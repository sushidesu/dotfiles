import { ReconnectHandler } from "./reconnect-handler"
import { sleep } from "../utils/sleep"
import { Got } from "got"

export const createKomedaReconnectHandler =
  (client: Got): ReconnectHandler =>
  async (generate_204_body) => {
    const next = generate_204_body.match(
      /<meta http-equiv='refresh' content='1; url=(http:\/\/www.gstatic.com\/generate_204&arubalp=.+)'>/
    )?.[1]
    if (next === null) {
      throw new Error(
        `ERROR: cannot find next location from body:\n${generate_204_body}`
      )
    }
    console.log("GET start page")
    await sleep(300)
    // http://www.gstatic.com/generate_204?cmd=redirect&arubalp=XXXXX
    await client.get(next, {
      followRedirect: true,
    })

    console.log("GET session")
    await sleep(300)
    const session = await client
      .get("https://api.wifi-cloud2.jp/session")
      .json<{ token: string }>()

    console.log("GET login")
    await sleep(300)
    await client.get("https://captive-portal.wifi-cloud.jp/login")

    console.log("GET auth")
    await sleep(300)
    const res = await client.get(
      `https://uaf.wifi-cloud.jp/click-through/auth/authorize?state=${session.token}&redirect_uri=https%3A%2F%2Fcaptive-portal.wifi-cloud.jp%2Fcallback&lang=ja`,
      {
        followRedirect: true,
      }
    )
    // get code
    const url = new URL(res.url)
    const code = url.searchParams.get("code")
    if (code === null) throw new Error("code is null")

    console.log("POST login")
    await sleep(300)
    const result = await client.post("https://api.wifi-cloud2.jp/auth", {
      json: {
        state: session.token,
        code,
        lang: "ja",
      },
    })

    return result.body
  }

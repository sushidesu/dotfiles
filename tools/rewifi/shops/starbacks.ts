import { ReconnectHandler } from "./reconnect-handler"
import { sleep } from "../utils/sleep"
import { Got } from "got"

export const createStarBacksReconnectHandler =
  (client: Got): ReconnectHandler =>
  async () => {
    console.log("GET agreement")
    await sleep(300)
    await client.get(
      "https://service.wi2.ne.jp/freewifi/starbucks/agreement.html"
    )

    console.log("POST login")
    await sleep(300)
    const result = await client.post(
      "https://service.wi2.ne.jp/wi2auth/xhr/login",
      {
        json: { login_method: "onetap", login_params: { agree: "1" } },
      }
    )

    return result.body
  }

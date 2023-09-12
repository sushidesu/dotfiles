import got from "got"
import { CookieJar } from "tough-cookie"
import { createStarBacksReconnectHandler } from "./shops/starbacks"
import { createKomedaReconnectHandler } from "./shops/komeda"

const main = async () => {
  const jar = new CookieJar()
  const client = got.extend({ cookieJar: jar })

  // session idとかが生成される
  console.log("GET generate")
  const generated = await client.get("http://www.gstatic.com/generate_204")

  // login済み場合は何も返ってこないので終了
  if (generated.body === "") {
    console.log("Already refreshed.")
    return
  }

  // shopの判定と呼び出し
  // <meta http-equiv='refresh' content='1; url=http://www.gstatic.com/generate_204&arubalp=xxxx'> があるなら、komeda
  const isKomeda = /url=http:\/\/www\.gstatic\.com\/generate_204&arubalp=/.test(
    generated.body
  )

  let result = ""
  if (isKomeda) {
    console.log("reconnect to komeda wifi")
    const komedaReconnectHandler = createKomedaReconnectHandler(client)
    result = await komedaReconnectHandler(generated.body)
  } else {
    console.log("reconnect to starbacks wifi")
    const starBacksReconnectHandler = createStarBacksReconnectHandler(client)
    result = await starBacksReconnectHandler(generated.body)
  }

  console.log("RESULT")
  console.log(result)
}

main()

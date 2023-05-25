import got from "got"
import { CookieJar } from "tough-cookie"
import { createStarBacksReconnectHandler } from "./shops/starbacks"

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
  console.log("reconnect to starbacks wifi")
  const starBacksReconnectHandler = createStarBacksReconnectHandler(client)
  const result = await starBacksReconnectHandler()

  console.log("RESULT")
  console.log(result)
}

main()

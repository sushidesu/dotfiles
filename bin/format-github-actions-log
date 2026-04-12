const filename = "validate-picker"
// only-01-test.txt
// only-0102-test.txt
// only-06-test.txt
// only-09-test.txt
// skip-all-test.txt

const ext = ".txt"

const file = await fs.readFile(filename + ext, "utf-8")
// 2022-09-12T07:16:19.8242257Z 
const re = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{7}Z\s/

const result = file
  .split("\n")
  .map(line => line.replace(re, ""))
  // .filter((_, i) => i < 10)
  .join("\n")

// echo(result)
await fs.writeFile(filename + "-fixed" + ext, result)

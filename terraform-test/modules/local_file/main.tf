# 指定された内容のファイルを作成する
resource "local_file" "helloworld" {
  content  = var.content
  filename = var.filename
}
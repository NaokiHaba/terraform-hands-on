module "local_file" {
  source   = "../modules/local_file"
  content  = "hello world!"
  filename = "hello.txt"
}
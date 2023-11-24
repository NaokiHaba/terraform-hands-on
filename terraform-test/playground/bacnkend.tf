terraform {
  backend "s3" {
    bucket  = "terraform-hands-on"                      # <-tfファイルを配置するS3バケットの名前を記載します。
    region  = "ap-northeast-1"                          # <-tfファイルを配置するS3バケットがいるリージョンを指定します。
    key     = "terraform-hands-on/terraform.tfstate"    # <- S3バケット内のterraform-hands-onディレクトリ配下でtfstateファイルを管理するよう指定します。
    profile = "terraform-hands-on"                      # <- playground/provider.tfで記載しているプロファイルを指定します。
  }
}
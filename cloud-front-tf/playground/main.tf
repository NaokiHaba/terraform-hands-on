module "s3" {
  source      = "../modules/s3"
  bucket_name = "cloud-front-test-bucket-naoki"
}

module "cloudfront" {
  source             = "../modules/cloudfront"
  bucket_id          = module.s3.bucket_id
  bucket_domain_name = module.s3.bucket_regional_domain_name
}

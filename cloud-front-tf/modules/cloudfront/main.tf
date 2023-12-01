# 静的なコンテンツ、動的なコンテンツ、オリジンサーバー(S3・EC2とか）からのコンテンツを配信するツール
resource "aws_cloudfront_distribution" "this" {

  origin {
    # ディストリビューションのオリジンとなるS3バケットのドメイン名
    domain_name = var.bucket_domain_name

    # ディストリビューションのオリジンとなるS3バケットのID
    origin_id = var.bucket_id

    # ディストリビューションからのみアクセスできるようにする(OAC)
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  # CloudFrontのディストリビューションを有効にするかどうか
  enabled = true

  # ディストリビューションのデフォルトのルートオブジェクト(ページ)を指定
  default_root_object = "index.html"

  # キャッシュの設定
  default_cache_behavior {
    # 許可されるHTTPメソッド
    allowed_methods = ["GET", "HEAD"]

    # キャッシュされるHTTPメソッド
    cached_methods = ["GET", "HEAD"]

    # デフォルトのキャッシュ動作が使用するオリジン
    # CloudFrontはユーザーからのリクエストをS3から直接取得し、必要に応じてエッジロケーションにキャッシュ
    target_origin_id = var.bucket_id

    # デフォルトキャッシュ動作において、リクエストの際にオリジンにどのような情報を転送するかを指定
    forwarded_values {
      # クエリ文字列を含むリクエストをオリジンに転送
      query_string = true

      # リクエストの際にCookieをオリジンに転送しない
      cookies {
        forward = "none"
      }
    }

    # ユーザーがHTTPでアクセスしようとした場合、CloudFrontはHTTPSへのリダイレクトを実行
    viewer_protocol_policy = "redirect-to-https"
    # Time to Liveを指定
    # 特定のデータやリソースがキャッシュされたり有効である期間
    min_ttl                = 60
    default_ttl            = 60
    max_ttl                = 60

    # CloudFrontは圧縮が有効な場合には適切にコンテンツを圧縮して配信
    compress = true
  }

  restrictions {
    geo_restriction {
      # 地理的な制限は設けられず、全世界のユーザーがアクセスできるようにする
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # CloudFrontが提供するデフォルトのSSL/TLS証明書を使用
    cloudfront_default_certificate = true
  }
}

# OACを作成する
resource "aws_cloudfront_origin_access_control" "this" {
  name = "terraform-spa-app-hands-on-naoki.s3.ap-northeast-1.amazonaws.com"

  # S3バケットのオリジンに関連付ける
  origin_access_control_origin_type = "s3"

  # すべてのリクエストに署名が必要
  signing_behavior = "always"

  # AWS Signature Version 4を使用
  signing_protocol = "sigv4"
}
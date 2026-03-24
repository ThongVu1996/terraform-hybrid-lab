provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

provider "tailscale" {
  oauth_client_id     = var.ts_oauth_client_id
  oauth_client_secret = var.ts_oauth_client_secret
}

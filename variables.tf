#下記はリージョンの設定です。変更したい人は変更してください。
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

# アマゾンlinux の無料枠のイメージを使います。
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-0b898040803850657"
    "us-west-2" = "ami-0b898040803850657"
  }
}
#作成したキーの名前は覚えておいてください
variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

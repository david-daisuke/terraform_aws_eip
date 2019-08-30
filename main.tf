# AWS　IAMユーザのアクセスキーとシークレットを入れてください
provider "aws" {
  access_key = "アクセスキーをいれてください"
  secret_key = "シークレットキーを入れてください"
  region = "${var.aws_region}"
}

resource "aws_eip" "default" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

# デフォルトのセキュリティグループを作成します
resource "aws_security_group" "default" {
  name        = "eip_example"
  description = "Used in the terraform"

  # SSH を許可
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP を許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アウトバウンドはすべて許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  instance_type = "t1.micro"

  # インスタンスに使うリージョンとイメージをvariables.tfから引っ張ってきます
  ami = "${lookup(var.aws_amis, var.aws_region)}"


  # https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:
  # 上記のURLからキーペアを作成してください。terraform apply　を打鍵したときにキーペアの名前を求められます
  key_name = "${var.key_name}"

  # セキュリティグループの設定
  security_groups = ["${aws_security_group.default.name}"]

  #インスタンスを作成したら、userdata.shを起動して、nginx ダウンロードしてインストールしますこのときのポート番号は80
  user_data = "${file("userdata.sh")}"

  #Instance tags
  tags = {
    Name = "eip-example"
  }
}

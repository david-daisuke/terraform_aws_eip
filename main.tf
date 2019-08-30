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

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "eip_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  instance_type = "t1.micro"

  # Lookup the correct AMI based on the region
  # we specified　　
  ami = "${lookup(var.aws_amis, var.aws_region)}"


  # https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:
  # 上記のURLからキーペアを作成してください。terraform apply　を打鍵したときにキーペアの名前を求められます
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  #インスタンスを作成したら、nginx ダウンロードしてインストールしますこのときのポート番号は80
  user_data = "${file("userdata.sh")}"

  #Instance tags
  tags = {
    Name = "eip-example"
  }
}

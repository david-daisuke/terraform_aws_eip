output "address" {
  value = "${aws_instance.web.private_ip}"
}
# awsのプライベートアドレスをapply後に出力します
output "elasticip" {
  value = "${aws_eip.default.public_ip}"
}
#　awsのEIPをapply後に出力します。

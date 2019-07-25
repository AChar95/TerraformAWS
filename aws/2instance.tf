resource "aws_instance" "api" {
	# ubuntu 18.04
	ami = "ami-0c30afcb7ab02233d"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.default.id}"
	vpc_security_group_ids = ["${aws_security_group.api.id}"]
	associate_public_ip_address = true
	key_name = "default-key-pair"
	provisioner "remote-exec" {
		connection {
			type = "ssh"
			host = "${self.public_ip}"
			user = "ubuntu"
			private_key = "${file("~/.ssh/id_rsa")}"
		}
		inline = [
			"sudo apt update",
			"curl https://get.docker.com | sudo bash",
			"sudo docker run -d --name api -e MONGO_HOST=${aws_instance.mongo.private_ip} -p 8080:8080 achar95/api-config"
		]
	}
	tags = {
		Name = "API"
	}
}

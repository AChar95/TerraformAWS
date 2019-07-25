resource "aws_instance" "mongo" {
	# ubuntu 18.04
	ami = "ami-0c30afcb7ab02233d"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.default.id}"
	vpc_security_group_ids = ["${aws_security_group.default.id}"]
	associate_public_ip_address = true
	private_ip = "${var.mongo_ip}"
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
			"sudo apt install -y docker.io",
			"sudo docker run -d -p 27017:27017 --name mongo mongo:latest"
		]
	}
	tags = {
		Name = "mongo"
	}
}

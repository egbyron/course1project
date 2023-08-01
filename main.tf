provider "aws" {
   region     = "us-east-1"
   access_key = "<aws access key here>"
   secret_key = "<aws secret key here>"
   token = "<aws token here if using>"
}

resource "aws_instance" "ec2_example" {

    ami = "ami-0fea48fe9492d2c89"  
    instance_type = "t3.micro" 
    key_name= "aws_key"
    vpc_security_group_ids = [aws_security_group.main.id]

}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 8080]
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

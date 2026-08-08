#Importing existed public key (or u can chnge in the ec2, ~/.ssh/authrized_keys)
resource "aws_key_pair" "deployer" {
  key_name   = "jenkins"
  public_key = file("test.pub")  //inporting already existed key pairs
}


#1 jenkins-server
resource "aws_instance" "jenkins_server" {
  ami = data.aws_ami.rhel.id
  key_name = aws_key_pair.deployer.key_name     #id or key_name: attribute
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.sg_id
  root_block_device {
        delete_on_termination = true
        volume_type = "gp3"
        volume_size = 20
  }
  user_data = file("jenkins-master.sh")
  instance_type = var.instance_type.master
  #  instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     max_price = 0.0453  # 0.0031
  #   }
  # }
  tags = merge(
    var.common_tags,
    {
      Name = var.jenkins_server
    }
  )
}

# #2 jenkins-Agent
# resource "aws_instance" "jenkins_agent" {
#   ami = data.aws_ami.ubuntu.id
#   key_name = aws_key_pair.deployer.key_name     #id or key_name: attribute
#   subnet_id     = var.subnet_id
#   vpc_security_group_ids = var.sg_id
#   user_data = file("jenkins-agent.sh")

#   #EBS Volume
#   root_block_device {
#         delete_on_termination = true
#         volume_type = "gp3"
#         volume_size = 25
#   }
  
#   #Spot Instance
#   instance_type = var.instance_type.agent
#   #  instance_market_options {
#   #   market_type = "spot"
#   #   spot_options {
#   #     max_price = 0.0453
#   #   }
#   # }
#   tags = merge(
#     var.common_tags,
#     {
#      Name = var.jenkins_agent
#     }
#   )
# }


#Records NOT WORKING
# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   # version = "~> 3.0"

#   zone_name = var.domain_name

#   records = [
#     {
#       name    = "jenkins"
#       type    = "A"
#       ttl     = 1 
#       records = [aws_instance.jenkins_server.public_ip]   #publicip -- jenkins_ip:8080 --jenkins opns port 8080
#       allow_overwrite = true
#     },
#     {
#       name    = "jenkins-agent"
#       type    = "A"
#       ttl     = 1
#       records = [aws_instance.jenkins_agent.private_ip] #this is agent
#       allow_overwrite = true
#     }
#   ]
# }

resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id

  name    = "jenkins.${var.domain_name}"  #jenkins.telugudevops.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins_server.public_ip]
}

# resource "aws_route53_record" "jenkins_agent" {
#   zone_id = var.zone_id

#   name    = "jenkins-agent.${var.domain_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.jenkins_agent.private_ip]
# }
output "private_ec2_instances" {
  value = [for inst in aws_instance.test_priv_ec2_inst : 
            {"name" = inst.id, 
             "public_ip" = inst.public_ip,
             "private_ip" = inst.private_ip}
          ]
}

output "public_ec2_instances" {
  value = [for inst in aws_instance.test_pub_ec2_inst : 
            {"name" = inst.id, 
             "public_ip" = inst.public_ip,
             "private_ip" = inst.private_ip,
             "primary_network_interface" = inst.primary_network_interface_id}
          ]
}

output "nat_gateway_ips"{
  value = {"public_ip" = aws_nat_gateway.test_nat_gw.public_ip, "private_ip" = aws_nat_gateway.test_nat_gw.private_ip}
}

output "public_instance_elastic_ips" {
  value = [for eip in aws_eip.test_eip : 
            {"name"       = eip.id, 
             "public_ip"  = eip.public_ip,
             "private_ip" = eip.private_ip}
          ]
}

output "public_application_load_balancer" {
  value = aws_lb.test_pub_alb
}
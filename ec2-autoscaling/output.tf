output "load_balancer" {
  value = aws_lb.test_alb
}

output "nat_gateway_ips"{
  value = { "public_ip"   = aws_nat_gateway.test_nat_gw.public_ip,
            "private_ip"  = aws_nat_gateway.test_nat_gw.private_ip
          }
}

output "elastic_ip" {
  value = { "name"       = aws_eip.test_eip.id, 
            "public_ip"  = aws_eip.test_eip.public_ip,
            "private_ip" = aws_eip.test_eip.private_ip 
          }
}

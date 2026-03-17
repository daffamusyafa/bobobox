output "web_server_public_ip" {
  description = "Alamat IP Publik VM"
  value       = aws_instance.web_server.public_ip
}

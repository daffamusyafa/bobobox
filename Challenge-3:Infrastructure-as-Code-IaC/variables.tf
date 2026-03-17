variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipe instance EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID untuk Ubuntu 22.04 LTS"
  # Pastikan AMI ID ini sesuai dengan region yang dipilih
  default     = "ami-053b0d53c279acc90" 
}

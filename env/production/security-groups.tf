// Allows all internal traffic
resource "aws_security_group" "allow_traffic" {
  name        = "Allow Internal and outbound traffic"
  description = "Security Group for internal access and outbound connections"
  vpc_id      = module.wp-vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Name"        = "Allow Internal and outbound traffic"
  }
}


// Allows all HTTP and HTTPS traffic from anywhere
resource "aws_security_group" "allow_all_http_https" {
  name        = "Allow all HTTP HTTPS"
  description = "Security Group which allows HTTP and HTTPS traffic from anywhere"
  vpc_id      = module.wp-vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Name"        = "Allow all HTTP HTTPS"
  }
}

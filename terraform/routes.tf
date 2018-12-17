// Configure private subnet network routing through nat gateway
resource "google_compute_route" "private_subnet_route" {
  name        = "private-subnet-internet-access"
  dest_range  = "0.0.0.0/0"
  network     = "${google_compute_network.vpc_lms.self_link}"
  next_hop_instance = "${google_compute_instance.lms_nat_gateway.self_link}"
  priority    = 800
  tags = ["private"]
}
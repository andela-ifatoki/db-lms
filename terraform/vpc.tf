// Configure project networks
resource "google_compute_network" "vpc_lms" {
  name                    = "vpc-lms-db"
  description             = "Virtual Private Cloud for the project"
  auto_create_subnetworks = "false"  
}
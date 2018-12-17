// Configure project subnets
resource "google_compute_subnetwork" "subnet_private" {
  name          = "subnet-private-lms"
  description   = "Private subnet for project"
  ip_cidr_range = "${lookup(var.subnet_cidrs, "private")}"
  network       = "${google_compute_network.vpc_lms.self_link}"
}

resource "google_compute_subnetwork" "subnet_public" {
  name          = "subnet-public-lms"
  description   = "Public subnet for project"
  ip_cidr_range = "${lookup(var.subnet_cidrs, "public")}"
  network       = "${google_compute_network.vpc_lms.self_link}"
}
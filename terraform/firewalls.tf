resource "google_compute_firewall" "firewall_allow_private_ssh" {
  name          = "allow-ssh-private"
  description   = "Allow SSH access across the firewall into the Private Subnet."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_tags = ["public", "private"]
  target_tags   = ["private"]
}

resource "google_compute_firewall" "firewall_allow_public_ssh" {
  name          = "allow-ssh-public"
  description   = "Allow SSH access across the firewall into the Public Subnet."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_firewall" "firewall_allow_postgresql" {
  name          = "allow-postgresql"
  description   = "Allow connections to postgresql access across the firewall."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["5432"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["postgresql-server"]
}

resource "google_compute_firewall" "firewall_allow_http" {
  name          = "allow-http"
  description   = "Allow HTTP access across the firewall."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["80", "7000", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "firewall_allow_https" {
  name          = "allow-https"
  description   = "Allow HTTPS access across the firewall."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "firewall_allow_icmp" {
  name          = "allow-icmp"
  description   = "Allow ICMP access across the firewall."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["private", "public"]
}

resource "google_compute_firewall" "firewall_allow_internal" {
  name          = "allow-internal"
  description   = "Allow internal traffic on the network."
  network       = "${google_compute_network.vpc_lms.self_link}"
  allow {
    protocol    = "tcp"
    ports       = ["0-65535"]
  }

  allow {
    protocol    = "udp"
    ports       = ["0-65535"]
  }

  allow {
    protocol    = "icmp"
  }
  source_tags = ["public", "private"]
  target_tags   = ["private", "public"]
}
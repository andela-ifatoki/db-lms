resource "google_compute_address" "ip_st_master" {
  name = "ip-internal-master"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private.self_link}"
  address = "${lookup(var.static_ips, "ip_master")}"
}

resource "google_compute_address" "ip_st_slave_1" {
  name = "ip-internal-slave-1"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private.self_link}"
  address = "${lookup(var.static_ips, "ip_slave_1")}"
}

resource "google_compute_address" "ip_st_slave_2" {
  name = "ip-internal-slave-2"
  region = "${var.region}"
  address_type = "INTERNAL"
  subnetwork = "${google_compute_subnetwork.subnet_private.self_link}"
  address = "${lookup(var.static_ips, "ip_slave_2")}"
}

resource "google_compute_address" "ip_ext_nat" {
  name = "ip-ext-nat"
  region = "${var.region}"
}
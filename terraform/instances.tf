resource "google_compute_instance" "lms_db_master" {
  name         = "instance-lms-master"
  description  = "Master server"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "master")}"
  boot_disk {
    initialize_params {
      image = "${var.machine_image}"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private.self_link}"
    network_ip = "${google_compute_address.ip_st_master.address}"
  }
  tags = ["postgresql-server", "private", "http-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lms_db_slave_1" {
  name         = "instance-lms-slave-1"
  description  = "Slave Server 1"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "slave")}"
  boot_disk {
    initialize_params {
      image = "${var.machine_image}"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private.self_link}"
    network_ip = "${google_compute_address.ip_st_slave_1.address}"
  }
  tags = ["postgresql-server", "private", "http-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lms_db_slave_2" {
  name         = "instance-lms-slave-2"
  description  = "Slave server 2"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "slave")}"
  boot_disk {
    initialize_params {
      image = "${var.machine_image}"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_private.self_link}"
    network_ip = "${google_compute_address.ip_st_slave_2.address}"
  }
  tags = ["postgresql-server", "private", "http-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "lms_nat_gateway" {
  name         = "instance-lms-nat"
  description  = "NAT Gateway server"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  metadata_startup_script = "${lookup(var.startup_scripts, "nat")}"
  boot_disk {
    initialize_params {
      image = "${var.machine_image}"
    }
  }
  network_interface {
    subnetwork  = "${google_compute_subnetwork.subnet_public.self_link}"
    access_config {
      nat_ip = "${google_compute_address.ip_ext_nat.address}"
    }
  }
  can_ip_forward = "true"
  tags = ["nat", "public", "http-server", "https-server", "postgresql-server"]
  service_account {
    scopes = ["cloud-platform"]
  }
}
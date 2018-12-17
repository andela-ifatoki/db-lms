provider "google" {
  credentials = "${file("gcloud-key.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
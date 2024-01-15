terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  zone = "ru-central1-a"
}

provider "yandex" {
  token = "${file("./token")}"
  cloud_id = "${file("./cloudid")}"
  folder_id = "b1g6k2i3lobiesnh55af"
  zone = local.zone
}
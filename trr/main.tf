variable hostname_blocks {}
variable name_bloks {}
variable images_blocks {}
variable cores_blocks {}
variable memory_blocks {}
variable core_fraction_blocks {}

variable count_vm {}

#---- vms --------------
resource "yandex_compute_instance" "vm" {

  count = "${var.count_vm}"

  name = "${var.name_bloks[count.index]}" 
  hostname = "${var.hostname_blocks[count.index]}" 

  allow_stopping_for_update = true
  platform_id               = "standard-v1" 
  #zone                      = local.zone

  resources {
    core_fraction = "${var.core_fraction_blocks[count.index]}" 
    cores  = "${var.cores_blocks[count.index]}" 
    memory = "${var.memory_blocks[count.index]}"  
  }

  boot_disk {
    initialize_params {
      image_id = "${var.images_blocks[count.index]}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}" 
    nat       = true
  }

  scheduling_policy {
  preemptible = true
   }

 metadata = {
    user-data = "${file("./meta.yaml")}" 
  }


  provisioner "file" {
    source      = "docker-compose.yaml"
    destination = "/home/dmil/docker-compose.yaml"
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/inst-gitlab.sh",
          "cd ~",
          "sudo dpkg -i \"gitlab-ee_13.6.3-ee.0_amd64_bionic.deb\""
#          "~/conf-gitlab.sh"
    ]
  }

    connection {
      type        = "ssh"
      user        = "dmil"
      private_key = "${file("id_ed25519")}"
      host = self.network_interface[0].nat_ip_address
    }
 
}





locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

variable "password" {
  type = string
  default = "password"
}

source "googlecompute" "puppet-pe-base" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "puppet-pe-base"
  instance_name       = "puppet-pe-base"
  machine_type        = "n2d-standard-2"
  project_id          = "kmo-instruqt"
  image_family        = "puppet-pe-base"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  zone                = "us-west1-b"
}

build {
  sources = ["source.googlecompute.puppet-pe-base"]

  provisioner "file" {
    destination = "/tmp/resources"
    source      = "./resources"
  }

  provisioner "shell" {
    execute_command  = "echo '${var.password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script           = "./bootstrap-scripts/bootstrap.sh"
    valid_exit_codes = [0, 2, 4, 6]
  }

}

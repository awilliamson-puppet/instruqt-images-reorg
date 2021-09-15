variable "lab_id" {
    type = string
    default = "lab-3-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "googlecompute" "puppet-pe-base" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "puppet-pe-base-${var.lab_id}"
  instance_name       = "puppet-pe-base-${var.lab_id}"
  machine_type        = "n2d-standard-2"
  project_id          = "kmo-instruqt"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  zone                = "us-west1-b"
}

source "googlecompute" "nixagent1" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "nixagent1-${var.lab_id}"
  instance_name       = "nixagent1-${var.lab_id}"
  machine_type        = "n2d-standard-2"
  project_id          = "kmo-instruqt"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  zone                = "us-west1-b"
}

source "googlecompute" "nixagent2" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "nixagent2-${var.lab_id}"
  instance_name       = "nixagent2-${var.lab_id}"
  machine_type        = "n2d-standard-2"
  project_id          = "kmo-instruqt"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  zone                = "us-west1-b"
}

source "googlecompute" "winagent" {
  image_labels = {
    created = "${local.timestamp}"
  }
  communicator      = "winrm"
  disk_size         = 100
  disk_type         = "pd-ssd"
  image_description = "Windows Server instance for use within Instruqt platform"
  image_name        = "winagent-${var.lab_id}"
  instance_name     = "winagent-${var.lab_id}"
  machine_type      = "n1-standard-2"
  metadata = {
    windows-startup-script-cmd  = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
  network             = "default"
  on_host_maintenance = "TERMINATE"
  project_id          = "kmo-instruqt"
  region              = "us-west1"
  zone                = "us-west1-a"
  source_image_family = "windows-base"
  tags                = ["allow-winrm-ingress-to-packer"]
  winrm_insecure      = true
  winrm_use_ssl       = true
  winrm_username      = "packer_user"
}

build {
    sources = ["source.googlecompute.puppet-pe-base"]

    provisioner "file" {
      destination = "/tmp/resources"
      source      = "./resources"
  }

    provisioner "shell" {
      scripts = [
          "./setup-steps/bootstrap.sh"
      ]
      skip_clean = true
    }
}

build {
    sources = ["source.googlecompute.nixagent1"]

    provisioner "shell" {
      scripts = [
          "./setup-steps/nixagent/SetupFacts.sh",
          "./setup-steps/nixagent/OptionBasedPackageInstaller.sh"
          ]
      
      environment_vars = [
        "OPTIONVAR=httpd"
        ]
      skip_clean = true

    }
}

build {
    sources = ["source.googlecompute.nixagent2"]

    provisioner "shell" {
      scripts = [
          "./setup-steps/nixagent/SetupFacts.sh",
          "./setup-steps/nixagent/OptionBasedPackageInstaller.sh"]
      
      environment_vars = ["OPTIONVAR=nginx"]
      skip_clean = true

    }
}

build {
    sources = ["source.googlecompute.winagent"]

    provisioner "powershell" {
        scripts = [
          "./setup-steps/windows/Install-IIS.ps1",
          "./setup-steps/windows/Install-PuppetAgent.ps1"]
        
        skip_clean = true
    }
}
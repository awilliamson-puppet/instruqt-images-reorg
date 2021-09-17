# A variable to store the lab id for use in various name config options where machine names are generated 
# Can be overriden on the command line during building

variable "lab_id" {
    type = string
    default = "lab-3-1"
}

# A default root password used during provisioning to execute .sh scripts as root
variable "password" {
  type = string
  default = "password"
}

# a tag for GCP image metadata to tag the resulting image with the current build timestamp
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# A source is a reusable piece of meta data that contains basic info about the VM being built
# these can be named anything, and control the output of log lines during build
# the convention is to name them by provider and imagename
source "googlecompute" "puppet-pe" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "puppet-${var.lab_id}"
  instance_name       = "puppet-${var.lab_id}"
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

# In this source the windows image family is set to inherit from the windows-base image family to allow inheritence
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

# a build block consumes source block meta-data as defined in the sources array
# build blocks also setup the way changes are made to the resulting VM image
# these change engines can be scripts, uploading files, or inline commands
build {

    sources = ["source.googlecompute.puppet-pe"]

    # This provisioner uploades the Base-Setup.sh script to the VM /tmp directory and runs it with sudo -E -S
    # The script path is relative to the .pkr.hcl file used during this build
    provisioner "shell" {
      execute_command  = "echo '${var.password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
      scripts = [
          "./Base-Setup.sh"
      ]
      skip_clean = true
    }
}

build {
    sources = ["source.googlecompute.nixagent1"]

    provisioner "shell" {
      execute_command  = "echo '${var.password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
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
      execute_command  = "echo '${var.password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
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
    provisioner "file" {
    destination = "C:/ProgramData/PuppetLabs/puppet/etc/csr_attributes.yaml"
    source = "./setup-steps/windows/csr_attributes.yaml"
  }
}
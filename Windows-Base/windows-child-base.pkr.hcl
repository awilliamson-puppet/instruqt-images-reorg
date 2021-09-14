variable "image_name" {
  type = string
  default = "windows-child-image"
}



source "googlecompute" "windows-child" {
  communicator      = "winrm"
  disk_size         = 100
  disk_type         = "pd-ssd"
  image_description = "Windows Server instance for use within Instruqt platform"
  image_name        = var.image_name
  image_family      = "windows-child"
  instance_name     = "windows-child-image"
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
  sources = ["source.googlecompute.windows-child"]

  provisioner "powershell" {
    elevated_user     = "SYSTEM"
    elevated_password = ""
    inline = ["Get-ChildItem C:\\Temp -Recurse"]

  }

  provisioner "windows-restart" {
    restart_timeout = "60m"
  }

}
terraform {


  cloud {
    organization = "ManCorpInc"
    hostname     = "app.terraform.io"
    workspaces {
      project = "local_application"
      name    = "local_application_default"
    }
  }
}

resource "null_resource" "resource_1" {
  provisioner "local-exec" {
    command = "echo 'Hello, World!'"
  }
}

output "output_1" {
  value = timestamp()
}

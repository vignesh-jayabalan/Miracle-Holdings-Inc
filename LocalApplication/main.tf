terraform {

  backend "local" {
    path = "terraform.tfstate"
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

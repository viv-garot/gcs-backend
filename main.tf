terraform {
  backend "gcs" {
    bucket = "YOUR-BUCKET-NAME" # Update with your bucket name
    prefix = "terraform/state"
  }
}

resource "null_resource" "null" {

  provisioner "local-exec" {
    command = "echo null_resource"
  }
}

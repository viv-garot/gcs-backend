# Gcs backend

## Description
Learn how to store terraform state file in the GCS (Google Cloud Storage) backend

## Pre-requirements

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
* [Terraform cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [gcloud SDK](https://cloud.google.com/sdk/docs/quickstart)

## How to use this repo

- Clone
- Create GCP project and GCS bucket
- Edit the main.tf file (update the bucket name)
- Run
- Cleanup

---

### Clone the repo

```
git clone https://github.com/viv-garot/gcs-backend/
```

### Change directory

```
cd https://github.com/viv-garot/gcs-backend/
```

### Create a bucket in GCS

- Go to [GCP console](https://console.cloud.google.com/)
- Create a new project 

![image](https://user-images.githubusercontent.com/85481359/130591121-2da400ae-c09e-49be-8bf3-feab6071f748.png)

![image](https://user-images.githubusercontent.com/85481359/130591899-8afedfe9-820f-4646-8292-bb47f0d83144.png)

- In GCP Dashboard, go to Cloud Storage

![image](https://user-images.githubusercontent.com/85481359/130592476-12857965-968a-4212-a4fb-326fcb7675dc.png)

- And create a new bucket

![image](https://user-images.githubusercontent.com/85481359/130599120-22195979-eee9-4419-a601-79182155d117.png)
![image](https://user-images.githubusercontent.com/85481359/130599276-5e70947a-e680-493f-8aff-91517c7380d9.png)


- Bucket configuration

![image](https://user-images.githubusercontent.com/85481359/130593219-e5128fd9-01d3-4e03-becc-8450da5a4150.png)


Alternatively you can create the [project](https://cloud.google.com/sdk/gcloud/reference/projects/create) and [bucket](https://cloud.google.com/storage/docs/creating-buckets) via glcoud and gsutil cli



### Run

* Authenticate with GCP SDK.
On your local terminal, run 

```
gcloud auth application-default login
```

* This will redirect you to your web browser. Accept the access authorization

![image](https://user-images.githubusercontent.com/85481359/130593811-e7a58e1c-54f2-4541-a5bc-42a48df658c5.png)


_sample_ :

```
gcloud auth application-default login
Your browser has been opened to visit:

    https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8085%2F&scope=openid+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&state=Ms4PGEac4MZ9RDP4diADy4UUtw5X3y&access_type=offline&code_challenge=_eF7loKpfmgVDN7oW1DdSetTZNbWkAlxI1EDOG_JiPA&code_challenge_method=S256


Credentials saved to file: [/Users/viviengarot/.config/gcloud/application_default_credentials.json]

These credentials will be used by any library that requests Application Default Credentials (ADC).

Quota project "vivien-gcp" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.


Updates are available for some Cloud SDK components.  To install them,
please run:
  $ gcloud components update



To take a quick anonymous survey, run:
  $ gcloud survey
```

* Replace the bucket name in the main.tf file with the bucket created earlier

_sample_

```
cat main.tf
terraform {
  backend "gcs" {
    bucket = "vivien-tf-gcs" # Update with your bucket name
    prefix = "terraform/state"
  }
}

resource "null_resource" "null" {

  provisioner "local-exec" {
    command = "echo null_resource"
  }
}
```

* Init:

```
terraform init
```

_sample_:

```
terraform init

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Apply:

```
terraform apply
```

_sample_:

```
terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # null_resource.null will be created
  + resource "null_resource" "null" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.null: Creating...
null_resource.null: Provisioning with 'local-exec'...
null_resource.null (local-exec): Executing: ["/bin/sh" "-c" "echo null_resource"]
null_resource.null (local-exec): null_resource
null_resource.null: Creation complete after 0s [id=5785584152328100649]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

* Confirm the tfstate file exist in the created bucket

```
gsutil ls -lr gs://<YOUR-BUCKET-NAME>/terraform/state
```

_sample_:

```
gsutil ls -lr gs://vivien-tf-gcs/terraform/state
gs://vivien-tf-gcs/terraform/state/:
       579  2021-08-24T09:43:48Z  gs://vivien-tf-gcs/terraform/state/default.tfstate
TOTAL: 1 objects, 579 bytes (579 B)
```

### Cleanup

```
terraform destroy
```

_sample_:

```
terraform destroy
null_resource.null: Refreshing state... [id=5785584152328100649]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.null will be destroyed
  - resource "null_resource" "null" {
      - id = "5785584152328100649" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.null: Destroying... [id=5785584152328100649]
null_resource.null: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```

* Delete the GCS bucket

```
gsutil rm -r gs://YOUR-BUCKET-NAME
```

_sample_

```
gsutil rm -r gs://vivien-tf-gcs
Removing gs://vivien-tf-gcs/terraform/state/default.tfstate#1629798864815614...
/ [1 objects]
Operation completed over 1 objects.
Removing gs://vivien-tf-gcs/...
```

* Delete the GCP project

```
gcloud projects delete YOUR-PROJECT-NAME
```

_sample_

```
gcloud projects delete vivien-gcs
Your project will be deleted.

Do you want to continue (Y/n)?  y

Deleted [https://cloudresourcemanager.googleapis.com/v1/projects/vivien-gcs].

You can undo this operation for a limited period by running the command below.
    $ gcloud projects undelete vivien-gcs

See https://cloud.google.com/resource-manager/docs/creating-managing-projects for information on shutting down projects.
```

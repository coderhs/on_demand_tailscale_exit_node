# On Demand Tailscale Exit Node

Ever wanted to launch an exit node in a different geography for a short duration to get your work done, and then
terminate it? Now you can using Terraform, Tailscale and a cloud provider (Digital Ocean in the configuration)

## What is it?

This is a terraform file that I use to launch a server in digital ocean to act as an exit node, while I work for
clients who have geographic restrictions on there site or services. Once the work is done, I destroy the droplet
so as to not get charged any more.

Since we are using terraform, you customize the same script to any cloud provider available.

## How to get started.

Make sure you have terraform installed.

create the `terraform.tfvars`.

```sh
cp terraform.rfvars.example terraform.rfvars
```

Place your token and credentials in the file.

```sh
terraform init
terraform apply
```

Thats it, your exit note should be online and available for you to pick.

Once you are done with your work, you can destroy the droplet by running the bellow command

```sh
terraform destroy
```

## How to get started

In detail: https://hsps.in/post/setup-on-demand-tailscale-exit-node-using-terraform-and-digital-ocean/

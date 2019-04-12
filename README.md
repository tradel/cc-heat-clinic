Consul Connect Heat Clinic Demo v2
==================================

This is a ground-up rewrite of the original [Heat Clinic] demo for [Consul Connect]. Where the original demo used [Vagrant] to spin up a set of virtual machines on your laptop, this version is designed to be run in the cloud. Currently it only supports GCP, but AWS and Azure will be added eventually. 

The demo uses Packer and Terraform to create the infrastructure and launch the applications.

## Prerequisites

 * Install Packer and Terraform binaries

## Installing in GCP (Google Cloud)

 1. Create a new project to house your demo. In this example, I call my project `heat-clinic-demo`.

 2. Create a service account that has the "Compute Instance Admin (v1)" and "Compute Security Admin" roles. Download the account credentials as a JSON file. This can be done through the UI or through the `gcloud` command line tool, e.g.:

        project="heat-clinic-demo"
        account="my-service-account"

        gcloud iam service-accounts create ${account} \
            --display-name "Heat Clinic Service Account" \
            --project ${project}

        for role in iam.serviceAccountUser compute.instanceAdmin.v1 compute.networkAdmin compute.securityAdmin
        do
            gcloud projects add-iam-policy-binding ${project} \
                --member serviceAccount:${account}@${project}.iam.gserviceaccount.com \
                --role roles/${role}
        done

        gcloud iam service-accounts keys create ${account}-key.json \
            --iam-account ${account}@${project}.iam.gserviceaccount.com

 3. Add the credentials to your shell environment so the tools can find them.

        export GOOGLE_APPLICATION_CREDENTIALS=my-service-account-key.json

 4. Use Packer to build a Debian image that contains all of the needed software (Consul, Vault, Consul Template, MySQL, Broadleaf Commerce, and Nginx).

        packer build -only=googlecompute packer.json 

   If successful, you'll see output like this:

        Build 'googlecompute' finished.

        ==> Builds finished. The artifacts of successful builds are:
        --> googlecompute: A disk image was created: heat-clinic-1555102420

 5. Use Terraform to create the GCE instances, firewall rules, and Consul Connect intentions.

        terraform init
        terraform plan
        terraform apply

    If successful, the output will end with something similar to this:

        Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

 6. You can see the public IP addresses and URL's for your demo by inspecting the Terraform output:

        $ terraform output -module=gcp 

        admin_url = https://35.196.54.195/admin/
        app_url = https://35.196.54.195/
        consul_ip_address = 35.227.37.35
        consul_url = http://35.227.37.35:8500/
        nginx_ip_address = 35.196.54.195
        vault_root_token = s.Kyg0k9Ct8N2UAruMwKZUXiFq
        vault_unseal_key = +ygAT/N1/cDkKpIBoyVBfHhmxg+EIQFvh0WQzBTWSQw=

**Note:** It may take a minute or two for the site to become available, as the JVM needs to create all the database objects.


## Future Enhancements

 - [ ] Implement Gossip encryption
 - [ ] Implement TLS on Consul and Vault
 - [ ] Secure traffic between nodes (except for Connect proxies)
 - [ ] Support AWS as a deployment option


[heat clinic]: https://github.com/tradel/consul-connect-demo
[consul connect]: https://www.consul.io/docs/connect/index.html
[vagrant]: https://www.vagrantup.com/

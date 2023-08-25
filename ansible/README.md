# RH-SSO Installation using Ansible playbook.
This installation process is based on the deployment of RH-SSO on an local or external machine.
At this moment it is needed to download the RH-SSO installation zip file manually. 
Deployment on Openshift is not included.

## Configuration
1. Playbook: **./install_rhsso.yml**
2. Inventory: **./inventory**
3. Configuration: **./ansible.cfg**

## Prerequiites
1. Download **Red Hat Single Sign-On 7.6.0 Server** installation file from this link: [https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=104539].
2. Move the downloaded file to [./files] folder in this project.

## Instructions
1. Run this command:

$ ansible-playbook install_rhsso.yml --ask-become-pass

Where:
- --ask-become-pass: request password for host's root user


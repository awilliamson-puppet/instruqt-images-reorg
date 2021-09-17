# Packer Image Repo Guide
There are two main components to the packer image repo:
- Base Image packer files and setup scripts
- Lab Image packer files and setup scripts

Base images are underlying image recipes build to allow inheritence of a set of common configuration states desired in all VMs used during instruqt lab building; e.g. always having a standard user account or having WinRM enabled on all Windows images. Base image building config is stored in the *-Base named directories.

Lab images provide a packer file and accompanying resources to build a set of images purpose tailored to meet the requirements of a given lab, e.g. a lab that demonstrates package data collection will come with puppet agents pre-installed and various packages deployed while a lab demonstrating puppet agent installation will come with very little pre-configuration done to the VM images. Each lab build recipe is stored in a directory structure matching the lab name. 

## Building a new lab
To create a new lab recipe simply create a new correctly named sub-directory under the ./LabBuildSteps directory. Create a new lab-[Major]-[Minor].pkr.hcl file and accompanying sub-directory structure to build out the requirements for your lab. Check the ./LabBuildSteps/pe-templatel-lab for a sample directory structure and commented .pkr.hcl file.

## PE Main server
The PE main server is currently not setup to use inheritence and has a full install performed during each lab build. This stems from the PE install using the hostname to configure its multitudinous service routes. A future enhancement would be to engineer a way to change the hostname during a build so that the PE server could inherit from a base image and create differentials for each lab build with a different hostname and cert. 
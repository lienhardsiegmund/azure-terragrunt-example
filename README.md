# Terragrunt examples
Simple example to explain configuation and provider handling with Terragrunt.

Installation: See https://terragrunt.gruntwork.io/

## Terragrunt Versions
terraform_v1/  
terraform_v2/


### plan & deploy a module
```
cd /env/dev/test2
terragrunt plan
terragrunt apply

with plan file:
terragrunt plan -out $(pwd)/plan.tfplan
terragrunt apply -input=false $(pwd)/plan.tfplan
```
### plan & deploy multiple modules
```
cd /env/dev/
terragrunt run-all plan 
terragrunt run-all apply
```
### apply with autoapprove
```
terragrunt --terragrunt-non-interactive apply -auto-approve -input=false plan.tfplan
```


## Plain Terraform Version
terraform_v3/

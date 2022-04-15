# terraform

https://terraform101.inflearn.devopsart.dev/cont/vpc-intro/


## Terraform의 tfstate를 원격으로 관리하기
https://blog.outsider.ne.kr/1290

## terraform version issue
terraform current version
```
terraform version
Terraform v1.1.2
on darwin_amd64
+ provider registry.terraform.io/hashicorp/aws v4.9.0

Your version of Terraform is out of date! The latest version
is 1.1.8. You can update by downloading from https://www.terraform.io/downloads.html
```

`terraform init -upgrade`

lock_table unsupported error 해결 https://blog.outsider.ne.kr/1516
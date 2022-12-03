## Common
Tạo main.tf rồi khởi chạy
```
terraform init
```

Workspace sau khi chạy sẽ như này
```
.
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           └── hashicorp
│               └── aws
│                   └── 3.68.0
│                       └── linux_amd64
│                           └── terraform-provider-aws_v3.68.0_x5
├── .terraform.lock.hcl
└── main.tf
```

Review các resource trước khi tạo ra
```
terraform plan
```

Khi có quá nhiều resource và câu lệnh plan bị chậm, ta có thể tăng tốc nó lên bằng việc thêm vào -parallelism=n. 
```
terraform plan -parallelism=2
```

Lưu kết quả của plan ra file
```
terraform plan -out plan.out
terraform show -json plan.out > plan.json
```

Thực hiện tạo resource
```
terraform apply
```
hoặc
```
terraform apply "plan.out"
```

Thự hiện tạo + tự động xác nhận
```
terraform apply -auto-approve
```
hoặc
```
terraform apply "plan.out" -auto-approve
```

Sau khi tạo xong, Workspace sẽ có thêm file terraform.tfstate
```
.
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           └── hashicorp
│               └── aws
│                   └── 3.68.0
│                       └── linux_amd64
│                           └── terraform-provider-aws_v3.68.0_x5
├── .terraform.lock.hcl
├── main.tf
└── terraform.tfstate
```

Trong file terraform.tfstate sẽ lưu thông tin các resource đã được tạo ra
```
{
  "version": 4,
  "terraform_version": "1.0.0",
  "serial": 3,
  "lineage": "fa28c290-92d6-987f-c49d-bc546b296c2b",
  "outputs": {},
  "resources": []
}
```

Xóa resource + tự động xác nhận
```
terraform destroy -auto-approve
```

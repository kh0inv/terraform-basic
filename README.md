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

## Life cycle

Khi chỉnh sửa các resource, data trong main.tf, một trong các funtion hooks này sẽ được thực hiện

![markdown](https://images.viblo.asia/533acb9f-dde3-43d6-baf9-db03c50b031d.png)

- Resource type implement CRUD interface
- Data type thì implement Read() interface

Lưu đồ luồng CRUD

![markdown](https://images.viblo.asia/93b08891-5a2e-4929-800d-6a248c6e5f25.jpg)

Trong terraform, resource sẽ có hai loại thuộc tính (attribute) là force new với normal update:
- Force new attribute: resource sẽ được re-create (xóa resource cũ trước và tạo ra lại resouce mới => mất data cũ).
- Normal update attribute: resource được update bình thường, không cần phải xóa resouce cũ.

***Khi update resource cần chạy plan để kiểm tra có bị re-create hay không***

Xóa resource bằng `terraform destroy` sẽ sinh ra file backup
```
.
├── main.tf
├── terraform.tfstate
└── terraform.tfstate.backup
```

## Variable
```
variable "instance_type" {
  type = string
  description = "Instance type of the EC2"
}
```
Khối này có thể đặt trong `main.tf` hoặc để ra 1 file `.tf` với tên bất kì

Thuộc tính `type` là bắt buộc, để chỉ định kiểu của biến. Các type hợp lệ:
- Basic type: string, number, bool
- Complex type: list(), set(), map(), object(), tuple()

*Trong terraform, type number và type bool sẽ được convert thành type string khi cần thiết. Nghĩa là 1 sẽ thành "1", true sẽ thành "true"*

Sau khi định nghĩa biến, giờ phải gán giá trị cho biến. Tạo file tên là `terraform.tfvars`
```
instance_type = "t2.micro"
```
Khi ta chạy `terraform apply` thì file `terraform.tfvars` sẽ được terraform sử dụng mặc định để load giá trị cho biến. Nếu không muốn dùng tên mặc định này, ta thêm option `-var-file`
```
terraform apply -var-file="production.tfvars"
```
Nếu khai báo biến đầu vào cho `root module`, có 4 cách để gán giá trị cho nó:
- Trong file `main.tf`
- Sử dụng tùy chọn `-var` trong lệnh commmand `terraform apply -var="image_id=ami-abc123"`
- Định nghĩa file (.tfvars), đồng thời sử dụng tùy chọn `-var-file` như bên trên
- Khai báo như biến môi trường

*Các cách trên KHÔNG áp dụng được với `child module`*

### Validate variable
Trong block định nghĩa biến, thêm thiết lập validation
```
variable "instance_type" {
  ...
  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow"
  }
}
```

## Output

Khối này có thể đặt trong file `main.tf` hoặc tạo file `.tf` với tên bất kỳ
```
output "ec2_private_ip_addr" {
  description = "The private IP address of the main server instance"
  value = aws_instance.hello.private_ip
}
```

có thể nhóm nhiều output trong 1 `value` xuất ra
```
output "ec2_ip_addr" {
  description = "The public IP address of the main server instance"

  value = {
    public_ip = aws_instance.hello.public_ip
    private_ip = aws_instance.hello.public_ip
  }
}
```

## Count parameter

Sử dụng `count` để tạo hàng loạt
```
resource "aws_instance" "hello" {
  count = 5
  ...
}
```

## For expressions

```
for <value> in <list> : <return value>
```
- Áp dụng để tạo 1 mảng mới `[ for s in var.words: function(s) ]`
- Áp dụng để tạo 1 map mới `{ for k, v in var.words: k => function(v) }`

```
ouput "ec2_output" {
  value = {
    public_ip = [ for v in aws_instance.hello: v.public_ip ]
  }
}
```
```
ouput "ec2_output" {
  value = {
    public_ip = { for k, v in aws_instance.hello: format("public_ip%d", k+1) => v.public_ip }
  }
}
```
## Workspaces

Liệt kê các workspace hiện có
```
terraform workspace list
```

Tạo mới workspace
```
terraform workspace new dev
terraform workspace new pro
```

Chuyển đổi workspace
```
terraform workspace select dev
```

Khởi tạo tài nguyên, với tùy chọn giá trị đầu vào
```
terraform apply -var-file=env/dev.tfvars -auto-approve
```
## Working rules

- chỉ có 1 template duy nhất cho các environment, phân loại environment thì dùng cd tool như octopus, jenkins, gitlab hoặc terraform cloud
- push mọi thứ lên vcs, trừ value file (tfvars, .terraform*)
- split thành các module (main, variables, inputs, outputs, ...), tránh wall of text in a file
- gom tất cả variables vào 1 local resource duy nhất.
- chỉ dùng module của các provider lớn: hashicorp, aws, kubernetes, cloudflare, azure, không dùng module của cá nhân

# terraform-rds
Create an Amazon AWS RDS instance with security group.

## Example

```
module "rds" {
  vpc_subnet_ids = "subnet-1234abcd"
  db_admin_password = "some password"
  admin_cidrs = "0.0.0.0/0"
}
```

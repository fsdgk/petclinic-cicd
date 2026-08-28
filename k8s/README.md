# PetClinic Backend on EKS

Replace placeholders after `terraform apply`:

```bash
terraform output -raw ecr_repository_url
terraform output -raw rds_endpoint
```

Update:

- `CHANGE_ME_ECR_REPOSITORY_URL`
- `CHANGE_ME_RDS_ADDRESS`

Use the RDS endpoint without the port. If Terraform prints:

```text
test-db.xxxxxx.ap-northeast-2.rds.amazonaws.com:3306
```

put only:

```text
test-db.xxxxxx.ap-northeast-2.rds.amazonaws.com
```

Apply:

```bash
aws eks update-kubeconfig --region ap-northeast-2 --name test-eks
kubectl apply -f k8s/
kubectl -n petclinic get pods,svc,hpa
```

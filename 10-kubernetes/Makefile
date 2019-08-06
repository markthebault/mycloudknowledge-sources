gcp_region=us-east1
gcp_project=$(shell gcloud config list --format 'value(core.project)' 2>/dev/null)


all: terraform.init terraform.apply kubernetes.config

############
# Terraform
############
terraform.init:
	terraform init

terraform.plan:
	terraform plan

terraform.apply:
	terraform apply -auto-approves

terraform.destroy:
	terraform destroy


############
# Kubernetes
############
kubernetes.config:
	gcloud beta container clusters get-credentials --region $(gcp_region) k8some

kubernetes.set-context:
	kubectl config set-context gke_$(gcp_project)_$(gcp_region)_k8some

kubernetes.example-app:
	kubectl apply -f ./kube-guestbook

kubernetes.get-endpoint:
	kubectl get service frontend

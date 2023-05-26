.DEFAULT_GOAL := help

.PHONY: help
help:
	less ./README.md

.PHONY: tfvars
tfvars:
	cp ./terraform.tfvars.example terraform.tfvars

.PHONY: init
init:
	terraform init -upgrade

.PHONY: create
create: init
	terraform plan -out aro.plan 		                       \
		-var "cluster_name=aro-${USER}"

	terraform apply aro.plan

.PHONY: create-private
create-private: init
	terraform plan -out aro.plan 		                       \
		-var "cluster_name=aro-${USER}"                      \
		-var "restrict_egress_traffic=true"		               \
		-var "api_server_profile=Private"                    \
		-var "ingress_profile=Private"

	terraform apply aro.plan

.PHONY: create-private-noegress
create-private-noegress: init
	terraform plan -out aro.plan 		                       \
		-var "cluster_name=aro-${USER}"                      \
		-var "restrict_egress_traffic=false"		             \
		-var "api_server_profile=Private"                    \
		-var "ingress_profile=Private"

	terraform apply aro.plan

.PHONY: destroy
destroy:
	terraform destroy

.PHONY: destroy-force
destroy.force:
	terraform destroy -auto-approve

.PHONY: delete
delete: destroy


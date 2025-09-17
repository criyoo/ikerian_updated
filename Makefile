# Ikerian AWS Data Pipeline Makefile (Simple commands for local testing and deployment)
WORKSPACE := $(shell terraform workspace show)
WORKSPACE_VARS := "-var-file=envs/$(WORKSPACE).tfvars"


.PHONY: init validate plan apply deploy destroy status


fmt:
	terraform fmt -recursive

init: fmt
	terraform init

validate:
	terraform validate

lint: init
	terraform fmt -diff -check -recursive
	terraform validate

plan:
	terraform plan $(WORKSPACE_VARS) -out=tfplan

apply:
	terraform apply -auto-approve tfplan 

# Create a graph of the resource and their dependencies. 
# Requires "graphviz" package to be installed
graph:
	terraform graph | dot -Tpng > graph.png
	terraform graph | dot -Tpng > graph.jpeg

# Full deployment with prerequisites check
deploy: lint plan apply
	@echo "🎉 Full deployment completed successfully!"

destroy:
	terraform destroy $(WORKSPACE_VARS) -auto-approve;
	echo "✅ Resources destroyed successfully!";


# Check if infrastructure is deployed
RAW_EXISTS := $(shell aws s3 ls | grep ikerian-$(WORKSPACE)-raw-data >/dev/null 2>&1 && echo YES || echo NO)
PROC_EXISTS := $(shell aws s3 ls | grep ikerian-$(WORKSPACE)-processed-data >/dev/null 2>&1 && echo YES || echo NO)
LAMBDA_EXISTS := $(shell aws lambda get-function --function-name ikerian-$(WORKSPACE)-data-processor >/dev/null 2>&1 && echo YES || echo NO)
status:
	@echo "📊 Deployment Status:"
	@echo ""
ifeq ($(RAW_EXISTS),YES)
	@echo "✅ Raw Data Bucket exists: ikerian-$(WORKSPACE)-raw-data"
else
	@echo "❌ Raw Data Bucket missing"
endif

ifeq ($(PROC_EXISTS),YES)
	@echo "✅ Processed Data Bucket exists: ikerian-$(WORKSPACE)-processed-data"
else
	@echo "❌ Processed Data Bucket missing"
endif

ifeq ($(LAMBDA_EXISTS),YES)
	@echo "✅ Lambda Function exists: ikerian-$(WORKSPACE)-data-processor"
else
	@echo "❌ Lambda Function missing"
endif

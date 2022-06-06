#!make
# include .env
# export

tf_development = ./
# tf_tests = ./Infrastructure/tests

tf-validate:
	@if terraform fmt -check -diff -recursive  $(tf_development); then \
		echo "Terraform files all formatted correctly"; \
	else \
		echo "Formatting errors found, run tf-format to fix automatically"; \
		exit 1; \
	fi
	@cd $(tf_development) && terraform init -backend=false && terraform validate

tf-deploy: tf-format tf-validate
	@cd $(tf_development) && \
		terraform init && \
		terraform apply -auto-approve -var-file=./environments/dev.tfvars -lock=false

tf-destroy:
	@cd $(tf_development) && \
		terraform destroy -var-file=./environments/dev.tfvars -lock=false

tf-format:
	terraform fmt -recursive $(tf_development)

# tf-deploy-cd: tf-validate
# 	@cd $(tf_development) && \
# 		terraform init -backend-config='resource_group_name=$(backend-rg)'\
# 		 -backend-config='storage_account_name=$(backend-storage)' \
# 		 -backend-config='container_name=$(backend-container)' \
# 		 -backend-config='key=$(backend-statefile-name)' \
# 		 -backend-config='sas_token=$(backend-sas-token)'\
# 		  && \
# 		terraform apply -auto-approve -var-file=environment.tfvars \
# 			-var='environment_name=$(environment)' \
# 			-var='unique_postfix_value=$(build-number)' \
# 			-var='client_id=$(client-id)' \
# 			-var='client_secret=$(client-secret)' \
# 			-var='client_ea_object_id=$(client-ea-object-id)' \
# 			-var='tenant_id=$(tenant-id)' \
# 			-var='subscription_id=$(subscription-id)' \
# 			-var='companieshouse_streaming_api_key=$(companieshouse-api-key)' \
# 			-var='app_service_client_id=$(app-service-client-id)' \
# 			-var='app_service_client_secret=$(app-service-client-secret)'


# tf-test:
# 	cd $(tf_tests) && \
# 		go test ${TEST_FILE} -v -timeout 30m -short
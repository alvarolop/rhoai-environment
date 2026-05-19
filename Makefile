.PHONY: docs docs-check install-helm-docs help

help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

docs: ## Generate README.md from values.yaml using helm-docs
	@echo "Generating documentation..."
	@if ! command -v helm-docs >/dev/null 2>&1; then \
		echo "Error: helm-docs is not installed. Run 'make install-helm-docs' first."; \
		exit 1; \
	fi
	@helm-docs --chart-search-root=. --template-files=README.md.gotmpl
	@echo "✓ README.md generated successfully!"

docs-check: ## Check if documentation is up to date
	@echo "Checking if documentation is up to date..."
	@if ! command -v helm-docs >/dev/null 2>&1; then \
		echo "Error: helm-docs is not installed. Run 'make install-helm-docs' first."; \
		exit 1; \
	fi
	@helm-docs --dry-run --chart-search-root=. --template-files=README.md.gotmpl
	@echo "✓ Documentation is up to date!"

install-helm-docs: ## Install helm-docs tool
	@echo "Installing helm-docs..."
	@if command -v helm-docs >/dev/null 2>&1; then \
		echo "helm-docs is already installed: $$(helm-docs --version)"; \
	else \
		echo "Installing helm-docs using go install..."; \
		go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest; \
		echo "✓ helm-docs installed successfully!"; \
	fi

lint: ## Lint the Helm chart
	@echo "Linting chart..."
	@helm lint .
	@echo "✓ Chart linted successfully!"

package: ## Package the Helm chart
	@echo "Packaging chart..."
	@helm package .
	@echo "✓ Chart packaged successfully!"

template: ## Template the Helm chart with default values
	@echo "Templating chart..."
	@helm template test-release .

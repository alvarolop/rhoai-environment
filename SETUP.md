# Setup Guide for Documentation Generation

This chart uses [helm-docs](https://github.com/norwoodj/helm-docs) to automatically generate documentation from the `values.yaml` file.

## Installing helm-docs

### Option 1: Using Go (Recommended)

```bash
go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
```

Make sure `$GOPATH/bin` is in your PATH.

### Option 2: Using Homebrew (macOS/Linux)

```bash
brew install norwoodj/tap/helm-docs
```

### Option 3: Download Binary

Download the latest release from [GitHub](https://github.com/norwoodj/helm-docs/releases):

```bash
# Linux
wget https://github.com/norwoodj/helm-docs/releases/latest/download/helm-docs_Linux_x86_64.tar.gz
tar xzf helm-docs_Linux_x86_64.tar.gz
sudo mv helm-docs /usr/local/bin/

# macOS
wget https://github.com/norwoodj/helm-docs/releases/latest/download/helm-docs_Darwin_x86_64.tar.gz
tar xzf helm-docs_Darwin_x86_64.tar.gz
sudo mv helm-docs /usr/local/bin/
```

## Generating Documentation

Once helm-docs is installed, you can generate the README:

### Using Make (Easiest)

```bash
# Generate documentation
make docs

# Check if documentation is up to date
make docs-check

# See all available commands
make help
```

### Using helm-docs Directly

```bash
helm-docs --chart-search-root=. --template-files=README.md.gotmpl
```

## How It Works

1. **values.yaml** contains special comments that start with `# --`
2. **README.md.gotmpl** is the template file with sections and examples
3. **helm-docs** reads both files and generates **README.md**

## Updating Documentation

Whenever you update `values.yaml`:

1. Add comments using the `# --` syntax for new parameters
2. Run `make docs` to regenerate the README
3. Commit both `values.yaml` and the generated `README.md`

## Example Comment Syntax

```yaml
# -- Description of the parameter
parameterName: value

# -- Description with @default tag
# @default -- Custom default description
complexParameter:
  nested: value
```

## CI/CD Integration

You can add a check to your CI pipeline to ensure documentation is up to date:

```yaml
# Example GitHub Actions
- name: Check documentation
  run: |
    make install-helm-docs
    make docs-check
```

## Additional Resources

- [helm-docs GitHub](https://github.com/norwoodj/helm-docs)
- [helm-docs Documentation](https://github.com/norwoodj/helm-docs#usage)

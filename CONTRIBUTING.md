# Contributing to RHOAI Environment Chart

## Documentation Workflow

This chart uses automated documentation generation via [helm-docs](https://github.com/norwoodj/helm-docs).

### Quick Start

```bash
# Install helm-docs (first time only)
make install-helm-docs

# Generate documentation after making changes
make docs

# Check if docs are up to date
make docs-check
```

### When to Update Documentation

**Automatically updated** (just run `make docs`):
- Any changes to `values.yaml` parameters
- Changes to `Chart.yaml` metadata
- New parameters added

**Manually update**:
- `README.md.gotmpl` for examples, guides, or additional sections
- Then run `make docs` to regenerate

### Adding New Parameters

When adding a new parameter to `values.yaml`, document it using this format:

```yaml
# -- Brief description of what this parameter does
newParameter: defaultValue

# -- For nested objects, document the parent
# @default -- See values below
complexParameter:
  # -- Description of nested parameter
  nested: value
```

### Documentation Comment Syntax

| Syntax | Purpose | Example |
|--------|---------|---------|
| `# --` | Document a parameter | `# -- Database hostname` |
| `# @default` | Custom default description | `# @default -- Calculated from other values` |
| `# @ignored` | Exclude from docs | `# @ignored` |

### Commit Guidelines

When making changes:

1. Update `values.yaml` with proper `# --` comments
2. Run `make docs` to regenerate README
3. Review the generated README.md
4. Commit **both** `values.yaml` and `README.md`

```bash
git add values.yaml README.md
git commit -m "feat: add new parameter for XYZ"
```

### Testing Your Changes

```bash
# Lint the chart
make lint

# Test template rendering
make template

# Package the chart
make package
```

## Chart Version Guidelines

Update `Chart.yaml` version following [Semantic Versioning](https://semver.org/):

- **Patch** (0.1.0 → 0.1.1): Bug fixes, documentation updates
- **Minor** (0.1.0 → 0.2.0): New features, backward compatible changes
- **Major** (0.1.0 → 1.0.0): Breaking changes

## Pre-Commit Checks

Before committing, ensure:

- [ ] Documentation is up to date (`make docs-check`)
- [ ] Chart passes linting (`make lint`)
- [ ] Templates render correctly (`make template`)
- [ ] All values are documented with `# --` comments

## CI/CD Integration

Add to your CI pipeline:

```yaml
- name: Verify documentation
  run: |
    make install-helm-docs
    make docs
    git diff --exit-code README.md || (echo "README.md is out of date. Run 'make docs'" && exit 1)
```

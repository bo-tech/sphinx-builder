# Agent Guidelines for sphinx-builder

## Repository Purpose

Nix flake providing a Sphinx documentation build environment with common extensions.
Used as a dependency by other documentation projects.

## Versioning

- **Semantic versioning** via git tags: `v0.1.0`, `v0.2.0`, etc.
- **No VERSION file** — version is determined solely by git tags
- Tags should follow semver:
  - Patch (`v0.6.1`): Bug fixes, dependency updates
  - Minor (`v0.7.0`): New extensions, features
  - Major (`v1.0.0`): Breaking changes

## Release Process

1. Make changes to `packages.nix` or `flake.nix`
2. Test locally: `nix build .#sphinx-env --no-link`
3. Commit with conventional commit message (e.g., `feat: Add sphinxcontrib-mermaid`)
4. Push to main branch
5. Tag the release: `git tag v0.X.0 && git push --tags`

## CI/CD

- **Trigger:** Runs on tags and main branch pushes
- **Output:** Container image pushed to GitLab registry
- **Image tags:**
  - Git tag → same tag on image (e.g., `v0.7.0`)
  - Main branch → `latest`

## Consumer Updates

Projects using this flake pin a specific commit in their `flake.lock`.
After pushing changes here, consumers update via:

```bash
cd project/docs
nix flake update sphinx-builder
```

Or update all inputs:

```bash
nix flake update
```

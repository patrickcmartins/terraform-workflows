# terraform-workflows

**Reusable workflows** do GitHub Actions para todos os repos Terraform da "empresa".
A ideia é ter um único lugar onde o padrão de qualidade é definido e versionado.

| Workflow | Usado por | O que faz |
|---|---|---|
| `terraform-ci.yml` | todo PR | descobre root modules, roda `fmt`, `validate`, `tflint`, `trivy config` e `terraform test` |
| `terraform-drift.yml` | cron no `infra-live` | `plan -detailed-exitcode` com **OIDC na AWS**; abre uma issue se houver drift |
| `release-please.yml` | `terraform-modules` | semver e CHANGELOG a partir de Conventional Commits |

```yaml
jobs:
  ci:
    uses: patrickcmartins/terraform-workflows/.github/workflows/terraform-ci.yml@v1
    with:
      run-tests: true
```

## Versionamento

* As tags `vX.Y.Z` são imutáveis e `v1` é uma tag **móvel** que aponta para o último `v1.x`. Os consumidores usam `@v1`.
* Breaking change (input removido, por exemplo) vira `v2`, e os consumidores migram quando quiserem.
* Em ambiente regulado, fixe por **SHA** (`@<sha>`) e deixe o Dependabot/Renovate fazer os bumps.

## Divisão de responsabilidades: CI x Atlantis

| | GitHub Actions (este repo) | Atlantis |
|---|---|---|
| Lint, segurança, testes | sim | não |
| `plan` / `apply` com credenciais de escrita | não | sim (via comentário no PR) |
| Drift detection (só leitura, OIDC) | sim | não |

O `mergeable` do Atlantis depende do CI verde, então nenhum `apply` acontece sem lint e segurança aprovados.

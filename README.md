# Solucione Infrastructure

Este repositório contém a infraestrutura como código (IaC) para o projeto Solucione, utilizando Terraform para provisionar recursos na AWS.

## 📋 Visão Geral

A infraestrutura do Solucione é composta por três módulos principais que gerenciam diferentes aspectos da aplicação:

- **IAM**: Gerenciamento de identidades e permissões
- **S3**: Armazenamento de arquivos e estado do Terraform
- **ECR**: Registro de containers Docker

## Repositórios complementares

- Backend: https://github.com/garciaagui/solucione-backend
- Mobile: https://github.com/garciaagui/solucione-mobile

## 🏗️ Arquitetura

### Módulos

#### 1. **IAM Module** (`modules/iam/`)

Gerencia as identidades e permissões necessárias para o projeto:

- **OIDC Provider**: Configuração para autenticação via GitHub Actions
- **Terraform Role**: Role para execução de pipelines de infraestrutura
- **ECR Role**: Role específica para operações com ECR e App Runner
- **Políticas de Acesso**: Permissões granulares para cada role

#### 2. **S3 Module** (`modules/s3/`)

Gerencia buckets S3 para diferentes propósitos:

- **State Bucket** (`solucione-state-bucket`): Armazena o estado do Terraform
  - Versionamento habilitado
  - Proteção contra destruição acidental
- **Images Bucket** (`solucione-images-bucket`): Armazenamento público de imagens
  - Acesso público configurado
  - Política de leitura pública

#### 3. **ECR Module** (`modules/ecr/`)

Configura o Elastic Container Registry:

- **Repository**: `solucione-ecr`
- **Scan de Imagens**: Habilitado para segurança
- **Tag Mutability**: Configurado como MUTABLE

## 🚀 Configuração e Uso

### Pré-requisitos

- Terraform >= 1.0
- AWS CLI configurado
- Perfil AWS configurado (variável de ambiente `AWS_PROFILE`)

### Configuração do Backend

O estado do Terraform é armazenado no S3 com as seguintes configurações:

```hcl
backend "s3" {
  bucket = "solucione-state-bucket"
  key    = "state/terraform.tfstate"
  region = "us-east-2"
}
```

### Deploy da Infraestrutura

1. **Clone o repositório**:

   ```bash
   git clone <repository-url>
   cd solucione-infra
   ```

2. **Configure o perfil AWS**:

   ```bash
   export AWS_PROFILE=seu_profile
   ```

3. **Inicialize o Terraform**:

   ```bash
   terraform init
   ```

4. **Planeje as mudanças**:

   ```bash
   terraform plan
   ```

5. **Aplique a infraestrutura**:
   ```bash
   terraform apply
   ```

## 🔐 Segurança

### GitHub Actions Integration

A infraestrutura está configurada para integração com GitHub Actions através de OIDC:

- **Terraform Role**: Para pipelines de infraestrutura no repositório `garciaagui/solucione-infra`
- **ECR Role**: Para pipelines de aplicação no repositório `garciaagui/solucione-backend`

### Tags Padrão

Todos os recursos são automaticamente marcados com:

- `IAC = "True"`

## 📁 Estrutura do Projeto

```
solucione-infra/
├── main.tf                 # Configuração principal dos módulos
├── providers.tf           # Configuração de providers e backend
├── modules/
│   ├── iam/
│   │   └── main.tf        # Recursos IAM (roles, policies, OIDC)
│   ├── s3/
│   │   └── main.tf        # Buckets S3 (state e images)
│   └── ecr/
│       └── main.tf        # ECR repository
└── README.md              # Este arquivo
```

## 🔧 Recursos Criados

### IAM

- OIDC Provider para GitHub Actions
- Role `tf-role` com permissões para ECR, IAM e S3
- Role `ecr-role` com permissões para App Runner e ECR
- Políticas associadas às roles

### S3

- Bucket `solucione-state-bucket` (protegido contra destruição)
- Bucket `solucione-images-bucket` (acesso público)
- Versionamento habilitado no bucket de estado

### ECR

- Repository `solucione-ecr`
- Scan de vulnerabilidades habilitado

## 🛠️ Comandos Úteis

```bash
# Verificar o estado atual
terraform show

# Listar recursos
terraform state list

# Destruir recursos (cuidado!)
terraform destroy

# Formatar código
terraform fmt -recursive

# Validar configuração
terraform validate
```

## 📝 Notas Importantes

- O bucket de estado (`solucione-state-bucket`) está protegido contra destruição acidental
- As roles IAM são específicas para os repositórios GitHub configurados
- O bucket de imagens tem acesso público configurado
- Todos os recursos seguem as melhores práticas de segurança da AWS

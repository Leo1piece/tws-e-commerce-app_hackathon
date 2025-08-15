terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
<<<<<<< HEAD
  region = "ap-southeast-2"
}

#跨区域资源管理
#如果你需要在不同的 AWS 区域（比如一个资源在 eu-west-1，另一个在 ap-southeast-2）创建资源，就需要定义多个 provider，并用 alias 区分。例如：
=======
  region = "ap-south-1"
}


>>>>>>> 583401a6d8617af7499e4bd4135fa2dba0d8064d
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# 3 bucket 是全局唯一，但每个 bucket 有自己的 region。你必须让 Terraform 的 backend 配置里的 region 和 S3 bucket 的实际 region 一致，否则会报 301 重定向错误
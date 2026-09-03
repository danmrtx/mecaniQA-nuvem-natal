terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "mecaniqa_net" {
  name = "mecaniqa-net"
}

resource "docker_volume" "mysql_data" {
  name = "mysql_data_tf"
}

resource "docker_volume" "redis_data" {
  name = "redis_data_tf"
}

resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_container" "mysql" {
  name  = "mecaniqa-mysql-tf"
  image = docker_image.mysql.image_id
  env   = ["MYSQL_ROOT_PASSWORD=admin"]

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name = docker_network.mecaniqa_net.name
  }

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }
}

resource "docker_image" "redis" {
  name = "redis:7-alpine"
}

resource "docker_container" "redis" {
  name  = "mecaniqa-redis-tf"
  image = docker_image.redis.image_id

  ports {
    internal = 6379
    external = 6379
  }

  networks_advanced {
    name = docker_network.mecaniqa_net.name
  }

  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
  }
}

resource "docker_image" "api" {
  name = "mecaniqa-api-tf"
  build {
    context = "../app-java"
  }
  keep_locally = true
}

resource "docker_container" "api" {
  name  = "mecaniqa-app-tf"
  image = docker_image.api.image_id

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.mecaniqa_net.name
  }

  depends_on = [docker_container.mysql, docker_container.redis]
}
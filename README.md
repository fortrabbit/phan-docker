# phan-docker

An installation of PHP7 and [Phan](https://github.com/phan/phan/) in a small Alpine Linux Docker image.

This project is a simplified version of the complex build process used in [Cloudflare's docker-phan](https://github.com/cloudflare/docker-phan).

## Motivations

Phan requires PHP 7.1 and specific PHP extensions to be installed. Sometimes your local version of PHP does not match and users would still need to compile and enable the extra PHP extensions.

By packaging Phan inside a Docker image, we can separate the runtime and configuration of the tool from your application’s environment and requirements.

## Getting phan-docker

The easiest way is to create a shell function for “phan” that makes makes it nearly transparent that phan is running inside Docker.

```sh
phan() { docker run -it -v $PWD:/mnt/src --rm -u "$(id -u):$(id -g)" fortrabbit/phan:latest $@; return $?; }
```

(You may replace “latest” with a tagged Phan release to use a specific version of Phan.)

## Running phan-docker
> If you’re just getting started with Phan, you should follow Phan’s excellent
[Tutorial for Analyzing A Large Sloopy Code Base][phan-tutorial] to setup the
initial configuration for your project.

All of Phan’s command line flags can be passed to `docker-phan`.

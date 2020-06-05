

## Linux Environment

Once you have a Linux development environment (either virtual or bare metal), the build is done in four separate steps:

1. Prerequisite packages.  Mostly compilers, tools and libraries needed to compile everything else.
1. OpenResty system, including Nginx, LuaJIT, PCRE, etc.
1. Databases. Kong uses Posgres, Cassandra and Redis.  We have a handy setup with docker-compose to keep each on its container.
1. Kong itself.


### Prerequisites

These are the needed tools and libraries that aren't installed out of the box on Ubuntu and Fedora, respectively.  Just run one of these, either as root or sudo.

Ubuntu:

```
    apt-get update

    apt-get install \
        automake \
        build-essential \
        curl \
        docker \
        docker-compose \
        git \
        libpcre3 \
        libyaml-dev \
        m4 \
        openssl \
        perl \
        procps \
        unzip \
        zlib1g-dev
```

Fedora:

```
    dnf install \
        automake \
        docker \
        docker-compose \
        gcc \
        gcc-c++ \
        git \
        libyaml-devel \
        make \
        patch \
        pcre-devel \
        unzip \
        zlib-devel
```

### OpenResty

We have a build script that makes it easy to pull and compile specific versions of the needed components of the OpenResty system.  Currently these include OpenResty 1.15.8.2, OpenSSl 1.1.1d, LuaRocks 3.2.1 and PCRE 8.43;  the exact versions can also be found on the `.requirements` file of the main Kong repository (https://github.com/Kong/kong/blob/master/.requirements)

These commands don't have to be performed as root, since all compilation is done within a subdirectory, and installs everything in the target specified by the `-p` argument (here the `build` directory).

```
    git clone https://github.com/kong/openresty-build-tools

    cd openresty-build-tools

    ./kong-ngx-build -p build \
        --openresty 1.15.8.2 \
        --openssl 1.1.1d \
        --luarocks 3.2.1 \
        --pcre 8.43
```

After this task, we'd like to have the next steps use the built packages and for LuaRocks to install new packages inside this `build` directory.  For that, it's important to set the `$PATH` variable accordingly:


## 将以下环境变量放入 .bash_profile中，注意更改安装路径, 然后 source  ~/.bash_profile
```
    export PATH=$HOME/path/to/kong/openresty-build-tools/build/openresty/bin:$HOME/path/to/kong/openresty-build-tools/build/openresty/nginx/sbin:$HOME/path/to/kong/openresty-build-tools/build/luarocks/bin:$PATH
    export OPENSSL_DIR=$HOME/path/to/kong/openresty-build-tools/build/openssl

    eval `luarocks path`
```

The `$OPENSSL_DIR` variable is needed when compiling Kong, to make sure it uses the correct version of OpenSSL.

You can add these lines to your `.profile` or `.bashrc` file.  Otherwise you could find yourself wondering where is everything!.


### Databases

The easiest way to handle these as a single group is via docker-compose.  It's also recommended to set your user as a [docker manager](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) to simplify the next steps.

Make sure the docker daemon is enabled and running: `sudo systemctl enable docker` and `sudo systemctl start docker`.  Verify that `docker ps` shows no errors.

On a Fedora VM, you might have to disable SELinux:

```
    sudo vim /etc/selinux/config        # change the line to SELINUX=disabled
    sudo setenforce 0
```

Now pull the compose script from the repository and fire it up:

```
    git clone https://github.com/thibaultcha/kong-tests-compose.git

    cd kong-tests-compose

    docker-compose up
```

Verify the three new containers are up and running with `docker ps` on a separate terminal.


### Install Kong

```
    git clone https://github.com/Kong/kong.git
    cd kong
    git checkout next
    make dev
```

Now run unit tests with `make test` and integration test with `make test-integration`.

Hack on!

# Table of Contents

-   [About](#org7058eb3)
-   [Installation](#org76b7260)
    -   [Download from dockerhub](#org7172bb5)
    -   [Build from chiselapp (fossil)](#org8dbf7e3)
    -   [Build from github](#org5188bbf)
-   [Configuration options](#org2ff6644)
    -   [General options](#org42abd73)
    -   [Timezone](#org72d8313)
-   [Usage](#orged99818)
-   [Prepare source packages](#orga222ddc)
-   [CI/CD](#org3b59035)
-   [Maintenance](#org994c70b)
    -   [Log output](#org1076b1d)
    -   [Shell access](#orgba1cb96)



<a id="org7058eb3"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay) for buid tcl software. The basic idea was taken from [tcl2020-build](https://github.com/tcl2020/tcl2020-build) .

Tcl-build is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/tcl-build>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting tcl-build repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about tcl-build, visit the official self-hosting site linked above.


<a id="org76b7260"></a>

# Installation


<a id="org7172bb5"></a>

## Download from dockerhub

    docker pull oupfiz5/tcl-build:latest
    docker pull oupfiz5/tcl-build:20.04


<a id="org8dbf7e3"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/tcl-build tcl-build.fossil
    mkdir tcl-build
    cd tcl-build
    fossil open ../tcl-build.fossil
    docker build -t oupfiz5/tcl-build .


<a id="org5188bbf"></a>

## Build from github

    git clone https://github.com/oupfiz5/tcl-build.git
    cd tcl-build
    docker build -t oupfiz5/tcl-build .


<a id="org2ff6644"></a>

# Configuration options


<a id="org42abd73"></a>

## General options

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Option</th>
<th scope="col" class="org-left">Default</th>
<th scope="col" class="org-left">Description</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">TZ</td>
<td class="org-left">UTC</td>
<td class="org-left">Set timezone, example Europe/Moscow</td>
</tr>
</tbody>
</table>


<a id="org72d8313"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the timezone set the desired timezone with the variable TZ.

    docker run -it --rm \
               --name tcl-build  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/tcl-build:latest \
               /bin/bash


<a id="orged99818"></a>

# Usage

Run the build container in the background with Docker:

    mkdir -p $PWD/workspaces
    docker run -itd \
        -v $PWD/workspaces:/workspaces\
        -v $PWD/builds:/builds \
        --name=tcl-build \
        oupfiz5/tcl-build:latest

Build Naviserver in tcl-build using a docker exec:

    docker exec -it tcl-build bash /builds/ns-all-build.sh

Modify the source code of any package in the workspaces directory. Then you can use make, cmake, &#x2026; to rebuild the container with the changes.  Use the build container with your favorite IDE


<a id="orga222ddc"></a>

# Prepare source packages

Source packages are added to the Docker image using the `builds/build-all.sh` script.

To add packages or features create a two shell scripts in `builds` directory.  One shell script will download the source package: `yourpackage-download.sh`. The other script will build the package: `yourpackage-build.sh`.  Add your new build script, `yourpackage-build.sh`, to `builds/all-build.sh`.


<a id="org3b59035"></a>

# CI/CD

For  build and push docker images using  [Github Actions workflow](https://github.com/oupfiz5/build-tcl/blob/master/.github/workflows/on-push.yaml).


<a id="org994c70b"></a>

# Maintenance


<a id="org1076b1d"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=tcl-build \
           oupfiz5/tcl-build:latest \
           /bin/bash


<a id="orgba1cb96"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are usingDocker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it tcl-build /bin/bash

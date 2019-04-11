# diffusion imaging analysis containers

This repository contains instructions for creating Linux containers for the processing of diffusion MR images. Individual containers are created for DTIPrepTools, FreeSurfer, and FSL. These containers will be specified using Dockerfiles, built using Docker, and then converted to Singularity for use on high-performance computing clusters. Singularity is an HPC-friendly container implementation that preserves a user's privileges, whereas Docker can escalate a user to root. Graphical user interfaces are also easier to use with Singularity.

Here are the instructions to [install Docker](https://docs.docker.com/install/) and to [install Singularity](https://www.sylabs.io/guides/3.0/user-guide/installation.html). You must be running Linux to use Singularity.

## DTIPrepTools

The specification for the DTIPrepTools container is in [dtipreptools.Dockerfile](dtipreptools.Dockerfile). This file was written by hand.

Build Docker container:

```bash
docker build --tag dtipreptools:latest - < dtipreptools.Dockerfile
```

Convert to Singularity:

```bash
sudo singularity build dtipreptools.sif docker-daemon://dtipreptools:latest
```

Run DTIPrep:

```bash
singularity run --bind /path/to/data:/data dtipreptools.sif DTIPrep
```

## FreeSurfer

The specification for the FreeSurfer container is in [freesurfer.Dockerfile](freesurfer.Dockerfile). This file was generated with Neurodocker. This does not include support for `freeview`.

Generate the Dockerfile:

```bash
docker run --rm kaczmarj/neurodocker:master generate docker \
  --base neurodebian:nd16.04-non-free \
  --pkg-manager apt \
  --freesurfer version=6.0.1 > freesurfer.Dockerfile
```

Build Docker container:

```bash
docker build --tag freesurfer:latest - < freesurfer.Dockerfile
```

Convert to Singularity:

```bash
sudo singularity build freesurfer.sif docker-daemon://freesurfer:latest
```

## FSL

The specification for the FSL container is in [fsl.Dockerfile](fsl.Dockerfile). This file was generated with Neurodocker.

Generate the Dockerfile:

```bash
docker run --rm kaczmarj/neurodocker:master generate docker \
  --base neurodebian:nd16.04-non-free \
  --pkg-manager apt \
  --install \
      apt_opts='--quiet' \
      fsl-core \
      fsleyes \
      fslview \
  --add-to-entrypoint 'source /etc/fsl/fsl.sh' > fsl.Dockerfile
```

Build Docker container:

```bash
docker build --tag fsl:latest - < fsl.Dockerfile
```

Convert to Singularity:

```bash
sudo singularity build fsl.sif docker-daemon://fsl:latest
```

Run fslview:

```bash
singularity run --bind /path/to/data:/data fsl.sif fslview /data/T1w.nii.gz
```

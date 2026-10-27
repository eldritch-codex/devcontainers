<h1 align="center">EldritchCodex Development Containers</h1>

<h3 align="center">The shared Linux graphics development image for Nodens, Nyar and the application template.</h3>

<p align="center">
  <a href="https://github.com/eldritch-codex/devcontainers/actions/workflows/publish-linux-graphics.yml"><img src="https://img.shields.io/github/actions/workflow/status/eldritch-codex/devcontainers/publish-linux-graphics.yml?branch=main&amp;style=flat-square&amp;label=publish" alt="Publish workflow status"></a>
  <img src="https://img.shields.io/badge/platform-linux%2Famd64-blue?style=flat-square" alt="Platform: linux/amd64">
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-yellow?style=flat-square" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://github.com/eldritch-codex/nodens">Nodens</a> ·
  <a href="https://github.com/eldritch-codex/template-nodens-app">Application Template</a> ·
  <a href="https://github.com/eldritch-codex/nyar">Nyar</a>
</p>

> **Status:** the image is published as `ghcr.io/eldritch-codex/arch-dev:main`, and the tag moves when the image is rebuilt.
>
> **Limitations:** the image is Linux-only and targets `linux/amd64`. It does not contain NVIDIA kernel drivers.

## Introduction

Shared Linux graphics development image for Nodens, Nyar, and Template-NodensApp.

## Images

Shared image:

```text
ghcr.io/eldritch-codex/arch-dev:main
```

The image owns the full toolchain. GPU devices and NVIDIA runtime defaults stay
in each consuming project's `devcontainer.json`. The image does not contain
NVIDIA kernel drivers. Docker injects host NVIDIA libraries when `--gpus=all` is
used.

The image is Linux-only and currently targets `linux/amd64`. It contains:

- Clang, LLD, CMake, Ninja, GDB, Git, and common build utilities.
- OpenGL/Mesa and libglvnd userspace libraries.
- GLFW with X11 and Wayland support.
- X11 and Wayland development packages, including `libxkbcommon`.
- Vulkan headers, loader, validation layers, tools, and SPIR-V tools.
- Pinned `slangc` from an official Shader-Slang release.
- Pinned CodeLLDB debug adapter from an official release, at `/opt/codelldb/adapter/codelldb`.
- Non-root `eldritchcodex` user with passwordless sudo.

## GPU configuration

Each project uses plain `image` Dev Container configuration. No Docker Compose
or host GPU detection runs.

Generic Intel/AMD configuration uses:

```json
"image": "ghcr.io/eldritch-codex/arch-dev:main",
"runArgs": [
    "--device=/dev/dri",
    "--group-add=video",
    "--group-add=render"
]
```

NVIDIA configuration uses the same image with:

```json
"runArgs": ["--gpus=all"],
"containerEnv": {
    "NVIDIA_DRIVER_CAPABILITIES": "graphics,display,utility"
}
```

NVIDIA hosts need NVIDIA Container Toolkit configured in Docker:

```sh
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

The host must provide the display environment. The project configurations mount
`/tmp/.X11-unix` for X11 and `${XDG_RUNTIME_DIR}` for Wayland, and pass through
`DISPLAY`, `WAYLAND_DISPLAY`, and `XDG_RUNTIME_DIR`.

X11-only hosts need `/tmp/.X11-unix`. Wayland hosts need a valid
`XDG_RUNTIME_DIR`. X11 authentication may require host-specific setup.

## Repository layout

```text
linux-graphics/
├── Dockerfile
├── .bashrc
├── README.md
└── scripts/
    ├── create-user.sh
    ├── install-git-prompt.sh
    ├── install-codelldb.sh
    ├── install-packages.sh
    └── install-slang.sh
.devcontainer/
└── devcontainer.json
.github/workflows/
└── publish-linux-graphics.yml
```

## Local image build

Build the shared image:

```sh
docker build --pull \
    -t ghcr.io/eldritch-codex/arch-dev:main \
    linux-graphics
```

Rebuild or reopen the project Dev Container after changing the image.

The publish workflow pushes the image on `main`, version tags, or manual
dispatch. Make the GHCR package public when anonymous pulls are needed.

## Relationship to Nodens and Nyar

Nodens, Nyar, and Template-NodensApp keep their own source repositories and
build configurations. They use this shared toolchain image and do not publish
project-specific images unless a project later needs unique dependencies.

Each project's `devcontainer.json` sets `workspaceMount` and `workspaceFolder` to
`${localWorkspaceFolder}`, so the project sits at the same path inside the
container as on the host. That keeps build caches, `compile_commands.json` and
debugger source paths valid on both sides. Projects whose Zed runs on the host
drive the container with the Dev Containers CLI (`devcontainer up` and
`devcontainer exec`) and expect the CodeLLDB debug adapter at
`/opt/codelldb/adapter/codelldb` in this image.

## Acknowledgements

In September 2026 I started experimenting with LLM coding agents (Claude Code, ZedAI and Pi) and even decided to develop my own: [Armitage](https://eldritchcodex.com/armitage/). I use them mostly to learn new stuff, but also they help with documentation, CI/CD and general project upkeep. Commits carry no co-author or AI attribution trailers, since I am responsible for every commit.

## License

Copyright (c) 2026 EldritchCodex. The project and its entire history are licensed under the MIT License.

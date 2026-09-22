#!/usr/bin/env bash
# Common C++ and desktop development packages.

set -euo pipefail

pacman -Syyu --noconfirm

packages=(
    # Base utilities and debugging.
    sudo
    gdb
    patch

    # C++ toolchain and build tools.
    clang
    llvm
    lld
    cmake
    ninja
    pkgconf

    # Source control and downloads.
    git
    openssh
    curl
    ca-certificates

    # OpenGL and GLFW.
    mesa
    libglvnd
    glfw

    # X11 development.
    xorgproto
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    libxfixes

    # Wayland development.
    wayland
    wayland-protocols
    libxkbcommon

    # Vulkan development and diagnostics.
    vulkan-headers
    vulkan-icd-loader
    vulkan-validation-layers
    vulkan-tools
    spirv-tools
)

pacman -S --noconfirm "${packages[@]}"

pacman -Scc --noconfirm

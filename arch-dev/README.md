# Arch linux development image

This image is the shared development environment for Nodens, Nyar, and
Template-NodensApp.

It includes the common C++ toolchain, GLFW, OpenGL userspace libraries, X11,
Wayland, Vulkan development and diagnostic tools, and `slangc`. Both X11 and
Wayland support are compiled into the desktop stack; the active display backend
is selected at runtime by GLFW and the host session.

The image is published as
`ghcr.io/eldritch-codex/arch-dev:main`, is Linux-only, and currently
targets `linux/amd64`. GPU devices, display sockets, and session-specific
environment variables are runtime concerns configured by each consuming
repository's `devcontainer.json`.

The CodeLLDB debug adapter is installed at `/opt/codelldb/adapter/codelldb`, pinned and checksum-verified. An editor running on the host starts it with `devcontainer exec` (or `docker exec`) and talks to it over stdio.

CMake defaults are set for a plain `cmake -S . -B build`: Clang as the C and C++ compiler (`CC`, `CXX`), Ninja as the generator (`CMAKE_GENERATOR`) and an exported compile database (`CMAKE_EXPORT_COMPILE_COMMANDS`). Doxygen and capstone are installed for the optional `nodens-docs` and Tracy profiler targets.

NVIDIA hosts require a working host driver and the
[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
Intel/AMD hosts use `/dev/dri` at runtime.

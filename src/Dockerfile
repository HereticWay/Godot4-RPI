FROM debian:bookworm

# Get some dependencies
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		ca-certificates \
		curl \
		git \
		sudo

# Get mesa compilation script and run
RUN curl -s https://raw.githubusercontent.com/karnkaul/rpi4-install-vulkan/14b658cdb24d297398890ef247f38262e93d0e7f/install_vulkan.sh \
	| /bin/bash



# Get Godot sources
RUN curl https://downloads.tuxfamily.org/godotengine/4.0/alpha2/godot-4.0-alpha2.tar.xz \
	| tar --extract --xz

# Apply sse2neon patch to Godot sources
COPY ./sse2neon_patch/ ./godot-4.0-alpha2/

# Get godot compilation dependencies
RUN apt-get install --no-install-recommends -y \
		build-essential \
		scons \
		pkg-config \
		libx11-dev \
		libxcursor-dev \
		libxinerama-dev \
		libgl1-mesa-dev \
		libglu-dev \
		libasound2-dev \
		libpulse-dev \
		libudev-dev \
		libxi-dev \
		libxrandr-dev \
		&& apt-get clean

# Compile Godot
RUN cd godot-4.0-alpha2 \
	&& scons -j6 \
		platform=x11 \
		module_webm_enabled=no \
		tools=yes \
		target=release_debug \
		use_llvm=yes \
		CCFLAGS="-mtune=cortex-a72 -mcpu=cortex-a72 -mfloat-abi=hard -mlittle-endian -munaligned-access -mfpu=neon-fp-armv8"

ENTRYPOINT ["/bin/bash", "-c", "source ~/vk_icd.sh; ./godot-4.0-alpha2/bin/godot.linuxbsd.opt.tools.64.llvm"]

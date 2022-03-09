FROM debian:sid as mesa_builder

WORKDIR /Build

# Get some dependencies
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		curl \
		git \
		sudo

# Get mesa compilation script and run
RUN curl -s https://raw.githubusercontent.com/karnkaul/rpi4-install-vulkan/14b658cdb24d297398890ef247f38262e93d0e7f/install_vulkan.sh \
	| /bin/bash



FROM debian:sid as godot_builder

WORKDIR /Build

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		curl \
		clang \
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
		libxrandr-dev

# Get Godot sources
RUN curl https://downloads.tuxfamily.org/godotengine/4.0/alpha3/godot-4.0-alpha3.tar.xz \
	| tar --extract --xz

# Apply my simple sse2neon patch to Godot sources
COPY ./sse2neon_patch/ ./godot-4.0-alpha3/

# Compile Godot
RUN cd godot-4.0-alpha3 \
	&& scons -j6 \
		platform=linuxbsd \
		module_webm_enabled=no \
		tools=yes \
		target=release_debug \
		use_llvm=yes \
		CCFLAGS="-march=armv8-a+crc+simd -mtune=cortex-a72 -ftree-vectorize -O2 -pipe -fomit-frame-pointer -mfloat-abi=hard -mlittle-endian -munaligned-access"



FROM debian:sid

RUN useradd -m godot
USER godot
WORKDIR /home/godot

COPY --from=mesa_builder /root/mesa_vulkan /home/godot/mesa_vulkan
COPY --from=mesa_builder /root/vk_icd.sh /home/godot/vk_icd.sh
COPY --from=godot_builder /Build/godot-4.0-alpha3/bin/godot.linuxbsd.opt.tools.64.llvm /opt/Godot/godot

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
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
		xorg-dev \
		libvulkan-dev \
		libvulkan1 \
		vulkan-tools \
		ninja-build \
		clang \
		lld \
	&& apt-get clean

ENTRYPOINT ["/bin/bash", "-c", "source ~/vk_icd.sh; /opt/Godot/godot"]

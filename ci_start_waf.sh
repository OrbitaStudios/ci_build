#!/bin/bash
#// Copyright (C) 2025 Orbita Studios.
#//
#// This file is part of the Lambda Complex: Source, and other Orbita Studios' projects.  
#// This library is free software; you can redistribute it and/or modify it under the
#// terms of the GNU General Public License as published by the
#// Free Software Foundation; either version 3, or (at your option)
#// any later version.
#
#// This library is distributed in the hope that it will be useful,
#// but WITHOUT ANY WARRANTY; without even the implied warranty of
#// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#// GNU General Public License for more details.

export OS_NAME_CI=$(cat /etc/os-release | grep "ID=")
export OS_OVERRIDE_EMSCRIPTEN="false"

if [[ $OS_NAME_CI == "debian" ]]; then
	# Required to enable *:i386 packages
	dpkg --add-architecture i386
	sudo apt-get update && apt-get install libsdl2-dev:i386 libfreetype6-dev:i386 libfontconfig1-dev:i386 libopenal-dev:i386 libjpeg-dev:i386 libpng-dev:i386 libcurl4-gnutls-dev:i386 libbz2-dev:i386 libedit-dev:i386 build-essential gcc-multilib g++-multilib pkg-config ccache clang clang++
	if [[ $OS_OVERRIDE_EMSCRIPTEN == "true" ]]; then
		sudo apt-get install emscripten
	fi
elif [[ $OS_NAME_CI == "arch" ]]; then
	sudo pacman -Syu lib32-gcc-libs lib32-sdl2 lib32-freetype2 lib32-fontconfig lib32-zlib lib32-bzip2 lib32-libjpeg lib32-libpng lib32-curl lib32-openal lib32-opus clang clang++
	if [[ $OS_OVERRIDE_EMSCRIPTEN == "true" ]]; then
		sudo pacman -S emscripten
	fi
fi

cd src

if [[ $OS_OVERRIDE_EMSCRIPTEN == "true" ]]; then
	CC=emcc CXX=em++ ./waf configure -T debug -8
else
	CC=clang CXX=clang++ ./waf configure -T debug
fi
./waf build

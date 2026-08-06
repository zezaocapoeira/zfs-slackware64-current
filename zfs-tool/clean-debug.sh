#!/bin/sh


(cd /usr/src/linux

echo "Cleaning up..."

make clean
# Make sure header files aren't missing...
make prepare

# clang support
#make CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1 prepare

# Don't package the kernel in the sources:
find . -name "*Image" -exec rm "{}" \+

find . -name "*.cmd" -exec rm -f "{}" \+ 
rm .*.d
# Still some dotfiles laying around... probably fine though
# Get rid of any ELF (non-eBPF) binaries that are not executable:
find . -type f -perm 0644 ! -name "*.c" ! -name "*.h" ! -name "*.S" ! -name "*.dts*" ! -name "Makefile*" ! -name Kbuild ! -name "*config" ! -name ".git*" ! -name "*.rst" ! -name "*.txt" | xargs file | grep ELF | grep -v eBPF | grep stripped | cut -f 1 -d : | while read elf_binary ; do
rm -f -v $elf_binary
done 
# Strip any remaining binaries:
find . -type f ! -name "*.c" ! -name "*.h" ! -name "*.S" ! -name "*.dts*" ! -name "Makefile*" ! -name Kbuild ! -name "*config" ! -name ".git*" ! -name "*.rst" ! -name "*.txt" | xargs file | grep -e "executable" -e "shared object" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
)

mkdir -p build/isoroot/boot/grub
echo 'menuentry "Nexera" {
    multiboot /boot/kernel.bin
    boot
}' > build/isoroot/boot/grub/grub.cfg

nasm -f elf -o build/loader.o kernel/loader/loader.asm
mcs /target:exe /out:build/kernel.exe /unsafe kernel/kernel.cs
mono utils/tysila/tysila2.exe --arch i586-elf-tysos -fno-rtti -o build/kernel.o build/kernel.exe
ld -m elf_i386 -T utils/linker.ld -o build/isoroot/boot/kernel.bin build/loader.o build/kernel.o
grub-mkrescue -o build/image.iso build/isoroot
qemu-system-i386 -cdrom build/image.iso
rm -rf build
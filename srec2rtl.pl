#!/usr/bin/perl -w
################################################################
# Generate RTL file from srec (Motorola S-format)
# 
# usage:
#     $ or32-uclinux-objcopy -O srec hello.o hello.srec
#     $ ./srec2rtl.pl hello.srec
################################################################
use strict;

my($codes, $i, $offset, $opecode);
my($b0, $b1, $b2, $b3);
my(@bank0, @bank1, @bank2, @bank3);
my($address);

&OpenRtlFiles();
while (<>) {
    #print STDERR;
    chomp;
    if (!(($_,$address,$codes) = (/^S1(\S{2})([0-9A-F]{4})(\S+)\S{2}/g))) {
	next;
    }
    $address = hex $address;
    for ($i = 0; 1; $i++) {
	$offset = 8 * $i;
	if ($opecode = substr($codes, $offset, 8)) {
	    ($b0, $b1, $b2, $b3) = ($opecode =~ /(\S{2})(\S{2})(\S{2})(\S{2})/);
	    # printf STDERR "%x: %s%s%s%s %04x\n", $i, $b0, $b1, $b2, $b3, $address;
 	    printf B0V "mem[%d] <= 8'h%s;\n", $address >> 2, $b0;
 	    printf B1V "mem[%d] <= 8'h%s;\n", $address >> 2, $b1;
 	    printf B2V "mem[%d] <= 8'h%s;\n", $address >> 2, $b2;
 	    printf B3V "mem[%d] <= 8'h%s;\n", $address >> 2, $b3;
	    $address += 4;
	} else {
 	    #print STDERR;
	    last;
	}
    }
}
&CloseRtlFiles();

################################################################
sub OpenRtlFiles {
    open(B0V, ">onchip_ram_bank0.v");
    open(B1V, ">onchip_ram_bank1.v");
    open(B2V, ">onchip_ram_bank2.v");
    open(B3V, ">onchip_ram_bank3.v");
}

sub CloseRtlFiles {
    close(B0V);
    close(B1V);
    close(B2V);
    close(B3V);
}

#!/usr/bin/perl -w
################################################################
# Generate Memory Initialization File (.mif) file from srec (Motorola S-format)
# 
# usage:
#     $ or32-uclinux-objcopy -O srec hello.o hello.srec
#     $ ./srec2mem.pl hello.srec
################################################################
use strict;

my($codes, $i, $offset, $opecode);
my($b0, $b1, $b2, $b3);
my(@bank0, @bank1, @bank2, @bank3);
my($address, @SrecAddress, $MifAddress);

&OpenMifFiles();
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
	    #printf STDERR "%x: %s%s%s%s %04x\n", $i, $b0, $b1, $b2, $b3, $address;
	    printf B0MIF "%04x : %s;\n", $address >> 2, $b0;
	    printf B1MIF "%04x : %s;\n", $address >> 2, $b1;
	    printf B2MIF "%04x : %s;\n", $address >> 2, $b2;
	    printf B3MIF "%04x : %s;\n", $address >> 2, $b3;
	    $address += 4;
	} else {
 	    #print STDERR;
	    last;
	}
    }
}
&CloseMifFiles();


################################################################
sub OpenMifFiles {
    open(B0MIF, ">onchip_ram_bank0.mif");
    open(B1MIF, ">onchip_ram_bank1.mif");
    open(B2MIF, ">onchip_ram_bank2.mif");
    open(B3MIF, ">onchip_ram_bank3.mif");
    print B0MIF "WIDTH=8;\nDEPTH=4096;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\n\nCONTENT\nBEGIN\n";
    print B1MIF "WIDTH=8;\nDEPTH=4096;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\n\nCONTENT\nBEGIN\n";
    print B2MIF "WIDTH=8;\nDEPTH=4096;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\n\nCONTENT\nBEGIN\n";
    print B3MIF "WIDTH=8;\nDEPTH=4096;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\n\nCONTENT\nBEGIN\n";
}

sub CloseMifFiles {
    print(B0MIF "END;");
    print(B1MIF "END;");
    print(B2MIF "END;");
    print(B3MIF "END;");
    close(B0MIF);
    close(B1MIF);
    close(B2MIF);
    close(B3MIF);
}

=c
objdump2shellcode 
This uses a binary and objdump to get the opcodes
parse-it and print the C code with the shellcode.
ex: http://pastebin.com/ghzfy5sT
=cut
#!/usr/bin/perl
use strict;
use warnings;
print "\t$0 by m0nad\n";
my $file = shift || die "usage:\n  perl $0 ./binary\n";
my @dump = `objdump -d $file`;
print "const char sc[] =\n";
foreach (@dump) {
  my ($opcode, $instruction) = (split /\t/)[1,2];
  next unless $opcode;
  chomp $instruction;
  print "\""; 
  my @opcodes = split / /, $opcode;
  foreach (@opcodes) {
    next if /^[\s\t]+$/;
    print "\\x$_";  
  }
  print "\"\t//$instruction\n";
}
print ";
int
main()
{
  __asm__(\"jmp sc\");
  return 0;
}
";


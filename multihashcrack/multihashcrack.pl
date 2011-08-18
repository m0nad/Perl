=cut
              _ _   _                 _       ___               _    
  /\/\  _   _| | |_(_) /\  /\__ _ ___| |__   / __\ __ __ _  ___| | __
 /    \| | | | | __| |/ /_/ / _` / __| '_ \ / / | '__/ _` |/ __| |/ /
/ /\/\ \ |_| | | |_| / __  / (_| \__ \ | | / /__| | | (_| | (__|   < 
\/    \/\__,_|_|\__|_\/ /_/ \__,_|___/_| |_\____/_|  \__,_|\___|_|\_\

  by m0nad at email.com

Cracks multiple hash functions using a wordlist.
=cut
use warnings;use strict;
use Digest::SHA qw(sha1_hex sha256_hex sha384_hex sha512_hex); 
use Digest::MD5 qw(md5_hex);
use Getopt::Long;
sub banner
{
  print q!
              _ _   _                 _       ___               _    
  /\/\  _   _| | |_(_) /\  /\__ _ ___| |__   / __\ __ __ _  ___| | __
 /    \| | | | | __| |/ /_/ / _` / __| '_ \ / / | '__/ _` |/ __| |/ /
/ /\/\ \ |_| | | |_| / __  / (_| \__ \ | | / /__| | | (_| | (__|   < 
\/    \/\__,_|_|\__|_\/ /_/ \__,_|___/_| |_\____/_|  \__,_|\___|_|\_\

  by m0nad at email.com

!;

}
sub usage
{
  die "
options:	description:

--md5           to crack md5 hash function.
--sha1		to crack sha1 hash function.
--sha256	to crack sha256 hash function.
--sha384	to crack sha384 hash function.
--sha512	to crack sha512 hash function.

--verbose	to active verbose mode.

usage:
  perl $0 <hash function> <hash> <wordlist> 
  perl $0 --sha1 a94a8fe5ccb19ba61c4c0873d391e987982fbbd2 wordlist.wl\n\n";

}

banner();

my $opt = {};
my $func = undef;
my $hash = undef;
my $file = undef;

GetOptions(
  "md5" => \$opt->{md5},
  "sha1" => \$opt->{sha1},
  "sha256" => \$opt->{sha256},
  "sha384" => \$opt->{sha384},
  "sha512" => \$opt->{sha512},
  "verbose" => \$opt->{verbose},
);
$hash = shift;
$file = shift || usage();

if (defined $opt->{md5}) {
  $func = \&md5_hex;
  die "This not look like a md5 hash\n" if $hash !~ /^[A-Fa-f0-9]{32}$/;
} 
elsif (defined $opt->{sha1}) {
  $func = \&sha1_hex;
  die "This not look like a sha1 hash\n" if $hash !~ /^[A-Fa-f0-9]{40}$/;
} 
elsif (defined $opt->{sha256}) {
  $func = \&sha256_hex;
  die "This not look like a sha256 hash\n" if $hash !~ /^[A-Fa-f0-9]{64}$/;
}
elsif (defined $opt->{sha384}) {
  $func = \&sha384_hex;
  die "This not look like a sha384 hash\n" if $hash !~ /^[A-Fa-f0-9]{96}$/;
}
elsif (defined $opt->{sha512}) {
  $func = \&sha512_hex;
  die "This not look like a sha512 hash\n" if $hash !~ /^[A-Fa-f0-9]{128}$/;
} else {
  usage();
}

open my $FH, '<', $file or die "$!\n";
while (<$FH>) {
  chomp;
  if (&$func($_) eq $hash) { 
    print "Hash found!!!\n$hash = $_\n\n";  
    close $FH;
    exit;
  } elsif (defined $opt->{verbose}) {
    print $hash . " != " . &$func($_) . "\n" ;
  } 
}
print "Hash not found.\n\n";
close $FH;

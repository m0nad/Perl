#!/usr/bin/perl
#simple port range tcp connect() portscan in perl
#by m0nad /at/ email.com
use Socket;
use warnings;
use strict;

die qq!\nuso:$0 <host> <initial port> <final port>\n\n! if ($#ARGV < 2);

my ($host, $porta_i, $porta_f) = @ARGV ;

my $proto = getprotobyname ('tcp');
my $iaddr = inet_aton ($host);

my $hostname  = gethostbyaddr ($iaddr, AF_INET);
#my $packed_ip = gethostbyname ($host);
my $ip = inet_ntoa ($iaddr);

socket (my $SOCK, AF_INET, SOCK_STREAM, $proto);

print "PortScan report for : " ;
print "$hostname " if (defined $hostname);
print "($ip)" if (defined $ip);
print "\n";
print "\nPORT\tESTATE\tSERVICE\n";

for ($porta_i..$porta_f) { 
  my $porta = $_;
  my $paddr = sockaddr_in ($porta, $iaddr);
  if (connect ($SOCK, $paddr)) {
    my $servico = getservbyport ($porta,'tcp') || "unknown" ; 
    print "$porta\taberto\t\"$servico\"\n";
  }
	
}
close $SOCK;
print "\nScan finished!\n"; 

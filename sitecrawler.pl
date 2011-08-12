#!/usr/bin/perl

#m0nad SiteCrawler
#using WWW::Mechanize
#extract urls from a site by crawling him 
#by m0nad [at] email.com
use URI;
use WWW::Mechanize;
use warnings; use strict;

banner();
crawl(http (shift || usage()));

sub usage
{
  die "usage :\n  perl $0 http://site-seed\n";
}
sub banner
{
  print "
SiteCrawler
  by m0nad [at] email.com\n\n";
}
sub crawl
{
  my @urls = shift || return;
  my %seen = (); 
  my @links = ();
  
  while (my $link = shift @urls) { 
    next if $seen{$link}++; 

    print $link . "\n";
    @links = urlparser($link);

    push @urls, @links;
  }

}

sub urlparser
{
  my $base_url = shift;
  my $host = host($base_url);
  my $mech = WWW::Mechanize->new();
  eval { $mech->get($base_url); };
  return if ($@);
  my @links = $mech->links();

  my %seen = ();
  foreach my $link (@links) {
    my $url = $link->url_abs();
    next if $url eq $base_url;
    my $hurl;
    eval { $hurl = host($url); };
    next unless $hurl;
    if ($hurl =~ $host) {
      next if $seen{$url}++;
    }
  }
  return keys %seen;
}


sub host 
{
  return URI->new(shift || return)->host();
}

sub http
{
  my $h = shift || return;

  $h = 'http://' . $h if $h !~ /^https?:/ ;
  return $h;
}

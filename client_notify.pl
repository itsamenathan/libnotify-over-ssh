#!/usr/bin/perl -w
use strict;
use IO::Socket;

my $tag = shift || $ARGV[0];
my $title = shift || $ARGV[1];
my $summary  = shift || $ARGV[2];

my $HOST = '127.0.0.1';
my $PORT = '1216';

my $sock = new IO::Socket::INET(
    PeerAddr    => $HOST,
    PeerPort    => $PORT,
    Proto        => 'tcp',
) or exit;
 
$sock->autoflush(1);
 
#print $sock "\"$title\" \"$summary\"\n";
if($tag && $title && $summary){
  print $sock $tag."\n";
  print $sock $title."\n";
  print $sock $summary."\n";
}

close $sock;

#!/usr/bin/perl -w
use strict;
use IO::Socket;
sub message;

$SIG{CHLD} = 'IGNORE'; #automatic child reaping

my $weechat_icon='/home/jimshoe/dev/libnotify-over-ssh/weechat_icon.png';
my $HOST = '127.0.0.1';
my $PORT = '1216';

my $sock = new IO::Socket::INET(
    LocalHost    => $HOST,
    LocalPort    => $PORT,
    Proto        => 'tcp',
    Listen        => SOMAXCONN,
    Reuse        => 1
    ) or die "no socket :$!";
my ($new_sock, $c_addr, $buf);
$sock->autoflush(1);
while (($new_sock, $c_addr) = $sock->accept()) {
  my ($client_port, $c_ip) = sockaddr_in($c_addr);
  my $client_ipnum = inet_ntoa($c_ip);
  my $client_host =gethostbyaddr($c_ip, AF_INET);
  my $pid = fork();
  print "Cannot fork : $!\n" unless (defined($pid));

  if ($pid == 0) {
    my ($tag, $title, $summary,$x);
    while (defined ($buf = <$new_sock>)) {
      chomp $buf;
      $x++;
      if($x == 1){$tag = $buf;}
      if($x == 2){$title = $buf;}
      if($x == 3){
        $summary = $buf;
        message($tag,$title,$summary);
      }
    }
    exit(0);
  }
}

sub message ($$$) {
  my $tag = $_[0];
  my $title = $_[1];
  my $summary = $_[2];
  if($tag eq 'weechat'){
    # see if weechat has focus, if not, send notification.  Depends on terminal name starting with weechat
    my $focus = `xwininfo -tree -id \$(xdpyinfo | awk '/focus/ {gsub(",", "", \$3); print \$3}') | grep Parent | awk -F\\" '{print \$2}'`;
    if ($focus !~ /^weechat /){
      $title =~ s/[<&]//g; # remove some characters that libnotify hates
      $summary =~ s/[<&]//g;
      my @args = ('/usr/bin/notify-send', $title, $summary, "--icon=$weechat_icon");
      exec @args;
    }
  }
  if($tag eq 'system'){
    $title =~ s/[<&]//g; # remove some characters that libnotify hates
    $summary =~ s/[<&]//g;
    my @args = ('/usr/bin/notify-send', $title, $summary);
    exec @args;
  }
}

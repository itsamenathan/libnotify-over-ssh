README for libnotify-over-ssh
=============

Summary
-------------
This is a client server perl script I wrote so that my server could essentially send libnotify messages to my local machine.  
I use this mainly with weechat but has a feature to make it more general.  When calling the client with the weechat tag the 
server checks the name of the current focused window.  If it starts with weechat, notifications are suppressed if not notify-send 
is called.

My Working Environment
-------------
### Local Machine
* Debian Testing
* Gnome-Terminal - 2.30.2
* libnotify-bin - 0.5.0-2
* perl - 5.10.1
* openssh - 1:5.5p1-6

### Server
* Debian Testing
* Weechat 0.3.2
* perl - 5.10.1
* openssh - 1:5.5p1-6

How it works
-------------
1. server_notify.pl is always running on your localmachine
2. SSH remote port forward is forwarding a port from our local machine so that the remote machine can access it.
3. client_notify.pl is called on our server with three command line arguments - "tag" "title" "summary"
4. client_notify.pl sends each argument to server_notify.pl through our remote port forward.
5. server_notify.pl calls notify-send using data is received from client_notify.pl

Usage
-------------
./client_notify.pl "tag" "title" "summary"
    * tag     - A string that lets you distinguish messages 
    * title   - This is the first string to be passed to notify-send
    * summary - This is the second string to be passed to notify-send

My Setup
-------------
### Local Machine
* added server_notify.pl to my startup apps.  In Gnome this is System -> Preferences -> Startup Application
* edited .ssh/config and added "RemoteForward 1216 127.0.0.1:1216" to my server connection.
* this works also ssh -L 1216:120.0.0.1:1216 user@host

### Server
* copy client_notify.pl somewhere it can be called easily.
* call client_notify.pl from weechat using the tag "weechat".
    As explained in the summary this will cause the server to check the name of the windows in focus.  If
    it starts with weechat then the notification isn't sent. This way I can sent all PM's and mentions to my 
    local machine.
    calling client_notify.pl using the tag "system" will always display the notification.

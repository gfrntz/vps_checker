#!/usr/bin/perl -w

use strict;
use HTTP::Request;
use LWP::UserAgent;
use Getopt::Long;
use JSON::Any;

my ($verbose, $check, $action, $file, $help, $result);

$result = GetOptions ("verbose" => \$verbose,
					  "check" => \$check,
					  "action=s" => \$action,
					  "file=s" => \$file,
					  "help" => \$help);

# ACTIONS:
# start - start vps from file
# stop - stop vps from file
# getstate - get vps status from file
# restart - restart vps from file
					  
# OPTIONS:
# vesbose - verbose mode on
# check - check runing vps and services
# action - action 
# file - path to file whith vps numbers & id's
# help - call for help

# STATUS RESPONSE:
# error status - error  
# stop status- stop 
# running status - r 
# install status - install 
# backup status - backup 
# restore status - restore
my $get_dc = " https://api.clodo.ru/v1/system/dcs";
my $vps_status = "/v1/system/vpsstatus/?vps=";  
my $vps_start = "/v1/system/vpsstart/?vps=";
my $vps_stop = "/v1/system/vpsstop/?vps=";
my $vps_restart = "/v1/system/vpsrestart/?vps=";
my $https = "https://";

my $ua = LWP::UserAgent->new;
   $ua->timeout(10);

die ("Option --file and --actions must be!\n") if !defined $file or !defined $action;

$check = 1 if $action =~ m/(start|stop|restart)/;

open (FILE, "<", "$file") or die ("Can't open file or file does not exist.\n");

chomp(my @vps_id_array = <FILE>);

close(FILE);

print "@vps_id_array\n" if $verbose;


sub GET {
	
	$_ = shift;
	
	my $response = $ua->get($_);

	if ($response->is_success) {
		my $res = $response->content;  # or whatever
		print "response is - $res\n";
	}
	
	else {
		die $response->status_line;
	}
}


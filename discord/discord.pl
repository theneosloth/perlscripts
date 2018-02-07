#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use Modern::Perl;

use HTTP::Tiny;

use JSON qw( decode_json );     # From CPAN

my $webhook_id = $ENV{DISCORD_WEBHOOK_ID} or $ARGV[0] or die "Error: No webhook id set.";
my $webhook_token = $ENV{DISCORD_WEBHOOK_TOKEN} or $ARGV[1] or die "Error: No webhook token set.";
my $url = "https://discordapp.com/api/webhooks/$webhook_id/$webhook_token";

my $message = "Hello World.";
my $payload = qq({"content": "$message"});
my $response = HTTP::Tiny->new->request('POST', $url, { content => $payload, headers => { 'content-type' => 'application/json' } });

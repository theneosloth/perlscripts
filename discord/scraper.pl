#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use Modern::Perl;

use HTTP::Tiny;

use JSON qw( decode_json );

my $filename = "lastchecked";



my $subreddit = $ENV{SCRAPER_SUBREDDIT} // $ARGV[0] // die "Error: No subreddit provided.";
my $webhook_id = $ENV{DISCORD_WEBHOOK_ID} // $ARGV[1] // die "Error: No webhook id set.";
my $webhook_token = $ENV{DISCORD_WEBHOOK_TOKEN} // $ARGV[2] // die "Error: No webhook token set.";
my $webhook_url = "https://discordapp.com/api/webhooks/$webhook_id/$webhook_token";


unless (-e $filename){
    open my $fc, ">", $filename or die "Cannot write the date file.";
    print $fc time();
    close $fc;
}

open my $fc, "<", $filename or die "Date file not found.";
my $last_checked = <$fc>;

my $url = "https://www.reddit.com/r/$subreddit/new/.json";

my $json_request = HTTP::Tiny->new->get($url);
die "Couldn't download the json." unless $json_request->{success};
my $json = $json_request->{content};

my $json_text = JSON->new->allow_nonref->utf8->relaxed->decode($json) or die "Could not decode the JSON.";

my $posts = $json_text->{data}->{children};

foreach my $post (reverse @$posts) {
    $post = $post -> {data};
    my $date = $post -> {created_utc};

    die "Improper date provided" unless $date =~/\d+/;

    if ($date > $last_checked){
        my $title = $post -> {title};
        my $author = $post -> {author};
        my $url = $post -> {url};


        # Replace double quotes
        $title =~ s/"/'/g;
        $author =~ s/"/'/g;

        $title =~ s/[^[:ascii:]]//g;
        $author =~ s/[^[:ascii:]]//g;

        say "$title is new. Posting a message";

        my $message = qq(**$title** by *$author* \\n $url);
        my $payload = qq({"content": "$message"});
        my $response = HTTP::Tiny->new->request('POST', $webhook_url,
                                                { content => $payload, headers => { 'content-type' => 'application/json' } });
        die "Couldn't post a message!\n" . $response ->{content} unless $response->{success};

        open my $fc, ">", $filename;
        print $fc $date;
        close $fc;

        $last_checked = $date;
    }

}

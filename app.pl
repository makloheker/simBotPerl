#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use LWP::Protocol::https;  

sub send_request {
    my ($input_text) = @_;
    
    my $url = 'https://api.simsimi.vn/v1/simtalk';
    my $ua = LWP::UserAgent->new;
    
    $ua->agent('Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36');

    my $headers = [
        'Content-Type' => 'application/x-www-form-urlencoded',
    ];

    my $response = $ua->post(
        $url,
        $headers,
        Content => [
            text => $input_text,
            lc   => 'id',
        ],
    );

    if ($response->is_success) {
        my $response_content = $response->decoded_content;
        my $response_data = decode_json($response_content);
        return $response_data->{message};
    } else {
        warn "failed to get response " . $response->status_line;
        return undef;
    }
}

while (1) {
    print "you>: ";
    my $input_text = <STDIN>;
    chomp($input_text);

    if ($input_text =~ /^(exit|quit|keluar|murtad)$/i) {
        print "byeee...\n";
        last;
    }

    my $response_message = send_request($input_text);
    if (defined $response_message) {
        print "bot>: $response_message\n";
    } else {
        print "error bang\n";
    }
}

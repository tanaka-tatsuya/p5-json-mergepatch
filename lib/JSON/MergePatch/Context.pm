package JSON::MergePatch::Context;
use 5.008005;
use strict;
use warnings;

use JSON;

our $VERSION = "0.01";

sub purge_nulls {
    my ($instance) = @_;

    if ( not ref $instance ) {
        return $instance;
    }
    elsif ( ref $instance eq 'ARRAY' ) {
        return [ map { purge_nulls($_) } grep { defined $_ } @$instance ];
    }
    elsif ( ref $instance eq 'HASH' ) {
        return +{ map { $_ => purge_nulls($instance->{$_}) } grep { defined $instance->{$_} } keys %$instance };
    }
    else {
        die 'instance is invalid';
    }
}

1;

package Test::JSON::MergePatch::Suite;
use strict;
use warnings;

use File::Spec;
use JSON;

use Test::More;
use Test::Deep;

sub run {
    my ($class, %args) = @_;

    my ($suite, $version) = @args{qw/ suite version /};

    my $self = bless +{
        base_dir => File::Spec->catdir( Fiel::Spec->no_upwards( dirname(__FILE__), '../../../../suite/tests') ),
        version  => $version || "draft2",
    }, $class;

    my $test_suite = $self->load_test_suite($suite);

    for my $test_cases ( @$test_suite ) {
        $self->run_test_cases($test_cases);
    }

    done_testing;
}

sub _merge {
    my ($self, $doc, $patch) = @_;
    #TODO: implement
}

sub run_test_cases {
    my ($self, $test_cases) = @_;

    my ($description, $tests) = @$test_cases{qw/ description tests /};

    subtest $description => sub {
        $self->run_test_case($_) for @$tests;
    };
}

sub run_test_case {
    my ($self, $test_case) = @_;

    my ($description, $doc, $patch, $expect)
        = @$test_case{qw/ description doc patch expect /};

    cmp_deeply(
        $self->_merge( $doc, $patch ),
        $expect,
        $description,
    );
}

sub load_test_suite {
    my ($self, $suite) = @_;
    my $test_suite_file = File::Spec->catfile(
        $self->{base_dir}, $self->{version}, sprintf("%s.json", $suite)
    );

    note "loading $test_suite_file";

    open (my $fh, "<", $test_suite_file) or croak $!;
    my $test_suite = decode_json( do { local $/; <$fh> } );
    close $fh;
    return $test_suite;
}

1;

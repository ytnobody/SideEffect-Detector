use strict;
use warnings;
use Test::More;
use SideEffect::Detector;

my $x = sub {
    open my $fh, '<', __FILE__;
    my $data = join('', <$fh>);
    close $fh;
    return $data;
};

SideEffect::Detector->detect($x);

ok 1;
done_testing;

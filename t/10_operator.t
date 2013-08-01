use strict;
use warnings;
use Test::More;
use Test::Exception;
use SideEffect::Detector;

throws_ok {SideEffect::Detector->detect('my $c = 2; $c++;')} qr/\+\+/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c--;')} qr/\-\-/;
throws_ok {SideEffect::Detector->detect('my $c = 2; ++$c;')} qr/\+\+/;
throws_ok {SideEffect::Detector->detect('my $c = 2; --$c;')} qr/\-\-/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c += 1;')} qr/\+\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c -= 1;')} qr/\-\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c *= 1;')} qr/\*\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c /= 1;')} qr/\/\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c %= 1;')} qr/\%\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c **= 1;')} qr/\*\*\=/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = $c + 1;')} qr/same variable/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = $c - 1;')} qr/same variable/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = $c / 1;')} qr/same variable/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = 1 * $c;')} qr/same variable/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = $c ** 1;')} qr/same variable/;
throws_ok {SideEffect::Detector->detect('my $c = 2; $c = $c % 1;')} qr/same variable/;

done_testing;

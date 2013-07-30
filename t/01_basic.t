use strict;
use warnings;
use Test::More;
use Test::Exception;
use SideEffect::Detector;

my $x = <<'EOF';
open my $fh, '<', __FILE__;
my $data = join('', <$fh>);
close $fh;
return $data;
EOF

throws_ok { SideEffect::Detector->detect($x) } qr/^a side-effect \"open\" near line 1, type is BuiltinFunc/;

done_testing;

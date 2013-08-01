package SideEffect::Detector::Rule::BuiltInFunc::Scalar;
use strict;
use warnings;

sub check {
    my ($class, $token, $context) = @_;
    if ($token->name eq 'BuiltInFunc' && $token->data =~ /^(chomp|chop)$/) {
        $context->{error} = $token; 
        $context->{reason} = 'chomp / chop make change to value for variable';
    }
    return $context;
}

1;

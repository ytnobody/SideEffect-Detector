package SideEffect::Detector::Rule::Operator;
use strict;
use warnings;

sub check {
    my ($class, $token, $context) = @_;
    if ($class->is_destractive_operator($token)) {
        $context->{error} = $token; 
        $context->{reason} = 'this operator make change to value for variable';
    }
    if ($class->has_destructive_assignment($token, $context)) {
        $context->{error} = $token;
        $context->{reason} = 'detected destructive assignment to same variable';
    }
    return $context;
}

sub is_destractive_operator {
    my ($class, $token) = @_;
    $token->name =~ /^(Inc|Dec|AddEqual|SubEqual|DivEqual|MulEqual|PowerEqual|ModEqual)$/;
}

sub has_destructive_assignment {
    my ($class, $token, $context) = @_;
    if ($token->name eq 'Var') {
        if ($context->{stack}{assign} ) {
            return $token if $context->{stack}{assign} eq $token->data;
        }
        else {
            $context->{stack}{var} = $token->data;
        }
    }
    elsif ($token->name eq 'Assign') {
        $context->{stack}{assign} = $context->{stack}{var};
        delete $context->{stack}{var};
    }
    elsif ($token->name eq 'SemiColon') {
        delete $context->{stack}{assign};
    }
    return 0;
}

1;

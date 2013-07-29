package SideEffect::Detector;
use 5.008005;
use strict;
use warnings;
use Carp;
use Compiler::Lexer;
use Data::Dumper::Concise;

our $VERSION = "0.01";

sub detect {
    my ($class, $code) = @_;
    my @caller = caller;
    my $lexer = Compiler::Lexer->new($caller[1]);
    my $tokens = $lexer->tokenize(Dumper($code));
    $class->_check_token($_) for @$tokens;
}

sub _check_token {
    my ($class, $token) = @_;
    local $Carp::CarpLevel = $Carp::CarpLevel + 2;
    if ($token->name =~ /^(Inc|Dec)$/) {
        $class->_raise_error($token);
    }
    elsif ($token->name eq 'BuiltinFunc' && $token->data =~ /^(open|pipe)/) {
        $class->_raise_error($token);
    }
    else {
        warn Dumper($token);
    }
}

sub _raise_error {
    my ($class, $token) = @_;
    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    croak sprintf('a side-effect "%s" near line %s, type is %s', $token->data, $token->line, $token->name);
}

1;
__END__

=encoding utf-8

=head1 NAME

SideEffect::Detector - It's new $module

=head1 SYNOPSIS

    use SideEffect::Detector;

=head1 DESCRIPTION

SideEffect::Detector is ...

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut


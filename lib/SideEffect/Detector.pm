package SideEffect::Detector;
use 5.008005;
use strict;
use warnings;
use Carp;
use Compiler::Lexer;
use Module::Pluggable search_path => ['SideEffect::Detector::Rule'], sub_name => 'rules', require => 1;

our $VERSION = "0.01";
our $ERROR;

sub detect {
    my ($class, $codestr) = @_;
    my @caller = caller;
    my $lexer = Compiler::Lexer->new($caller[1]);
    my $tokens = $lexer->tokenize($codestr);
    my $context = { stack => {}, error => undef, reason => undef, messages => [] };
    for my $token (@$tokens) {
        $context = $class->_check_token($token, $context);
    }
    return;
}

sub has_sideeffect {
    my ($class, $codestr) = @_;
    eval {$class->detect($codestr)};
    $ERROR = $@;
    return $@ ? 1 : 0;
}

sub _check_token {
    my ($class, $token, $context) = @_;
    local $Carp::CarpLevel = $Carp::CarpLevel + 2;
    for my $rule ($class->rules) {
        $context = $rule->check($token, $context);
        $class->_raise_error($context, $rule) if $context->{error};
    }
    $context->{error} = undef;
    $context->{reason} = undef;
    return $context;
}

sub _raise_error {
    my ($class, $context, $rule) = @_;
    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    my ($short_rule) = $rule =~ /^SideEffect::Detector::Rule::(.*)$/;
    my $token  = $context->{error};
    my $reason = $context->{reason} || 'unknown reason';
    croak sprintf('[%s] side-effect "%s" near line %s, because %s', $short_rule, $token->data, $token->line, $reason);
}

1;
__END__

=encoding utf-8

=head1 NAME

SideEffect::Detector - Detect Side-Effect from Code

=head1 SYNOPSIS

    use SideEffect::Detector;
    my $code = 'my $x = 2; $x = $x + 1;';
    if ( SideEffect::Detector->has_sideeffect($code) ) {
        print $SideEffect::Detector::ERROR."\n";
    }
    
    # or raise error when $code has side-effect
    
    SideEffect::Detector->detect($code); 

=head1 DESCRIPTION

SideEffect::Detector detects side-effect from supplied code.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut


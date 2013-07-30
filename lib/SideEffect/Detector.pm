package SideEffect::Detector;
use 5.008005;
use strict;
use warnings;
use Carp;
use Compiler::Lexer;

our $VERSION = "0.01";

use constant FUNC => {
    scalar   => [qw/chomp chop/],
    match    => [qw/study/],
    math     => [qw/rand srand/],
    array    => [qw/pop push shift unshift splice/],
    hash     => [qw/delete/],
    io       => [qw/binmode close closedir dbmclose dbmopen die eof fileno flock format getc print printf read readdir rewinddir seek seekdir select syscall sysread sysseek syswrite tell telldir truncate warn write/],
    filesys  => [qw/chdir chmod chown chroot fcntl glob ioctl link lstat mkdir open opendir readlink rename rmdir stat symlink umask unlink utime/],
    flow     => [qw/caller die dump eval exit goto redo wantarray/],
    scope    => [qw/caller local our use package/],
    misc     => [qw/formline local our reset undef wantarray/],
    proc     => [qw/alarm exec fork getpgrp getppid getpriority kill pipe setpgrp setpriority sleep system times wait waitpid/],
    mod      => [qw/do no package require use/],
    object   => [qw/bless dbmclose dbmopen package ref tie tied untie use/],
    sock     => [qw/accept bind connect getpeername getsockname getsockopt listen recv send setsockopt shutdown socket socketpair/],
    sysvproc => [qw/msgctl msgget msgrcv msgsnd semctl semget semop shmctl shmget shmread shmwrite/],
    userinfo => [qw/endgrent endhostent endnetent endpwent getgrent getgrgid getgrnam getlogin getpwent getpwnam getpwuid setgrent setpwent/],
    netinfo  => [qw/endprotoent endservent gethostbyaddr gethostbyname gethostent getnetbyaddr getnetbyname getnetent getprotobyname getprotobynumber getprotoent getservbyname getservbyport getservent sethostent setnetent setprotoent setservent/],
    time     => [qw/gmtime localtime time times/],
};

sub detect {
    my ($class, $codestr) = @_;
    my @caller = caller;
    my $lexer = Compiler::Lexer->new($caller[1]);
    my $tokens = $lexer->tokenize($codestr);
    $class->_check_token($_) for @$tokens;
}

sub _side_effect_funcs {
    my %func = FUNC;
    return map {@{$func{$_}}} keys %func;
}

sub _check_token {
    my ($class, $token) = @_;
    local $Carp::CarpLevel = $Carp::CarpLevel + 2;
    if ($token->name =~ /^(Inc|Dec)$/) {
        $class->_raise_error($token);
    }
    elsif ($token->name eq 'BuiltinFunc' && grep {$token->data eq $_} qw/open pipe/) {
        $class->_raise_error($token);
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


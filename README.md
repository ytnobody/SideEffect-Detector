# NAME

SideEffect::Detector - Detect Side-Effect from Code

# SYNOPSIS

    use SideEffect::Detector;
    my $code = 'my $x = 2; $x = $x + 1;';
    if ( SideEffect::Detector->has_sideeffect($code) ) {
        print $SideEffect::Detector::ERROR."\n";
    }
    

    # or raise error when $code has side-effect
    

    SideEffect::Detector->detect($code); 

# DESCRIPTION

SideEffect::Detector detects side-effect from supplied code.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>

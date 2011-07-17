package Data::ParseBinary::Stream::ChecksumReader;
use strict;
use warnings;

our @ISA = qw{Data::ParseBinary::Stream::StringRefReader Data::ParseBinary::Stream::WrapperBase};

sub new {
    my ($class, $sub_stream) = @_;
    my $string = '';
    my $self = $class->SUPER::new(\$string);
    $self->_warping($sub_stream);
    return $self;
}



1;
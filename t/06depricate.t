#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Data::ParseBinary qw{:all};
use Test::More;
$| = 1;

my $data;
my $string;
my $s;
my $s1;

$s = Range(3, 7, UBInt8("foo"));
eval { $data = $s->parse("\x01\x02") };
ok( $@ , "Range: Parse: Die on too few elements");
$data = [1..3];
$string = "\x01\x02\x03";
is_deeply($s->parse($string), $data, "Range: Parse: correct");
ok( $s->build($data) eq $string, "Range: Build: correct");
is_deeply($s->parse("\x01\x02\x03\x04\x05\x06\x07\x08\x09"), [1..7], "Range: Parse: correct data 2");
eval { $s->build([1,2]) };
ok( $@ , "Range: Build: Die on too few elements");
eval { $s->build([1..8]) };
ok( $@ , "Range: Build: Die on too many elements");
ok( $s->build([1..7]) eq "\x01\x02\x03\x04\x05\x06\x07" , "Range: Build: correct");

$s = GreedyRange(UBInt8("foo"));
$data = [1];
$string = "\x01";
is_deeply($s->parse($string), $data, "GreedyRange: Parse: correct1");
ok( $s->build($data) eq $string, "GreedyRange: Build: correct1");
$data = [1..3];
$string = "\x01\x02\x03";
is_deeply($s->parse($string), $data, "GreedyRange: Parse: correct2");
ok( $s->build($data) eq $string, "GreedyRange: Build: correct2");
$data = [1..6];
$string = "\x01\x02\x03\x04\x05\x06";
is_deeply($s->parse($string), $data, "GreedyRange: Parse: correct3");
ok( $s->build($data) eq $string, "GreedyRange: Build: correct3");
eval { $data = $s->parse("") };
ok( $@ , "GreedyRange: Parse: Die on too few elements");
eval{ $s->build([]) };
ok( $@, "GreedyRange: Build: dies on too few elements");

$s = OptionalGreedyRange(UBInt8("foo"));
$data = [];
$string = "";
is_deeply($s->parse($string), $data, "OptionalGreedyRange: Parse: empty");
ok( $s->build($data) eq $string, "OptionalGreedyRange: Build: empty");
$data = [1,2];
$string = "\x01\x02";
is_deeply($s->parse($string), $data, "OptionalGreedyRange: Parse: normal");
ok( $s->build($data) eq $string, "OptionalGreedyRange: Build: normal");

done_testing();

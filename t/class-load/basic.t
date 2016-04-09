use strict;
use warnings;

use Test::More;

# ABSTRACT: Basic class load tests

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Class::Load )], );
my $prereqs = $scanner->scan_string(
  q[
  use Class::Load;

  load_class("My::ClassA");
  try_load_class(q{My::ClassB});
  load_optional_class('My::ClassC');

]
)->as_string_hash;

my $diag_needed;

$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassA"}, "ClassA reported" );
$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassB"}, "ClassB reported" );
$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassC"}, "ClassC reported" );

if ($diag_needed) {
  diag explain $prereqs;
}

done_testing;


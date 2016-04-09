use strict;
use warnings;

use Test::More;

# ABSTRACT: Basic class load tests

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Module::Load )], );
my $prereqs = $scanner->scan_string(
  q[
  use Module::Load;

  load "My::ClassA";
  load My::ClassB;

  autoload "My::ClassC";
  autoload My::ClassD;
]
)->as_string_hash;

my $diag_needed;

$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassA"}, "ClassA reported" );
$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassB"}, "ClassB reported" );
$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassC"}, "ClassC reported" );
$diag_needed = 1 unless ok( exists $prereqs->{"My::ClassD"}, "ClassC reported" );

if ($diag_needed) {
  diag explain $prereqs;
}

done_testing;


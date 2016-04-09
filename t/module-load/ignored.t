use strict;
use warnings;

use Test::More;

# ABSTRACT: Basic class load tests

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Module::Load )], );
my $prereqs = $scanner->scan_string(
  q[
  use Module::Load;

  $thing->load("My::ClassA");
  load("My/ClassB");
  load("My/ClassC.pm");
  load("ClassD.pm");
]
)->as_string_hash;

my $diag_needed;

$diag_needed = 1 unless ok( !exists $prereqs->{"My::ClassA"}, "ClassA not reported" );
$diag_needed = 1 unless ok( !exists $prereqs->{"My/ClassB"}, "ClassB not reported" );
$diag_needed = 1 unless ok( !exists $prereqs->{"My/ClassC.pm"}, "ClassC not reported" );
$diag_needed = 1 unless ok( !exists $prereqs->{"ClassD.pm"}, "ClassD not reported" );

if ($diag_needed) {
  diag explain $prereqs;
}

done_testing;


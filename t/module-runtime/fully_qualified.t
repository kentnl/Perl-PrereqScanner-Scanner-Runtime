use strict;
use warnings;

use Test::More;

# ABSTRACT: Test Module::Runtime scanner

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Module::Runtime )], );
my $routed_code = <<"EOF";

require Module::Runtime;

Module::Runtime::require_module("Example1");
Module::Runtime::use_module("Example2");
Module::Runtime::use_module("Example3",5.6);
Module::Runtime::use_package_optimistically("Example4");
Module::Runtime::use_package_optimistically("Example5", 5.6);

EOF

my $prereqs  = $scanner->scan_string($routed_code)->as_string_hash;
my $hash_bad = undef;
for my $key ( 1 .. 5 ) {
  ok( exists $prereqs->{"Example$key"}, "FQ code required $key" ) or $hash_bad = 1;
}
for my $key ( 3, 5 ) {
  next unless exists $prereqs->{"Example$key"};
  unlike( $prereqs->{"Example$key"}, qr/^0$/, "FQ code required $key @ some version" ) or $hash_bad = 1;
}
if ($hash_bad) {
  diag explain $prereqs;
}
done_testing;


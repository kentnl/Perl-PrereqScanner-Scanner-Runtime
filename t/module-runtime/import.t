use strict;
use warnings;

use Test::More;

# ABSTRACT: Test Module::Runtime scanner

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Module::Runtime )], );

my $imported_code = <<"EOF";

use Module::Runtime;

require_module("Example1");
use_module("Example2");
use_module("Example3",5.6);
use_package_optimistically("Example4");
use_package_optimistically("Example5", 5.6);

EOF

my $prereqs  = $scanner->scan_string($imported_code)->as_string_hash;
my $hash_bad = undef;
for my $key ( 1 .. 5 ) {
  ok( exists $prereqs->{"Example$key"}, "Import code required $key" ) or $hash_bad = 1;
}
for my $key ( 3, 5 ) {
  next unless exists $prereqs->{"Example$key"};
  unlike( $prereqs->{"Example$key"}, qr/^0$/, "Import code required $key @ some version" ) or $hash_bad = 1;
}
if ($hash_bad) {
  diag explain $prereqs;
}

done_testing;


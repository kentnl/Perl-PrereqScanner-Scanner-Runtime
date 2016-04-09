use strict;
use warnings;

use Test::More;

# ABSTRACT: Test Module::Runtime scanner

use Perl::PrereqScanner;
my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Module::Runtime )], );

my $imported_code = <<"EOF";

use Module::Runtime;

require_module("Example1");
require_module(Example2 =>);
require_module('Example3');
require_module(q/Example4/);
require_module(qw( Example5 ));

require_module("Example6", 5);
require_module(Example7 => 5);
require_module('Example8', 5);
require_module(q/Example9/, 5);
require_module(qw( Example10 5));
require_module(qw( Example11 ), 5));

require_module "Example12";
require_module Example13 =>;
require_module 'Example14';
require_module q/Example15/;
require_module qw( Example16 );

require_module "Example17", 5;
require_module Example18 => 5;
require_module 'Example19', 5;
require_module q/Example20/, 5;
require_module qw( Example21 5);
require_module qw( Example22 ), 5;

EOF

my $prereqs  = $scanner->scan_string($imported_code)->as_string_hash;
my $hash_bad = undef;
for my $key ( 1 .. 22 ) {
  ok( exists $prereqs->{"Example$key"}, "Import code required $key" ) or $hash_bad = 1;
}
if ($hash_bad) {
  diag explain $prereqs;
}

done_testing;


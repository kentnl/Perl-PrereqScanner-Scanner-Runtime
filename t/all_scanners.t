use strict;
use warnings;

use Test::More;

use Perl::PrereqScanner;

my $scanner = Perl::PrereqScanner->new(
  extra_scanners => [qw( Runtime )],
);

my $reqs = $scanner->scan_string(q[
  use Module::Runtime;

  use_module('Example');
])->as_string_hash;

ok( exists $reqs->{'Example'}, 'Module::Runtime example found' ) or diag explain $reqs;

done_testing;



use strict;
use warnings;

use Test::More;

use Perl::PrereqScanner;

my $scanner = Perl::PrereqScanner->new( extra_scanners => [qw( Runtime )], );

my $reqs = $scanner->scan_string(
  q[
  use Module::Runtime;
  use Class::Load;

  use_module('Example');
  load_class('Example2');
]
)->as_string_hash;

ok( exists $reqs->{'Example'},  'Module::Runtime example found' ) or diag explain $reqs;
ok( exists $reqs->{'Example2'}, 'Class::Load example found' )     or diag explain $reqs;

done_testing;


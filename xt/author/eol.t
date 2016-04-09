use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.18

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/Perl/PrereqScanner/Scanner/Class/Load.pm',
    'lib/Perl/PrereqScanner/Scanner/Module/Load.pm',
    'lib/Perl/PrereqScanner/Scanner/Module/Runtime.pm',
    'lib/Perl/PrereqScanner/Scanner/Runtime.pm',
    't/00-compile/lib_Perl_PrereqScanner_Scanner_Class_Load_pm.t',
    't/00-compile/lib_Perl_PrereqScanner_Scanner_Module_Load_pm.t',
    't/00-compile/lib_Perl_PrereqScanner_Scanner_Module_Runtime_pm.t',
    't/00-compile/lib_Perl_PrereqScanner_Scanner_Runtime_pm.t',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/all_scanners.t',
    't/class-load/basic.t',
    't/module-load/basic.t',
    't/module-load/ignored.t',
    't/module-runtime/fully_qualified.t',
    't/module-runtime/import.t',
    't/module-runtime/import_bare.t',
    't/module-runtime/noimport.t',
    't/module-runtime/quotestyles.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;

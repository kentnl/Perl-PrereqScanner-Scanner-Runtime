use 5.006;    # our
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Runtime;

our $VERSION = '0.001000';

# ABSTRACT: Detect various kinds of run-time prerequisites

# AUTHORITY

use Moose qw( with );
use Perl::PrereqScanner::Scanner::Module::Runtime;

with 'Perl::PrereqScanner::Scanner';

__PACKAGE__->meta->make_immutable;
no Moose;

=for Pod::Coverage scan_for_prereqs

=cut

sub scan_for_prereqs {    ## no critic (RequireArgUnpacking)
  Perl::PrereqScanner::Scanner::Module::Runtime->scan_for_prereqs(@_);
  return;
}

1;

=head1 SYNOPSIS

  use Perl::Prereq::Scanner;
  my $scanner = Perl::Prereq::Scanner->new(
    extra_scanners => [qw( Runtime )],
  );

=head1 DESCRIPTION

This distribution contains a collection of various run-time scanners,
intended to expose "optional" prerequisites to tools that are expressly
looking for them.

Grading them as optional is presently an exercise left to the user.

This class is a convenience wrapper around a bunch of other classes
that provide different kinds of generic C<Runtime> detection.

=over 4

=item * L<< C<Module::Runtime>|Perl::PrereqScanner::Scanner::Module::Runtime >>

Scans for C<Module::Runtime> specific syntax.

=back
=cut

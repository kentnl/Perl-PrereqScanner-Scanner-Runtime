use 5.006;    # our
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Runtime;

our $VERSION = '0.001000';

# ABSTRACT: Detect various kinds of run-time prerequisites

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moose qw( with );
use Perl::PrereqScanner::Scanner::Module::Runtime;

with 'Perl::PrereqScanner::Scanner';

__PACKAGE__->meta->make_immutable;
no Moose;





sub scan_for_prereqs {    ## no critic (RequireArgUnpacking)
  Perl::PrereqScanner::Scanner::Module::Runtime->scan_for_prereqs(@_);
  return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Perl::PrereqScanner::Scanner::Runtime - Detect various kinds of run-time prerequisites

=head1 VERSION

version 0.001000

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

=for Pod::Coverage scan_for_prereqs

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

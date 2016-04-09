use 5.006;    # our
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Runtime;

our $VERSION = '0.001000';

# ABSTRACT: Detect various kinds of run-time prerequisites

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moose qw( with has );

with 'Perl::PrereqScanner::Scanner';

has _slave_scanners => ( is => 'ro', lazy => 1, builder => '_build_slave_scanners' );

__PACKAGE__->meta->make_immutable;
no Moose;





sub scan_for_prereqs {    ## no critic (RequireArgUnpacking)
  for my $scanner ( @{ $_[0]->_slave_scanners } ) {
    $scanner->scan_for_prereqs( @_[ 1 .. $#_ ] );
  }
  return;
}

sub _build_slave_scanners {
  require Perl::PrereqScanner::Scanner::Module::Runtime;
  require Perl::PrereqScanner::Scanner::Class::Load;
  require Perl::PrereqScanner::Scanner::Module::Load;
  return [
    Perl::PrereqScanner::Scanner::Module::Runtime->new(), Perl::PrereqScanner::Scanner::Class::Load->new(),
    Perl::PrereqScanner::Scanner::Module::Load->new(),
  ];
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

Scans for L<< C<Module::Runtime>|Module::Runtime >> specific syntax.

=item * L<< C<Class::Load>|Perl::PrereqScanner::Scanner::Class::Load >>

Scans for L<< C<Class::Load>|Class::Load >> specific syntax.

=item * L<< C<Module::Load>|Perl::PrereqScanner::Scanner::Module::Load >>

Scans for L<< C<Module::Load>|Module::Load >> specific syntax.

=back

=head2 AUDIENCE

Its worth noting that this module is not necessarily going to be useful in part of a C<Dist::Zilla>
or similar stack. By nature of how this works, its job is to find dependencies that likely qualify
as I<optional>.

Hence, blindly advertising what this scanner reports as dependencies is not recommended.

This tool is more oriented around turn-key maintainers who want a quick way of finding
I<possible> auto-magical dependency behavior so they can make judgment calls about it.

=for Pod::Coverage scan_for_prereqs

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use 5.006;    # our
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Module::Load;

our $VERSION = '0.001000';

# ABSTRACT: Extract Module::Load module requirements

# AUTHORITY

use Moose qw( with );
use Carp qw( croak );
with 'Perl::PrereqScanner::Scanner';

__PACKAGE__->meta->make_immutable;
no Moose;

my %functions = (
  load     => '_get_pn',
  autoload => '_get_pn',
);
my %subs = ( map { ( "Module::Load::$_" => [ $functions{$_}, $_ ], "$_" => [ $functions{$_}, $_ ], ) } keys %functions );

=for Pod::Coverage scan_for_prereqs

=cut

sub scan_for_prereqs {
  my ( $self, $ppi_doc, $req ) = @_;

  # Compiles a list of function names to grep for
  my $literal_re = sprintf q[\A(?:%s)\z], join q[|], map { quotemeta }
    sort { $a cmp $b } _using_module_load($ppi_doc), map { 'Module::Load::' . $_ } keys %functions;

  # Scan document for <$functionname $quoted thing,...> or
  #   <$functionname(@arglist)> statements
  #
  # Skimming all statements for C<$functionname> and the looking right to see what to do
  my (@interesting);
  $ppi_doc->find(
    sub {
      return q[] unless $_[1]->isa('PPI::Statement');
      my (@children) = $_[1]->schildren;
      my ( $child, $previous );
      while (@children) {
        $previous = $child;
        $child    = shift @children;

        # Match sub call
        next unless $child->isa('PPI::Token::Word') and $child->literal =~ qr/$literal_re/sx;

        # Skip methods
        next if $previous and $previous->isa('PPI::Token::Operator') and q{->} eq $previous->content;

        # Handle a list of arguments as token->next
        if ( $children[0]->isa('PPI::Structure::List') ) {
          push @interesting, [ $child->literal, shift @children ];
          next;
        }

        # Handle "bare" calls by passing *all* remaining siblings
        # if token-next is a module name
        if ( $children[0]->isa('PPI::Token::Quote')
          or $children[0]->isa('PPI::Token::Word')
          or $children[0]->isa('PPI::Token::QuoteLike::Words') )
        {
          push @interesting, [ $child->literal, @children ];
          next;
        }

        # Here things fall through.
      }
      return q[];
    },
  );

  # Processing the identified groups happens independently to avoid
  # repressed errors, but this logic could just as easily be internal
  for my $group (@interesting) {
    my $subname = shift @{$group};
    my $handler = $self->can( $subs{$subname}->[0] ) or croak "Can't find extractor for $subname";
    my ( $module, $version ) = $handler->($group);
    next unless defined $module;
    next if $module =~ qr/[.]p[ml]\z/sx;
    next if $module =~ qr{[/\\.]}sx;
    local $@ = undef;
    ## no critic (RequireCheckingReturnValueOfEval)
    eval { $req->add_minimum( $module, 0 ) };    # If module name is invalid, not adding it is ok
    eval { $req->add_string_requirement( $module, $version ) };    # if version is invalid, not adding it is ok
  }
  return 1;
}

# Tries to flatten series of tokens/nodes to strings.
# may have bugs...
# anything that isn't known-safely stringifiable says a ref
# list seperators are nommed
sub _flatten {    ## no critic (RequireArgUnpacking)
  my (@children) = @{ $_[0] };
  my (@out);
  while ( my $child = shift @children ) {
    next if $child->isa('PPI::Token::Operator') and $child->content =~ qr{,|=>}sx;
    if ( $child->isa('PPI::Token::Quote::Single')
      or $child->isa('PPI::Token::Quote::Literal') )
    {
      push @out, $child->string;
      next;
    }
    if ( $child->isa('PPI::Token::Quote::Double') ) {
      if ( not $child->interpolations ) {
        push @out, $child->string;
        next;
      }
      push @out, $child;
      next;
    }
    if ( $child->isa('PPI::Token::Word') ) {
      push @out, $child->literal;
      next;
    }
    if ( $child->isa('PPI::Token::Number')
      or $child->isa('PPI::Token::QuoteLike::Words') )
    {
      push @out, $child->literal;
      next;
    }
    if ( $child->isa('PPI::Structure::List') or $child->isa('PPI::Statement::Expression') ) {
      push @out, _flatten( [ $child->schildren ] );
      next;
    }
    push @out, $child;    # Stash unhandled tokens verbatim
  }
  return @out;
}

sub _get_pn {
  my ($schildren) = @_;
  my (@args)      = _flatten($schildren);
  if ( defined $args[0] and not ref $args[0] ) {
    return ( $args[0], 0 );
  }
  return;
}

sub _get_pn_v {
  my ($schildren) = @_;
  my (@args)      = _flatten($schildren);
  if ( defined $args[0] and not ref $args[0] ) {
    if ( defined $args[1] and not ref $args[1] ) {
      return ( $args[0], $args[1] );
    }
    return ( $args[0], 0 );
  }
  return;
}

sub _using_module_load {
  my ($doc) = @_;
  my $found = undef;
  $doc->find_first(
    sub {
      return q[]
        if not $_[1]->isa('PPI::Statement::Include')
        or 'use' ne $_[1]->type
        or $_[1]->pragma
        or 'Module::Load' ne $_[1]->module;
      return $found = 1;
    },
  );

  # TODO: Detect all functions imported instead of assuming any
  # 'use' anywhere implies everything.
  return keys %functions if $found;
  return;
}

=head1 DESCRIPTION

This module is an extension for C<Perl::PrereqScanner> which extracts the following C<Module::Load>
syntax and declares them as requirements.

  use Module::Load;

  load "Example1";
  load Example2;

  autoload "Example3";
  autoload Example4;

  # ignored
  # load "some/path.pl"

=cut

1;


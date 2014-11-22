package Archive::BagIt::App::Verify;

use strict;
use warnings;

# VERSION
use Moose;
use MooseX::App::Command;

use namespace::autoclean;


parameter 'bag_path' => (
  is=>'rw',
  isa=>'Str',
  documentation => q[This is the path to run verify on],
  required => 1,
);

option 'return_all_errors' => (
  is => 'rw',
  isa => 'Bool',
  documentation => q[collect all errors rather than dying on first],
);

option 'fast' => (
  is => 'rw',
  isa => 'Bool',
  documentation => q[use Archive::BagIt::Fast instead...],
);

=for Pod::Coverage abstract run

=cut

sub abstract {
  return 'verifies a valid bag';
}


sub run {
  my ( $self) = @_;

  use Archive::BagIt;
  my $bag_path = $self->bag_path;
  my ($bag);
  if($self->fast) {
    use Archive::BagIt::Fast;
    $bag = Archive::BagIt::Fast->new($bag_path);
  }
  else {
    $bag = Archive::BagIt->new($bag_path);
  }
  eval {
      $bag->verify_bag();
  };
  if ($@) {
      print "FAIL: ".$bag_path." : $! $@\n";
  }
  else {
      print "PASS: ".$bag_path."\n";
  }
}

__PACKAGE__->meta->make_immutable;

1;


__END__

=pod

=encoding UTF-8

=head1 NAME

Archive::BagIt::App::Verify - verifies a bag

=cut

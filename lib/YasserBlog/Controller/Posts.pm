package YasserBlog::Controller::Posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

YasserBlog::Controller::Posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# sub index :Path :Args(0) {
#     my ( $self, $c ) = @_;
#     $c->response->body('Matched YasserBlog::Controller::Posts in Posts.');
# }
# sub list :Local {
#     my ( $self, $c ) = @_;
#     $c->stash(posts => [$c->model('DB::Post')->all]);
#     $c->stash(template => 'posts/list.tt');
# }
sub base :Chained('/') :PathPart('posts') :CaptureArgs(0){
    my ( $self, $c ) = @_;
    

}
sub add :Chained('base') :PathPart('add') :Args(0){
    my ( $self, $c ) = @_;
    my $content = $c->request->params->{content};
    my $title = $c->request->params->{title};
    my $dt = $c->datetime();
    my $post = $c->model('DB::Post')->create({
                userid => $c->user->id,
                title => $title,
                content => $content,
                postdate => $dt,
                editdate => $dt
              });
    $c->response->redirect($c->uri_for("/"));
}


=encoding utf8

=head1 AUTHOR

Yasser,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

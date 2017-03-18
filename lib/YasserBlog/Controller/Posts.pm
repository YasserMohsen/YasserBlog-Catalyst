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
    $c->stash(resultset => $c->model('DB::Post'));
    # $c->stash->{WRAPPER} = 'wrapper.tt';
}
sub add :Chained('base') :PathPart('add') :Args(0){
    my ( $self, $c ) = @_;
    my $content = $c->request->params->{content};
    my $title = $c->request->params->{title};
    my $dt = $c->datetime();
    if($title && $content){
        my $post = $c->model('DB::Post')->create({
                    userid => $c->user->id,
                    title => $title,
                    content => $content,
                    postdate => $dt,
                    editdate => $dt
                  });
    } else {
        $c->flash->{status_msg} = "Empty title or content!";
    }
    $c->response->redirect($c->uri_for("/"));
}
sub object :Chained('base') :PathPart('id'): CaptureArgs(1){
    my ( $self, $c, $id ) = @_;
    $c->stash(object => $c->stash->{resultset}->find($id));
    if (!$c->stash->{object}){
          die;
          $c->response->redirect($c->uri_for('/'));
          return;
    };
}
sub delete :Chained('object') :PathPart('delete'): Args(0){
    my ( $self, $c ) = @_;
    my $post = $c->stash->{object};
    if($post->userid->id == $c->user->id || $c->user->role == 'admin'){
        $c->stash->{object}->delete;
        $c->flash->{status_msg} = "Post deleted.";
    }
    $c->response->redirect($c->uri_for('/'));
}
sub edit :Chained('object') :PathPart('edit'): Args(0){
    my ( $self, $c ) = @_;
    my $post = $c->stash->{object};
    if($post->userid->id == $c->user->id  || $c->user->role == 'admin'){
        $c->stash(edit_post => $c->uri_for($c->controller->action_for("do_edit"),[$post->id]));
        $c->stash(post => $post, template => 'posts/edit.tt');
    } else {
        $c->response->redirect($c->uri_for('/'));
    }
}
sub do_edit :Chained('object') :PathPart('do_edit') :Args(0){
    my ( $self, $c ) = @_;
    my $post = $c->stash->{object};
    my $content = $c->request->params->{content};
    my $title = $c->request->params->{title};
    my $dt = $c->datetime();
    if($title && $content){
        $c->stash->{object}->update({
                    title => $title,
                    content => $content,
                    editdate => $dt
                  });
        $c->flash->{status_msg} = "Post updated.";
        $c->response->redirect($c->uri_for('/'));
    } else {
        $c->flash->{status_msg} = "Empty title or content!";
        $c->response->redirect($c->uri_for($c->controller->action_for("edit"),[$post->id]));
    }
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

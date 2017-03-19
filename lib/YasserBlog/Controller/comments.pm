package YasserBlog::Controller::comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

YasserBlog::Controller::comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub base :Chained('/') :PathPart('comments') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::Comment'));
}
sub add :Chained('base') :PathPart('add') :Args(0){
  my ($self, $c, $id) = @_;
    my $content = $c->request->params->{content};
    my $postid = $c->request->params->{postid};
    my $dt = $c->datetime();
    if($content){
        my $comment = $c->model('DB::Comment')->create({
                        postid => $postid,
                        content => $content,
                        userid => $c->user->id,
                        commentdate => $dt,
                        editdate => $dt
                      });
    } else {
        $c->flash->{status_msg} = "Empty comment!";
    }
    $c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'),[$postid]));
}
sub object :Chained('base') :PathPart('id'): CaptureArgs(1){
    my ( $self, $c, $id ) = @_;
    $c->stash(object => $c->stash->{resultset}->find($id));
    if (!$c->stash->{object}){
          $c->detach('error');
          return;
    };
}
sub error: Private{
    my ( $self, $c ) = @_;
    $c->response->redirect($c->uri_for('/'));
}
sub delete :Chained('object') :PathPart('delete'): Args(0){
    my ( $self, $c ) = @_;
    my $comment = $c->stash->{object};
    if($c->user_exists && ($comment->userid->id == $c->user->id || $c->user->role eq 'admin')){
        $c->stash->{object}->delete;
        $c->flash->{status_msg} = "Comment deleted succecfully.";
    }
    $c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'),[$comment->postid->id]));
}
sub edit :Chained('object') :PathPart('edit'): Args(0){
    my ( $self, $c ) = @_;
    my $comment = $c->stash->{object};
    if($c->user_exists && ($comment->userid->id == $c->user->id  || $c->user->role eq 'admin')){
        $c->stash(edit_comment => $c->uri_for($c->controller('comments')->action_for("do_edit"),[$comment->id]));
        $c->stash(comment => $comment, template => 'comments/edit.tt');
    } else {
        $c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'),[$comment->postid->id]));
    }
}
sub do_edit :Chained('object') :PathPart('do_edit') :Args(0){
    my ( $self, $c ) = @_;
    my $comment = $c->stash->{object};
    my $content = $c->request->params->{content};
    my $dt = $c->datetime();
    if($content){
        $c->stash->{object}->update({
                    content => $content,
                    editdate => $dt
                  });
        $c->flash->{status_msg} = "Comment updated successfully.";
        $c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'),[$comment->postid->id]));
    } else {
        $c->flash->{status_msg} = "Empty comment!";
        $c->response->redirect($c->uri_for($c->controller->action_for("edit"),[$comment->id]));
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

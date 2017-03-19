package YasserBlog::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

YasserBlog::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub admin: Global :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(users => [$c->model('DB::User')->search({},{ order_by => 'id ASC' })]);
     $c->stash(template => 'users/list.tt');
}

sub base :Chained('/') :PathPart('users') :CaptureArgs(0){
    my ( $self, $c ) = @_;
    $c->stash(resultset => $c->model('DB::User'));
}
sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    if($c->user_exists && ($c->user->id == $id || $c->user->role eq 'admin')){
        $c->stash(object => $c->stash->{resultset}->find($id));
        if (!$c->stash->{object}){
              $c->detach('error');
              return;
        }
    } else{
        $c->detach('error');
        return;
    }
}
sub error :Private{
    my ( $self, $c ) = @_;
    $c->response->redirect($c->uri_for('/'));
}
sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $user = $c->stash->{object};
    if($user->id != $c->user->id){
        $c->stash->{object}->delete;
        $c->flash->{status_msg} = "User deleted.";
        $c->response->redirect($c->uri_for('/admin'));
    }
}
sub edit :Chained('object') :PathPart('edit'): Args(0){
    my ( $self, $c ) = @_;
    my $user = $c->stash->{object};
    $c->stash(edit_user => $c->uri_for($c->controller->action_for("do_edit"),[$user->id]));
    $c->stash(user => $user, template => 'users/edit.tt');
}
sub do_edit :Chained('object') :PathPart('do_edit') :Args(0){
    my ( $self, $c ) = @_;
    my $user = $c->stash->{object};
    my $fname = $c->request->params->{fname};
    my $lname = $c->request->params->{lname};
    my $oldpassword = $c->request->params->{oldpassword};
    my $newpassword = $c->request->params->{newpassword};
    my $repassword = $c->request->params->{repassword};
    my $gender = $c->request->params->{gender};
    if($fname && $lname && $gender){
        if(!$newpassword){
            $c->stash->{object}->update({
                        fname => $fname,
                        lname => $lname,
                        gender => $gender
                      });
            $c->flash->{status_msg} = "Profile updated.";
        } else {
            if($user->password eq $oldpassword){
                if($newpassword eq $repassword && $newpassword){
                    $c->stash->{object}->update({
                                fname => $fname,
                                lname => $lname,
                                gender => $gender,
                                password => $newpassword
                              });
                    $c->flash->{status_msg} = "Profile updated.";
                } else {
                    $c->flash->{error} = "New password fields are not matching each other!";
                }
            } else {
                $c->flash->{error} = "Incorrect Old password!";
            }
        }

    } else {
        $c->flash->{error} = "Empty Firstname or Lastname!";
    }
    $c->response->redirect($c->uri_for($c->controller->action_for("edit"),[$user->id]));
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

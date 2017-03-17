package YasserBlog::Controller::login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

YasserBlog::Controller::login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# sub index :Path :Args(0) {
#     my ( $self, $c ) = @_;
#
#     $c->response->body('Matched YasserBlog::Controller::login in login.');
# }
sub base :Chained('/') :PathPart('login') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->stash(resultset => $c->model('DB::User'));
    $c->stash->{WRAPPER} = 'signwrapper.tt';
}

sub index :Chained('base') :PathPart("") :Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => "login/login.tt");
}
sub go :Chained('base') :PathPart("go") :Args(0) {
    my ($self, $c) = @_;

    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};

    if ($username && $password) {
        if ($c->authenticate({ username => $username, password => $password  } )) {
            $c->response->redirect($c->uri_for("/"));
            return;
        } else {
            $c->flash->{error} = "Wrong username or password";
        }
    } else {
        $c->flash->{error} = "Empty email or password";
    }
    $c->response->redirect($c->uri_for($c->controller('login')->action_for("")));
    return;
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

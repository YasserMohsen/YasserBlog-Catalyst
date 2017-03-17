package YasserBlog::Controller::register;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

YasserBlog::Controller::register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('register') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->stash(resultset => $c->model('DB::User'));
}

sub index :Chained('base') :PathPart("") :Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => "register/register.tt");
}
sub start :Chained('base') :PathPart("start") :Args(0) {
    my ($self, $c) = @_;

    my $fname = $c->request->params->{fname};
    my $lname = $c->request->params->{lname};
    my $email = $c->request->params->{email};
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    my $repassword = $c->request->params->{repassword};
    my $gender = $c->request->params->{gender};
    my $regex = $email =~ /^[a-z][a-z0-9._-]*[a-z0-9]\@[a-z0-9]+\.[a-z0-9]+$/;
    my $dt = $c->datetime();

    if ($username && $password && $email && $fname && $lname && $gender && $repassword) {
        if ($regex == 1) {
            my $userEmail = $c->model('DB::User')->search({email => $email});
            if($userEmail == 1){
                $c->flash->{error} = "This Email is already exist!";
            } else {
                my $userUsername = $c->model('DB::User')->search({username => $username});
                if($userUsername == 1){
                    $c->flash->{error} = "This username is already exist!";
                } else {
                    if($password != $repassword){
                        $c->flash->{error} = "Password fields are not matching each other!"
                    } else {
                        my $user = $c->model('DB::User')->create({
                                              fname => $fname,
                                              lname => $lname,
                                              username => $username,
                                              email => $email,
                                              password => $password,
                                              gender => $gender,
                                              avatar => 'default.png',
                                              regdate => $dt,
                                              role => 'user'
                                          });
                        $c->authenticate({ username => $username, password => $password  });
                        $c->response->redirect($c->uri_for("/"));
                        return;
                    }
                }
            }
        } else {
            $c->flash->{error} = "Please enter a valid Email!";
        }
    } else {
        $c->flash->{error} = "Empty required fields!";
    }
    $c->response->redirect($c->uri_for($c->controller('register')->action_for("")));
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

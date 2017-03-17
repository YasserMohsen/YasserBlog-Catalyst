use strict;
use warnings;
use Test::More;


use Catalyst::Test 'YasserBlog';
use YasserBlog::Controller::register;

ok( request('/register')->is_success, 'Request should succeed' );
done_testing();

use strict;
use warnings;
use Test::More;


use Catalyst::Test 'YasserBlog';
use YasserBlog::Controller::logout;

ok( request('/logout')->is_success, 'Request should succeed' );
done_testing();

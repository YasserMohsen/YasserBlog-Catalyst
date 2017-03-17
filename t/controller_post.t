use strict;
use warnings;
use Test::More;


use Catalyst::Test 'YasserBlog';
use YasserBlog::Controller::post;

ok( request('/post')->is_success, 'Request should succeed' );
done_testing();

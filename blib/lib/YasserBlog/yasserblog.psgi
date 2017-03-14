use strict;
use warnings;

use YasserBlog;

my $app = YasserBlog->apply_default_middlewares(YasserBlog->psgi_app);
$app;


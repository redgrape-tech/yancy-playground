package YancyPlay;
use Mojo::Base 'Mojolicious';
use DBIx::Class::Schema::Loader qw/ make_schema_at /;


# This method will run once at server start
sub startup {
  my $self = shift;

	my $log = $self->log;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');

	my $dsn = 'dbi:SQLite:dbname=sakila.db';

	make_schema_at( 'Play::Schema', { debug => 0, naming=>'current' }, [ $dsn , '', '' ] );

	my $schema ;

	$self->helper( schema => sub {  $schema //= Play::Schema->connect( $dsn);   } );

	my $rs = $self->schema->resultset('Film')->search( {},
					{
									columns => [ qw/title/ ],
									distinct => 1
					}
	);
	my $count = $rs->count;
	$log->debug("sample query result: distinct film title is: $count");


}

1;

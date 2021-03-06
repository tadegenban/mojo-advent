package PerlChinaAdvent::Controller::Calendar;

use Mojo::Base 'Mojolicious::Controller';
use PerlChinaAdvent::Entry qw/get_day_file get_available_days get_current_year render_pod render_markdown/;
use Calendar::Simple;

sub index {
    my $c = shift;

}

sub year {
    my $c = shift;

    my $year = $c->stash('year');
    my @days = get_available_days($year);
    $c->stash('available_days', \@days);
    $c->stash('calendar', scalar calendar(12, $year, 1));
}

sub entry {
    my $c = shift;

    my $year = $c->stash('year');
    my $day  = $c->stash('day');

    my $file = get_day_file($year, $day);
    unless ($file) {
        return $c->render(
            template => 'not_found',
            status => 404
        );
    }

    my $data;
    if ($file =~ /\.md$/) {
        $data = render_markdown($file);
    } else {
        $data = render_pod($file);
    }

    $c->stash('entry_data' => $data);
}

1;

#!/usr/bin/perl

use DBI;
my $db = "//rac-pgt.pgt.mpt.gov.br:1521/geral";
my $usarname = "sisseg";
my $passwd = "xms4da1f";

my $dbh = DBI->connect( "dbi:Oracle:$db", $username, $passwd ) or die "Não foi possivel conectar em $db\n";

$dbh->disconnect();

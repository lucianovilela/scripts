#!/usr/bin/perl -w
##########################################################################
# Title      :  Verifica atualizacao de Certificados 
# Author     :  Luciano Vilela Dourado <luciano.dourado@pgt.mpt.gov.br>
# Date       :  2009-05-05
# Requires   :  wget 
##########################################################################
# Description
#
##########################################################################
use strict;
use warnings;
use File::Path qw(make_path);
my $PN=`basename $0`;
my $VER='1.0';
my $WGET="wget  -UMozilla/5.0 ";
my $TMP=".";
my $FILE_CHAVE="./server.keystore";
my $PASSWORD='changeit';

my $PARAMETROS='-J-Duser.language=en';


my $LIST_CMD = "keytool -list $PARAMETROS -keystore $FILE_CHAVE -storepass $PASSWORD";


our $LISTA="";



sub LOG() {
        print `date "+%d/%m/%Y %H:%M:%S"` . @_;
}

sub inicializa(){

  if(  -d $TMP ){
    qx{rm -rf $TMP};
  }

  make_path $TMP;

}


sub listaChaves(){
  $LISTA = qx{$LIST_CMD};

}

sub main(){
  

    opendir(DIR, $TMP) or die $!;

    while (my $file = readdir(DIR)) {
	next if ($file =~ m/^\./ );
	next unless ($file =~ m/.*\.cert$/);
	my($proprietario, $emissor, $fingerprint)=("", "", "");

	my $INFO = qx{keytool $PARAMETROS -printcert -file $TMP/$file};

	
	#print($INFO);
	if($INFO =~ /.*Owner: CN=([\w\s\.]+),.*/gi){
	  print("Owner:$1\n");
	  $proprietario=lc($1);
	}
	if($INFO =~ /.*Issuer: CN=([\w\s]+),.*/gi){
	  print("Issuer:$1\n");
	  $emissor=lc($1);
	}
	if($INFO =~ /.*SHA1: (.+)/gi){
	  print("SHA1:$1\n");
	  $fingerprint=quotemeta $1;
	}


	my $alias= "$proprietario($emissor)" ;
	#print "$fingerprint\n";
	unless($LISTA =~ m/$fingerprint/gi){
	    my $DELETE_CMD="keytool $PARAMETROS -delete  -alias '$alias' -storepass $PASSWORD  -keystore $FILE_CHAVE -v";
	    print "$DELETE_CMD\n";
	    print qx{ $DELETE_CMD};
	    
	    my $IMPORT_CMD="keytool $PARAMETROS -importcert -noprompt -alias '$alias' -storepass $PASSWORD -file '$TMP/$file'  -keystore $FILE_CHAVE";
	    print "$IMPORT_CMD\n";
	    print qx{ $IMPORT_CMD};
	    #print "import $alias $fingerprint \n";
	}
	
	
    }
    closedir(DIR);

}




listaChaves();
main();




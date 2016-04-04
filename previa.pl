#!/usr/bin/perl

my $buffer; 

my $regional_atual="";

while(<>){
  s/\r\n//g;

  if(/^LOTACAO:\s+\d+\s+\-\s+([\w\s\/\,\.\-]+)\sMUNICIPIO.*$/){
    $regional = $1;
    $regional_atual=$regional if($regional_atual eq "");
    
  }
  if(/^.*INATIVOS.*CEDIDOS.*REQUISITADOS.*$/){
   
    $regional_atual=~ s/\s+$//g;
     $regional_atual =~ s/[\s\/\,\-]/\_/g;
     print "$regional_atual\n";


     open(OUT, "> previa/${regional_atual}.txt");
     print OUT $buffer;
     $buffer="";
     close(OUT);
     $regional_atual="";
     
  }
  $buffer .= "$_\r\n";

}
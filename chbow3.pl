#!/usr/bin/perl

%assuntos=();
open(ASSUNTO, "< $ARGV[0]") or die "$! $? \n";

while(<ASSUNTO>){
	chomp;
	@c=split(/,/);
		@campos=split(/\|/, $c[1]);
		$assuntos{$c[0]}=&trim($campos[0]);
		#print "$c[0] = $assuntos{$c[0]};\n";
}

close(ASSUNTO);

open(ARQ, "< $ARGV[1]") or die "$! $? \n";
while(<ARQ>){
	chomp;
	if($. == 1){
		@cab = split(",");
		
	}
	else{
		print "nomearquivo,assunto,termo,indice\n" if($. == 2);
		@col = split(/,/);
		if($col[0] =~ /^.*\/(\d*)\.(.*$)/){
				$nome=$1;
			}
		for( $i=1; $i< @col; $i++){
			printf("%s,%s,%s,%d\n", $nome, 
			$assuntos{$nome}, 
			$cab[$i], 
			$col[$i]);
		}
	}

}

close(ARQ);


sub trim {
   my($string)=@_;
   for ($string) {
       s/^\s+//;
       s/\s+$//;
   }
   return $string;
}

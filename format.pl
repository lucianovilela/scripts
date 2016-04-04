
%v=();

while(<>){
	chomp;
	@campos=split(";");
	$campos[8] =~ s/,/./g;
	$campos[9] =~ s/,/./g;
	$uf="$campos[0]";
	$key="$campos[1]";
	unless(exists $v{$uf}){
		$v{$uf} = ();
		
	}
	unless(exists $v{$uf}{$key}){
		$v{$uf}{$key}[0] = $campos[8];
		$v{$uf}{$key}[1] = $campos[9];
	}	
	
	
}

print << "XXX";
<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>
 <kml xmlns=\"http://www.google.com/earth/kml/2\">
	<Folder>
		<name>Brasil Telecom</name>
		<open>1</open>

XXX

foreach $uf(sort keys %v){
print << "XXX";
	<Folder>
		<name>$uf</name>
		<open>1</open>

XXX

	foreach $key1 (sort keys %{$v{$uf}}){
	
	print << "XXX";
	  <Placemark>
	   <description></description>
	   <name><![CDATA[ $key1 ]]></name>
	   <open>1</open>
	   <styleUrl>root://styleMaps#default+nicon=0x307+hicon=0x317</styleUrl>
	   <LookAt>
	    <longitude> ${$v{$uf}}{$key1}[0]</longitude>
	    <latitude> ${$v{$uf}}{$key1}[1]</latitude>
	    <range>500</range>
	    <tilt>-2.564273528665263e-016</tilt>
	    <heading>-6.815716473445065e-016</heading>

	   </LookAt>
	   <Point>
	    <coordinates> ${$v{$uf}}{$key1}[0], ${$v{$uf}}{$key1}[1]</coordinates>
	   </Point>
	  </Placemark>
XXX
	}

print << "XXX";
	</Folder>
XXX
	
}

print << "XXX";
	</Folder>
	</kml>
XXX


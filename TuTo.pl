#!/usr/bin/perl

use strict;
use warnings;

#-------------------------------------------------------------------#
#                            Introduction To perl                   #
#-------------------------------------------------------------------#

# To run all the script : do in the shell  "perl TuTo.pl Test patients.csv samples.csv genes.csv"
# Be sure all the files are in the same repertory.

#------------------------------------#
#           Mission 1 		     #
#------------------------------------#
=head
A – Write in a file a script that will print out a message when you execute it.
B – Try now to pass arguments to your script, to print them out into the shell.
C – Define a subroutine in your script to print your message in the shell.
D – Define a subroutine that return a string message into a scalar. Next, print the scalar in the shell.
E – Print something in a new file.
F – Read the messages you wrote in the file you have just created.
=cut

print "Message : HELLO\n"; # Reponse A
my $argument = $ARGV[0];# Reponse B
#my ($argument) = @ARGV; 
print "Argument : ".$argument."\n";
print sayHello();
sub sayHello {print "Subroutine1 : HELLO SUBROUTINE\n";return;} # Reponse C
  
my $message = returnHelloString();  
print "Subroutine2 : ".$message;
sub returnHelloString {return "HELLO SUBROUTINE WITH RETURN\n";} # Reponse D


open(FILE,">FILE.txt") or die "Can't read file \n";   # Reponse E
print FILE "Kikou";
close(FILE);

open(FILE1,"<FILE.txt") or die "Can't read file \n"; # Reponse F
my @lines = <FILE1>;
foreach my $line (@lines){print "File Content : ".$line."\n";}
close(FILE1);

#------------------------------------#
#           Mission 2 		     #
#------------------------------------#
=head
A – Create an array. Read the content of the array with 'foreach' control structure.
B – Test condtions on the values of you array. Note : Testing is different if values are numercis or strings.
C – Create an array with (Revolver,Revolt,Stuff,BlaRevoBla,BlaBlaRevo). Try to compute a regex to find the pattern Revo in the array. Then try to find first occurrence at the beginning of the string. Finally, at the end.
D – Create a subroutine to read the content of your array.
E – Create a hash. Read the content : key and values.
F – Create a hash and an array with both numerics values. Some values must be the same between the two elements.Try to read them and to compare each values to see what is the hash key content for equals values.
=cut
print "\n";

my @list=("Revolver","Revolt","Stuff","BlaRevoBla","BlaBlaRevo"); # Reponse A
foreach my $value(@list){	
	print"Current valueInArray : ".$value."\n";
        # Reponse B
	if ($value eq 'Revolt'){ print "Perfect match with the word Revolt \n";  } 
	# Reponse C
 	if($value =~ m/Revo/){print "Revo Pattern found in the whole value.\n";} 
        if($value =~ m/^Revo/){print "Revo Pattern found at the beginning of a value.\n";} 
        if($value =~ m/Revo$/){print "Revo Pattern found at the end of a value.\n";} 
}
print "\n";
# Reponse D
readContentOfTheLoop(@list); 
sub readContentOfTheLoop {
   my @list = @_;
   foreach my $value(@list){	print"Current valueInArray : ".$value."\n"; }
return;
   
}
# Reponse E
my %hash =(1=>'Eve',2=>'Test',3=>'Adam',4=>'Snake');
foreach my $key (keys %hash ){print $key." - ".$hash{$key}." \n";}

# Reponse F
my %hash_names =('John'=>'1','Kevin'=>'18','Wesley'=>'45');
my @array_names =(5,642,4,5,6,21,456,3,3,4464,5353,18,23,5,3);

foreach my $key (keys %hash_names ){

	print $key." - ".$hash_names{$key}." \n";

	foreach my $array_value (@array_names){
		
		if ($hash_names{$key} eq $array_value){print "Equal values for : ".$key."\n";}

	}

}
#------------------------------------#
#           Mission 3 		     #
#------------------------------------#
=head
A – Read the file and print the ouput. 
B – How many patient are classified in each gender ?
C – How many male patient are from a population annotated with BLACK OR AFRICAN AMERICAN ?
D –  How many patient from the sub group identified in question C have the sum of Monocytes and Lymphocytes count greater than 20 ?
E – Compute the mean of the age of diagnosis for the sub-group identified in C.
=cut
print "\n";

my $pathPatient = $ARGV[1];

my $maleCount = 0;
my $femalCount =0;
my $blackmaleCount = 0;
my $blackmaleSup20Count = 0;
open(FILE_PATIENT,$pathPatient) or die "Can't read to file \n";
# Another solution
#my @lines = <FILE_PATIENT>;
#foreach my $line (@lines){

my @ageforsubgroup = ();
while(my $line = <FILE_PATIENT>) {

	my @listColumns = split(',', $line);		
					 
	print $listColumns[0]."\n";

	if ($listColumns[4] eq "MALE"){

		$maleCount ++;
		if ($listColumns[5] eq "BLACK OR AFRICAN AMERICAN") {
			print  $listColumns[16]."\n";
                        push(@ageforsubgroup,$listColumns[16]);
			if($listColumns[19] + $listColumns[18] > 20) {$blackmaleSup20Count++;}
                	$blackmaleCount ++;
		}

	}
	elsif ($listColumns[4] eq "FEMALE"){$femalCount++; }

}
close(FILE_PATIENT);

print "Femal Gender Total : ".$femalCount."\n";

print "Male Gender Total : ".$maleCount."\n";
print "Black Male  Total : ".$blackmaleCount."\n";
print "Black Male with sum Monocytes and Lymphocytes > 20 Total : ".$blackmaleSup20Count."\n";
print "Femal Gender Total : ".$femalCount."\n";
print "Mean Age of subgroup C : ".mean(@ageforsubgroup)."\n";

sub mean {

my @ageforsubroup = @_;
my $total_participant = scalar @ageforsubroup; # length of the array, number of participant
my $sum_age = 0;

foreach my $age (@ageforsubroup) {
	$sum_age = $sum_age + $age;
}

return $sum_age/$total_participant;

}
#------------------------------------#
#           Mission 4 		     #
#------------------------------------#
=head
A – Create a file wich contains the patient id and total of samples for each patient.
To achieve this , you will need to cross the files using a regular expression.
=cut
print "\n";


open(FILE_PATIENT,$pathPatient) or die "Can't read to file \n";

my $path_to_samples = $ARGV[2];
open(FILE_SAMPLE,$path_to_samples) or die "Can't read to file \n";
my @lines_samples = <FILE_SAMPLE>;
my %patient_to_samples = ();
while(my $line_patient = <FILE_PATIENT>) {

	my @listColumnsPatients = split(',', $line_patient);	
	
	print "Bcr_patient_barcode : ".$listColumnsPatients[1]."\n";

	foreach my $line_sample (@lines_samples){
		
		my @listColumnsSamples = split(',', $line_sample);

		
		if($listColumnsSamples[0] =~ /^$listColumnsPatients[1]/){
			print "File Content : ".$listColumnsSamples[0]."\n";
			$patient_to_samples{$listColumnsPatients[1]}++;
		}
	
	}
}
close(FILE_PATIENT);
close(FILE_SAMPLE);

open(FILE_REZ_4,">RESULTATS_MISSION_4.txt") or die "Can't read file \n";   # Reponse E
foreach my $key_id_patient (keys %patient_to_samples){
print FILE_REZ_4 $key_id_patient." ->  ".$patient_to_samples{$key_id_patient}." \n";
}
close(FILE_REZ_4);

#------------------------------------#
#           Mission 5 		     #
#------------------------------------#
=head
A – Create a file with all informations filtered by gender and population, with total of samples by patient, and where the GC percentage is between 40 and 70 %. Keep GC content and Gene biotype values also in the final file.
=cut
print "\n";

open(FILE_REZ_5,">RESULTATS_MISSION_5.csv") or die "Can't read file \n"; 

open(FILE_PATIENT,$pathPatient) or die "Can't read to file \n";
my @lines_patients = <FILE_PATIENT>;

my $path_to_genes = $ARGV[3];
open(FILE_GENE,$path_to_genes) or die "Can't read to file \n";
my @lines_genes = <FILE_GENE>;
my @percentGC =();
foreach my $key_id_patient (keys %patient_to_samples){

	foreach my $line_patient (@lines_patients){
	chomp($line_patient);
	my @patients = split(',',$line_patient);			
	
		if ($patients[4] eq "MALE" && $patients[5] eq "BLACK OR AFRICAN AMERICAN" && $patients[1] eq $key_id_patient) {

			foreach my $line_gene (@lines_genes){
				
				my @genes = split(',', $line_gene);				

				if ($genes[1] eq $patients[23]){
				
				   print "Found ".$key_id_patient .": ".$genes[1]." - ".$genes[7]."\n";
				   push(@percentGC,$genes[7]);
				   print FILE_REZ_5 $line_patient.",".$patient_to_samples{$key_id_patient}.",".$genes[7].",".$genes[9];
				   last;
				}
			}
		}
	}

}
print "Mean % GC of the genes found : ".mean(@percentGC)."\n";
# The % is very high, not very low !
close(FILE_PATIENT);
close(FILE_SAMPLE);
close(FILE_GENE);
close(FILE_REZ_5);


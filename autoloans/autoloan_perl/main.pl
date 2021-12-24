#!usr/bin/perl


my $rate = 4.7;
my @nper = (24, 36, 48, 60, 72);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

$datestr = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec+1);

my $file = 'loans-perl.csv';

open $fh, '>', $file
    or die "Fille Error : $1";
print $fh "PV,NPER,RATE,PMT,STATUS,DATE\n";

my $pv = 25000;

my $countall = 0;
my $sumall = 0.0;


while ($pv < 30000) {
    for my $x (@nper) {

        $ir = $rate / 100 / 12;    
        $pmt = $ir * $pv / (1 - (1 + $ir)** -$x);

        if ($pmt lt 500) {
            $status = "low";
        } elsif ($pmt gt 600) {
            $status = "high";
        } else {
            $status = "ok";
        }
       
       printf("pv => %d, nper => %d, rate => %0.2f = pmt of %0.2f is %s on %s\n", $pv, $x, $rate, $pmt, $status, $datestr);
       $line = sprintf("%d,%d,%0.2f,%0.2f,%s,%s\n", $pv, $x, $rate, $pmt, $status, $datestr);
       print $fh $line;

        $countall = $countall + 1;
        $sumall = $sumall + $pmt;    

    } 
    
    $pv = $pv + 1000;
}

close $fh or die "Couldn't Close File : $!";

printf("Total records %d and total payments \$%0.2f\n", $countall, $sumall)

# perl main.pl
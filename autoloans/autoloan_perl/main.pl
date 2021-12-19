#!usr/bin/perl

sub autoLoan($pv, $np, $ir) {

    return $ir / 100 / 12  * $pv * $np;    
}

say autoLoan(25515, 72, 3.19);
<?php
 
$period_array = array(24, 36, 48, 60, 72);
 
$present_value = 25000;
 
$interest_rate = 4.7;
 
$count_all = 0;
 
$sum_all = 0;
 
function loan($present_value, $period, $interest_rate) {
    $rate = $interest_rate / 100/ 12;
    return ($rate * $present_value) / (1 - (1 + $rate)** -$period);
}
 
function status($payment){
    if($payment > 600) {
        return "high";
    } elseif($payment < 500) {
        return "low";    
    } else {
        return "ok";
    }
}
 
date_default_timezone_set('America/New_York');
 
$current_date = date('Y-m-d G:i:s');
 
$out_file = fopen('../loans.csv', 'w');
 
$header = "LOAN,INTEREST,TERM,MONTHLY,STATUS,DATE";
fputcsv($out_file, explode(',', $header));
 
while($present_value < 30000) {
    foreach($period_array as $period) {
 
        $payment = loan($present_value, $period, $interest_rate);
        $stat = status($payment);
        $row = sprintf("%d,%.1f,%d,%.2f,%s,%s",
         $present_value,
         $interest_rate,
         $period,
         $payment,
         $stat,
         $current_date);
 
        printf("%s\n", $row);
        fputcsv($out_file, explode(',',$row));
 
        $count_all++;
        $sum_all = $sum_all + $payment;
    }
    $present_value += 1000;
}
 
printf("\nTotal records: %d with total payments: $%.2f\n", $count_all, $sum_all)
 
?>

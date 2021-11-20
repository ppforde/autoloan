
use chrono::Local;
use std::f64;
use std::io::Write;
fn main() {
    let number_periods_vec = vec![24.0, 36.0, 48.0, 60.0, 72.0];

    let interest_rate = 4.7;

    let date = Local::now();

    let mut present_value = 25000.0;

    let mut countall = 0;

    let mut file = std::fs::File::create("../loans.csv").expect("create failed");

    let mut rows = "LOAN,RATE,TERM,MONTHLY,DATE\n".to_string();

    while present_value <= 29000.0 {
        for number_periods in &number_periods_vec {
            let monthly_payment = auto_loan(present_value, *number_periods, interest_rate);

            let row = format!(
                "{:},{:.1},{:},{:.2},{}\n",
                present_value,
                interest_rate,
                number_periods,
                monthly_payment,
                date.format("%Y-%m-%d %H:%M:%S")
            );

            print!("{}", row);
            rows.push_str(&row);

            countall += 1;
        }
        present_value += 1000.0;
    }

    file.write_all(rows.as_bytes()).expect("write failed");

    println!("\nNumber of records : {}", countall);
}
// functions

fn auto_loan(present_value: f64, number_periods: f64, interest_rate: f64) -> f64 {
    let irr0 = interest_rate / 100.0 / 12.0;
    let irr1 = 1.0 + irr0;
    let rv = irr0 * present_value / (1.0 - irr1.powf(number_periods * -1.0));
    return rv;
}

/*
cargo new auto_loan --bin
cd auto_loan
cargo build
./target/debug/auto_loan
or
cargo run
or
rustc main.rs
./main
*/

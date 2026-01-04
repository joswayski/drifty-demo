use std::{thread::sleep, time::Duration};

use sjl::{Logger, error, info};

const LOGS: [&str; 3] = [
    "User created successfully",
    "Order placed",
    "Payment processed",
];

const LOG_FREQUENCY: Duration = Duration::from_secs(5);

fn main() {
    Logger::init().build();
    info!("Drifty Demo started!");

    loop {
        // Occasionally log an error
        if rand::random_bool(0.03) {
            error!("Something went wrong processing the request");
        } else {
            let log_idx = rand::random_range(0..LOGS.len());
            let random_log = LOGS[log_idx];
            info!(random_log);
        }

        sleep(LOG_FREQUENCY);
    }
}

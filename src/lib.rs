#[rocket::get("/")]
fn hello() -> &'static str {
  "Hello, world!"
}

pub fn rocket() -> rocket::Rocket {
  rocket::ignite().mount("/", rocket::routes![hello])
}

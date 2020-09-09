#[rocket::main]
async fn main() {
  if let Err(e) = gossamer::rocket().launch().await {
    eprintln!("Rocket failed to launch: {:?}", e);
  };
}

use std::path::{Path, PathBuf};

use rocket::response::NamedFile;

#[rocket::get("/<file..>")]
async fn www(file: PathBuf) -> Option<NamedFile> {
  dbg!(&file);
  NamedFile::open(Path::new("www/").join(file)).await.ok()
}

pub fn rocket() -> rocket::Rocket {
  rocket::ignite().mount("/", rocket::routes![www])
}

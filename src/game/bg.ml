open Ecs
open Component_defs
open System_defs

let create img x y=
  let e = Entity.create () in
  Position.set e {x = x; y = y };
  Box.set e { width = 800; height = 600};
  Surface.set e (Texture.create_image img 800 600);
  
  Draw_S.register e;
  e

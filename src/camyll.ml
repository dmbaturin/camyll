open Cmdliner

let build () =
  let config =
    match Filesystem.read_bin "config.yml" with
    | exception Sys_error _ -> Config.default
    | data ->
      match Yaml.yaml_of_string data with
      | Error (`Msg msg) -> failwith msg
      | Ok yaml -> Config.of_yaml yaml
  in
  Build.build config

let build_cmd =
  let doc = "build the site" in
  Term.(const build $ const ()),
  Term.info "build" ~doc

let default_cmd =
  let doc = "static site generator" in
  Term.(ret (const (`Help(`Auto, None)))),
  Term.info "camyll" ~doc

let cmds = [build_cmd]

let main () = Term.(exit @@ eval_choice default_cmd cmds)

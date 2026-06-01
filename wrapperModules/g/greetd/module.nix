{
  config,
  lib,
  wlib,
  pkgs,
  ...
}:
let
  settingsFormat = pkgs.formats.toml;
in
{
  imports = [ wlib.modules.default ];

  options = {
    settings = lib.mkOption {
      type = settingsFormat.type;
      description = ''
        Nix attribute set to configure greetd. [greetd configuration documentation](https://man.sr.ht/~kennylevinsen/greetd/)
      '';
    };
  };

  config = {
    package = lib.mkDefault pkgs.greetd;

    constructFiles.settings = {
      content = builtins.readFile (settingsFormat.generate "greetd.toml" config.settings);
      relPath = "greetd.toml";
    };

    flags."--config" = config.constructFiles.settings.path;

    meta.maintainers = [ wlib.maintainers.clay53 ];
  };
}

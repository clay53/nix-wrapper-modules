{
  config,
  lib,
  wlib,
  pkgs,
  ...
}:
{
  imports = [ wlib.modules.default ];

  options = {
    settings = lib.mkOption {
      type = wlib.types.structuredValueWith {
        nullable = false;
        typeName = "TOML";
      };
      default = { };
      description = ''
        Nix attribute set to configure greetd. [greetd configuration documentation](https://man.sr.ht/~kennylevinsen/greetd/)
      '';
    };
  };

  config = {
    package = lib.mkDefault pkgs.greetd;

    constructFiles.generatedConfig = {
      content = builtins.toJSON config.settings;
      relPath = "${config.binName}-config.toml";
      builder = ''${pkgs.remarshal}/bin/json2toml "$1" "$2"'';
    };

    flags."--config" = config.constructFiles.generatedConfig.path;

    meta.maintainers = [ wlib.maintainers.clay53 ];
  };
}

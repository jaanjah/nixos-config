{ config, ... }:
{
  home.file = {
    "wallos/db/.keep".text = "";
    "wallos/logos/.keep".text = "";
  };
  virtualisation.quadlet.containers.wallos = {
    autoStart = true;

    containerConfig = {
      # https://github.com/ellite/Wallos/releases
      image = "docker.io/bellamy/wallos:4.8.0";
      autoUpdate = "registry";
      publishPorts = [ "8282:80/tcp" ];
      environments = {
        TZ = "Europe/Tallinn";
      };
      volumes = [
        "${config.home.homeDirectory}/wallos/db:/var/www/html/db:Z"
        "${config.home.homeDirectory}/wallos/logos:/var/www/html/images/uploads/logos:Z"
      ];
    };

    serviceConfig = {
      SuccessExitStatus = [
        "0"
        "143"
      ];
    };
  };
}

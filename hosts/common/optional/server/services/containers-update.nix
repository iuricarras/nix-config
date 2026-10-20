{
  config,
  pkgs,
  lib,
  ...
}: {
  # Serviço para atualizar as imagens OCI automaticamente
  systemd.services.update-oci-images = {
    description = "Atualizar imagens OCI/Docker";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script = ''
      IMAGES=$(${pkgs.docker}/bin/docker ps --format="{{.Image}}" | sort -u)

      for img in $IMAGES; do
        ${pkgs.docker}/bin/docker pull "$img"
      done
    '';
    # Opcional: Reiniciar os serviços do oci-containers após atualizar as imagens
    postStop = ''
      ${pkgs.systemd}/bin/systemctl restart docker-*.service
    '';
  };

  # Temporizador para correr o script (ex: todas as segundas-feiras às 02:00)
  systemd.timers.update-oci-images = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon 02:00";
      Persistent = true;
    };
  };
}

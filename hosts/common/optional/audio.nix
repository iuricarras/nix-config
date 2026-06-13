{...}: {
  #
  # Audio configuration for desktop environments. This is not required for headless servers, but it is required for desktops and laptops.
  #
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

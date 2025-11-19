{...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = 0;
      cpu_stats = true;
      gpu_stats = true;
      frametime = true;
      vram_stats = true;
      ram_stats = true;
      battery_stats = true;
      clock_stats = true;
      no_display = false;
    };
  };
}

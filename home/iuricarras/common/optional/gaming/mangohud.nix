{...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      # FPS
      fps_limit = 0;
      frametime = true;

      # CPU
      cpu_stats = true;
      cpu_temp = true;

      # RAM
      ram = true;
      
      # GPU
      gpu_stats = true;
      gpu_temp = true;
      
      # VRAM
      vram = true;
    };
  };
}

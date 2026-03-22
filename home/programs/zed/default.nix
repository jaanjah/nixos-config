{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    # https://zed.dev/extensions
    extensions = [
      # Language Servers
      "dockerfile"
      "html"
      "git-firefly"
      "nix"
      "sql"
      "toml"

      # Agents
      "github-copilot-cli"

      # Themes
      "catppuccin"

      # Icon Themes
      "catppuccin-icons"
    ];
    extraPackages = with pkgs; [
      # Nix language server dependencies
      nil
      nixd

      # Go packages
      go
      gopls

      # Package.json language server
      package-version-server
    ];
    userSettings = {
      agent = {
        always_allow_tool_actions = true;
        default_model = {
          provider = "copilot_chat";
          model = "claude-opus-4-6";
        };
      };
      base_keymap = "JetBrains";
      edit_predictions = {
        provider = "copilot";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      auto_install_extensions = {
        nix = true;
        catppuccin = true;
        catpuccin-icons = true;
        html = true;
        package-version-server = true;
        sql = true;
        git-firefly = true;
        github-copilot-cli = true;
        dockerfile = true;
        toml = true;
      };
      autosave = "on_focus_change";
      buffer_font_family = "CaskaydiaMono Nerd Font Mono";
      buffer_font_size = 14;
      buffer_font_features = {
        calt = false;
      };
      ui_font_family = "CaskaydiaMono Nerd Font Mono";
      ui_font_size = 14;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Mocha - No Italics";
      };
      icon_theme = {
        mode = "system";
        light = "Zed (Default)";
        dark = "Catppuccin Mocha";
      };
      calls = {
        mute_on_join = true;
      };
      # See: https://github.com/zed-industries/zed/pull/39400
      format_on_save = "off";
      git = {
        inline_blame = {
          enabled = false;
        };
      };
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };
      lsp = { };
    };
    userKeymaps = [
      {
        context = "Workspace";
        bindings = { };
      }
      {
        context = "Editor";
        bindings = {
          super-k = "pane::SplitRight";
        };
      }
      {
        context = "Pane";
        bindings = { };
      }
    ];
  };
}

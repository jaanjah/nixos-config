{
  accounts.email.accounts = {
    jaan = {
      userName = "jaanjahilo@outlook.com";
      realName = "Jaan Jahilo";
      address = "jaanjahilo@outlook.com";
      flavor = "outlook.office365.com";
      primary = true;
      thunderbird = {
        enable = true;
        profiles = [
          "default"
        ];
        settings = id: {
          # 10 = OAUTH2
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          extensions = {
            autoDisableScopes = 0;
          };
        };
      };
    };
  };
}

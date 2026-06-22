{
  # TODO: Setup ssh config for different ssh keys for different project
  programs.git = {
    enable = true;
    settings = {
      alias = {
        st = "status";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        please = "push --force-with-lease";
        rm-merged = "!git br | awk '$2 == \"[gone]\" { print $1 }' | xargs -r git branch -D";
        sync = "!git switch $(git remote show origin | sed -n '/HEAD branch/s/.*: //p') && git pull --prune && git rm-merged";
        br = "!git branch --format '%(refname:short) %(upstream:track)'";
      };
      commit = {
        gpgsign = true;
      };
      core = {
        editor = "vim";
      };
      gpg = {
        format = "ssh";
        # Verify SSH-signed commits locally. Without an allowedSigners file git
        # can sign but not verify (`git log --show-signature` errors and `%G?`
        # returns N — looks unsigned but isn't). GitHub verifies via the key
        # registered as a Signing Key regardless.
        ssh = {
          allowedSignersFile = "~/.config/git/allowed_signers";
        };
      };
      push = {
        autoSetupRemote = true;
      };
      user = {
        name = "Jaan Jahilo";
        email = "jaanjahilo@outlook.com";
        signingKey = "~/.ssh/id_ed25519.pub";
      };
      lfs = {
        enable = true;
      };
    };
  };

  # Identity → public-key map that gpg.ssh.allowedSignersFile points at.
  xdg.configFile."git/allowed_signers".text = ''
    jaanjahilo@outlook.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEebQ1uTuMl7PBX16i+zjVjGA+7dpUdVYkseY+YcPFk2 jaan-nixos-new
  '';
}

{
  programs.fish = {
    enable = true;

    shellAliases = {
      ssh = "kitten ssh";
      claude = "claude --model claude-opus-5 --effort xhigh";
    };

    interactiveShellInit = ''
      set -g __fish_git_prompt_showdirtystate yes
      set -g __fish_git_prompt_color_branch green --bold
      set -g __fish_git_prompt_color_branch_dirty red --bold
      set -g __fish_git_prompt_color_branch_staged yellow --bold

      # Colors already convey state; drop the `*`/`+` markers.
      set -g __fish_git_prompt_char_dirtystate ""
      set -g __fish_git_prompt_char_stagedstate ""
      set -g __fish_git_prompt_char_untrackedfiles ""
    '';

    functions = {
      __k8s_prompt = ''
        # "⎈ <cluster>:<namespace>", silent without kubectl or a context.
        command -q kubectl; or return

        set -l cfg $KUBECONFIG
        test -n "$cfg"; or set cfg "$HOME/.kube/config"
        test -r "$cfg"; or return

        set -l info (kubectl config view --minify \
            --output 'jsonpath={.contexts[0].context.cluster}|{.contexts[0].context.namespace}' \
            2>/dev/null)
        test -n "$info"; or return

        set -l parts (string split '|' -- $info)
        set -l cluster $parts[1]
        set -l ns $parts[2]
        test -n "$cluster"; or return
        test -n "$ns"; or set ns default

        set_color magenta
        echo -n "⎈ $cluster:$ns "
        set_color normal
      '';

      fish_prompt = ''
        set -l last_status $status

        __k8s_prompt

        echo -n -s (prompt_login) ' '
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal
        fish_vcs_prompt
        set_color normal

        if test $last_status -ne 0
            set_color $fish_color_status
            echo -n " [$last_status]"
            set_color normal
        end

        echo -n '> '
      '';
    };
  };
}

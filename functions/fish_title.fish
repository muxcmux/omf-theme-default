function fish_title
  if not set -q INSIDE_EMACS
    # set cmd (status current-command)

    echo (basename $PWD)
  end
end
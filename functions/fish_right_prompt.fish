function fish_right_prompt
  if git_is_repo
    
    set -l ahead    "↑ "
    set -l behind   "↓ "
    set -l diverged "⥄ "
    set -l dirty    (set_color red) "⨯ " (set_color normal)
    set -l git_icon (printf "\ue725 ")
    
    set -l repository_color (set_color $fish_color_cwd 2> /dev/null; or set_color green)
    
    echo -n -s $repository_color " " $git_icon

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged)
    end

    echo -n -s $repository_color (abbreviated_git_branch_name) $normal_color
  end
end

function abbreviated_git_branch_name
  set ref (git_branch_name)

  set filter (command git config --get shell-prompt.sed-filter 2>/dev/null)
  if test -n "$filter"
    set ref (command echo $ref | sed "$filter")
  end

  set length (string length $ref)
  
  set maxLength (command git config --get shell-prompt.max-branch-length 2>/dev/null)
  test -z "$maxLength"; and set maxLength 40

  if test $length -gt $maxLength
    set regex (command git config --get shell-prompt.prefix-regex 2>/dev/null)
    
    if test -n "$regex"
      set ref (command echo $ref | sed "s/$regex//1")
    end

    set prefixLength (command git config --get shell-prompt.prefix-length 2>/dev/null)
    test -z "$prefixLength"; and set prefixLength 0
    
    if test $prefixLength -gt 0
      set prefix (command echo $ref | cut -c $prefixLength)
      set ref (command echo $ref | cut -c (math $prefixLength + 1)-)
      set length (string length $ref)
    end
  end

  if test $length -gt $maxLength
    set suffixLength (command git config --get shell-prompt.suffix-length 2>/dev/null)
    test -z "$suffixLength"; and set suffixLength 0

    set length (string length $ref)
    set suffixStart (math $length - $suffixLength + 1)
    set separatorLength 3
    set nameEnd (math $maxLength - $suffixLength - $separatorLength)
    set ref (command echo $ref | cut -c 1-$nameEnd)...(command echo $ref | cut -c $suffixStart-)
  end

  echo $ref
end
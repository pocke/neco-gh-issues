let s:save_cpo = &cpo
set cpo&vim

let g:neco_gh_issues#hub_cmd = get(g:, 'neco_gh_issues#hub_cmd', 'hub')

let s:source = {
\   'name': 'gh_issues',
\   'mark': '[issue]',
\   'filetypes': {'gitcommit': 1,},
\   'keyword_patterns': {'gitcommit': '\v\#\d*'},
\ }

let s:re = '\v^\s+(\d+)\] (.+) \( .+ \)$'

function! s:source.gather_candidates(context)
  let out = split(neocomplete#util#system('hub issue'), "\n")
  if neocomplete#util#get_last_status()
    return []
  endif

  let i = 0

  let res = []
  for str in out
    let word  = '#' . substitute(str, s:re, '\= submatch(1)', '')
    let abbr  = word . ' ' . substitute(str, s:re, '\= submatch(2)', '')
    call add(res, {'word': word, 'abbr': abbr})
  endfor

  echom string(res)
  return res

  " if !(&spell || neocomplete#is_text_mode()
  "       \ || neocomplete#within_comment())
  "       \ || a:context.complete_str !~ '^[[:alpha:]]\+$'
  "   return []
  " endif
  "
  " let list = split(neocomplete#util#system(
  "       \ 'look ' . a:context.complete_str .
  "       \ '| head -n ' . self.max_candidates), "\n")
  " if neocomplete#util#get_last_status()
  "   return []
  " endif
  "
  " return map(list, "substitute(v:val,
  "       \ '^' . tolower(a:context.complete_str),
  "       \ a:context.complete_str, '')")
endfunction

function! neocomplete#sources#gh_issues#define()
  return executable(g:neco_gh_issues#hub_cmd) ? s:source : {}
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

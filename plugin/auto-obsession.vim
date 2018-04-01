" auto-obsession.vim - Auto-load tpope's Obsession
" Maintainer:   Hugo Haas <hugoh@hugoh.net>

if exists('g:loaded_auto_obsession')
  finish
endif
let g:loaded_auto_obsession = 1

let g:auto_obsession_active = get(g:, 'auto_obsession_active', 1)
let g:auto_obsession_exclude = get(g:, 'auto_obsession_exclude', [ '/\.git/COMMIT_EDITMSG$' ])
let g:auto_obsession_session = get(g:, 'auto_obsession_session', 'Session.vim')

function! s:FindBuffer(filename)
  let l:bufnr = bufnr(a:filename)
  if l:bufnr > -1
    execute 'buffer ' . l:bufnr
  endif
endfunction

function! s:AutoLoadObsession()
  " Deactivated?
  if g:auto_obsession_active == 0
    return
  endif
  " Exclusion?
  let l:filename = expand(@%)
  let l:filename_full = fnamemodify(l:filename, ':p')
  for l:e in g:auto_obsession_exclude
    if l:filename_full =~ l:e
      return
    endif
  endfor
  " Load or start session
  let l:session_file = expand(g:auto_obsession_session)
  if empty(v:this_session) && filereadable(l:session_file) && !&modified
    exec 'source ' . l:session_file
    call s:FindBuffer(l:filename)
  else
    exec 'Obsession ' . l:session_file
  endif
endfunction

augroup auto_obsession_group
  autocmd!
  autocmd VimEnter * nested call s:AutoLoadObsession()
augroup END

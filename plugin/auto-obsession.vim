" auto-obsession.vim - Auto-load tpope's Obsession
" Maintainer:   Hugo Haas <hugoh@hugoh.net>

if exists("g:loaded_auto_obsession")
  finish
endif
let g:loaded_auto_obsession = 1

let g:auto_obsession_active = get(g:, 'auto_obsession_active', 1)
let g:auto_obsession_session = get(g:, 'auto_obsession_session', 'Session.vim')

function! s:AutoLoadObsession()
  if g:auto_obsession_active == 0
    return
  endif
  let l:session_file = expand(g:auto_obsession_session)
  if empty(v:this_session) && filereadable(l:session_file) && !&modified
    exec "source " . l:session_file
  else
    exec "Obsession " . l:session_file
  endif
endfunction

augroup auto_obsession_group
  autocmd!
  autocmd VimEnter * nested call s:AutoLoadObsession()
augroup END
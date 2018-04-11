""
" @section Introduction, intro
" This is a very simple Vim plugin to automatically load and track a session,
" using tpope's Obsession plugin. You need to have |obsession| loaded.
"
" You can control whether you want it to kick in with |g:auto_obsession_active|
" (e.g., if you want to disable it when an argument is passed). Alternatively,
" you can use |g:auto_obsession_exclude| for more fine-grained control.
"
" By default, it uses `Session.vim` which is `:mksession`'s default. I
" personally like to use a single session file:
" >
"   let g:auto_obsession_session = '~/.vim/Session.vim'
" <
" @order intro config commands


if exists('g:loaded_auto_obsession')
  finish
endif
let g:loaded_auto_obsession = 1

""
" Enables loading and activating a session managed by Obsession on Vim startup.
" By default, it is enabled.
let g:auto_obsession_active = get(g:, 'auto_obsession_active', 1)

""
" List of file patterns for which a session won't be loaded / started.
" By default, opening Vim for `git commit` messages will not use a session.
" Default value: [ '/\.git/COMMIT_EDITMSG$' ]
let g:auto_obsession_exclude = get(g:, 'auto_obsession_exclude', [ '/\.git/COMMIT_EDITMSG$' ])

""
" Name of the session file. By default, `Session.vim` is used, which is
" `:mksession`'s default.
let g:auto_obsession_session = get(g:, 'auto_obsession_session', 'Session.vim')

function! s:FindBuffer(filename)
  let l:bufnr = bufnr(a:filename)
  if l:bufnr > -1
    execute 'buffer ' . l:bufnr
  endif
endfunction

function! s:AutoObsession()
  " Exclusion?
  let l:filename = expand(@%)
  let l:filename_full = fnamemodify(l:filename, ':p')
  for l:e in g:auto_obsession_exclude
    if l:filename_full =~# l:e
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

function! s:AutoLoadObsession()
  " Deactivated?
  if g:auto_obsession_active == 0
    return
  endif
  call s:AutoObsession()
endfunction

function! s:AutoObsessionWipe()
  if !empty(get(g:, 'this_obsession'))
    Obsession!
  endif
endfunction

""
" Either load or start session recording manually
command! AutoObsession call s:AutoObsession()

""
" Stop session recording and wipe it
command! AutoObsessionWipe call s:AutoObsessionWipe()

augroup auto_obsession_group
  autocmd!
  autocmd VimEnter * nested call s:AutoLoadObsession()
augroup END

augroup goerr_nvim_go_ft
autocmd!
autocmd FileType go setlocal syntax=on
autocmd FileType go setlocal foldlevel=10
" autocmd FileType go silent! execute 'g/if err != nil {/silent execute("normal zcgg")'
autocmd FileType go setlocal foldtext=goerr_nvim#foldtext()
" also remove distracting dots in fold names (replace to spaces)
autocmd FileType go setlocal fillchars=fold:\ 
autocmd FileType go silent! execute ':call GolangWalkError()'
augroup END

lua require("goerr-nvim")

function! goerr_nvim#foldtext()
    return luaeval('_G.GoErrFoldTxt(vim.api.nvim_get_current_buf())')
endfunction

function! GolangWalkError()
  let saved_cursor = getpos('.')
  " 将光标移动到文件的第一行
  silent! call setpos('.', [0, 1, 1, 0])
  " 查找并折叠所有匹配的错误处理代码块
  " while search('if err != nil {', 'W') > 0
  while search('\v^[^\/]*if err \!\= nil \{', 'W') > 0
    " 折叠当前行所在的代码块
    " silent! execute "normal! zc"
    let fold_line = foldclosed(line('.'))
    " 检查当前行是否已经折叠
    if fold_line == -1
      " 如果未折叠，则折叠当前行所在的代码块
      silent! execute "normal! zc"
    endif
  endwhile
  silent! call setpos('.', saved_cursor)
endfunction
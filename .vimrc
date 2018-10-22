" 日本語用のプラグイン
set runtimepath+=~/.vim/plugins/JpFormat.vim-master
let ExtViewer_txt = "call system('cot %f &')"
let EV_toFenc_txt = ''

let mapleader = ','

"release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト (2013-07-03 14:30 修正）
" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" " バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" " クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
 if has('unnamedplus')
         set clipboard& clipboard+=unnamedplus,unnamed 
      else
              set clipboard& clipboard+=unnamed
      endif
" Swapファイル？Backupファイル？前時代的すぎ
" なので全て無効化する
set nowritebackup
set nobackup
set noswapfile

set list                " 不可視文字の可視化
set number              " 行番号の表示
"set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
set colorcolumn=100      " その代わり80文字目にラインを入れる

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jjj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
"nnoremap <Tab> %
"vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
"cmap w!! w !sudo tee > /dev/null %

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
"function! s:mkdir(dir, force)
"  if !isdirectory(a:dir) && (a:force ||
"    \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
"    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
"  endif
"endfunction
"autocmd MyAutoCmd BufWritePre * call
"s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
  if a:directory == ''
    lcd %:p:h
  else
    execute 'lcd' . a:directory
  endif
  if a:bang == ''
    pwd
  endif
endfunction
" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
  execute 'source ' . s:local_vimrc
endif

" ####################### NEOBUNDLE SETTINGS ##########################
set nocompatible               " Be iMproved
filetype off                   " Required!

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" " dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(expand('~/.vim/dein'))
  call dein#add('Shougo/dein.vim')

  "############## NEOBUNDLE INSTALL SETTINGS ##############
  "======== vim environment ========
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neocomplete')
  call dein#add('Shougo/vimshell.git')
  call dein#add('majutsushi/tagbar')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('scrooloose/nerdtree')
  call dein#add('szw/vim-tags')
  call dein#add('kana/vim-submode')
  " -- color scheme
  call dein#add('tomasr/molokai.git')
  call dein#add('jpo/vim-railscasts-theme')
  call dein#add('w0ng/vim-hybrid')
  call dein#add('vim-scripts/errormarker.vim.git')
  call dein#add('wincent/Command-T')
  "-- git
  call dein#add('cohama/agit.vim')
  "======== language ========
  " -- scala
  call dein#add('derekwyatt/vim-scala.git')
  " -- haskell
  call dein#add('dag/vim2hs')
  call dein#add('kana/vim-filetype-haskell')
  call dein#add('ujihisa/neco-ghc')
  call dein#add('thinca/vim-quickrun')
  call dein#add('thinca/vim-ref')
  call dein#add('ujihisa/unite-haskellimport')
  call dein#add('eagletmt/unite-haddock')
  call dein#add('eagletmt/ghcmod-vim')
  " -- Python
  " -- HTML CSS 
  call dein#add('wavded/vim-stylus')
  call dein#add('lepture/vim-css')
  call dein#add('digitaltoad/vim-pug')
  "-- TypeSvript
  call dein#add('leafgarland/typescript-vim')
  "  Any Other
  call dein#add("thinca/vim-template")
  call dein#add('tpope/vim-surround')
  call dein#add('vim-scripts/Align')
  call dein#add('vim-scripts/YankRing.vim')
  " -- Database Tool
  call dein#add('vim-scripts/dbext.vim')

  "call dein#add( "mattn/gist-vim", {
  "      \ "depends": ["mattn/webapi-vim"],
  "      \ "autoload": {
  "      \   "commands": ["Gist"],
  "      \ }})
  " vim-fugitiveは'autocmd'多用してるっぽくて遅延ロード不可
  "call dein#add("tpope/vim-fugitive")
  "call dein#add("gregsexton/gitv", {
  "      \ "depends": ["tpope/vim-fugitive"],
  "      \ "autoload": {
  "      \   "commands": ["Gitv"],
  "      \ }})

  "call dein#add("vim-scripts/TaskList.vim", {
  "      \ "autoload": {
  "      \   "mappings": ['<Plug>TaskList'],
  "      \}})

  " Djangoを正しくVimで読み込めるようにする
  "call dein#add("lambdalisue/vim-django-support", {
  "      \ "autoload": {
  "      \   "filetypes": ["python", "python3", "djangohtml"]
  "      \ }})
  " Vimで正しくvirtualenvを処理できるようにする
  "call dein#add("jmcantrell/vim-virtualenv", {
  "      \ "autoload": {
  "      \   "filetypes": ["python", "python3", "djangohtml"]
  "      \ }})
  "call dein#add("vim-pandoc/vim-pandoc", {
  "      \ "autoload": {
  "      \   "filetypes": ["text", "pandoc", "markdown", "rst", "textile"],
  "      \ }})
  


  " -- END --
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

  let dbext_default_profile="" "使用プロファイル
  let dbext_default_type="MYSQL" "データベースの種類
  let dbext_default_user="root" "ユーザ名
  let dbext_default_passwd="" "パス
  let dbext_default_dbname="pikakyu_local" "データベース名
  let dbext_default_host="localhost" "ホスト(localhost等)
  let dbext_default_buffer_lines=30 "vimに表示する行数設定 


  nmap <Leader>T <plug>TaskList

  "####################################### 


  "################# NEOBUNDLE LAZY #####################

" thinca / vim-templateの設定
" テンプレート中に含まれる特定文字列を置き換える
autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction
" テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
autocmd MyAutoCmd User plugin-template-loaded
    \   if search('<+CURSOR+>')
    \ |   silent! execute 'normal! "_da>' 

"ファイルタイププラグインおよびインデントを有効化
" これはNeoBundleによる処理が終了したあとに呼ばなければならない
filetype plugin indent on
" GIT PLUGINS

 " NEOCOMPLETE テンプレそのまま
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'


"勝手な選択を無効
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif

" let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
 
  " インストールされていないプラグインのチェックおよびダウンロード

" display
set showmatch
set number
set ruler
set cursorline
" indent
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
" etc
set smartcase
set history=50
syntax on

" colorschehme
set background=dark
colorscheme hybrid
" let g:molokai_original=1
let g:hybrid_custom_term_colors = 1
"let g:hybrid_use_Xresources = 1
" iTerm2で半透明にしているが、vimのcolorschemeを設定すると背景も変更されるため
highlight Normal ctermbg=none
" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'scala' : $HOME . '/.vim/dict/scala.dict',
    \ }

" vimsehll
let g:vimshell_interactive_update_time = 10
let g:vimshell_prompt = $USER."% "
"vimshell map
nmap vs :VimShell<CR>
nmap vp :VimShellPop<CR>

" make
autocmd FileType scala :compiler sbt
autocmd QuickFixCmdPost make if len(getqflist()) != 0 | copen | endif

" marker
let g:errormarker_errortext     = '!!'

let g:errormarker_errorgroup    = 'Error'
let g:errormarker_warninggroup  = 'ToDo'

" TagBar
nmap <F8> :TagbarToggle<CR>

" vim-tags
nnoremap <C-]> g<C-]>

" indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1

" NERDTree
nmap <silent> <C-e> :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc> :NERDTreeToggle<CR>
omap <silent> <C-e> :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeShowHidden=1

" カーソル形状を修正 iterm2のみ有効らしい
let &t_SI.="\e[6 q"
let &t_EI.="\e[2 q"
" カーソル形状を戻すタイムアウト時間を修正
let ttimeoutlen=10
" 挿入モードを抜けた時にカーソルが見えなくなる現象対策(なぜかこれで治る)
inoremap <ESC> <ESC>

" 画面分割用の設定
nnoremap r <Nop>
nnoremap rj <C-w>j
nnoremap rk <C-w>k
nnoremap rl <C-w>l
nnoremap rh <C-w>h
nnoremap rJ <C-w>J
nnoremap rK <C-w>K
nnoremap rL <C-w>L
nnoremap rH <C-w>H
nnoremap rn gt
nnoremap rp gT
noremap rr <C-w>r
nnoremap r= <C-w>=
nnoremap rw <C-w>w
nnoremap ro <C-w>_<C-w>|
nnoremap rO <C-w>=
nnoremap rN :<C-u>bn<CR>
nnoremap rP :<C-u>bp<CR>
nnoremap rt :<C-u>tabnew<CR>
nnoremap rT :<C-u>Unite tab<CR>
nnoremap rs :<C-u>sp<CR>
nnoremap rv :<C-u>vs<CR>
nnoremap rq :<C-u>q<CR>
nnoremap rQ :<C-u>bd<CR>
nnoremap rb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap rB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 'r>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 'r<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 'r+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 'r-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

" 画面スクロール
nnoremap <Space> <Nop>
nnoremap <Space>j 5<C-e>
nnoremap <Space>k 5<C-y>
nnoremap <Space>l zl5
nnoremap <Space>h zh5

call submode#enter_with('scrolling', 'n', '', '<Space>j', '5<C-e>')
call submode#enter_with('scrolling', 'n', '', '<Space>k', '5<C-y>')
call submode#enter_with('scrolling', 'n', '', '<Space>l', 'zl5')
call submode#enter_with('scrolling', 'n', '', '<Space>h', 'zh5')
call submode#map('scrolling', 'n', '', 'j', '5<C-e>')
call submode#map('scrolling', 'n', '', 'k', '5<C-y>')
call submode#map('scrolling', 'n', '', 'l', 'zl5')
call submode#map('scrolling', 'n', '', 'h', 'zh5')
call submode#map('scrolling', 'n', '', '<Space>', 'M')

" unite-haddock
nnoremap <silent> K :UniteWithCursorWord hoogle<CR>

vmap <silent> ;h :s?^\(\s*\)+ '\([^']\+\)',*\s*$?\1\2?g<CR>
vmap <silent> ;q :s?^\(\s*\)\(.*\)\s*$? \1 + '\2'?<CR>


set fileencoding=japan
set fileencodings=utf-8,euc-jp,iso-2022-jp,ucs-2le,ucs-2,cp932 

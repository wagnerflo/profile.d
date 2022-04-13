(add-to-list 'load-path "~/.profile.d/emacs")
(add-to-list 'load-path "~/.profile.d/emacs/php-mode")

;; temporary files
(set 'temporary-file-directory "/tmp")

;; no backups and don't do version control for me
(setq make-backup-files nil)
(setq vc-handled-backends nil)

;; turn on colors and menubar off
(global-font-lock-mode t)
(menu-bar-mode -1)

;; turn on column display
(setq column-number-mode t)

;; show trailing whitespace on lines
(setq-default show-trailing-whitespace t)

;; customized buffer switching
(require 'swbuff)
(setq swbuff-exclude-buffer-regexps '("^ .*" "^\\*.*\\*"))
(defalias 'next-buffer 'swbuff-switch-to-next-buffer)
(defalias 'previous-buffer 'swbuff-switch-to-previous-buffer)

;; dired with single buffer mode
(add-hook 'dired-load-hook
  (lambda ()
    (require 'dired-single)
    (define-key dired-mode-map (read-kbd-macro "RET")
      'dired-single-buffer)
    (define-key dired-mode-map (read-kbd-macro "C-RET")
      'dired-find-file)
    (define-key dired-mode-map (kbd "<DEL>")
      (function
        (lambda nil (interactive)
          (dired-single-buffer ".."))))
    ))

;; use emacs implementation of ls to avoid problems on operating
;; systems not supporting ls --dired
(setq ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)

;; use ssh by default
(setq tramp-default-method "ssh")

;; make tramp faster on first connection
(setq tramp-ssh-controlmaster-options "-o ControlMaster=auto")

;; up/down keys
(global-set-key [next]
  (lambda () (interactive)
    (condition-case nil (scroll-up)
      (end-of-buffer (goto-char (point-max))))))

(global-set-key [prior]
  (lambda () (interactive)
    (condition-case nil (scroll-down)
      (beginning-of-buffer (goto-char (point-min))))))

;; function to disable exit key-combination
(defun disable-exit () (interactive)
  (global-unset-key (kbd "C-x C-c")))

;; set some colors
(defface extra-whitespace-face
  '((t (:background "light goldenrod")))
  "Used for tabs and such.")

(add-hook 'hack-local-variables-hook
  (lambda ()
    (if (and (boundp 'highlight-tabs) highlight-tabs)
      (font-lock-add-keywords nil '(("\t" . 'extra-whitespace-face))))))

(add-hook 'term-setup-hook
  (lambda ()
    (custom-set-faces
      '(diff-changed ((((type tty pc) (class color) (background light))
                        (:foreground "magenta"))))
      '(diff-context ((nil nil)))
      '(diff-file-header ((((class color) (background light))
                            (:foreground "yellow"))))
      '(diff-header ((((class color) (background light))
                       (:foreground "yellow"))))
      '(diff-hunk-header ((t (:inherit diff-header
                               :foreground "green"))))
      '(diff-removed ((t (:inherit diff-changed
                           :foreground "red"))))
      '(dired-directory ((t (:inherit font-lock-function-name-face
                              :foreground "blue"
                              :weight bold))))
      '(dired-mark ((t (:inherit font-lock-constant-face
                         :weight bold))))
      '(font-lock-comment-face ((t (:foreground "red"))))
      '(font-lock-constant-face ((t (:foreground "magenta"))))
      '(font-lock-builtin-face ((t (:foreground "magenta"))))
      '(font-lock-doc-face ((t (:inherit font-lock-string-face))))
      '(font-lock-function-name-face ((t (:foreground "blue"
                                           :weight bold))))
      '(font-lock-keyword-face ((t (:foreground "#0080d4" :weight bold))))
      '(font-lock-negation-char-face ((t (:foreground "red"
                                           :weight bold))))
      '(font-lock-string-face ((t (:foreground "#d45500"))))
      '(font-lock-type-face ((t (:foreground "#005500" :weight bold))))
      '(mode-line ((t (:background "black" :foreground "white"))))
      '(mode-line-inactive ((t (:inherit mode-line
                                 :background "#6c6c6c"
                                 :foreground "#e4e4e4"))))
      )))

;; setup custom variables
(custom-set-variables

  ;; declare few variable/value pairs as safe for overriding
  '(safe-local-variable-values
     (quote
       (
         (default-tab-width . 6)
         (default-tab-width . 8)
         (highlight-tabs . t)
         (highlight-tabs . nil)
         )))

  ;; general stuff
  '(global-hl-line-mode t)
  '(indent-tabs-mode nil)

  ;; printing
  '(ps-paper-type 'a4)
  '(ps-print-only-one-header t)
  '(ps-header-lines 1)
  '(ps-zebra-stripes t)
  '(ps-line-number t)
  '(ps-line-number-step 'zebra)

  ;; python
  '(python-honour-comment-indentation nil)
  '(python-use-skeletons nil)

  ;; lisp mode
  '(lisp-indent-offset 2)
  )

;; for c mode
(c-set-offset 'case-label '+)
(c-set-offset 'inclass '++)
(c-set-offset 'friend '-)

;; template files of void linux packages
(setq vlpt-pattern "srcpkgs/[^/]+/template\\'")
(add-to-list 'auto-mode-alist `(,vlpt-pattern . sh-mode))
(add-hook 'sh-mode-hook
  (lambda ()
    (when (string-match vlpt-pattern (buffer-file-name))
      (setq sh-basic-offset 8)
      (setq indent-tabs-mode t))))

;; markdown mode
(autoload 'markdown-mode "markdown-mode" nil t)
(autoload 'gfm-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(setq markdown-command "cmark")
(setq markdown-live-preview-window-function
  (lambda (file) ""))

;; yaml mode
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; use js-mode for .json files
(add-to-list 'auto-mode-alist '("\\.json\\'" . js-mode))

;; web-mode
(autoload 'web-mode "web-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))

(add-hook 'web-mode-hook
  (lambda ()
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-script-padding 2)))

;; cmake
(autoload 'cmake-mode "cmake-mode" nil t)
(add-to-list 'auto-mode-alist '("/CMakeLists.txt" . cmake-mode))

;; ess
(require 'ess-site nil 'noerror)
(if (featurep 'ess-site)
  (ess-toggle-underscore nil))

;; php-mode
(autoload 'php-mode "php-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\(?:php\\|phtml\\)\\'" . php-mode))

;; python-mode
(add-hook 'python-mode-hook
  (lambda ()
    (setq-local completion-at-point-functions nil)))

;; commandline switch for ediff mode
(add-to-list 'command-switch-alist
  '("-diff" . (lambda (switch)
                (let ((file1 (pop command-line-args-left))
                       (file2 (pop command-line-args-left)))
                  (setq inhibit-startup-screen t)
                  (ediff file1 file2)))))

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; fix some things when running inside tmux
(defadvice terminal-init-screen
  (before tmux activate)
  "Apply xterm keymap, allowing use of keys passed through tmux."
  (if (getenv "TMUX")
    (let
      ((map (copy-keymap xterm-function-map)))
      (set-keymap-parent map (keymap-parent input-decode-map))
      (set-keymap-parent input-decode-map map))))

(if (getenv "TMUX")
  (setq frame-background-mode 'light))

;; provide a commandline option to disable the exit keybinding
(setq command-switch-alist
  '(("disable-exit" . (lambda (arg) (disable-exit)))))

;; system local config
(let
  ((filename
     (expand-file-name
       (concat "~/.profile.d/emacs/emacs." (getenv "PROFILE_ENV") ".el"))))
  (if
    (file-readable-p filename)
    (load-file filename)))

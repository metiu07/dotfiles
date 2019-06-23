;; Initialize package repositories
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("org" . "http://orgmode.org/elpa/")
						 ("marmalade" . "http://marmalade-repo.org/packages/")
						 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Initializes packages, so we can use -> use-package
(package-initialize)

(package-install 'use-package)
(eval-when-compile (require 'use-package))

;; Ensure that we have every package we need
(setq use-package-always-ensure t)

(use-package org
  :config
  (setq org-log-done 'time)
  (setq org-startup-folded nil)
  (setq org-hide-leading-stars t))

;; GNU Global emacs implementation
(use-package ggtags
  :config
  (add-hook 'c-mode-common-hook
			(lambda ()
			  (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
				              (ggtags-mode 1)))))

;; Language server protocol
(use-package lsp-mode
  :commands lsp
  :init (add-hook 'c++-mode-hook 'lsp))

;; Allow to choose server without prefix
;; This is due to the C-u being page up in emacs
;; We want to be able to call at least this function with prefix
(defun lsp-choose-server ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'lsp))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
;; (use-package ccls)



;; CEDET - Emacs development tools
;;(use-package cedet
;;  :config
;;  ;; Project management for smart completion
;;  (require 'ede)
;;  (global-ede-mode t)
;;
;;  (require 'cc-mode)
;;  (require 'semantic)
;;  (global-semanticdb-minor-mode 1)
;;  
;;  (semantic-mode 1))

;; LLVM Syntax
(setq load-path
    (cons (expand-file-name "/home/mato/.emacs.d/") load-path))
  (require 'llvm-mode)

;; Company mode - auto completion
(use-package company
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-gtags)
  (define-key c-mode-map  [(tab)] 'company-complete)
  (define-key c++-mode-map  [(tab)] 'company-complete)
  (add-hook 'after-init-hook 'global-company-mode))

;; Highlight symbol under cursor
;;(use-package highlight-symbol
;;  :config
;;  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;; Ranger file exploler
(use-package ranger)

;; Code browsing - sr-speedbar
(use-package sr-speedbar
  :config
  (add-hook 'buffer-quit-function 'sr-speedbar-close)
  (setq sr-speedbar-right-side nil))

;; Incremental completitions - helm
(use-package helm
  :config
  (add-hook 'helm-minibuffer-set-up-hook 'nolinum)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (helm-mode 1))

(defun helm-M-x-prefix ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'helm-M-x))

(use-package helm-swoop)
(require 'helm-config)

;; GTAGS - Source code navigation
(use-package helm-gtags
  :init
  (setq
   helm-gtags-ignore-case t
   helm-gtags-auto-update t
   helm-gtags-use-input-at-cursor t
   helm-gtags-pulse-at-cursor t
   helm-gtags-prefix-key "\C-cg"
   helm-gtags-suggested-key-mapping t
   )
  :config
  (helm-gtags-mode t))

;; Project management - projectile
(use-package projectile
  :config
  (projectile-global-mode))

;; Helm interface for projectile project management
(use-package helm-projectile
  :config
  (helm-projectile-on))

;; Syntax checking on fly
(use-package flycheck)
;;  :config
;;  (global-flycheck-mode))

;; Rtags frontend
;; (require 'rtags)
;; (require 'helm-rtags)

;; Cmake ide flags
;; (use-package cmake-ide
;;   :config
;;   (cmake-ide-setup))

;; VIM initialization
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  ;; Map visual movement, this is usefull when word wrap is on
  (evil-define-key '(normal visual) latex-mode-map (kbd "j") 'evil-next-visual-line)
  (evil-define-key '(normal visual) latex-mode-map (kbd "k") 'evil-previous-visual-line)
  ;; Map TAB to hide/cycle through folding on items
  (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
  (evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point)
  ;; Use Meta-{h, l} to move between windows instead of C-w {l, h}
  (global-unset-key (kbd "M-h"))
  (evil-global-set-key 'normal (kbd "M-h") 'evil-window-left)
  (evil-global-set-key 'normal (kbd "M-l") 'evil-window-right)
  ;;(evil-define-key '(normal insert) global-map (kbd "M-h") 'evil-window-left)
  ;;(evil-define-key '(normal insert) global-map (kbd "M-l") 'evil-window-right)
  (evil-mode t))

;; Vim surround addon
(use-package evil-surround
  :config
  (global-evil-surround-mode t))

;; Vim tabs
(use-package evil-tabs)

;; Emacs git interface
(use-package magit)
(use-package evil-magit)

;; Leader bindings (/ + 'key')
(use-package evil-leader
  :config
  (global-evil-leader-mode t) ; Evil leader key set
  ;; Emacs functions
  (evil-leader/set-key "D" 'describe-function)
  ;; Ranger
  (evil-leader/set-key "r" 'ranger)
  ;; Programming
  (evil-leader/set-key "C" 'comment-line)
  (evil-leader/set-key "R" 'evil-show-registers)
  ;; Files navigation
  (evil-leader/set-key "e" 'helm-find)
  (evil-leader/set-key "f" 'helm-projectile-find-file)
  (evil-leader/set-key "d" 'helm-gtags-dwim)
  (evil-leader/set-key "j" 'helm-gtags-parse-file)
  (evil-leader/set-key "x" 'helm-gtags-pop-stack)
  (evil-leader/set-key "U" 'helm-gtags-update-tags)
  ;; Org mode
  (evil-leader/set-key "a" 'org-agenda)
  (evil-leader/set-key "L" 'org-insert-link)
  (evil-leader/set-key "l" 'org-store-link)
  (evil-leader/set-key "c" 'org-capture)
  (evil-leader/set-key "O" 'org-switchb)
  ;; Helm tweaks
  (evil-leader/set-key "v" 'helm-bookmarks)
  (evil-leader/set-key "b" 'helm-mini)
  (evil-leader/set-key "s" 'helm-swoop)
  ;; Projectile binding
  (evil-leader/set-key "p" 'helm-projectile-switch-project)
  (evil-leader/set-key "o" 'helm-projectile-find-other-file)
  ;; Open git window
  (evil-leader/set-key "g" 'magit-status))

;; (define-key 'evil-normal-state-map (kbd ",")
;;             (lookup-key evil-leader--default-map
;;                         (kbd "\\")))

;;; BEHAVIOUR

;; Line numbering
(global-linum-mode)
(setq linum-format "%4d | ")
(defun nolinum ()
  (linum-mode 0))

;; LaTeX setup
(add-hook 'latex-mode-hook 'visual-line-mode)

;; Spell checking 
;; http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html
;; find aspell and hunspell automatically
(cond
 ;; try hunspell at first
  ;; if hunspell does NOT exist, use aspell
 ((executable-find "hunspell")
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "sk_SK")
  (setq ispell-local-dictionary-alist
        ;; Please note the list `("-d" "sk_SK")` contains ACTUAL parameters passed to hunspell
        ;; You could use `("-d" "sk_SK,sk_SK-med")` to check with multiple dictionaries
        '(("sk_SK" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "sk_SK") nil utf-8)
          )))

 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=sk_SK"))))

(defun flyspell-check-next-highlighted-word ()
  "Function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word))

;; Start spell checking by default in latex files
(add-hook 'latex-mode-hook 'flyspell-mode)

;; Write both brackets
(electric-pair-mode)

;; IDE-like GDB
(setq gdb-many-windows t)

;; Turn off line truncating
(set-default 'truncate-lines -1)

;; Smart indentation enable
(setq indent-tabs-mode t)
;; (setq c-basic-offset 4)
;; (setq tab-width 4)

;; Set c code style
(setq c-default-style "bsd")

;; GDB environment
(setq gdb-many-windows t)
(setq gdb-show-main t)

;; Never show visual bell
(setq visible-bell nil)

;; Esc quits interactive lines
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
	  (setq deactivate-mark  t)
	(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
	(abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;;; USER INTERFACE

;; Color scheme
(use-package grandshell-theme
  :config
  (load-theme 'grandshell t))

;; Disable menu bar
(menu-bar-mode -1)

;; This part is generated automaticaly by emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3860a842e0bf585df9e5785e06d600a86e8b605e5cc0b74320dfe667bcbe816c" default)))
 '(ede-project-directories
   (quote
    ("/home/vagrant/dev/osdev/src/shell" "/home/vagrant/dev/osdev/src/lib" "/home/vagrant/dev/osdev/src/keyboard" "/home/vagrant/dev/osdev/src/kernel" "/home/vagrant/dev/osdev/src/include" "/home/vagrant/dev/osdev/src" "/home/vagrant/dev/osdev")))
 '(evil-shift-width 8)
 '(lsp-ui-imenu-enable nil)
 '(lsp-ui-sideline-enable nil)
 '(org-agenda-files (quote ("~/dev/notes/tmp.org" "~/dev/notes/org.org")))
 '(package-selected-packages
   (quote
    (ccls lsp-clang lsp-clangd company-lsp lsp-ui lsp-mode grandshell-theme ranger neotree rainbow-mode flycheck-pyflakes flycheck-pyflake markdown-mode evil-leader evil-magit magit evil-tabs evil-surround evil helm-projectile projectile helm-gtags helm-config helm-swoop helm sr-speedbar company ggtags use-package)))
 '(safe-local-variable-values
   (quote
    ((cmake-ide-build-dir . "/home/mato/dev/retdec/build")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ggtags-highlight ((t nil)))
 '(highlight-symbol-face ((t (:background "yellow" :foreground "color-16" :weight bold))))
 '(lsp-face-highlight-textual ((t (:inherit highlight :weight bold))))
 '(lsp-ui-doc-background ((t (:background "black"))))
 '(lsp-ui-peek-list ((t (:background "black" :weight bold))))
 '(lsp-ui-peek-peek ((t (:background "black" :weight bold)))))

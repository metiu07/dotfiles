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

;; CEDET - Emacs development tools
(use-package cedet
  :config
  ;; Project management for smart completion
  (require 'ede)
  (global-ede-mode t)

  (require 'cc-mode)
  (require 'semantic)
  (global-semanticdb-minor-mode 1)
  
  (semantic-mode 1))

;; Company mode - auto completion
(use-package company
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-gtags)
  (define-key c-mode-map  [(tab)] 'company-complete)
  (define-key c++-mode-map  [(tab)] 'company-complete)
  (add-hook 'after-init-hook 'global-company-mode))

;; Code browsing - sr-speedbar
(use-package sr-speedbar
  :config
  (add-hook 'buffer-quit-function 'sr-speedbar-close)
  (setq sr-speedbar-right-side nil))

(defun nolinum ()
   (linum-mode 0))

;; Incremental completitions - helm
(use-package helm
  :config
  (add-hook 'helm-minibuffer-set-up-hook 'nolinum)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (helm-mode 1))

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

(use-package helm-projectile
  :config
  (helm-projectile-on))

;; VIM initialization
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
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
  ;; Files navigation
  (evil-leader/set-key "e" 'helm-find)
  (evil-leader/set-key "f" 'helm-projectile-find-file)
  (evil-leader/set-key "d" 'helm-gtags-dwim)
  ;; Org mode
  (evil-leader/set-key "a" 'org-agenda)
  (evil-leader/set-key "L" 'org-insert-link)
  (evil-leader/set-key "l" 'org-store-link)
  (evil-leader/set-key "c" 'org-capture)
  (evil-leader/set-key "i" 'org-iswitchb)
  ;; Helm tweaks
  (evil-leader/set-key "v" 'helm-bookmarks)
  (evil-leader/set-key "b" 'helm-mini)
  (evil-leader/set-key "s" 'helm-swoop)
  ;; Projectile binding
  (evil-leader/set-key "p" 'helm-projectile-switch-project)
  (evil-leader/set-key "o" 'helm-projectile-find-other-file)
  ;; Open git window
  (evil-leader/set-key "g" 'magit-status))

;;; BEHAVIOUR
;; Line numbering
(global-linum-mode)
(setq linum-format "%d | ")
;; Write both brackets
(electric-pair-mode)

;; IDE-like GDB
(setq gdb-many-windows t)

;; Turn off line truncating
(set-default 'truncate-lines -1)

;; Smart indentation enable
(setq indent-tabs-mode t)
(setq c-basic-offset 4)
(setq tab-width 4)

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
;; Disable menu bar
(menu-bar-mode -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories
   (quote
    ("/home/vagrant/dev/osdev/src/shell" "/home/vagrant/dev/osdev/src/lib" "/home/vagrant/dev/osdev/src/keyboard" "/home/vagrant/dev/osdev/src/kernel" "/home/vagrant/dev/osdev/src/include" "/home/vagrant/dev/osdev/src" "/home/vagrant/dev/osdev")))
 '(org-agenda-files (quote ("~/dev/notes/tmp.org" "~/dev/notes/org.org")))
 '(package-selected-packages
   (quote
    (evil-leader evil-magit magit evil-tabs evil-surround evil helm-projectile projectile helm-gtags helm-config helm-swoop helm sr-speedbar company ggtags use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

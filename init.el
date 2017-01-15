;; Initialize package repositories
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Initializes packages, so we can use -> use-package
(package-initialize)

;; Ensure that we have every package we need
(setq use-package-always-ensure t)

;; Incremental completitions - helm
(use-package helm
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (helm-mode 1))

(use-package helm-swoop)
(require 'helm-config)

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
  (global-evil-leader-mode t)
  ; Evil leader key set
  (evil-leader/set-key "e" 'helm-find)
  (evil-leader/set-key "f" 'helm-projectile-find-file)
  (evil-leader/set-key "v" 'helm-bookmarks)
  (evil-leader/set-key "b" 'helm-mini)
  (evil-leader/set-key "s" 'helm-swoop)
  (evil-leader/set-key "p" 'helm-projectile-switch-project)
  (evil-leader/set-key "g" 'magit-status))

;;; BEHAVIOUR
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

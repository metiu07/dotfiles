;; Initialize package repositories
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Initializes packages, so we can use -> use-package
(package-initialize)

;; Ensure that we have every package we need
(setq use-package-always-ensure t)

;; VIM initialization
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t))

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

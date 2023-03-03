;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(after! org
  (set-face-attribute 'org-level-1 nil
                      :background nil
                      :foreground "color-26"
                      :height 1.7)
  (set-face-attribute 'org-level-2 nil
                      :height 1.5)
  (set-face-attribute 'org-level-3 nil
                      :height 1.3)
  (setq org-startup-folded nil))

(after! evil
  (evil-ex-define-cmd "W" "write"))

(after! magit
  (magit-todos-mode t)
  (setq magit-todos-auto-group-items 0
        magit-todos-group-by
        '(magit-todos-item-suffix magit-todos-item-filename))
        magit-repository-directories '(("~/dev/" . 0)
                                       ("~/tools/" . 0)))

(after! yasnippet
  (push (expand-file-name "snippets/" doom-private-dir) yas-snippet-dirs))

(after! company
  (setq company-idle-delay 0))

(setq lsp-keymap-prefix "M-p")

(map!
  (:after helm
    (:map helm-projectile-find-file-map
      "TAB"    #'helm-ff-run-switch-other-window)
    (:map helm-buffer-map
      "TAB"    #'helm-buffer-switch-other-window)))

(setq x-select-enable-clipboard nil)

(setq doom-theme 'doom-gruvbox)

(setq org-roam-directory "~/dev/roam")

(setq-default enable-local-variables t)

; unbind D key
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(after! evil
  (map! :n "u" 'evil-insert
        :n "U" 'evil-insert-line
        :n "l" 'evil-undo
        :nv "m" 'evil-backward-char
        :nv "n" 'evil-next-line
        :nv "e" 'evil-previous-line
        :nv "i" 'evil-forward-char
        :nv "f" 'evil-forward-word-end   
        :n "z" 'evil-backward-word-begin
        :n "d" 'evil-change   
        :n "D" 'evil-change-line
        :n "c" 'evil-delete-char
        :n "p" 'evil-replace
        :n "P" 'evil-replace-state
        :n "o" 'evil-paste-after
        :n "O" 'evil-paste-before
        :n "s" 'evil-delete
        :n "S" 'evil-delete-line
        :n "N" 'evil-join
        :nv "j" 'evil-yank
        :n "J" 'evil-yank-line
        :n "y" 'evil-open-below
        :n "Y" 'evil-open-above
        :n "k" 'evil-ex-search-next))

(after! evil-org
  (map! :map evil-org-mode-map
        :n "o" 'evil-paste-after
        :n "O" 'evil-paste-before
        :n "d" 'evil-change
        :n "D" 'evil-change-line
        :nv "z" 'evil-backward-word-begin
        :n "M-m" 'org-metaleft
        :n "M-n" 'org-metadown
        :n "M-e" 'org-metaup
        :n "M-i" 'org-metaright))

(after! magit
  (map! :map magit-mode-map
        :n "n" 'magit-next-line
        :n "e" 'magit-previous-line))

(map! :map org-agenda-mode-map
      :m "n" 'org-agenda-next-line
      :m "e" 'org-agenda-previous-line
      )

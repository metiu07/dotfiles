;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(after! org (set-face-attribute 'org-level-1 nil :background nil :foreground "color-26" :height 1.7)
  (set-face-attribute 'org-level-2 nil :height 1.5)
  (set-face-attribute 'org-level-3 nil :height 1.3))

(after! evil
  (evil-ex-define-cmd "W" "write"))

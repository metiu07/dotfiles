;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(after! org
  (set-face-attribute 'org-level-1 nil
                      :background nil
                      :foreground "color-26"
                      :height 1.7)
  (set-face-attribute 'org-level-2 nil
                      :height 1.5)
  (set-face-attribute 'org-level-3 nil
                      :height 1.3))

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

(map!
  (:after helm
    (:map helm-projectile-find-file-map
      "TAB"    #'helm-ff-run-switch-other-window)))

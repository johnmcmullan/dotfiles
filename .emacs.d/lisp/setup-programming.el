;;; setup-programming.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs startup file -- initialization for Emacs programming
;;; Code:

;; ------------------------------------------------------------------

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init
  (global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay .3)
  (flycheck-idle-change-delay 2.0)
  :config
  (progn
    ;; Settings
    (setq-default flycheck-emacs-lisp-initialize-packages t
                  flycheck-highlighting-mode 'symbols
                  flycheck-check-syntax-automatically '(save idle-update-delay)))
  (define-key flycheck-mode-map (kbd "M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "M-p") 'flycheck-previous-error))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook ((c-mode . lsp)
         (python-mode .lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :config
;  (setq lsp-prefer-flymake nil)
  :commands lsp)

(use-package lsp-ui
  :requires lsp-mode flycheck
  :config
  (setq lsp-ui-doc-include-signature nil  ; don't include type signature in the child frame
;        lsp-ui-sideline-show-symbol nil  ; don't show symbol on the right of info
;        lsp-ui-doc-enable nil
;        lsp-enable-links nil
;        lsp-ui-sideline-enable nil
        )
  (define-key lsp-ui-mode-map [f10] 'lsp-ui-sideline-toggle-symbols-info) ; F10 to toggle documentation

  :commands
  lsp-ui-mode)

(use-package yasnippet)

(use-package company
  :init
  (add-hook 'prog-mode-hook 'company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-minimum-prefix-length 1))

(use-package emacs-lisp
             :ensure nil
             :defer t)

;; GIT
(use-package magit
  :ensure t
  :defer t
  :config
  (setq truncate-lines nil)) ; wrap lines

(use-package magit-todos
  :after (magit))

;(use-package hl-todo
;  :config
;  (global-hl-todo-mode +1))

(provide 'setup-programming)
;;; setup-programming.el ends here

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
  :commands lsp
  :custom
;  (lsp-auto-guess-root t)
;  (lsp-enable-file-watchers nil)
  (lsp-prefer-flymake nil)
  :ensure t)

(use-package lsp-ui
  :commands lsp-ui-mode
  :ensure t)

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(use-package yasnippet)

(use-package company
  :hook
  ((nxml-mode . company-mode)
   (prog-mode . company-mode))
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

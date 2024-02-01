;;; setup-programming.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs startup file -- initialization for Emacs programming
;;; Code:

;; ------------------------------------------------------------------

;; never any tabs, anywhere!!!!
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq tramp-default-method 'ssh)
(setq tramp-default-user "john.mcmullan")
(setq tramp-default-host "ec2")

(use-package yasnippet)

(use-package company
  :hook
  ((nxml-mode . company-mode)
   (prog-mode . company-mode))
  :custom
  (company-backends '(company-capf))
  (company-tooltip-align-annotations t)
  (company-lsp-async t)
  )

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :custom
  (flycheck-display-errors-delay .3)
  (flycheck-idle-change-delay 2.0)
  :config
  (progn
    ;; Settings
    (setq-default flycheck-emacs-lisp-initialize-packages t
                  flycheck-highlighting-mode 'symbols
                  flycheck-check-syntax-automatically '(save idle-change)))
  :bind
  ("M-n" . flycheck-next-error)
  ("M-p" . flycheck-previous-error))

(use-package lsp-mode
  :ensure t
  :hook
  (c-mode-common . lsp-deferred)
  (python-mode . lsp-deferred)
  (ruby-mode . lsp-deferred)
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "/opt/llvm-10/bin/clangd")
                    :major-modes '(c-mode c++-mode)
                    :priority -1
                    :remote? t
                    :server-id 'clangd-remote))
  :custom
  (lsp-idle-delay 0.1)
  (lsp-clients-clangd-args
   (list "-j=4" "--clang-tidy" "--header-insertion-decorators=0" ))
  (lsp-prefer-flymake nil)
  (lsp-prefer-capf t)
  (lsp-auto-guess-root t)
  (lsp-keep-workspace-alive nil)
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("solargraph" "stdio"))
                    :major-modes '(ruby-mode)
                    :priority -1
                    :multi-root t
                    :server-id 'ruby-ls)))

(use-package lsp-ui
  :custom
  (lsp-lens-enable nil)
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-use-childframe nil)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-flycheck-enable t)
  (lsp-ui-flycheck-list-position 'bottom)
  (lsp-ui-flycheck-live-reporting t)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-list-width 60)
  (lsp-ui-peek-peek-height 25)
  :commands lsp-ui-mode
  :ensure t)

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

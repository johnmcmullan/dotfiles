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

(use-package company
  :hook
  ((nxml-mode . company-mode)
   (prog-mode . company-mode))
  :custom
  (company-backends '(company-capf))
  (company-tooltip-align-annotations t)
  (company-lsp-async t)
  )

; AI enhanced flycheck
(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :custom
  (flycheck-display-errors-delay .3)
  (flycheck-idle-change-delay 2.0)
  (flycheck-indication-mode 'left-margin)  ; Show indicators in the left margin
  (flycheck-highlighting-mode 'symbols)    ; Your existing setting
  (flycheck-standard-error-navigation t)   ; Enable standard error navigation
  :config
  (progn
    ;; Your existing settings
    (setq-default flycheck-emacs-lisp-initialize-packages t
                  flycheck-highlighting-mode 'symbols
                  flycheck-check-syntax-automatically '(save idle-change))
    
    ;; Enhanced error display for terminal
    (setq flycheck-error-list-format
          `[("Line" 5 flycheck-error-list-entry-< :right-align t)
            ("Col" 3 nil :right-align t)
            ("Level" 8 flycheck-error-list-entry-level-<)
            ("Message" 0 t)
            ("ID" 6 t)])
    
    ;; Customize error display function
    (defun my/flycheck-display-error-at-point ()
      "Display flycheck error in echo area more clearly."
      (interactive)
      (when flycheck-mode
        (let ((errors (flycheck-overlay-errors-at (point))))
          (when errors
            (message "%s" (mapconcat #'flycheck-error-message errors "\n"))))))
    
    ;; Set up margins for error indication
    (add-hook 'flycheck-mode-hook
              (lambda ()
                (setq left-margin-width 1)
                (set-window-buffer (selected-window) (current-buffer)))))
  
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error)
   ;; Additional convenient bindings for terminal use
   ("C-c ! l" . flycheck-list-errors)        ; Quick access to error list
   ("C-c ! n" . flycheck-next-error)         ; Alternative navigation
   ("C-c ! p" . flycheck-previous-error)
   ("C-c ! d" . my/flycheck-display-error-at-point))) ; Show current error clearly


;(use-package flycheck
;  :ensure t
;  :defer t
;  :diminish
;  :custom
;  (flycheck-display-errors-delay .3)
;  (flycheck-idle-change-delay 2.0)
;  :config
;  (progn
;    ;; Settings
;    (setq-default flycheck-emacs-lisp-initialize-packages t
;                  flycheck-highlighting-mode 'symbols
;                  flycheck-check-syntax-automatically '(save idle-change)))
;  :bind
;  ("M-n" . flycheck-next-error)
;  ("M-p" . flycheck-previous-error))

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
  (lsp-clients-clangd-command "/usr/bin/clangd")
  (lsp-clients-clangd-args
   (list "-j=4" "--clang-tidy" "--header-insertion-decorators=0" "--completion-style=detailed" "--header-insertion=never" "--log=verbose"))
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
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-use-childframe nil)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-flycheck-enable t)
  (lsp-ui-flycheck-list-position 'bottom)
  (lsp-ui-flycheck-live-reporting t)
  (lsp-ui-flycheck-indicate-warnings nil) ; AI suggestion
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-list-width 60)
  (lsp-ui-peek-peek-height 25)
  (lsp-ui-peek-always-show nil) ; AI suggestion
  (lsp-ui-peek-show-directory t) ; AI suggestion
  :commands lsp-ui-mode
  :ensure t
  :bind
  (:map lsp-ui-mode-map
        ("C-c d" . lsp-ui-doc-show)    ; Manual doc popup
        ("C-c h" . lsp-ui-doc-hide)))  ; Hide doc popup)

(use-package yasnippet)
(add-hook 'c-mode-common-hook #'yas-minor-mode)

(use-package emacs-lisp
  :ensure nil
  :defer t)

(use-package copilot
  :ensure t
  :bind
  (:map lsp-ui-mode-map
        ("C-c c" . copilot-complete)
        ("C-c a" . copilot-accept-completion)))

(use-package ellama
  :config
  (require 'llm-ollama)
  (setq ellama-provider
		'(make-llm-ollama
		  :host "10.73.111.146"
		  :port 11434
		  :chat-model "qwen2.5-coder:14b"
		  :embedding-model "nomic-embed-text")))

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

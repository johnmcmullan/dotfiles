;;; setup-c.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs startup file -- initialization for Emacs coding
;;; Code:

; The actual GCC and LLVM that rdm uses
(setenv "LD_LIBRARY_PATH" "/opt/llvm-6.0/lib64:/opt/gcc-8.2.0/lib64")

;; ------------------------------------------------------------------
; .cpp -> .h etc
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; TBricks C++ mode
(c-add-style "tbricks"
             '("linux"
               (c-basic-offset . 4)
               (c . c-lineup-streamop)
;               (c-offsets-alist . (
;                                   (c . c-lineup-C-comments)
;                                   (statement-case-open . 0)
;                                   (case-label . +)
;                                   (substatement-open . +)
;				   ))
               ))

(defun tbricks-c++-mode-hook () "Set up C++ mode for Tbricks."
  (c-set-style "tbricks")
  (c-set-offset 'innamespace 0)
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq whitespace-style '(trailing tabs tab-mark)))

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (c++-mode . "tbricks")
			(c-mode . "tbricks")
                        (other . "gnu")))
(add-hook 'c-mode-common-hook 'tbricks-c++-mode-hook)

(use-package clang-format
  :custom
  (clang-format-style "file"))

;; CCLS
;; ------------------------------------------------------------------

(require 'yasnippet) ; template arguments
(require 'company-yasnippet)
(require 'flycheck)

(use-package lsp-mode
  :init
  (require 'lsp-clients)
  :config
  (define-key lsp-mode-map (kbd "M-.") 'lsp-find-definition)
  (define-key lsp-mode-map (kbd "M-,") 'lsp-find-references)
  :custom
  (lsp-auto-guess-root t)
  (lsp-eldoc-render-all nil)
  (lsp-prefer-flymake nil)
  (lsp-file-watch-threshold 2500)
  :commands
  lsp)

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

(use-package flycheck-clangcheck)

(use-package lsp-ui
  :requires lsp-mode flycheck
  :config
  (setq lsp-ui-doc-include-signature nil  ; don't include type signature in the child frame
        lsp-ui-sideline-show-symbol nil  ; don't show symbol on the right of info
        lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil)
  (define-key lsp-ui-mode-map [f10] 'lsp-ui-sideline-toggle-symbols-info) ; F10 to toggle documentation
  :commands
  lsp-ui-mode)

(use-package company
  :init
  (add-hook 'prog-mode-hook 'company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-minimum-prefix-length 1))

(use-package company-lsp
  :requires company
  :commands
  company-lsp
  :config
  (push 'company-lsp company-backends)
  :custom
  (company-lsp-async t)
  (company-lsp-cache-candidates 'auto)
  (company-lsp-enable-recompletion t))

(use-package ccls
  :defer t
  :init
  (add-hook 'c-mode-common-hook (lambda () (require 'ccls) (lsp)))
  :custom
  (ccls-executable "~/work/apps/.vscode/ccls" "Fedor's ccls")
  (ccls-args '("--log-file=/tmp/ccls.log"))
  (ccls-initialization-options
   '(:clang (:resourceDir "/opt/llvm-6.0/lib64/clang/6.0.1")))
  (ccls-sem-highlight-method nil))

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

(use-package hl-todo
  :config
  (global-hl-todo-mode +1))

(provide 'setup-c)
;;; setup-c.el ends here

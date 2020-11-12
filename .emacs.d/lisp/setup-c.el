;;; setup-c.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs startup file -- initialization for Emacs c programming
;;; Code:

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

(if (executable-find "ccls")
    (use-package ccls
                 :defer t
                 :init
                 (add-hook 'c-mode-common-hook (lambda () (require 'ccls) (lsp)))
                 :custom
;                 (ccls-executable "~/bin/ccls" "ccls for llvm-9")
                 (ccls-args '("--log-file=/tmp/ccls.log"))
                 (if (neq window-system 'ns)
                     (ccls-initialization-options
                      '(:clang (:resourceDir "/opt/llvm-9/lib64/clang/9.0.0"))))
                 ))

(provide 'setup-c)
;;; setup-c.el ends here

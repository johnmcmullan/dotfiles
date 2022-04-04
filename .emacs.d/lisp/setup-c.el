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
               (c-offsets-alist . (
                                   (innamespace . [0])
                                   (c . c-lineup-C-comments)
                                   (statement-case-open . 0)
                                   (case-label . +)
                                   (substatement-open . 0)
				   ))
             ))

(defun tbricks-c++-mode-hook () "Set up C++ mode for Tbricks."
  (c-set-style "tbricks")
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  )

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (c++-mode . "tbricks")
			(c-mode . "tbricks")
                        (other . "gnu")))
(add-hook 'c-mode-common-hook 'tbricks-c++-mode-hook)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
(add-hook 'c-mode-common-hook #'yas-minor-mode)
(add-hook 'c-mode-common-hook #'company-mode)

;(use-package clang-format
;  :custom
;  (clang-format-style "file"))

;; CCLS
;; ------------------------------------------------------------------

;(if (executable-find "ccls")
;    (use-package ccls
;                 :defer t
;                 :init
;                 (add-hook 'c-mode-common-hook (lambda () (require 'ccls) (lsp)))
;                 :custom
;                 (ccls-args '("--log-file=/home/john.mcmullan/tmp/ccls.log"))
;                 (ccls-initialization-options
;                  '(:clang (:resourceDir "/opt/llvm-10/lib64/clang/10.0.1"))))
;  )

(provide 'setup-c)
;;; setup-c.el ends here

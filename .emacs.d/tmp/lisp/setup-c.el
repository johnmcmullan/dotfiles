;; setup-c.el

; The actual GCC and LLVM that rdm uses
(setenv "LD_LIBRARY_PATH" "/opt/llvm-6.0/lib64:/opt/gcc-8.2.0/lib64")

; .cpp -> .h etc
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; clang-format
(setq clang-format-style "file")

;; ------------------------------------------------------------------
;; TBricks C++ mode
(c-add-style "tbricks"
             '("linux"
               (c-basic-offset . 4)
;               (c-offsets-alist . (
;                                   (c . c-lineup-C-comments)
;                                   (statement-case-open . 0)
;                                   (case-label . +)
;                                   (substatement-open . +)
;				   ))
))
(defun tbricks-c++-mode-hook ()
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


;; ------------------------------------------------------------------
;; RTAGS, company, yasnippet, flycheck

(require 'yasnippet) ; template arguments
(require 'rtags)     ; symbol lookup
(require 'irony)     ; clang completion
(require 'company)   ; completion
(require 'flycheck)
(require 'company-c-headers)
(require 'company-rtags)
(require 'company-irony)
(require 'company-yasnippet)

(rtags-start-process-unless-running)
(rtags-enable-standard-keybindings)
;(setq rtags-autostart-diagnostics t)
;(rtags-diagnostics)
; no thanks, too slow
;(setq rtags-completions-enabled t)

; keys for rtags lookup
(define-key c-mode-base-map (kbd "M-.")
  (function rtags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "M-,")
  (function rtags-find-references-at-point))

(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
(add-hook 'c-mode-common-hook 'irony-mode)
(add-hook 'c-mode-common-hook 'global-company-mode)
(add-hook 'lisp-mode-hook 'global-company-mode)

(defun company-c-headers-includes()
    (add-to-list 'company-c-headers-path-system "$SDK/include64/")
    (add-to-list 'company-c-headers-path-system "$GCC_SUITE/include/c++/8.2.0/")
    (add-to-list 'company-c-headers-path-system "$LLVM/include/c++/v1/"))
(company-c-headers-includes)

;;(setq company-backends (delete 'company-semantic company-backends))
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony company-c-headers)))

; replace the `completion-at-point' and `complete-symbol' bindings in
; irony-mode's buffers by irony-mode's function
(defun tb-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'tb-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

; eldoc
(add-hook 'irony-mode-hook #'irony-eldoc)

(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

; flycheck
(add-hook 'c-mode-common-hook 'flycheck-mode)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(provide 'setup-c)

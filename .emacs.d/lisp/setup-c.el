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
               (c-basic-offset . 4)     ; Guessed value
               (c-offsets-alist
                (block-close . 0)       ; Guessed value
                (brace-list-intro . ++) ; Guessed value
                (case-label . 0)        ; Guessed value
                (catch-clause . 0)      ; Guessed value
                (class-close . 0)       ; Guessed value
                (class-open . 0)        ; Guessed value
                (cpp-define-intro . +)  ; Guessed value
                (defun-block-intro . +) ; Guessed value
                (defun-close . 0)       ; Guessed value
                (defun-open . 0)        ; Guessed value
                (else-clause . 0)       ; Guessed value
                (inclass . +)           ; Guessed value
                (inline-close . 0)      ; Guessed value
                (member-init-cont . -)  ; Guessed value
                (member-init-intro . +) ; Guessed value
                (statement . 0)             ; Guessed value
                (statement-block-intro . +) ; Guessed value
                (statement-case-intro . +) ; Guessed value
                (statement-cont . ++)   ; Guessed value
                (stream-op . 3)         ; Guessed value
                (substatement . +)      ; Guessed value
                (substatement-open . 0) ; Guessed value
                (topmost-intro . 0)     ; Guessed value
                (topmost-intro-cont . 0) ; Guessed value
                (access-label . -)
                (annotation-top-cont . 0)
                (annotation-var-cont . +)
                (arglist-close . c-lineup-close-paren)
                (arglist-cont c-lineup-gcc-asm-reg 0)
                (arglist-cont-nonempty . c-lineup-arglist)
                (arglist-intro . +)
                (block-open . 0)
                (brace-entry-open . 0)
                (brace-list-close . 0)
                (brace-list-entry . 0)
                (brace-list-open . 0)
                (c . c-lineup-C-comments)
                (comment-intro . c-lineup-comment)
                (composition-close . 0)
                (composition-open . 0)
                (cpp-macro . -1000)
                (cpp-macro-cont . +)
                (do-while-closure . 0)
                (extern-lang-close . 0)
                (extern-lang-open . 0)
                (friend . 0)
                (func-decl-cont . +)
                (incomposition . +)
                (inexpr-class . +)
                (inexpr-statement . +)
                (inextern-lang . +)
                (inher-cont . c-lineup-multi-inher)
                (inher-intro . +)
                (inlambda . 0)
                (inline-open . +)
                (inmodule . +)
                (innamespace . +)
                (knr-argdecl . 0)
                (knr-argdecl-intro . 0)
                (label . 0)
                (lambda-intro-cont . +)
                (module-close . 0)
                (module-open . 0)
                (namespace-close . 0)
                (namespace-open . 0)
                (objc-method-args-cont . c-lineup-ObjC-method-args)
                (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
                (objc-method-intro .
                                   [0])
                (statement-case-open . 0)
                (string . -1000)
                (substatement-label . 0)
                (template-args-cont c-lineup-template-args +))))

(defun tbricks-c++-mode-hook () "Set up C++ mode for Tbricks."
       (c-set-style "tbricks"))

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (c++-mode . "tbricks")
			            (c-mode . "tbricks")
                        (other . "gnu")))
(add-hook 'c-mode-common-hook 'tbricks-c++-mode-hook)
(add-hook 'c-mode-common-hook #'yas-minor-mode)

(use-package clang-format
  :custom
  (clang-format-style "file"))

(defun tbricks-apps-test-path (file-dir file-name)
  "Change a Tbricks apps path to its tests path and add the .profdata file."
  (let ((try
         (concat (file-name-as-directory
		          (replace-regexp-in-string "apps" "apps\/tests" file-dir))
		         ".profdata")))
    (and (file-exists-p try)
         (cons (file-truename try) 'lcov))))

(setq cov-coverage-mode 't)
(setq cov-coverage-file-paths '(tbricks-apps-test-path))

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

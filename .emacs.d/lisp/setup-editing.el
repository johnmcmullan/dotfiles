;; package --- setup-editing
;;; Commentary: general emacs setup, keys etc

;;; Code:

;; ------------------------------------------------------------------
;; Key mappings

(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "C-x o") 'ff-find-other-file)
(global-set-key (kbd "C-x f") 'lsp-execute-code-action)
(global-set-key (kbd "M-3") #'(lambda () (interactive) (insert "#")))
(global-set-key (kbd "<wheel-up>") 'scroll-down)
(global-set-key (kbd "<wheel-down>") 'scroll-up)

;; Fine-grained scrolling control
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1) ((control) . 5)))  ; 2 lines at a time
(setq mouse-wheel-progressive-speed nil)  ; Don't accelerate scrolling
(setq scroll-conservatively 10000)  ; Never recenter point

;; For Emacs 30 specifically 
(pixel-scroll-precision-mode 1)  ; Enable pixel-level scrolling
(setq pixel-scroll-precision-interpolate-page nil)  ; Disable interpolation
(setq pixel-scroll-precision-use-momentum nil)  ; Disable momentum


(eval-after-load "cc-mode"
  '(define-key c-mode-base-map (kbd "C-a") 'beginning-of-line-or-indentation))
(provide 'setup-editing)

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
(setq scroll-step 2)



(eval-after-load "cc-mode"
  '(define-key c-mode-base-map (kbd "C-a") 'beginning-of-line-or-indentation))
(provide 'setup-editing)

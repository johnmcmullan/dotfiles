;; setup-editing

;; ------------------------------------------------------------------
;; Key mappings
;; scroll two lines at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2))) ;; two lines at a time
;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 2) ;; keyboard scroll one line at a time

(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "C-x o") ' ff-find-other-file)
(global-set-key (kbd "C-a") 'beginning-of-line-or-indentation)
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(provide 'setup-editing)

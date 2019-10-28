;; setup-general.el

(setq visible-bell t)
(menu-bar-mode -1)
(global-hl-line-mode)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "vijay.sharma")

(server-start)

; backups in one place
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.saves"))    ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups
; auto-save in one place
(setq auto-save-file-name-transforms
      '((".*" "~/.saves/" t)))

;; never any tabs, anywhere!!!!
(setq-default indent-tabs-mode nil)

; Highlighting of FIXME and TODO et al
(require 'fic-mode)
(add-hook 'c-mode-common-hook 'fic-mode)
(add-hook 'emacs-lisp-mode-hook 'fic-mode)

;; remove trailing whitespace automatically
(require 'ws-butler)

; https://www.emacswiki.org/emacs/EightyColumnRule
(require 'fill-column-indicator)
(setq-default fci-rule-width 5)
(setq-default fci-rule-color "#ff0000")
(setq-default fill-column 120)
(add-hook 'c-mode-common-hook 'fci-mode)


(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'c-mode-common-hook 'set-newline-and-indent)
(add-hook 'lisp-mode-hook 'set-newline-and-indent)
(add-hook 'ruby-mode-hook 'set-newline-and-indent)

(defun beginning-of-line-or-indentation ()
  "move to beginning of line, or indentation"
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

;; ZENBURN theme
;(load-theme 'zenburn t)

(provide 'setup-general)

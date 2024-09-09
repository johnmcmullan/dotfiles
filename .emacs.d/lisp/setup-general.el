;; package --- setup-general
;;; Commentary: general emacs setup, keys etc

;;; Code:

(setq visible-bell t)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (menu-bar-mode -1)
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

(if window-system
    (setq url-proxy-services
          '(("no_proxy" . "^\\(localhost\\|10.*\\)")
            ("http" . "10.32.22.18:8080")
            ("https" . "10.32.22.18:8080")))
  (setq url-http-proxy-basic-auth-storage
        (list (list "10.32.22.18:8080"
                    (cons "Input your LDAP UID !"
                          (base64-encode-string "mcmullanj:K0n4L4v4D0m3!09")))))
  )

(use-package pbcopy
  :config
  (turn-on-pbcopy)
  )

(use-package clipetty
  :config
  (global-clipetty-mode)
  )

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "john.mcmullan")

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
; no lock files
(setq create-lockfiles nil)

;; never any tabs, anywhere!!!!
;(setq-default indent-tabs-mode nil)

; Highlighting of FIXME and TODO et al
;(require 'fic-mode)
;(add-hook 'c-mode-common-hook 'fic-mode)
;(add-hook 'emacs-lisp-mode-hook 'fic-mode)

;; remove trailing whitespace automatically
;(require 'ws-butler)

; https://www.emacswiki.org/emacs/EightyColumnRule
;(require 'fill-column-indicator)
;(add-hook 'c-mode-common-hook 'fci-mode)
;(setq fill-column 120)

; for C-a
(defun beginning-of-line-or-indentation ()
  "move to beginning of line, or indentation"
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(provide 'setup-general)
;;; setup-general ends here

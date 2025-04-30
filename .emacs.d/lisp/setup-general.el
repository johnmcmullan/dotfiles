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
  ;; Enable 24-bit color support
  (setq xterm-color-use-bright-colors t)
  
  ;; Set up ANSI color mapping
  (setq ansi-color-for-comint-mode t)
  (setq ansi-color-names-vector
        ["black" "red3" "green3" "yellow3"
         "blue2" "magenta3" "cyan3" "gray90"])

  (setq auto-window-vscroll nil)
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
(setq show-trailing-whitespace t)
(setq-default indent-tabs-mode nil)

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
(setq-default indent-tabs-mode nil)
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

;; Project management
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-project-root-files
      (cons "compile_commands.json" 
            (delete "pom.xml" projectile-project-root-files)))

    ;; Function to find the nearest directory with a GNUmakefile
  (defun my/tbricks-find-app-root (dir)
    "Find the Tbricks app root by looking for GNUmakefile."
    (let ((root (locate-dominating-file dir "GNUmakefile")))
      (when root
        (file-truename root))))

  ;; Custom function to create compilation database
  (defun my/projectile-create-compilation-database ()
    "Create compilation database and reload LSP workspace."
    (interactive)
    (let* ((current-file (buffer-file-name))
           (app-root (when current-file 
                      (my/tbricks-find-app-root current-file))))
      (if app-root
          (let ((default-directory app-root))
            (message "Creating compilation database in %s..." app-root)
            (async-shell-command "make db.create")
            (set-process-sentinel 
             (get-buffer-process "*Async Shell Command*")
             (lambda (process event)
               (when (string= event "finished\n")
                 (message "Compilation database created, restarting LSP...")
                 (sleep-for 1)
                 (lsp-workspace-restart)))))
        (message "Could not find Tbricks app root directory!"))))
  
    ;; Custom function to find corresponding test files
  (defun my/projectile-test-file-p (file)
    "Check if FILE is a test file in Tbricks structure."
    (string-match-p "/tests/" file))
  
  (defun my/projectile-test-with-prefix (file)
    "Find test file for FILE in Tbricks structure."
    (let* ((project-root (projectile-project-root))
           (relative-path (file-relative-name file project-root))
           (test-path (replace-regexp-in-string
                      "^apps/\\(.*\\)$"
                      "apps/tests/\\1"
                      relative-path)))
      (expand-file-name test-path project-root)))
  
  ;; Tell Projectile about our custom test setup
  (setq projectile-test-files-suffixes nil)  ; Disable suffix-based detection
  (setq projectile-test-prefix nil)          ; Disable prefix-based detection
  (setq projectile-test-file-fn #'my/projectile-test-file-p)
  
  (add-to-list 'projectile-project-types
               '(cpp-compile-commands
                 :compile "make -j5"
                 :test "make -j5 test"
                 :run "make -j5 install SYSTEM=jmm"
                 :test-file-fn my/projectile-test-with-prefix))
  
(setq projectile-project-root-files-functions
      '(projectile-root-top-down
        projectile-root-bottom-up
        projectile-root-local))

    ;; Add a keybinding for database creation
  :bind (:map projectile-command-map
              ("D" . my/projectile-create-compilation-database))
  
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; Improved file navigation
;(use-package counsel
;  :bind
;  ("C-x C-f" . counsel-find-file)
;  ("M-x" . counsel-M-x))

(provide 'setup-general)
;;; setup-general ends here

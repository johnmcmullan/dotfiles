;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs startup file -- initialization for Emacs
;;; Code:

;; ------------------------------------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dea4b7d43d646aa06a4f705a58f874ec706f896c25993fcf73de406e27dc65ba" "3b8284e207ff93dfc5e5ada8b7b00a3305351a3fb222782d8033a400a48eca48" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "9d91458c4ad7c74cf946bd97ad085c0f6a40c370ac0a1cbeb2e3879f15b40553" "f2c35f8562f6a1e5b3f4c543d5ff8f24100fae1da29aeb1864bbc17758f52b70" default))
 '(package-selected-packages
   '(use-package flatbuffers-mode lsp-sonarlint cov git-lens lsp-java pbcopy robe projectile which-key company-prescient yasnippet-snippets modern-cpp-font-lock yasnippet lsp-mode lsp-treemacs lsp-ui zenburn-theme ccls magit-todos magit clang-format hl-todo pyvenv ws-butler docbook)))

(package-install-selected-packages)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'setup-general)
(require 'setup-editing)
(require 'setup-lisp)
(require 'setup-c)
(require 'setup-programming)

(if (not (eq system-type 'darwin))
    (load-theme 'zenburn)
  (load-theme 'leuven)
  )

(provide 'init)
;;; init.el ends here

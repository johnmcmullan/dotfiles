;; init.el

(require 'package)
(require 'cl)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(add-to-list 'load-path "~/.emacs.d/lisp")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("zenburn" "9d91458c4ad7c74cf946bd97ad085c0f6a40c370ac0a1cbeb2e3879f15b40553" default)))
 '(package-selected-packages
   (quote
    (aggressive-indent neotree auto-complete auto-complete-clang c-eldoc clang-format company company-c-headers company-irony fic-mode flycheck flycheck-irony irony irony-eldoc rtags company-rtags zenburn-theme fill-column-indicator ws-butler yasnippet yasnippet-snippets))))

(package-install-selected-packages)

(require 'setup-general)
(require 'setup-editing)
(require 'setup-general)
(require 'setup-c)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

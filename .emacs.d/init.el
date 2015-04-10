(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/.emacs.d/el-get/magit")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(autoload 'cc-mode+ "cc-mode+" "" t) 
(add-to-list 'auto-mode-alist '("\\.c[c]?$" . cc-mode+))
(add-to-list 'auto-mode-alist '("\\.cpp$" . cc-mode+))
(add-to-list 'auto-mode-alist '("\\.h$" . cc-mode+))
(add-to-list 'auto-mode-alist '("\\.hpp$" . cc-mode+))

(autoload 'ruby-mode "php-mode" "" t) 
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php3$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php4$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php5$" . php-mode))

(autoload 'ruby-mode "ruby-mode" "" t) 
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))

(autoload 'web-mode "web-mode" "" t) 
(add-to-list 'auto-mode-alist '("\\.phtml$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.htm$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css$" . web-mode))

(autoload 'lua-mode "lua-mode" "" t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("f37d09076188b2e8d2a6847931deec17f640853aedd8ea4ef3ac57db01335008" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Zenburn theme, does not hurt my eye balls
(load-theme 'zenburn t)

; Git support
(setq magit-last-seen-setup-instructions "1.4.0")         
(require 'magit)


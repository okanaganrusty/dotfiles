((ample-regexps status "installed" recipe
		(:name ample-regexps :description "Compose and reuse Emacs regular expressions with ease" :type github :pkgname "immerrr/ample-regexps.el"))
 (cc-mode+ status "installed" recipe
	   (:name cc-mode+ :auto-generated t :type emacswiki :description "Extensions to `c-mode.el' & `cc-mode.el'." :website "https://raw.github.com/emacsmirror/emacswiki.org/master/cc-mode+.el"))
 (cl-lib status "installed" recipe
	 (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (color-theme status "installed" recipe
	      (:name color-theme :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme" :website "http://www.nongnu.org/color-theme/" :type http-tar :options
		     ("xzf")
		     :url "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz" :load "color-theme.el" :features "color-theme" :post-init
		     (progn
		       (color-theme-initialize)
		       (setq color-theme-is-global t))))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
		("el-get.*\\.el$" "methods/")
		:features el-get :post-init
		(when
		    (memq 'el-get
			  (bound-and-true-p package-activated-list))
		  (message "Deleting melpa bootstrap el-get")
		  (unless package--initialized
		    (package-initialize t))
		  (when
		      (package-installed-p 'el-get)
		    (let
			((feats
			  (delete-dups
			   (el-get-package-features
			    (el-get-elpa-package-directory 'el-get)))))
		      (el-get-elpa-delete-package 'el-get)
		      (dolist
			  (feat feats)
			(unload-feature feat t))))
		  (require 'el-get))))
 (git-modes status "installed" recipe
	    (:name git-modes :description "GNU Emacs modes for various Git-related files" :type github :branch "master" :pkgname "magit/git-modes"))
 (lua-mode status "installed" recipe
	   (:name lua-mode :description "A major-mode for editing Lua scripts" :depends
		  (ample-regexps)
		  :type github :pkgname "immerrr/lua-mode"))
 (magit status "installed" recipe
	(:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :branch "master" :depends
	       (cl-lib git-modes)
	       :info "." :compile "magit.*\\.el\\'" :build
	       `(("make" ,(format "EMACSBIN=%s" el-get-emacs)
		  "docs"))
	       :build/berkeley-unix
	       (("gmake"
		 (\,
		  (format "EMACSBIN=%s" el-get-emacs))
		 "docs"))
	       :build/windows-nt
	       (progn nil)))
 (nginx-mode status "installed" recipe
	     (:name nginx-mode :website "https://github.com/ajc/nginx-mode" :description "major mode for editing nginx config files" :type github :pkgname "ajc/nginx-mode"))
 (php-mode status "installed" recipe
	   (:name php-mode :description "A PHP mode for GNU Emacs " :type github :pkgname "ejmr/php-mode" :website "https://github.com/ejmr/php-mode"))
 (ruby-mode status "installed" recipe
	    (:name ruby-mode :builtin "24" :type http :description "Major mode for editing Ruby files." :url "http://bugs.ruby-lang.org/projects/ruby-trunk/repository/raw/misc/ruby-mode.el"))
 (web-mode status "installed" recipe
	   (:name web-mode :description "emacs major mode for editing PHP/JSP/ASP HTML templates (with embedded CSS and JS blocks)" :type github :pkgname "fxbois/web-mode")))

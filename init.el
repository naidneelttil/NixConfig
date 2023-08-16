
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(load-theme 'gruvbox-light-hard t)

(display-line-numbers-mode 1)
(setq display-line-numbers 'relative)

(set-frame-font "Inconsolata 18")
(add-to-list 'default-frame-alist
             '(font . "Inconsolata 18"))

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

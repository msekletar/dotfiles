;; add additional package installation source (MELPA)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

; always start server at startup
(server-start)

;; set default mail address for emacs to use
(setq user-mail-address "msekleta@redhat.com")

;; make buffer names unique
(require 'uniquify)
(setq  uniquify-buffer-name-style 'post-forward )

;; add folder with my own LISP extensions to load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

; turn off weird bell sound
(setq ring-bell-function 'ignore)

; turn on yasnippet
(require 'yasnippet)
(yas-global-mode 1)

; turn off unwanted *bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

; show matching parentheses
(show-paren-mode 1)

; turn on ido mode
(require 'flx-ido)
(ido-mode t)
(ido-everywhere t)
(setq ido-use-faces nil)

; do not display emacs splash screen on start-up
(setq inhibit-splash-screen t)

; save backup files to ~/.saves 
(setq backup-directory-alist `(("." . "~/.saves")))

; don't indent with tabs because they are usefull as hole in the head
(setq-default indent-tabs-mode nil)

; in cc-mode indent offset is 8 spaces
(setq c-basic-offset 8)

; wrap at 80 columns in c mode
(add-hook 'c-mode-common-hook
  '(lambda() (set-fill-column 80)))

;; wrap at 80 columns in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook
  '(lambda() (set-fill-column 80)))

;; wrap at 72 in git commit mode
(add-hook 'git-commit-mode-hook
  '(lambda() (set-fill-column 72)))

;; all files containing string mutt in its name will be opened in mail mode
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))

;; wrap at 80 columns in mail mode
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook
  '(lambda() (set-fill-column 80)))

;; proper formatting of git commit messages
(add-hook 'git-commit-mode-hook 'turn-on-flyspell)

; compilation mode settings
(setq compile-command "make -j4")
(setq compilation-scroll-output t)
(setq compilation-always-kill t)
(setenv "GCC_COLORS" "")

; helm config
(require 'helm-git-grep) ;; Not necessary if installed by package.el
(global-set-key (kbd "C-c g") 'helm-git-grep)
; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

; use ssh method for tramp by default
(require 'tramp)
(setq tramp-default-method "ssh")

; awesome virt-manager
(require 'virt-manager)

; use ibuffer of C-x C-b
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

; custom keyboard shortcuts
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-c C-k") 'compile)

; view manpage
(global-set-key "\C-cw"
                (lambda ()
                  (interactive)
                  (let ((woman-use-topic-at-point t))
                    (woman))))

; kernel coding style for ~/devel/upstream/kernel
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/devel/upstream/net-next")
                                       filename))
                (setq indent-tabs-mode t)
                (setq show-trailing-whitespace t)
                (c-set-style "linux-tabs-only")))))

;; function to cleanup and indent buffer
(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;; org mode settings
(setq org-directory "~/Documents/gtd")

;; org-capture settings
(setq org-default-notes-file (concat org-directory "/inbox.org"))

;; org archive
;(setq org-archive-location (concat org-directory "/gtd_archive.org"))

;; some useful shortcuts
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;; enable fly-spell for org, emails and git commit messages
(dolist (hook '(org-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(mail-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(git-commit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; use irony-mode for code completion
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; company mode setup
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-backends (delete 'company-semantic company-backends))
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(defun ignore-error-wrapper (fn)
  "Funtion return new function that ignore errors.
   The function wraps a function with `ignore-errors' macro."
  (lexical-let ((fn fn))
    (lambda ()
      (interactive)
      (ignore-errors
        (funcall fn)))))

; easier navigation between split windows (Shift + arrow keys)
(global-set-key [s-left] (ignore-error-wrapper 'windmove-left))
(global-set-key [s-right] (ignore-error-wrapper 'windmove-right))
(global-set-key [s-up] (ignore-error-wrapper 'windmove-up))
(global-set-key [s-down] (ignore-error-wrapper 'windmove-down))

;; gofmt to format the code before buffer is saved
(add-hook 'before-save-hook 'gofmt-before-save)

;; bind remove unused imports to C-c C-r
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))

;; bind go to imports to C-c i
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "C-c i") 'go-goto-imports)))

;; cscope with helm
(require 'xcscope)
(cscope-setup)
(setq cscope-index-recursively t)
(setq cscope-option-do-not-update-database t)
(setq cscope-option-use-inverted-index t)

;; Enable helm-cscope-mode
(add-hook 'c-mode-hook 'helm-cscope-mode)
(add-hook 'c++-mode-hook 'helm-cscope-mode)
;; Set key bindings
(eval-after-load "helm-cscope"
  '(progn
     (define-key helm-cscope-mode-map (kbd "M-t") 'helm-cscope-find-this-symbol)
     (define-key helm-cscope-mode-map (kbd "M-r") 'helm-cscope-find-global-definition)
     (define-key helm-cscope-mode-map (kbd "M-g M-c") 'helm-cscope-find-called-function)
     (define-key helm-cscope-mode-map (kbd "M-g M-p") 'helm-cscope-find-calling-this-funtcion)
     (define-key helm-cscope-mode-map (kbd "M-s") 'helm-cscope-select)))

(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(global-set-key (kbd "C-`") 'push-mark-no-activate)
(global-set-key (kbd "C-h ;") 'helm-info-libc)

;; go mode setting
(add-to-list 'exec-path "/home/msekleta/dev/go/bin")

(defun my-go-mode-hook ()
  (local-set-key (kbd "M-.") 'godef-jump)
  (set (make-local-variable 'company-backends) '(company-go)))

(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; interpret vim modeline in emacs
(require 'vim-modeline)
(add-to-list 'find-file-hook 'vim-modeline/do)

;; completing filenames in buffer
(fset 'my-complete-file-name
      (make-hippie-expand-function '(try-complete-file-name-partially
                                     try-complete-file-name)))
(global-set-key "\M-\\" 'my-complete-file-name)

;; eval local variables
(setq enable-local-eval t)

;; add additional package installation source (MELPA)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; set default mail address for emacs to use
(setq user-mail-address "msekleta@redhat.com")

;; make buffer names unique
(require 'uniquify)
(setq  uniquify-buffer-name-style 'post-forward )

;; make emacs look good
(provide 'init-themes)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(load-theme 'github t)


;; turn on yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; turn off unwanted *bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

;; turn on ido mode
(require 'flx-ido)
(ido-mode t)
(ido-everywhere t)
(setq ido-use-faces nil)

;; do not display emacs splash screen on start-up
(setq inhibit-splash-screen t)

;; save backup files to ~/.saves 
(setq backup-directory-alist `(("." . "~/.saves")))

;; don't indent with tabs because they are usefull as hole in the head
(setq-default indent-tabs-mode nil)

;; in cc-mode indent offset is 8 spaces
(setq c-basic-offset 8)

;; wrap at 80 columns in c mode
(add-hook 'c-mode-common-hook
  '(lambda() (set-fill-column 80)))
(add-hook 'c-mode-common-hook
  '(lambda() (linum-mode)))

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
(add-hook 'git-commit-mode-hook (lambda () (toggle-save-place 0)))

;; use rpm-spec-mode when editing specfile
(autoload 'rpm-spec-mode "rpm-spec-mode.el" "RPM spec mode." t)
(setq auto-mode-alist (append '(("\\.spec" . rpm-spec-mode))
			      auto-mode-alist))

;; use auto-completion with clang support
(require 'auto-complete-config)
(ac-config-default)

(require 'auto-complete-clang-async)
(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
)

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)

;; compilation mode settings
(setq compile-command "make -j4 -k")
(setq compilation-scroll-output t)
(setq compilation-always-kill t)
(setenv "GCC_COLORS" "")

(require 'helm-git-grep) ;; Not necessary if installed by package.el
(global-set-key (kbd "C-c g") 'helm-git-grep)
;; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

(require 'fill-column-indicator)

(require 'tramp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["color-237" "#d75f5f" "#afaf00" "#ffaf00" "#87afaf" "#d787af" "#87af87" "color-223"])
 '(ansi-term-color-vector [unspecified "#202020" "#ac4142" "#90a959" "#f4bf75" "#6a9fb5" "#aa759f" "#6a9fb5" "#e0e0e0"] t)
 '(custom-safe-themes (quote ("42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a99e7c91236b2aba4cd374080c73f390c55173c5a1b4ac662eeb3172b60a9814" "134f38000f413a88743764983c751ac34edbec75a602065e2ae3b87fcf26c451" "ad9fc392386f4859d28fe4ef3803585b51557838dbc072762117adad37e83585" "96efbabfb6516f7375cdf85e7781fe7b7249b6e8114676d65337a1ffe78b78d9" "de2c46ed1752b0d0423cde9b6401062b67a6a1300c068d5d7f67725adc6c3afb" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "bd115791a5ac6058164193164fd1245ac9dc97207783eae036f0bfc9ad9670e0" "978ff9496928cc94639cb1084004bf64235c5c7fb0cfbcc38a3871eb95fa88f6" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" "1e194b1010c026b1401146e24a85e4b7c545276845fc38b8c4b371c8338172ad" "454dc6f3a1e9e062f34c0f988bcef5d898146edc5df4aa666bf5c30bed2ada2e" "53e29ea3d0251198924328fd943d6ead860e9f47af8d22f0b764d11168455a8e" "e53cc4144192bb4e4ed10a3fa3e7442cae4c3d231df8822f6c02f1220a0d259a" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "dc758223066a28f3c6ef6c42c9136bf4c913ec6d3b710794252dc072a3b92b14" "bf648fd77561aae6722f3d53965a9eb29b08658ed045207fe32ffed90433eb52" "f41fd682a3cd1e16796068a2ca96e82cfd274e58b978156da0acce4d56f2b0d5" "41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" "f7a22b2ae325554a467d01202e0b3fc25b76c37b04db8fcef9ce65e361144b3e" "90b5269aefee2c5f4029a6a039fb53803725af6f5c96036dee5dc029ff4dff60" "90af7d0da6b97c28098177271c1d9198234435a2d1874880ba36e5bdae9da113" "c7359bd375132044fe993562dfa736ae79efc620f68bab36bd686430c980df1c" "ce79400f46bd76bebeba655465f9eadf60c477bd671cbcd091fe871d58002a88" "a774c5551bc56d7a9c362dca4d73a374582caedb110c201a09b410c0ebbb5e70" "0ebe0307942b6e159ab794f90a074935a18c3c688b526a2035d14db1214cf69c" "53c542b560d232436e14619d058f81434d6bbcdc42e00a4db53d2667d841702e" "9bcb8ee9ea34ec21272bb6a2044016902ad18646bd09fdd65abae1264d258d89" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" "33c5a452a4095f7e4f6746b66f322ef6da0e770b76c0ed98a438e76c497040bb" "9bac44c2b4dfbb723906b8c491ec06801feb57aa60448d047dbfdbd1a8650897" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))

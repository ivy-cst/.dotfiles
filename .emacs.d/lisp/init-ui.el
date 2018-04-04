;;; Init-ui.el --- UI related settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; be quiet at startup; don't load or display anything unnecessary
(advice-add #'display-startup-echo-area-message :override #'ignore)
  (setq inhibit-startup-message t
        inhibit-startup-echo-area-message user-login-name
        inhibit-default-init t
        initial-major-mode 'fundamental-mode
        initial-scratch-message nil
        mode-line-format nil)

(setq-default
 ;; don't use visual bells or dialog boxes.
 use-dialog-box nil
 ring-bell-function #'ignore
 visible-bell nil

 ;; update ui less often.
 idle-update-delay 2

 ;; don't show advice warnings.
 ad-redefinition-action 'accept

 ;; make 'apropos' useful.
 apropos-do-all t

 ;; confirm before visiting non-existing file/buffer.
 confirm-nonexistent-file-or-buffer t

 ;; don't allow minibuffer commands while in minbuffer.
 enable-recursive-minibuffers nil

 ;; disable bidirectional text for tiny performance boost
 bidi-display-reordering nil

 ;; do not mess with frame size when altering fonts or settings.
 frame-inhibit-implied-resize t

 ;; remove continuation arrow on right fringe
 fringe-indicator-alist (delq
                         (assq 'continuation fringe-indicator-alist)
                         fringe-indicator-alist)

 ;; hide cursors in other windows
 cursor-in-non-selected-windows nil

 ;; let minibuffer windows resize automatically.
 resize-mini-windows 'grow-only

 ;; maximum size for mini-windows.
 max-mini-window-height 0.4

 highlight-nonselected-windows nil

 ;; keep the point out of the minibuffer
 minibuffer-prompt-properties '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)

 ;; don't show buffer boundaries visually.
 indicate-buffer-boundaries nil

 ;; don't show empty lines.
 indicate-empty-lines nil

 ;; lean towards horizontal splits.
 split-width-threshold 160

 ;; no need to make cursor overly visible.
 visible-cursor nil

 ;; don't stretch block cursor.
 x-stretch-cursor nil

 ;; don't ask for save confirmation before compilation, just do it.
 compilation-ask-about-save nil

 ;; scroll compilation output.
 compilation-scroll-output t

;; kill existing compilation before starting new, don't ask.
 compilation-always-kills t)

;; set inter-window bordto be minimal,
(setq-default window-divider-default-places t
              window-divider-default-bottom-width 0
              window-divider-default-right-width 1)
(add-hook 'after-init-hook #'window-divider-mode)

;; Don't show the ugly stuff.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tooltip-mode) (tooltip-mode -1))
(unless (display-graphic-p) (menu-bar-mode -1))

;; standardize default fringe width
(if (fboundp 'fringe-mode) (fringe-mode 4))

;; Make mouse less jumpy
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Enable y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; Winner mode for quick window configurations.
(when (fboundp 'winner-mode) (winner-mode 1))

;; Allow switching between active windows using Shift + arrow keys.
(when (fboundp 'windmove-default-keybindings) (windmove-default-keybindings))

;; Set default font
;; (set-face-attribute 'default nil
;;                     :family "Input Mono Narrow"
;;                     :height 140
;;                     :weight 'extra-light
;;                     :width 'normal)
;; (set-face-attribute 'default nil
;;                     :family "Iosevka"
;;                     :height 130
;;                     :weight 'light
;;                     :width 'normal)
;; (set-face-attribute 'default nil
;;                     :family "PragmataPro"
;;                     :height 130
;;                     :weight 'normal
;;                     :width 'normal)

(defvar api-emacs-font-size 14)
(defvar api-emacs-font (font-spec :family "PragmataPro" :size api-emacs-font-size))
(defvar api-emacs-variable-pitch-font (font-spec :family "PragmataPro"))
(defvar api-emacs-fixed-pitch-font (font-spec :family "PragmataPro"))
(defvar api-emacs-unicode-font (font-spec :family "PragmataPro"))
(defvar api-emacs-fallback-font (font-spec :family "PragmataPro"))

(set-frame-font api-emacs-font nil t)
(set-fontset-font t 'unicode api-emacs-unicode-font)
(set-face-attribute 'fixed-pitch nil
                    :family api-emacs-fixed-pitch-font
                    :height (* (+ api-emacs-font-size 2) 10))

(set-fontset-font "fontset-default"
                  '(#x2776 . #x2793) api-emacs-fallback-font nil 'prepend)
(set-fontset-font "fontset-default"
                  '(#x24b6 . #x24fe) api-emacs-fallback-font nil 'prepend)
(set-fontset-font "fontset-default"
                  '(#x2295 . #x22a1) api-emacs-fallback-font nil 'prepend)
(set-fontset-font "fontset-default"
                  '(#x2190 . #x2200) api-emacs-fallback-font nil 'prepend)

(use-package winum
  :config
  (setq window-numbering-scope 'global
        winum-auto-setup-mode-line nil)
  (add-hook 'emacs-startup-hook 'winum-mode))

;; Visually select windows.
(use-package ace-window
  :defer t
  :diminish ace-window-display-mode
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame
        aw-background t))

;; Rainbow delimiters to manage delimiter explosion.
(use-package rainbow-delimiters
  :defer t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; All the icons.
(use-package all-the-icons
  :commands (all-the-icons-octicon all-the-icons-faicon all-the-icons-fileicon
             all-the-icons-wicon all-the-icons-material all-the-icons-alltheicon
             all-the-icons-install-fonts all-the-icons-icon-for-buffer))

;; Interactively show available commands
(use-package which-key
  :diminish which-key-mode
  :config
  (setq which-key-sort-order #'which-key-prefix-then-key-order
        which-key-min-display-lines 5
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil)
  (set-face-attribute 'which-key-local-map-description-face nil :weight 'bold)
  (which-key-setup-side-window-bottom)
  (add-hook 'emacs-startup-hook #'which-key-mode))

;; Theme
(defadvice load-theme
    (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes))

(setq custom-safe-themes t)

(use-package seoul256-theme
  ;;:disabled
  :ensure nil
  :load-path "~/Code/seoul256-emacs"
  :config
  (setq seoul256-background 236
        seoul256-alternate-background 253)
  (load-theme 'seoul256 t)
  (with-eval-after-load "seoul256-theme"
    (custom-theme-set-faces
     'seoul256
     '(font-lock-comment-delimiter-face ((t (:foreground "gray45"))))
     '(font-lock-comment-face ((t (:foreground "gray45"))))
     '(font-lock-doc-face ((t (:foreground "gray70")))))))

;; bbatsov's solarized port
(use-package solarized-theme
  :disabled
  :config
  ;; make the fringe stand out from the background
  (setq solarized-distinct-fringe-background t)

  ;; Don't change the font for some headings and titles
  (setq solarized-use-variable-pitch nil)

  ;; make the modeline high contrast
  ;;(setq solarized-high-contrast-mode-line t)

  ;; Use less bolding
  ;;(setq solarized-use-less-bold t)

  ;; Use more italics
  (setq solarized-use-more-italic t)

  ;; Use less colors for indicators such as git:gutter, flycheck and similar
  ;;(setq solarized-emphasize-indicators nil)

  ;; Don't change size of org-mode headlines (but keep other size-changes)
  (setq solarized-scale-org-headlines nil)

  (setq x-underline-at-descent-line t)

  ;; Avoid all font-size changes
  ;;(setq solarized-height-minus-1 1.0)
  ;;(setq solarized-height-plus-1 1.0)
  ;;(setq solarized-height-plus-2 1.0)
  ;;(setq solarized-height-plus-3 1.0)
  ;;(setq solarized-height-plus-4 1.0)

  (load-theme 'solarized-dark t))

(use-package doom-themes
  :disabled
  :init (load-theme 'doom-one t)
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme
  (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package zenburn-theme
  :disabled
  :config
   (load-theme 'zenburn t)

   (with-eval-after-load "zenburn-theme"
     (custom-theme-set-faces
      'zenburn

      '(region ((t (:background "#007475"))))
      '(font-lock-comment-delimiter-face ((t (:foreground "gray55"))))
      '(font-lock-comment-face ((t (:foreground "gray55"))))
      '(font-lock-doc-face ((t (:foreground "gray70"))))
      '(shm-current-face ((t (:background "gray27"))))
      '(linum ((t (:foreground "gray37"))))
      '(fringe ((t (:background "#3f3f3f"))))

      ;; column-enforce-mode
      '(column-enforce-face ((t (:foreground "#DC8CC3"))))

      ;; eyebrowse
      `(eyebrowse-mode-line-active ((t (:foreground "#F0DFAF"))))
      `(eyebrowse-mode-line-inactive ((t (:foreground "gray37"))))

      ;; ace-window
      `(aw-leading-char-face ((t (:foreground "#F0DFAF"
                                              :weight bold
                                              :height 1.0))))

      `(winum-face ((t (:foreground "#F0DFAF" :height 1.3))))

      ;; solaire-mode
      `(solaire-default-face  ((t (:background "#383838"))))
      `(solaire-hl-line-face ((t (:background "#2B2B2B"))))

      ;; strike through unmatched parenthesis
      '(rainbow-delimiters-unmatched-face ((t (:foreground "red"
                                               :inherit unspecified
                                               :strike-through t)))))))

;; Mode line.
(require 'init-modeline)

(use-package smart-mode-line
  :disabled
  :init
  ;;(setq sml/no-confirm-load-theme t
   ;;     sml/theme 'nil)
  (add-hook 'after-init-hook #'sml/setup))

(use-package powerline
  :disabled
  :config
  (setq powerline-default-separator 'wave
        ;;powerline-height (truncate (* 1.0 (frame-char-height))))
        powerline-height 29)
  (powerline-default-theme))

;; Telephone line.
(use-package telephone-line
  :disabled
  :after evil
  ;:ensure nil
  ;:load-path "/Users/api/Code/telephone-line"
  :init

  ;;(setq telephone-line-height (truncate (* 2.1 (frame-char-height))))
  (setq telephone-line-height 29)

  ;; Bunch of mode line segments. Most of them taken from:
  ;; https://github.com/domtronn/all-the-icons.el/wiki/Spaceline

  (telephone-line-defsegment api--workspace-segment ()
  (when (and
             (bound-and-true-p persp-mode)
             ;; There are multiple implementations of
             ;; persp-mode with different APIs
             (fboundp 'safe-persp-name)
             (fboundp 'get-frame-persp))
    (let ((name (safe-persp-name (get-frame-persp))))
      (concat " "
              (all-the-icons-octicon "versions" :v-adjust -0.05)
              " "
      (propertize
       (if (file-directory-p name)
           (file-name-nondirectory (directory-file-name name))
         name)
       'face 'bold)))))

  (defun api--github-vc ()
    (let ((branch (mapconcat 'concat (cdr (split-string vc-mode "[:-]")) "-")))
      (concat
       (propertize (all-the-icons-alltheicon "git")
                   'face '(:height 1.1 :inherit)
                   'display '(raise 0.1))
       ;; (propertize " · ")
       ;;  (propertize (format "%s" (all-the-icons-octicon "git-merge"))
       ;;              'face `(:family ,(all-the-icons-octicon-family)
       ;;                              :height 1.1 :inherit)
       ;;                              'display '(raise 0.1))
       (propertize (format " %s" branch)
                   'face `(:inherit)
                   'display '(raise 0.0)))))

  ;; Shows version control and branch.
  (telephone-line-defsegment api--vc-segment ()
    (when vc-mode
      (cond ((string-match "Git[:-]" vc-mode) (api--github-vc))
            (t (propertize (format "%s" vc-mode))))))

  ;; Shows all-the-icon icon for the current major mode.
  (telephone-line-defsegment api--mode-icon-segment ()
    (let ((icon (all-the-icons-icon-for-buffer)))
      (unless (symbolp icon) ;; This implies it's the major mode
        (propertize (format "%s" icon)
                    'help-echo (format "Major-mode: `%s`" major-mode)
                    'display '(raise -0.15)
                    'face `(:height 1.2
                            :family ,(all-the-icons-icon-family-for-buffer)
                            )))))

  ;; Shows the current buffer id. If projectile-mode is active, shows the
  ;; relative path to the file from the project root.
  (telephone-line-defsegment api--buffer-id-segment ()
    (if (fboundp 'projectile-project-root)
        (let* ((buf (or (buffer-file-name) (buffer-name)))
               (proj (ignore-errors (projectile-project-root)) )
               (name (if (buffer-file-name)
                         (or (cadr (split-string buf proj))
                             (format-mode-line "%b"))
                       (format-mode-line "%b"))))
          (propertize (format "%s" name)
                      'face `(:inherit)
                      'display '(raise 0.0)
                      'help-echo (format "Major-mode: `%s`" major-mode)))
      (propertize (format-mode-line "%b ")
                  'face '(:inherit)
                  'display '(raise 0.0))))

  ;; Shows status of the current buffer using all-the-icons.
  (telephone-line-defsegment api--buffer-modified-segment ()
    (let* ((config-alist
            '(("*" all-the-icons-faicon-family all-the-icons-faicon
               "chain-broken" :height 1.2 :v-adjust -0.0)
              ("-" all-the-icons-faicon-family all-the-icons-faicon
               "link" :height 1.2 :v-adjust -0.0)
              ("%" all-the-icons-octicon-family all-the-icons-octicon
               "lock" :height 1.2 :v-adjust 0.1)))
           (result (cdr (assoc (format-mode-line "%*") config-alist))))

      (propertize (format "%s" (apply (cadr result) (cddr result)))
                  'face `(:family ,(funcall (car result)) :inherit ))))

  ;; Shows the buffer size.
  (telephone-line-defsegment api--buffersize-segment ()
    (propertize (format-mode-line " %I ")
                'face `(:height 1.0 :inherit)
                'display '(raise 0.0)))

  ;; Shows a bunch of buffer related things.
  (telephone-line-defsegment api--buffer-segment ()
    `(""
      mode-line-mule-info
      mode-line-client
      mode-line-remote
      mode-line-frame-identification
      ,(telephone-line-raw (format-mode-line " %I "))
      ,(telephone-line-raw mode-line-buffer-identification t)))

  ;; Shows the current pointer position in the buffer.
  (telephone-line-defsegment api--position-segment ()
    (if (telephone-line-selected-window-active)
        (if (eq major-mode 'paradox-menu-mode)
            (telephone-line-trim (format-mode-line mode-line-front-space))
          '("%3l:%2c %p"))))

  (telephone-line-defsegment* api--spacer-segment ()
    " ")

  ;; (setq telephone-line-lhs
  ;;       '((evil   . (telephone-line-window-number-segment
  ;;                    api--spacer-segment
  ;;                    api--persp-name-segment))
  ;;         (accent . (api--vc-segment
  ;;                    telephone-line-process-segment))
  ;;         (nil    . (telephone-line-projectile-segment
  ;;                    api--spacer-segment
  ;;                    api--buffer-segment
  ;;                    api--spacer-segment
  ;;                    api--buffer-modified-segment))))

  (setq telephone-line-lhs
        '((evil   . (telephone-line-window-number-segment))
          (accent . (api--workspace-segment))
          (nil    . (
                     api--spacer-segment
                     api--vc-segment
                     telephone-line-process-segment
                     telephone-line-projectile-segment
                     api--spacer-segment
                     api--buffer-segment
                     api--spacer-segment
                     api--buffer-modified-segment))))

  (setq telephone-line-rhs
        '(;(nil    . (telephone-line-misc-info-segment))
          (nil . (api--mode-icon-segment
                     api--spacer-segment
                     telephone-line-major-mode-segment))
          (evil   . (api--spacer-segment
                     api--position-segment
                     api--spacer-segment))))

  (setq telephone-line-primary-left-separator 'telephone-line-nil
        telephone-line-secondary-left-separator 'telephone-line-nil
        telephone-line-primary-right-separator 'telephone-line-flat
        telephone-line-secondary-right-separator 'telephone-line-nil)

  (telephone-line-mode t))

(use-package shackle
  :defer t
  :init
  (setq shackle-default-alignment 'below
        shackle-default-size 8
        helm-display-function 'pop-to-buffer
        shackle-rules
        '(("^\\*eww" :regexp t :size 0.5 :select t :autokill t :noesc t)
          ("^\\*ftp " :noselect t :autokill t :noesc t)
          ("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.3)
          ;; built-in (emacs)
          ("*compilation*" :size 0.25 :noselect t :autokill t :autoclose t)
          ("*ert*" :same t :modeline t)
          ("*info*" :size 0.5 :select t :autokill t)
          ("*undo-tree*" :size 0.25 :align right)
          ("*Backtrace*" :size 20 :noselect t)
          ("*Warnings*"  :size 12 :noselect t :autofit t)
          ("*Messages*"  :size 12 :noselect t)
          ("*Help*" :size 0.3 :autokill t)
          ("^\\*.*Shell Command.*\\*$" :regexp t :size 20 :noselect t :autokill t)
          (apropos-mode :size 0.3 :autokill t :autoclose t)
          (Buffer-menu-mode :size 20 :autokill t)
          (comint-mode :noesc t)
          (grep-mode :size 25 :noselect t :autokill t)
          (profiler-report-mode :size 0.3 :regexp t :autokill t :modeline minimal)
          (tabulated-list-mode :noesc t)
          ("^ ?\\*" :regexp t :size 15 :noselect t :autokill t :autoclose t)))
  (shackle-mode))

(use-package zoom
  :disabled ;; doesn't play well with which-key
  :config
  ;(setq which-key-popup-type 'minibuffer)
  (setq zoom-ignored-major-modes '(calc-mode
                                   dired-mode
                                   ediff-mode
                                   markdown-mode
                                   speedbar-mode
                                   which-key-mode)
        zoom-ignored-buffer-name-regexps '("^*calc"
                                           "^\\*[hH]elm.*")
        zoom-ignored-buffer-names '(" *NeoTree*"
                                    " *which-key*")))

(use-package golden-ratio
  :config
  (progn
    ;; golden-ratio-exclude-modes
    (dolist (m '("bs-mode"
                 "calc-mode"
                 "ediff-mode"
                 "dired-mode"
                 "gud-mode"
                 "gdb-locals-mode"
                 "gdb-registers-mode"
                 "gdb-breakpoints-mode"
                 "gdb-threads-mode"
                 "gdb-frames-mode"
                 "gdb-inferior-io-mode"
                 "gdb-disassembly-mode"
                 "gdb-memory-mode"
                 "speedbar-mode"
                 ))
      (add-to-list 'golden-ratio-exclude-modes m))

    (add-to-list 'golden-ratio-exclude-buffer-regexp "^\\*[hH]elm.*")

    ;; golden-ratio-extra-commands
    (dolist (f '(ace-window
                 ace-delete-window
                 ace-select-window
                 ace-swap-window
                 ace-maximize-window
                 avy-pop-mark
                 buf-move-left
                 buf-move-right
                 buf-move-up
                 buf-move-down
                 evil-avy-goto-word-or-subword-1
                 evil-avy-goto-line
                 evil-window-delete
                 evil-window-split
                 evil-window-vsplit
                 evil-window-left
                 evil-window-right
                 evil-window-up
                 evil-window-down
                 evil-window-bottom-right
                 evil-window-top-left
                 evil-window-mru
                 evil-window-next
                 evil-window-prev
                 evil-window-new
                 evil-window-vnew
                 evil-window-rotate-upwards
                 evil-window-rotate-downwards
                 evil-window-move-very-top
                 evil-window-move-far-left
                 evil-window-move-far-right
                 evil-window-move-very-bottom
                 quit-window
                 winum-select-window-0-or-10
                 winum-select-window-1
                 winum-select-window-2
                 winum-select-window-3
                 winum-select-window-4
                 winum-select-window-5
                 winum-select-window-6
                 winum-select-window-7
                 winum-select-window-8
                 winum-select-window-9
                 windmove-left
                 windmove-right
                 windmove-up
                 windmove-down))
      (add-to-list 'golden-ratio-extra-commands f))

    ;; golden-ratio-exclude-buffer-names
    (dolist (n '(" *NeoTree*"
                 "*LV*"
                 " *which-key*"))
      (add-to-list 'golden-ratio-exclude-buffer-names n))))

(use-package fringe-helper
  :commands (fringe-helper-define fringe-helper-convert)
  :init
  (unless (fboundp 'define-fringe-bitmap)
    ;; doesn't exist in terminal Emacs; define it to prevent errors
    (defun define-fringe-bitmap (&rest _))))

(use-package solaire-mode
  :disabled
  :init
  ;; brighten buffers (that represent real files)
  (add-hook 'after-change-major-mode-hook #'turn-on-solaire-mode)
  ;; To enable solaire-mode unconditionally for certain modes:
  (add-hook 'ediff-prepare-buffer-hook #'solaire-mode)

  ;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
  ;; itself off every time Emacs reverts the file
  (add-hook 'after-revert-hook #'turn-on-solaire-mode)

  ;; highlight the minibuffer when it is activated:
  (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)

  ;; if the bright and dark background colors are the wrong way around, use this
  ;; to switch the backgrounds of the `default` and `solaire-default-face` faces.
  ;; This should be used *after* you load the active theme!
  ;;
  ;; NOTE: This is necessary for themes in the doom-themes package!
  (solaire-mode-swap-bg))

(provide 'init-ui)

;;; init-ui.el ends here

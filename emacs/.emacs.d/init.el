;; To run init file using custom path (example)
;; emacs -q -l /Users/adamsjoholm/Documents/projects/emacs/init.el

;; Clean up the user interface for a minimal presentation ---------------------------

(setq inhibit-startup-message t)

(setq visible-bell t)  ; Set up the visible bell 

(scroll-bar-mode -1)   ; Disable visible scrollbar
(tool-bar-mode -1)     ; Disable the toolbar
(tooltip-mode -1)      ; Disable tooltips
(set-fringe-mode 10)   ; Give some breathing room
(menu-bar-mode -1)     ; Disable the menu bar

(column-number-mode)   ; Turn on column numbering

; (setq default-directory "/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook")

;; Arch-specific configurations -----------------------------------------------------
(when (eq system-type 'gnu/linux)
  (set-face-attribute 'default nil
		      :font "FiraCode Nerd Font Mono")
  )

;; Unbind specific keys -------------------------------------------------------------
(global-unset-key (kbd "M-SPC")) ; Key binding originally does "cycle-spacing"

;; Make ESC quit prompts ------------------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources -------------------------------------------------------
(require 'package)     ; Bring in package management functions

(setq package-archives '(("mepla" . "https://melpa.org/packages/")     ; Archives used to fetch packages
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)   ; Initialize the package system
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms ------------------------------------
(unless (package-installed-p 'use-package) ; Unless already installed...
  (package-install 'use-package))          ; ...install use-package

(require 'use-package) ; load use-packages 
(setq use-package-always-ensure t)
	 
;; Doom themes ----------------------------------------------------------------------
(use-package doom-themes
  :config
  (load-theme 'doom-lantern t)

  ;; Enable flashing mode-line on errorsa
  (doom-themes-visual-bell-config))

;; NOTE the first time you load your config on a new machine, you'll need to run
;; the following command interactively so that mode line icons display correctly:
;;
;; M-x all-the-icons-install-fonts
;; M-x nerd-icon-install-fonts

(use-package all-the-icons)

;; Magit ----------------------------------------------------------------------------
(use-package magit
  :ensure t)

;; Load fonts when using emacs client -----------------------------------------------
(defun strider/setup-frame (frame)
  (with-selected-frame frame
    (when (display-graphic-p frame)
      (set-face-attribute 'default frame
                          :font "FiraCode Nerd Font Mono"
                          :height 110))))

(add-hook 'after-make-frame-functions #'strider/setup-frame)

;; Also handle the case where Emacs is launched directly (not as daemon)
(when (display-graphic-p)
  (strider/setup-frame (selected-frame)))

;; Ivy ------------------------------------------------------------------------------
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Ivy rich -------------------------------------------------------------------------
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Counsel --------------------------------------------------------------------------
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ; Don't start searches with ^

;; Doom modeline --------------------------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Which key ------------------------------------------------------------------------
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 2))
  
;; Helpful --------------------------------------------------------------------------
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Evil mode ------------------------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Evil-collection ------------------------------------------------------------------
;(use-package evil-collection
;  :after evil
;  :config
;  (evil-collection-init))

;; CONSIDER using hydra to make a command to cycle buffers --------------------------

;; Citar ----------------------------------------------------------------------------
(use-package citar
  :ensure t)
;  :custom
;  (citar-bibliography '("/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/research_notebook/literature/refs_main.bib")))

;; Biblio ---------------------------------------------------------------------------
(use-package biblio)

;; Mermaid --------------------------------------------------------------------------
(use-package ob-mermaid
  :ensure t)

;; General --------------------------------------------------------------------------
;; Create functions to be used with general
(defun strider/open-agenda-file ()
  (interactive)
  (find-file "/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/notes/agenda.org"))

(defun strider/open-medicine-file ()
  (interactive)
  (find-file "/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/medical_school_notebook/medicine.org"))

(defun strider/open-research-file ()
  (interactive)
  (find-file "/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/research_notebook/research_notes.org"))

(defun strider/open-init-file ()
  (interactive)
  (find-file "/Users/adamsjoholm/Documents/projects/emacs/init.el"))

(use-package general
  :config
  (general-create-definer strider/leader-keys
    :keymaps 'override
    :prefix "M-SPC")

  (strider/leader-keys
    ;; Basic commands
    "b" '(counsel-switch-buffer :which-key "select buffer")
    "a" '(strider/open-agenda-file :which-key "open agenda file")
    "m" '(strider/open-medicine-file :which-key "open medicine notebook")
    "r" '(strider/open-research-file :which-key "open research notebook")
    "i" '(strider/open-init-file :which-key "open init file")
    "p" '(org-agenda :which-key "agenda")

    ;; Reference management
    "c" '(:ignore r :which-key "references")
    "cd" '(biblio-doi-insert-bibtex :which-key "insert doi")
    "ci" '(citar-insert-citation :which-key "insert citation")))

;; Org mode -------------------------------------------------------------------------
(defun strider/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . strider/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers nil))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Turn "-" into "•"
(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(defun strider/org-mode-visual-fill ()
  (setq visual-fill-column-width 130
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . strider/org-mode-visual-fill))

(setq org-agenda-files
      '("/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/notes/agenda.org"
	"/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/research_notebook/projects/tgfb_inhibition/ic_tgfbtrap_hidose_sting_ic/notebook/notes.org"
	"/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/research_notebook/projects/ep4_antagonism/pilot_vorb/notebook/notes.org"
	"/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/research_notebook/projects/nrp2/14v11_28v4_mono_survival/notebook/notes.org"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NOTE(n)" "ONGOING(g)" "|" "DONE(d)" "CANCELED(c)")
	(sequence "HABIT(h)" "|" "DONE(d)" "SKIP(s)")
	(sequence "DUE(d)" "|" "SUBMITTED(u)")
	(sequence "EXAM(x)" "QUIZ(q)" "|" "DONE(d)")
	(sequence "EVENT(e)" "HOLD(H)" "LECTURE(l)" "LAB(b)" "OFFICE(o)" "TRAVEL(T)" "|" "PAST(p)" "CANCELED(c)")
	(sequence "EXPIRE(r)" "|" "UPDATED(a)")
        (sequence "MSG(m)" "|" "SENT(s)")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#e01d1d"))   ;; Red Dark
	("DUE" . (:foreground "#fabc2c"))))  ;; Yellow Dark

(setq org-agenda-span 'fortnight)

;; Ox-Pandoc ------------------------------------------------------------------------
(use-package ox-pandoc)

;; Calfw ----------------------------------------------------------------------------
(use-package calfw)
(use-package calfw-org)

(setq cfw:org-agenda-schedule-args '(:timestamp :lecture :exam :event))

(defun org-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-file-source "agenda" "/Users/adamsjoholm/Library/Mobile Documents/com~apple~CloudDocs/files/active/notebook/agenda.org" "Orange"))))

;; Babel ----------------------------------------------------------------------------
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (sqlite . t)
   (python . t)
   (mermaid . t)))

(setq org-edit-src-content-indentation 0) ; stop automatically indenting source code blocks

;; xdg-launcher ---------------------------------------------------------------------
;(use-package xdg-launcher
;  :vc (:url "https://github.com/emacs-exwm/xdg-launcher")

;; Special character commands  ------------------------------------------------------
(global-set-key (kbd "s-b") (lambda () (interactive) (insert "β"))) ;; beta
(global-set-key (kbd "s-u") (lambda () (interactive) (insert "µ"))) ;; micro sign
(global-set-key (kbd "s-m") (lambda () (interactive) (insert "γ"))) ;; gamma sign

;; Box building commands  -----------------------------------------------------------

(global-set-key (kbd "s--") (lambda () (interactive) (insert "─"))) ;; Insert horizontal line
(global-set-key (kbd "s-\\") (lambda () (interactive) (insert "│"))) ;; Insert vertical line
(global-set-key (kbd "s-[") (lambda () (interactive) (insert "┌"))) ;; Top-left corner
(global-set-key (kbd "s-]") (lambda () (interactive) (insert "┐"))) ;; Top-right corner
(global-set-key (kbd "s-;") (lambda () (interactive) (insert "└"))) ;; Bottom-left corner
(global-set-key (kbd "s-'") (lambda () (interactive) (insert "┘"))) ;; Bottom-right corner
(global-set-key (kbd "s-/") (lambda () (interactive) (insert "├"))) ;; Right connector
(global-set-key (kbd "s-.") (lambda () (interactive) (insert "┼"))) ;; Intersection
(global-set-key (kbd "s-,") (lambda () (interactive) (insert "┤"))) ;; Left connector
(global-set-key (kbd "s-9") (lambda () (interactive) (insert "┬"))) ;; Bottoom connector
(global-set-key (kbd "s-0") (lambda () (interactive) (insert "┴"))) ;; Top connector
(global-set-key (kbd "s-1") (lambda () (interactive) (insert "←"))) ;; Left arrow
(global-set-key (kbd "s-2") (lambda () (interactive) (insert "→"))) ;; Right arrow
(global-set-key (kbd "s-3") (lambda () (interactive) (insert "↑"))) ;; Up arrow
(global-set-key (kbd "s-4") (lambda () (interactive) (insert "↓"))) ;; Down arrow
(global-set-key (kbd "s-5") (lambda () (interactive) (insert "✓"))) ;; Down arrow
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

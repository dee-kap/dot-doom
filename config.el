;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
;;
;;
(setq fancy-splash-image "~/housekeeping/stan.png")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 15))
(setq-default line-spacing 15)
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq diary-file "~/org/diary.org")




;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; use ruff as the linter
;; (after! flycheck
;;   (require 'flycheck)
;;   (flycheck-define-checker python-ruff
;;     "A Python syntax and style checker using Ruff."
;;     :command ("ruff" source-inplace)
;;     :error-patterns
;;     ((error line-start (file-name) ":" line ":" column ": " (id (one-or-more (not (any ":")))) ": " (message) line-end))
;;     :modes python-mode)
;;   (add-to-list 'flycheck-checkers 'python-ruff)
;;   (setq flycheck-python-ruff-executable "ruff"))

(after! flycheck
  (flycheck-define-checker python-ruff
    "A Python syntax and style checker using Ruff."
    :command ("ruff" "check" source-inplace)
    :error-patterns
    ((error line-start (file-name) ":" line ":" (optional column ":") " " (message) line-end))
    :modes python-mode)
  (add-to-list 'flycheck-checkers 'python-ruff))


(add-hook 'python-mode-hook (lambda () (flycheck-select-checker 'python-ruff)))

;; Python formatting
(use-package! format-all
  :commands (format-all-buffer format-all-mode)
  :init
  (add-hook 'python-mode-hook #'format-all-mode)  ; Enable format-all-mode for Python files
  :config
  (set-formatter! 'black "black -" :modes '(python-mode)))  ; Set Black as the formatter for Python

(defun my-setup-python-formatting ()
  (setq-local format-all-formatters '(("Python" black)))
  (add-hook 'before-save-hook 'format-all-buffer nil 'local))

(add-hook 'python-mode-hook 'my-setup-python-formatting)


(setq doom-modeline-icon (display-graphic-p))
(setq font-lock-maximum-decoration t)

(after! treemacs
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t))

;; mappings
(defun my/run-current-script ()
  "Run the current script without prompting."
  (interactive) ; This makes the function callable via key-bindings
  (executable-interpret (buffer-file-name)))
(map! :leader
      :desc "Run Script" "c b" #'my/run-current-script)

;; display workspace number on modeline
(setq doom-modeline-persp-name t)
(setq doom-modeline-display-default-persp-name t)
(setq doom-modeline-project-detection 'auto)
;; Whether display the modification icon for the buffer.
;; It respects option `doom-modeline-icon' and option `doom-modeline-buffer-state-icon'.
(setq doom-modeline-buffer-modification-icon t)

;; Whether display the lsp icon. It respects option `doom-modeline-icon'.
(setq doom-modeline-lsp-icon t)
(setq doom-modeline-lsp t)
;; Whether display the modern icons for modals.
(setq doom-modeline-modal-modern-icon t)

;; sass mode
(use-package! sass-mode
  :mode ("\\.sass\\'" "\\.scss\\'")
  :config
  ;; add custom configuration for sass-mode here
  )

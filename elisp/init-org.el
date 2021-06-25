;;; init-org.el --- -*- lexical-binding: t -*-
;;
;; Filename: init-org.el
;; Description: Initialize Org, Toc-org, HTMLize, OX-GFM
;; Author: Mingde (Matthew) Zeng
;; Copyright (C) 2019 Mingde (Matthew) Zeng
;; Created: Fri Mar 15 11:09:30 2019 (-0400)
;; Version: 3.0
;; URL: https://github.com/MatthewZMD/.emacs.d
;; Keywords: M-EMACS .emacs.d org toc-org htmlize ox-gfm
;; Compatibility: emacs-version >= 26.1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; This initializes org toc-org htmlize ox-gfm
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; OrgPac
(use-package org
  :ensure nil
  :defer t
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         (:map org-mode-map (("C-c C-p" . eaf-org-export-to-pdf-and-open)
                             ("C-c ;" . nil))))
  :custom
  (org-log-done 'time)
  (calendar-latitude 53.551086) ;; Prerequisite: set it to your location, currently default: Hamburg, Germany
  (calendar-longitude  9.993682) ;; Usable for M-x `sunrise-sunset' or in `org-agenda'
  (org-export-backends (quote (ascii html icalendar latex md odt)))
  (org-use-speed-commands t)
  (org-confirm-babel-evaluate 'nil)
  (org-latex-listings-options '(("breaklines" "true")))
  (org-latex-listings t)
  (org-deadline-warning-days 7)
  (org-todo-keywords
   '((sequence "TODO" "IN-PROGRESS" "REVIEW" "|" "DONE" "CANCELED")))
  (org-agenda-window-setup 'other-window)
  (org-latex-pdf-process
   '("pdflatex -shelnl-escape -interaction nonstopmode -output-directory %o %f"
     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  :custom-face
  (org-agenda-current-time ((t (:foreground "spring green"))))
  :config
  (add-to-list 'org-latex-packages-alist '("" "listings"))
  (unless (version< org-version "9.2")
    (require 'org-tempo))

  (defun org-export-toggle-syntax-highlight ()
    "Setup variables to turn on syntax highlighting when calling `org-latex-export-to-pdf'."
    (interactive)
    (setq-local org-latex-listings 'minted)
    (add-to-list 'org-latex-packages-alist '("newfloat" "minted")))

  (defun org-table-insert-vertical-hline ()
    "Insert a #+attr_latex to the current buffer, default the align to |c|c|c|, adjust if necessary."
    (interactive)
    (insert "#+attr_latex: :align |c|c|c|")))

(setq org-agenda-files '("~/MEGA/tasks.org"))
(setq org-image-actual-width '(600))
(setq org-startup-with-inline-images t)
(setq org-hide-emphasis-markers t)
(use-package org-download)

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)
(setq org-habit-show-all-today t)

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

;; -OrgPac

;;roam-Pac
(setq org-roam-dailies-directory "~/MEGA/org-roam/daily/")

(use-package org-roam
  :diminish
:hook
(after-init . org-roam-mode)
:custom
(org-roam-directory "~/MEGA/org-roam/")
:bind (:map org-roam-mode-map
(("C-c n l" . org-roam)
 ("C-c n f" . org-roam-find-file)
 ("C-c n g" . org-roam-graph))
:map org-mode-map
(("C-c n i" . org-roam-insert))
(("C-c n I" . org-roam-insert-immediate))))

(setq org-roam-dailies-capture-templates
  `(("d" "default" entry (function org-roam-capture--get-point)
     "* %?"
     :file-name ,(concat org-roam-dailies-directory "%<%Y-%m-%d>")
     :head "#+title: %<%Y-%m-%d>\n
[[file:../daily.org][Daily]]
* Diary")))

(setq org-roam-capture-templates
'(("d" "default" plain (function org-roam-capture--get-point)
"%?"
:file-name "${slug}"
:head "#+TITLE: ${title}
#+startup: latexpreview showall

#+ROAM_ALIAS:
#+CREATED: %u

- tags ::
\n* ${title}
* Siehe Auch
* Quellen
"
:unnarrowed t
:immediate-finish t)))
;; -RoamPac

;; UIPac
(use-package org-superstar
  :diminish
:init
(setq org-superstar-headline-bullets-list
'("" "" "" "" "" ""))
:config
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(custom-set-faces
'(org-level-1 ((t (:height 2.0 :foreground "#a71d31"))))
'(org-level-2 ((t (:height 1.5 :foreground "#8D6B94"))))
'(org-level-3 ((t (:height 1.25 ))))
'(org-level-4 ((t (:height 1.15 ))))
'(org-level-5 ((t (:height 1.05 ))))
)
;; -UIPac

;; TocOrgPac
(use-package toc-org
  :hook (org-mode . toc-org-mode))
;; -TocOrgPac

;; HTMLIZEPac
(use-package htmlize :defer t)
;; -HTMLIZEPac

;; OXGFMPac
(use-package ox-gfm :defer t)
;; -OXGFMPac

;; PlantUMLPac
(use-package plantuml-mode
  :defer t
  :custom
  (org-plantuml-jar-path (expand-file-name "~/tools/plantuml/plantuml.jar"))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(;; other Babel languages
     (dot      . t)
     (plantuml . t))))
;; -PlantUMLPac


(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
(provide 'init-org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-org.el ends here

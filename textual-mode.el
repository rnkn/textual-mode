;;; textual-mode.el --- major mode for working with textual files  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Paul W. Rankin

;; Author: Paul W. Rankin <hello@paulwrankin.com>
;; Keywords: wp, text

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(defgroup textual ()
  "Major mode for working with textual files."
  :prefix "textual-"
  :group 'text)


;;; Faces

(defgroup textual-faces ()
  "Faces for `textual-mode'."
  :group 'textual)

(defface textual-todo
  '((t (:inherit font-lock-constant-face)))
  "Face for todo comments."
  :group 'textual-faces)

(defface textual-marker
  '((t (:inherit font-lock-keyword-face)))
  "Face for markers."
  :group 'textual-faces)

(defface textual-research
  '((t (:inherit font-lock-doc-face)))
  "Face for research."
  :group 'textual-faces)

(defface textual-comment
  '((t (:inherit font-lock-comment-face)))
  "Face for comments."
  :group 'textual-faces)

(defface textual-blockquote
  '((t nil))
  "Face for blockquotes."
  :group 'textual-faces)


;;; Regular Expressions

(defvar textual-todo-regexp
  "^![ ]*\\(.*\\)")

(defvar textual-marker-regexp
  "^@[ ]*\\(.*\\)")

(defvar textual-research-regexp
  "^^[ ]*\\(.*\\)")

(defvar textual-blockquote-regexp
  "^\s\\{2,\\}\\(.*\\)")

(defvar textual-comment-regexp
  "^#\\(.*\\)")

(defvar textual-date-time-regexp
  (concat
   "\\(?1:[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\\)"
   "\\(?2: +[0-9][0-9]:[0-9][0-9]\\(:[0-9][0-9]\\)?\\)?"
   "\\(?3:.*\\)"))


;;; Font Lock

(defvar textual-font-lock-keywords
  (list
   (list textual-comment-regexp '(0 'textual-comment))
   (list textual-date-time-regexp '(0 'outline-1))
   (list textual-blockquote-regexp '(0 'textual-blockquote))
   (list textual-todo-regexp '(0 'textual-todo))
   (list textual-marker-regexp '(0 'textual-marker))
   (list textual-research-regexp '(0 'textual-research))))


;;; Commands

(defun textual-next-marker ()
  (interactive)
  (end-of-line)
  (when (re-search-forward textual-marker-regexp nil 'move)
    (goto-char (match-beginning 0))))

(defun textual-previous-marker ()
  (interactive)
  (beginning-of-line)
  (re-search-backward textual-marker-regexp nil 'move))


;;; Mode Definition

(defcustom textual-mode-hook
  nil
  "Mode hook for `textual-mode', run after the mode is turned on."
  :type 'hook
  :group 'textual)

(define-key textual-mode-map (kbd "M-n") #'textual-next-marker)
(define-key textual-mode-map (kbd "M-p") #'textual-previous-marker)

;;;###autoload
(define-derived-mode textual-mode outline-mode "Textual"
  "Major mode for working with textual files."
  :group 'textual
  (setq-local outline-regexp textual-date-time-regexp)
  (setq-local outline-level 'journal-outline-level-1)
  (setq font-lock-defaults '((textual-font-lock-keywords))))

(provide 'textual-mode)
;;; textual-mode.el ends here

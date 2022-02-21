;;; anejil.el --- Automatically switch Python venvs -*- lexical-binding: t -*-

;; Copyright (C) 2022 Nakamura, Ryotaro <nakamura.ryotaro.kzs@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "26.3") (pyvenv "1.21"))
;; URL: https://github.com/nryotaro/narumi
;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; anejil automatically activates a Python venv with pyvenv package.
;; When you open a file in python-mode, it searches for the venv
;; directory near the file, and activates it.  When you open a Python
;; file, anejil searches for a venv directory with a name in
;; `anejil-venv-dirnames`.  The search behavior is similar to that of
;; `locate-dominating-file`.  The directory name with a smaller index
;; has higher priority than that with a greater index.

;;; Code:
(require 'pyvenv)

(defgroup anejil-mode nil
  "Autmatic switcher of Python venv."
  :prefix "anejil-"
  :group 'anejil)

(defcustom anejil-venv-dirnames
  (list "venv" ".venv")
  "The patterns of venv directories that you want to activate."
  :type '(repeat string))

(defun anejil--locate-venv
    (base-directory venv-dirname)
  "Search for a venv directory.
Search for a venv that matches VENV-DIRNAME
from BASE-DIRECTORY.  The behavior is similar to
`locate-dominating-file'."
  (when-let ((parent-dir (locate-dominating-file
			  base-directory
			  (anejil--resolve-activate
			   venv-dirname))))
    (expand-file-name
         (concat (file-name-as-directory parent-dir)
	    venv-dirname))))

(defun anejil--locate-venvs
    (base-directory venv-dirnames)
  "Search for a venv directory from venv directories.
Search for VENV-DIRNAMES from BASE-DIRECTORY.
The behavior is similar to `locate-dominating-file'.
The priority is same as the order of VENV-DIRNMAES.
Return a path of the venv directory or nil."
  (seq-some #'identity
	    (mapcar (lambda (venv-dirname)
		      (anejil--locate-venv base-directory
					   venv-dirname))
		    venv-dirnames)))

(defun anejil--run ()
  "Search for a venv directory and activate it."
  (when-let* ((venv-dir (anejil--locate-venvs
			 default-directory
			 anejil-venv-dirnames))
	      (match (not (equal venv-dir pyvenv-virtual-env))))
    (pyvenv-activate venv-dir)
    (message (format "anejil activated %s."
		     venv-dir))))

(defun anejil--resolve-activate (directory)
  "Return the path of the activete file in DIRECTORY."
  (concat (file-name-as-directory
	   (concat (file-name-as-directory directory) "bin"))
	  "activate"))

;;;###autoload
(define-minor-mode anejil-mode
  "Turn on anejil-mode."
  :init-value nil
  :lighter " anejil"
  :global t
  (let ((hook 'python-mode-hook))
  (if anejil-mode
      (add-hook hook #'anejil--run)
    (remove-hook hook #'anejil--run))))

(provide 'anejil)
;;; anejil.el ends here

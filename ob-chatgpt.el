;;; ob-chatgpt.el --- Wrap your input for chatgpt with org-babel
;;
;; Authors: Minh Nguyen-Hue <minh.nh1989@gmail.com>
;; URL: https://github.com/suonlight/ob-chatgpt
;; Keywords: chatgpt, org-babel
;; Version: 0.1
;; Package-Requires: ((epc "0.1.1") (deferred "0.5.1") (chatgpt "0.1"))
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Code:
(require 'uuidgen)
(require 'deferred)
(require 'chatgpt)
(require 'python)

(add-to-list 'org-src-lang-modes '("chatgpt" . fundamental))

;;;###autoload
(defvar org-babel-default-header-args:chatgpt '((:wrap . "example"))
  "Default header arguments for forth code blocks.")

;;;###autoload
(defun org-babel-execute:chatgpt (body params)
  "Execute a block of ChatGPT code with org-babel.
  This function is called by `org-babel` when it needs to execute a code block in the ChatGPT language."
  (let* ((result-params (cdr (assq :result-params params)))
          (type (cdr (assq :type params)))
          (info (org-babel-get-src-block-info))
          (jid (uuidgen-4))
          (query body))
    (unless chatgpt-process
      (chatgpt-init))
    (deferred:$
      (deferred:$
        (epc:call-deferred chatgpt-process 'query (list query))
        (eval `(deferred:nextc it
                 (lambda (results)
                   (with-current-buffer ,(current-buffer)
                     (save-excursion
                       (goto-char (point-min))
                       (search-forward ,jid)
                       (search-backward "src")
                       (org-babel-insert-result results ',result-params ',info)))))))
      (eval
        `(deferred:error it
           (lambda (err)
             (string-match "\"Error('\\(.*\\)')\"" (error-message-string err))
             (let ((error-str (match-string 1 (error-message-string err))))
               (when (yes-or-no-p (format "Error encountered. Reset chatgpt (If reset doesn't work, try \"\"pkill ms-playwright/firefox\"\" in the shell then reset)?" error-str))
                 (chatgpt-reset)))))))
    jid))

(provide 'ob-chatgpt)
;;; ob-chatgpt.el ends here

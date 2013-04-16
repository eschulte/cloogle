;;; cloogle.lisp --- unit test based function recommendation

;; Copyright (C) Eric Schulte 2013

;; Licensed under the Gnu Public License Version 3 or later

;;; Commentary:

;; A shameless mimic of what George Stelle is doing in haskell.

;;; Code:
(in-package :cloogle)
(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

(defun can (test)
  "Return a form which can replace `?' in TEST."
  (remove-if-not [#'eval {replace-sym test}] *funcs*))

(defun replace-sym (form with)
  (cond ((consp form) (cons (replace-sym (car form) with)
                            (replace-sym (cdr form) with)))
        ((equal '? form) with)
        (t form)))

(defun calls (form &aux calls)
  (labels ((collect (form)
             (when (and form (listp form))
               (if (equal (car form) '?)
                   (push (cdr form) calls)
                   (mapc #'collect (cdr form))))))
    (collect form)
    calls))

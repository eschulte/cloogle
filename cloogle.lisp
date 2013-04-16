;;; cloogle.lisp --- unit test based function recommendation

;; Copyright (C) Eric Schulte 2013

;; Licensed under the Gnu Public License Version 3 or later

;;; Commentary:

;; A shameless mimic of what George Stelle is doing in haskell.

;; Actually, this is stupider because it doesn't filter by types.  It
;; does collect information on both the argument and value types of
;; all functions for future use.  When we get there we should first
;; ensure the number of arguments match, then ensure types of
;; arguments match (see `typep' and `subtypep').

;;; Code:
(in-package :cloogle)
(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

(defvar *bad-funcs* '(loop)
  "Functions which we don't want to try.")

(defvar *funcs-w-types*
  (let (all)
    (do-symbols (sym)
      (ignore-errors (push (cons sym (sb-impl::%fun-type (symbol-function sym)))
                           all)))
    (remove-if {intersection *bad-funcs*} all)))

(defun can (test) ;;  &optional package external-only <- like apropos
  "Return a form which can replace `?' in TEST."
  (remove-if-not (lambda (func-spec)
                   (ignore-errors (eval (replace-sym test (car func-spec)))))
                 *funcs-w-types*))

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

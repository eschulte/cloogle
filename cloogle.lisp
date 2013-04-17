;;; cloogle.lisp --- unit test based function recommendation

;; Copyright (C) Eric Schulte 2013

;; Licensed under the Gnu Public License Version 3 or later

;;; Commentary:

;; A shameless mimic of what George Stelle is doing in haskell.

;;; Code:
(in-package :cloogle)
(eval-when (:compile-toplevel :load-toplevel :execute)
  (enable-curry-compose-reader-macros))

(defvar *bad-funcs* '(loop inspect gaussian-random)
  "Functions which we don't want to try.")

(defvar *funcs-w-types*
  (let (all)
    (do-symbols (sym)
      (ignore-errors
        (push (cons sym (cdr (sb-impl::%fun-type (symbol-function sym))))
              all)))
    (remove-if {intersection *bad-funcs*} all)))

(defun can (test) ;;  &optional package external-only <- like apropos
  "Return a form which can replace `?' in TEST."
  (let ((calls (calls test)))
    (remove-if-not
     (lambda (func-spec)
       (ignore-errors (let ((*error-output* (make-broadcast-stream))
                            (*standard-output* (make-broadcast-stream)))
                        (eval (replace-sym test (car func-spec))))))
     ;; filter by type
     (remove-if-not (if calls
                        [{match-ftype _ (mapcar #'eval (car calls))} #'second]
                        (constantly t))
                    *funcs-w-types*))))

(defun match-ftype (ftype call)
  (every (lambda (type instance)
           ;; return true if type is &rest or &key or if types match
           (case type
             ((&rest &key &optional) (return-from match-ftype t))
             (t (typep instance type))))
         (let ((diff (- (length call) (length ftype))))
           (if (positive-integer-p diff)
               (append ftype (make-list diff :initial-element nil))
               ftype)) call))

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
                   (progn (collect (car form))
                          (collect (cdr form)))))))
    (collect form)
    calls))

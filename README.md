what it does
------------

Takes a form in which `?` represents an unknown function.  Searches
all of the functions in scope which by type, evaluates the form with
each of them replacing `?`, and returns those which succeed.

how to install
--------------

Note: this uses a couple [SBCL](http://www.sbcl.org)-specific
functions, so it won't work with another lisp.

1. Install [Quicklisp](http://www.quicklisp.org/beta/) if you're not
   already using it for you lisp package management.

2. Install the [Alexandria](http://common-lisp.net/project/alexandria/)
   library.
       
        (ql:quickload :alexandria)

3. Install my curry/compose library, and this library which you'll
   have to do somewhat manually because they aren't in Quicklisp.
   Clone them to your `local-projects` directory.

        cd ~/lisp/local-projects/
        git clone git://github.com/eschulte/curry-compose-reader-macros.git
        git clone git://github.com/eschulte/cloogle.git

4. Refresh Quicklisp so it can find these libraries, and you're good
   to go.

        (ql:register-local-projects)

examples
--------

Here's an example session.

    CL-USER> (require :cloogle)
    CL-USER> (use-package :cloogle)
    T

    CL-USER> (can '(= (? 3 7) 1))
    ((GCD (&REST T) (VALUES INTEGER &OPTIONAL))
     (CEILING (T &OPTIONAL T) (VALUES INTEGER NUMBER &OPTIONAL))
     (FCEILING (T &OPTIONAL T) (VALUES NUMBER NUMBER &OPTIONAL)))

    CL-USER> (mapcar #'car (can '(= (? 3 7) 1)))
    (GCD CEILING FCEILING)

    CL-USER> (mapcar #'car (can '(= (? 3 7) 21)))
    (* LCM)

    CL-USER> (mapcar #'car (can '(= (? 3 7) 3)))
    (LOGAND REM UNWIND-PROTECT MIN DECODE-UNIVERSAL-TIME VALUES
            MULTIPLE-VALUE-PROG1 OR PROG1 MOD LOAD-TIME-VALUE)

    CL-USER> (mapcar #'car (can '(equal (? 3 7) '(3 . 7))))
    (BYTE CONS LIST*)

    CL-USER> (mapcar #'car (can '(equal (? 3 7) '(3 7))))
    (LIST)

    CL-USER> (mapcar #'car (can '(equal (? 2 6) (? 6 2))))
    (ALEXANDRIA.0.DEV:NTH-VALUE-OR ALEXANDRIA.0.DEV:ENDS-WITH
      ALEXANDRIA.0.DEV:STARTS-WITH
      ALEXANDRIA.0.DEV:XOR
      ALEXANDRIA.0.DEV:LENGTH=
      ALEXANDRIA.0.DEV:REMOVE-FROM-PLIST
      ALEXANDRIA.0.DEV:DELETE-FROM-PLIST
      EQUAL
      SLOT-EXISTS-P
      /=
      LOGXOR
      NTH-VALUE
      LOGTEST
      LOGAND
      GCD
      MAX
      MIN
      LOGNOR
      UNLESS
      LOGNAND
      TREE-EQUAL
      EQL
      LOGEQV
      TAGBODY
      =
      DOCUMENTATION
      EQ
      *
      +
      TRACE
      LOGIOR
      LCM
      EQUALP
      UNTRACE)

However some forms will still throw errors too serious for
`ignore-errors` to handle.  For example the following wrecks my lisp
image.

    CL-USER> (mapcar #'car (can '(equal (? '(2 4 1 5 3) #'<) '(1 2 3 4 5))))

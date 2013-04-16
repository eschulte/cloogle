(defsystem :cloogle
  :description "unit test based function recommendation"
  :version "0.0.0"
  :licence "GPL V3"
  :depends-on (alexandria metabang-bind curry-compose-reader-macros)
  :components
  ((:static-file "COPYING")
   (:file "package")
   (:file "cloogle" :depends-on ("package"))))

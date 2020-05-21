(defsystem :cloogle
  :description "unit test based function recommendation"
  :version "0.0.0"
  :licence "GPL V3"
    :depends-on (:cloogle/cloogle)
    :class :package-inferred-system
    :defsystem-depends-on (:asdf-package-system))

;;;; The Clojure Cookbook provides the following examples for polymorphic
;;;; functions:
;;;;
;;;; * map-based dispatch
;;;; * multi-methods
;;;; * Clojure protocols
(defmodule polymorph
  (export all))

;;; Multi-methods  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; In this example we improve upon the previosu example by separating
;;; dispatch and implementation:
;;;
;;;   (defmulti area
;;;     "Calculate the area of a shape"
;;;     :type)
;;;
;;;   (defmethod area :rectangle [shape]
;;;     (* (:length shape) (:width shape)))
;;;
;;;   (defmethod area :circle [shape]
;;;     (* (. Math PI) (:radius shape) (:radius shape)))
;;;
;;;   (area {:type :rectangle :length 2 :width 4}) ;; -> 8
;;;
;;;   (area {:type :circle :radius 1}) ;; -> 3.14159 ...

;; In LFE, there are no multi-method related macros. But the los project
;; offers these for users who wish to use them:

(include-lib "los/include/multi-methods.lfe")

(defmulti area)

(defmethod area triangle
  (((map 'base b 'height h))
   (* b h (/ 1 2))))

(defmethod area rectangle
  (((map 'length l 'width w))
   (* l w)))

(defmethod area square
  (((map 'side s))
   (* s s)))

(defmethod area circle
  (((map 'radius r))
   (* (math:pi) r r)))

(defmulti perim)

(defmethod perim rectangle
  (((map 'length l 'width w))
   (* 2 (+ l w))))

(defmethod perim circle
  (((map 'radius r))
    (* 2 (math:pi) r)))


;; To use these:
;;
;;   > (c "examples/macros/polymorph.lfe")
;;   #(module polymorph)
;;   > (slurp "examples/macros/polymorph.lfe")
;;   #(module polymorph)
;;
;;   > (area #m(type triangle side 2))
;;   4
;;   > (area #m(type rectangle side 2))
;;   > (area #m(type square side 2))
;;   > (area #m(type circle side 2))

;;;  Clojure protocols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; With Clojure multimethods you’ll need to repeat dispatch
;;; logic for each function and write a combinatorial explosion of
;;; implementations to suit. It would be better if these functions and their
;;; implementations could be grouped and written together. Use Clojure’s protocol
;;; facilities to define a protocol interface and extend it with concrete
;;; implementations:
;;;
;;; Define the "shape" of a Shape object:
;;;
;;;   (defprotocol Shape
;;;     (area [s] "Calculate the area of a shape")
;;;     (perimeter [s] "Calculate the perimeter of a shape"))
;;;
;;; Define a concrete Shape, the Rectangle:
;;;
;;;  (defrecord Rectangle [length width]
;;;     Shape
;;;     (area [this] (* length width))
;;;     (perimeter [this] (+ (* 2 length)
;;;                       (* 2 width))))
;;;
;;;   (-> Rectangle 2 4) ;; -> #user.Rectangle{: length 2, :width 4}
;;;   (area (-> Rectangle 2 4)) ;; -> 8

;; XXX explore this using the defined LFE macros.
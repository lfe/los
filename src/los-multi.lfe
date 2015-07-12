(defmodule los-multi
  (export all))

(defun multi-prefix () "multi-method-impl-")

(defun get-impl-name (fname type)
  (list_to_atom (++ (multi-prefix)
                    (atom_to_list fname)
                    "-"
                    (atom_to_list type))))

(defun dispatch (mod fname type args)
   (call mod (get-impl-name fname type) args))


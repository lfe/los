(defmacro defmulti
  ((cons name '())
   `(defun ,name
      (((= (map 'type type) args))
       (los-multi:dispatch (MODULE) ',name type (maps:remove 'type args))))))

(defmacro defmethod
  ((list name type body)
   `(defun ,(los-multi:get-impl-name name type) ,body)))

(defun loaded-multi-methods ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)
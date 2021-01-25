#lang racket/gui
(require racket/gui/base)


; both of these appear to work to send string to clipboard
;(send the-clipboard set-clipboard-string "HI 5 for doin it" (current-milliseconds))
;(send the-clipboard set-clipboard-string "HI 5 for doin it now" 0)

; docs, in order of relevance:
;   https://docs.racket-lang.org/gui/windowing-overview.html
;   https://docs.racket-lang.org/gui/clipboard___.html
;   https://docs.racket-lang.org/gui/event_.html
;   https://docs.racket-lang.org/reference/time.html
;
;   https://docs.racket-lang.org/reference/Filesystem.html
;
;   https://groups.google.com/g/racket-users/c/QmvqWtm1x28
;
;   To compile to an executable, use:
;       "c:\Program Files\Racket\raco" exe --embed-dlls --gui clipboard.rkt
;
;

(define NUM-COLS 3)


;; read lines of config file into a list of strings
(define clip-lines (file->lines "config/clipboard_txt.txt"))



; split the lines from the file into three lists
(define buttons-per-col (ceiling (/ (length clip-lines) NUM-COLS)))
(define clip-lines1 (take clip-lines buttons-per-col))
(define clip-lines2 (take (drop clip-lines buttons-per-col) buttons-per-col))
(define clip-lines3 (drop (drop clip-lines buttons-per-col) buttons-per-col))



; make a list of lists of length n out of a single list
(define (chunkify list n)
  (cond
    [(< (length list) n) list]
    [else (cons (take list n) (chunkify (drop list n) n))]))


; make a list of n lists out of a single list
(define (chunkify2 list n)
  (let* ([n2 (ceiling (/ (length list) n))])
    (chunkify list n2)))



  
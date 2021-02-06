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



;; read lines of config file into a list of strings
(define clip-lines (file->lines "config/clipboard_txt.txt"))


; make a list of lists of length n out of a single list
(define (chunkify list n)
  (cond
    [(< (length list) n) (cons list '())]
    [else (cons (take list n) (chunkify (drop list n) n))]))


; make a list of n lists out of a single list
(define (chunkify2 list n)
  (let* ([n2 (ceiling (/ (length list) n))])
    (chunkify list n2)))


; the list of lists of strings
(define columns-list (chunkify2 clip-lines 3))




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


;; read lines of config file into a list of strings
(define clip-lines (file->lines "config/clipboard_txt.txt"))


; top level window.
; the 'float style makes it an always on top type of window
(define win-frame (new frame% [label "example"]
                              [style (list 'float)]))


(define msg (new message% [parent win-frame]
                          [label "default ---"]))



; make a new button whose parent is the top level window
(define (make-button txt)
  (new button% [parent win-frame]
       [label txt]
       [callback (lambda (button event)
                   (send the-clipboard set-clipboard-string txt 0))]))


; create all the buttons in the window by recursively adding
; each one to a list
(define (all-buttons txt-list)
  (cond
    [(empty? txt-list) '()]
    [else (cons (make-button (first txt-list))
                (all-buttons (rest txt-list)))]))




(define (main)
  (all-buttons clip-lines)
  (send win-frame show #t))


(main)






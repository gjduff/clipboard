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

(define NUM-COLS 4)

(define win-frame (new frame% [label "example"]
                              [style (list 'float)]))

(define msg (new message% [parent win-frame]
                          [label "Press Buttons to Copy to Clipboard"]))

(define panel0 (new horizontal-panel% [parent win-frame]))



;----------------------------------------------------------
;  Process the file into a list of NUM-COLS  
;  lists of strings                
;----------------------------------------------------------

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
(define columns-list (chunkify2 clip-lines NUM-COLS))



;----------------------------------------------------------
;  build GUI window contents with a column for each
;  list within the list of lists of strings.
;  the column will contain a button for each string
;  of that inner list. the button places that text onto
;  the windows clipboard
;----------------------------------------------------------

; make a new button whose parent is the first arg
; the button is assigned an action sending the text of the txt
; argument to the clipboard
(define (make-button txt b-parent)
  (new button% [parent b-parent]
               [label txt]
               [callback (lambda (button event)
                           (send the-clipboard set-clipboard-string txt 0))]))


; create all the buttons in a panel by recursively adding
; each one to a list
(define (all-buttons txt-list b-parent)
  (cond
    [(empty? txt-list) '()]
    [else (cons (make-button (first txt-list) b-parent)
                (all-buttons (rest txt-list) b-parent))]))


; make a vertical panel containing buttons for every item
; in a list of strings
(define (make-panel txt-list chk-empty)
  (let* ([p (new vertical-panel% [parent panel0])]
         [b (all-buttons txt-list p)]
         [s (if (empty? chk-empty) #f (new vertical-panel% [parent panel0]))]
         [m (if (empty? chk-empty) #f (new message% [parent s]
                                                    [label "          "]))])
    p))
    
    
; for each list in the "list of lists", make a single column
; (panel with buttons)
(define (make-columns lst)
  (cond [(empty? lst) '()]
        [else (cons (make-panel (first lst) (rest lst))
                    (make-columns (rest lst)))]))


(make-columns columns-list)

(define (main)
  (send win-frame show #t))

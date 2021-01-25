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



; top level window.
; the 'float style makes it an always on top type of window
(define win-frame (new frame% [label "example"]
                              [style (list 'float)]))


(define msg (new message% [parent win-frame]
                          [label "Press Buttons to Copy to Clipboard"]))

; arrange window so buttons will occupy three columns
(define panel0 (new horizontal-panel% [parent win-frame]))

(define panel1 (new vertical-panel% [parent panel0]))
(define panel1a (new vertical-panel% [parent panel0]))
(define msg1a (new message% [parent panel1a]
                          [label "    "]))

(define panel2 (new vertical-panel% [parent panel0]))
(define panel2a (new vertical-panel% [parent panel0]))
(define msg2a (new message% [parent panel2a]
                          [label "    "]))

(define panel3 (new vertical-panel% [parent panel0]))





; make a new button whose parent is the top level window
; the button is assigned an action sending the text of the txt
; argument to the clipboard
(define (make-button txt b-parent)
  (new button% [parent b-parent]
               [label txt]
               [callback (lambda (button event)
                           (send the-clipboard set-clipboard-string txt 0))]))


; create all the buttons in the window by recursively adding
; each one to a list
(define (all-buttons txt-list b-parent)
  (cond
    [(empty? txt-list) '()]
    [else (cons (make-button (first txt-list) b-parent)
                (all-buttons (rest txt-list) b-parent))]))


; split the lines from the file into three lists
(define buttons-per-col (ceiling (/ (length clip-lines) NUM-COLS)))
(define clip-lines1 (take clip-lines buttons-per-col))
(define clip-lines2 (take (drop clip-lines buttons-per-col) buttons-per-col))
(define clip-lines3 (drop (drop clip-lines buttons-per-col) buttons-per-col))


; --- experiment
(define my-textbox
  (new text-field% [parent win-frame]
                   [label "Text"]
                   [init-value "text"]))

(define my-button
  (new button% [parent win-frame]
               [label "getText"]
               [callback (lambda (button event)
                                 (send my-button set-label (send my-textbox get-value))
                                 )]))
; ---


(define (main)
  (all-buttons clip-lines1 panel1)
  (all-buttons clip-lines2 panel2)
  (all-buttons clip-lines3 panel3)
  ;(make-textbox)
  (send win-frame show #t))



(main)






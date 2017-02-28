#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "net.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_refspec_src
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_dst
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_string
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_force
  (_fun _refspec -> _int))
(define-libgit2 git_refspec_direction
  (_fun _refspec -> _git_direction))
(define-libgit2 git_refspec_src_matches
  (_fun _refspec _string -> _int))
(define-libgit2 git_refspec_dst_matches
  (_fun _refspec _string -> _int))
(define-libgit2 git_refspec_transform
  (_fun _buf _refspec _string -> _int))
(define-libgit2 git_refspec_rtransform
  (_fun _buf _refspec _string -> _int))


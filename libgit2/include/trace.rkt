#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define _git_trace_level_t
  (_enum '(GIT_TRACE_NONE
           GIT_TRACE_FATAL
           GIT_TRACE_ERROR
           GIT_TRACE_WARN
           GIT_TRACE_INFO
           GIT_TRACE_DEBUG
           GIT_TRACE_TRACE)))

(define _git_trace_callback
  (_fun _git_trace_level_t _string -> _void))
(define-libgit2/check git_trace_set
  (_fun _git_trace_level_t _git_trace_callback -> _int))


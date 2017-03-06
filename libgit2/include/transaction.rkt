#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/alloc git_transaction_new
  (_fun _transaction _repository -> _int))
(define-libgit2/check git_transaction_lock_ref
  (_fun _transaction _string -> _int))
(define-libgit2/check git_transaction_set_target
  (_fun _transaction _string _oid _signature _string -> _int))
(define-libgit2/check git_transaction_set_symbolic_target
  (_fun _transaction _string _string _signature _string -> _int))
(define-libgit2/check git_transaction_set_reflog
  (_fun _transaction _string _reflog -> _int))
(define-libgit2/check git_transaction_remove
  (_fun _transaction _string -> _int))
(define-libgit2/check git_transaction_commit
  (_fun _transaction -> _int))
(define-libgit2 git_transaction_free
  (_fun _transaction -> _void))


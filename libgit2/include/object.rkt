#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "buffer.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/alloc git_object_lookup
  (_fun _object _repository _oid _git_otype -> _int))
(define-libgit2/alloc git_object_lookup_prefix
  (_fun _object _repository _oid _size _git_otype -> _int))
(define-libgit2/alloc git_object_lookup_bypath
  (_fun _object _object _string _git_otype -> _int))
(define-libgit2 git_object_id
  (_fun _object -> _oid))
(define-libgit2 git_object_type
  (_fun _object -> _git_otype))
(define-libgit2 git_object_owner
  (_fun _object -> _repository))
(define-libgit2 git_object_free
  (_fun _object -> _void))
(define-libgit2 git_object_type2string
  (_fun _git_otype -> _string))
(define-libgit2 git_object_string2type
  (_fun _string -> _git_otype))
(define-libgit2 git_object_typeisloose
  (_fun _git_otype -> _bool))
(define-libgit2 git_object__size
  (_fun _git_otype -> _size))
(define-libgit2/alloc git_object_peel
  (_fun _object _object _git_otype -> _int))
(define-libgit2/alloc git_object_dup
  (_fun _object _object -> _int))


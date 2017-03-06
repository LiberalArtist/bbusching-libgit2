#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define _indexer (_cpointer 'git_indexer))

(define-libgit2/alloc git_indexer_new
  (_fun _indexer _string _uint _odb _git_transfer_progress_cb (_cpointer _void) -> _int))
(define-libgit2/check git_indexer_append
  (_fun _indexer (_cpointer _void) _size _git_transfer_progress-pointer -> _int))
(define-libgit2/check git_indexer_commit
  (_fun _indexer _git_transfer_progress-pointer -> _int))
(define-libgit2 git_indexer_hash
  (_fun _indexer -> _oid))
(define-libgit2 git_indexer_free
  (_fun _indexer -> _void))


#lang racket

(require ffi/unsafe
         (only-in "net.rkt"
                  _git_direction
                  _git_remote_head)
         "strarray.rkt"
         "transport.rkt"
         "pack.rkt"
         "proxy.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_transport_message_cb
                  _git_transport_certificate_check_cb
                  _git_transfer_progress
                  _git_transfer_progress-pointer
                  _git_transfer_progress_cb
                  _git_remote
                  _git_refspec)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_remote_completion_type
  (_enum '(GIT_REMOTE_COMPLETION_DOWNLOAD
           GIT_REMOTE_COMPLETION_INDEXING
           GIT_REMOTE_COMPLETION_ERROR)))

(define _git_push_transfer_progress
  (_fun _uint _uint _size _bytes -> _int))

(define-cstruct _git_push_update
  ([src_name _string]
   [dst_name _string]
   [src _git_oid-pointer]
   [dst _git_oid-pointer]))
(define _push_update _git_push_update-pointer)

(define _git_push_negotiation
  (_fun (_cpointer _push_update) _size _bytes -> _int))

(define-cstruct _git_remote_callbacks
  ([version _uint]
   [sideband_progress _git_transport_message_cb]
   [completion (_fun _git_remote_completion_type _bytes -> _int)]
   [credentials _git_credential_acquire_cb]
   [certificate_check _git_transport_certificate_check_cb]
   [transfer_progress _git_transfer_progress_cb]
   [update_tips (_fun _string _git_oid-pointer _git_oid-pointer _bytes -> _int)]
   [pack_progress _git_packbuilder_progress]
   [push_transfer_progress _git_push_transfer_progress]
   [push_update_reference (_fun _string _string _bytes -> _int)]
   [push_negotiation _git_push_negotiation]
   [transport _git_transport_cb]
   [payload _bytes]))

(define GIT_REMOTE_CB_VERSION 1)

(define _git_fetch_prune_t
  (_enum '(GIT_FETCH_PRUNE_UNSPECIFIED
           GIT_FETCH_PRUNE_PRUNE
           GIT_FETCH_PRUNE_NO_PRUNE)))

(define _git_remote_autotag_option_t
  (_enum '(GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED
           GIT_REMOTE_DOWNLOAD_TAGS_AUTO
           GIT_REMOTE_DOWNLOAD_TAGS_NONE
           GIT_REMOTE_DOWNLOAD_TAGS_ALL)))

(define-cstruct _git_fetch_opts ;; FIX NAME
  ;; FIXME: constructor will need a wrapper to
  ;; retain the custom_headers and other gc-managed fields
  ([version _int]
   [callbacks _git_remote_callbacks]
   [prune _git_fetch_prune_t]
   [update_fetchhead _int]
   [download_tags _git_remote_autotag_option_t]
   [proxy_opts _git_proxy_options]
   [custom_headers _git_strarray]))

(define GIT_FETCH_OPTS_VERSION 1)

(define-cstruct _git_push_opts ;; FIX NAME
  ;; FIXME: constructor will need a wrapper to
  ;; retain the custom_headers and other gc-managed fields
  ([version _uint]
   [pb_parallelism _uint]
   [callbacks _git_remote_callbacks]
   [proxy_opts _git_proxy_options]
   [custom_headers _git_strarray]))

(define GIT_PUSH_OPTS_VERSION 1)

; Functions

(define-libgit2/dealloc git_remote_free
  (_fun _git_remote -> _void))

(define-libgit2/check git_remote_add_fetch
  (_fun _git_repository _git_remote _string -> _int))

(define-libgit2/check git_remote_add_push
  (_fun _git_repository _git_remote _string -> _int))

(define-libgit2 git_remote_autotag
  (_fun _git_remote -> _git_remote_autotag_option_t))

(define-libgit2/check git_remote_connect
  (_fun _git_remote
        _git_direction
        _git_remote_callbacks
        _git_proxy_options-pointer
        _git_strarray-pointer
        -> _int))

(define-libgit2 git_remote_connected
  (_fun _git_remote -> _bool))

(define-libgit2/alloc git_remote_create
  (_fun _git_remote _git_repository _string _string -> _int)
  git_remote_free)

(define-libgit2/alloc git_remote_create_anonymous
  (_fun _git_remote _git_repository _string -> _int)
  git_remote_free)

(define-libgit2/alloc git_remote_create_with_fetchspec
  (_fun _git_remote _git_repository _string _string _string -> _int)
  git_remote_free)

(define-libgit2/check git_remote_default_branch
  (_fun (_git_buf/bytes-or-null) _git_remote -> _int))

(define-libgit2/check git_remote_delete
  (_fun _git_repository _string -> _int))

(define-libgit2 git_remote_disconnect
  (_fun _git_remote -> _void))

(define-libgit2/check git_remote_download
  (_fun _git_remote
        (_or-null _git_strarray-pointer)
        _git_fetch_opts-pointer/null
        -> _int))

(define-libgit2/alloc git_remote_dup
  (_fun _git_remote _git_remote -> _int)
  git_remote_free)

(define-libgit2/check git_remote_fetch
  (_fun _git_remote
        (_or-null _git_strarray-pointer)
        _git_fetch_opts-pointer/null
        _string
        -> _int))

(define-libgit2 git_remote_get_fetch_refspecs
  (_fun [lst : _git_strarray-pointer]
        _git_remote
        -> (_git_error_code/check)
        -> lst))

(define-libgit2 git_remote_get_push_refspecs
  (_fun [lst : (_git_strarray-pointer/alloc)]
        _git_remote
        -> (_git_error_code/check)
        -> lst))

(define-libgit2 git_remote_get_refspec
  (_fun _git_remote _size -> _git_refspec))

(define-libgit2/check git_remote_init_callbacks
  (_fun _git_remote_callbacks-pointer _uint -> _int))

(define-libgit2 git_remote_name_is_valid
  (_fun [ok? : (_ptr o _bool)]
        _string
        -> (_git_error_code/check)
        -> ok?))

(define-libgit2 git_remote_list
  (_fun [lst : (_git_strarray-pointer/alloc)]
        _git_repository
        -> (_git_error_code/check)
        -> lst))

(define-libgit2/alloc git_remote_lookup
  (_fun _git_remote _git_repository _string -> _int)
  git_remote_free)

(define-libgit2 git_remote_ls
  (_fun [out : (_ptr o _git_remote_head)]
        [size : (_ptr o _size)]
        _git_error_code
        -> [v : _int]
        -> (values out size)))

(define-libgit2 git_remote_name
  (_fun _git_remote -> _string))

(define-libgit2 git_remote_owner
  (_fun _git_remote -> _git_repository))

(define-libgit2/check git_remote_prune
  (_fun _git_remote _git_remote_callbacks-pointer/null -> _int))

(define-libgit2 git_remote_prune_refs
  (_fun _git_remote -> _int))

(define-libgit2/check git_remote_push
  (_fun _git_remote
        (_or-null _git_strarray-pointer)
        _git_push_opts-pointer
        -> _int))

(define-libgit2 git_remote_pushurl
  (_fun _git_remote -> _string))

(define-libgit2 git_remote_refspec_count
  (_fun _git_remote -> _size))

(define-libgit2 git_remote_rename
  (_fun [lst : (_git_strarray-pointer/alloc)]
        _git_repository
        _string
        _string
        -> (_git_error_code/check)
        -> lst))

(define-libgit2/check git_remote_set_autotag
  (_fun _git_repository _string _git_remote_autotag_option_t -> _int))

(define-libgit2/check git_remote_set_pushurl
  (_fun _git_repository _git_remote _string -> _int))

(define-libgit2/check git_remote_set_url
  (_fun _git_repository _git_remote _string -> _int))

(define-libgit2 git_remote_stats
  (_fun _git_remote -> _git_transfer_progress-pointer))

(define-libgit2 git_remote_stop
  (_fun _git_remote -> _void))

(define-libgit2/check git_remote_update_tips
  (_fun _git_remote _git_remote_callbacks-pointer _int _git_remote_autotag_option_t _string -> _int))

(define-libgit2/check git_remote_upload
  (_fun _git_remote
        (_or-null _git_strarray-pointer)
        _git_push_opts-pointer
        -> _int))

(define-libgit2 git_remote_url
  (_fun _git_remote -> _string))

(define-libgit2/check git_fetch_options_init
  (_fun _git_fetch_opts-pointer _uint -> _int))

(define-libgit2/check git_push_options_init
  (_fun _git_push_opts-pointer _uint -> _int))

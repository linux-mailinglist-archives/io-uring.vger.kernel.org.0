Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD5585F5A
	for <lists+io-uring@lfdr.de>; Sun, 31 Jul 2022 17:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiGaPD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jul 2022 11:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiGaPD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jul 2022 11:03:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22229DEAB
        for <io-uring@vger.kernel.org>; Sun, 31 Jul 2022 08:03:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso9875837pjq.4
        for <io-uring@vger.kernel.org>; Sun, 31 Jul 2022 08:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=b46F10VGsS/pbV4In1SO/aFIhsnBFQzUIgyKcvPrSGA=;
        b=udXgpUzxwrB5liR0FrKUPH2fvdRvCthcj0E/zUeym7qq1nwtJX8gvkk0cqIHvfjfl6
         nHfqOqjlp5aHs+DNM/Mk41uefcYZNu9wwqn+pqrJUzk+Z5ji8aWUzBp+UZ5wUx9d9uvV
         CIJ6s5DdOkrX5x+MfmyBUXAi2VISHpsFly9jO7uJrhyQ6KMIcJuLcLvlpuLj6+jdEsoY
         6XPOPVcq6B3x44/mVwr4/ilKmSQSoXynYsrV0Mloy+VBB0Gh5Rimq1IxP6Vmx6a/T5bo
         lV2vPydtZ9vhmGjC/Ltp9j7GuPqiSPt0yWZnmu7QXtdMiMwZyU2/OytlyDdP1bk1kvrj
         Q5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=b46F10VGsS/pbV4In1SO/aFIhsnBFQzUIgyKcvPrSGA=;
        b=UnoFM41ZQZWSryg/qsW846D06iK+oaGkxqhkKvsbwlIOGXsWXr7N1Xlv8cYpcOxU+u
         M2bq6r12aOSQNmOkcR44+FNSdHlmNYo2wcsd78iuV7J5wdoj1o4qpX1rZbh6S3M/q1h/
         rp9kFnEi3tdr5vcfXkQoc4rnoRVhklebQu4NW+PDme2iqDStLu1BU/mppLmXaYfNJ3FA
         WJ6gZ8eEUAnlXWSLMtSi68I491x1cJ5FtO4qJLG63BlVvGoXJ/HuKAL/9zRgKTC/aOyr
         bwlqfP/Y1Fm6Tj+mLqCZHSBI/UlimhyEQbO6O68H2FbL/q594tPPb9D4lcuRw5LIGR4W
         VPbA==
X-Gm-Message-State: ACgBeo2oAbyCSq4cTaaAkZ/da37czfIUOTyxWPLbGeYFX2pKyDFBeRti
        C7PPQly7w/P1CnzYU16p430DhOHgqFSdwg==
X-Google-Smtp-Source: AA6agR5en4508RK94bXtnUmDT2tnbYtTEhMgaOuLT/TLjcjAoiZ/jVVpFdQM+nWK4fs08Z4Ox52Q5g==
X-Received: by 2002:a17:902:b08a:b0:16c:68b6:311 with SMTP id p10-20020a170902b08a00b0016c68b60311mr12067825plr.166.1659279805409;
        Sun, 31 Jul 2022 08:03:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709027fc100b0016bf7981d0bsm7514989plb.86.2022.07.31.08.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 08:03:24 -0700 (PDT)
Message-ID: <0d0db348-ef5f-e293-5837-321e7e57ad72@kernel.dk>
Date:   Sun, 31 Jul 2022 09:03:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.20-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here's the main pull request for the io_uring changes queued up for the
5.20 kernel. Details:

- As per (valid) complaint in the last merge window, fs/io_uring.c has
  grown quite large these days. io_uring isn't really tied to fs either,
  as it supports a wide variety of functionality outside of that. Move
  the code to io_uring/ and split it into files that either implement a
  specific request type, and split some code into helpers as well. The
  code is organized a lot better like this, and io_uring.c is now < 4K
  LOC (me).

- Deprecate the epoll_ctl opcode. It'll still work, just trigger a
  warning once if used. If we don't get any complaints on this, and I
  don't expect any, then we can fully remove it in a future release (me).

- Improve the cancel hash locking (Hao)

- kbuf cleanups (Hao)

- Efficiency improvements to the task_work handling (Dylan, Pavel)

- Provided buffer improvements (Dylan)

- Add support for recv/recvmsg multishot support. This is similar to the
  accept (or poll) support for have for multishot, where a single SQE
  can trigger everytime data is received. For applications that expect
  to do more than a few receives on an instantiated socket, this greatly
  improves efficiency (Dylan).

- Efficiency improvements for poll handling (Pavel)

- Poll cancelation improvements (Pavel)

- Allow specifiying a range for direct descriptor allocations (Pavel)

- Cleanup the cqe32 handling (Pavel)

- Move io_uring types to greatly cleanup the tracing (Pavel)

- Tons of great code cleanups and improvements (Pavel)

- Add a way to do sync cancelations rather than through the sqe -> cqe
  interface, as that's a lot easier to use for some use cases (me).

- Add support to IORING_OP_MSG_RING for sending direct descriptors to a
  different ring. This avoids the usually problematic SCM case, as we
  disallow those. (me)

- Make the per-command alloc cache we use for apoll generic, place
  limits on it, and use it for netmsg as well (me).

- Various cleanups (me, Michal, Gustavo, Uros)

This will merge cleanly with -git, and the only conflict I'm aware of is
with the vfs tree from Al, with the change done to fs/io_uring.c:

 -      kiocb->ki_flags = iocb_flags(file);
++      kiocb->ki_flags = file->f_iocb_flags;

Resolution is as noted, use file->f_iocb_flags in io_uring/rw.c rather
than call iocb_flags(file).

Please pull!


The following changes since commit e0dccc3b76fb35bb257b4118367a883073d7390e:

  Linux 5.19-rc8 (2022-07-24 13:26:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-2022-07-29

for you to fetch changes up to f6b543fd03d347e8bf245cee4f2d54eb6ffd8fcb:

  io_uring: ensure REQ_F_ISREG is set async offload (2022-07-24 18:39:18 -0600)

----------------------------------------------------------------
for-5.20/io_uring-2022-07-29

----------------------------------------------------------------
Dylan Yudaken (26):
      io_uring: remove priority tw list optimisation
      io_uring: remove __io_req_task_work_add
      io_uring: lockless task list
      io_uring: introduce llist helpers
      io_uring: batch task_work
      io_uring: add trace event for running task work
      io_uring: trace task_work_run
      io_uring: allow 0 length for buffer select
      io_uring: restore bgid in io_put_kbuf
      io_uring: allow iov_len = 0 for recvmsg and buffer select
      io_uring: recycle buffers on error
      io_uring: clean up io_poll_check_events return values
      io_uring: add IOU_STOP_MULTISHOT return code
      io_uring: add allow_overflow to io_post_aux_cqe
      io_uring: fix multishot poll on overflow
      io_uring: fix multishot accept ordering
      io_uring: multishot recv
      io_uring: fix io_uring_cqe_overflow trace format
      io_uring: only trace one of complete or overflow
      io_uring: disable multishot recvmsg
      io_uring: fix multishot ending when not polled
      io_uring: support 0 length iov in buffer select in compat
      net: copy from user before calling __copy_msghdr
      net: copy from user before calling __get_compat_msghdr
      io_uring: support multishot in recvmsg
      io_uring: fix types in io_recvmsg_multishot_overflow

Gustavo A. R. Silva (1):
      io_uring: replace zero-length array with flexible-array member

Hao Xu (5):
      io_uring: poll: remove unnecessary req->ref set
      io_uring: switch cancel_hash to use per entry spinlock
      io_uring: kbuf: add comments for some tricky code
      io_uring: kbuf: kill __io_kbuf_recycle()
      io_uring: kbuf: inline io_kbuf_recycle_ring()

Jens Axboe (71):
      io_uring: define a 'prep' and 'issue' handler for each opcode
      io_uring: move to separate directory
      io_uring: move req async preparation into opcode handler
      io_uring: add generic command payload type to struct io_kiocb
      io_uring: convert read/write path to use io_cmd_type
      io_uring: convert poll path to use io_cmd_type
      io_uring: convert poll_update path to use io_cmd_type
      io_uring: remove recvmsg knowledge from io_arm_poll_handler()
      io_uring: convert net related opcodes to use io_cmd_type
      io_uring: convert the sync and fallocate paths to use io_cmd_type
      io_uring: convert cancel path to use io_cmd_type
      io_uring: convert timeout path to use io_cmd_type
      io_uring: convert open/close path to use io_cmd_type
      io_uring: convert madvise/fadvise to use io_cmd_type
      io_uring: convert file system request types to use io_cmd_type
      io_uring: convert epoll to io_cmd_type
      io_uring: convert splice to use io_cmd_type
      io_uring: convert msg and nop to io_cmd_type
      io_uring: convert rsrc_update to io_cmd_type
      io_uring: convert xattr to use io_cmd_type
      io_uring: convert iouring_cmd to io_cmd_type
      io_uring: unify struct io_symlink and io_hardlink
      io_uring: define a request type cleanup handler
      io_uring: add io_uring_types.h
      io_uring: set completion results upfront
      io_uring: handle completions in the core
      io_uring: move xattr related opcodes to its own file
      io_uring: move nop into its own file
      io_uring: split out filesystem related operations
      io_uring: split out splice related operations
      io_uring: split out fs related sync/fallocate functions
      io_uring: split out fadvise/madvise operations
      io_uring: separate out file table handling code
      io_uring: split out open/close operations
      io_uring: move uring_cmd handling to its own file
      io_uring: add a dummy -EOPNOTSUPP prep handler
      io_uring: move epoll handler to its own file
      io_uring: move statx handling to its own file
      io_uring: split network related opcodes into its own file
      io_uring: move msg_ring into its own file
      io_uring: move our reference counting into a header
      io_uring: move timeout opcodes and handling into its own file
      io_uring: move SQPOLL related handling into its own file
      io_uring: use io_is_uring_fops() consistently
      io_uring: move fdinfo helpers to its own file
      io_uring: move io_uring_task (tctx) helpers into its own file
      io_uring: include and forward-declaration sanitation
      io_uring: add opcode name to io_op_defs
      io_uring: move poll handling into its own file
      io_uring: move cancelation into its own file
      io_uring: split provided buffers handling into its own file
      io_uring: move rsrc related data, core, and commands
      io_uring: move remaining file table manipulation to filetable.c
      io_uring: move read/write related opcodes to its own file
      io_uring: move opcode table to opdef.c
      io_uring: add support for level triggered poll
      io_uring: deprecate epoll_ctl support
      io_uring: remove unused IO_REQ_CACHE_SIZE defined
      io_uring: move a few private types to local headers
      io_uring: have cancelation API accept io_uring_task directly
      io_uring: add IORING_ASYNC_CANCEL_FD_FIXED cancel flag
      io_uring: add sync cancelation API through io_uring_register()
      io_uring: move POLLFREE handling to separate function
      io_uring: split out fixed file installation and removal
      io_uring: add support for passing fixed file descriptors
      io_uring: move apoll cache to poll.c
      io_uring: add abstraction around apoll cache
      io_uring: impose max limit on apoll cache
      io_uring: add netmsg cache
      net: fix compat pointer in get_compat_msghdr()
      io_uring: ensure REQ_F_ISREG is set async offload

Michal Koutn? (1):
      io_uring: Don't require reinitable percpu_ref

Pavel Begunkov (67):
      io_uring: make reg buf init consistent
      io_uring: move defer_list to slow data
      io_uring: better caching for ctx timeout fields
      io_uring: refactor ctx slow data placement
      io_uring: move small helpers to headers
      io_uring: explain io_wq_work::cancel_seq placement
      io_uring: inline ->registered_rings
      io_uring: never defer-complete multi-apoll
      io_uring: remove check_cq checking from hot paths
      io_uring: don't set REQ_F_COMPLETE_INLINE in tw
      io_uring: rw: delegate sync completions to core io_uring
      io_uring: kill REQ_F_COMPLETE_INLINE
      io_uring: refactor io_req_task_complete()
      io_uring: don't inline io_put_kbuf
      io_uring: pass poll_find lock back
      io_uring: clean up io_try_cancel
      io_uring: limit the number of cancellation buckets
      io_uring: clean up io_ring_ctx_alloc
      io_uring: use state completion infra for poll reqs
      io_uring: add IORING_SETUP_SINGLE_ISSUER
      io_uring: pass hash table into poll_find
      io_uring: introduce a struct for hash table
      io_uring: propagate locking state to poll cancel
      io_uring: mutex locked poll hashing
      io_uring: don't expose io_fill_cqe_aux()
      io_uring: don't inline __io_get_cqe()
      io_uring: introduce io_req_cqe_overflow()
      io_uring: deduplicate __io_fill_cqe_req tracing
      io_uring: deduplicate io_get_cqe() calls
      io_uring: change ->cqe_cached invariant for CQE32
      io_uring: kill extra io_uring_types.h includes
      io_uring: make io_uring_types.h public
      io_uring: clean up tracing events
      io_uring: remove extra io_commit_cqring()
      io_uring: reshuffle io_uring/io_uring.h
      io_uring: move io_eventfd_signal()
      io_uring: remove ->flush_cqes optimisation
      io_uring: fix multi ctx cancellation
      io_uring: improve task exit timeout cancellations
      io_uring: fix io_poll_remove_all clang warnings
      io_uring: hide eventfd assumptions in eventfd paths
      io_uring: introduce locking helpers for CQE posting
      io_uring: add io_commit_cqring_flush()
      io_uring: opcode independent fixed buf import
      io_uring: move io_import_fixed()
      io_uring: consistent naming for inline completion
      io_uring: add a warn_once for poll_find
      io_uring: optimize io_uring_task layout
      io_uring: improve io_run_task_work()
      io_uring: move list helpers to a separate file
      io_uring: dedup io_run_task_work
      io_uring: clean poll ->private flagging
      io_uring: remove events caching atavisms
      io_uring: add a helper for apoll alloc
      io_uring: change arm poll return values
      io_uring: refactor poll arm error handling
      io_uring: optimise submission side poll_refs
      io_uring: improve io_fail_links()
      io_uring: fuse fallback_node and normal tw node
      io_uring: remove extra TIF_NOTIFY_SIGNAL check
      io_uring: don't check file ops of registered rings
      io_uring: remove ctx->refs pinning on enter
      io_uring: let to set a range for file slot allocation
      io_uring: don't miss setting REQ_F_DOUBLE_POLL
      io_uring: don't race double poll setting REQ_F_ASYNC_DATA
      io_uring: clear REQ_F_HASH_LOCKED on hash removal
      io_uring: consolidate hash_locked io-wq handling

Uros Bizjak (1):
      io_uring: Use atomic_long_try_cmpxchg in __io_account_mem

 MAINTAINERS                     |     7 +-
 Makefile                        |     1 +
 fs/Makefile                     |     2 -
 fs/io_uring.c                   | 13273 --------------------------------------
 include/linux/io_uring_types.h  |   544 ++
 include/linux/socket.h          |     7 +-
 include/net/compat.h            |     5 +-
 include/trace/events/io_uring.h |   174 +-
 include/uapi/linux/io_uring.h   |    69 +-
 io_uring/Makefile               |    11 +
 io_uring/advise.c               |    99 +
 io_uring/advise.h               |     7 +
 io_uring/alloc_cache.h          |    53 +
 io_uring/cancel.c               |   315 +
 io_uring/cancel.h               |    23 +
 io_uring/epoll.c                |    65 +
 io_uring/epoll.h                |     6 +
 io_uring/fdinfo.c               |   194 +
 io_uring/fdinfo.h               |     3 +
 io_uring/filetable.c            |   193 +
 io_uring/filetable.h            |    88 +
 io_uring/fs.c                   |   293 +
 io_uring/fs.h                   |    20 +
 {fs => io_uring}/io-wq.c        |    18 +-
 io_uring/io-wq.h                |    83 +
 io_uring/io_uring.c             |  3980 ++++++++++++
 io_uring/io_uring.h             |   261 +
 io_uring/kbuf.c                 |   549 ++
 io_uring/kbuf.h                 |   140 +
 io_uring/msg_ring.c             |   171 +
 io_uring/msg_ring.h             |     4 +
 io_uring/net.c                  |  1047 +++
 io_uring/net.h                  |    60 +
 io_uring/nop.c                  |    25 +
 io_uring/nop.h                  |     4 +
 io_uring/opdef.c                |   494 ++
 io_uring/opdef.h                |    42 +
 io_uring/openclose.c            |   256 +
 io_uring/openclose.h            |    14 +
 io_uring/poll.c                 |   965 +++
 io_uring/poll.h                 |    39 +
 io_uring/refs.h                 |    48 +
 io_uring/rsrc.c                 |  1373 ++++
 io_uring/rsrc.h                 |   166 +
 io_uring/rw.c                   |  1020 +++
 io_uring/rw.h                   |    23 +
 fs/io-wq.h => io_uring/slist.h  |   100 +-
 io_uring/splice.c               |   122 +
 io_uring/splice.h               |     7 +
 io_uring/sqpoll.c               |   425 ++
 io_uring/sqpoll.h               |    29 +
 io_uring/statx.c                |    73 +
 io_uring/statx.h                |     5 +
 io_uring/sync.c                 |   110 +
 io_uring/sync.h                 |    10 +
 io_uring/tctx.c                 |   340 +
 io_uring/tctx.h                 |    57 +
 io_uring/timeout.c              |   644 ++
 io_uring/timeout.h              |    36 +
 io_uring/uring_cmd.c            |   114 +
 io_uring/uring_cmd.h            |    13 +
 io_uring/xattr.c                |   258 +
 io_uring/xattr.h                |    15 +
 kernel/sched/core.c             |     2 +-
 net/compat.c                    |    39 +-
 net/socket.c                    |    37 +-
 66 files changed, 15141 insertions(+), 13529 deletions(-)
 delete mode 100644 fs/io_uring.c
 create mode 100644 include/linux/io_uring_types.h
 create mode 100644 io_uring/Makefile
 create mode 100644 io_uring/advise.c
 create mode 100644 io_uring/advise.h
 create mode 100644 io_uring/alloc_cache.h
 create mode 100644 io_uring/cancel.c
 create mode 100644 io_uring/cancel.h
 create mode 100644 io_uring/epoll.c
 create mode 100644 io_uring/epoll.h
 create mode 100644 io_uring/fdinfo.c
 create mode 100644 io_uring/fdinfo.h
 create mode 100644 io_uring/filetable.c
 create mode 100644 io_uring/filetable.h
 create mode 100644 io_uring/fs.c
 create mode 100644 io_uring/fs.h
 rename {fs => io_uring}/io-wq.c (99%)
 create mode 100644 io_uring/io-wq.h
 create mode 100644 io_uring/io_uring.c
 create mode 100644 io_uring/io_uring.h
 create mode 100644 io_uring/kbuf.c
 create mode 100644 io_uring/kbuf.h
 create mode 100644 io_uring/msg_ring.c
 create mode 100644 io_uring/msg_ring.h
 create mode 100644 io_uring/net.c
 create mode 100644 io_uring/net.h
 create mode 100644 io_uring/nop.c
 create mode 100644 io_uring/nop.h
 create mode 100644 io_uring/opdef.c
 create mode 100644 io_uring/opdef.h
 create mode 100644 io_uring/openclose.c
 create mode 100644 io_uring/openclose.h
 create mode 100644 io_uring/poll.c
 create mode 100644 io_uring/poll.h
 create mode 100644 io_uring/refs.h
 create mode 100644 io_uring/rsrc.c
 create mode 100644 io_uring/rsrc.h
 create mode 100644 io_uring/rw.c
 create mode 100644 io_uring/rw.h
 rename fs/io-wq.h => io_uring/slist.h (56%)
 create mode 100644 io_uring/splice.c
 create mode 100644 io_uring/splice.h
 create mode 100644 io_uring/sqpoll.c
 create mode 100644 io_uring/sqpoll.h
 create mode 100644 io_uring/statx.c
 create mode 100644 io_uring/statx.h
 create mode 100644 io_uring/sync.c
 create mode 100644 io_uring/sync.h
 create mode 100644 io_uring/tctx.c
 create mode 100644 io_uring/tctx.h
 create mode 100644 io_uring/timeout.c
 create mode 100644 io_uring/timeout.h
 create mode 100644 io_uring/uring_cmd.c
 create mode 100644 io_uring/uring_cmd.h
 create mode 100644 io_uring/xattr.c
 create mode 100644 io_uring/xattr.h

-- 
Jens Axboe


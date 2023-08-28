Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4754D78BA2B
	for <lists+io-uring@lfdr.de>; Mon, 28 Aug 2023 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjH1VUJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Aug 2023 17:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbjH1VTo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Aug 2023 17:19:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C09695
        for <io-uring@vger.kernel.org>; Mon, 28 Aug 2023 14:19:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68a32506e90so807327b3a.1
        for <io-uring@vger.kernel.org>; Mon, 28 Aug 2023 14:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1693257580; x=1693862380;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lnh3baY4QLXh90lKfYDF75hLgbr7yoNHKJWTFONNNEg=;
        b=sck4+5mnJxbH6It2EoY+usDRy6IaR7s+L6jNpjZ+fMEjameWh3xc9r5bRc6hI8X9mZ
         g9hdykMPrhlH/w+HxGZ41t6KFhHXvMz9LnqoKyA9Vb8PixsoTCyret27F5DzHVYla+vx
         73KGWfw7TDl8MK6YhwMuHD9laZfDyzOjPh4MeqCODwoPVal1xaiJDWb2dNxT+q9YziU7
         umbXI3TRFstgAQ3FgfQtOyLNoYGIdS8SFqKTV4cCvwgz1QODkXduZQa58/n8odbTXsAF
         5nHghczJpjVtDrQKOwuDR8tUvyKvY3Du2oOHtBbKKzp26jfAQ6hzQrgtpqu3kErz0Psx
         krVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693257580; x=1693862380;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lnh3baY4QLXh90lKfYDF75hLgbr7yoNHKJWTFONNNEg=;
        b=lOimFLahbeci2l6sZz9vjvIN14IE8pN3mpqBf9Zz58lyB1rsvVkKT0GcfV77awKHZu
         2pWj0VN1j0iNrwqeBzwsbGgsnabDELtC9UH7cBLtWATdpcQuvJvBBVwnaFWlQlHz6jdb
         +zkGPkgxJ3l5EpwlOwg9U7g/Enmi3WkA2luoREpbLssqfzEgTj2KTm8pWuMGVJd+YUDV
         qUiNMZOo4BB419gXpQA3FN9z3vF9bNRMoHIMKuiIjEP9j/lfcKjPrOwMsrW8tb1vq/z1
         wJevt743wJM0DmheIaTK6qxej+dAFfyez9i47iazigRqPlmH652KJMXLVgD2g8jUG67P
         VuWQ==
X-Gm-Message-State: AOJu0YyNDInPtQKAOB7NxMDBYlTInuu9H1fN4E5iR4xI2gUr1WbBvO4x
        DJamN7Lc+Fdkdb9Cw+g6zFhnSBSNoX6HJk2cW9pZkQ==
X-Google-Smtp-Source: AGHT+IF6I7NmhG2FX2lzEj3/4yEMBLiqXcRC1x/WYnYDOpmP2OmjKPEIZyn4uZMe2WEmbjN/WusnCg==
X-Received: by 2002:a05:6a21:6da5:b0:137:3eba:b81f with SMTP id wl37-20020a056a216da500b001373ebab81fmr35263997pzb.3.1693257579991;
        Mon, 28 Aug 2023 14:19:39 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j10-20020a62b60a000000b0063b898b3502sm7078727pff.153.2023.08.28.14.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 14:19:39 -0700 (PDT)
Message-ID: <70336a64-9541-418c-8c71-9c9ee4f4961b@kernel.dk>
Date:   Mon, 28 Aug 2023 15:19:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.6-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here is the main pull request for io_uring changes for the 6.6 kernel
release. Fairly quiet round in terms of features, mostly just
improvements all over the map for existing code. In detail:

- Initial support for socket operations through io_uring. Latter half of
  this will likely land with the 6.7 kernel, then allowing things like
  get/setsockopt (Breno)

- Cleanup of the cancel code, and then adding support for canceling
  requests with the opcode as the key (me)

- Improvements for the io-wq locking (me)

- Fix affinity setting for SQPOLL based io-wq (me)

- Remove the io_uring userspace code. These were added initially as
  copies from liburing, but all of them have since bitrotted and are way
  out of date at this point. Rather than attempt to keep them in sync,
  just get rid of them. People will have liburing available anyway for
  these examples. (Pavel)

- Series improving the CQ/SQ ring caching (Pavel)

- Misc fixes and cleanups (Pavel, Yue, me)

Merges cleanly with the current master. Please pull!


The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.6/io_uring-2023-08-28

for you to fetch changes up to 644c4a7a721fb90356cdd42219c9928a3c386230:

  io_uring: move iopoll ctx fields around (2023-08-24 17:16:20 -0600)

----------------------------------------------------------------
for-6.6/io_uring-2023-08-28

----------------------------------------------------------------
Breno Leitao (1):
      io_uring: Add io_uring command support for sockets

Jens Axboe (18):
      io_uring/poll: always set 'ctx' in io_cancel_data
      io_uring/timeout: always set 'ctx' in io_cancel_data
      io_uring/cancel: abstract out request match helper
      io_uring/cancel: fix sequence matching for IORING_ASYNC_CANCEL_ANY
      io_uring: use cancelation match helper for poll and timeout requests
      io_uring/cancel: add IORING_ASYNC_CANCEL_USERDATA
      io_uring/cancel: support opcode based lookup and cancelation
      io_uring/cancel: wire up IORING_ASYNC_CANCEL_OP for sync cancel
      io_uring: annotate the struct io_kiocb slab for appropriate user copy
      io_uring: cleanup 'ret' handling in io_iopoll_check()
      io_uring/fdinfo: get rid of ref tryget
      io_uring/splice: use fput() directly
      io_uring: have io_file_put() take an io_kiocb rather than the file
      io_uring: remove unnecessary forward declaration
      io_uring/io-wq: don't grab wq->lock for worker activation
      io_uring/io-wq: reduce frequency of acct->lock acquisitions
      io_uring/io-wq: don't gate worker wake up success on wake_up_process()
      io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL is used

Kees Cook (1):
      io_uring/rsrc: Annotate struct io_mapped_ubuf with __counted_by

Pavel Begunkov (26):
      io_uring: fix drain stalls by invalid SQE
      io_uring: fix false positive KASAN warnings
      io_uring: kill io_uring userspace examples
      io_uring: break iopolling on signal
      io_uring/net: don't overflow multishot accept
      io_uring/net: don't overflow multishot recv
      io_uring: open code io_fill_cqe_req()
      io_uring: remove return from io_req_cqe_overflow()
      io_uring: never overflow io_aux_cqe
      io_uring/rsrc: keep one global dummy_ubuf
      io_uring: simplify io_run_task_work_sig return
      io_uring: improve cqe !tracing hot path
      io_uring: cqe init hardening
      io_uring: simplify big_cqe handling
      io_uring: refactor __io_get_cqe()
      io_uring: optimise extra io_get_cqe null check
      io_uring: reorder cqring_flush and wakeups
      io_uring: merge iopoll and normal completion paths
      io_uring: force inline io_fill_cqe_req
      io_uring: compact SQ/CQ heads/tails
      io_uring: add option to remove SQ indirection
      io_uring: move non aligned field to the end
      io_uring: banish non-hot data to end of io_ring_ctx
      io_uring: separate task_work/waiting cache line
      io_uring: move multishot cqe cache in ctx
      io_uring: move iopoll ctx fields around

Yue Haibing (1):
      io_uring/rsrc: Remove unused declaration io_rsrc_put_tw()

 MAINTAINERS                     |   1 -
 include/linux/io_uring.h        |   6 +
 include/linux/io_uring_types.h  | 129 ++++-----
 include/uapi/linux/io_uring.h   |  21 +-
 io_uring/cancel.c               |  60 +++-
 io_uring/cancel.h               |   3 +-
 io_uring/fdinfo.c               |  18 +-
 io_uring/io-wq.c                |  70 +++--
 io_uring/io-wq.h                |   2 +-
 io_uring/io_uring.c             | 225 ++++++++-------
 io_uring/io_uring.h             |  79 ++----
 io_uring/net.c                  |   8 +-
 io_uring/poll.c                 |  21 +-
 io_uring/rsrc.c                 |  14 +-
 io_uring/rsrc.h                 |   3 +-
 io_uring/rw.c                   |  24 +-
 io_uring/splice.c               |   4 +-
 io_uring/sqpoll.c               |  15 +
 io_uring/sqpoll.h               |   1 +
 io_uring/timeout.c              |  20 +-
 io_uring/uring_cmd.c            |  33 ++-
 net/socket.c                    |   2 +
 tools/io_uring/Makefile         |  18 --
 tools/io_uring/README           |  29 --
 tools/io_uring/barrier.h        |  16 --
 tools/io_uring/io_uring-bench.c | 592 ----------------------------------------
 tools/io_uring/io_uring-cp.c    | 283 -------------------
 tools/io_uring/liburing.h       | 187 -------------
 tools/io_uring/queue.c          | 156 -----------
 tools/io_uring/setup.c          | 107 --------
 tools/io_uring/syscall.c        |  52 ----
 31 files changed, 432 insertions(+), 1767 deletions(-)
 delete mode 100644 tools/io_uring/Makefile
 delete mode 100644 tools/io_uring/README
 delete mode 100644 tools/io_uring/barrier.h
 delete mode 100644 tools/io_uring/io_uring-bench.c
 delete mode 100644 tools/io_uring/io_uring-cp.c
 delete mode 100644 tools/io_uring/liburing.h
 delete mode 100644 tools/io_uring/queue.c
 delete mode 100644 tools/io_uring/setup.c
 delete mode 100644 tools/io_uring/syscall.c

-- 
Jens Axboe


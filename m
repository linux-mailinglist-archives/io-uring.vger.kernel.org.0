Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1F53061F
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 23:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351488AbiEVV0Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 17:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351535AbiEVV0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 17:26:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B0A5F8E
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:25:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so11997133pju.1
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=Fay8J0v9s6GHrHv7n4zbVp6ctRZpch/X3cL5vAysVwU=;
        b=HyyortGgroHgnwxrSv3GYWTE2BEBKuYXfdrLY03s6LgFyMIiyEhx55K4aebx2SsWiD
         b0mJYOMb5ewhcW01UbMVf4Fv4EYgDz3dBjZt2pSdNeogqWo+IZO3Gm6DCGBs/bP0SsXz
         tUO9pBUITB6KGM8j1HcMxT/eK5vcOuKWqdD+vpA2dHewzwOcVdrd0lHJc1A9nzuDLpvu
         KdG9NQw16r7dK7e9mym2VxUbzkEoUFXqMf4LJePx3VtYatnDnUTKpB2wMTeYPdnSBPV9
         nZSXpxaAe9/UcH8VNplGHISJeyV0Xwq0NMcNlApuuwxWALG8nNcusDoh5cf9I1G8g+a2
         dfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=Fay8J0v9s6GHrHv7n4zbVp6ctRZpch/X3cL5vAysVwU=;
        b=rYfuCyMLNgjTgastyupsQ4AQIDAev+woX4CySr1dARb4mJKYblKbBbm6uJMR2ruzav
         9tn3XkAWOjNWTrAmU/TY0qdFHW1Bf4yISlyXBVcHcNkb7OV0/XTmg+5oEjvcraWFQ37J
         cbZ/eu62/9I7FG+Ug8WyzFDaBeAiz4I06TrF+WqW42PlwCvGxE71rmOfsOtDzhooyZBO
         M+NHz8OmA79rDZ4XS7YmgHFJmyFqUkdOUAyyTbiSL4I++q4YwbdOzwcGxLz2kbezew7h
         gEzctbKNwN/Op4EoornBZTEtApVRwDvFctrP8hCYfxJSuq/K4F3FBM7RNETUTtU4Vg9f
         kPUA==
X-Gm-Message-State: AOAM530vPFFX9dZgXtJt99vLJcn1Wlh0i/WqPj73X+niMy+B2+Scs5Za
        RqU0GAuyErI9H3quGHx7x3wpa9t+ixw53w==
X-Google-Smtp-Source: ABdhPJxk0/8aFzJDbs2toG8ELx4rJYpzufATtUAVf0EzxFZFuiAWk9tH19CgfC3t18DzCKz97GpGbw==
X-Received: by 2002:a17:903:44e:b0:161:58c6:77e5 with SMTP id iw14-20020a170903044e00b0016158c677e5mr20317324plb.81.1653254758393;
        Sun, 22 May 2022 14:25:58 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902aa8f00b0015e8d4eb2d3sm3517046plr.285.2022.05.22.14.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 14:25:57 -0700 (PDT)
Message-ID: <6003da99-86f6-df03-7e21-a80e82d52f66@kernel.dk>
Date:   Sun, 22 May 2022 15:25:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring core updates for 5.19-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here are the main io_uring changes for the 5.19 merge window. This pull
request contains:

- Fixes for sparse type warnings (Christoph, Vasily)

- Support for multi-shot accept (Hao)

- Support for io_uring managed fixed files, rather than always needing
  the applicationt o manage the indices (me)

- Fix for a spurious poll wakeup (Dylan)

- CQE overflow fixes (Dylan)

- Support more types of cancelations (me)

- Support for co-operative task_work signaling, rather than always
  forcing an IPI (me)

- Support for doing poll first when appropriate, rather than always
  attempting a transfer first (me)

- Provided buffer cleanups and support for mapped buffers (me)

- Improve how io_uring handles inflight SCM files (Pavel)

- Speedups for registered files (Pavel, me)

- Organize the completion data in a struct in io_kiocb rather than keep
  it in separate spots (Pavel)

- task_work improvements (Pavel)

- Cleanup and optimize the submission path, in general and for handling
  links (Pavel)

- Speedups for registered resource handling (Pavel)

- Support sparse buffers and file maps (Pavel, me)

- Various fixes and cleanups (Almog, Pavel, me)

This will merge cleanly, but due to the completion data change mentioned
above, a late fix in 5.18 will cause it to fail compile. Fix is to do:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59e65d70dfda..0c6a14276186 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7413,7 +7413,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 
 	/* assign early for deferred execution for non-fixed file */
 	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
-		req->file = io_file_get_normal(req, req->fd);
+		req->file = io_file_get_normal(req, req->cqe.fd);
 	if (!def->needs_async_setup)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))

and then it'll be fine.

Please pull!


The following changes since commit af2d861d4cd2a4da5137f795ee3509e6f944a25b:

  Linux 5.18-rc4 (2022-04-24 14:51:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-2022-05-22

for you to fetch changes up to 0e7579ca732a39cc377e17509dda9bfc4f6ba78e:

  io_uring: fix incorrect __kernel_rwf_t cast (2022-05-19 12:27:59 -0600)

----------------------------------------------------------------
for-5.19/io_uring-2022-05-22

----------------------------------------------------------------
Almog Khaikin (1):
      io_uring: replace smp_mb() with smp_mb__after_atomic() in io_sq_thread()

Christoph Hellwig (6):
      io_uring: use a rwf_t for io_rw.flags
      io_uring: don't use ERR_PTR for user pointers
      io_uring: drop a spurious inline on a forward declaration
      io_uring: make apoll_events a __poll_t
      io_uring: consistently use the EPOLL* defines
      io_uring: use rcu_dereference in io_close

Dylan Yudaken (6):
      io_uring: add trace support for CQE overflow
      io_uring: trace cqe overflows
      io_uring: rework io_uring_enter to simplify return value
      io_uring: use constants for cq_overflow bitfield
      io_uring: return an error when cqe is dropped
      io_uring: only wake when the correct events are set

Hao Xu (4):
      io_uring: add IORING_ACCEPT_MULTISHOT for accept
      io_uring: add REQ_F_APOLL_MULTISHOT for requests
      io_uring: let fast poll support multishot
      io_uring: implement multishot mode for accept

Jens Axboe (43):
      io_uring: move finish_wait() outside of loop in cqring_wait()
      io_uring: store SCM state in io_fixed_file->file_ptr
      io_uring: remove dead 'poll_only' argument to io_poll_cancel()
      io_uring: pass in struct io_cancel_data consistently
      io_uring: add support for IORING_ASYNC_CANCEL_ALL
      io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
      io_uring: add support for IORING_ASYNC_CANCEL_ANY
      io_uring: support MSG_WAITALL for IORING_OP_SEND(MSG)
      io_uring: allow re-poll if we made progress
      io_uring: fix compile warning for 32-bit builds
      task_work: allow TWA_SIGNAL without a rescheduling IPI
      io_uring: serialize ctx->rings->sq_flags with atomic_or/and
      io-wq: use __set_notify_signal() to wake workers
      io_uring: set task_work notify method at init time
      io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_COOP_TASKRUN is used
      io_uring: add IORING_SETUP_TASKRUN_FLAG
      io_uring: check IOPOLL/ioprio support upfront
      io_uring: add POLL_FIRST support for send/sendmsg and recv/recvmsg
      io_uring: use 'sr' vs 'req->sr_msg' consistently
      io_uring: kill io_recv_buffer_select() wrapper
      io_uring: make io_buffer_select() return the user address directly
      io_uring: kill io_rw_buffer_select() wrapper
      io_uring: ignore ->buf_index if REQ_F_BUFFER_SELECT isn't set
      io_uring: always use req->buf_index for the provided buffer group
      io_uring: get rid of hashed provided buffer groups
      io_uring: never call io_buffer_select() for a buffer re-select
      io_uring: abstract out provided buffer list selection
      io_uring: move provided and fixed buffers into the same io_kiocb area
      io_uring: move provided buffer state closer to submit state
      io_uring: eliminate the need to track provided buffer ID separately
      io_uring: don't clear req->kbuf when buffer selection is done
      io_uring: track fixed files with a bitmap
      io_uring: add basic fixed file allocator
      io_uring: allow allocated fixed files for openat/openat2
      io_uring: allow allocated fixed files for accept
      io_uring: bump max direct descriptor count to 1M
      io_uring: add flag for allocating a fully sparse direct descriptor space
      io_uring: fix locking state for empty buffer group
      io_uring: add buffer selection support to IORING_OP_NOP
      io_uring: add io_pin_pages() helper
      io_uring: add support for ring mapped supplied buffers
      io_uring: initialize io_buffer_list head when shared ring is unregistered
      io_uring: disallow mixed provided buffer group registrations

Pavel Begunkov (50):
      io_uring: small optimisation of tctx_task_work
      io_uring: remove extra ifs around io_commit_cqring
      io_uring: refactor io_req_find_next
      io_uring: optimise io_free_batch_list
      io_uring: move poll recycling later in compl flushing
      io_uring: clean up io_queue_next()
      io_uring: split off IOPOLL argument verifiction
      io_uring: pre-calculate syscall iopolling decision
      io_uring: optimise mutex locking for submit+iopoll
      io_uring: cleanup conditional submit locking
      io_uring: partially uninline io_put_task()
      io_uring: silence io_for_each_link() warning
      io_uring: refactor io_req_add_compl_list()
      io_uring: don't scm-account for non af_unix sockets
      io_uring: uniform SCM accounting
      io_uring: refactor __io_sqe_files_scm
      io_uring: don't pass around fixed index for scm
      io_uring: deduplicate SCM accounting
      io_uring: rename io_sqe_file_register
      io_uring: explicitly keep a CQE in io_kiocb
      io_uring: memcpy CQE from req
      io_uring: shrink final link flush
      io_uring: inline io_flush_cached_reqs
      io_uring: helper for empty req cache checks
      io_uring: add helper to return req to cache list
      io_uring: optimise submission loop invariant
      io_uring: optimise submission left counting
      io_uring: optimise io_get_cqe()
      io_uring: clean poll tw PF_EXITING handling
      io_uring: minor refactoring for some tw handlers
      io_uring: kill io_put_req_deferred()
      io_uring: inline io_free_req()
      io_uring: helper for prep+queuing linked timeouts
      io_uring: inline io_queue_sqe()
      io_uring: rename io_queue_async_work()
      io_uring: refactor io_queue_sqe()
      io_uring: introduce IO_REQ_LINK_FLAGS
      io_uring: refactor lazy link fail
      io_uring: refactor io_submit_sqe()
      io_uring: inline io_req_complete_fail_submit()
      io_uring: add data_race annotations
      io_uring: use right helpers for file assign locking
      io_uring: refactor io_assign_file error path
      io_uring: store rsrc node in req instead of refs
      io_uring: add a helper for putting rsrc nodes
      io_uring: kill ctx arg from io_req_put_rsrc
      io_uring: move timeout locking in io_timeout_cancel()
      io_uring: refactor io_disarm_next() locking
      io_uring: avoid io-wq -EAGAIN looping for !IOPOLL
      io_uring: add fully sparse buffer registration

Vasily Averin (1):
      io_uring: fix incorrect __kernel_rwf_t cast

 fs/io-wq.c                      |    4 +-
 fs/io-wq.h                      |    1 +
 fs/io_uring.c                   | 2659 ++++++++++++++++++++++++---------------
 include/linux/sched/signal.h    |   13 +-
 include/linux/task_work.h       |    1 +
 include/trace/events/io_uring.h |   44 +-
 include/uapi/linux/io_uring.h   |   95 +-
 kernel/task_work.c              |   25 +-
 8 files changed, 1812 insertions(+), 1030 deletions(-)

-- 
Jens Axboe


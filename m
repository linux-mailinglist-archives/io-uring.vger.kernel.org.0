Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9581391C78
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhEZPyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhEZPyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:54:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F25C061756
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:52:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso3578709wmc.1
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vR7zO7ONAkB1ZzssZ7IpH6ITBFI+V1mbfLUUoRoWsaI=;
        b=WEbhhdt1n16tMQKT5cvaOB+bIygR+ue6CrEjJ1xZdltjv9WfAHuoqfMFxn+RS06Ucb
         UGFvL9VaUqdtNXvCZOOfELeryPpGq5dNMMlpBsS+k3UIhm/AHqKutI+4/WKn66emgDEC
         eusdlHzVckAQTO5b7g0B/eS1CjY9pEb1vBhLtLxdcOzCbcBSdXLd1nGy1lNW2PpxnZV9
         1wo83nFcdkZoC9X39QWic0kmKT4+dIxhfCh0I3SP7Yfb2pRxLPl8mFZXZdI6TaFukdYT
         Pq++S69eYsUfbY85gnK+Khk6BCWYMlKNQDg7wme7jmZJRKK66s+4Tk8uBwI5Mg7+a8XL
         bi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vR7zO7ONAkB1ZzssZ7IpH6ITBFI+V1mbfLUUoRoWsaI=;
        b=VOjeO+oEuO/4YrQfpoj3/Oxt8wHfHEbs04UmWzcSnnu4oHvVfK8CvuezYAiU5ts+28
         nTm+kEJQby2D9+OuwQYR5N0GzyGPD6WqmRviE77iwz15Nw9DVxk7OaLRSwmAGLlGBQmW
         OUpaVP570OmfIRzOmw5Ti1O3Kt7uwvpipHIlk1J4KXEVhDMMD6uLd6f5SfLjGuRqCitC
         gNimppLKtw43JPaLRgHEzqmce0i7l3WpQs958U7ZTlTBMYOXlwX4o2wbxKPRWjE8Sy9s
         O3Evucl99/Ir3shBJ0BNFSVCt0QxrnxrhsALabsUes7nR2i6K/oDLDUH61cGKLFOWsJE
         2iQQ==
X-Gm-Message-State: AOAM533j48p7S3m495M0u2ReBeCr7x3V+HW4Lc4iSE5gadtmv1zlYGkZ
        IE2MrF/flIat2tNk1z1RuEOkcw==
X-Google-Smtp-Source: ABdhPJwVejaX6ExwwxIk+Q71mFt4SgeeMScRqGZKFRHePK6dzeR0CURXRqG517ANZ0zVWs1DSzSUbw==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr16047859wml.40.1622044369142;
        Wed, 26 May 2021 08:52:49 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:74ba:ff42:8494:7f35])
        by smtp.gmail.com with ESMTPSA id r17sm7412145wmh.25.2021.05.26.08.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:52:48 -0700 (PDT)
Date:   Wed, 26 May 2021 17:52:42 +0200
From:   Marco Elver <elver@google.com>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     syzbot <syzbot+73554e2258b7b8bf0bbf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, dvyukov@google.com
Subject: Re: [syzbot] KCSAN: data-race in __io_uring_cancel /
 io_uring_try_cancel_requests
Message-ID: <YK5uygiCGlmgQLKE@elver.google.com>
References: <000000000000fa9f7005c33d83b9@google.com>
 <YK5tyZNAFc8dh6ke@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK5tyZNAFc8dh6ke@elver.google.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 05:48PM +0200, Marco Elver wrote:
> On Wed, May 26, 2021 at 08:44AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    a050a6d2 Merge tag 'perf-tools-fixes-for-v5.13-2021-05-24'..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13205087d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3bcc8a6b51ef8094
> > dashboard link: https://syzkaller.appspot.com/bug?extid=73554e2258b7b8bf0bbf
> > compiler:       Debian clang version 11.0.1-2
> [...]
> > write to 0xffff88811d8df330 of 8 bytes by task 3709 on cpu 1:
> >  io_uring_clean_tctx fs/io_uring.c:9042 [inline]
> >  __io_uring_cancel+0x261/0x3b0 fs/io_uring.c:9136
> >  io_uring_files_cancel include/linux/io_uring.h:16 [inline]
> >  do_exit+0x185/0x1560 kernel/exit.c:781
> >  do_group_exit+0xce/0x1a0 kernel/exit.c:923
> >  get_signal+0xfc3/0x1610 kernel/signal.c:2835
> >  arch_do_signal_or_restart+0x2a/0x220 arch/x86/kernel/signal.c:789
> >  handle_signal_work kernel/entry/common.c:147 [inline]
> >  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
> >  exit_to_user_mode_prepare+0x109/0x190 kernel/entry/common.c:208
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
> >  syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
> >  do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > read to 0xffff88811d8df330 of 8 bytes by task 6412 on cpu 0:
> >  io_uring_try_cancel_iowq fs/io_uring.c:8911 [inline]
> >  io_uring_try_cancel_requests+0x1ce/0x8e0 fs/io_uring.c:8933
> >  io_ring_exit_work+0x7c/0x1110 fs/io_uring.c:8736
> >  process_one_work+0x3e9/0x8f0 kernel/workqueue.c:2276
> >  worker_thread+0x636/0xae0 kernel/workqueue.c:2422
> >  kthread+0x1d0/0x1f0 kernel/kthread.c:313
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> I wasn't entirely sure if io_wq is guaranteed to remain live in this
> case in io_uring_try_cancel_iowq(), but the comment there suggests it
> does. In that case, I think the below patch would explain the situation
> better and also propose a fix.
> 
> Thoughts?

Due to some moving around of code, the patch lost the actual fix (using
atomically read io_wq) -- so here it is again ... hopefully as intended.
:-)

Thanks,
-- Marco

From: Marco Elver <elver@google.com>
Date: Wed, 26 May 2021 16:56:37 +0200
Subject: [PATCH] io_uring: fix data race to avoid potential NULL-deref

Commit ba5ef6dc8a82 ("io_uring: fortify tctx/io_wq cleanup") introduced
setting tctx->io_wq to NULL a bit earlier. This has caused KCSAN to
detect a data race between between accesses to tctx->io_wq:

  write to 0xffff88811d8df330 of 8 bytes by task 3709 on cpu 1:
   io_uring_clean_tctx                  fs/io_uring.c:9042 [inline]
   __io_uring_cancel                    fs/io_uring.c:9136
   io_uring_files_cancel                include/linux/io_uring.h:16 [inline]
   do_exit                              kernel/exit.c:781
   do_group_exit                        kernel/exit.c:923
   get_signal                           kernel/signal.c:2835
   arch_do_signal_or_restart            arch/x86/kernel/signal.c:789
   handle_signal_work                   kernel/entry/common.c:147 [inline]
   exit_to_user_mode_loop               kernel/entry/common.c:171 [inline]
   ...
  read to 0xffff88811d8df330 of 8 bytes by task 6412 on cpu 0:
   io_uring_try_cancel_iowq             fs/io_uring.c:8911 [inline]
   io_uring_try_cancel_requests         fs/io_uring.c:8933
   io_ring_exit_work                    fs/io_uring.c:8736
   process_one_work                     kernel/workqueue.c:2276
   ...

With the config used, KCSAN only reports data races with value changes:
this implies that in the case here we also know that tctx->io_wq was
non-NULL. Therefore, depending on interleaving, we may end up with:

              [CPU 0]                 |        [CPU 1]
  io_uring_try_cancel_iowq()          | io_uring_clean_tctx()
    if (!tctx->io_wq) // false        |   ...
    ...                               |   tctx->io_wq = NULL
    io_wq_cancel_cb(tctx->io_wq, ...) |   ...
      -> NULL-deref                   |

Note: It is likely that thus far we've gotten lucky and the compiler
optimizes the double-read into a single read into a register -- but this
is never guaranteed, and can easily change with a different config!

Fix the data race by atomically accessing tctx->io_wq. Of course, this
assumes that a valid io_wq remains alive for the duration of
io_uring_try_cancel_iowq(), which should be the case per comment there.

Reported-by: syzbot+bf2b3d0435b9b728946c@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f82954004f6..e681ece1bbca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8903,14 +8903,18 @@ static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
+		struct io_wq *io_wq;
 
+		if (!tctx)
+			continue;
 		/*
 		 * io_wq will stay alive while we hold uring_lock, because it's
 		 * killed after ctx nodes, which requires to take the lock.
 		 */
-		if (!tctx || !tctx->io_wq)
+		io_wq = READ_ONCE(tctx->io_wq);
+		if (!io_wq)
 			continue;
-		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
+		cret = io_wq_cancel_cb(io_wq, io_cancel_ctx_cb, ctx, true);
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
 	mutex_unlock(&ctx->uring_lock);
@@ -9039,7 +9043,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	tctx->io_wq = NULL;
+	WRITE_ONCE(tctx->io_wq, NULL);
 	xa_for_each(&tctx->xa, index, node)
 		io_uring_del_task_file(index);
 	if (wq)
-- 
2.31.1.818.g46aad6cb9e-goog


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873CC65E9C0
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjAELXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjAELXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:34 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE9C4FD75
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:33 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so2276277wml.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pkim4tG4NDBUuRyin4QQLRlT/GqMiXafE1MXKCTtQQ=;
        b=Shg+/8OfjNobEeonLkO2VJyizuRofDISgUhR7IaaHYVFZV/PsaPcx5L5CXDJphaZVC
         8o+XbEaje+zJhNXmF02KkzbfEdtcs3t5OJYj6up7W572ysIXG5wnpxhMBseIV4PL9FPJ
         FeoBudGZSRsWex7U1WiXgvaoax8Aq2pjBywAcGaHQ8OBlzdoVSrtFq5lTED62iFyZJDj
         IZTDT0vyS2cvrGRXEmnNldMntfRhUW20ljZv42FT10vVkLVDyG+LSWLqxsQRo7wfYXtm
         vYehp396ly8wQtS8GfkKJC35Rc3W6ZyCWUAVhVNHs7VmDuxBBAMHD/TPckTuF9yP0lHh
         TDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+pkim4tG4NDBUuRyin4QQLRlT/GqMiXafE1MXKCTtQQ=;
        b=yqVrLfRWZiOx59qu0BXh9mv3Eyd0yOwAEg5M/WQ1QDioCTB9V+Z29ccde4/9ZuXXOC
         myTGMp+R5u1XypLmsJMUwiUeDhwbK75bPKfDR/dImi+OlOq1OwwXs++HfPTddaN09bXI
         Z7L7IyVdnOiyrr4x8SoFx/Dqaaz0cl4ua6DC+8PJBAiU/0kv7pvF+tpMs+gHp9seSOn2
         2eSNKZbAXRBL5eLoK0kFqYd95mwj4N41kdSjrPwCkWs34lyvZm1Z5dP72Vfsf0C7wFZ0
         ke0PmoAIlrbxnlHnLR5hk4OFOcoF4+wAmtoE08bDREovsbq6wkDLxctDVBc+7u4doAYT
         2jgQ==
X-Gm-Message-State: AFqh2kqK2j9t6Q3FlNKK6OifDblClVbIjO5BKc7Kk+JUVzabc0YKdmRz
        WNDOCfXFozMv4hhcGKhASorhDvy2eig=
X-Google-Smtp-Source: AMrXdXsSUl5+BwFTHDvZReujZQRpgLh/F4VCbBg9XnTHZ4Rh/7AVLwWSjS7RYeHteamZnpKwoH0yyQ==
X-Received: by 2002:a05:600c:220c:b0:3d2:3831:e5c4 with SMTP id z12-20020a05600c220c00b003d23831e5c4mr39546346wml.40.1672917812165;
        Thu, 05 Jan 2023 03:23:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 06/10] io_uring: mimimise io_cqring_wait_schedule
Date:   Thu,  5 Jan 2023 11:22:25 +0000
Message-Id: <2814fabe75e2e019e7ca43ea07daa94564349805.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cqring_wait_schedule() is called after we started waiting on the cq
wq and set the state to TASK_INTERRUPTIBLE, for that reason we have to
constantly worry whether we has returned the state back to running or
not. Leave only quick checks in io_cqring_wait_schedule() and move the
rest including running task work to the callers. Note, we run tw in the
loop after the sched checks because of the fast path in the beginning of
the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 067e3577ac9b..b4ca238cbd63 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2467,24 +2467,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
 					  ktime_t *timeout)
 {
-	int ret;
-
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
-	/* make sure we run task_work before checking for signals */
-	ret = io_run_task_work_sig(ctx);
-	if (ret || io_should_wake(iowq))
-		return ret;
+	if (unlikely(!llist_empty(&ctx->work_llist)))
+		return 1;
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+		return 1;
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+	if (unlikely(io_should_wake(iowq)))
+		return 0;
 	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
-
-	/*
-	 * Run task_work after scheduling. If we got woken because of
-	 * task_work being processed, run it now rather than let the caller
-	 * do another wait loop.
-	 */
-	ret = io_run_task_work_sig(ctx);
-	return ret < 0 ? ret : 1;
+	return 0;
 }
 
 /*
@@ -2545,6 +2540,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		if (ret < 0)
+			break;
+		/*
+		 * Run task_work after scheduling and before io_should_wake().
+		 * If we got woken because of task_work being processed, run it
+		 * now rather than let the caller do another wait loop.
+		 */
+		io_run_task_work();
+		if (!llist_empty(&ctx->work_llist))
+			io_run_local_work(ctx);
 
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
@@ -2559,10 +2564,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			}
 		}
 
-		if (__io_cqring_events_user(ctx) >= min_events)
+		if (io_should_wake(&iowq)) {
+			ret = 0;
 			break;
+		}
 		cond_resched();
-	} while (ret > 0);
+	} while (1);
 
 	finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
-- 
2.38.1


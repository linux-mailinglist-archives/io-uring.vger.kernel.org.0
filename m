Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6F65B98F
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbjACDFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbjACDF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:27 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C3EBE3C
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:26 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso15758521wmb.1
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Df0rkeviyDF2yto0MQKu8Bc1IpWSypehWf9m4+kV1uM=;
        b=c+cbOcL2HcVB6jlLiv0EROiSEgODmRzVb6dfFjWtkhDC2Aj/grTJEkjFZW6F76lw8W
         uU+csCclI9xgAo5+cmX6mi8pq+OBQn0ViWB9aRzpA5MkwVa9AytuPVA2Aw1jLQtDfc1g
         X4WeYILNsSUyl1nT0AzI+oj/bO6va0NK0Z5ZQiFcv7V8q5BYoapqXlYR6zzFXagUMpsO
         xWjalh8CKaT7WDW3USGy7vLbQn8/4U705Ti6U0egp/jf5lA98AdGc/g19fGsuXPT3STJ
         AruNzkciXhk2OtSTnpBTzhw2jjCKZytsUNiJx19lay3glsnp5GkwNAdwEAdQWam0al63
         o21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Df0rkeviyDF2yto0MQKu8Bc1IpWSypehWf9m4+kV1uM=;
        b=N0Vp/jGkrPByrieXiSYgthKay5QtZ7GBTpylx8eLB2Vb8zjY4pJOYSVl4PMtxkDeyk
         80rUjv7NXtLuzx+VK7d1qGQcw1SVWxP5hXEP48Wqw2s0V4eeWEfwwx8n+NIbqQHWbtC4
         3NM0I2SuxTfpuTjSR1mpsenLpdkkw7WNJAt+D7QQko9mtzg5pdztGvfapcQme3Qgq010
         41WyuMzKlW88S/vrt4xH1UsF6ODkNxbGnfgeTEMiHGX0QkWZQDPp1Fbs43NaskDG4J5A
         pTXgT+aryO9ojf5alAeNewqU1kNIbCxOvadQ/oZLky56VuE/XnvSZuLTr98Y6DvbHQLF
         MYCg==
X-Gm-Message-State: AFqh2kr2iNXDn9QRmhsZS/RHoQwc9eEpbQgD1Wuf5JIzI84KZtdUK87k
        h9WXtK4i5qiMzTmcZjQ8R48ByI6C4hY=
X-Google-Smtp-Source: AMrXdXtWCDN8VeB5S+gHQNgaT/B7HYWEsXCL/zjGwa/eoIRLs+mjipzTWoHm86N54C8TbMd70Zasqw==
X-Received: by 2002:a05:600c:214a:b0:3cf:6910:51d4 with SMTP id v10-20020a05600c214a00b003cf691051d4mr29612671wml.29.1672715124434;
        Mon, 02 Jan 2023 19:05:24 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 06/13] io_uring: mimimise io_cqring_wait_schedule
Date:   Tue,  3 Jan 2023 03:03:57 +0000
Message-Id: <4d299f7d0c3007bed5f62e2a53a928013e8c19e4.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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
---
 io_uring/io_uring.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e3c5de299baa..fc9604848bbb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2467,24 +2467,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
 					  ktime_t timeout)
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
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
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
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
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


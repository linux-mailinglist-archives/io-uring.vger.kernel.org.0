Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D512548871C
	for <lists+io-uring@lfdr.de>; Sun,  9 Jan 2022 01:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiAIAyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Jan 2022 19:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiAIAyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Jan 2022 19:54:17 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11882C06173F
        for <io-uring@vger.kernel.org>; Sat,  8 Jan 2022 16:54:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id w26so582990wmi.0
        for <io-uring@vger.kernel.org>; Sat, 08 Jan 2022 16:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e1MzLQJVHvY42mKSEhh0cGpkqEUvnKwKb5SarZbx47o=;
        b=d4H9M53E+ShvjLtcLh0xF8pzkvbB0GDYM3RPpb3R56iTXILaai2/0PHRv0+pHV/WME
         1b0HY2c835Xl277NIfvI3G1ajQDwunM4jlG8FBSwjHdFDE3H9p1kxv2pd/O3W24BCYhp
         VXX2ZwTOV0eYUsCbI3FPmZSwVK9woUoqJo60OBxSJTempEiKEKTby7nS+vg0CT+CMlp2
         Uwc2TaVDbREtlGDavBe1kU2ziQnLMD9bNruYKnR1gSGAzzbwWFt9YqREYicgYts2S3Qy
         PNRy5iqjMvF+F1Zy5ZOub+m7Gd94ijKkBimmIPgl1Hx2j1ducRsjqRj+8MOWZAw/KU0y
         lNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e1MzLQJVHvY42mKSEhh0cGpkqEUvnKwKb5SarZbx47o=;
        b=UHJUd2IMqA88tJXUOaJ19ryoZG4KWjxrOdvTR6EC9DjPhAMlJFcd2oR7Q1daWr6cHX
         uPvsan6kPTsc+U1kf2jBOyRk7Ua3znVtb130zUM+ZlLgpzXeTk4QKtXA/AscsylmbQzx
         t4+RCtAFz0JEQkolN95zDp56nF5XBidXz1RqyKgs5YbxPlCmOsdG+H8HWPppS5MmWDuk
         FmG2IYNAVIiMIKObpkLURE2quVPeaQ4D31fdHmZk1ELEYyuMygPj311GUvi+xkAy0jb0
         /aKu7NB7d67EG0uA3tZSQbnbgutSyqKQC3WZO3hTLLr+4op/eYy3WF9RTpPKsJKP4ANc
         0eFg==
X-Gm-Message-State: AOAM5332IoYgUJyMIgRImqD18buQiD2MD7MgPzMnwSK+VOeWhtOXemFT
        wjjjQanouDR/FAABhpUiWR/mgU/G28Q=
X-Google-Smtp-Source: ABdhPJyDIeOJ3eZcrXR5bQlCR89IyVcxyDKsvgJyh1nvDwKFmQdbmcUhALj6GGegrntjpCb6MpNfmw==
X-Received: by 2002:a1c:f70f:: with SMTP id v15mr16503922wmh.117.1641689655503;
        Sat, 08 Jan 2022 16:54:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.215])
        by smtp.gmail.com with ESMTPSA id i11sm1922959wrn.59.2022.01.08.16.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 16:54:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH for-next] io_uring: fix not released cached task refs
Date:   Sun,  9 Jan 2022 00:53:22 +0000
Message-Id: <69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tctx_task_work() may get run after io_uring cancellation and so there
will be no one to put cached in tctx task refs that may have been added
back by tw handlers using inline completion infra, Call
io_uring_drop_tctx_refs() at the end of the main tw handler to release
them.

Cc: stable@vger.kernel.org # 5.15+
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aed1625a26e1..684d77c179a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1827,6 +1827,18 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2319,6 +2331,10 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &uring_locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
@@ -9803,18 +9819,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-	unsigned int refs = tctx->cached_refs;
-
-	if (refs) {
-		tctx->cached_refs = 0;
-		percpu_counter_sub(&tctx->inflight, refs);
-		put_task_struct_many(task, refs);
-	}
-}
-
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
@@ -9870,10 +9874,14 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_idle set for normal exit.
+		 */
+		atomic_dec(&tctx->in_idle);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
-- 
2.33.1


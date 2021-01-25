Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99F33033F3
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 06:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbhAZFJx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbhAYMKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:16 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82ECC061225
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:16 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id g10so12058290wrx.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yY8VnMOytCEhEU2aPamccwBTG5bLhhcfUWkfmt6FXWc=;
        b=Oq0trlZsWmNIqG3qZw222P+uBTuGakA2MfPNbQFyQSeNeaOckpZlb9wxlL9oCGR06w
         kE3ioM6DS5dDBylcBi/w5HIMHBtPcXuTYs20u/Z6FDMoMq1XlR1legAwuJTKpvJb8h26
         02vBn6k8iHeY4vCuphS8ic4PFJD8mCNMKocuWhbfTPM+8+7t90IDdBsLk9dc9LdpyfT1
         +JGdtMkbLcq0+kwhuycQ70lmCEAUtaph2TK3EXsu8s/jcRNrarmdrKoiGTC3Bi4Lpcw5
         vWB8HvVOASrXqvPboknHYzCMX7kwp1yKbtbFgaj8oCFn7v7hN3QC3WaZ1FmfiRaB2CG4
         M8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yY8VnMOytCEhEU2aPamccwBTG5bLhhcfUWkfmt6FXWc=;
        b=MPhvOsz7d2LPTphwf2yjC19OJxH2tH1nRQyuYCXNBXK/Z0nqVvxqcQQ9+wvBG/Lptf
         pt1x8hnmf5Pzc9shZgFdnIlwybah/IF540Txi8I/f/a0ixOXW7nQYYEuUBxk9XjHeoWE
         NTbaHTyqJdKAkwmsZgKe3ihIZvUYdhw6cz26p/h6nmrZakerY4l+rrsSAxJod87J5Htc
         BPEiiNnsqxTWaRfmbvnFUgaN40P/CEV/siIsMOqdeV1qGOzINMBPtPonKMTJGTaziGXe
         o8eMBj95KF6ko2M+G5N7/C1dXe9JbPpBVt8GWBogicSEA/rt/NJn/Tw9YgB06B9hZcQj
         vXfw==
X-Gm-Message-State: AOAM5326JI369v/Y7VftzuPo2n5x/cKg4UohXhhcSBOA6l6/MPI5S2fG
        rcvpR/C5YATuuB4Vj0RY5zk76MoUOqM=
X-Google-Smtp-Source: ABdhPJyuQ+AOOf7e129z45z06mtjByhvbv9JkFZ7zEsYIKVZswe671PJ1OnQm5L5fbUnYPlGPKxxIw==
X-Received: by 2002:a5d:6209:: with SMTP id y9mr464078wru.197.1611575175591;
        Mon, 25 Jan 2021 03:46:15 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: consolidate putting reqs task
Date:   Mon, 25 Jan 2021 11:42:21 +0000
Message-Id: <aea8455c4d80fcabde71d28fd78a42c375ebd8ab.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We grab a task for each request and while putting it it also have to do
extra work like inflight accounting and waking up that task. This
sequence is duplicated several time, it's good time to add a helper.
More to that, the helper generates better code due to better locality
and so not failing alias analysis.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8be7b4c6d304..fa421555ab8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2013,17 +2013,22 @@ static void io_dismantle_req(struct io_kiocb *req)
 	io_req_clean_work(req);
 }
 
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	struct io_uring_task *tctx = task->io_uring;
+
+	percpu_counter_sub(&tctx->inflight, nr);
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		wake_up(&tctx->wait);
+	put_task_struct_many(task, nr);
+}
+
 static void __io_free_req(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_dismantle_req(req);
-
-	percpu_counter_dec(&tctx->inflight);
-	if (atomic_read(&tctx->in_idle))
-		wake_up(&tctx->wait);
-	put_task_struct(req->task);
+	io_put_task(req->task, 1);
 
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
@@ -2277,12 +2282,7 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 	if (rb->to_free)
 		__io_req_free_batch_flush(ctx, rb);
 	if (rb->task) {
-		struct io_uring_task *tctx = rb->task->io_uring;
-
-		percpu_counter_sub(&tctx->inflight, rb->task_refs);
-		if (atomic_read(&tctx->in_idle))
-			wake_up(&tctx->wait);
-		put_task_struct_many(rb->task, rb->task_refs);
+		io_put_task(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
 }
@@ -2296,14 +2296,8 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	io_queue_next(req);
 
 	if (req->task != rb->task) {
-		if (rb->task) {
-			struct io_uring_task *tctx = rb->task->io_uring;
-
-			percpu_counter_sub(&tctx->inflight, rb->task_refs);
-			if (atomic_read(&tctx->in_idle))
-				wake_up(&tctx->wait);
-			put_task_struct_many(rb->task, rb->task_refs);
-		}
+		if (rb->task)
+			io_put_task(rb->task, rb->task_refs);
 		rb->task = req->task;
 		rb->task_refs = 0;
 	}
-- 
2.24.0


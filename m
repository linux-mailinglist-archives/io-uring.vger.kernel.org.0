Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F151C1E9104
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 13:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgE3Lzx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 07:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgE3Lzw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 07:55:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6A8C03E969;
        Sat, 30 May 2020 04:55:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r7so6836348wro.1;
        Sat, 30 May 2020 04:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ho6XpTXdZ+UwtVd+7nxuFS4RfwvV6cudDxjtkGw4STM=;
        b=Xe0OZfS2CdRMMDicbQ0YpJ4quDFUv5prkmW3WRBlHKksr8kg3w9UjG1g2A+nb7S2TN
         n3KJzDY9phEZ2bYaGcEJHZXkZoY0Ah2+3/YgdnqyPziTP5/jdj8zdCUQlQyzjC+ZN3Hp
         vfVAErUuj+0jykh0nwvxNi64Env4UJ3fJJJWZH2EKO8coAV+KyUTXRLSY74hPbQHjMVu
         3JjfWWfBqO7UwU/EdPOS5G1vC5shnBHoaFfbLPMvktV9YUnKUi0Pr/+CqpwyCaAkAkPf
         eVnfL2zK90nlUhmbM/yYKh153tXCuQdEYHnHyb3dh8TBQaGFKKfO3a0rgQkVeOGYHW8A
         eizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ho6XpTXdZ+UwtVd+7nxuFS4RfwvV6cudDxjtkGw4STM=;
        b=Ija7+5f/34w47PDfU3+Mv37trKMft1HQQXJSC97SbA6fr3L0E17/0AoouHW+/uttS/
         lYgo+DEfj8Gk4G7whNtkCseTrqgdBOqldpv4yKo5crV17UIdl4Tc31toDowONIc7cCpu
         gtKYsb1VVyPJCvU8Rueba4cNoXEj6PseT1xgSeiTcMsKmNoundMBTEI60TGtL+cVL8Tg
         QloKJgcuhNKfw0Q6QdU2ggVuVkDlCwqO1ceat5IgoU7SnJhMIdkkyKRMtIck6w2Yn2iY
         6/+Qn8AbAUGO+N1gvedA4hrzrfMx7f1ajXeHaD6odhcyrRFvgSDhaZ8ZbWVn+v1FhRup
         8yMg==
X-Gm-Message-State: AOAM531CSjwTuccltnul8rpZcF7xDBzsiXBunI24kreTmFeNn326dVAm
        WO8XU5X2g149fU/KLY4UH4s=
X-Google-Smtp-Source: ABdhPJw4FwmCKzcVZS2Jn+zV/y2Rh3YcdEnkPmTspVjAWZkupq5EMwHK+va3/V6C65rfk+vraFf7tA==
X-Received: by 2002:adf:df03:: with SMTP id y3mr12591578wrl.376.1590839750539;
        Sat, 30 May 2020 04:55:50 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l18sm3405332wmj.22.2020.05.30.04.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:55:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] io_uring: off timeouts based only on completions
Date:   Sat, 30 May 2020 14:54:18 +0300
Message-Id: <e6a5d53be008d0b1fd4e2bdba53a5e78397e275e.1590839530.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590839530.git.asml.silence@gmail.com>
References: <cover.1590839530.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Offset timeouts wait not for sqe->off non-timeout CQEs, but rather
sqe->off + number of prior inflight requests. Wait exactly for
sqe->off non-timeout completions

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 65 +++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0975cd8ddcb7..732ec73ec3c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -394,7 +394,8 @@ struct io_timeout {
 	struct file			*file;
 	u64				addr;
 	int				flags;
-	u32				count;
+	u32				off;
+	u32				target_seq;
 };
 
 struct io_rw {
@@ -1124,8 +1125,10 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			break;
-		if (__req_need_defer(req))
+		if (req->timeout.target_seq != ctx->cached_cq_tail
+					- atomic_read(&ctx->cq_timeouts))
 			break;
+
 		list_del_init(&req->list);
 		io_kill_timeout(req);
 	}
@@ -4660,20 +4663,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
 	 */
-	if (!list_empty(&req->list)) {
-		struct io_kiocb *prev;
-
-		/*
-		 * Adjust the reqs sequence before the current one because it
-		 * will consume a slot in the cq_ring and the cq_tail
-		 * pointer will be increased, otherwise other timeout reqs may
-		 * return in advance without waiting for enough wait_nr.
-		 */
-		prev = req;
-		list_for_each_entry_continue_reverse(prev, &ctx->timeout_list, list)
-			prev->sequence++;
+	if (!list_empty(&req->list))
 		list_del_init(&req->list);
-	}
 
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
@@ -4765,7 +4756,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
-	req->timeout.count = off;
+	req->timeout.off = off;
 
 	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;
@@ -4789,13 +4780,10 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static int io_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_timeout_data *data;
+	struct io_timeout_data *data = &req->io->timeout;
 	struct list_head *entry;
-	unsigned span = 0;
-	u32 count = req->timeout.count;
-	u32 seq = req->sequence;
+	u32 tail, off = req->timeout.off;
 
-	data = &req->io->timeout;
 	spin_lock_irq(&ctx->completion_lock);
 
 	/*
@@ -4803,13 +4791,14 @@ static int io_timeout(struct io_kiocb *req)
 	 * timeout event to be satisfied. If it isn't set, then this is
 	 * a pure timeout request, sequence isn't used.
 	 */
-	if (!count) {
+	if (!off) {
 		req->flags |= REQ_F_TIMEOUT_NOSEQ;
 		entry = ctx->timeout_list.prev;
 		goto add;
 	}
 
-	req->sequence = seq + count;
+	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	req->timeout.target_seq = tail + off;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -4817,39 +4806,13 @@ static int io_timeout(struct io_kiocb *req)
 	 */
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
-		unsigned nxt_seq;
-		long long tmp, tmp_nxt;
-		u32 nxt_offset = nxt->timeout.count;
 
 		if (nxt->flags & REQ_F_TIMEOUT_NOSEQ)
 			continue;
-
-		/*
-		 * Since seq + count can overflow, use type long
-		 * long to store it.
-		 */
-		tmp = (long long)seq + count;
-		nxt_seq = nxt->sequence - nxt_offset;
-		tmp_nxt = (long long)nxt_seq + nxt_offset;
-
-		/*
-		 * cached_sq_head may overflow, and it will never overflow twice
-		 * once there is some timeout req still be valid.
-		 */
-		if (seq < nxt_seq)
-			tmp += UINT_MAX;
-
-		if (tmp > tmp_nxt)
+		/* nxt.seq is behind @tail, otherwise would've been completed */
+		if (off >= nxt->timeout.target_seq - tail)
 			break;
-
-		/*
-		 * Sequence of reqs after the insert one and itself should
-		 * be adjusted because each timeout req consumes a slot.
-		 */
-		span++;
-		nxt->sequence++;
 	}
-	req->sequence -= span;
 add:
 	list_add(&req->list, entry);
 	data->timer.function = io_timeout_fn;
-- 
2.24.0


Return-Path: <io-uring+bounces-4583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC6D9C32F4
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 15:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068091F212D0
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC451C28E;
	Sun, 10 Nov 2024 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZcsn0Y2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560B3B298
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731250546; cv=none; b=q1qDBLlGcOK80WmTzUgs3NDp1YU1Hi2eAaCM/MldsyOQ+DLiSuOqyKgTzYEfqN7stk7xDg+eU9P3eEFHR0d0MTNk4qRv3jbU3eSgyHPVSLEX82YXakW5oEQnbuiv1wDi8c51/L3un8e6R6hQpsw4fPSnzYejv6fMAf1ajxGQ6Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731250546; c=relaxed/simple;
	bh=gzBlB2S9hWxCZWyz5YLoZ43Ubwbn8Hm9jMNBwg1G+MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW/vHhJoeZPIrK8xn6FHRiizU17Pz4bYs1cA7rP6T9z9JRDyKIsuKdrfccliFiNxObvQBqaqvpg81xGbDDz3ABx69f64tMZ8b7VzEBMyfaITiNHoPqdtgF13xYr0bXAYp8GgzauYgLsuMCZ78pGkO8LNjg9YEdjpSbTijL28EPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZcsn0Y2; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d462c91a9so2302370f8f.2
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 06:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731250542; x=1731855342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8zV3Xxbm1BmP6KeJIic2z/32D6ufKuQ8hf49CeI9RI=;
        b=SZcsn0Y2LORrndAB7MMhw9E7z79fxBEGedYO7qekBz9rZEJsL0pZhxrTrWWrISvMfU
         O6BShYVZKb95PDufl1+PbSRdOfLK3UY9JuGGUCQuMbjUD4N2Yxwycjz8wV6YzMHQXeJC
         IMKEY/QqOKSIHGNebXnsNNYCgUy2ba0N7lt3GII2AemUclAyDZCVHm/St6Dl5wS6CLAQ
         VKjHfnpYhnF4bZT92yEObax/aP4dZTVgG3LG7JAjCBK6ES44lgNa7lwhW2lAQKiK9xjc
         WFtWW/efo0XrYSd/QTxuFDjOGYmSO97deRJQYyUsanuZCJHrz1TiBLWbc2GJCIwlTjPE
         T/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731250542; x=1731855342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8zV3Xxbm1BmP6KeJIic2z/32D6ufKuQ8hf49CeI9RI=;
        b=MWj2QtQZhRYJfPYwsiSLkPg4Fas62oJVBBRYvFYfQZQiO4FNtRgMgUNyLRtfJ1ImPz
         dO+7NqpnM2826wjU3+VWWth5wNm5VEnw/kuHGs9/ibIp4q/sBcBcA8f6xn11m64pzhpk
         UpYGRUyyAoJWhzBBtvQ7QhEPqxYhxxpaDFa02C/FtHQ9Asjy0T/PRsLc+tbFFhs6Ewpn
         hYBBqPpRvF4zvIjRPwBC427a8zWLTXNBGi/OM9kRedZSNnpO7TppBE7O3xF7rAtv1QLO
         PMjhUvYWXD4EXoepZGEyRjCv6VWbMlSzcwc/esf8QbFtKfbcPX6V6g74JzNoJAa5JRQo
         8MuQ==
X-Gm-Message-State: AOJu0Ywo6taJ2d6V3R2BrnHJJiOldL5PC73R2BUzhQUzxScRkpy3d8+D
	JkumG/AeqMKzxEr5U9e0s5pGveqJyngz60v6XEga2TwHkBEpvFJjkKY90Q==
X-Google-Smtp-Source: AGHT+IGPdSvV5L+oA8X5syO1/CqS/TBDiMp9fp9O6fpLei48ElAJy1BbZzWdi/GrnF5w4sp6JuCaDw==
X-Received: by 2002:a05:6000:481b:b0:374:c614:73df with SMTP id ffacd0b85a97d-381f1852a83mr7685838f8f.57.1731250542082;
        Sun, 10 Nov 2024 06:55:42 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6beea6sm182445535e9.20.2024.11.10.06.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 06:55:41 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 3/3] io_uring: allow waiting loop to ignore some CQEs
Date: Sun, 10 Nov 2024 14:56:22 +0000
Message-ID: <a15bb014ecc67b004c2bd2283758c5ab3987e54a.1731205010.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731205010.git.asml.silence@gmail.com>
References: <cover.1731205010.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The user might not care about getting results of certain request, but
there will still wake up the task (i.e. task_work) and trigger the
waiting loop to terminate.

IOSQE_SET_F_HINT_SILENT attempts to de-priorities such completions.
The completion will be eventually posted, however the execution of the
request can and likely will be delayed to batch it with other requests.

It's an incomplete prototype, it only works with DEFER_TASKRUN, fails to
apply the optimisation for task_works queued before the waiting loop
starts, and interaction with IOSQE_SET_F_HINT_IGNORE_INLINE is likely
broken.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           | 43 +++++++++++++++++++++++------------
 io_uring/register.c           |  3 ++-
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e6d10fba8ae2..6dff0ee4e20c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -901,6 +901,7 @@ struct io_uring_recvmsg_out {
 
 enum {
 	IOSQE_SET_F_HINT_IGNORE_INLINE		= 1,
+	IOSQE_SET_F_HINT_SILENT			= 2,
 };
 
 struct io_uring_ioset_reg {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6e89435c243d..2e1af10fd4f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1270,6 +1270,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 {
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
+	bool ignore = req->ioset->flags & IOSQE_SET_F_HINT_SILENT;
 
 	/* See comment above IO_CQ_WAKE_INIT */
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
@@ -1297,13 +1298,17 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 			nr_tw_prev = READ_ONCE(first_req->nr_tw);
 		}
 
-		/*
-		 * Theoretically, it can overflow, but that's fine as one of
-		 * previous adds should've tried to wake the task.
-		 */
-		nr_tw = nr_tw_prev + 1;
-		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = IO_CQ_WAKE_FORCE;
+		nr_tw = nr_tw_prev;
+
+		if (!ignore) {
+			/*
+			 * Theoretically, it can overflow, but that's fine as
+			 * one of previous adds should've tried to wake the task.
+			 */
+			nr_tw += 1;
+			if (!(flags & IOU_F_TWQ_LAZY_WAKE))
+				nr_tw = IO_CQ_WAKE_FORCE;
+		}
 
 		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = head;
@@ -1325,6 +1330,9 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 			io_eventfd_signal(ctx);
 	}
 
+	if (ignore)
+		return;
+
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
 	/* not enough or no one is waiting */
 	if (nr_tw < nr_wait)
@@ -1405,7 +1413,7 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 }
 
 static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
-			       int min_events)
+			       int min_events, struct io_wait_queue *waitq)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
@@ -1425,6 +1433,10 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
+
+		if (req->ioset->flags & IOSQE_SET_F_HINT_SILENT)
+			waitq->cq_tail++;
+
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				req, ts);
@@ -1450,16 +1462,17 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 
 	if (llist_empty(&ctx->work_llist))
 		return 0;
-	return __io_run_local_work(ctx, &ts, min_events);
+	return __io_run_local_work(ctx, &ts, min_events, NULL);
 }
 
-static int io_run_local_work(struct io_ring_ctx *ctx, int min_events)
+static int io_run_local_work(struct io_ring_ctx *ctx, int min_events,
+			      struct io_wait_queue *waitq)
 {
 	struct io_tw_state ts = {};
 	int ret;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_run_local_work(ctx, &ts, min_events);
+	ret = __io_run_local_work(ctx, &ts, min_events, waitq);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
@@ -2643,7 +2656,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
 	if (!llist_empty(&ctx->work_llist)) {
 		__set_current_state(TASK_RUNNING);
-		if (io_run_local_work(ctx, INT_MAX) > 0)
+		if (io_run_local_work(ctx, INT_MAX, NULL) > 0)
 			return 0;
 	}
 	if (io_run_task_work() > 0)
@@ -2806,7 +2819,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 	if (!llist_empty(&ctx->work_llist))
-		io_run_local_work(ctx, min_events);
+		io_run_local_work(ctx, min_events, NULL);
 	io_run_task_work();
 
 	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
@@ -2877,7 +2890,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		 * now rather than let the caller do another wait loop.
 		 */
 		if (!llist_empty(&ctx->work_llist))
-			io_run_local_work(ctx, nr_wait);
+			io_run_local_work(ctx, nr_wait, &iowq);
 		io_run_task_work();
 
 		/*
@@ -3389,7 +3402,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
-		ret |= io_run_local_work(ctx, INT_MAX) > 0;
+		ret |= io_run_local_work(ctx, INT_MAX, NULL) > 0;
 	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
diff --git a/io_uring/register.c b/io_uring/register.c
index f87ec7b773bd..5462c49bebd3 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -92,7 +92,8 @@ static int io_update_ioset(struct io_ring_ctx *ctx,
 {
 	if (!(ctx->flags & IORING_SETUP_IOSET))
 		return -EINVAL;
-	if (reg->flags & ~IOSQE_SET_F_HINT_IGNORE_INLINE)
+	if (reg->flags & ~(IOSQE_SET_F_HINT_IGNORE_INLINE |
+			   IOSQE_SET_F_HINT_SILENT))
 		return -EINVAL;
 	if (reg->__resv[0] || reg->__resv[1] || reg->__resv[2])
 		return -EINVAL;
-- 
2.46.0



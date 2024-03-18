Return-Path: <io-uring+bounces-1072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A64387E15A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F8D428325A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC76F21350;
	Mon, 18 Mar 2024 00:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JB/84Zok"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16A820DD0;
	Mon, 18 Mar 2024 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722633; cv=none; b=APMqoIba7xKpdTDlnrjiYVAMQVjPh2123v+OvUr3/lTNVcFp024T/HBVAKJdrJhkzd3cYiPx31xwete5MbEaDIcseban4OTb0nM3hhl2E5OQjPkCsPzpPx93BiFe2k83Cdr+SpoXpEy+ops6q6mC9Q6PsqiUyguhfBAafr7gkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722633; c=relaxed/simple;
	bh=NM6gv/o9UF/VHTQExPt8kQq8ePNaVU2X1jg4KWfWkLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5zhOP/xoFfUQWleTtIDWaztTeIA8inFcZGhQn7y/BaZQdtyh7Sy44Y/k7+3lrQiXkUkyssg6aX7NhxRRH8KHRcEKHaVagQq8PwPjnjbDE/uRBJWoZAKgs7yG4V7LLwjqEPIfWpT3XpNfbCQmJUCY+MXolO5w8urTeSA5JKWBQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JB/84Zok; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56840d872aeso3407861a12.0;
        Sun, 17 Mar 2024 17:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722630; x=1711327430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6AXZxC8m1pgrrNg/yyM/YZEKwCJeLeCZY1gTFaZL+4=;
        b=JB/84Zokz628Th5Z05nk3UiXFARy0zZw69ugYNpImWBk43mld06OwlWijsFkrE9Xf1
         EzbJTjho/GQmEvz/dhC0pkUE8hdMLmZ5ccQQBI69fHkIAh7TznWZvhgOcEkDNB1DhnTu
         HdtU6tIeNJMFsu8F96FATHzMnPUwNqfu7stk1DXpT7b0h67nlW415tg5pRvMJ9iG3no/
         ZFR56s49UUefn+9856pFIBFDQJltT3GLgD2cK+oIB4Vn4HUAzPCfq5jGYHcq0Zu9WoD2
         8ixp1uZ9T3/dPbide8pxPSpaHsEpEKQ8HqEFNBJksY8CXaW3Hll624NCab1R+evY8bfJ
         rVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722630; x=1711327430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6AXZxC8m1pgrrNg/yyM/YZEKwCJeLeCZY1gTFaZL+4=;
        b=uBUQL41Mu0XwmWxMaRjrPQeKioLAr3ZYfNNxjZPAWIW4y/Q8Oa7p4QPxGYCUU+A1Jd
         uBaRuVOaooWehrVFM84OShCAeoyJea64xrhYpcFa43NZ39vVyDCZ3vxhR2zcAfk7VGFi
         4lYwayX3t651iRsjWeugMvqDkaahJa4klZ9ScwAg3FisxQGiIGJ/xTYn9QoUnF7mvYyA
         Fh4VY6j7PWlu/k4f6/5DVvRLmn4KnAP6DQ4sa24SnOb7BdzboIhGK3Dbe+aJyhstNFal
         tLaiz26gwiHx2wMmkNM0MlUbcn1/TNYNqkg5+Wj2Q/+1VDRN3CjGIw6U9JiPLLCY9ng5
         0Kww==
X-Gm-Message-State: AOJu0YzCfvKyu2GrxFlQx6knX23tAdbwsRwdpzNY86zWucDec8W0+j65
	d415kkyogdTSMRiDeJyjFfjO1XyOlabjgeTi1zRUIdO19KCQPdx2EdPqZ7gy
X-Google-Smtp-Source: AGHT+IEvjoOsStRKdKyACweecEAcBNvOD2LAaL8zDYHFV6kdWGoSyS2vgteQuv11dwX/exxHXR9RKA==
X-Received: by 2002:a05:6402:5d0:b0:565:6e34:da30 with SMTP id n16-20020a05640205d000b005656e34da30mr5331650edx.21.1710722629665;
        Sun, 17 Mar 2024 17:43:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 10/14] io_uring: refactor io_fill_cqe_req_aux
Date: Mon, 18 Mar 2024 00:41:55 +0000
Message-ID: <df810b740b7dbf4ddbc20d97527532c0331f553d.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The restriction on multishot execution context disallowing io-wq is
driven by rules of io_fill_cqe_req_aux(), it should only be called in
the master task context, either from the syscall path or in task_work.
Since task_work now always takes the ctx lock implying
IO_URING_F_COMPLETE_DEFER, we can just assume that the function is
always called with its defer argument set to true.

Kill the argument. Also rename the function for more consistency as
"fill" in CQE related functions was usually meant for raw interfaces
only copying data into the CQ without any locking, waking the user
and other accounting "post" functions take care of.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/777fb7fbd2a3ba526a876fc422288c5f65283f12.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 16 +++-------------
 io_uring/io_uring.h |  2 +-
 io_uring/net.c      |  6 ++----
 io_uring/poll.c     |  3 +--
 io_uring/rw.c       |  4 +---
 io_uring/timeout.c  |  2 +-
 6 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ef089f6367ea..30542dda1473 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -913,40 +913,30 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
 	state->cqes_count = 0;
 }
 
-static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
-			      bool allow_overflow)
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
 
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
-	if (!filled && allow_overflow)
+	if (!filled)
 		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 
 	io_cq_unlock_post(ctx);
 	return filled;
 }
 
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
-{
-	return __io_post_aux_cqe(ctx, user_data, res, cflags, true);
-}
-
 /*
  * A helper for multishot requests posting additional CQEs.
  * Should only be used from a task_work including IO_URING_F_MULTISHOT.
  */
-bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
+bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	u64 user_data = req->cqe.user_data;
 	struct io_uring_cqe *cqe;
 
 	lockdep_assert(!io_wq_current_is_worker());
-
-	if (!defer)
-		return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
-
 	lockdep_assert_held(&ctx->uring_lock);
 
 	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6cad3ef3408b..4bc96470e591 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -67,7 +67,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags);
+bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
diff --git a/io_uring/net.c b/io_uring/net.c
index 1e7665ff6ef7..ed798e185bbf 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -706,8 +706,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	 * receive from this socket.
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
-	    io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-				*ret, cflags | IORING_CQE_F_MORE)) {
+	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
@@ -1428,8 +1427,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < 0)
 		return ret;
-	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-				ret, IORING_CQE_F_MORE))
+	if (io_req_post_cqe(req, ret, IORING_CQE_F_MORE))
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8901dd118e50..5d55bbf1de15 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -322,8 +322,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_fill_cqe_req_aux(req, true, mask,
-						 IORING_CQE_F_MORE)) {
+			if (!io_req_post_cqe(req, mask, IORING_CQE_F_MORE)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c7f9246ff508..35216e8adc29 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -955,9 +955,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		cflags = io_put_kbuf(req, issue_flags);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
-		if (io_fill_cqe_req_aux(req,
-					issue_flags & IO_URING_F_COMPLETE_DEFER,
-					ret, cflags | IORING_CQE_F_MORE)) {
+		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
 			if (issue_flags & IO_URING_F_MULTISHOT) {
 				/*
 				 * Force retry, as we might have more data to
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 0a48e6acd0b2..3458ca550b83 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -72,7 +72,7 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
-		if (io_fill_cqe_req_aux(req, true, -ETIME, IORING_CQE_F_MORE)) {
+		if (io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-- 
2.44.0



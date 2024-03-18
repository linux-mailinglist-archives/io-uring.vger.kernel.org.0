Return-Path: <io-uring+bounces-1123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C984A87F2D9
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA5EE1C2138A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6759659B79;
	Mon, 18 Mar 2024 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1SgDkc8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8325A79D;
	Mon, 18 Mar 2024 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799345; cv=none; b=tkQ3iPzPIOvAY2wVH0MNW9mlwDMBpecgp7w18gwvHoo3hreFC3CL9govTrbM0IJDPtXEVuWsTHa9VfAB5RbPY5kMeuszJU9TUZeGh+1pVjtapfuQY4WrgQqsKagcMz+/0Mzc/iqaoNTOjtPGeXAsxvXxPEtoSHOtYVTPcL0o3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799345; c=relaxed/simple;
	bh=7VqekwisfeZVEBvPctdmASLNCv3mAxskHtDDVKJbF80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urvZjJR46Pzq5Gr0mA3f0rWdF+GxYJ4v3w9We5aQLWpLtb9UtAPE1PGPoqygn3PvuztIjB8UhtNfyLX0ZHTpQp9R/yaaTnAF3zp6y3RJ2oIuBrvGXkMFoMcxa00U9cIPSZlMBlkCzF/mtyARFyYUcgE/JAMQOCnb2UQBky1+qy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1SgDkc8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4141156f245so9533615e9.2;
        Mon, 18 Mar 2024 15:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799341; x=1711404141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgD3bsMP0S2gpC+HqO1lBHKa+Q6P0EutKXjfqR3KaNY=;
        b=J1SgDkc82kXlx2h5Eo5I/ECWZXUPqNNPzwhQPeT3K4Vezt41VC9E5KNQp2K6TETi9j
         FvpNcS1z9CeXIcLdlMq+/b8jGTzJEu9TYD6cYe+vADzlFZX/sPDBGdvtXRTtjudUEC36
         uH+rdkLf+WlEB1NEX3PpFCcpCPBmSKVJdrXkSGtDnyvtZJr36F7UkxRfobfjHfNwfstN
         FS3eJt8MPneZ+h1x5WV4Wjjdq60miOl5opeXfA5fIfTDJqsc98y+vix0bxmDxw7x4Y/A
         ZsH2Vuij/3XMVhtGW5zJWijC03xonlo+oUNKC/tay4WSP+DkbYFAUoXLIbxeVdgs6Taa
         wb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799341; x=1711404141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgD3bsMP0S2gpC+HqO1lBHKa+Q6P0EutKXjfqR3KaNY=;
        b=P+r+2Zc3hOKG54s0+C7IlQ3qK0JxTZtLptq7550Xwppt1uQ8Mp7pRuLpriz80zR09r
         4mzxqPJUv6tlKCIOcIgjvKFLUW4JALODgHtj77Xp6FtgiJgbzkPmQWiK7ba5taV5gU3N
         q/ATwD+R363aPFNELHmnlx8lALuifFGxcRv9XdkEg5877025LD6CrT/C1t2MV+Qx/SV2
         e0BmAYRDbOmzj7dj1n1f8FhWiBXf8hlrgjmtiUTglrMyDuV1AYXIN+NFH0Jsewi8Wxia
         fdbYPW7j963ltD8D4O9UibjOWagt+l202i2c0AaaFsmXtXddcZJyLKaC9kwQ7OtdiqWm
         VEnQ==
X-Gm-Message-State: AOJu0YzpCk255uQoW9jPg16Bi48rV7Dzk8esAv4vOqf2XfOOKHHTLTSD
	W2Lru3Nh5ak3cMjUy9nQVHzCI0CaS6hr1wQtdeiCSMlLytR965m4OtHIevhz
X-Google-Smtp-Source: AGHT+IGpVFNIVG/JdV3D5UBVImz15cictZpMO91uVMKgkFVvNoy6LrrsbNNbbrj9PXZ41KJgK/ZOMw==
X-Received: by 2002:a5d:4d82:0:b0:33e:c7e3:9024 with SMTP id b2-20020a5d4d82000000b0033ec7e39024mr8761668wru.58.1710799341471;
        Mon, 18 Mar 2024 15:02:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 09/13] io_uring: refactor io_fill_cqe_req_aux
Date: Mon, 18 Mar 2024 22:00:31 +0000
Message-ID: <93423d106c33116c7d06bf277f651aa68b427328.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
---
 io_uring/io_uring.c | 16 +++-------------
 io_uring/io_uring.h |  2 +-
 io_uring/net.c      |  6 ++----
 io_uring/poll.c     |  3 +--
 io_uring/rw.c       |  4 +---
 io_uring/timeout.c  |  2 +-
 6 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9e8afc006fc9..9a4cc46582b2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -907,40 +907,30 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
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
index 7f921daae9c3..460290e1bdec 100644
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



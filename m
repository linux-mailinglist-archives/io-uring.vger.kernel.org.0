Return-Path: <io-uring+bounces-962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E000087D05A
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C231F2127E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8523E498;
	Fri, 15 Mar 2024 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cr71W45h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA1641236;
	Fri, 15 Mar 2024 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516684; cv=none; b=bAoaZt1e66REgiikB5FX4vm6z11Ox1HaSXvpQt1hkbY7B1ArCI25i5a+taUYGixgcaZkXt8W6aGyKMpWwYkWTYn38nRQ1H3y2lBkVvvWEb8NI6sY6V7Qyu85bPGfgwJMYDK5oLnFgj+ZGVx0e3gpJsbmhR3OCeeB2WqvkTjG7GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516684; c=relaxed/simple;
	bh=EHG9bGiSWjV6Of0fB0gBLFd05b0oTLSBkIQD9NicUNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHoN9cIBzWN/mV3b+9rrWULHgAB25Pm+QPQK3UYYEnFwV0RDIMuQjnBoVasqqWw0eki89o33kDy3oiyP+zX9AZOwbUWqnDieXD32bQnL1HKPHDqTn+vmo9de1AiqCh5D8A4Uj+G37qsZTdXOOPTHZp1++6IjUd/oHvn/YWv3N9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cr71W45h; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512e39226efso2154833e87.0;
        Fri, 15 Mar 2024 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516681; x=1711121481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrsISQ+DEwoL0WD2x8rUh3mvSFRhgV8vcD0vdmOMI8Q=;
        b=cr71W45hoSQPPI7C32pWg0Mm/yF77m7re5oCpSqw7rvKKjbk/nMFEPh2KxXwXm85Ig
         p0JPJ5CKwJ6KkM9ZSh23Dj8SDhuhmNZn4THNJqHvIgQIoPW6snoczVNDHFHcCbbBjOLM
         n9oFcy96mhjX6sMD5uukfg77+HxzQoA88XlFJhGYLu8IyAu0jTK/1ehW1zHQKY3HlZJ9
         7NxNP24zzOlzM8HW/GZ568Hjw2RHD5zvZOfQZwnEtu5AcWvdTPCXYL2uScty2dlCb9Q4
         i44izMFQZCKD77QC6GHvlEekiSBKW1tTkVvfG7PIbM9RBmHrXZluqJWC7W9T3v7MFmjg
         O9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516681; x=1711121481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrsISQ+DEwoL0WD2x8rUh3mvSFRhgV8vcD0vdmOMI8Q=;
        b=XhcA6zRldH218fhtJgUcN7ylq8dTrwyMXoaDMlIzwhAUu1SbqzpqWe7X3fOJlixS+V
         2uOJVsiNO6pW/aFilPuBVwwumpz7Z+brVVkHZA3U5szhOCrFDqW07WUje/diX+EzM97v
         a+NmQUHqG6RdedFZIG3Nj2+dl9rf0by+PuStqjETz0jRtPZylXTIOyilLWpUkpZJoCmV
         5JvD2A+Z/166kzap46rPoPakJ5gnfEN62YBg2BNXZtTj/Tu8RoHW4F2AzWxf1Bm1fB9k
         a9qh8ykPCVD9D8Y4cBLz/6v92WMIwqBPr2ZcUPE15WV3ves9AnCMCXzxxAzE0cFJ3bfS
         s+GQ==
X-Gm-Message-State: AOJu0Yy7m0bNLcLtsVkdnjDpjaFHoRpmjjazjC22pZmStfGOl6DqGsJH
	2+H0xKj5ITOPn001hK7RG6/1mwDi0rcNJL1eg0gfUCnMPiL0Nlfg1ZfGH6M1
X-Google-Smtp-Source: AGHT+IE63B1JvzA/d9wOCVO4Ny+trUpkfhDlLpCm8caS5IovYC48fnKiXokWIqjRLR+C/TIKgp4jOQ==
X-Received: by 2002:ac2:5b10:0:b0:513:dd66:d5ed with SMTP id v16-20020ac25b10000000b00513dd66d5edmr595907lfn.29.1710516680653;
        Fri, 15 Mar 2024 08:31:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 10/11] io_uring: refactor io_fill_cqe_req_aux
Date: Fri, 15 Mar 2024 15:30:00 +0000
Message-ID: <777fb7fbd2a3ba526a876fc422288c5f65283f12.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
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
index 1c4bbfc411d1..167a3429a056 100644
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
index 19451f0dbf81..b2890eeea6a8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -699,8 +699,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	 * receive from this socket.
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
-	    io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-				*ret, cflags | IORING_CQE_F_MORE)) {
+	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
@@ -1421,8 +1420,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
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
2.43.0



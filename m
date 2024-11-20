Return-Path: <io-uring+bounces-4885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3969D43D7
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C6471F22B43
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 22:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B171BC9F7;
	Wed, 20 Nov 2024 22:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="bqqiJkL6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904B1802DD
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732140898; cv=none; b=BLnuf+Mxja4wcp0gJ8GbPhNM7MT7wg/tLQ7ii9zIyq6Wlqia3stmon8K51A544na95lK9Kw3hriCNdVo+Rg1/x3X7cvPNTsqo1NZzc2T+aCulr6TditaVal3GQ6eTD2ov9F7CBCQLvgXT7LJ7IerQdyfFhZC1gQwkLyUFoQ0aE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732140898; c=relaxed/simple;
	bh=YGPGFiFWDBXHdtj/i1vaxr1Yts6u74gPz2TFtBG06Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB92sXCDvSbhgFQT1610Efw0BKNolxHENbSMb/j1oC48ZImAjQesFoKm2bDe1jtjDB5xHYkdqUnRupui7GuQCxxh7KXWee+Xsu5egCDEnZxZxSEKzsb2RyKQbJLxAZrUxkYbuwTVJaTsFushVgli+hHAyWxOk2JSp+4xXuMB9wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=bqqiJkL6; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7f71f2b136eso250606a12.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 14:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1732140896; x=1732745696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzbyVcjfNk/Lt/lVuCnnDLI2/P5nIpS8qvfpCpAujlI=;
        b=bqqiJkL6N5DZKto9TeOThrs+OQCS+ReLMJFeFH/s9eS9/LzTcEAuQxmEbXSNeSRVEQ
         FsOXFcecT7aQOpDaFg3HI7WMnJn7BdihOIIkBaD9mGxDifVkHKVwwuGQW/TVnzjVb6mB
         WZV11ANPTBy88AlCRUQ8yXWjLSQ/ibuZxGAmymgF+7FQEW4k7oayLfOXE+WZSA29iwUR
         hSFwTY18P+ndl0mWR9KAhOTe3m8B+qfaCD5NbTEtOHYhgcI0O9uKgHPZ4eS3igAboKIQ
         k/If3S6Y8ofxqdJFuHSdbvGBFdrqITVsIcrD81+BWked5Ar+/YY982KIuq7dtJxe38dE
         x7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732140896; x=1732745696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzbyVcjfNk/Lt/lVuCnnDLI2/P5nIpS8qvfpCpAujlI=;
        b=gu5Rlc09Cc7mhVJiVRp4ODq0M1XFPb0ThQYDQ2/+opYWFwo/4VCcNQ07eMXTa0z0kv
         hgqWZfI0UHHOLR4blCXkiev4ku/thE0Rdk6LAKqIQ4JCBYuvm9s4MjKrzQX6xfkxcX2r
         pdwINoExQ+c3uZdRHGHGt/HoshWpY+H87kZpk1wsDzeYoKEu+5JeQr6AmFqNTBPPQo7i
         gRYysa4rHE6SAHn50iGen7rCsN3Wyx8beu46mXqByRtxxI7Ys9y0DyBiVcT6ZRSUqzTC
         7gmkxpyi7EqYs/QpDSWLC/FWVHFpbsYEvPGCCHqOS6hCr+Qt8fISUT+dGmllhYCRG7AL
         b1HQ==
X-Gm-Message-State: AOJu0Yx01Of7VYbHXbJCDbh8igSMySuVYd0qJ6XQYrhMHn6+OUeQbjA5
	UAn5dArkYLJ7hGVk3obOI/khu2Wcab+T1cEpmNfzylVe1jhuyTEjWqQb9iiLoeEIaKtyth0HCzy
	3
X-Gm-Gg: ASbGnctYeq2TxAOaif5p1pmue37DCWn41mKrz70xQymlBM0tEsq/WKo4GcX8Sa02sH2
	Njy5NIQm8hikd9IoWKvXkp0Yd2Q96gILMMiONPugArmNf+WdiGvdogwoXMovA4MFawQmQFR4ZHP
	6MSAGuhEEM4dPswYfUD9q0fbyHC90udOb7u2w8+5awR1xRrO9UQz1hQWQkw+T99T4D2CVNp58UH
	1MbUaHL66/Wz13NpxFqlyu1ftzZl/Wx7MM=
X-Google-Smtp-Source: AGHT+IHMUhyai68xmG0fuZqSh/jxTZ8RvFEfg2NbowwfIYjw+QnouQSyXmaIiAXVZYb/2nrEwraDfQ==
X-Received: by 2002:a05:6a20:4305:b0:1dc:792f:d27c with SMTP id adf61e73a8af0-1ddb0338a82mr5176093637.42.1732140895788;
        Wed, 20 Nov 2024 14:14:55 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbb64f5514sm50719a12.34.2024.11.20.14.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 14:14:55 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH next v1 1/2] io_uring: add io_local_work_pending()
Date: Wed, 20 Nov 2024 14:14:51 -0800
Message-ID: <20241120221452.3762588-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241120221452.3762588-1-dw@davidwei.uk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding a new llist of tw to retry due to hitting the
tw limit, add a helper io_local_work_pending(). This function returns
true if there is any local tw pending. For now it only checks
ctx->work_llist.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/io_uring.c | 14 +++++++-------
 io_uring/io_uring.h |  9 +++++++--
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 801293399883..83bf041d2648 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1260,7 +1260,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 				       int min_events)
 {
-	if (llist_empty(&ctx->work_llist))
+	if (!io_local_work_pending(ctx))
 		return false;
 	if (events < min_events)
 		return true;
@@ -1313,7 +1313,7 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 {
 	struct io_tw_state ts = {};
 
-	if (llist_empty(&ctx->work_llist))
+	if (!io_local_work_pending(ctx))
 		return 0;
 	return __io_run_local_work(ctx, &ts, min_events);
 }
@@ -2328,7 +2328,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (!llist_empty(&ctx->work_llist)) {
+	if (io_local_work_pending(ctx)) {
 		__set_current_state(TASK_RUNNING);
 		if (io_run_local_work(ctx, INT_MAX) > 0)
 			return 0;
@@ -2459,7 +2459,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
-	if (unlikely(!llist_empty(&ctx->work_llist)))
+	if (unlikely(io_local_work_pending(ctx)))
 		return 1;
 	if (unlikely(task_work_pending(current)))
 		return 1;
@@ -2493,7 +2493,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-	if (!llist_empty(&ctx->work_llist))
+	if (io_local_work_pending(ctx))
 		io_run_local_work(ctx, min_events);
 	io_run_task_work();
 
@@ -2564,7 +2564,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		 * If we got woken because of task_work being processed, run it
 		 * now rather than let the caller do another wait loop.
 		 */
-		if (!llist_empty(&ctx->work_llist))
+		if (io_local_work_pending(ctx))
 			io_run_local_work(ctx, nr_wait);
 		io_run_task_work();
 
@@ -3158,7 +3158,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
 		xa_for_each(&tctx->xa, index, node) {
-			if (!llist_empty(&node->ctx->work_llist)) {
+			if (io_local_work_pending(node->ctx)) {
 				WARN_ON_ONCE(node->ctx->submitter_task &&
 					     node->ctx->submitter_task != current);
 				goto end_wait;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4070d4c8ef97..69eb3b23a5a0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -347,9 +347,14 @@ static inline int io_run_task_work(void)
 	return ret;
 }
 
+static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
+{
+	return !llist_empty(&ctx->work_llist);
+}
+
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
+	return task_work_pending(current) || io_local_work_pending(ctx);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
@@ -484,6 +489,6 @@ enum {
 static inline bool io_has_work(struct io_ring_ctx *ctx)
 {
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
-	       !llist_empty(&ctx->work_llist);
+	       io_local_work_pending(ctx);
 }
 #endif
-- 
2.43.5



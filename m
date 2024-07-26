Return-Path: <io-uring+bounces-2587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA02393D50B
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 16:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 586DC1F24899
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 14:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265502582;
	Fri, 26 Jul 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PyDZ81dV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF45D51A
	for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722003849; cv=none; b=e0sRhOAdG6kEl/4L1I+rYCnTsYf8kkoZ5i+61PcsYiXbeu4yQf5WqFMgHtsFHlCqHT9QRZ60QfwFxtcPS3P1tx9dT9mzqBPeHPGThw8R8wJnL9fCoSfVraOdmc56t7JKXif8zJAUKyd9/+n2FgROF5PYxasEt8OGbtHnF7OjKkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722003849; c=relaxed/simple;
	bh=L2okTSJ+rSpzoiY8aZagIeiuHvRODBu78hT4711L91w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCGpn/qlwkReMdCpGHGOYxao95Uka7qdvYVSz4x46/HX8WT+itgpCJanOw5g08ARhYGsepm6eJzN4hx07PYjy/MCO4Yk8Snclc5yfEzzL9cC4/jgmXgzAAsEjyJ15mEOZ6C2UjgwNVESsimAfnlzMwaAFJt4H0cZmOPWh2H+VRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PyDZ81dV; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-368526b1333so1752619f8f.1
        for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 07:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722003845; x=1722608645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WutZkJH1IUuTpMrwmSGBn+cQYuOblL06DxC4bKpMpcw=;
        b=PyDZ81dVzUJISrkUMF3YmYv0XeeYFy8pd+y7ecHSioS4FXW9Kh4g7OgnsSGOkiB7/I
         BzAHP2h5XpG/EmSV5398WCrq73FeOBqJ7TwUpdp+eEXikhPE+mzlD8ZndKzEodQANo5v
         cK6CH0GjfGsANUKM5SojQaEmWiO67PvwydBye1NisHbM6f0d9ogxzFjBgJ1XqUTlms8h
         nrPo9EM0oTWekEvgNWR+gHhgZC75yRiX3DNVHj/f+Nz6Hr5y8jM+4ZRhH5QeFgEjKW+P
         z+8dEqFsHq2h8dbrJunSDRVl+bfIfAe+pk4JeXnPgV2+6qiSg14EGxCbjIL2cimF9s/X
         hTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722003845; x=1722608645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WutZkJH1IUuTpMrwmSGBn+cQYuOblL06DxC4bKpMpcw=;
        b=WVcTNZuJxf1EsjB3kPBovIO+dJQy3R12g/71DQs7haLPZf1LOVV357JmWwcXvjJCBS
         cSx97+GhF/mTOsKcuSW9V6OQ27jZP8oAP7BcMXDTKsW/qGjKDOXD33zctll/TXsAIHKg
         9Avd06QlCitoEH+eSXT43bXl1QOl0jx+WUuo1cH2tp/BKB5X+hXN+CoIO5dskSEQSlBF
         QdKvcixR62K6GiZ63373X0ucezHZTGc1lOdrrTPKqH73mkn8ju81eMqEmFRfll3FcRZs
         E11tz7OO8jI4eJjTAyhLvSLBZ2WqOXZKUYahUrtWt1b7peHnaQOC0YRbuyG+JKGa7Rf9
         ck2g==
X-Gm-Message-State: AOJu0YwT4IqV94OftT3Du/aXBkRZbP2jORQixJWB5wCONcEzOg64qXTs
	Vph8B8IGbwNbNHGhFp+6NsSkLIcOtc+78Lxn4XMnczkPx+lOhULye6Qmig==
X-Google-Smtp-Source: AGHT+IGc7KrFwTqluc0X+tYibtqPrVOxgSUfCJifMfoP69bklZ3qiufbGHHZAxOg6F275NbYm7lDOw==
X-Received: by 2002:adf:e50c:0:b0:368:4ab0:b260 with SMTP id ffacd0b85a97d-36b31b4e0bamr3933333f8f.18.1722003845182;
        Fri, 26 Jul 2024 07:24:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.204])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9859sm5263706f8f.28.2024.07.26.07.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 07:24:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring/napi: use ktime in busy polling
Date: Fri, 26 Jul 2024 15:24:30 +0100
Message-ID: <95e7ec8d095069a3ed5d40a4bc6f8b586698bc7e.1722003776.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1722003776.git.asml.silence@gmail.com>
References: <cover.1722003776.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's more natural to use ktime/ns instead of keeping around usec,
especially since we're comparing it against user provided timers,
so convert napi busy poll internal handling to ktime. It's also nicer
since the type (ktime_t vs unsigned long) now tells the unit of measure.

Keep everything as ktime, which we convert to/from micro seconds for
IORING_[UN]REGISTER_NAPI. The net/ busy polling works seems to work with
usec, however it's not real usec as shift by 10 is used to get it from
nsecs, see busy_loop_current_time(), so it's easy to get truncated nsec
back and we get back better precision.

Note, we can further improve it later by removing the truncation and
maybe convincing net/ to use ktime/ns instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.h            |  2 +-
 io_uring/napi.c                | 48 +++++++++++++++++++---------------
 io_uring/napi.h                |  2 +-
 4 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e62aa9f0629f..3315005df117 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -404,7 +404,7 @@ struct io_ring_ctx {
 	spinlock_t		napi_lock;	/* napi_list lock */
 
 	/* napi busy poll default timeout */
-	unsigned int		napi_busy_poll_to;
+	ktime_t			napi_busy_poll_dt;
 	bool			napi_prefer_busy_poll;
 	bool			napi_enabled;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e1ce908f0679..c2acf6180845 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -43,7 +43,7 @@ struct io_wait_queue {
 	ktime_t timeout;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	unsigned int napi_busy_poll_to;
+	ktime_t napi_busy_poll_dt;
 	bool napi_prefer_busy_poll;
 #endif
 };
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 327e5f3a8abe..6bdb267e9c33 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -33,6 +33,12 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
 	return NULL;
 }
 
+static inline ktime_t net_to_ktime(unsigned long t)
+{
+	/* napi approximating usecs, reverse busy_loop_current_time */
+	return ns_to_ktime(t << 10);
+}
+
 void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 {
 	struct hlist_head *hash_list;
@@ -102,14 +108,14 @@ static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
 		__io_napi_remove_stale(ctx);
 }
 
-static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
-					     unsigned long bp_usec)
+static inline bool io_napi_busy_loop_timeout(ktime_t start_time,
+					     ktime_t bp)
 {
-	if (bp_usec) {
-		unsigned long end_time = start_time + bp_usec;
-		unsigned long now = busy_loop_current_time();
+	if (bp) {
+		ktime_t end_time = ktime_add(start_time, bp);
+		ktime_t now = net_to_ktime(busy_loop_current_time());
 
-		return time_after(now, end_time);
+		return ktime_after(now, end_time);
 	}
 
 	return true;
@@ -124,7 +130,8 @@ static bool io_napi_busy_loop_should_end(void *data,
 		return true;
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
-	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
+	if (io_napi_busy_loop_timeout(net_to_ktime(start_time),
+				      iowq->napi_busy_poll_dt))
 		return true;
 
 	return false;
@@ -181,10 +188,12 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
  */
 void io_napi_init(struct io_ring_ctx *ctx)
 {
+	u64 sys_dt = READ_ONCE(sysctl_net_busy_poll) * NSEC_PER_USEC;
+
 	INIT_LIST_HEAD(&ctx->napi_list);
 	spin_lock_init(&ctx->napi_lock);
 	ctx->napi_prefer_busy_poll = false;
-	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
+	ctx->napi_busy_poll_dt = ns_to_ktime(sys_dt);
 }
 
 /*
@@ -217,7 +226,7 @@ void io_napi_free(struct io_ring_ctx *ctx)
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to 	  = ctx->napi_busy_poll_to,
+		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
 		.prefer_busy_poll = ctx->napi_prefer_busy_poll
 	};
 	struct io_uring_napi napi;
@@ -232,7 +241,7 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
-	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+	WRITE_ONCE(ctx->napi_busy_poll_dt, napi.busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
 	WRITE_ONCE(ctx->napi_enabled, true);
 	return 0;
@@ -249,14 +258,14 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to 	  = ctx->napi_busy_poll_to,
+		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
 		.prefer_busy_poll = ctx->napi_prefer_busy_poll
 	};
 
 	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
-	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	WRITE_ONCE(ctx->napi_busy_poll_dt, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
 	WRITE_ONCE(ctx->napi_enabled, false);
 	return 0;
@@ -275,23 +284,20 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
 			      struct timespec64 *ts)
 {
-	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
+	ktime_t poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
 
 	if (ts) {
 		struct timespec64 poll_to_ts;
 
-		poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		poll_to_ts = ns_to_timespec64(ktime_to_ns(poll_dt));
 		if (timespec64_compare(ts, &poll_to_ts) < 0) {
 			s64 poll_to_ns = timespec64_to_ns(ts);
-			if (poll_to_ns > 0) {
-				u64 val = poll_to_ns + 999;
-				do_div(val, 1000);
-				poll_to = val;
-			}
+			if (poll_to_ns > 0)
+				poll_dt = ns_to_ktime(poll_to_ns);
 		}
 	}
 
-	iowq->napi_busy_poll_to = poll_to;
+	iowq->napi_busy_poll_dt = poll_dt;
 }
 
 /*
@@ -320,7 +326,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 	LIST_HEAD(napi_list);
 	bool is_stale = false;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_to))
+	if (!READ_ONCE(ctx->napi_busy_poll_dt))
 		return 0;
 	if (list_empty_careful(&ctx->napi_list))
 		return 0;
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 6fc0393d0dbe..babbee36cd3e 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -55,7 +55,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_to))
+	if (!READ_ONCE(ctx->napi_busy_poll_dt))
 		return;
 
 	sock = sock_from_file(req->file);
-- 
2.45.2



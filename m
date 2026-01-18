Return-Path: <io-uring+bounces-11800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C19DD3986D
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5206E3009567
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B167260A;
	Sun, 18 Jan 2026 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LTdRhqKv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9EA23EA87
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757017; cv=none; b=gEsch5hO32duDwoKaPpUm3jTJ/SOa+meT5tp4MRueK70D5Nbxk2rJuZJZvHL1iqRZz+YDkgbF/G7vpIpBhJot61EOoCX93jbmrO0Jb/19FT+UdkOyGoKOGGTHe8C6k3nKvtM/p1ghlrjVEE7At3k09xnU8MZUnWFy762LoInPv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757017; c=relaxed/simple;
	bh=cC21RRTglbNlpE4F2zmsv2iHbp4/GgURNfN89Dw70C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoII7Y3aMBTMjfzZZNHH7BnNTJfgeVOZay91Vfsyw/TCALUw5TC39UK0NXlo2Mqr+Ec5kMOcQhKlEwzv5C7MvJH1Y2mRsg2pX3wwoybjbWAx+ei7cCizXBFRdEuFt0ybkwBL20wRnAryoCKzJg85fBQpuCN596t4dBAfvcoMfhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LTdRhqKv; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45c715116dbso2476361b6e.3
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757015; x=1769361815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlyWajuS8ubyGmgFHdNCIENTA+N96Sx8IaP5TuNOhfI=;
        b=LTdRhqKvqv0S6Vv26T6gU1HDs0ChdQWMuqJMsA+ksZaaLOdbXPDwz39GXzX+Mr2m4C
         WBEjF3COlpr7EJoIl90r/Duvfae8t4g1x8BKhcISYgA6D27oFrvT4Mydemw9U/15UHGq
         q9XAdDuMtRk7/NR95kwX9IGmxZpP46UxDUTxnCNcEt7RnY/QEJa+KM6gkv5kv5iLJN2X
         vuepsGp7virnnM/tV9gh8cZqwRpx6X4fCEr4RdZNLgv3PKpwrnO78+Aja5t2SB8IYtKZ
         DfF/x9ds8Z2KwHHyflQC05taD2DB9ohzshFFlJercC4FIqK/YzhftpcGl/BFAqYkxVg8
         6YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757015; x=1769361815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MlyWajuS8ubyGmgFHdNCIENTA+N96Sx8IaP5TuNOhfI=;
        b=lee0DwF116H1UE1St5uzvH3aBY9Lb/fDayDuxoVq9fMvcAicEUI0Kfltc4ruvER32D
         Py6NMm2wXKHuINXD/zWM5VGm4ltcKIS1sDvXU7SxOqKIQJKzUAK2lP0lGJ6PGJT5AFZ/
         Z4j0MmB/+XQa4U3ykK/cTAn8umC/U3DPYdLIy+M6D2rhuxg9FuUbkZeJrqUr+fuvYyMI
         Ey5aaXJ/ChIabD8PDQL7WoxgkjPOF2rnagOZDt+wQCij1g7U2C92GS/C8uBvEfBT/sr9
         T+AffVqT016GS+tklkCTyEFzcFcWJWnUxf65iJlWTZ6kqkk82wyM3L9MmKnPnLagiFVM
         uCdw==
X-Gm-Message-State: AOJu0YwDTgZWLmAnqhvqVZ55TxL+xwfPjI2xGV/22j5+lW+M3KBBa0QG
	ouuttJEGlYBucLopEs1NON3UvhzgMdUgdZcLU8YUDjd4PGw0lxvel4NyJKlXVQmP1k6fW1EToU/
	w+PUY
X-Gm-Gg: AY/fxX7GurReQVv2ce/a+2XAI3lNyl0iIrgSpXJdym8UABYvNWv99Eiflm+Mb2526k8
	JaSnkvDfudDA0rJpe+ZfhHveSyfUdNKzzJOw7tR46cPYnZeNlPYR2JxCED7RZhjkJ3+mcnDDOch
	GKH0r25LZKoG24i3/pn4sBKj++B7jeTxE3I9/CYCL6Ziap1OaPqsvqTss6SZwbg0qFZ01hnUlA5
	06c01BJ2FvERi/JMJVBjJw9MSaW5tTTdy9/475N0WzSJZYejHEHNCDTHIK9vSG4kp6z/JUcNkm5
	DUxU8fRAP38vJXG4rA8FvVNCgTa4iQ8ZFOHKqFctr9uZrN2gQ6P1VGTVc2sDzLKmSuQ9Q/8F6CO
	meaYF7lfKvPg8CUldI9fflftNqzwChfn4HP6f39Or2c+rwIO8MR4B9nqyv8zMF4tpb0bMntsBGC
	RMHW0I/knCghITLyRfDkiO5j2eQ2ekF5Sza+GrgG8fSS7lVW8QK4EufSqlxNf5td/sD6Y=
X-Received: by 2002:a05:6808:198e:b0:45c:881c:e0c0 with SMTP id 5614622812f47-45c9c0d95a6mr4304786b6e.47.1768757014940;
        Sun, 18 Jan 2026 09:23:34 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/bpf_filter: cache lookup table in ctx->bpf_filters
Date: Sun, 18 Jan 2026 10:16:53 -0700
Message-ID: <20260118172328.1067592-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently a few pointer dereferences need to be made to both check if
BPF filters are installed, and then also to retrieve the actual filter
for the opcode. Cache the table in ctx->bpf_filters to avoid that.

Add a bit of debug info on ring exit to show if we ever got this wrong.
Small risk of that given that the table is currently only updated in one
spot, but once task forking is enabled, that will add one more spot.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/bpf_filter.c          |  7 ++++---
 io_uring/bpf_filter.h          | 10 +++++-----
 io_uring/io_uring.c            | 11 +++++++++--
 io_uring/register.c            |  3 +++
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 37f0a5f7b2f4..366927635277 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -287,6 +287,8 @@ struct io_ring_ctx {
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
+		/* cache of ->restrictions.bpf_filters->filters */
+		struct io_bpf_filter __rcu	**bpf_filters;
 		struct percpu_ref	refs;
 
 		clockid_t		clockid;
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 63996b350e60..0e668852b3ea 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -49,14 +49,15 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
  * __io_uring_run_bpf_filters() returns 0 on success, allow running the
  * request, and -EACCES when a request is denied.
  */
-int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
+int __io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
+			       struct io_kiocb *req)
 {
 	struct io_bpf_filter *filter;
 	struct io_uring_bpf_ctx bpf_ctx;
 	int ret;
 
 	/* Fast check for existence of filters outside of RCU */
-	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
+	if (!rcu_access_pointer(filters[req->opcode]))
 		return 0;
 
 	/*
@@ -64,7 +65,7 @@ int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
 	 * of what we expect, io_init_req() does this.
 	 */
 	rcu_read_lock();
-	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
+	filter = rcu_dereference(filters[req->opcode]);
 	if (!filter) {
 		ret = 1;
 		goto out;
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
index 27eae9705473..9f3cdb92eb16 100644
--- a/io_uring/bpf_filter.h
+++ b/io_uring/bpf_filter.h
@@ -6,18 +6,18 @@
 
 #ifdef CONFIG_IO_URING_BPF
 
-int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req);
+int __io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters, struct io_kiocb *req);
 
 int io_register_bpf_filter(struct io_restriction *res,
 			   struct io_uring_bpf __user *arg);
 
 void io_put_bpf_filters(struct io_restriction *res);
 
-static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 					   struct io_kiocb *req)
 {
-	if (res->bpf_filters)
-		return __io_uring_run_bpf_filters(res, req);
+	if (filters)
+		return __io_uring_run_bpf_filters(filters, req);
 
 	return 0;
 }
@@ -29,7 +29,7 @@ static inline int io_register_bpf_filter(struct io_restriction *res,
 {
 	return -EINVAL;
 }
-static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **filters,
 					   struct io_kiocb *req)
 {
 	return 0;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 67533e494836..62aeaf0fad74 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2262,8 +2262,8 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
-	if (unlikely(ctx->restrictions.bpf_filters)) {
-		ret = io_uring_run_bpf_filters(&ctx->restrictions, req);
+	if (unlikely(ctx->bpf_filters)) {
+		ret = io_uring_run_bpf_filters(ctx->bpf_filters, req);
 		if (ret)
 			return io_submit_fail_init(sqe, req, ret);
 	}
@@ -2857,6 +2857,13 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+
+	if (ctx->restrictions.bpf_filters) {
+		WARN_ON_ONCE(ctx->bpf_filters !=
+			     ctx->restrictions.bpf_filters->filters);
+	} else {
+		WARN_ON_ONCE(ctx->bpf_filters);
+	}
 	io_put_bpf_filters(&ctx->restrictions);
 
 	WARN_ON_ONCE(ctx->nr_req_allocated);
diff --git a/io_uring/register.c b/io_uring/register.c
index 30957c2cb5eb..40de9b8924b9 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -837,6 +837,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (nr_args != 1)
 			break;
 		ret = io_register_bpf_filter(&ctx->restrictions, arg);
+		if (!ret)
+			WRITE_ONCE(ctx->bpf_filters,
+				   ctx->restrictions.bpf_filters->filters);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.51.0



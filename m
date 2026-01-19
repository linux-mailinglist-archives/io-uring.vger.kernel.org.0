Return-Path: <io-uring+bounces-11827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB38D3BC24
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 78F9B3038B8B
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2A72C08CB;
	Mon, 19 Jan 2026 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h0xhKN+P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B25E2D1916
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866911; cv=none; b=cRIb8BxewiUFEVSXLBygcyqlv/1s2vzlUgHmJakbvPhl9mqHldoGnuSz1iUT+vc79Qr/f7OX6wdPx1rcfpC4VFhd+GC5/SBPDtc2BRsMA1T7rCiAwZQZmCTQa+c1td5LR+Z6PsrAChqG59BcGoQ9Q5T5yfH6zpJ2ZQ/lP2m1XFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866911; c=relaxed/simple;
	bh=6VAxAobIgatlQE98HcCiSGApckYe1P36Q8FRYaXe8+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRndE5O9N9C/1qc51aTNlaRPdXp4fz7mANAzIuqzd1zSU+x3gIGgzwo5YArJWQN0ECAEgWN2QvNCRM6RC0GqyCAoH+QQ2aoYNSHvTzhQZsh4wvk02tGqCKuj+2cs4VTcEhdS2lNBvfd7fEnmZJgvyJjK9ZC50ooa6HpKcfmUDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h0xhKN+P; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7cfcbe7d176so3142719a34.3
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866904; x=1769471704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLFfsxRVnIUTtGYHuqdysnbhsPUWWLHguip17Yqjw2Q=;
        b=h0xhKN+PsW4n/yYJz3s2TaI905Cd8HBsr0gp5eepheyf7aECY0tqdX4yHFdHktCndH
         Kd2JqjxZFwLtLUr4JL4JAnrS4KN8is+OCSUd+m/uhvXZErQn5fDT7qar/wFhNGpJdQ43
         Z6Zb+mFjTD1FoH5NGcRIuqWvLjCulfzzYhA9n0IFIFhmkHiBUCY980kdgmjOlcuc9AOW
         K5QwsIzRlVrJGnwCG9um7rB9wgVsoVyF0dfELOb2f/W+CRkLjcRhZuKcE0g0Q1mE/Ume
         evejezt3AGD2IYc9XlNY6tLkulHKttwKzjzeBceJ5+j3Y74EtpcIsUYvQjRAPekFtR5v
         DsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866904; x=1769471704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZLFfsxRVnIUTtGYHuqdysnbhsPUWWLHguip17Yqjw2Q=;
        b=mrK7JyRYoh5rF654TzVVT8Cky45J6J+PBTzL92nNzi5OOdoQYbjydnsOtL3xxSs1Cx
         FWSFPZlXBh4isujcvsqNBdSHzCoCnJ0wKGasxZyZhcykVMtln36LEw473USXh5b+TkJg
         gCP0OjP4mrZlVZr1Y10xgMIPJTsur6gKcLathVlnhM82615exSHD1/kY3gBGHoyHA7Ro
         +5VZ8Fqeup0g/W6/V+3ssYeeoRWQtojVy9vdgQ76mpBHWOjf7ws0SoRLl0BiDOVzHEzz
         85i5T2TH8C41apw3kFBGK8F/yqn20UX9SXiXh/kCWYC/cLhk08+ou2arMNR5/abEgkmf
         MiGQ==
X-Gm-Message-State: AOJu0YwkG/ydYfCsk2WWLznGiqzoUVhXuOmRTOSUMBG+4pk3Bf/wbZV/
	b//QcNnVc6tZCUiGy9vkDJhkBbW2Jskb7POBfs4IKztIDvYwJ8poUj75EiHoLHp5MYAXg1tQxwB
	VsOdB
X-Gm-Gg: AY/fxX6U2oXVau4x6kG9LWzXHJ8ic1lJdYYp0L1xqPEZt36n5WminluCTzw8V1EVESC
	zU5sh83sgNE9xI0genkRaZAoBWBo2oDCh/KmF9uJ7stP+GLBHFUn7ZYdeTEuabl2zz/VG2gE1nV
	voGVjKhqiSBMyWJSPhMsxGZwTwMMswsa0TQ+4B9jwiLqralEZaWt5Bvus9B4WGHHvmHohbUNsqr
	6Q5cLiiOh7JPwI1WiQein2lzTP8ry/G2plky0xM6VcwKptCw4HJ4YJczzQBHVM9HTdlv7/KzEHH
	Js7xMZ1cPZL3c03OEVT4602YHjB4OTbFer2MpQul0ZnlAkmVk9Vl0nmG0u0Lon+EAWf7mHxEKyE
	ZjSA1rknqRLug2K1xsV9rpuRH9TP1OxGp2shjIBCGwr/VNKJpSyEou0+JAfjtG3jMG4i5cUlh0c
	X47F9AKu6iUuoF+WdrtfBUxVvbd+lIGjeMAgS3dbtDcld6JHgJDWr/o4Nv
X-Received: by 2002:a05:6830:6d2c:b0:7cf:cef0:be05 with SMTP id 46e09a7af769-7d140a3d424mr73583a34.5.1768866903772;
        Mon, 19 Jan 2026 15:55:03 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:03 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/bpf_filter: cache lookup table in ctx->bpf_filters
Date: Mon, 19 Jan 2026 16:54:27 -0700
Message-ID: <20260119235456.1722452-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
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
index 3352f53fd2b9..06fad04c4b54 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -55,14 +55,15 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
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
@@ -70,7 +71,7 @@ int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
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



Return-Path: <io-uring+bounces-11732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FB6D25E0F
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 272B2303B7E8
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 16:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06643A7E0B;
	Thu, 15 Jan 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DadHfP6G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C33A35BE
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495977; cv=none; b=bibYbYDaYx5fsnZFdUHpqXAjET2KkqU5v6+gDMxPKdPiN3BIa034yHuq1EAee4uy8HShBOgADI0W3ANHJACZQ0EVO86HJ3xnhv/MNZ+e8RxsV07Gy+VGpaVtbJqIOtFixwVWx6F1GJaKlviYpUCsvgkLgt/TVQ8FbfksJDQXP54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495977; c=relaxed/simple;
	bh=r2kyDIy6Kgrdm0A5Um36+FWoeSgVe4c8iTXvbRzcnZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlokFia/eFqIJdIi4N4UMEDgRx9QWhSI/ujR+P+C9dA5dqelvBQbNkOIf19mc4XWlvmJzXgYppHhaM+UlnY6evyc5MWQqL8n3ZY8qog3CtxA7fLviNrCunvg6D5N4xvZdYrr09XML/qGFiHVbmew603Kq5Xdf842K0SARRdThnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DadHfP6G; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7cfd139645cso749248a34.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 08:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768495975; x=1769100775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOIIx5IS2QmfwaiS3EHf9C9zup3dtylSmQaUuD8Jo0Y=;
        b=DadHfP6GDVO1DJ2ul89Y7yrHIH8bc1RaQOliUJDjZlU/sL5ILpTIiQkOUGI3PbsLQy
         sftjQMJLkGSpYLZR/3ZWlZJ040/8NMYSpvutOQ7can41126zOOGbM0WK60Thx4omjnUN
         Wx+hGc5IVwJ/HSJRt8/6oyMUV2OgjyfNJbTJVbI7SvpPgzrBAsh0BlzjPTqeTi/+6r8W
         P1iSvyfzeISVuDZnJ2DV755xsxGWCiwV10cAXJRBEPeAR283qsWZ0Q+P8ugWbMXuA1+8
         XLKRseSxxGi4f4NV1iGEdP2mDpAkc6XGCTTIjo4UHtBcGHVHmE/5JpY/iDDdRVBeb98k
         vIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495975; x=1769100775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOIIx5IS2QmfwaiS3EHf9C9zup3dtylSmQaUuD8Jo0Y=;
        b=E8Zk+SgU+mUbHNr2R8MoAvzLUlvcZXvXBNr8QX6w+1jO38d55wzwcyKzXFHO7eLGD+
         Xobemq1KNgabGbRxii1qsU8pLO/bmpiW91dNTUngIgVRdsV7KZ9K4QJXmvXl8ROtIDLW
         R/WErTlnk4R8aYRDcDK45PDsYNxsOwMC24OXP4h+RH30VfvfgXgVR2qQDZkuxeiZInBh
         4qTGg87yoI6lhzuXvk7NT3RI8gkSilpGDhm+53HOkVb6vGEflw8f4gkZCAzHRg6divZY
         AIGXu5YlttmavZSM7nYR3bRdp2OhznnFOENp3xPbDcsE9LJGkZaeE39+m9KzRn8rc+Z/
         4GKw==
X-Gm-Message-State: AOJu0YyXUGNPtszFLR5L1/8fXV4wEOdc0zJ2QEyXW7IXdujGHDPlBeEi
	j9qQwI4vfGb9cufsgLLda/0mKEnZFZmVQcLe+giZLHyAOigh/XVXvPOYc7kKky1JP6eYjk02Bme
	V7vVl
X-Gm-Gg: AY/fxX61EtZtwe3jzblAbWmPLxyjHWjbxmx50WYO1yJ57aBqIyPjwMsCx7OozEl1/+m
	k05TqVNFCEBj5MZOd/bD1can9G13qSsKHEAzN1nV00Xk4Mn3gXbdiRiqAnhwuOqnSv+kodNW3AQ
	7DGG9kKj+EFEds8O3Ayy8qT8niw8t0nMRTgw/3jER0Dis0FJC/B5sHRZExLQv9rMf0M/DLs5GAk
	nfMpE8bzGstrxzZr/ZyZRhB0IVXngfwQwaKYXUB0KSUwfXokDYIURZdd7u6vFiBM/Fg+9xBidoe
	4OaZoBP9SKpD1PwTUKOC5tP1GxRMqyYc4nr2O4p1xe2UdXQPiFrDFS6Mh6U/B7iYb6WCuiqjIxI
	dLAxZEhh4H1s/i2NbncUSbnqsTzOgPB8CI6EzOiFXE1KKORBLx8MlQeG70Bq/Pc3v/gWgoQ==
X-Received: by 2002:a05:6830:4392:b0:7cf:dc6a:b70 with SMTP id 46e09a7af769-7cfdee073bdmr66044a34.13.1768495974624;
        Thu, 15 Jan 2026 08:52:54 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0db2ddsm14369a34.3.2026.01.15.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:52:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: move ctx->restrictions to be dynamically allocated
Date: Thu, 15 Jan 2026 09:36:32 -0700
Message-ID: <20260115165244.1037465-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260115165244.1037465-1-axboe@kernel.dk>
References: <20260115165244.1037465-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for being able to share restrictions, move them to
allocated data rather than be embedded in the ring. This makes it more
obvious when they will have potentially different lifetimes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  4 +++-
 io_uring/io_uring.c            | 12 ++++++-----
 io_uring/register.c            | 37 +++++++++++++++++++++++++++-------
 io_uring/register.h            |  2 ++
 4 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 211686ad89fd..c664c84247f1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -220,6 +220,7 @@ struct io_rings {
 };
 
 struct io_restriction {
+	refcount_t refs;
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
@@ -342,6 +343,8 @@ struct io_ring_ctx {
 		struct io_alloc_cache	rw_cache;
 		struct io_alloc_cache	cmd_cache;
 
+		struct io_restriction	*restrictions;
+
 		/*
 		 * Any cancelable uring_cmd is added to this list in
 		 * ->uring_cmd() by io_uring_cmd_insert_cancelable()
@@ -413,7 +416,6 @@ struct io_ring_ctx {
 
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
-	struct io_restriction		restrictions;
 
 	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
 	struct xarray			zcrx_ctxs;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2cde22af78a3..eec8da38a596 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2058,15 +2058,15 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 {
 	if (!ctx->op_restricted)
 		return true;
-	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+	if (!test_bit(req->opcode, ctx->restrictions->sqe_op))
 		return false;
 
-	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
-	    ctx->restrictions.sqe_flags_required)
+	if ((sqe_flags & ctx->restrictions->sqe_flags_required) !=
+	    ctx->restrictions->sqe_flags_required)
 		return false;
 
-	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
-			  ctx->restrictions.sqe_flags_required))
+	if (sqe_flags & ~(ctx->restrictions->sqe_flags_allowed |
+			  ctx->restrictions->sqe_flags_required))
 		return false;
 
 	return true;
@@ -2850,6 +2850,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+	if (ctx->restrictions)
+		io_put_restrictions(ctx->restrictions);
 
 	WARN_ON_ONCE(ctx->nr_req_allocated);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 8551f13920dc..6c99b441d886 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -163,9 +163,28 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 	return ret;
 }
 
+void io_put_restrictions(struct io_restriction *res)
+{
+	if (refcount_dec_and_test(&res->refs))
+		kfree(res);
+}
+
+static struct io_restriction *io_alloc_restrictions(void)
+{
+	struct io_restriction *res;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&res->refs, 1);
+	return res;
+}
+
 static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 					   void __user *arg, unsigned int nr_args)
 {
+	struct io_restriction *res;
 	int ret;
 
 	/* Restrictions allowed only if rings started disabled */
@@ -173,19 +192,23 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		return -EBADFD;
 
 	/* We allow only a single restrictions registration */
-	if (ctx->restrictions.op_registered || ctx->restrictions.reg_registered)
+	if (ctx->restrictions)
 		return -EBUSY;
 
-	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
-	/* Reset all restrictions if an error happened */
+	res = io_alloc_restrictions();
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = io_parse_restrictions(arg, nr_args, res);
 	if (ret < 0) {
-		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+		io_put_restrictions(res);
 		return ret;
 	}
-	if (ctx->restrictions.op_registered)
+	if (res->op_registered)
 		ctx->op_restricted = 1;
-	if (ctx->restrictions.reg_registered)
+	if (res->reg_registered)
 		ctx->reg_restricted = 1;
+	ctx->restrictions = res;
 	return 0;
 }
 
@@ -637,7 +660,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 	if (ctx->reg_restricted && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
-		if (!test_bit(opcode, ctx->restrictions.register_op))
+		if (!test_bit(opcode, ctx->restrictions->register_op))
 			return -EACCES;
 	}
 
diff --git a/io_uring/register.h b/io_uring/register.h
index a5f39d5ef9e0..99c59894d163 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -6,4 +6,6 @@ int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
 struct file *io_uring_register_get_file(unsigned int fd, bool registered);
 
+void io_put_restrictions(struct io_restriction *res);
+
 #endif
-- 
2.51.0



Return-Path: <io-uring+bounces-8028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD62EABA9E6
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 439814A4D72
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6251FBEB0;
	Sat, 17 May 2025 11:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AheC/m49"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8687F1F4C9F
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482591; cv=none; b=AUi13XEI0UOLuQa1zakCCq+xsahE1ubHfvEfJB/pSI01HEQ9FnMJivE1rXJsGonXyo2cll1+HHnFoEEEEqMwCU+wpO8A2Q/0wKPG5Hn51JJekiGrlUCUNY4j81bSEl5DT/4U2AkKWajS9IqOVjhVv7WbeAwEmCRpiNdwAsh9gj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482591; c=relaxed/simple;
	bh=KAA9/pCFgJfB5rDBaEeDoITmF+5yNJS16EYHfwsswP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc5knH4IhaHF7yK+rlOyui0Dp1lnJFaO9nsN38uM77x4lRHn4E/6vPDh+fm+iznKbHAe5jIh7117anPpS5WFts5Ky0rraHiCHPoYUr0H+a5eTQlNZOUjXNTwVA8aE9Q4ZJSM0WQrBP+m6WJ750zkR9IOwoHDsN9J1v8iu1VIc+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AheC/m49; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso135590739f.1
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482588; x=1748087388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT5NRwBAa7z+dA+SItfqRLrgvLPkDvp36tWJQ392TqI=;
        b=AheC/m49E7UxT8T0W5P59z0ZAC7keht6cdeHnJEGsBYyT9vWtqBVJoa4gvhAJ4q1B2
         nzjkgNNUjAxEpP4Go0eBHE0opaZEqHxB8zig8yzGnRX7B1eopNASaIuAtsKkIQ/EIQqV
         Gdk8pCF/yDYGjSXDxy3SXaCAYFHMEg0MySWdNA0gTKHfreF72viktZM7VS3ss1KoGGR0
         vMoBURh0PfmRV7unyiF6plJQ3YYWnJUISaCzqzk7TyM8C5LIw2/ookqpQVCucQ0G7lse
         5IZj2Z10lNdoNBH2VhUQQVbLz6JRQVh0QFIN93wbz/qqI2G7tlzUeWAYdKif21ZADalz
         VEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482588; x=1748087388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OT5NRwBAa7z+dA+SItfqRLrgvLPkDvp36tWJQ392TqI=;
        b=HcCEM61dYbGovIE2SXEo6wIOSV0lRMwTs87/5kscbh4l3vQK9hI4BHZxtC8mz/mQoP
         CllfL3ZaYPZMoZlsgEPEwNyzJTAaRCFdja1q7UfWPROc3m0DdmOSSlz6efd2ViMutUF9
         zz8dJIxHwQfcy2cUl/adtDKsfowRvFAghI5a3Zm3qu3isbA7aObWeO7munzQXkvw3ltl
         BqKZSdPmNzyYivaoB+270YMAXUFIv76XKEEaTaGAkEABiYKAMA7Ub7WvgZDYcpJzPZ6+
         1aQt6Mx0Rmu8U2r55swnUoNZgDLGcYelAzO95XZuXw5Udo7q58y6C2iNpztHZy6ZepkB
         T09w==
X-Gm-Message-State: AOJu0YwJo5sWxKq3o3ZbfBYi3tw6wpzv6MeLqrnP/oUMzTau+omJAefs
	sBQxJ6RvtjGs+slw0ci8PMkwKxgLfuWfAcdXJ4v4YYVKg5GiG6kwVccyGAd/k2WB0J8+i6CdzeU
	tKISj
X-Gm-Gg: ASbGnctzQGD+T/40cEmMi8Vr/8Lxe+vtRtSmTp54/v4uWQbpCRsi3WCZDOCrYiUaDrU
	rdKbYTmzppCDlefFIUMXWfy0Zeh36FBo/NUWUbQpsxE6KGIKysHpwUvGXx05IjRCBi0QwxOh++8
	5NEfMniv54KmofFc18rReR1UvP+F57lysiq1fEydvadCi+1l3Wuxwiupl7j7nbrZa6vYs9+n4Cr
	kOjEqF8nXsiXoHebziG09vHfNUct6xbUPVVPdxYlId+yi2PEVSEqkQuwyvCzj7Yh8j4O3IqaPQO
	Q6O5spL/f4+zavk92yJ9p9TpN3PaUFB85sKI4uoCtVknsJCrjX70W/7F
X-Google-Smtp-Source: AGHT+IFmLwKYG5O1hggsj7cIzHqkCe9BZSXQY26js35tFmI0Ljn/FT4gtCsjOUoXOnMTnSfGnR9ACg==
X-Received: by 2002:a5d:8181:0:b0:86a:24a7:cecb with SMTP id ca18e2360f4ac-86a24a7d12dmr680277439f.4.1747482588094;
        Sat, 17 May 2025 04:49:48 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: pass in struct io_big_cqe to io_alloc_ocqe()
Date: Sat, 17 May 2025 05:42:14 -0600
Message-ID: <20250517114938.533378-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517114938.533378-1-axboe@kernel.dk>
References: <20250517114938.533378-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than pass extra1/extra2 separately, just pass in the (now) named
io_big_cqe struct instead. The callers that don't use/support CQE32 will
now just pass a single NULL, rather than two seperate mystery zero
values.

Move the clearing of the big_cqe elements into io_alloc_ocqe() as well,
so it can get moved out of the generic code.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 00dbd7cd0e7d..2922635986f5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -710,7 +710,7 @@ struct io_kiocb {
 	const struct cred		*creds;
 	struct io_wq_work		work;
 
-	struct {
+	struct io_big_cqe {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1cf9d68b4964..4081ffd890af 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -724,8 +724,8 @@ static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
 }
 
 static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
-					     struct io_cqe *cqe, u64 extra1,
-					     u64 extra2, gfp_t gfp)
+					     struct io_cqe *cqe,
+					     struct io_big_cqe *big_cqe, gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -734,17 +734,19 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
-	ocqe = kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
+	ocqe = kzalloc(ocq_size, gfp | __GFP_ACCOUNT);
 	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
 	if (ocqe) {
 		ocqe->cqe.user_data = cqe->user_data;
 		ocqe->cqe.res = cqe->res;
 		ocqe->cqe.flags = cqe->flags;
-		if (is_cqe32) {
-			ocqe->cqe.big_cqe[0] = extra1;
-			ocqe->cqe.big_cqe[1] = extra2;
+		if (is_cqe32 && big_cqe) {
+			ocqe->cqe.big_cqe[0] = big_cqe->extra1;
+			ocqe->cqe.big_cqe[1] = big_cqe->extra2;
 		}
 	}
+	if (big_cqe)
+		big_cqe->extra1 = big_cqe->extra2 = 0;
 	return ocqe;
 }
 
@@ -821,7 +823,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -841,7 +843,7 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
@@ -1451,8 +1453,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
 			struct io_overflow_cqe *ocqe;
 
-			ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
-					     req->big_cqe.extra2, gfp);
+			ocqe = io_alloc_ocqe(ctx, &req->cqe, &req->big_cqe, gfp);
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
 				io_cqring_add_overflow(ctx, ocqe);
@@ -1460,7 +1461,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			} else {
 				io_cqring_add_overflow(ctx, ocqe);
 			}
-			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0



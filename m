Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39E93169EE
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 16:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBJPRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 10:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhBJPRS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 10:17:18 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB161C061793
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:08 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q7so2244591iob.0
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/dxS3BEh6jt+UUS0xgw/ymlQtIOq7FAG8NfWREenwo0=;
        b=aaoLSaTPGDwEtokOz1fRWDNWkix1kkm3fAwiHnPReWtuwoSUDSMfWNBm/M1l8ahvpi
         H8peHb8V3ldO/6AZh8Xy5h9kKHbN5nURzm3VmGcXd+ve+/sZHbnkvD3rx4cID6CC/zPR
         q1WAfxHOD0VPk3QNmfNDiO/l/+K2y+9vfHkEaGANB4LllsfeR2hUiemvRZTg9EcE3O3k
         pBxMNoawmLpe4TS8EQCBwQ+1DhPyI+swtP7rnUVl5qhZnHkqknX2Hn2r0badyRWHgu0H
         VKsmGPPop1OquxtvoKwwTBaDcEMefT2axOFgH59AKCAoL68an6Y4czxd4lSOUfdGePuA
         sL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/dxS3BEh6jt+UUS0xgw/ymlQtIOq7FAG8NfWREenwo0=;
        b=JVfdV1xpg/6GDE2IDOWFHw3tM+fRhzjd4uIOLxj9UCU/1ScHgwgYDZNiMevPrpSxbl
         jF+4KM+Tk4pAzsrexQOsXV6iUCXbZA/X6VV4wdHJWz7SQe66AVSGiApQqfaP97lmgblG
         8p1B6XRXJ3EIvnbfyGP+UL2LoFNp26u3LJBHgPyxEo7xoA6lr9tGtwyOkAVG9ZdmgO5G
         KXlagfPaqni5jHO2ZTBp4RM3U3OKeXhh2DI2TvmqiP2pWs9Z7RZCIf8yOmNl3JLy5lUu
         7wm7fMS5NCVmnqUZCoMHcpBGrTLpxV7VLIS5lbYITgItyZz82o6FWbSw+9vr00nwbSzu
         xQGA==
X-Gm-Message-State: AOAM531Gp60QSH83HtsykjQn/quKTacrLhEJ7MJNSmzoqdKtq+8r4Rae
        DMsHbvWOOWSa6Ip5odNXFqrtXtLoEiSpGhKC
X-Google-Smtp-Source: ABdhPJwHm90Co1SU4ZtLwR3yIjqlIs012y7wwlVgTMCEm2YmA8/NTlU5DpXArFlzri5syeMHqV1dog==
X-Received: by 2002:a05:6638:34a1:: with SMTP id t33mr734889jal.23.1612970168107;
        Wed, 10 Feb 2021 07:16:08 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm1027952ioc.34.2021.02.10.07.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 07:16:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: place ring SQ/CQ arrays under memcg memory limits
Date:   Wed, 10 Feb 2021 08:16:04 -0700
Message-Id: <20210210151604.498311-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210151604.498311-1-axboe@kernel.dk>
References: <20210210151604.498311-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of imposing rlimit memlock limits for the rings themselves,
ensure that we account them properly under memcg with __GFP_ACCOUNT.
We retain rlimit memlock for registered buffers, this is just for the
ring arrays themselves.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 85 ++++++---------------------------------------------
 1 file changed, 10 insertions(+), 75 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bffed6aa5722..7a1e4ecf5f94 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1017,11 +1017,6 @@ static const struct io_op_def io_op_defs[] = {
 	},
 };
 
-enum io_mem_account {
-	ACCT_LOCKED,
-	ACCT_PINNED,
-};
-
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
@@ -8355,25 +8350,16 @@ static inline int __io_account_mem(struct user_struct *user,
 	return 0;
 }
 
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
-			     enum io_mem_account acct)
+static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
 
-	if (ctx->mm_account) {
-		if (acct == ACCT_LOCKED) {
-			mmap_write_lock(ctx->mm_account);
-			ctx->mm_account->locked_vm -= nr_pages;
-			mmap_write_unlock(ctx->mm_account);
-		}else if (acct == ACCT_PINNED) {
-			atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
-		}
-	}
+	if (ctx->mm_account)
+		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 }
 
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
-			  enum io_mem_account acct)
+static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	int ret;
 
@@ -8383,15 +8369,8 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 			return ret;
 	}
 
-	if (ctx->mm_account) {
-		if (acct == ACCT_LOCKED) {
-			mmap_write_lock(ctx->mm_account);
-			ctx->mm_account->locked_vm += nr_pages;
-			mmap_write_unlock(ctx->mm_account);
-		} else if (acct == ACCT_PINNED) {
-			atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
-		}
-	}
+	if (ctx->mm_account)
+		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
 
 	return 0;
 }
@@ -8411,7 +8390,7 @@ static void io_mem_free(void *ptr)
 static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
-				__GFP_NORETRY;
+				__GFP_NORETRY | __GFP_ACCOUNT;
 
 	return (void *) __get_free_pages(gfp_flags, get_order(size));
 }
@@ -8445,18 +8424,6 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	return off;
 }
 
-static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
-{
-	size_t pages;
-
-	pages = (size_t)1 << get_order(
-		rings_size(sq_entries, cq_entries, NULL));
-	pages += (size_t)1 << get_order(
-		array_size(sizeof(struct io_uring_sqe), sq_entries));
-
-	return pages;
-}
-
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	int i, j;
@@ -8471,7 +8438,7 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 			unpin_user_page(imu->bvec[j].bv_page);
 
 		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages, ACCT_PINNED);
+			io_unaccount_mem(ctx, imu->acct_pages);
 		kvfree(imu->bvec);
 		imu->nr_bvecs = 0;
 	}
@@ -8569,7 +8536,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	if (!imu->acct_pages)
 		return 0;
 
-	ret = io_account_mem(ctx, imu->acct_pages, ACCT_PINNED);
+	ret = io_account_mem(ctx, imu->acct_pages);
 	if (ret)
 		imu->acct_pages = 0;
 	return ret;
@@ -8949,14 +8916,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
-	/*
-	 * Do this upfront, so we won't have a grace period where the ring
-	 * is closed but resources aren't reaped yet. This can cause
-	 * spurious failure in setting up a new ring.
-	 */
-	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries),
-			 ACCT_LOCKED);
-
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
@@ -9780,7 +9739,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
 	struct file *file;
-	bool limit_mem;
 	int ret;
 
 	if (!entries)
@@ -9821,26 +9779,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	}
 
 	user = get_uid(current_user());
-	limit_mem = !capable(CAP_IPC_LOCK);
-
-	if (limit_mem) {
-		ret = __io_account_mem(user,
-				ring_pages(p->sq_entries, p->cq_entries));
-		if (ret) {
-			free_uid(user);
-			return ret;
-		}
-	}
 
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx) {
-		if (limit_mem)
-			__io_unaccount_mem(user, ring_pages(p->sq_entries,
-								p->cq_entries));
 		free_uid(user);
 		return -ENOMEM;
 	}
 	ctx->compat = in_compat_syscall();
+	ctx->limit_mem = !capable(CAP_IPC_LOCK);
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 #ifdef CONFIG_AUDIT
@@ -9876,17 +9822,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 #endif
-
-	/*
-	 * Account memory _before_ installing the file descriptor. Once
-	 * the descriptor is installed, it can get closed at any time. Also
-	 * do this before hitting the general error path, as ring freeing
-	 * will un-account as well.
-	 */
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
-		       ACCT_LOCKED);
-	ctx->limit_mem = limit_mem;
-
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
-- 
2.30.0


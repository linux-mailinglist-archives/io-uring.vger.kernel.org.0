Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB931C3BC4
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgEDNxo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 09:53:44 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38484 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgEDNxo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 09:53:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TxUSl9j_1588600413;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TxUSl9j_1588600413)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 04 May 2020 21:53:39 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: handle -EFAULT properly in io_uring_setup()
Date:   Mon,  4 May 2020 21:53:28 +0800
Message-Id: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
resources, which could be reproduced by using mprotect to set params
to PROT_READ. To fix this issue, refactor io_uring_create() a bit to
let it return 'struct io_ring_ctx *', then when copy_to_user() failed,
we can free kernel resource properly.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b91b0631173..a19885dee621 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7761,7 +7761,8 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_uring_create(unsigned entries, struct io_uring_params *p)
+static struct io_ring_ctx *io_uring_create(unsigned entries,
+				struct io_uring_params *p)
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
@@ -7769,10 +7770,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	int ret;
 
 	if (!entries)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	if (entries > IORING_MAX_ENTRIES) {
 		if (!(p->flags & IORING_SETUP_CLAMP))
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 		entries = IORING_MAX_ENTRIES;
 	}
 
@@ -7792,10 +7793,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 		 * any cq vs sq ring sizing.
 		 */
 		if (p->cq_entries < p->sq_entries)
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
 			if (!(p->flags & IORING_SETUP_CLAMP))
-				return -EINVAL;
+				return ERR_PTR(-EINVAL);
 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
 		}
 		p->cq_entries = roundup_pow_of_two(p->cq_entries);
@@ -7811,7 +7812,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 				ring_pages(p->sq_entries, p->cq_entries));
 		if (ret) {
 			free_uid(user);
-			return ret;
+			return ERR_PTR(ret);
 		}
 	}
 
@@ -7821,7 +7822,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 			io_unaccount_mem(user, ring_pages(p->sq_entries,
 								p->cq_entries));
 		free_uid(user);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 	ctx->compat = in_compat_syscall();
 	ctx->account_mem = account_mem;
@@ -7853,22 +7854,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 
-	/*
-	 * Install ring fd as the very last thing, so we don't risk someone
-	 * having closed it before we finish setup
-	 */
-	ret = io_uring_get_fd(ctx);
-	if (ret < 0)
-		goto err;
-
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	return ret;
+	return ctx;
 err:
 	io_ring_ctx_wait_and_kill(ctx);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 /*
@@ -7878,6 +7871,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
  */
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
+	struct io_ring_ctx *ctx;
 	struct io_uring_params p;
 	long ret;
 	int i;
@@ -7894,12 +7888,21 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
 		return -EINVAL;
 
-	ret = io_uring_create(entries, &p);
-	if (ret < 0)
-		return ret;
+	ctx = io_uring_create(entries, &p);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
 
-	if (copy_to_user(params, &p, sizeof(p)))
+	if (copy_to_user(params, &p, sizeof(p))) {
+		io_ring_ctx_wait_and_kill(ctx);
 		return -EFAULT;
+	}
+	/*
+	 * Install ring fd as the very last thing, so we don't risk someone
+	 * having closed it before we finish setup
+	 */
+	ret = io_uring_get_fd(ctx);
+	if (ret < 0)
+		io_ring_ctx_wait_and_kill(ctx);
 
 	return ret;
 }
-- 
2.17.2


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE321C504B
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 10:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgEEI3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 04:29:06 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:39077 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728556AbgEEI3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 04:29:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TxYdNBh_1588667335;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TxYdNBh_1588667335)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 May 2020 16:29:04 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2] io_uring: handle -EFAULT properly in io_uring_setup()
Date:   Tue,  5 May 2020 16:28:53 +0800
Message-Id: <20200505082853.28411-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
resources, which will be recycled until process terminates. This bug
can be reproduced by using mprotect to set params to PROT_READ. To fix
this issue, refactor io_uring_create() a bit to add a new 'struct
io_uring_params __user *params' parameter and move the copy_to_user()
in io_uring_setup() to io_uring_setup(), if copy_to_user() failed,
we can free kernel resource properly.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b91b0631173..ec0aa6957882 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7761,7 +7761,8 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_uring_create(unsigned entries, struct io_uring_params *p)
+static int io_uring_create(unsigned entries, struct io_uring_params *p,
+			   struct io_uring_params __user *params)
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
@@ -7853,6 +7854,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 
+	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
+			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
+
+	if (copy_to_user(params, p, sizeof(*p))) {
+		ret = -EFAULT;
+		goto err;
+	}
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
@@ -7861,9 +7870,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret < 0)
 		goto err;
 
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
@@ -7879,7 +7885,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
-	long ret;
 	int i;
 
 	if (copy_from_user(&p, params, sizeof(p)))
@@ -7894,14 +7899,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
 		return -EINVAL;
 
-	ret = io_uring_create(entries, &p);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(params, &p, sizeof(p)))
-		return -EFAULT;
-
-	return ret;
+	return  io_uring_create(entries, &p, params);
 }
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
-- 
2.17.2


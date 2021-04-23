Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F231E3689B4
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhDWAUV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWAUU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7046C061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u187so5573848wmb.0
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3TVGdd6rMT1txASSWBht30KdmwyaOj5kRf99JIhyEa0=;
        b=fAasAu/bKpuOMs0x+VF2IEeLEwGrQMmtEr79xeKDH0atrUqb56F8qz+vXN0SUKyZCZ
         A3PtPP2ubcXb+Ko2xdTSaPJc405+rioQ5zpV4wSh6yD35NCoB6Og9G77eZhdgR0dkyPo
         N2I2LKHEysMeZlbDuYGA54QytYBTS3NEAOQ90a918GmA3K+RTGybbvvadV9p6H74VH+T
         pwKQ/JWZ+b/EjJsANmY+5a6JkN0Zo18DlMHiQ/aesS9QN2MbZIv8be1kLzueDJCvKBiS
         qGClyrH4bt/FcjqaB9XUcwnBAiQl/Wr7zWn/wbqF10Dc+3wydj//eX1uLBVoycKdsOmI
         nblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3TVGdd6rMT1txASSWBht30KdmwyaOj5kRf99JIhyEa0=;
        b=XP2KSzw795qqOZI6i4I9hIV7DC7bbeY410vULk/n/mpvVKPZoADuqa6umKRpkBRKnl
         VZQD6fhn4XzRs9rXEipXKfnZnZmHutU3p0Q03h8jZRM2jPriK3W0m7WmEXlLb1ZRGJaM
         I8Of1KVICHQA+EMyYWyKSVLe/7xIwx8AWUKf1I2FrwPHw6b8nuM27C0Ksl9Pg/kE6FPh
         nfDd+EPrkL1/4Ei2GZBrRSCgQer4IVvbQhpqTjx6p3OYvpdtJzssnhJp4prBU3yrua1k
         LCOnlr/ZPOksws2Nx6lVs7h2rlwg6ZpTBNrxpez3XYo+oz0a78n+DmJZd7UbYtpWD7SF
         7nHg==
X-Gm-Message-State: AOAM532+e7I5kJTIQka/hdp6H/HFI8XenEnTQnv0+NZNn/OASAa0lV+5
        sHB+fOgLceEzNqUyQZutxgs=
X-Google-Smtp-Source: ABdhPJzKev8NVGpqFreAJrsyIdSw96i2RSsU0HTi5tUOeoiz9wC1jZ8DsaxC3SxNjs0ZWzIi4oYA4Q==
X-Received: by 2002:a05:600c:17c3:: with SMTP id y3mr2651175wmo.185.1619137183717;
        Thu, 22 Apr 2021 17:19:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/11] io_uring: enumerate dynamic resources
Date:   Fri, 23 Apr 2021 01:19:23 +0100
Message-Id: <18e4edac2e03be42253f9155320cd90ef3c028f7.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As resources are getting more support and common parts, it'll be more
convenient to index resources and use it for indexing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 16 ++++++++--------
 include/uapi/linux/io_uring.h |  4 ++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 906baaa10d09..856f508a9992 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1035,7 +1035,7 @@ static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update *up,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
@@ -5818,7 +5818,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_register_rsrc_update(ctx, IORING_REGISTER_FILES_UPDATE,
+	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
@@ -9667,7 +9667,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update *up,
 				     unsigned nr_args)
 {
@@ -9680,14 +9680,14 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
 	if (err)
 		return err;
 
-	switch (opcode) {
-	case IORING_REGISTER_FILES_UPDATE:
+	switch (type) {
+	case IORING_RSRC_FILE:
 		return __io_sqe_files_update(ctx, up, nr_args);
 	}
 	return -EINVAL;
 }
 
-static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				   void __user *arg, unsigned nr_args)
 {
 	struct io_uring_rsrc_update up;
@@ -9698,7 +9698,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
 		return -EFAULT;
 	if (up.resv)
 		return -EINVAL;
-	return __io_register_rsrc_update(ctx, opcode, &up, nr_args);
+	return __io_register_rsrc_update(ctx, type, &up, nr_args);
 }
 
 static bool io_register_op_must_quiesce(int op)
@@ -9791,7 +9791,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_register_rsrc_update(ctx, opcode, arg, nr_args);
+		ret = io_register_rsrc_update(ctx, IORING_RSRC_FILE, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
 	case IORING_REGISTER_EVENTFD_ASYNC:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5beaa6bbc6db..d363e0c4fd21 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -316,6 +316,10 @@ struct io_uring_rsrc_update {
 	__aligned_u64 data;
 };
 
+enum {
+	IORING_RSRC_FILE		= 0,
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.31.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75CF503320
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiDPA2n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 20:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiDPA2m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 20:28:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C366EBB9C
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j8so8183424pll.11
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dSXwdpuB52SuLjmFXAXoBCz/Q+io05P8oxRkfvN/SGc=;
        b=W8u9yJIJ8g6C2q4v7r+EjXzt5ZAHGQzigfV4PgB7hY4NUm0dd378BoCNSVImOCHk4K
         p2Sr1YEAM3iHEEVktwLqRF/PSOJCHacDGe0Iw9fwGjJRKtfpp+C4lgXOpinWC69TCF6V
         J0Gc+SKGsr4TIHVPms/V5sfnjlFoyWXQuJmHQKKb/qljr/Fq4Ehafd829Il0eAFlMWYS
         st0i/ofsVgc10H20JAE047zWEmLVejMO9cPeM0Lt9eIz6yWdMDzKFI7PaPVB4pZWunXO
         vfLINhYjhCNZJh4SYHsG0IdvHKTIMhooVD3Gcfutz0/gmGBY8RoBMOQ+dXB14t/RjqBl
         QcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSXwdpuB52SuLjmFXAXoBCz/Q+io05P8oxRkfvN/SGc=;
        b=UQxhiC7ByqPtPz5yQk0TimSMqsScSa8sdY4QGSfbSjV/6KB+SqcDFpNwrKWZJlFkXe
         pTZyipG1zaBDLmrjSo08rktc8QZ5DbXPolOLB0knsDIeKjVTdQOq8ZRK8b5Gd851B3h+
         sxAmpBtv4mfaS2LgWx5Hn85S1OIXtuAu1wi9MNW0Iffj4Tr/L+DYrzaN3NZeYNCCenA+
         sA4pwVSx0/AIuWTMjA4a8G9TbG+0CyrR1IZV2h/MHStvoR5MPPPiiO4yAsgSY96QXouB
         17Pl01faXOo4zzUfB3NQCGDhuXcY8m6rsln7vKyNLwHCryy0p09WSngl0Me5mudoExIo
         LbuA==
X-Gm-Message-State: AOAM531/YKtl13EHsVhSaUTEQ8Q04uqBrmfsfXQxEGRic1FjYxxxASll
        9ab4tgkqxnC/KhHo/nOpVOeVXwxege0wRg==
X-Google-Smtp-Source: ABdhPJwzVhGNafLAXRlN0xKTOSURUcrj3/AqJgN1MxrsZS4MNOD0A0vPwHrZm5ygqhlD6ZwjWvEMGg==
X-Received: by 2002:a17:90a:be16:b0:1cd:5aef:69e8 with SMTP id a22-20020a17090abe1600b001cd5aef69e8mr1401405pjs.233.1650068768229;
        Fri, 15 Apr 2022 17:26:08 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm3895375pfe.186.2022.04.15.17.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:26:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
Date:   Fri, 15 Apr 2022 18:26:01 -0600
Message-Id: <20220416002601.360026-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220416002601.360026-1-axboe@kernel.dk>
References: <20220416002601.360026-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently sqe->addr must contain the user_data of the request being
canceled. Introduce the IORING_ASYNC_CANCEL_FD flag, which tells the
kernel that we're keying off the file fd instead for cancelation. This
allows canceling any request that a) uses a file, and b) was assigned the
file based on the value being passed in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 71 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  3 ++
 2 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79601a333903..07acf7199fa7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -570,6 +570,7 @@ struct io_cancel {
 	struct file			*file;
 	u64				addr;
 	u32				flags;
+	s32				fd;
 };
 
 struct io_timeout {
@@ -975,7 +976,10 @@ struct io_defer_entry {
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	u64 data;
+	union {
+		u64 data;
+		struct file *file;
+	};
 	u32 flags;
 	int seq;
 };
@@ -6322,6 +6326,29 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 	return NULL;
 }
 
+static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
+					  struct io_cancel_data *cd)
+	__must_hold(&ctx->completion_lock)
+{
+	struct io_kiocb *req;
+	int i;
+
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry(req, list, hash_node) {
+			if (req->file != cd->file)
+				continue;
+			if (cd->seq == req->work.cancel_seq)
+				continue;
+			req->work.cancel_seq = cd->seq;
+			return req;
+		}
+	}
+	return NULL;
+}
+
 static bool io_poll_disarm(struct io_kiocb *req)
 	__must_hold(&ctx->completion_lock)
 {
@@ -6335,8 +6362,12 @@ static bool io_poll_disarm(struct io_kiocb *req)
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, false, cd);
+	struct io_kiocb *req;
 
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		req = io_poll_file_find(ctx, cd);
+	else
+		req = io_poll_find(ctx, false, cd);
 	if (!req)
 		return -ENOENT;
 	io_poll_cancel_req(req);
@@ -6785,8 +6816,13 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 
 	if (req->ctx != cd->ctx)
 		return false;
-	if (req->cqe.user_data != cd->data)
-		return false;
+	if (cd->flags & IORING_ASYNC_CANCEL_FD) {
+		if (req->file != cd->file)
+			return false;
+	} else {
+		if (req->cqe.user_data != cd->data)
+			return false;
+	}
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 		if (cd->seq == req->work.cancel_seq)
 			return false;
@@ -6841,9 +6877,11 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (ret != -ENOENT)
 		goto out;
 
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd);
-	spin_unlock_irq(&ctx->timeout_lock);
+	if (!(cd->flags & IORING_ASYNC_CANCEL_FD)) {
+		spin_lock_irq(&ctx->timeout_lock);
+		ret = io_timeout_cancel(ctx, cd);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
@@ -6854,15 +6892,17 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
 	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
-	if (req->cancel.flags & ~IORING_ASYNC_CANCEL_ALL)
+	if (req->cancel.flags & ~(IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_FD))
 		return -EINVAL;
+	if (req->cancel.flags & IORING_ASYNC_CANCEL_FD)
+		req->cancel.fd = READ_ONCE(sqe->fd);
 
 	return 0;
 }
@@ -6911,7 +6951,20 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	};
 	int ret;
 
+	if (cd.flags & IORING_ASYNC_CANCEL_FD) {
+		if (req->flags & REQ_F_FIXED_FILE)
+			req->file = io_file_get_fixed(req, req->cancel.fd, issue_flags);
+		else
+			req->file = io_file_get_normal(req, req->cancel.fd);
+		if (!req->file) {
+			ret = -EBADF;
+			goto done;
+		}
+		cd.file = req->file;
+	}
+
 	ret = __io_async_cancel(&cd, req, issue_flags);
+done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete_post(req, ret, 0);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 476e58a2837f..cc7fe82a1798 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -191,8 +191,11 @@ enum {
  * ASYNC_CANCEL flags.
  *
  * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
+ * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
+ *				request 'user_data'
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
+#define IORING_ASYNC_CANCEL_FD	(1U << 1)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.35.1


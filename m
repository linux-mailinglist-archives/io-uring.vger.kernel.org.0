Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3530502B05
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiDONjy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiDONhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:37:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7279D044
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id be5so7109932plb.13
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lxQIi9xl3EaNCcXmb88/a2xZyyur/BnErclSwROSWsw=;
        b=vXchIMJIOgGzYcMFV6RDSa/djQnspiXMUzsLf3OfNcIl8DSiiih8f1kbPX0gyrVbBt
         TCBlHq3De919aOYCVtGyOi7XvYRsEYT46u2J1xfZ9Bo8fHJfr1Pt6xOrF1A3U88iJ9P0
         B83/Y9mxTwksK9kdfjz/334KaYjJenjkk0mb4hsQn/xkHcoJAJj+y+2pEYECRn+EqeOA
         xJHBYmRi12JKNlWZvt2+bsH8XVNQZqJSqFqw+O2CAt08D6KO1b3vuR/lMya4yXg2zi1P
         Zr9T0EPbYlRMLbhja/tfC4/83eNMR7Sw1+m4pRYKBXWBfzGRwGe/npR1wVe8zTa4Y4hW
         2uxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lxQIi9xl3EaNCcXmb88/a2xZyyur/BnErclSwROSWsw=;
        b=GiXX0Mz7XDoukHz0oHNsAlQKpRdoEP35B11fTGh4P4Or5Wk9Z60WaQ8UN6SuTpqV4i
         ibaINFfoMVd14JaeA/BYAXsarL+fhJQCrzXVp/wSOURqtu6zBe+ZdmAB4zZMxSkfgCPr
         WlRo3mb55fbfr+0Go3W63mDagbpk8y9QreD8JQzqa5lvofLdyR7VDl8/S9nZCvAtT+fV
         KWOCt3uf58+/OiwGJ5In/XJe0B/EwWzkeF9iiDQAN9iH626nkmJWuHhgEnKxGWY4AWC2
         wG+o4WAUSblDXRDHoYZ11ZfDRt6UrZnecFxdekwM3YI2CWRRATIBrM4bOm6nf6L9Mhnz
         bfwg==
X-Gm-Message-State: AOAM531c73I8+KD909edIr7o1AJFdvl2jauOX37yp4Bgugvi67I9KxuM
        6wt5sUXMMQCp89m+NnPKCGD3xnJDhaK+og==
X-Google-Smtp-Source: ABdhPJzD4lGbXkDe7Rym7pHHO+t9gZahzyOpGWRu4j7BlvKNmyb8DFgGGOAIOORM2NQadMGcjvhJog==
X-Received: by 2002:a17:903:2045:b0:158:c130:31b7 with SMTP id q5-20020a170903204500b00158c13031b7mr6400948pla.154.1650029608181;
        Fri, 15 Apr 2022 06:33:28 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
Date:   Fri, 15 Apr 2022 07:33:19 -0600
Message-Id: <20220415133319.75077-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415133319.75077-1-axboe@kernel.dk>
References: <20220415133319.75077-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 65 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  3 ++
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7e5d60fbbe5..4a3dbdb36d0d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -569,6 +569,7 @@ struct io_cancel {
 	struct file			*file;
 	u64				addr;
 	u32				flags;
+	s32				fd;
 };
 
 struct io_timeout {
@@ -6307,6 +6308,26 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
 	return NULL;
 }
 
+static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
+					  struct file *file)
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
+			if (req->file != file)
+				continue;
+			return req;
+		}
+	}
+	return NULL;
+}
+
 static bool io_poll_disarm(struct io_kiocb *req)
 	__must_hold(&ctx->completion_lock)
 {
@@ -6319,15 +6340,22 @@ static bool io_poll_disarm(struct io_kiocb *req)
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	u64 data;
+	union {
+		u64 data;
+		struct file *file;
+	};
 	u32 flags;
 };
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, cd->data, false);
+	struct io_kiocb *req;
 
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		req = io_poll_file_find(ctx, cd->file);
+	else
+		req = io_poll_find(ctx, cd->data, false);
 	if (!req)
 		return -ENOENT;
 	io_poll_cancel_req(req);
@@ -6764,7 +6792,11 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->cqe.user_data == cd->data;
+	if (req->ctx != cd->ctx)
+		return false;
+	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+		return req->file == cd->file;
+	return req->cqe.user_data == cd->data;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx,
@@ -6813,9 +6845,11 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (ret != -ENOENT)
 		goto out;
 
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, cd->data);
-	spin_unlock_irq(&ctx->timeout_lock);
+	if (!(cd->flags & IORING_ASYNC_CANCEL_FD)) {
+		spin_lock_irq(&ctx->timeout_lock);
+		ret = io_timeout_cancel(ctx, cd->data);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
@@ -6826,15 +6860,17 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
@@ -6884,7 +6920,20 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
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


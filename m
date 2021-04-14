Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2728735F1A4
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhDNKsi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbhDNKsh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:37 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB22C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z24-20020a1cf4180000b029012463a9027fso10279696wma.5
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=k+UhWY5JllSfnXyoOmmt0OTh9KhdqNlULHfwRPgFz1g=;
        b=F2TjoPhXpSX2sEGs6Mh819yqrfe3g2mG6cZz0IZ0p554IXmjGPSYkCZV6YaNoulg9n
         LwlQMMiPQIZy8pbCr7Z7pFJc4jRrGNcabU5sPMMU2qwUxuY9iyRhkcQfdFuCCTdO0z7/
         64J+Ty+1FB+edvRLAZ7kYBIwHuv3SjzZD/o4Pk4Nvas7+lKmuNWf+8dXtPEduls2A9Zp
         rJ5Hhy05eZFx5rD3qsVRl0npDLYcpy6Ra8gBsKXXodjeYhiH75gwhQivcfZ5A7bUaaaL
         xub8zUnsgcNOtNoDX2KCjI/n41xmUn1dydlf5mX8PJ821m6alh6GvzzDrqurUwmZcLL6
         r88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+UhWY5JllSfnXyoOmmt0OTh9KhdqNlULHfwRPgFz1g=;
        b=hk9cGIKJqcVzKwsV56fIO13Si53hsw0D0SBZMUoGJqlfUkBgC8wqH+Y+LgdG2MqH1A
         Bd7wtseFY5NZRGNV7yLA0fDRgkJQJvJRBlIE/lQjKmi1aUL7khG8XsyMwY2zs4t777Hy
         iAuBj1rnjRHQ4XhzESmWJnkNsqtoYhlFPw4euBkAFQ+QIrCptWHw6CVqO900xX8NoDct
         Dla97tXHOvKU9PTTBy+yNiNdhxn2VTErPxKgGfDH+tplU0ccssRTxwzjh27vjL9KBagM
         ceZvg5e9dAOBPfbAT4UVgxrlaiSqXw3kfP3E8Oj0jKxDgfURNT04KlN03JqeJZGGIGv7
         sWGA==
X-Gm-Message-State: AOAM530hXbp2ttrKP2FBgw0+/6Dx4s2beao1ceiF0IB/uXkE9zHOBHEZ
        W2w76WzogmsKF1ooqsNO3MwZIyrvu1DeSQ==
X-Google-Smtp-Source: ABdhPJxiAoNBgUp5rLIToX4hMNrGbRv5hgXECJJWv3AFL3wJrPwLGYtYv8hPFkNOdULY8sl1uRrzXA==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr2366041wmq.60.1618397293843;
        Wed, 14 Apr 2021 03:48:13 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: move poll update into remove not add
Date:   Wed, 14 Apr 2021 11:43:54 +0100
Message-Id: <3ff0d0f4b251b4a3b6ea6a1a033fef84a494b42d.1618396839.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618396838.git.asml.silence@gmail.com>
References: <cover.1618396838.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Having poll update function as a part of IORING_OP_POLL_ADD is not
great, we have to do hack around struct layouts and add some overhead in
the way of more popular POLL_ADD. Even more serious drawback is that
POLL_ADD requires file and always grabs it, and so poll update, which
doesn't need it.

Incorporate poll update into IORING_OP_POLL_REMOVE instead of
IORING_OP_POLL_ADD. It also more consistent with timeout remove/update.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 104 ++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 66 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index da5061f38fd6..e8fcb894223f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -501,11 +501,6 @@ struct io_poll_update {
 	bool				update_user_data;
 };
 
-struct io_poll_remove {
-	struct file			*file;
-	u64				addr;
-};
-
 struct io_close {
 	struct file			*file;
 	int				fd;
@@ -715,7 +710,6 @@ enum {
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
-	REQ_F_POLL_UPDATE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
@@ -763,8 +757,6 @@ enum {
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
 	/* don't attempt request reissue, see io_rw_reissue() */
 	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
-	/* switches between poll and poll update */
-	REQ_F_POLL_UPDATE	= BIT(REQ_F_POLL_UPDATE_BIT),
 	/* supports async reads */
 	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
 	/* supports async writes */
@@ -795,7 +787,6 @@ struct io_kiocb {
 		struct io_rw		rw;
 		struct io_poll_iocb	poll;
 		struct io_poll_update	poll_update;
-		struct io_poll_remove	poll_remove;
 		struct io_accept	accept;
 		struct io_sync		sync;
 		struct io_cancel	cancel;
@@ -5305,35 +5296,36 @@ static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 }
 
-static int io_poll_remove_prep(struct io_kiocb *req,
+static int io_poll_update_prep(struct io_kiocb *req,
 			       const struct io_uring_sqe *sqe)
 {
+	struct io_poll_update *upd = &req->poll_update;
+	u32 flags;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
-	    sqe->poll_events)
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
+	flags = READ_ONCE(sqe->len);
+	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
+		      IORING_POLL_ADD_MULTI))
+		return -EINVAL;
+	/* meaningless without update */
+	if (flags == IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
-	req->poll_remove.addr = READ_ONCE(sqe->addr);
-	return 0;
-}
-
-/*
- * Find a running poll command that matches one specified in sqe->addr,
- * and remove it if found.
- */
-static int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
+	upd->old_user_data = READ_ONCE(sqe->addr);
+	upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
+	upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
 
-	spin_lock_irq(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, req->poll_remove.addr, true);
-	spin_unlock_irq(&ctx->completion_lock);
+	upd->new_user_data = READ_ONCE(sqe->off);
+	if (!upd->update_user_data && upd->new_user_data)
+		return -EINVAL;
+	if (upd->update_events)
+		upd->events = io_poll_parse_events(sqe, flags);
+	else if (sqe->poll32_events)
+		return -EINVAL;
 
-	if (ret < 0)
-		req_set_fail_links(req);
-	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -5356,40 +5348,22 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	u32 events, flags;
+	struct io_poll_iocb *poll = &req->poll;
+	u32 flags;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->addr)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE_EVENTS |
-			IORING_POLL_UPDATE_USER_DATA))
+	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
-	events = io_poll_parse_events(sqe, flags);
-
-	if (flags & (IORING_POLL_UPDATE_EVENTS|IORING_POLL_UPDATE_USER_DATA)) {
-		struct io_poll_update *poll_upd = &req->poll_update;
-
-		req->flags |= REQ_F_POLL_UPDATE;
-		poll_upd->events = events;
-		poll_upd->old_user_data = READ_ONCE(sqe->addr);
-		poll_upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
-		poll_upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
-		if (poll_upd->update_user_data)
-			poll_upd->new_user_data = READ_ONCE(sqe->off);
-	} else {
-		struct io_poll_iocb *poll = &req->poll;
-
-		poll->events = events;
-		if (sqe->off || sqe->addr)
-			return -EINVAL;
-	}
+	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
-static int __io_poll_add(struct io_kiocb *req)
+static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5415,7 +5389,7 @@ static int __io_poll_add(struct io_kiocb *req)
 	return ipt.error;
 }
 
-static int io_poll_update(struct io_kiocb *req)
+static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
@@ -5429,6 +5403,12 @@ static int io_poll_update(struct io_kiocb *req)
 		goto err;
 	}
 
+	if (!req->poll_update.update_events && !req->poll_update.update_user_data) {
+		completing = true;
+		ret = io_poll_remove_one(req) ? 0 : -EALREADY;
+		goto err;
+	}
+
 	/*
 	 * Don't allow racy completion with singleshot, as we cannot safely
 	 * update those. For multishot, if we're racing with completion, just
@@ -5456,14 +5436,13 @@ static int io_poll_update(struct io_kiocb *req)
 	}
 	if (req->poll_update.update_user_data)
 		preq->user_data = req->poll_update.new_user_data;
-
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* complete update request, we're done with it */
 	io_req_complete(req, ret);
 
 	if (!completing) {
-		ret = __io_poll_add(preq);
+		ret = io_poll_add(preq, issue_flags);
 		if (ret < 0) {
 			req_set_fail_links(preq);
 			io_req_complete(preq, ret);
@@ -5472,13 +5451,6 @@ static int io_poll_update(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
-{
-	if (!(req->flags & REQ_F_POLL_UPDATE))
-		return __io_poll_add(req);
-	return io_poll_update(req);
-}
-
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5883,7 +5855,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_POLL_ADD:
 		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:
-		return io_poll_remove_prep(req, sqe);
+		return io_poll_update_prep(req, sqe);
 	case IORING_OP_FSYNC:
 		return io_fsync_prep(req, sqe);
 	case IORING_OP_SYNC_FILE_RANGE:
@@ -6114,7 +6086,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_poll_add(req, issue_flags);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove(req, issue_flags);
+		ret = io_poll_update(req, issue_flags);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
 		ret = io_sync_file_range(req, issue_flags);
-- 
2.24.0


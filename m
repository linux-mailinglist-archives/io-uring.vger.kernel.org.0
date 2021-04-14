Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43335F42B
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhDNMnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbhDNMnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:20 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C65C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w4so16005322wrt.5
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3OOGOMPpErRxvPj0cOEuJgfh4itMt9irW6K/5ZA6+TM=;
        b=h+53tl/OqujwYyeKRf0L4ymfv1hpbPhydpf26zMWUGj2NgQKGzOQonbVeMzWEGW8ND
         raMLnHt+EWKIbT2igeQhSBszsvbIbFnZrSEB/U5InS26NoDEpGOKwD5vfFgdEHxYkzqf
         vPLSizlRXdjfk9zORS4S9rsJ1nmSVZ0w60fCXLgzbBBopTlZI4vvXDk/e960hfZwBpA7
         Q2HlkczB0iry4QzHiMPga1APXPNDuTuFYUoGv51L+Ow5FHsq2gGUbrKgrbk9batn+N0R
         SQY1sAnjL/xmlFQLOZE3jllXSDKuJ8pSbwAx2iQbChJrSsXcg+23bzz8yfFFbwaixuew
         7FrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OOGOMPpErRxvPj0cOEuJgfh4itMt9irW6K/5ZA6+TM=;
        b=XUfOeqcly3hq/7VdWpfKee3q+04XzA43j6RuT5e0ZnJu2R2rXoyH7SU/uxWg5zwBBq
         pRspuWRRarNYf6LFtLpvDRE477pq61oRKMnnruKwtsG9RmVslTk5KFgxJL4aecbp43Gj
         yXidAt2c2g+nvy2Zrw0HmV28zIC/62JvSNndLTxw9zN51hakUfiKi45Oq/Pe2RVem05J
         Sv1wksJMZYx9zZLW1ZO720HXBplupiB1bAbxFuqr8J2y6jiLIluavbtX4bpGJipfNUXd
         7qmjWeDw1jZRD31N/jZ4QWyBTPVYYBF4etAmfB2C38KXGrnIuxDnfjyAv4IOxh4qnoE9
         +2zQ==
X-Gm-Message-State: AOAM5338HnTYDovNg+vz/hvJ3eMILDWowaG8sPnNVKk18XLZdzS7D5fo
        1NIm3TZpMkd1JLow51pw1uWxpGdz9AC25g==
X-Google-Smtp-Source: ABdhPJw+acf3LV12Jiu5vwDZ6Bh4rODUOOQ1KNr4JiJsJA/SwRxFCiI5stFl2eFlPVbCrPRq9VsZxw==
X-Received: by 2002:adf:b301:: with SMTP id j1mr11777190wrd.301.1618404177494;
        Wed, 14 Apr 2021 05:42:57 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/5] io_uring: move poll update into remove not add
Date:   Wed, 14 Apr 2021 13:38:37 +0100
Message-Id: <8db04a970d00fab0fc693be8fbe2d95534da8ba6.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
References: <cover.1618403742.git.asml.silence@gmail.com>
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
index da5061f38fd6..e9d60dee075e 100644
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
+		ret = io_poll_remove_one(preq) ? 0 : -EALREADY;
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


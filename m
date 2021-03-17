Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2384E33F586
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhCQQaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhCQQ3t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:49 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5AFC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:49 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id v3so2071189ilj.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7QxdZAqs5jueN26xfq30PZBGHG4vQCHLs7PQxNz8xUA=;
        b=S6hdmqkRzBGxXsX4gg/1PHJhL5E8LpmfxyX3WIJoVd2cUpZagbXHtEPJXvI18mrSCK
         1pFMPzJ1UbK1JZY15Bc1wtqtX1rdXSMa+Ux891N1K2sOYyt0DwtdH96X/0aTm942MM7E
         8pYpDz8ElIaGeYrTxJo154gcSkNA1JiJaN/3jDVP96k8bHU5DkHSnr0U47SRbNFMtMf1
         s7IuemYhwuw+5yJJxxlKOKXaq/V/KyMpVuHShSZeHR10NKK0ApwCbmSZmCJ4b2KPfgYx
         xp8pgNgScBXj8RQItHb1cfVenYin011PKQ6ZBfgqZY+faG/sSnY/CS0OyKg3IiVMrR/a
         TC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7QxdZAqs5jueN26xfq30PZBGHG4vQCHLs7PQxNz8xUA=;
        b=Ky9OodGGqYPfWtAQQ+3k0usRp7dLOSYd+6g9iE2S4CNuhVUnv+3yLPDtfQkOT1Hnyv
         M9TIPyN6aJekvoM2PytxbjmptJWpL8dpNTAVUonWE1Fv+Uu8d0+9mD2qbGZG0Z+ZQlGm
         ey3+RD0SlozzM/wV2Y47dXBBkgyZnA3BE4E5CG6cgE2+5f8BNHw0nSGwMjjB4Hwa2vlA
         kClOjL+OemJwVJBCIpyofb9+KTfm2BcNf0gz7lcPfeEpOFYM/Ysw7+0eQaCvuuoqDffg
         S21SJAkQ2NbPKx8cAyV2jj06OUIqWdlDjT3muhfo34KRJ8L1gNfZdpF6YNB957TJNgw8
         MWtw==
X-Gm-Message-State: AOAM533wVZQpXRDMF++PD9uGrogSckCmVNnlnqltliK04oTNDGOSX2OJ
        W1NtuU9/yg/bX8+h4EwglGJrPv7PbtGoAQ==
X-Google-Smtp-Source: ABdhPJyKwgaBHc4ltYxQmdqT5bx+hzThZoxoAwFODtZEE+5kHsIZujtnOJ9TEWzgXA7wJ+0lMRz7Qw==
X-Received: by 2002:a05:6e02:1a2d:: with SMTP id g13mr8394796ile.216.1615998588640;
        Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] io_uring: add multishot mode for IORING_OP_POLL_ADD
Date:   Wed, 17 Mar 2021 10:29:39 -0600
Message-Id: <20210317162943.173837-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The default io_uring poll mode is one-shot, where once the event triggers,
the poll command is completed and won't trigger any further events. If
we're doing repeated polling on the same file or socket, then it can be
more efficient to do multishot, where we keep triggering whenever the
event becomes true.

This deviates from the usual norm of having one CQE per SQE submitted. Add
a CQE flag, IORING_CQE_F_MORE, which tells the application to expect
further completion events from the submitted SQE. Right now the only user
of this is POLL_ADD in multishot mode.

Since sqe->poll_events is using the space that we normally use for adding
flags to commands, use sqe->len for the flag space for POLL_ADD. Multishot
mode is selected by setting IORING_POLL_ADD_MULTI in sqe->len. An
application should expect more CQEs for the specificed SQE if the CQE is
flagged with IORING_CQE_F_MORE. In multishot mode, only cancelation or an
error will terminate the poll request, in which case the flag will be
cleared.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 63 +++++++++++++++++++++++++----------
 include/uapi/linux/io_uring.h | 12 +++++++
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 140029f730d7..c3d6f28a9147 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4908,17 +4908,25 @@ static void io_poll_remove_double(struct io_kiocb *req)
 	}
 }
 
-static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
+static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned flags = IORING_CQE_F_MORE;
 
-	if (!error && req->poll.canceled)
+	if (!error && req->poll.canceled) {
 		error = -ECANCELED;
-
-	io_poll_remove_double(req);
-	req->poll.done = true;
-	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
+		req->poll.events |= EPOLLONESHOT;
+	}
+	if (error || (req->poll.events & EPOLLONESHOT)) {
+		io_poll_remove_double(req);
+		req->poll.done = true;
+		flags = 0;
+	}
+	if (!error)
+		error = mangle_poll(mask);
+	__io_cqring_fill_event(req, error, flags);
 	io_commit_cqring(ctx);
+	return !(flags & IORING_CQE_F_MORE);
 }
 
 static void io_poll_task_func(struct callback_head *cb)
@@ -4930,14 +4938,25 @@ static void io_poll_task_func(struct callback_head *cb)
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
 	} else {
-		hash_del(&req->hash_node);
-		io_poll_complete(req, req->result, 0);
+		bool done, post_ev;
+
+		post_ev = done = io_poll_complete(req, req->result, 0);
+		if (done) {
+			hash_del(&req->hash_node);
+		} else if (!(req->poll.events & EPOLLONESHOT)) {
+			post_ev = true;
+			req->result = 0;
+			add_wait_queue(req->poll.head, &req->poll.wait);
+		}
 		spin_unlock_irq(&ctx->completion_lock);
 
-		nxt = io_put_req_find_next(req);
-		io_cqring_ev_posted(ctx);
-		if (nxt)
-			__io_req_task_submit(nxt);
+		if (post_ev)
+			io_cqring_ev_posted(ctx);
+		if (done) {
+			nxt = io_put_req_find_next(req);
+			if (nxt)
+				__io_req_task_submit(nxt);
+		}
 	}
 
 	percpu_ref_put(&ctx->refs);
@@ -4953,6 +4972,8 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
+	if (!(poll->events & EPOLLONESHOT))
+		return poll->wait.func(&poll->wait, mode, sync, key);
 
 	list_del_init(&wait->entry);
 
@@ -5118,7 +5139,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 			ipt->error = 0;
 			mask = 0;
 		}
-		if (mask || ipt->error)
+		if ((mask && (poll->events & EPOLLONESHOT)) || ipt->error)
 			list_del_init(&poll->wait.entry);
 		else if (cancel)
 			WRITE_ONCE(poll->canceled, true);
@@ -5161,7 +5182,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	req->flags |= REQ_F_POLLED;
 	req->apoll = apoll;
 
-	mask = 0;
+	mask = EPOLLONESHOT;
 	if (def->pollin)
 		mask |= POLLIN | POLLRDNORM;
 	if (def->pollout)
@@ -5334,19 +5355,24 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	u32 events;
+	u32 events, flags;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+	if (sqe->addr || sqe->ioprio || sqe->off || sqe->buf_index)
+		return -EINVAL;
+	flags = READ_ONCE(sqe->len);
+	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
 	events = READ_ONCE(sqe->poll32_events);
 #ifdef __BIG_ENDIAN
 	events = swahw32(events);
 #endif
+	if (!flags)
+		events |= EPOLLONESHOT;
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
-		       (events & EPOLLEXCLUSIVE);
+		       (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
 }
 
@@ -5370,7 +5396,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
-		io_put_req(req);
+		if (poll->events & EPOLLONESHOT)
+			io_put_req(req);
 	}
 	return ipt.error;
 }
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2514eb6b1cf2..76c967621601 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -159,6 +159,16 @@ enum {
  */
 #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
 
+/*
+ * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
+ * command flags for POLL_ADD are stored in sqe->len.
+ *
+ * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
+ *				the poll handler will continue to report
+ *				CQEs on behalf of the same SQE.
+ */
+#define IORING_POLL_ADD_MULTI	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -172,8 +182,10 @@ struct io_uring_cqe {
  * cqe->flags
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
+ * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
+#define IORING_CQE_F_MORE		(1U << 1)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
-- 
2.31.0


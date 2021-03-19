Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453873426FC
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCSUfi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhCSUf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:27 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C93C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h20so3492694plr.4
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PobN0o1Mi34M60NiiQE9AKCrlCPQjHbRKh+D1/x6JIQ=;
        b=Rx250plj0WTCeMuqwov/yNviQDFdN0vLgV9xKSKN+JaX1bFTEMWF7WijQfxaSxGTvA
         yE3fSA4sHrbboIM0MvCSA0o6z1dXnuZLwZkKi+1RqrnW9ckOIPbLX+FyJqbWs/ZG+0VY
         z9P4aarHuD0b19E3sAaJzEfqFbhRnhc5tVoEAgasIeqqV5AbVH3erNAJXUXxLe5xV/T0
         sA8ruH/0iVyaUHSZvb7mbfNVv0rmDQ2AQEw0O8FvJqwR4U30v/KvVcQHkW+DhTYxKsnT
         nTpIf69Of3zRkFy5TopluF3pMEETEVjjhMTRB86sQrgZC3U3+P2w3lV9uPWn3APQh0xF
         5Jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PobN0o1Mi34M60NiiQE9AKCrlCPQjHbRKh+D1/x6JIQ=;
        b=SnUtyRAm7OEe3TJIbtRpFRqmVd8M53v5YbkGcZxgeQ9bjMwl0xEt2DArYHtT+VDZ7+
         if0L33vwIdtUciznKXRGNd3tYDxfVH4sHcQ6DvWnqzOczbO8a5WAeE8qrvdRVgiKSSlG
         RrqYoeGHpIp3DVX4/xcRHBTz6iUOhx914Mh8N7EbkX/VK+p9MxHO7xvji+OFOML/15pN
         Fr8OdReizaxYHHTs3jfAQA6n/BuxPLNXwutuBgxzCZrPbhvaDu1ExOJqMPoZS4WyEL65
         dz82U0odJ852swdD46O4xrv3fRKDaCCawYBXbjCz6KQo9Eb/PLHc68K6siOAUNx3QCRa
         IpZg==
X-Gm-Message-State: AOAM532l75UOEK36WWAHnTpfmJ7/F8QP1fo3irvsC5yDVdOHrFDGTmtR
        ikY9D8yTSXJdyp8HcxEMyZBCvaYth9Wz4w==
X-Google-Smtp-Source: ABdhPJyRigiay0z1mgTy7ObT7blc9hOz6G3MZK6Kqv3epzLGJXzRoNdgMQg5J/UMkl7YNF3aD+4KoQ==
X-Received: by 2002:a17:903:3053:b029:e6:5cde:bef with SMTP id u19-20020a1709033053b02900e65cde0befmr15649967pla.81.1616186125877;
        Fri, 19 Mar 2021 13:35:25 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring: add multishot mode for IORING_OP_POLL_ADD
Date:   Fri, 19 Mar 2021 14:35:12 -0600
Message-Id: <20210319203516.790984-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 64 +++++++++++++++++++++++++----------
 include/uapi/linux/io_uring.h | 12 +++++++
 2 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4987bbe523c..ede66f620941 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4896,17 +4896,25 @@ static void io_poll_remove_double(struct io_kiocb *req)
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
@@ -4918,14 +4926,25 @@ static void io_poll_task_func(struct callback_head *cb)
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
 }
 
@@ -4939,6 +4958,8 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
+	if (!(poll->events & EPOLLONESHOT))
+		return poll->wait.func(&poll->wait, mode, sync, key);
 
 	list_del_init(&wait->entry);
 
@@ -5104,7 +5125,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 			ipt->error = 0;
 			mask = 0;
 		}
-		if (mask || ipt->error)
+		if ((mask && (poll->events & EPOLLONESHOT)) || ipt->error)
 			list_del_init(&poll->wait.entry);
 		else if (cancel)
 			WRITE_ONCE(poll->canceled, true);
@@ -5147,7 +5168,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	req->flags |= REQ_F_POLLED;
 	req->apoll = apoll;
 
-	mask = 0;
+	mask = EPOLLONESHOT;
 	if (def->pollin)
 		mask |= POLLIN | POLLRDNORM;
 	if (def->pollout)
@@ -5320,18 +5341,24 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
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
-	poll->events = demangle_poll(events) | (events & EPOLLEXCLUSIVE);
+	if (!flags)
+		events |= EPOLLONESHOT;
+	poll->events = demangle_poll(events) |
+				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
 }
 
@@ -5355,7 +5382,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
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


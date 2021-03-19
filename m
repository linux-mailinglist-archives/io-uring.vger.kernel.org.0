Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD193426FF
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhCSUfj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhCSUfa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23ACC06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:30 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e14so3486633plj.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GuWtFlH4kaUCnosyxNfvlWy4RUrboa3jkB3FzN1yqJ4=;
        b=peUfkFrEawXvqe/YezdxoAklw/g8KBzO8p314QY7t4gh7ttz8OQYmmgumpyVnSOH3S
         xiw4ZOwqmuED3zw6E/jayGEBtPf27Mmq+FoykjjaPt1hDIVNLGuvJ1RmFkP3VQmwKPjE
         4IOwAdy8FrjygVdG0yBKkPNYSNrJjEh8wr7jaguRhlzDxHTeCZFr1R2fK3t/1Jm9JpiQ
         gk7lM+zjS27pd4sMVImXHJnIl3LpeX88kct+P5vU0qx54FApBFTyPQ+Jqv4Vj6/ofD9j
         cAS2cfvkbe2Com2t2vOGhiZPbz7jV4dNTGez+DEhbJy+mQ1axdzfxujep6cRsuC5Ox2L
         pzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GuWtFlH4kaUCnosyxNfvlWy4RUrboa3jkB3FzN1yqJ4=;
        b=T2T5Hk4eQ94HcBdI3E2LFHEYfw0fm7ubw2yob4sunDaswLhLA42i04Bfo7T9bZYkx1
         qcBIyPKtEnaO+ACJFA77cXCGDtuqdNMd9Y671rARw3xKkpctTfdwyLkYdh4XJ7KwTlsv
         pnl4Fw8Kl0NH+ixVgsgeAi2L/AVI9VjWj44lg6tDieRJqNED7xN375VOFxnOyg/ebIlk
         RWbDnhz3MMidCzi3qDAvD0bf9k1WlcVckT0I/inmISl8a1lRA9p+3D3Fmca+3mZBP6Ja
         lhwNjAH/dD2xhQxh+MiSY1Cc1fc5vzuB2pc/PD7uu3sVQHt+mr399wiYrOJfisSqhY1C
         UImg==
X-Gm-Message-State: AOAM532e14HwSYNXnqbyjCqlmARIks3mFUk5m0fQmkhS2g5xuoKlUIgW
        CsWXu3/xP7+TsC7JOGvNry1Cxt/+ilzq2g==
X-Google-Smtp-Source: ABdhPJxwIMWTTc9p4Fq6J2gv76XLvPFZ45CGw+sUHT+EkmRLUVH/x8hHHa3z/D1r5SiDOGpbZm1lpQ==
X-Received: by 2002:a17:90a:bb8d:: with SMTP id v13mr348549pjr.12.1616186129923;
        Fri, 19 Mar 2021 13:35:29 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring: allow events and user_data update of running poll requests
Date:   Fri, 19 Mar 2021 14:35:16 -0600
Message-Id: <20210319203516.790984-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds two new POLL_ADD flags, IORING_POLL_UPDATE_EVENTS and
IORING_POLL_UPDATE_USER_DATA. As with the other POLL_ADD flag, these are
masked into sqe->len. If set, the POLL_ADD will have the following
behavior:

- sqe->addr must contain the the user_data of the poll request that
  needs to be modified. This field is otherwise invalid for a POLL_ADD
  command.

- If IORING_POLL_UPDATE_EVENTS is set, sqe->poll_events must contain the
  new mask for the existing poll request. There are no checks for whether
  these are identical or not, if a matching poll request is found, then it
  is re-armed with the new mask.

- If IORING_POLL_UPDATE_USER_DATA is set, sqe->off must contain the new
  user_data for the existing poll request.

A POLL_ADD with any of these flags set may complete with any of the
following results:

1) 0, which means that we successfully found the existing poll request
   specified, and performed the re-arm procedure. Any error from that
   re-arm will be exposed as a completion event for that original poll
   request, not for the update request.
2) -ENOENT, if no existing poll request was found with the given
   user_data.
3) -EALREADY, if the existing poll request was already in the process of
   being removed/canceled/completing.
4) -EACCES, if an attempt was made to modify an internal poll request
   (eg not one originally issued ass IORING_OP_POLL_ADD).

The usual -EINVAL cases apply as well, if any invalid fields are set
in the sqe for this command type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 90 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  5 ++
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 55a7674eb3b6..10b67041ca30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -488,7 +488,15 @@ struct io_poll_iocb {
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
-	struct wait_queue_entry		wait;
+	bool				update_events;
+	bool				update_user_data;
+	union {
+		struct wait_queue_entry	wait;
+		struct {
+			u64		old_user_data;
+			u64		new_user_data;
+		};
+	};
 };
 
 struct io_poll_remove {
@@ -4990,6 +4998,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
+	poll->update_events = poll->update_user_data = false;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5368,24 +5377,36 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->addr || sqe->ioprio || sqe->off || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~IORING_POLL_ADD_MULTI)
+	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE_EVENTS |
+			IORING_POLL_UPDATE_USER_DATA))
 		return -EINVAL;
-
 	events = READ_ONCE(sqe->poll32_events);
 #ifdef __BIG_ENDIAN
 	events = swahw32(events);
 #endif
-	if (!flags)
+	if (!(flags & IORING_POLL_ADD_MULTI))
 		events |= EPOLLONESHOT;
+	poll->update_events = poll->update_user_data = false;
+	if (flags & IORING_POLL_UPDATE_EVENTS) {
+		poll->update_events = true;
+		poll->old_user_data = READ_ONCE(sqe->addr);
+	}
+	if (flags & IORING_POLL_UPDATE_USER_DATA) {
+		poll->update_user_data = true;
+		poll->new_user_data = READ_ONCE(sqe->off);
+	}
+	if (!(poll->update_events || poll->update_user_data) &&
+	     (sqe->off || sqe->addr))
+		return -EINVAL;
 	poll->events = demangle_poll(events) |
 				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_poll_add(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5411,6 +5432,63 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	return ipt.error;
 }
 
+static int io_poll_update(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *preq;
+	int ret;
+
+	spin_lock_irq(&ctx->completion_lock);
+	preq = io_poll_find(ctx, req->poll.old_user_data);
+	if (!preq) {
+		ret = -ENOENT;
+		goto err;
+	} else if (preq->opcode != IORING_OP_POLL_ADD) {
+		/* don't allow internal poll updates */
+		ret = -EACCES;
+		goto err;
+	}
+	if (!__io_poll_remove_one(preq, &preq->poll)) {
+		/* in process of completing/removal */
+		ret = -EALREADY;
+		goto err;
+	}
+	/* we now have a detached poll request. reissue. */
+	ret = 0;
+err:
+	spin_unlock_irq(&ctx->completion_lock);
+	if (ret < 0) {
+		req_set_fail_links(req);
+		io_req_complete(req, ret);
+		return 0;
+	}
+	/* only mask one event flags, keep behavior flags */
+	if (req->poll.update_events) {
+		preq->poll.events &= ~0xffff;
+		preq->poll.events |= req->poll.events & 0xffff;
+		preq->poll.events |= IO_POLL_UNMASK;
+	}
+	if (req->poll.update_user_data)
+		preq->user_data = req->poll.new_user_data;
+
+	/* complete update request, we're done with it */
+	io_req_complete(req, ret);
+
+	ret = __io_poll_add(preq);
+	if (ret < 0) {
+		req_set_fail_links(preq);
+		io_req_complete(preq, ret);
+	}
+	return 0;
+}
+
+static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (!req->poll.update_events && !req->poll.update_user_data)
+		return __io_poll_add(req);
+	return io_poll_update(req);
+}
+
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 76c967621601..5beaa6bbc6db 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -166,8 +166,13 @@ enum {
  * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
  *				the poll handler will continue to report
  *				CQEs on behalf of the same SQE.
+ *
+ * IORING_POLL_UPDATE		Update existing poll request, matching
+ *				sqe->addr as the old user_data field.
  */
 #define IORING_POLL_ADD_MULTI	(1U << 0)
+#define IORING_POLL_UPDATE_EVENTS	(1U << 1)
+#define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.31.0


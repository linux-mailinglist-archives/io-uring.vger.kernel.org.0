Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9A33F58A
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhCQQaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhCQQ3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:52 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEE8C061760
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:52 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d2so2072744ilm.10
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pykejHNlN0C/+PLQpNubmU3gJYYWuM0u0HuebnYHgDU=;
        b=PXHc6JK28FcQKlazNYzRPzUnXtrGoF891tuKuGQiRefXW92HLgguSXFp2vUGrpmV32
         EYbzljyvOFH5U63pjT3xxA3iqLU8b+1EUq+EY5UxnHEFYhrkIswMU9YtG8lVSNMi/m+Y
         xSVSz3wNKtG+5Crh5eNyJAXReF/i2XZ/MiBqsZ65QIR1XzOWLHAqPM8t+1dRLBJ1B2qd
         tUVSXYpC2aJ08xgOTWuno8li4Ei/n9eYFMZir95esp7P3s+nud/+VZOnMImmLyqFVP6d
         0iHPM16xkGh5R7rU0tp7eHFXceYl6jEAZkrdbeRpp6g7biKIx8hGxM1zWIOrYF9Ltl+B
         /2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pykejHNlN0C/+PLQpNubmU3gJYYWuM0u0HuebnYHgDU=;
        b=OLOxYzwQPRDJ3Bh6+JCZMsvNherYpLrrTUy0oDYWoTqNzBjNc4FhhwIp1TKzMLPfFL
         z15EBmGMS9P0qJCm1+oT0W1mYWzqhYorvyjhGRyogLmsgYmurZfN4RAzt4IHqZl2GL04
         mUd6USgBxJxgij9yeCJvnfzu6cIg0rnEv3MQKj2Lz7DCFD/2s+USBxSYrllWjrAM6enz
         vh6/c32WTZaYBNCK3uifH/gXfO+9mHEKvlW8I0mQMaNTxRAH8fVDaTZ0d4nwx1tCUIkE
         NxvKQiNZXyo76LnlQTjJffsneljBYwDgrpsT+h0E9Kp9AhQEVuHEx6asdjpz1D+/s8+j
         8Xdg==
X-Gm-Message-State: AOAM5307dYmU27LS6fqlqlLCpBatRq5E2edRHCiJE48T+t7sgfe38zSj
        snWQZ2vnnZHvZHX1+s5e/Pgoxls9GkAW3A==
X-Google-Smtp-Source: ABdhPJyR1ZSj95lpYl8Y8zxAncxiMTdKT/aJm+LYspbASpbojvVHMdIZOrVmMD1E9dR8L5EelpHZFw==
X-Received: by 2002:a05:6e02:f06:: with SMTP id x6mr7309138ilj.287.1615998591414;
        Wed, 17 Mar 2021 09:29:51 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring: allow events update of running poll requests
Date:   Wed, 17 Mar 2021 10:29:43 -0600
Message-Id: <20210317162943.173837-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds a new POLL_ADD flag, IORING_POLL_UPDATE. As with the other
POLL_ADD flag, this one is masked into sqe->len. If set, the POLL_ADD
will have the following behavior:

- sqe->addr must contain the the user_data of the poll request that
  needs to be modified. This field is otherwise invalid for a POLL_ADD
  command.

- sqe->poll_events must contain the new mask for the existing poll
  request. There are no checks for whether these are identical or not,
  if a matching poll request is found, then it is re-armed with the new
  mask.

A POLL_ADD with the IORING_POLL_UPDATE flag set may complete with any
of the following results:

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
 fs/io_uring.c                 | 73 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  4 ++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ed363bd95aa..79a40364e041 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -467,10 +467,14 @@ struct io_ring_ctx {
  */
 struct io_poll_iocb {
 	struct file			*file;
-	struct wait_queue_head		*head;
+	union {
+		struct wait_queue_head	*head;
+		u64			addr;
+	};
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
+	bool				update;
 	struct wait_queue_entry		wait;
 };
 
@@ -5004,6 +5008,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
+	poll->update = false;
 	poll->events = events;
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, wake_func);
@@ -5382,24 +5387,32 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->addr || sqe->ioprio || sqe->off || sqe->buf_index)
+	if (sqe->ioprio || sqe->off || sqe->buf_index)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~IORING_POLL_ADD_MULTI)
+	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE))
 		return -EINVAL;
 
 	events = READ_ONCE(sqe->poll32_events);
 #ifdef __BIG_ENDIAN
 	events = swahw32(events);
 #endif
-	if (!flags)
+	if (!(flags & IORING_POLL_ADD_MULTI))
 		events |= EPOLLONESHOT;
+	if (flags & IORING_POLL_UPDATE) {
+		poll->update = true;
+		poll->addr = READ_ONCE(sqe->addr);
+	} else {
+		if (sqe->addr)
+			return -EINVAL;
+		poll->update = false;
+	}
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
 		       (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_poll_add(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5425,6 +5438,56 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	return ipt.error;
 }
 
+static int io_poll_update(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *preq;
+	int ret;
+
+	spin_lock_irq(&ctx->completion_lock);
+	preq = io_poll_find(ctx, req->poll.addr);
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
+finish:
+		io_req_complete(req, ret);
+		return 0;
+	}
+	/* only mask one event flags, keep behavior flags */
+	preq->poll.events &= ~0xffff;
+	preq->poll.events |= req->poll.events & 0xffff;
+	ret = __io_poll_add(preq);
+	if (ret < 0) {
+		req_set_fail_links(preq);
+		io_req_complete(preq, ret);
+	}
+	ret = 0;
+	goto finish;
+}
+
+static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (!req->poll.update)
+		return __io_poll_add(req);
+	return io_poll_update(req);
+}
+
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 76c967621601..44fe7f80c851 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -166,8 +166,12 @@ enum {
  * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
  *				the poll handler will continue to report
  *				CQEs on behalf of the same SQE.
+ *
+ * IORING_POLL_UPDATE		Update existing poll request, matching
+ *				sqe->addr as the old user_data field.
  */
 #define IORING_POLL_ADD_MULTI	(1U << 0)
+#define IORING_POLL_UPDATE	(1U << 1)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.31.0


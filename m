Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90565124EF0
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLRRSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:51 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37766 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:51 -0500
Received: by mail-io1-f66.google.com with SMTP id k24so2784054ioc.4
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Te5VqN4BwrjFDkO8n7MgBKaApji0u90VXcr3sKPPmMY=;
        b=SFSoIS/YEzL5MfnQWaS7PvCB8F+5SfDPpg1p7tMmPWGdbAcV1S+YHk78PSkv2AURH9
         49z0AZzeK6z/sVGuoVyKcxBOykmw88zi/JZV5p3Xrm+lViFbWO1j67/wPGvmMaL/62MJ
         cYfrDY5HwFlttO226W7gIIF2LI2irViP6O9EwccEgU95lRqzojjjiNMbbd4LANhfm02G
         PokzSoGXCQtjWbRidFGO9btYN9/DUEhomCvdPtZ7eBhVCp8kAYYFP22yjO+vxYnbB/Hc
         pWMwvOrmd2yyrpGd9N5IbsWombgqCd5Hx10BIZbtUxaytOQwFSL46C4zMLz0RN/uKRBd
         mDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Te5VqN4BwrjFDkO8n7MgBKaApji0u90VXcr3sKPPmMY=;
        b=Asn9zNG04oLfr2McPEts39+jQVW+rLzKIHBlNU32TbzO0ueDOfV1s2LRPzPLbqrFj0
         9Sr2jZy4nrvcpr4/9Fg2YI1JQjD7mUqMR3hu8Ui/R8DGDEqTrS0ZNN7+b8oRl1YmvWPo
         h47RzaZsRrCVE/Wy2j4pkkVrdOwhIgsOcbjtYlNQXroVEQBLr7bOUKJhdwgyxFhslIyT
         y4lxcJ9fk2d9qB6Y9NKnx0Lw9ni5QcKQs374g5OkTrhS5l47t8gne1V93E38EIddUaZ/
         rl0QdE5WiZWAa6W/8ebv2lwwVcVQMYRmCo0NSK96bcg4QVDs8oGBMGuJkZ/jECqCyoXl
         P5qQ==
X-Gm-Message-State: APjAAAVSyJ6SM4QFzbXUpupkhe1a11oqfj+OUV+OKcqW6l9SjgfRgLBW
        vaGjSs8iDaCnfUKYyQTEiKVCVzrlpUXsjw==
X-Google-Smtp-Source: APXvYqz8JZU6ZSHrCLyYehezgvbMxlLup7Yh7uyJ6N9ta6qA+vJch0phhLDbgKhiMZZUI99qilmh7A==
X-Received: by 2002:a05:6602:248b:: with SMTP id g11mr1805430ioe.139.1576689530209;
        Wed, 18 Dec 2019 09:18:50 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/13] io_uring: make IORING_POLL_ADD and IORING_POLL_REMOVE deferrable
Date:   Wed, 18 Dec 2019 10:18:30 -0700
Message-Id: <20191218171835.13315-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we defer these commands as part of a link, we have to make sure that
the SQE data has been read upfront. Integrate the poll add/remove into
the prep handling to make it safe for SQE reuse.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 68 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12cc641eb833..aa5d6232c536 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -289,7 +289,10 @@ struct io_ring_ctx {
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
@@ -2488,24 +2491,40 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	return -ENOENT;
 }
 
+static int io_poll_remove_prep(struct io_kiocb *req)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	    sqe->poll_events)
+		return -EINVAL;
+
+	req->poll.addr = READ_ONCE(sqe->addr);
+	req->flags |= REQ_F_PREPPED;
+	return 0;
+}
+
 /*
  * Find a running poll command that matches one specified in sqe->addr,
  * and remove it if found.
  */
 static int io_poll_remove(struct io_kiocb *req)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
+	u64 addr;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
-	    sqe->poll_events)
-		return -EINVAL;
+	ret = io_poll_remove_prep(req);
+	if (ret)
+		return ret;
 
+	addr = req->poll.addr;
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, READ_ONCE(sqe->addr));
+	ret = io_poll_cancel(ctx, addr);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_add_event(req, ret);
@@ -2640,16 +2659,14 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, list);
 }
 
-static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_poll_add_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_poll_iocb *poll = &req->poll;
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_poll_table ipt;
-	bool cancel = false;
-	__poll_t mask;
 	u16 events;
 
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
@@ -2657,9 +2674,26 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (!poll->file)
 		return -EBADF;
 
-	INIT_IO_WORK(&req->work, io_poll_complete_work);
+	req->flags |= REQ_F_PREPPED;
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+	return 0;
+}
+
+static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_poll_iocb *poll = &req->poll;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_poll_table ipt;
+	bool cancel = false;
+	__poll_t mask;
+	int ret;
+
+	ret = io_poll_add_prep(req);
+	if (ret)
+		return ret;
+
+	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	INIT_HLIST_NODE(&req->hash_node);
 
 	poll->head = NULL;
@@ -3027,6 +3061,12 @@ static int io_req_defer_prep(struct io_kiocb *req)
 		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
 		ret = 0;
 		break;
+	case IORING_OP_POLL_ADD:
+		ret = io_poll_add_prep(req);
+		break;
+	case IORING_OP_POLL_REMOVE:
+		ret = io_poll_remove_prep(req);
+		break;
 	case IORING_OP_FSYNC:
 		ret = io_prep_fsync(req);
 		break;
-- 
2.24.1


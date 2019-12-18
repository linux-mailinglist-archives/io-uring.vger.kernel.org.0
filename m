Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D529123DEE
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLRD2M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40622 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id q8so402282pfh.7
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WbrMhYgAdgbft2LW1Hhj63dpm1O7fAS166F8GCfFS9w=;
        b=K+imQ1dYQHt2SNq6ajZmkgfJWSPUOsuQ3gLt2UoeDQ+Tx7j4UqczSGEKZS0UvMPbtG
         rFH3Z/ZAiAUhOhfQTMugDkFyAwESkfhD8CIP5P2Hwg9OE9UZ2cfSIxv9UU0vw7WPmP8S
         M4nPloCywyYazt5rEek4kFM4xi1Bj4GfUgr0X2U4OeLmdjZ/5F/D3QVjy2TNxUpQk691
         4jUK4uP2SCPN6qZTUyVQT4TGXpoeDTw/2W+ePXHCVGruY14/eigbr2M3G4717DKe3kHh
         Bqp40D88Pv80x80jIWeMH1SfTiTh3TxUEzpP8Hl1lRLCTnskKRONphQR/Jntysrosuk3
         JCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WbrMhYgAdgbft2LW1Hhj63dpm1O7fAS166F8GCfFS9w=;
        b=ATKVp/Uj3dAX1ErNzmSLvLIJyMaOXKXodBjMyWnH894alf1xvA3lvg8ObfzJKAm0sd
         c0aSD8Op1VFl1adtyGjMDgojzsKESwikvghaqExF50IMOYFyC2M+kdZcwKb8yy+MvNRH
         KVTP+oPUEPthNBzKiCEVX7SdlIKDSGjCyfJYkDBrsmIIBDa1bli1NMbCijSwOYfG0+aw
         7ONSlcF8HLd85VoAEXMdbhEjT5taNJ5L5xr5BlUtv15bkpPINv0/QmhdvntJwvhNQtCe
         XdePB3B3hvG8/StQ3tsr1iVyn3biOS0qYJ5zM6kiR/B2VNFVCp+9gGP5/yFKQ/DIAIyI
         eJBA==
X-Gm-Message-State: APjAAAV1VhHC5ry7XiJoRFf2jkrO+/aATrnGfzMiNN3fnT5fqEjQOHHb
        o5Oh/L81IojJp7ehViJr1TRhc3HYVk3lYA==
X-Google-Smtp-Source: APXvYqxr29/BQhs+zWaA9Kwwvidfewf4pesV48K5XBHUrmYcwQ0ddwLDxqpqGaFCGz2P9HN2ksBwSQ==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr487341pfm.77.1576639691008;
        Tue, 17 Dec 2019 19:28:11 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] io_uring: make IORING_POLL_ADD and IORING_POLL_REMOVE deferrable
Date:   Tue, 17 Dec 2019 20:27:55 -0700
Message-Id: <20191218032759.13587-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
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
index c8d741dd70dd..0ce91165d918 100644
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
@@ -2485,24 +2488,40 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
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
@@ -2637,16 +2656,14 @@ static void io_poll_req_insert(struct io_kiocb *req)
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
@@ -2654,9 +2671,26 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
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
@@ -3024,6 +3058,12 @@ static int io_req_defer_prep(struct io_kiocb *req)
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


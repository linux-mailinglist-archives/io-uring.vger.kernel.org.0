Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FB6124EED
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLRRSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:48 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44382 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:48 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so2326319iln.11
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Ajt3bKs4/N7Rp9wxPH6KfntcJEI/7oMPDlJVvKUcBU=;
        b=jNOBb3qrA1LqSZwPpC+JRIOGG3Nh/n3iWw/rhN3QABApw/zUpRwzX+1HQdUbxW10nP
         QaoLhMf1N3c/D8xqRva1t729kL0ZLgoNZ9Xvr3FZO0jL8QsljmIodaQniErUaJl91JB9
         nMMK87H9Z+GNA2F9DLRE/ODAcecklVxOpGDeRnL3ZeDlGBfgc3oMXoVlhMw40M/VXw15
         FieXWIDiyLzjTy+O6PhLXiWS7cb9pbTR2SvPAdSOtZfF8gJJdXqVXA3KiTO8rylQ2Jna
         mgA33ml/p83XuBlcKe+C8hwPOno17e+FQ2zc7+amwo3c7ivEOSrTzajoVQBBnbpAGLhS
         SxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Ajt3bKs4/N7Rp9wxPH6KfntcJEI/7oMPDlJVvKUcBU=;
        b=L40qzyL50+S6h3KmqJPKwnUW3/Lt4xaxBkltLLBQ3cO1N15IvJ4Adgf2okvOm+vgMb
         PcxEcrzMHMiejrbZ6G4BY9eTDqj6w4qHnS4b7/IqX/uiQebFehI0TPV5/pBgFpCh/XFJ
         SMUYAdjcGkbAm5PYL3nRevq/HrA58BeH9ZE7ddJ8+01SvGk0L91n/hmu4yQ6f+3NV0ck
         j8HwUJqV1EyF2EgWoZDVcXM9VCCy+gnJED9xlg6q/xpJeY/6gr+XzTaDoBnhH7kx82EM
         9TF5OTf8o5Od7bjdPauTKZpVeZEmgxQjVbWhxW2Rny5bs6PRw7BeOJ8UZ3fscYr2+YBw
         xJaA==
X-Gm-Message-State: APjAAAVI0Cq8DZlHQQ1SKBzIjhYyqa1zA0qMb2JzpGWWT8VYVfoXoi3C
        NdffuBf+Q3RmU3Kie9B9N+6UJ7gJKKxkcQ==
X-Google-Smtp-Source: APXvYqxN6G97QZ+AYwALl3B4BJ7J++a6knpvNNNpDXJ/nYl6l39JQ6AOYrRndkrXqKPxODHmHnEoAA==
X-Received: by 2002:a92:2a06:: with SMTP id r6mr2998723ile.13.1576689527504;
        Wed, 18 Dec 2019 09:18:47 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/13] io_uring: remove 'sqe' parameter to the OP helpers that take it
Date:   Wed, 18 Dec 2019 10:18:27 -0700
Message-Id: <20191218171835.13315-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass in req->sqe for all of them, no need to pass it in as the
request is always passed in. This is a necessary prep patch to be
able to cleanup/fix the request prep path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 80 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 582c7c19bdd7..0298dd0abac0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1949,8 +1949,9 @@ static int io_nop(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_fsync(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!req->file)
@@ -1964,9 +1965,10 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		    struct io_kiocb **nxt, bool force_nonblock)
+static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
+		    bool force_nonblock)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	loff_t sqe_off = READ_ONCE(sqe->off);
 	loff_t sqe_len = READ_ONCE(sqe->len);
 	loff_t end = sqe_off + sqe_len;
@@ -1977,7 +1979,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(fsync_flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
 
-	ret = io_prep_fsync(req, sqe);
+	ret = io_prep_fsync(req);
 	if (ret)
 		return ret;
 
@@ -1996,8 +1998,9 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_sfr(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret = 0;
 
@@ -2012,17 +2015,16 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
-static int io_sync_file_range(struct io_kiocb *req,
-			      const struct io_uring_sqe *sqe,
-			      struct io_kiocb **nxt,
+static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	loff_t sqe_off;
 	loff_t sqe_len;
 	unsigned flags;
 	int ret;
 
-	ret = io_prep_sfr(req, sqe);
+	ret = io_prep_sfr(req);
 	if (ret)
 		return ret;
 
@@ -2072,10 +2074,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #endif
 }
 
-static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -2154,10 +2157,11 @@ static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #endif
 }
 
-static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -2222,10 +2226,11 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 #endif
 }
 
-static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		     struct io_kiocb **nxt, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
+		     bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct sockaddr __user *addr;
 	int __user *addr_len;
 	unsigned file_flags;
@@ -2273,10 +2278,11 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #endif
 }
 
-static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
+static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
 	int addr_len, ret;
@@ -2374,8 +2380,9 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
  * Find a running poll command that matches one specified in sqe->addr,
  * and remove it if found.
  */
-static int io_poll_remove(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_poll_remove(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
@@ -2521,9 +2528,9 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, list);
 }
 
-static int io_poll_add(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		       struct io_kiocb **nxt)
+static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
@@ -2660,9 +2667,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 /*
  * Remove or update an existing timeout command
  */
-static int io_timeout_remove(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
+static int io_timeout_remove(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags;
 	int ret;
@@ -2721,8 +2728,9 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 	return 0;
 }
 
-static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_timeout(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
@@ -2862,9 +2870,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   struct io_kiocb **nxt)
+static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
@@ -2987,37 +2995,37 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 		ret = io_write(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_FSYNC:
-		ret = io_fsync(req, req->sqe, nxt, force_nonblock);
+		ret = io_fsync(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
-		ret = io_poll_add(req, req->sqe, nxt);
+		ret = io_poll_add(req, nxt);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove(req, req->sqe);
+		ret = io_poll_remove(req);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_sync_file_range(req, req->sqe, nxt, force_nonblock);
+		ret = io_sync_file_range(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
-		ret = io_sendmsg(req, req->sqe, nxt, force_nonblock);
+		ret = io_sendmsg(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_RECVMSG:
-		ret = io_recvmsg(req, req->sqe, nxt, force_nonblock);
+		ret = io_recvmsg(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_TIMEOUT:
-		ret = io_timeout(req, req->sqe);
+		ret = io_timeout(req);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove(req, req->sqe);
+		ret = io_timeout_remove(req);
 		break;
 	case IORING_OP_ACCEPT:
-		ret = io_accept(req, req->sqe, nxt, force_nonblock);
+		ret = io_accept(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_CONNECT:
-		ret = io_connect(req, req->sqe, nxt, force_nonblock);
+		ret = io_connect(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel(req, req->sqe, nxt);
+		ret = io_async_cancel(req, nxt);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.24.1


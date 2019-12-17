Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3393D123A4F
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfLQWyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:55 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41912 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLQWyy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:54 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so111312pgk.8
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ip+1xxnuonTLoEKd2CuKImyrGtNwdjNdgOTknMh4hYM=;
        b=sPnRprpILkBecraryvMKK1KtG9n0s4u0ArLcM8Ls1KNHiQaMk1PmqHuVhwvssFHCip
         D1WBvKEYllW6deaE/UsNDpnILuhyjVhlx+ByACxmmHrTd5eJuqXlxRHrtC2lwhLBT/UX
         guNqz9w4nxZWVj1t3nv66ikyRWrx91MzdOm9PDdfZbzWzJkC2xSKlEF8u0cFdn6/60fz
         Y0Bn7cFOHNpptc+7iTojgmy1ObruvJVO/HawbMxAequlYBERd5IqW+Jxkh0RdM00wPfB
         Fx691gKlkqcXsZ6JLkUFZMrxyHVkY6x4c+IILWJsZ4EbOru4O51RRhCyUaP0lqlq1m4A
         KgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ip+1xxnuonTLoEKd2CuKImyrGtNwdjNdgOTknMh4hYM=;
        b=jMJ43q9b1KuFlDzwTwS2c1gqYNcX8RkZrMUdXx/gODrV2emffO1i05oJXdkWP62Bxn
         +jCpwpMGwx78QudJ9nfXPfJpcBAah4l94INL9ehpPmwPe/YRiHWltu9D7bvX02yolVAY
         9WDDnoPLBT5xFXXMc/YPKn/qqn2NkZACDXdHVGjjxo+zlkiDJDS4ysuP3gQ/fq7aBnpg
         XVze57bH/h6ROdVmhX45g/i8Dv9u0P1b3tIOm5vr8Te1SAITrtI90U4dyE6MnWWqIcwD
         oDRLUbwtWf+cEHZfdxHUSniwMAOQ3PGbFGfPvA9ZHieeCwzXCKwgtt5TwkSk7k6wZtC+
         Xgrg==
X-Gm-Message-State: APjAAAURv36zwj1RVju9qr29JqNnANWB9AK0Q/p6Sb66KvL+BwmnAU1A
        lC2qxL/hp2TUVo0hktU8zTn3DwEivcqSCw==
X-Google-Smtp-Source: APXvYqx0c6vGxHBTLMNxq5SyTT2L9W7/0BorWUYkSAOSJN7odjchXfbFsB4DlEA07P4rKONvkGvzZA==
X-Received: by 2002:a63:f814:: with SMTP id n20mr27756833pgh.318.1576623293336;
        Tue, 17 Dec 2019 14:54:53 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring: remove 'sqe' parameter to the OP helpers that take it
Date:   Tue, 17 Dec 2019 15:54:43 -0700
Message-Id: <20191217225445.10739-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
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
index ff89fde0c606..5f6dd4d3215e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1951,8 +1951,9 @@ static int io_nop(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_fsync(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!req->file)
@@ -1966,9 +1967,10 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -1979,7 +1981,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(fsync_flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
 
-	ret = io_prep_fsync(req, sqe);
+	ret = io_prep_fsync(req);
 	if (ret)
 		return ret;
 
@@ -1998,8 +2000,9 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_sfr(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret = 0;
 
@@ -2014,17 +2017,16 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -2067,10 +2069,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
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
@@ -2151,10 +2154,11 @@ static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
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
@@ -2221,10 +2225,11 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2272,10 +2277,11 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
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
@@ -2373,8 +2379,9 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
  * Find a running poll command that matches one specified in sqe->addr,
  * and remove it if found.
  */
-static int io_poll_remove(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_poll_remove(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
@@ -2520,9 +2527,9 @@ static void io_poll_req_insert(struct io_kiocb *req)
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
@@ -2659,9 +2666,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
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
@@ -2720,8 +2727,9 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 	return 0;
 }
 
-static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_timeout(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
@@ -2861,9 +2869,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   struct io_kiocb **nxt)
+static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
@@ -2986,37 +2994,37 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
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


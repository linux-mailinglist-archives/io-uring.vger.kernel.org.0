Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E922123DEB
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLRD2J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44241 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:09 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so445070pgl.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVx3efgwJoxBa0SAUEjlz/gzZrDC+JD/pdvm0I8T2Ms=;
        b=bbDXs+IsKT9qZnDOHo7jQNrItNKjiktR7vgnTDF+MqMJQQ0wmR9hHGS9TxSad6hB5U
         NmVqwIeyy1ArcZEwyBnLIsFqva2hj9m461FuIztXv5obmdVfN+d0YlxjetSbyoGDwG6E
         D3PcjBHSPYKwiDS+uSgUSdbaLWiDA/t8xxThBd3VMPmwFreiNoOzO0HMTYqNKMxk0Kku
         9V9v2Bk570rrxCr+IUFX5pDFowBuzhVNoU7AQM2Dy8sXY6HFoH7ej1uOaFHaDSkJ+TXa
         VXcI60rFs3puR4SW/a2Hsg0npDzzx+AZTv3Qil/aOiktXpEXqr/F3wKBlHQGXd+bbaVk
         O9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVx3efgwJoxBa0SAUEjlz/gzZrDC+JD/pdvm0I8T2Ms=;
        b=clMiP3HKkpJ+nHi5MEYNDxOApaisikeli3V+LEAPqW+tgqVglin5HGslY86/Qte0Yr
         O82eCqYTFMLnPk0nHwEw+KeDa14oF7LQ+L1OWPKDu4ilSv923UauregMETHdtKE4sui+
         2iISkiyfYdxyx5IodRI43NNaYPsNg4wzKC0YrYolaaRnmtje8W0TQHsp/gY8Jw37yjIM
         To7QQwPlzxUEghSisYjT/lBJgGyZafu1eS4STsglnn5fPJMLsneiDyEF0OYcFfv7Xfqo
         iiwbzQbIohdCwqzc3qXrMuLsqvqpt8xl6kYzrnRAjVgqdkwlEtjC202rCNGWyR6XmoBa
         Ofyg==
X-Gm-Message-State: APjAAAUiQfi6ZUfvEEX0nKXE1qHAh4LiSXITYKIllCImbHznETFY66Cu
        fE4i/xFMc2I9udCdHmEDKSlY2TRyj94uSA==
X-Google-Smtp-Source: APXvYqwbQz8yc6Sm8BILhgoBmqk9xE9J6cEEyohABJGVvuxtq/Lei9yoD/vfarhceCNoByp+PtjO1w==
X-Received: by 2002:a63:1908:: with SMTP id z8mr370367pgl.350.1576639687609;
        Tue, 17 Dec 2019 19:28:07 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] io_uring: remove 'sqe' parameter to the OP helpers that take it
Date:   Tue, 17 Dec 2019 20:27:52 -0700
Message-Id: <20191218032759.13587-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
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
index bd4c3ee73679..737df6b3ad46 100644
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


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C0411EA6C
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfLMSgj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:39 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38341 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728796AbfLMSgj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:39 -0500
Received: by mail-io1-f66.google.com with SMTP id v3so646660ioj.5
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDUqcu+adYDMcMU6/EFVyAPb/sLSQjvOYyTK/khqmpA=;
        b=Apjh+3ZVKDV4kZadKJmQliMsIUrKluPYMUj8+S2X6J/ARd5sgW3cXRIHTjM3Cypps+
         8QnvPkIc1Ceo8ZwO0nsxskDf3cH1P8BEajfkve12A/af13r6lzxybM67FAyY0d/T/Uoa
         9oFO9by1yDBEvjeovKkcWqYJE1WSIMtPkIaujjt9LVWX7BnoD7FpfFeXgK/qH4JpGLWW
         r7mO0i+qdPp0ih6xMuK3kv0nMp4vLMv1/ZXh2MtjU6pJ8MGb9LgFKhkiWtuyYO9jxk0t
         7kj1ZBXO9PxA9zHVPV/6XYQi1m4IHeajOMrbFIhdjOkf1vAHfJxcDHz65bWl5mfm/KEE
         ii8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDUqcu+adYDMcMU6/EFVyAPb/sLSQjvOYyTK/khqmpA=;
        b=Z8oCwhGStowQhRoSGvwrunHLq/+PqJtUufU2nwfzLFUdBXw6/NYWzzG4gP12TyknkX
         Y2Xtrr5GJWaxciZ1N//S2i0gW4SP/8TK2OPWmACT3mEolLlF7OVif5oHwTtw5rhPJ8YZ
         HbhvLLfEg8ZWxKYrMsXWVyUUOaNamwH0AZP7gLdqWMv4dOLGbD6moP0odSk/DsJgGoNK
         axLQ7JDY93sAXGdoHDCC5NGzM2vK2kGFwriAiNiV4HhhpbsfuOyr54WIN4wlG0KKr58g
         TukeXtElHwYoao9GdW/RAbzsHBOhhlccz/4cFDdRWu8EFpxPNf4UrGuAXMGLMiZjcWrR
         1eLw==
X-Gm-Message-State: APjAAAVAsXxYojQ76olnRqeMFU/m0zEpN/5hLmebONUPIoreZiEcqXC5
        s/NNnNARB4gRplaO1+lQdJKwMRV/LqYQ5A==
X-Google-Smtp-Source: APXvYqyhYSrShu4t5lmex2rg/G6YW20jOm7tKkserSYRxDlssPaawHzLrCD3N1iKhaZNI7uSN3xXfQ==
X-Received: by 2002:a02:9988:: with SMTP id a8mr767767jal.33.1576262197885;
        Fri, 13 Dec 2019 10:36:37 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/10] io_uring: remove 'sqe' parameter to the OP helpers that take it
Date:   Fri, 13 Dec 2019 11:36:24 -0700
Message-Id: <20191213183632.19441-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass in req->sqe for all of them, no need to pass it in as the
request is always passed in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 70 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d780477b9a56..93a967cf3f9f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1942,9 +1942,10 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -2016,11 +2017,10 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -2063,10 +2063,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #endif
 }
 
-static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct socket *sock;
 	int ret;
 
@@ -2142,10 +2143,11 @@ static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #endif
 }
 
-static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct socket *sock;
 	int ret;
 
@@ -2207,10 +2209,11 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2258,10 +2261,11 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
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
@@ -2361,8 +2365,9 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
  * Find a running poll command that matches one specified in sqe->addr,
  * and remove it if found.
  */
-static int io_poll_remove(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_poll_remove(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
@@ -2508,9 +2513,9 @@ static void io_poll_req_insert(struct io_kiocb *req)
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
@@ -2648,9 +2653,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
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
@@ -2710,8 +2715,9 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 	return 0;
 }
 
-static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_timeout(struct io_kiocb *req)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
@@ -2857,9 +2863,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   struct io_kiocb **nxt)
+static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
@@ -2977,37 +2983,37 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
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
 	case IORING_OP_FALLOCATE:
 		ret = io_fallocate(req, nxt, force_nonblock);
-- 
2.24.1


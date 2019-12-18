Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9F1123DF0
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLRD2O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36102 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:14 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so413015pfb.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NTL8K6lauSIEj5rxFR3QFJq+fApU2iFW61cq+sTzRok=;
        b=N4zZkR7IFdP3sDAeWmbuVkDunmM415dtUJvFx7I8tNWapu+6c2IdAsBMNtT6zDvrEc
         vKz6+BrZ/ZqzzZFv4GOF6Zra4pXmi1OnT8Cdd8IClzK3ZIXKksYoLwDNoTfJDLh273+P
         A9Y02++iGbXUNv4D5CpFntHmfCg5zs9cFV454INlW/0W2YFXnM6zfi9fy4+HUMB0wzNv
         YdwHcwevsFNz3IzAFP9n1KCn1+jWyEIpXvY3WfHjnEViIhjyPrsgxXDVae3fpAiwhrLp
         35B4+d+SLZ3h69PyY4qqAZUmGEuLrRnW4ZCPY9A5PBjhhlMVB0s72wbzlSSS2StXasWh
         +MvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NTL8K6lauSIEj5rxFR3QFJq+fApU2iFW61cq+sTzRok=;
        b=ta+C/45jk+R34t/D3g3AouguAix6n8O3Yvr+XWd/7KjzHsY4B8uC0SF/lyksHSxsjP
         vQWt/F8X692vxo8v44O3gNx2xKSQNhfGWoCWk1xVt+r8VMMGESujDSf6DsL2fd0nquKD
         q+qcoza8tzfxxvNAHvQx/JD2O8ah+txAzRQIkOzr+Wwluf7tIJNrZYBX6xkQAOF3lPiC
         PqkwLB3ZIyrFYSeejr8ArooujCkFYEi1+tNxI0Ot8cjAm7mB5UAkITqNziK7O5JSnxx5
         x7im5YfGTGeI6Z2JiHnFsJQ9aKxeSru62KXYOMXpMlI0zk7WyRFTSYCzpWl0/9M7PvHI
         JnSQ==
X-Gm-Message-State: APjAAAVgTZjTr/WF+z/4Ai1c9hIrUqNFG5iK0pQGthm5S9W6v6Pc7kni
        tL5/s2X1jRnli7RaYK+W/Ocl0PdngQcWUQ==
X-Google-Smtp-Source: APXvYqxeogymyFoIRtal0mZLaEG3mff4MwHXfH4BY1tMhu9OyiT69R8gee4er4LWfmjWgdazTeMbmg==
X-Received: by 2002:a63:504f:: with SMTP id q15mr398399pgl.8.1576639693185;
        Tue, 17 Dec 2019 19:28:13 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/11] io_uring: make IORING_OP_TIMEOUT_REMOVE deferrable
Date:   Tue, 17 Dec 2019 20:27:57 -0700
Message-Id: <20191218032759.13587-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we defer this command as part of a link, we have to make sure that
the SQE data has been read upfront. Integrate the timeout remove op into
the prep handling to make it safe for SQE reuse.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bee98f6281fa..45d2090484a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,12 @@ struct io_cancel {
 	u64				addr;
 };
 
+struct io_timeout {
+	struct file			*file;
+	u64				addr;
+	int				flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -369,6 +375,7 @@ struct io_kiocb {
 		struct io_accept	accept;
 		struct io_sync		sync;
 		struct io_cancel	cancel;
+		struct io_timeout	timeout;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -2813,26 +2820,40 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	return 0;
 }
 
+static int io_timeout_remove_prep(struct io_kiocb *req)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+		return -EINVAL;
+
+	req->timeout.addr = READ_ONCE(sqe->addr);
+	req->timeout.flags = READ_ONCE(sqe->timeout_flags);
+	if (req->timeout.flags)
+		return -EINVAL;
+
+	req->flags |= REQ_F_PREPPED;
+	return 0;
+}
+
 /*
  * Remove or update an existing timeout command
  */
 static int io_timeout_remove(struct io_kiocb *req)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned flags;
 	int ret;
 
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
-		return -EINVAL;
-	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags)
-		return -EINVAL;
+	ret = io_timeout_remove_prep(req);
+	if (ret)
+		return ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_timeout_cancel(ctx, READ_ONCE(sqe->addr));
+	ret = io_timeout_cancel(ctx, req->timeout.addr);
 
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
@@ -3103,6 +3124,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout_prep(req, io, false);
 		break;
+	case IORING_OP_TIMEOUT_REMOVE:
+		ret = io_timeout_remove_prep(req);
+		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel_prep(req);
 		break;
-- 
2.24.1


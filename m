Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B2123DEF
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRD2N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36433 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:13 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so466568pgc.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Z+nQxFhARLRZhBk6cLgcVXswXeslb8XuHEHk9p1Ltk=;
        b=dpZGE62YMPg9GNKwUGzuGLC5RHmFapI/+DvGEKs+7N4n3ucO/mhqWybe+WUVPEAfig
         53HhFwJYsOvn9MQWqru7RxoS4iZfKhPOCeG/vqCvE86dykn+y3vdq6Xm1gLPeEcsuFwe
         e2MgSdk+eaAtU480yEE+IeR9RgXnXYsiILG5r7QPDSQUAtxpKN0GdCFySg6aAMWl52e4
         XyVA3Vx8aoIFzkfVJM44ealTWuayJXnogMrfPhFM3lMahNDjVvgkHX7Muuj4k9D0THJO
         1c7zAd+5bXT1JIp7SfZreQvZM75Xpq4Rkw5y/HBqv35LwlnyPc1r+UA1dmojD9EIzlvP
         6RGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Z+nQxFhARLRZhBk6cLgcVXswXeslb8XuHEHk9p1Ltk=;
        b=nXsZbNypvGuPrleU9P9qL/Yyeg1W1AqZt5uU8BSYCc3h6PU8Fn9Iw7qVLGo4fIAVPA
         JPwtYxvclElut1D3SGMTh9JZr6qtoKmrawKiEBTrqrRI+7yPssyLZDEY3ab3ux0Z5+Yt
         9AgGk43OUBFMpgtZrIDQv+zblpIC22zG5EElG9nY/KRmL/qQuyrAvlmUL/EY7szTh7Wd
         LnXZrdNHvBwPpjKrhofJDl1zIfJCIkoWBBs80wPoD9nP8+je8V+nnkjN/U/swpqWDfM2
         ldU126RttB5Ve5aaa95D27cxS02gwf9wucd9aGGIjUKVRnSa0EI/Rl7z7kAOQchmC9aH
         nPSw==
X-Gm-Message-State: APjAAAUeRy8unXeaL1lmPSalbi0x3Nwafv6pmJOEUTETXJyBjKEa/lgO
        RfjVKKzBi3pPUjMXA0fJyd9sVkBMkm7AeQ==
X-Google-Smtp-Source: APXvYqxcYulcRfT7tJKRkdVYUIYwnqHq/PfRBd7iQYUJElLl9X0Iqa4TCT0AM/xUU5RMWhbRKvkPdA==
X-Received: by 2002:aa7:850c:: with SMTP id v12mr525762pfn.188.1576639692174;
        Tue, 17 Dec 2019 19:28:12 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] io_uring: make IORING_OP_CANCEL_ASYNC deferrable
Date:   Tue, 17 Dec 2019 20:27:56 -0700
Message-Id: <20191218032759.13587-9-axboe@kernel.dk>
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
the SQE data has been read upfront. Integrate the async cancel op into
the prep handling to make it safe for SQE reuse.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ce91165d918..bee98f6281fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -321,6 +321,11 @@ struct io_sync {
 	int				flags;
 };
 
+struct io_cancel {
+	struct file			*file;
+	u64				addr;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -363,6 +368,7 @@ struct io_kiocb {
 		struct io_poll_iocb	poll;
 		struct io_accept	accept;
 		struct io_sync		sync;
+		struct io_cancel	cancel;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -3013,18 +3019,33 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_async_cancel_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
-	struct io_ring_ctx *ctx = req->ctx;
 
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
 	    sqe->cancel_flags)
 		return -EINVAL;
 
-	io_async_find_and_cancel(ctx, req, READ_ONCE(sqe->addr), nxt, 0);
+	req->flags |= REQ_F_PREPPED;
+	req->cancel.addr = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	ret = io_async_cancel_prep(req);
+	if (ret)
+		return ret;
+
+	io_async_find_and_cancel(ctx, req, req->cancel.addr, nxt, 0);
 	return 0;
 }
 
@@ -3082,6 +3103,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout_prep(req, io, false);
 		break;
+	case IORING_OP_ASYNC_CANCEL:
+		ret = io_async_cancel_prep(req);
+		break;
 	case IORING_OP_LINK_TIMEOUT:
 		ret = io_timeout_prep(req, io, true);
 		break;
-- 
2.24.1


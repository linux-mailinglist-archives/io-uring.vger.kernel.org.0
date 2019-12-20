Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44AD1281A3
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLTRru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:50 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37031 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfLTRrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:49 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so1521278ioc.4
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Le8aH9o3m+BhbfSO3ThYuzge08tIJiESK7WymEMyNXQ=;
        b=NmHV5IFvqvZQ4FLvhkj6eNjua0XA7OcarFo+raHzSl0//dLQkWA6wVh3Cy/Dpf+FVy
         AYucLVq7NT7d+yd8TKvo6gaZEmmmlgNH+0dx188e4xgialRxhTjbqRCLU8cDCeH7OAWn
         OzKpF4ldNXvFOSoiDF0928A72oqYqlE33PO6AxoWunF6FK9mCU1X0c8n0b2OlNKYmnCC
         TharNJFDkVVWTr8AFuzIZcTcLiN5oq0mel495t8Tc9OX33RTWiTCvS/LXazBT5gY3GIy
         WuVImhT9rEXHOTRn2hr1GIQq/sp0dXaupfurHPX/hY9StT3MBZwCUycwWzbXAmUjelt3
         jhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Le8aH9o3m+BhbfSO3ThYuzge08tIJiESK7WymEMyNXQ=;
        b=VAYJhNhtryEcEU6GkREbWiKqyuqYEIAHcMqACSK6lY3P/Z0v2+Bk477boZ4fqoxmXB
         cF9QP2L9VGbsvTi6tBj+7qWWL6U46kjsZRi/zYyz+MXcnKSCVYOO0e4OR72g+nwhZ+T0
         H5TbGKS5j+KOTZww9xbzVOTs3/CJ7qKmg/SE3PCmyHyxCyfPJnB2hvrmkMjaEVlw3UrH
         yPJAIKc3entfuwwLhnYZ7qlC6ZVnk6O/yy793pE2Ao7FrTD6oqQW4davS2TD5WcbYaH0
         EgYz4QKQKaw2hAhucozOFI4aDwonbp3vHUNb+AYeGVX3ih5i/7xJc9MOWdjEFEGOv+OZ
         xZ2Q==
X-Gm-Message-State: APjAAAVr+U6Fk51a5QHcaSmglC6zEzCBU0R162mxJsTiUur6cgVfujif
        RaNHlaD253SRMB3cPPaUgTc9Tnjprul0lg==
X-Google-Smtp-Source: APXvYqwuEp0y4YwO/YcUw8haAegpAzi7s9ROMO+8h/6GfMXKLv+ldQfY6ARHg3dDYXbyy98BO5v/GQ==
X-Received: by 2002:a02:c787:: with SMTP id n7mr13191750jao.85.1576864068845;
        Fri, 20 Dec 2019 09:47:48 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring: read 'count' for IORING_OP_TIMEOUT in prep handler
Date:   Fri, 20 Dec 2019 10:47:40 -0700
Message-Id: <20191220174742.7449-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add the count field to struct io_timeout, and ensure the prep handler
has read it. Timeout also needs an async context always, set it up
in the prep handler if we don't have one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 89e5b19044cc..7e8d28750053 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -330,6 +330,7 @@ struct io_timeout {
 	struct file			*file;
 	u64				addr;
 	int				flags;
+	unsigned			count;
 };
 
 struct io_rw {
@@ -2902,7 +2903,12 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
-	data = &io->timeout;
+	req->timeout.count = READ_ONCE(sqe->off);
+
+	if (!io && io_alloc_async_ctx(req))
+		return -ENOMEM;
+
+	data = &req->io->timeout;
 	data->req = req;
 	req->flags |= REQ_F_TIMEOUT;
 
@@ -2920,7 +2926,6 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 
 static int io_timeout(struct io_kiocb *req)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
@@ -2942,7 +2947,7 @@ static int io_timeout(struct io_kiocb *req)
 	 * timeout event to be satisfied. If it isn't set, then this is
 	 * a pure timeout request, sequence isn't used.
 	 */
-	count = READ_ONCE(sqe->off);
+	count = req->timeout.count;
 	if (!count) {
 		req->flags |= REQ_F_TIMEOUT_NOSEQ;
 		spin_lock_irq(&ctx->completion_lock);
-- 
2.24.1


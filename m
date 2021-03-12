Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD12339368
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 17:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhCLQaU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 11:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhCLQ37 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 11:29:59 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE01C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:29:58 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v4so2106270wrp.13
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RXOiiv7MLhedaF5cFeiMgCzCW+LIyu3DEJPfbhxZk4k=;
        b=QknJ9nE3LgN7Yt4Y24iv74ibFQHmaJar2gNPUmmMOzR6XUpnFUy+61RglT4R7rVbLH
         9WH2c4g0r2aqEkvj3KxCvKJDFO1zI/eHEmNmbnY7CyhZoTQYl4cqqBwOaqRKFLZcEJpk
         MStQUqFfcF7q2wa/QTchIsp4Balbwk8bYxYcQl5+F6eL4aBidMDVIuPzU2F1nVaPI4Ew
         hzh1k7Wx4I9l+eKBovIT0ufe6d4zGoDsKy+1xTezHmYkuhQabSSFoQzGlczD1utZt95V
         arYF0CUc+8ihDxSaFd8oYPQg/gZFiopFPVUrROYjJEFTcZj9z2GwQjZ1s53ngLgwG87r
         3LLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXOiiv7MLhedaF5cFeiMgCzCW+LIyu3DEJPfbhxZk4k=;
        b=iC7tXbE9opIufeKl2YD6tQjk7Yv2cqZD0oc+FqmyX1wekJ3o1Uuv74tZv5p8EdOh05
         OQes61v/VO/TALiz/xc3blSRYLyQkrJVr4O4s3BzNWYPmaAwPID4X7lBQVpZin/GmmXK
         ZPmKpwpdcfsAx3Y2n/M0awnp+6vI2nv2y3OKSoR22qRgmFeBuw0feTle1tNxwHrYXtyl
         YifSpIKNKNeyDem5eY5bUD/+oMFIWszZPJWrhTW5nZNvoShzZTd/DUtE6+jXuUKCriGx
         Cdqvaljfeg8UFMdGYghZLywRjg3pMhuCYFfzuB0zw+8QTMaDRYOjMOY8SU6Lh8aA7h7o
         Ct8w==
X-Gm-Message-State: AOAM5328hycgXyVXgss7jLQtczodV/exQDY065jSJnNwPYQVMJLSEeHd
        g/nDZ4obxmIQb7kj/hY6L3YNZxrkmWpR1g==
X-Google-Smtp-Source: ABdhPJx/bPbdyWZ1R3LtW+rI8OOjR1LmtZWn9UTNIEUVqdEDZs0ORu4l3TOWI7Fjk9YXPxs59d0HPw==
X-Received: by 2002:a05:6000:245:: with SMTP id m5mr15216203wrz.284.1615566597750;
        Fri, 12 Mar 2021 08:29:57 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.203])
        by smtp.gmail.com with ESMTPSA id u4sm9045615wrm.24.2021.03.12.08.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:29:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: fix OP_ASYNC_CANCEL across tasks
Date:   Fri, 12 Mar 2021 16:25:55 +0000
Message-Id: <153ab0c0ad081e0caa0dd67852eaab596825070b.1615566324.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615566324.git.asml.silence@gmail.com>
References: <cover.1615566324.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_ASYNC_CANCEL tries io-wq cancellation only for current task.
If it fails go over tctx_list and try it out for every single tctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70286b393c0e..a4bce17af506 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5667,8 +5667,47 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	u64 sqe_addr = req->cancel.addr;
+	struct io_tctx_node *node;
+	int ret;
 
-	io_async_find_and_cancel(ctx, req, req->cancel.addr, 0);
+	/* tasks should wait for their io-wq threads, so safe w/o sync */
+	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
+	spin_lock_irq(&ctx->completion_lock);
+	if (ret != -ENOENT)
+		goto done;
+	ret = io_timeout_cancel(ctx, sqe_addr);
+	if (ret != -ENOENT)
+		goto done;
+	ret = io_poll_cancel(ctx, sqe_addr);
+	if (ret != -ENOENT)
+		goto done;
+	spin_unlock_irq(&ctx->completion_lock);
+
+	/* slow path, try all io-wq's */
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	ret = -ENOENT;
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		if (!tctx || !tctx->io_wq)
+			continue;
+		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		if (ret != -ENOENT)
+			break;
+	}
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+
+	spin_lock_irq(&ctx->completion_lock);
+done:
+	io_cqring_fill_event(req, ret);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_put_req(req);
 	return 0;
 }
 
-- 
2.24.0


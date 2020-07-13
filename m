Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616B21E18F
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGMUjd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMUjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:32 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A095DC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:32 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id h28so14977810edz.0
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yvbg9XbQBX9YSBoiF4EpJN8ZKy8PRxUwYBEPp0mDWN0=;
        b=UvfQJauEpUYvgbidgJ004/R4glpZ9y02LLcbMsq4glmGjwha+eybvUeb842Rhd9aeA
         HNyal0NFBuMV0MU0CGQ/TuGuYf+Edw+naGVS966d4ZRaXeLVNWx1PGoxIFyVbOKEYn6U
         2BDumYw2x8haloEmJUTnC9eIl3s6aaxtMMth61Lv3lEyWua8bd8Nfl0cxzO/Y/TyN7gD
         df3FMVaOdFLHuset7hhTpkhbUL1J1TVF5DST3PJuJLevj6ugQoZAiK1TQD3PFzUkLCuX
         M5gUDhrmEx8D4pQyfqAWTiJmsLeL16ggQxb+FQmmcZlLneQXZBFr7vMwuKqZayeSUuzI
         2RUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvbg9XbQBX9YSBoiF4EpJN8ZKy8PRxUwYBEPp0mDWN0=;
        b=dn3ZESWi/Q6ZALsvlb6xnVmzHLNw+80lOtLWSXcw6Oo8fIsQ9ziF7n1JXek5gfshVa
         c8GPMQjSeE8hie5fH2186vQA7e0gFW9rMPKA64bQ1KPT8g/YZxO9TQbR6Yvy8LxP9v1y
         PVEgYsU/L5788DO5lBKQXIJWsmXnztqf8eZHWXoKP5bJzWMlQV7ZT0hevoVf61m+/qKB
         EzsUIQQ767vYC1iV8icoZQNQNq/awvz70kmo8B9LkeV8ZHoS4QWId35kzNES+S/f2O0u
         em8MWH20pU0b1s8V2sRukFUO4s7J9H62BAlrqr+v69GnPQcaoEBmz9ePCdo2jsDOqWCS
         4FAA==
X-Gm-Message-State: AOAM532U9p7Wg2k2WD7wurAPFFF4EBf4K/KrTIdLanCZZReusz9FdXjk
        c42fjgmuNM3rH7LXJdYWNTE=
X-Google-Smtp-Source: ABdhPJz0GEyaeyvLT+kEKYW7Wlpdq/dRalmpK40O5EXaRTMelK5mVt5Qosskw0tiBw1R7EMDZOko7g==
X-Received: by 2002:a05:6402:888:: with SMTP id e8mr1212761edy.210.1594672771334;
        Mon, 13 Jul 2020 13:39:31 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 7/9] io_uring: use non-intrusive list for defer
Date:   Mon, 13 Jul 2020 23:37:14 +0300
Message-Id: <c880ad13bc95282a8dc2923b0a4de764afb6a251.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only left user of req->list is DRAIN, hence instead of keeping a
separate per request list for it, do that with old fashion non-intrusive
lists allocated on demand. That's a really slow path, so that's OK.

This removes req->list and so sheds 16 bytes from io_kiocb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b789edbe4339..672eb57565dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -640,7 +640,6 @@ struct io_kiocb {
 	u16				buf_index;
 
 	struct io_ring_ctx	*ctx;
-	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
@@ -675,6 +674,11 @@ struct io_kiocb {
 	struct callback_head	task_work;
 };
 
+struct io_defer_entry {
+	struct list_head	list;
+	struct io_kiocb		*req;
+};
+
 #define IO_IOPOLL_BATCH			8
 
 struct io_comp_state {
@@ -1233,14 +1237,15 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	do {
-		struct io_kiocb *req = list_first_entry(&ctx->defer_list,
-							struct io_kiocb, list);
+		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
+						struct io_defer_entry, list);
 
-		if (req_need_defer(req))
+		if (req_need_defer(de->req))
 			break;
-		list_del_init(&req->list);
+		list_del_init(&de->list);
 		/* punt-init is done before queueing for defer */
-		__io_queue_async_work(req);
+		__io_queue_async_work(de->req);
+		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
 }
 
@@ -5372,6 +5377,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_defer_entry *de;
 	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
@@ -5386,15 +5392,20 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return ret;
 	}
 	io_prep_async_link(req);
+	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	if (!de)
+		return -ENOMEM;
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		kfree(de);
 		return 0;
 	}
 
 	trace_io_uring_defer(ctx, req, req->user_data);
-	list_add_tail(&req->list, &ctx->defer_list);
+	de->req = req;
+	list_add_tail(&de->list, &ctx->defer_list);
 	spin_unlock_irq(&ctx->completion_lock);
 	return -EIOCBQUEUED;
 }
-- 
2.24.0


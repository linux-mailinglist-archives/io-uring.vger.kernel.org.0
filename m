Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723E821C856
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgGLJnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:20 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9461CC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:20 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b15so8143250edy.7
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ANsSW+jX81BSKSeQ0JlpFNIwDpIQmJIXWPQBg0yDtQ4=;
        b=DfUISm3odZgZJu2rOB6t9onAM0rN82hv9caX12jrCWxXdWvKb/FPsQnraDkTHWE36X
         ySB2NZtIshuE38DY/wnurUa2gEpiwmShX4Qr/8kpKOoi9K1kTkZcl41Jwkx3ZRq+f7Zw
         Y3qhrMUixDIzz6StHdi8TLf7E89H9dEWGCdgKblrCXqBkoDy25k6N0+IvuSTWg+nzGiK
         IDibI5zy3Q/SlJ4hPtPeo3eMTyHJyJikVpmMXsJ0vc8UsitJkvIRLz3RyveZB5HmQGVP
         BtLIhFyuxuuDl5SeP0pnyeR/6D5AZLmX1WqO/d2RcJ+9XUI2XcSzfPmflx/FroYgEk7F
         nZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ANsSW+jX81BSKSeQ0JlpFNIwDpIQmJIXWPQBg0yDtQ4=;
        b=HLpTyBgPQLbIdqlVOwAtXeU6BiIjwlakFtoA2+lLyL8AEMXjgzcsq5qUVTirxVSNXM
         dQsQP/wzUBUAZtM1M29rPjwkWwp/a0wQP6Svn4cQ98ppHDZl2cfbxgq50irPmTzU4DWV
         5+mX4lw/BbBd+lcyggViR8zCwgvsQh4D39NOv3hKv4SOtikzrQVtii+NDhJF3PDq23TY
         zI9AGDzDdLNH+up4eDM10NXQQhqy7CgmmOnWr+VFsl1OpOtr0vVFztRY6BqzFlGvJjnf
         knzNz3LlOo8dY5u1o/3ghpY5/UOdVtOOkHK6JSgLUZ7GEkJsYpo4XjQFS4SbZbGqg5qo
         fM+Q==
X-Gm-Message-State: AOAM530iEs9xY80hxYbNtBEZHVNW4nrJB/CStR92vpcFCubLxarX8y/x
        TrElxZZ6vyERipvWG9fHo9j/CNFn
X-Google-Smtp-Source: ABdhPJwBMt2opSeFyOUjpr71VdNTsCHzpRCltO4r0UEyLfov3Lgz2yy59tQy0uXIbx7H0mg5OqC+eg==
X-Received: by 2002:aa7:c24d:: with SMTP id y13mr89667596edo.123.1594546999333;
        Sun, 12 Jul 2020 02:43:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/9] io_uring: kill rq->list and allocate it on demand
Date:   Sun, 12 Jul 2020 12:41:13 +0300
Message-Id: <35689abd988d34fdbc3da7ced9e45aa45c112ac4.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only user of req->list is DRAIN, hence instead of keeping a separate
per request list for it, just allocate a separate defer entry when
needed, that's a slow path anyway.
This removes req->list and so sheds 16 bytes from io_kiocb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38ffcfca9b34..93e8192983e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -641,7 +641,6 @@ struct io_kiocb {
 	u16				buf_index;
 
 	struct io_ring_ctx	*ctx;
-	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
 	struct task_struct	*task;
@@ -679,6 +678,11 @@ struct io_kiocb {
 	struct callback_head	task_work;
 };
 
+struct io_defer_entry {
+	struct list_head	list;
+	struct io_kiocb		*req;
+};
+
 #define IO_IOPOLL_BATCH			8
 
 struct io_comp_state {
@@ -1230,14 +1234,15 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
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
 
@@ -5398,6 +5403,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_defer_entry *de;
 	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
@@ -5412,15 +5418,20 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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


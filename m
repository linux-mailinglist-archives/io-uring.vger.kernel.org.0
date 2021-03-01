Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91BD328B2D
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 19:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbhCASaH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 13:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbhCAS1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 13:27:16 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE817C0617A9
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 10:24:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n4so17215687wrx.1
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 10:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gUKgDDDFHx58I6VODb6BxfHVUzm9uBpCjDavVeywPs0=;
        b=cVso58VZ3rrIiW6GSvzv+FibevCW0F1OeOj0pG0SWXWzoi5ijGDlxbo2dAnJAAFQP3
         dvFEhKq8VQyqeC5ho0Wwn+hS1EFhcPQY4gm/lQBlG68TC52FPhcwPmwjVJ4wBmbqay1m
         YJkNyMik23/+bR2L6uI+XxyfYTnJKz/TcqLplFAOFwgSyDjsLRGGP4XJUbVHuOVOGDhY
         wXqvQonJL93ONgvwBXINXKTf+bJfVzZzOW50jnqb4aIH2/5iWFkT5ylhgR4lRoC6fSi3
         gFervQUaojOvHrXt19BeYNqLCvPpwNETQ05qkfJS2rGpwnXMTD7n5L+0fV9ohUXJ83YT
         ow4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUKgDDDFHx58I6VODb6BxfHVUzm9uBpCjDavVeywPs0=;
        b=MiGgI5ndboQbP7xUOdkUoyUsHbjrnqas1R3k0KII26NOfxqdEC/CD4BTyDq1ccbo2W
         iQ5rXhI9dXcEJUNZQp1XocsL0WxzkoJ0NX4glVV3KMxL0rjsqtIP1n/BuBQy7zcmkuEr
         IHzBXXY/C7MIh2BUU4fGT2p8+yimLyP6SygjyR8/qB/K5fHEjXLVprO32KSlV7QySehY
         gunDAp9fJuXDIanuM25eOPAJYNfL3Cwytz9yCG3jbk//MbajJkRnH1kT/b+Rmr6DACi2
         Z4GwhXuIH7OUKhCbbEaqdBm7b5yJUOQULArhjMoOh22RKvdxYnpYZVD5l7XNOVxtAg8O
         868A==
X-Gm-Message-State: AOAM531KJxlRz+DZXQVKH8JUoV9O9NRkL2/V1OyzhxEMoWNU0EU13w7x
        mOW+ze5d13oq2bcDyYaaPPNWrzFHJoVV1Q==
X-Google-Smtp-Source: ABdhPJxOGl63V4WfnZCdJViBR18NEPAfB5HuZVsUYKQvZmIVEu/Z+ny9JHZ06vHqekvD9hpSitulGQ==
X-Received: by 2002:a5d:56c9:: with SMTP id m9mr17658517wrw.422.1614623089466;
        Mon, 01 Mar 2021 10:24:49 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id q25sm125146wmq.15.2021.03.01.10.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:24:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: inline __io_queue_async_work()
Date:   Mon,  1 Mar 2021 18:20:47 +0000
Message-Id: <d810022d059b7b6d9e0a86da904348b167ae7b78.1614622683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614622683.git.asml.silence@gmail.com>
References: <cover.1614622683.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_async_work() is only called from io_queue_async_work(),
inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d8c99c46127..411323dc43bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1205,7 +1205,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 		io_prep_async_work(cur);
 }
 
-static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
+static void io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
@@ -1216,18 +1216,9 @@ static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
-	io_wq_enqueue(tctx->io_wq, &req->work);
-	return link;
-}
-
-static void io_queue_async_work(struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
-	link = __io_queue_async_work(req);
-
+	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
 }
-- 
2.24.0


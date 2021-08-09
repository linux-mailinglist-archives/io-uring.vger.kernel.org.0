Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3E3E4CEC
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhHITTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbhHITTM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:12 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B157BC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:50 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15so11313379wmj.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=z9IcCYIxIJnNAFUoGa7g2Ab0CiOo7dqsZc9P3Jt3vPk=;
        b=SmMjtioUFw60cBLBqAcHM+SFluKkMS7hpBBLca+QzsC6ca7PtlIiXqk225vMglLuja
         /ICsxgSij8D0ZaAxTkLsO01BsrB23800wpLvQiT48IKzFfZfhB/LB1peOjdvNWOItwuM
         /hcGn8xamiULajuWp2LTInOjGXRZB3235UURt9Q5tuT3JB2sSiUDkPAQYAyiYsdTZBEt
         I4R46cX1mHZnotyhhWjM0P8SS7xbSTbPeh0b3+N14a5fdu3uB87wySIQkkU9sPUi7wT5
         zOjMdBmMv18ledy+FC0XKNjRlNw/I2x+lXVXCGYPvXQH8dfWzg1l0km1nqRRXxgzcXnV
         Pv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z9IcCYIxIJnNAFUoGa7g2Ab0CiOo7dqsZc9P3Jt3vPk=;
        b=dnpxKrXwdGW8PepZ+i7iupbXYwXEIEz5HWQPZwnPED23+1MFcQqfny9KpA6n0gxekI
         rMe5nXOxWGvSSCJeJkw3mAvSYrM4iuX26c0kXumRVJp9reenoU9kHnoWITOSqHdjrG6H
         Ws9mhjxKo10tWI+64NXtEq5yCLlwxTEJg7yFb2xC0zi06T2O4lAwajSsMNimz/qfdO4I
         7Wr8n7E0VoN1zaAGJMXKkALzXOGx+Y5FSXbBP9bF5dKxppkXYI2wH/L2J087LJ6LFg7d
         4KiE3hK4MArsuLVkyoUHVHNVl7sxoCgRZ5XTSufW+O/V0Er4njh3I4nxb1D1U4WJlB2R
         WS/Q==
X-Gm-Message-State: AOAM530AevbfxMKZedE/7NzE9icnUvqEWRay6kgXWS1SyXV/GjhYmI1n
        QgWQ8/eX9NVkL3zgHBksgguDmgNV+0k=
X-Google-Smtp-Source: ABdhPJyskSYuUTWhXpHCgEyrHJS3ekjcQzZo8pkaiW4Kl8Fa1iiCMtSrVxsVALVFwWWCVOuZXn2ciA==
X-Received: by 2002:a1c:1f17:: with SMTP id f23mr676355wmf.136.1628536729365;
        Mon, 09 Aug 2021 12:18:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/7] io_uring: move io_fallback_req_func()
Date:   Mon,  9 Aug 2021 20:18:07 +0100
Message-Id: <d0a8f9d9a0057ed761d6237167d51c9378798d2d.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
References: <cover.1628536684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_fallback_req_func() to kill yet another forward declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21dccfc8665f..889e11892227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1066,8 +1066,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
-static void io_fallback_req_func(struct work_struct *unused);
-
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -1144,6 +1142,17 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 	return !req->timeout.off;
 }
 
+static void io_fallback_req_func(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+						fallback_work.work);
+	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_kiocb *req, *tmp;
+
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+		req->io_task_work.func(req);
+}
+
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -2465,17 +2474,6 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
-static void io_fallback_req_func(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
-
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
-		req->io_task_work.func(req);
-}
-
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     unsigned int issue_flags)
 {
-- 
2.32.0


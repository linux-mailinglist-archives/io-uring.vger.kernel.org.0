Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D933E4546
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhHIMFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbhHIMFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8B4C061799
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso14432699wmq.3
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nymrDaShnCXl8oINh93f7kNh91GSKoBUuk/MhldA6tk=;
        b=JgTf5grrQMMLhOtpqAvVAN1IiJkeGcHoi2Uk7x8qYHyXLMcwJK2AuP3nWZLm72ELNu
         7m2+8SS8HBhGL0m5T7m3HZN+hnrmmknR/WGs99qaOwObTMCnVxSici+tY9c9CjYgX12e
         7xcbryPrqay3Nc3DndQzVdKEImBlYj/zWwN2c77Dj1aCMT7bs3BzcD07ZEudhN/K0NWj
         cSuxC2v3MTnWNOChgnMYzTZrwQKDPi+ntl5uJrzTPc/+YARH2xMkanxfERkQAYPtF5FT
         RM8yLGzjLBX9dSDU3MJXgT5czgl6VEagGdsjCClS0kljJo7zQYMkHv3ADouB9xZK+9k8
         Q47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nymrDaShnCXl8oINh93f7kNh91GSKoBUuk/MhldA6tk=;
        b=LAeCgicv0ySneQvLPOO/Ojmb3adNAnaNYJL0Fe7J4VK/x9auanuGGW2ZBudL6SRTZ5
         IzkLrYgSUrvgfVCLm1JOLg2aQISRABkxMyaiT82Ls+4qZ59SEi9Hi8VPEdbxYpq2ze7P
         XKIb0tJuC+apFIeVdxN1QwV3/YKKTg+9v7wexUDEsJQQD8wDPSGTemuDVYzUC2kIlb36
         f46XbzTm4oT1sfY5Dhhsx+Z1FDlmX+u+1mrxReJH10bfWYfWWyjDDCIVQq5Yyh0ZPy7G
         tLSVQL3xiSjP0JIy8Wa/M+MXf5mL47dkSK0aeZRwt31Isv8ljpZUrYTxX5WQYhPtP1jK
         DMNQ==
X-Gm-Message-State: AOAM533nz9PMbxDfZEZJsHgtX99nytIztKAR+lUgVngodLTvhmRW2YfA
        OzTJBQjNIakL1/txlEk4KKk93MNRuPQ=
X-Google-Smtp-Source: ABdhPJyQrQdLnFDOxj46Q66mbwKzGwSRo8X4deFiaPpZ2Y5GOehIU7VHl27z53UkIS55AXiQyfANSg==
X-Received: by 2002:a7b:ce8b:: with SMTP id q11mr10348527wmj.30.1628510723681;
        Mon, 09 Aug 2021 05:05:23 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 22/28] io_uring: move io_fallback_req_func()
Date:   Mon,  9 Aug 2021 13:04:22 +0100
Message-Id: <10a14fe1f995ca386a9caf88ea3ea354e0a78801.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 9e359acf2f51..8b07bdb11430 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1074,8 +1074,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
-static void io_fallback_req_func(struct work_struct *unused);
-
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -1157,6 +1155,17 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
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
@@ -2476,17 +2485,6 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
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


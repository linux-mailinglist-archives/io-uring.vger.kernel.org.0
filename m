Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3177131F267
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 23:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBRWhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBRWhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 17:37:34 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B016DC061788
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v15so4693335wrx.4
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yfmkRhgEIOJi/kDtZn26oflLlqIXOl98CK/10wrGrv4=;
        b=adi5c/1fHik4N8h8C/Q3AsHUmQezZLs5fYbobSNIu20+pphMhXc4AIs+aRDCPVIg+s
         n8HYZ90ArduJ2c7wCPKCMhRgjxTlO2etzR5pwcq2UBZDSJOwGgy8CyZ6C66OUy9D9/9z
         bXU6wNnqQiNkJRxQ3WgfvaO7QfsOSmHDS4nFqIf8LBdfHaI9kSr5lwQhRYLfgMaY8Rmi
         Sx4MUjEM57wR8k1hcs0tqJKVHaAz/1iRW7mbarn/opnj119F2NOQuIntGQRLmeJHCcNt
         L0U+IR52GI6+6xyAiKQ8SUbxBTzHmlXKLpWpkv6IpJ1M/XIjDjNCtTPZlOKAJawi/JK4
         qnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yfmkRhgEIOJi/kDtZn26oflLlqIXOl98CK/10wrGrv4=;
        b=S8ClvIw/slEg7yzVjYdNHeLq7/xnmrpiJzjGV2eGdGImyMSbvNSRUOfP1HFMrMIH56
         grhCZxOpkzHwdasXowRuMyYxdOodL7yk6laEGUim+uBG4bmKo0UFFS+N5TKx63takHLP
         wDZq0LsuO2GemNjKCzk4EDTY1+HRqHiMi+aA5K6MmT8LQSLmlzXWn+em/FqoR1SOlFo3
         U22BjrX0wbAa4lJEqyZLZvagsh3y5ZRc+Pe5BL2RaINoTvsyhQlrVLpo/eQecCvR79fI
         C2dHMl9Om1zVatGnbl90aZooE4wVnaZfd692kvODiE6Ac14Uk5IQftgz1qj+GqNUF0x1
         W70A==
X-Gm-Message-State: AOAM533SwUcGiPTqO2SHCKWwvLJrZjnDH4bq+oVwtiSzqqTUclGoZyDu
        o0nyroQoPoMOIyaxlSq5V4KIBjJoGrGAOQ==
X-Google-Smtp-Source: ABdhPJyLpwXgvgJ6VGPdmnVvvCm3Gf999M04/KJR/TclsogFnNKQ/R+9o3Wv601pCgsedG54KQexMQ==
X-Received: by 2002:adf:f591:: with SMTP id f17mr6230629wro.60.1613687812548;
        Thu, 18 Feb 2021 14:36:52 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id w13sm9807439wrt.49.2021.02.18.14.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 14:36:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: avoid taking ctx refs for task-cancel
Date:   Thu, 18 Feb 2021 22:32:53 +0000
Message-Id: <ffbeb9bee15392fdd2732333be1cc2db30a1eefa.1613687339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613687339.git.asml.silence@gmail.com>
References: <cover.1613687339.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't bother to take a ctx->refs for io_req_task_cancel() because it
take uring_lock before putting a request, and the context is promised to
stay alive until unlock happens.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1cb5e40d9822..1bd25d4711cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2337,10 +2337,10 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* ctx is guaranteed to stay alive while we hold uring_lock */
 	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, req->result);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
 }
 
 static void __io_req_task_submit(struct io_kiocb *req)
@@ -2372,14 +2372,12 @@ static void io_req_task_queue(struct io_kiocb *req)
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
 		ret = -ECANCELED;
-		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	}
 }
 
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	percpu_ref_get(&req->ctx->refs);
 	req->result = ret;
 	req->task_work.func = io_req_task_cancel;
 
-- 
2.24.0


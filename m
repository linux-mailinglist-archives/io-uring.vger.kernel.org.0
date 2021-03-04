Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8332D9CB
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhCDS54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbhCDS5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8EEC0613D7
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:35 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u187so8998222wmg.4
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U/Mj9fKYp0VxS9E9GV5FsaGx7X82PTdmhtDVKZ/VOYo=;
        b=pRSk8r+VJDaVPM3RdcYyyVk7ZxXwSgI1UTaEgpihVDB1EqmPZtr6ViRBp0LVSmfcKX
         sfHWxuCZlpuGZjZ3CP9rkfBb0bWYctALmLXwb0tZcJiiiuEVkshI2GkIb4XAZN1pv3ir
         lvHIQ/lr62oV84ldJs9EmuR1AnR0DS2uXc/4BVCSG8jNMx461vrtLIvwhfCfFwk8L7wo
         RZRd+KUatoQvywA4lov4tJdLJFM3mil9EG0P9RVwnDm8jMwIa7C2syj6Lu4cc9/wTVxX
         hK4NpCjcNYQd3YYREWum0fKtQoPN96O59PQPK/i2WXabFHHX8xk8SDpTCFj247qoM8Vv
         ai5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/Mj9fKYp0VxS9E9GV5FsaGx7X82PTdmhtDVKZ/VOYo=;
        b=pFN3UDpr3oe6fyM/Lf7Ia3J/IN8xiXhPjoXHccBk/PZC7NKyLbDfVv1W+uqOeEqiub
         /RrWH9tWzSWJWK9Wv3flglbantocO0riCvhfquixnlFoaizCmRXPXTVbC86DqJojwEWn
         WbZmnzxcCvSlfhopwD0lnUG2EauzMkTyQZHvp/OR0JtYMFTMdyxFcPahEt7w9HKWrgu8
         qYseafz9QlrsZ92QpRrr3H2h7+JL4cbSLLxXH/vBzvQCS8X0YJ8JF4BobRxI6Fn7dSOu
         8KXRZ7I3NKdHVzEOWMZgDWnHwaQA+ybOG/jGnQqtBFqk+u2CivwHPQinrB0AnaH7DWxi
         Pcxw==
X-Gm-Message-State: AOAM530uaUyq/y2UGcNTMJRjyLkArmBtUf1qI3cVuEo1uLMPScO84UHM
        gxncBNVfGUy38bpIxRJ6CNaUw5qrt/S3AA==
X-Google-Smtp-Source: ABdhPJxasSVmJY8e0vFKSOKFHPOLUSSOpiLGCDakKGOSh4raXuf7DNUlFy48N0Unri44ArFTYzM3+Q==
X-Received: by 2002:a05:600c:4292:: with SMTP id v18mr5262136wmc.23.1614884194406;
        Thu, 04 Mar 2021 10:56:34 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/11] io_uring: inline __io_queue_linked_timeout()
Date:   Thu,  4 Mar 2021 18:52:23 +0000
Message-Id: <136531d2aacb68edbd43f5c06bf6a84b957e8be1.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline __io_queue_linked_timeout(), we don't need it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index da5d8d962bff..c05579ac7bb7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -995,7 +995,6 @@ static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static void io_queue_next(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
-static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
@@ -6126,8 +6125,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void __io_queue_linked_timeout(struct io_kiocb *req)
+static void io_queue_linked_timeout(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
 	/*
 	 * If the back reference is NULL, then our linked request finished
 	 * before we got a chance to setup the timer
@@ -6139,16 +6141,7 @@ static void __io_queue_linked_timeout(struct io_kiocb *req)
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
 				data->mode);
 	}
-}
-
-static void io_queue_linked_timeout(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	__io_queue_linked_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
-
 	/* drop submission reference */
 	io_put_req(req);
 }
-- 
2.24.0


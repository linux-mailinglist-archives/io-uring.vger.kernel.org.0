Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0661C342352
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhCSR1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhCSR1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:04 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CC9C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso7705687wmi.3
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zh50YOTCBOYz3LfuVnn/8ey6RRNqPhp9Gp8YNVjCU3E=;
        b=jJUZI0vWIh7N05tqhyLHGk0N4RU36MLy1phmZqXaegu8X/6/3loTHxDbZjw0k+X51X
         XryFUmtdRm8oCnc4n8YykLxWw2d0B2FH2aRCPcLC6LEABEDWZe18WYBtd0pvlHEQWo6a
         LpTbTVt3aO2L58AIE9tBR31sq9Vkf1do3gMexFpdmXFjynjgsYI6rWa8cpG0e36hRTbx
         seAQg+WIhDQEtiEtZjSeJkxV5B1H9hQ9QVciX4xIjL3NZbDrw6fNTNR5JqHyYJolSvaO
         Yr4bekkkvvIChFgDeqW0MKB67BiqZYGDxs/qwkaUF2GIohWC7eyGIoS2EoMf0OfcGwqG
         cimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zh50YOTCBOYz3LfuVnn/8ey6RRNqPhp9Gp8YNVjCU3E=;
        b=sR0FAvEVPXEkeFwlm5i1aNf2uPHERCYPhubu+OLYeoF+DzRjgFTsijn7hCmgobZXmR
         Wdc7MLZ3umMlhPID9Cm71DOZGgjZ67DcruhHa2YULCUjI1oQ4+b0rO7RL8LF3iznU43e
         jnufOxU2f2a55XLk9nQSvukwYgq5JytkkGMQvMmkEeQpLpASwCOgX3o5lPdGxSo23een
         TEV8DGfo8zrfX2GrN822hk3p8CjtPh1x8zbd6iO5nodXLgOHXyjjMI6kDQD70i4tcBmC
         hjb8F7BMtgwulubOaPicgGU5zIM3bTgjQzPFmOH+dNOiFNE6rCAtY0gKKlWI39SQ5cUY
         ddSw==
X-Gm-Message-State: AOAM531Ngb4UJIFeiKvjo1xsqSMGDxEHqJni4ZH/JR+xdYoNxvr8DznF
        8PPhABH5hhbTCC2dWGxHkGJRp+uxdeRBAw==
X-Google-Smtp-Source: ABdhPJzV6MZdv8gCeh9p2287Q9pIFTWG4AkFb29X0PgOyySBS6+UASOuNc2oo0BvjL62M7FzVf2wmg==
X-Received: by 2002:a05:600c:4844:: with SMTP id j4mr4674941wmo.179.1616174822256;
        Fri, 19 Mar 2021 10:27:02 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/16] io_uring: remove __io_req_task_cancel()
Date:   Fri, 19 Mar 2021 17:22:40 +0000
Message-Id: <39116fb2257ae17651f0897358481fb035a8eebd.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both io_req_complete_failed() and __io_req_task_cancel() do the same
thing: set failure flag, put both req refs and emit an CQE. The former
one is a bit more advance as it puts req back into a req cache, so make
it to take over __io_req_task_cancel() and remove the last one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a5d712245f7..e46e4d5c3676 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1022,7 +1022,6 @@ static bool io_rw_reissue(struct io_kiocb *req);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
-static void io_double_put_req(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static void io_queue_next(struct io_kiocb *req);
@@ -2039,20 +2038,6 @@ static void io_req_task_work_add_fallback(struct io_kiocb *req,
 	io_task_work_add_head(&req->ctx->exit_task_work, &req->task_work);
 }
 
-static void __io_req_task_cancel(struct io_kiocb *req, int error)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	io_cqring_fill_event(req, error);
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	req_set_fail_links(req);
-	io_double_put_req(req);
-}
-
 static void io_req_task_cancel(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -2060,7 +2045,7 @@ static void io_req_task_cancel(struct callback_head *cb)
 
 	/* ctx is guaranteed to stay alive while we hold uring_lock */
 	mutex_lock(&ctx->uring_lock);
-	__io_req_task_cancel(req, req->result);
+	io_req_complete_failed(req, req->result);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2073,7 +2058,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	if (!(current->flags & PF_EXITING) && !current->in_execve)
 		__io_queue_sqe(req);
 	else
-		__io_req_task_cancel(req, -EFAULT);
+		io_req_complete_failed(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2228,13 +2213,6 @@ static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 		io_free_req_deferred(req);
 }
 
-static void io_double_put_req(struct io_kiocb *req)
-{
-	/* drop both submit and complete references */
-	if (req_ref_sub_and_test(req, 2))
-		io_free_req(req);
-}
-
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
 	/* See comment at the top of this file */
@@ -5085,7 +5063,7 @@ static void io_async_task_func(struct callback_head *cb)
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
 	else
-		__io_req_task_cancel(req, -ECANCELED);
+		io_req_complete_failed(req, -ECANCELED);
 
 	kfree(apoll->double_poll);
 	kfree(apoll);
-- 
2.24.0


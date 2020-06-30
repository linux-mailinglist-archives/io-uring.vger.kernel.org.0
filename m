Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB57C20F481
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgF3MWl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:40 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2EC061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:40 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so6082180edb.11
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QLY822HQf61CwAlpt2imqm6Ay7I/eJYlD0kyuocCRS4=;
        b=cKGjhVC9k9m4tWXGrnrJ8J57hLBQUEVQSg0W83lXpn+Ga3HR749bjy+C/QWHh5hqrZ
         VdL/YVDWUpsijwpoTpqC3eJhsZrOjbuT0+CCEf+K8EzhAkBu7FIuKwyQvuDW6xjPxlnw
         7PO/98f4Pu3N83eE1iPRAkhDbOO2w0btdof+c0xcWvOApjIihsVi0CKI9Yxx6Cc1QCOP
         6k9KR2ToOB668+6OFPQeoeTvp9XlMrpcuACS6BPD974wk3z/FYXj3OT4Dzd2TPpykPaj
         XjyRrGLYrW3PvxNNHjtmAM8ju0hd7bojJ4BGEzd9dt8kDnbNzKDfj066wxX9ON++NeD7
         C+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLY822HQf61CwAlpt2imqm6Ay7I/eJYlD0kyuocCRS4=;
        b=Ff4Y31AGbhy7CwDfK3+ZOqLyCrIDso/ZfwKa2vLfC22kEEvzdM+viXyuz67dU6c8dh
         LNXT5DCD8ecIG9bjhapIPfmOA3tb0YF4khnbZZXO2cnBP1MW4UoFXWjr9aLzzjdEjV39
         GXeD3e1du+3oW9fD/Zyyy23ILNIGyaD0Ahtry6xMav/oaDqxmSJHqcQvcbG50/iqNOAr
         GJmS9mpoxVkbrZF/gA+29P1zDA1VobjAM+OGj32fag4Zvrz5pd18iP5oLHQzHmTdt+Da
         VvNZYgejOe7hwGq95i4GHJ/QCqFbaHJhvtdsWCddw2ti5EAxel8QQR+1oiD6FkzwzKUS
         +cKA==
X-Gm-Message-State: AOAM53019bSOq8gy+gjjoMpX92sKopQpcvi8D5KGpe0Kge0CmW15QUf0
        63lwAEPG7dR2Uom+K0mg0SA=
X-Google-Smtp-Source: ABdhPJwv3HAx+5IfSgYKh8k2+T26dCKZ6YpxKE1bXBWPTB7FeHvXGLoRSHRYkTxbd1gbuLCCudrhRg==
X-Received: by 2002:a05:6402:b79:: with SMTP id cb25mr3247973edb.154.1593519759212;
        Tue, 30 Jun 2020 05:22:39 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: simplify io_async_task_func()
Date:   Tue, 30 Jun 2020 15:20:42 +0300
Message-Id: <819c0cdbc03d58e14a4665bafa489d40843a2766.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greatly simplify io_async_task_func() removing duplicated functionality
of __io_req_task_submit(). This do one extra spin lock/unlock for
cancelled poll case, but that shouldn't happen often.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 57c194de9165..68dcc29c5dc5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4582,7 +4582,6 @@ static void io_async_task_func(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
-	bool canceled = false;
 
 	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
 
@@ -4592,15 +4591,8 @@ static void io_async_task_func(struct callback_head *cb)
 	}
 
 	/* If req is still hashed, it cannot have been canceled. Don't check. */
-	if (hash_hashed(&req->hash_node)) {
+	if (hash_hashed(&req->hash_node))
 		hash_del(&req->hash_node);
-	} else {
-		canceled = READ_ONCE(apoll->poll.canceled);
-		if (canceled) {
-			io_cqring_fill_event(req, -ECANCELED);
-			io_commit_cqring(ctx);
-		}
-	}
 
 	spin_unlock_irq(&ctx->completion_lock);
 
@@ -4609,21 +4601,10 @@ static void io_async_task_func(struct callback_head *cb)
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
 	kfree(apoll);
 
-	if (!canceled) {
-		__set_current_state(TASK_RUNNING);
-		if (io_sq_thread_acquire_mm(ctx, req)) {
-			io_cqring_add_event(req, -EFAULT, 0);
-			goto end_req;
-		}
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
-		io_cqring_ev_posted(ctx);
-end_req:
-		req_set_fail_links(req);
-		io_double_put_req(req);
-	}
+	if (!READ_ONCE(apoll->poll.canceled))
+		__io_req_task_submit(req);
+	else
+		__io_req_task_cancel(req, -ECANCELED);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-- 
2.24.0


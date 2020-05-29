Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CE1E723F
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 03:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391572AbgE2Bve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 21:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390018AbgE2Bvd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 21:51:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0141DC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 18:51:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q16so379365plr.2
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2XhbtGiiweRShqIxUQYUe2lI5bHS7EAIpZYraJE5boA=;
        b=1SsKaiX1STS5eBfIAWlNQoQ9MmocneFSoQuB3vBMqF325YhP0MkcTVFSnVTW9ijgv6
         60mdLz9A8Fv5lzmCovH6x9oa1S9k4z9HH8j2DqF2a21TiKOm59T9t96VTRNaNijICE9J
         3JxY0iFkn02Vhk5V0CpzePjI7YhFZxaxLCwfxYbuDWT0uJMzDYNF/OXh24IosdBHFdmp
         l7OZ+E5yuGcF9BsYejsOGcifIE6VuqwYdMkw2OHVCm6oh8ItNDr6cbf7Y3CNSHPWAidE
         2UusoVifO+eDFuaM7Gj/mH3jdYLugQGxkmLVvVCm63AeqvLKKnl505Dw5p/coIWyOaB1
         RZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2XhbtGiiweRShqIxUQYUe2lI5bHS7EAIpZYraJE5boA=;
        b=c9JmmPA8nn3n48epMVPpDOwtedu9RSx/ERcZ9dvn1bIEz2YR2K01fXyGzz4Xkqgs3b
         +Avn70aa6obxdb1YcQd+2qcxV+VG9ttB7OCjZgiMFm0aZisle7swfnBm35ok6k9BC0tO
         9Ks8BFE0QBHipxgVTniNjhFYhcN7PCWYrUmGDq07YFDYASlyOoJCCBDEdUjJNKFXYDWI
         llh5lLCdjBjXj3iuARjxoHtbLrIhnq2vcVQkJ5E27tFlQm5Og59t6Et3/a07GEmQP78o
         /7n70teb/dOt+ukWA3ZlFwyKR6kRrBukbLITgTaOwKDtir1HaRHDLwhAw8NnQphMbkcC
         AFUg==
X-Gm-Message-State: AOAM530I8I0/N3RCDLyr88u+ubBd3PhOtuENxFDxwX5FMORaWN0turxd
        0XhKPbCnTugNSzaDMx5dCOX34FC0hWY4qQ==
X-Google-Smtp-Source: ABdhPJztFHYu4Q+OWX3CPxbE8P8+uGlFle0OvPqtpsqasaa1Xqm4XfXgm3dIFX0xfQmuptgEvvyvuw==
X-Received: by 2002:a17:90a:a884:: with SMTP id h4mr7209567pjq.82.1590717091805;
        Thu, 28 May 2020 18:51:31 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::10f2? ([2620:10d:c090:400::5:389])
        by smtp.gmail.com with ESMTPSA id q134sm5904515pfc.143.2020.05.28.18.51.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 18:51:31 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix readiness race with poll based retry
Message-ID: <42bd1541-00a5-430d-2a47-706dcd2b57aa@kernel.dk>
Date:   Thu, 28 May 2020 19:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The poll based retry handler uses the same logic as the normal poll
requests, but the latter triggers a completion if we hit the slim
race of:

1a) data/space isn't available
2a) data/space becomes available
1b) arm poll handler (returns success, callback not armed)

This isn't the case for the task_work based retry, where we need to
take action if the event triggered in the short time between trying
and arming the poll handler.

Catch this case in __io_arm_poll_handler(), and queue the task_work
upfront instead of depending on the waitq handler triggering it. The
latter isn't armed at this point.

Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that support it")
Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb25e3997d41..7368e5f2ac79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4094,6 +4094,7 @@ struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
 	int error;
+	bool ready_now;
 };
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
@@ -4117,22 +4118,13 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
-static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
-			   __poll_t mask, task_work_func_t func)
+static void io_queue_task_work(struct io_kiocb *req, struct io_poll_iocb *poll,
+			       task_work_func_t func)
 {
 	struct task_struct *tsk;
 	int ret;
 
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
-
-	list_del_init(&poll->wait.entry);
-
 	tsk = req->task;
-	req->result = mask;
 	init_task_work(&req->task_work, func);
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
@@ -4147,6 +4139,20 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 		task_work_add(tsk, &req->task_work, true);
 	}
 	wake_up_process(tsk);
+}
+
+static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
+			   __poll_t mask, task_work_func_t func)
+{
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+
+	list_del_init(&poll->wait.entry);
+	req->result = mask;
+	io_queue_task_work(req, poll, func);
 	return 1;
 }
 
@@ -4265,6 +4271,8 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 		if (unlikely(list_empty(&poll->wait.entry))) {
 			if (ipt->error)
 				cancel = true;
+			else if (mask)
+				ipt->ready_now = true;
 			ipt->error = 0;
 			mask = 0;
 		}
@@ -4315,6 +4323,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	mask |= POLLERR | POLLPRI;
 
 	ipt.pt._qproc = io_async_queue_proc;
+	ipt.ready_now = false;
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
@@ -4329,6 +4338,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	spin_unlock_irq(&ctx->completion_lock);
 	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
 					apoll->poll.events);
+	if (ipt.ready_now)
+		io_queue_task_work(req, &apoll->poll, io_async_task_func);
 	return true;
 }
 
@@ -4544,6 +4555,7 @@ static int io_poll_add(struct io_kiocb *req)
 	INIT_HLIST_NODE(&req->hash_node);
 	INIT_LIST_HEAD(&req->list);
 	ipt.pt._qproc = io_poll_queue_proc;
+	ipt.ready_now = false;
 
 	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
 					io_poll_wake);

-- 
Jens Axboe


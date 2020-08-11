Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53568241C12
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 16:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgHKOHb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 10:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKOHb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 10:07:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CDAC06174A
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:07:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so6868945plt.3
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bjLmjDHdUMGXBua+MpSAGyYvAsgTqJapHyb+SrygQ8U=;
        b=jBmyQnZd8imyhlNQimT1/GQRhWJLB9mGVdMHL3x+dpIb5u/H0wEgNEAAb0NcWTCkGP
         Dm5aaz7SVyl1oYTCFu2M+PlzFqlM0XH5s7qlvjC6nnW9E2kNNqQd2qkDlUAaTeumerP8
         QjbKLHqJcoca9GkiFpx5Ki64LlyC5zv9nrhkuhqoZCXPeCRS5oDhQ9vRoMKKZuxQX8Ti
         sT9IhTFK0mE6u92iXsVc/3t2tXWQNCCGxCuOYvJXOJJVM8wsOM+6ygmcaK//VgfCpFc0
         8BGX83M2qBYBX3RFE+XTmODE1q73mWYii/AG6uKTJjaPumzW6S006QjRK79lT0u6Dy4G
         +/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bjLmjDHdUMGXBua+MpSAGyYvAsgTqJapHyb+SrygQ8U=;
        b=iWj4ZUzZ5MKsNgvyxLjmAffMOJAUT3ARPYb7z6HDGt8vg0nRnbXean7VFYXLD92HyC
         8viqIzZmXXHEPtNdPnbETH1ULMZszsUH3w/TCKVp2evHDTRBM0N4zmaWOaKcgPzl6CsB
         Dles4WOGRbfXhdoABZ1pir7zQg59Tb/7PepG4OXgXIX4NLtJS3NRMtVFi32fajIm0mNg
         TbOzN990yXG9LCDiQoYCfOjHw7TuVyZFj+Bi7V0F/A83uD/DLmG9Lo+KYci3GwIzjYvp
         F8K1xiMH/Ozm1u2XT3Mkno1dYE/tyaMdQlAEOLGgSxF6r4Kd/YoW0cmNnv1JmqAu7YPR
         sVzw==
X-Gm-Message-State: AOAM532Tk91sGI8ML9iG1T0XpwwJ7pabOLlUYuD/i5kwOx1YcJABuCaf
        SgKvk752CsusxUb5e7abipoHhK6kS3Y=
X-Google-Smtp-Source: ABdhPJw9ewWZhNqm5mysWwhXW53q8njKLBy00Ab22zfa7oD06uOc8iazKFAODU7KLLLi5fpxecSRYA==
X-Received: by 2002:a17:902:9b97:: with SMTP id y23mr1078271plp.189.1597154850126;
        Tue, 11 Aug 2020 07:07:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d22sm25964572pfd.42.2020.08.11.07.07.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 07:07:29 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: hold 'ctx' reference around task_work queue +
 execute
Message-ID: <610d62ea-a9fe-24e3-74f7-72f9c464e48e@kernel.dk>
Date:   Tue, 11 Aug 2020 08:07:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're holding the request reference, but we need to go one higher
to ensure that the ctx remains valid after the request has finished.
If the ring is closed with pending task_work inflight, and the
given io_kiocb finishes sync during issue, then we need a reference
to the ring itself around the task_work execution cycle.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5488698189da..99582cf5106b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1821,8 +1821,10 @@ static void __io_req_task_submit(struct io_kiocb *req)
 static void io_req_task_submit(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	__io_req_task_submit(req);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
@@ -1830,6 +1832,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	int ret;
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
@@ -2318,6 +2321,8 @@ static void io_rw_resubmit(struct callback_head *cb)
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	}
+
+	percpu_ref_put(&ctx->refs);
 }
 #endif
 
@@ -2330,6 +2335,8 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 		return false;
 
 	init_task_work(&req->task_work, io_rw_resubmit);
+	percpu_ref_get(&req->ctx->refs);
+
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (!ret)
 		return true;
@@ -3033,6 +3040,8 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	list_del_init(&wait->entry);
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
+
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req, &req->task_work);
@@ -4565,6 +4574,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4652,11 +4663,13 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
 	if (nxt)
 		__io_req_task_submit(nxt);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4752,6 +4765,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -4767,6 +4781,7 @@ static void io_async_task_func(struct callback_head *cb)
 	else
 		__io_req_task_cancel(req, -ECANCELED);
 
+	percpu_ref_put(&ctx->refs);
 	kfree(apoll->double_poll);
 	kfree(apoll);
 }

-- 
Jens Axboe


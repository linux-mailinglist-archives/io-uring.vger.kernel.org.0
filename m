Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E96524EEF3
	for <lists+io-uring@lfdr.de>; Sun, 23 Aug 2020 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHWRFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Aug 2020 13:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWRFF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Aug 2020 13:05:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA8DC061573
        for <io-uring@vger.kernel.org>; Sun, 23 Aug 2020 10:05:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a79so3565495pfa.8
        for <io-uring@vger.kernel.org>; Sun, 23 Aug 2020 10:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Qf6TJS4T9y+v8Of57I4G/jyR9kP5q7LoI+sViYW/+90=;
        b=GRnzdOcAzgeNvLVmQlj2H4nZd78Mdl7Yr273zK22ttz8LTgfbtDJnhYcm07zAOnxCr
         zxEl66me1oKVSVLhC5ynHKfyNsw2v8s5s+fxuW1/sQKE6jDMd4rympcmeVodn780PTgM
         VlQ37jGawMva/27NwRrZscH7YaTxaZeH0U/BWWNsUFtuUTAWSVKQNmDWAXktqXWvOjXi
         RnMR+FmfZXIYxv9boq0I57DSwGbAfOSUziHEuwyuEjendqiU6n3v7//ymOtj2ODRU/CB
         67jUKSMOYDjn/lthoh8MrI+gFS6uwqTCymau7i0kuSik05t/xogyCqRjVXLP8/OMmWvG
         Y6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Qf6TJS4T9y+v8Of57I4G/jyR9kP5q7LoI+sViYW/+90=;
        b=purpwnaJNb9ABMn66o4pzzKwU8xwSyNBlgfafQ7TJq5VoykH4Y7ocpK/EWpbUGb7vD
         Yg8q9ym9+WqGRds+0l5LzrnUVcgBJq9SIaP7SHFJVTK3pw6nRd2YPB3W4ib4Xx4iNhHz
         MFfMDx2VjW6aci4V5uU8yvg9p0aa7jxzaGmePAKVSPHwkJFmo7yCFYSeEBSuSokCgFWF
         Vad5TzG7N+xuEq5wyqfbtTzgDKPxt2puwtv/j6//tmfHJpgzzhuHtmHZIvWmcjFj5mtb
         dwheL4/4La3+yHlTQs2hQZvToE/5/uaXrkYAMMLPF1FKiV4ukl9P4ftScfPmGigV5XiK
         XRuw==
X-Gm-Message-State: AOAM533v4hO40iH5FyVeOJ2y6Eb5QqB0hH0a8/ncY+7yWJD0kyHfAAMY
        T9QomQDxeKOyaWNtduV29rtPu6DVbCff1Cyj
X-Google-Smtp-Source: ABdhPJyB9A4qd0b+3i7APj5Tn7jmiCKVoyNuOzeOiL0HI3HJAXRCcZ4zNdXXGrpB+resmuht+VfNAQ==
X-Received: by 2002:a63:7704:: with SMTP id s4mr1154638pgc.78.1598202303432;
        Sun, 23 Aug 2020 10:05:03 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x17sm8399054pfn.160.2020.08.23.10.05.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 10:05:02 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't recurse on tsk->sighand->siglock with
 signalfd
Message-ID: <71d54db9-5415-5e23-96a5-8639f60b9280@kernel.dk>
Date:   Sun, 23 Aug 2020 11:05:00 -0600
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

If an application is doing reads on signalfd, and we arm the poll handler
because there's no data available, then the wakeup can recurse on the
tasks sighand->siglock as the signal delivery from task_work_add() will
use TWA_SIGNAL and that attempts to lock it again.

We can detect the signalfd case pretty easily by comparing the poll->head
wait_queue_head_t with the target task signalfd wait queue. Just use
normal task wakeup for this case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e2cc8414f9..c9d526ff55e0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1746,7 +1746,8 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				bool twa_signal_ok)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1759,7 +1760,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * will do the job.
 	 */
 	notify = 0;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
@@ -1819,7 +1820,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	init_task_work(&req->task_work, io_req_task_submit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -2322,7 +2323,7 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	init_task_work(&req->task_work, io_rw_resubmit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (!ret)
 		return true;
 #endif
@@ -3044,7 +3045,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -4566,6 +4567,7 @@ struct io_poll_table {
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
+	bool twa_signal_ok;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4580,13 +4582,21 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	init_task_work(&req->task_work, func);
 	percpu_ref_get(&req->ctx->refs);
 
+	/*
+	 * If we using the signalfd wait_queue_head for this wakeup, then
+	 * it's not safe to use TWA_SIGNAL as we could be recursing on the
+	 * tsk->sighand->siglock on doing the wakeup. Should not be needed
+	 * either, as the normal wakeup will suffice.
+	 */
+	twa_signal_ok = (poll->head != &req->task->sighand->signalfd_wqh);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, twa_signal_ok);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
-- 
Jens Axboe


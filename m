Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1D27F818
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgJADBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 23:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJADBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 23:01:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471DEC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:01:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id v14so1070639pjd.4
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=O5PUSLl8cGqQNtQPSxBlCUm6U7NUGIwB2DmbhFBVzCg=;
        b=rpk054gCVZDL7E2m0WnmWvLqsINwF5bnaKsen7DWVg4JgzspU0iQ8FL3W2vapk2I0p
         rBE6JK6kLps3Ubr9wQCBixdR7UV+P6v6ZYaLBxllAilTSVXG9Z0XnqqYoGj4B3aEs/H0
         Ih/D1fCB1KKkmyIzKkKQVKhDTmIn+J+w5b1NqFJ++WrWDsqvE47b8LZymnirFHRdWr9p
         WPRBzzUIOkohm2U5lzgd9uCBjH2DfDuKOfLqFlBPJqR8wZBn247sN5YYzea3bK2kQpfg
         YzHALpn8v4tPBHrEGZ9BgkD01wXnEi0wQN3Vefu/WOOZkUFYhe7dCPIfBwALf9HnbBM1
         ADIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=O5PUSLl8cGqQNtQPSxBlCUm6U7NUGIwB2DmbhFBVzCg=;
        b=pIOCDZvXkcmbt6oj37PniCAmzUR7jdNti8hjKnqW3NzvZ807VFRVwGcSmeSNLgLOe8
         JjVxuQnGV9E4MDtbfg8/9+dQ+wQFcXSBrB/JEkgCZ8VD7Zfmz2KmqbdRaZmHPcXjqAbv
         u3j50flkNQmo+geg2KknWJSxKtuHi//S+ktVptBUORrGECVy70IOuNaNg+qBa4ziTCsz
         xM2JCsqSOrHhewbDB1zYnQMeaiXVi5NUQohRmylQagVILkLG96bGdVA9/uVgVhYNzume
         FAZCr6woPD2Z8L861gpBPP3VsfUGI6ZeOm4IxAVPQD6QrT/aml69NNTUM3GMBBtyNo+f
         GYgg==
X-Gm-Message-State: AOAM5317q2E1nLdPcGGR6Leis+UjUW09nwgKJdO/FyA0CRT1Ya80cgtY
        lfKJ9denQqccZQXeEoCDvVSG7vSojTVRnQRU
X-Google-Smtp-Source: ABdhPJzDcTRxPV1riJDzCe0ItTR8k5u6PX/NqJBJNK1/PWCF565bYfTaRLy/LvDhBvgLVeEeE50y/Q==
X-Received: by 2002:a17:90a:a58d:: with SMTP id b13mr5134480pjq.196.1601521283383;
        Wed, 30 Sep 2020 20:01:23 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l3sm477537pjt.8.2020.09.30.20.01.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 20:01:22 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: kill callback_head argument for
 io_req_task_work_add()
Message-ID: <4004d378-331f-df42-c2c8-85b0433fabbe@kernel.dk>
Date:   Wed, 30 Sep 2020 21:01:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We always use &req->task_work anyway, no point in passing it in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f617f1a725e1..c409af7bd444 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1886,8 +1886,7 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
-				bool twa_signal_ok)
+static int io_req_task_work_add(struct io_kiocb *req, bool twa_signal_ok)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1906,7 +1905,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
 	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
 		notify = TWA_SIGNAL;
 
-	ret = task_work_add(tsk, cb, notify);
+	ret = task_work_add(tsk, &req->task_work, notify);
 	if (!ret)
 		wake_up_process(tsk);
 
@@ -1965,7 +1964,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	init_task_work(&req->task_work, io_req_task_submit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work, true);
+	ret = io_req_task_work_add(req, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -3185,7 +3184,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req, &req->task_work, true);
+	ret = io_req_task_work_add(req, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -4752,7 +4751,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work, twa_signal_ok);
+	ret = io_req_task_work_add(req, twa_signal_ok);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
-- 
Jens Axboe


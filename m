Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494EF3F1D42
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhHSPtY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 11:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbhHSPtK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 11:49:10 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6FC06175F
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:48:34 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w6so9061792oiv.11
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1IHhVtJKvwGU6Cdpyd2gAPERgP8wHposKfvliwJcMUs=;
        b=VlvPAcuO1J+eKDfzykyEAIgitAovEPzJfn0M06DJYo96hV/trskC1LNN4OaoccGG/v
         N5Gp0U/UyRIeEkAZ5OBgxvcfd0A2PpALiRwkjsAQzOAzcykJ/T6cMGq1Wa9Admupja5o
         AY68iioVLofUPAksSzXbeKG4Ql1xyg8ab/GaXl2kUDuYjS/5LK1WNhdKRjMeq29pVXiP
         V0aAfZ6AK4vfulEFh0vlPNIcKuJxf+WFzrWzEwXFZR4EZivyffBt5Z+F3BdRSdVTSats
         Onh3cddBQy58Cfo3aodHPPBFfhiUZzOzs6WtZGuolLI6KkYMp+COoMYZ7RvAMOJuGQ1W
         GhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1IHhVtJKvwGU6Cdpyd2gAPERgP8wHposKfvliwJcMUs=;
        b=BueRpPaFCBpLiYC/hYw6IuyWZ0OM4gHVCHBKfh0Mih/9mhF9f2ySJxzLbZQ97lBAZ5
         JvHYni/2cqnx6ffMdIQQkNa2Rn4gzgeO4Yyvyo6gVu/Ssp4jwy0uS5fsNL8WGSiPmH7n
         nwpJyhPFVooyScHnDO7bIZmhL+UH70lmNbI/LkS9hWhvNaYXgmUL49Pg9QY3vy9sPQYC
         iwHcwZ6I/o19i57uzupkrysUly+rNiYi8VfIJ2QcUq4MEkpyH20sEDXj7J27wDQSpV7k
         qLUmGe8o3XXW+Qy22NTtCIluDKhexSUROOW/ChLKqOIoNo6mWYzlyvjQbDnAq5+CYSA0
         1MjA==
X-Gm-Message-State: AOAM533uJV25EvQUj5UrMDX2ST0etCy6O2BVjXZ4fm3l8Z3KYg9Yoe/F
        iIB+94kl6BBSfrd4mpFMKEqYYPPSvV2IhAvX
X-Google-Smtp-Source: ABdhPJwc/T8FcjUxU9MRG+4knVohcYDqUt6fLpMtCwTE8a5YmNGKzWoM968+Hho2fWbrJzWkWutw3Q==
X-Received: by 2002:aca:bd8b:: with SMTP id n133mr3152339oif.75.1629388113383;
        Thu, 19 Aug 2021 08:48:33 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i19sm689098ooe.44.2021.08.19.08.48.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:48:33 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
Message-ID: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
Date:   Thu, 19 Aug 2021 09:48:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have two checks of task->flags & PF_EXITING left:

1) In io_req_task_submit(), which is called in task_work and hence always
   in the context of the original task. That means that
   req->task == current, and hence checking ->flags is totally fine.

2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
   it interfering with cancelation. Here, req->task is not necessarily
   current, and hence the check is racy. Use the ctx refs state instead
   to check if we need to cancel this request or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30edc329d803..ffce959c2370 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2114,6 +2114,7 @@ static void io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
+	/* req->task == current here, checking PF_EXITING is safe */
 	if (likely(!(req->task->flags & PF_EXITING)))
 		__io_queue_sqe(req);
 	else
@@ -4895,7 +4896,11 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (unlikely(req->task->flags & PF_EXITING))
+	/*
+	 * Pairs with spin_unlock() in percpu_ref_kill()
+	 */
+	smp_rmb();
+	if (unlikely(percpu_ref_is_dying(&ctx->refs)))
 		WRITE_ONCE(poll->canceled, true);
 
 	if (!req->result && !READ_ONCE(poll->canceled)) {

-- 
Jens Axboe


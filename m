Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D01D7F9F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2020 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgERRGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 May 2020 13:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERRGN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 May 2020 13:06:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8930C061A0C
        for <io-uring@vger.kernel.org>; Mon, 18 May 2020 10:06:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k22so4469785pls.10
        for <io-uring@vger.kernel.org>; Mon, 18 May 2020 10:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Dj30jxO9KJK7U1cReyW7xWHgbUrr3YnahXSEyL7cKBU=;
        b=RrAMOuNRDr8wC09N7/79Y6sTfb8LMS4398Y4DZ444n9DIf+DhazA7Hysm/lXjq1SJX
         miZI6HMCzv9ouKS94rYWVDrlMsxHUB3rkPvV2iWWn8tkEJ7RlbWI1X7TFcrO2FhbJ9uU
         64q8shPhJzXgY8LSqfPH0Qpi/dVTuv+5GzglHD2+Q+9RRPfrTu7ZH8/8QjUkLnH1vgGw
         y8Ev3o3tWRze2rVcTSmdVQDVk7mbMs3VZYYtC5+MSHxGH1K4LP5U42JCGtyLldn5gdBR
         BWVpAdA4fQx4ZWGKlcvJEczB306iyr0kLzj6CcLV427KISJmv15zfmBN59LWkna6BKmz
         anqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Dj30jxO9KJK7U1cReyW7xWHgbUrr3YnahXSEyL7cKBU=;
        b=pRDZcZNuvlYBS0wE5Vs8+6kaEsmBgEgu+wAvPHsx4RO7/OdA8pvqsqDNtvzNfes6cc
         3g7WAvNxOv8aX0gfpeqzAhXkxCkNkS33q+zYiCUbqMefHCO0ycTPlq48ELkab7W5Va9K
         4u9RmYdWqrV7keaX7xhD2+aas0Z5IK1TD0JEfz7Kxhyv5DRubGeXJIDV6aiiYhNL7ks4
         6EmTMYI2zRnpTlJH6o4aoeJ3Tij8Ter5K+ef29SClE/uTJW1rg5LmGO2LlweZ5EWLjyJ
         jSIy7svCG6gCY1hqPPOQ7amv6pBre22/tCPTVUnFCnF9k9KiWr9+2CR9fAnly9cTkty9
         ShrA==
X-Gm-Message-State: AOAM532y+8kh68iwNtlLfGvaOYcFhAqld1i5aylHggCeB/Ctfv5LEIL3
        yUmpgDXo9n+pCjoCdLC8ZKGY2TocvaM=
X-Google-Smtp-Source: ABdhPJwnyxeu1FcrxZXoMUrYXRunhXkHmuJn4J3XOrD7V47iTuyaT8LzQxBNFxKMBQpeMXFG4YSjzw==
X-Received: by 2002:a17:90a:ad49:: with SMTP id w9mr438262pjv.20.1589821570779;
        Mon, 18 May 2020 10:06:10 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:181b:27d1:4003:7a84? ([2605:e000:100e:8c61:181b:27d1:4003:7a84])
        by smtp.gmail.com with ESMTPSA id ce21sm90584pjb.51.2020.05.18.10.06.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 10:06:10 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cancel work if task_work_add() fails
Message-ID: <1f40ba1e-cd59-e097-5425-b96014e2b0fe@kernel.dk>
Date:   Mon, 18 May 2020 11:06:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently move it to the io_wqe_manager for execution, but we cannot
safely do so as we may lack some of the state to execute it out of
context. As we cancel work anyway when the ring/task exits, just mark
this request as canceled and io_async_task_func() will do the right
thing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ecfd7f054ef6..29aa53000def 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4135,12 +4135,14 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	req->result = mask;
 	init_task_work(&req->task_work, func);
 	/*
-	 * If this fails, then the task is exiting. Punt to one of the io-wq
-	 * threads to ensure the work gets run, we can't always rely on exit
-	 * cancelation taking care of this.
+	 * If this fails, then the task is exiting. When a task exits, the
+	 * work gets canceled, so just cancel this request as well instead
+	 * of executing it. We can't safely execute it anyway, as we may not
+	 * have the needed state needed for it anyway.
 	 */
 	ret = task_work_add(tsk, &req->task_work, true);
 	if (unlikely(ret)) {
+		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
 		task_work_add(tsk, &req->task_work, true);
 	}
-- 
2.26.2

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E735C50EE43
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiDZBwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241436AbiDZBwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:16 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322B212010E
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:11 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d15so14400720plh.2
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=s69QZtRGH9y9iFn9IGmPIHWqYIAND61qWCU1ZDpLnC05Lt8wGP3jJiJbPEIYsaHwE1
         eYhynL0fnMZjJ0SXJ1Spey9xBTgafgj87oOS/mr7sYqq5trzevd1OAhkmq51zq8Fa/vt
         JLotS1S+R5HSz5CNqBvq4ccT+yHBngwfdpFx+McsSA33CTapWztlJlqwh1SuTI3A0jKU
         ZLwzGMXRLYjdAG6di38h6V58jMnQhUaM5N9KopNhlBsrk8GGYezeo7UpDrWta6tW6gFo
         C4u8ar4hLiLrNerIpLao6CHiqMLMb1rcwSmXdLn/bhL799NBxMpsv2lhn0pPb9wFTj5P
         m4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=5Xs9+FpzTdCSL8MGWEeVG/Law7w+GGLZGzcP77cnoA8WrhFDCNLP3CXVwaASBFasvj
         T1mamqrev6QtmjWeg3ub8K+L47HnmggzFd3a8hTsBFvyZVhINDLTsBJqLvSNGUnRWqEH
         nD9jQv4QYXDHAiktCDuGe+U6Y9mUc8SxK0bKMNVa+Jlep3mRzQi/p6DUGLQwn2sqAOA3
         tVGsN1TlDhRORJS3ROYoGwDR21aWFoFNls3b/hWDZvo5uI6TKthOrNHzpJw4P7n93fy/
         TuONXXNcRT/L/PvGYdEewwESmpTCesgDHzskxPNl3I/i7FfwYuaE0OHvqcMoirhKibNz
         TjTA==
X-Gm-Message-State: AOAM530DSVi691scvT6Le5EwE4K1ZyLNwreGYo93nmnJi4TkY5F5Wl2X
        US7X9xEZjt3Bt8+x+eee2/G2UMHsgOcXM7vY
X-Google-Smtp-Source: ABdhPJzRJoq51TVFpAYG0Eou/YeiLp9Iusm0eCIyavbAdIs5PF3SWPXOOM72g9Q2lHAdfSQO7hxmow==
X-Received: by 2002:a17:90b:1e0b:b0:1d2:dabc:9929 with SMTP id pg11-20020a17090b1e0b00b001d2dabc9929mr24266254pjb.39.1650937750178;
        Mon, 25 Apr 2022 18:49:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io-wq: use __set_notify_signal() to wake workers
Date:   Mon, 25 Apr 2022 19:49:01 -0600
Message-Id: <20220426014904.60384-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only difference between set_notify_signal() and __set_notify_signal()
is that the former checks if it needs to deliver an IPI to force a
reschedule. As the io-wq workers never leave the kernel, and IPI is never
needed, they simply need a wakeup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 32aeb2c581c5..824623bcf1a5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -871,7 +871,7 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
-	set_notify_signal(worker->task);
+	__set_notify_signal(worker->task);
 	wake_up_process(worker->task);
 	return false;
 }
@@ -991,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 {
 	if (work && match->fn(work, match->data)) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		set_notify_signal(worker->task);
+		__set_notify_signal(worker->task);
 		return true;
 	}
 
-- 
2.35.1


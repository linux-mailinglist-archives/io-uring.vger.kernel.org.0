Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA16750C2AB
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiDVWnI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiDVWm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:42:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AC415279D
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:22 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so13641454plh.1
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=teLd7LKBbD9eJeb6tUNL8+euaXv2rgG0vlh1gClbuqGXZ6g2sTGVTECQVCsgMAzmMa
         jssWj2JpCfGF5L7KWiT9rRmDA1GcfyKnaivvdM9CN+m+m4R5sdUgMh715XLog5bVof7J
         +jPpGMXBXl9HBbB0oPRo5KwflGYubLSbXBnhD6aUdosDbA9wJTNPjrIuM2taE1G1CWdw
         A4aiPLwo+fOVX36me+EgRal0LZPW8D5VlRFN4gIqqfchvQQPfVRMbFruyfSrY6wrZUQV
         B0eF/IalmGixtU3QKi9nvOQKv9EwX86/MP6GA9dKINlPJg9bJMLujqdY4QMnqPcakKt/
         mTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=4lE8IkBEML4AagEMAIyz4/9GwyJNAzUwTt6wvz4YFc+divtCLRQz7U3/1QhEYuUYMU
         jLZ4aHCVWcmA0UZuP6o3J7tmvl1+3lbfvwMpwxkPMLCYGEALNj8m4yTLs7YQ7V7mlTg/
         J99kz+kgkzHliJJ6EKYfWPzBy8U8MHU/kHM7E5DAvJNAj01LiOMVJezqUEJESt3X9VuW
         CTNNhbste0d6+ybf8yLCpV8MC/bZFxpqcJ2JbX0lcgZDH6EKHJLP1eYX6otzGCvJWflG
         hr4qqjhW5xmSFms8l+C39YtLiWLlhWuCzPxmZ9i6btujsBAiYL+BtyijOcwmOP60SSpB
         CaYA==
X-Gm-Message-State: AOAM532ASTq7XrP3MYyoc0W4PpOKoQTqFyx4ZQ10dWTm/NWR7VY3i06f
        1SuMgterLINPLUZhrJYMEg9tcLZQhwMr456B
X-Google-Smtp-Source: ABdhPJxOODfvu4zvvrUL/r7Br10CEPeqUuHq7Nn3FPkktDyHRc65IthHNlpe+Gcsac/GUN3He2EI8w==
X-Received: by 2002:a17:903:1108:b0:156:73a7:7c1 with SMTP id n8-20020a170903110800b0015673a707c1mr6425576plh.101.1650663741247;
        Fri, 22 Apr 2022 14:42:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io-wq: use __set_notify_signal() to wake workers
Date:   Fri, 22 Apr 2022 15:42:12 -0600
Message-Id: <20220422214214.260947-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422214214.260947-1-axboe@kernel.dk>
References: <20220422214214.260947-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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


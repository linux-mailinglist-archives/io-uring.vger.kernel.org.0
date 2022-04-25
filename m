Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5812450E2F2
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiDYOY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiDYOY2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:28 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424A8220E2
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:24 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r12so15987469iod.6
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=vnX9EHkKIvPw9x5KG4VCvOl8JXNRUa4TObinP0yqluVIVLa9W9C9cAXfVw+hI1ZiiI
         wNP+4N6QqlyxY0qCzglkgKeXoiEwgkr/rplNrNs2XWNmgJs0EN7kSaluk0ifSsCA9FzV
         eN1GZ4Nyc3pLtd+dpBaEQfY7+2onlhvUAz0j9pZnQj5yeY/FxmyeYRrawMAg+FHj9HvP
         E8x2Q+y2NGwC2G4P8FZWiHUEms805AJsjwb3uhM7O68X6Q6SfpVzfgkG69gx4YPSV9oD
         22sH6HE5tPxDeIuAiwlL/OynrDSRhUjg0sD0Y2NQrZmto8sD7qLsBlR8JJxtaAv3uFTh
         NDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=DqOddBT3Ff2NYw4FfPc0ynQmkye3cDFci6ZzHu9m8rdl+fr+7aS1RAmV6CG/gCWhjV
         kozV7scs79xOfqn2QqIHb5MB3a1nREyXDKKcKifpT/qVGzcnsYGbov9Kj5r/M6ohsX81
         exgoKSbgyQdJhulYYfsLQJTRkGyAsMxemNbPlBHtFC/RCsAdpauiMjF9wh0QeDnuGAjv
         KyuUqyVH+a00lHxHrM/y1uOsF2o6ovd0n/vLhLwrFrgFyFqLy6PzG7P67t3GVWO6Vc1O
         LCk0z4Vd9UhXU6mHJ89kQM0E+aSkXsr0oHKEfC65YzuNuYwsjEHjE5keyewAQs2WhnhB
         zuxw==
X-Gm-Message-State: AOAM532fDZ2l+GDk579hOKc3BW7Gx+lOrFg6ROLr/ZgYFvWV8WNKzkJz
        YoUufaWuwxanRjcdTT9OkgKNiVqwlO81+A==
X-Google-Smtp-Source: ABdhPJyvk6BA5EiBGJ86KevyjG9rGV0rlX3N63ScAXUjVo2sV/Q8hJfafDS0dJo+kF/E5F9jWDdqDA==
X-Received: by 2002:a05:6638:2686:b0:323:bbe5:4f6c with SMTP id o6-20020a056638268600b00323bbe54f6cmr8193890jat.100.1650896483367;
        Mon, 25 Apr 2022 07:21:23 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io-wq: use __set_notify_signal() to wake workers
Date:   Mon, 25 Apr 2022 08:21:15 -0600
Message-Id: <20220425142118.1448840-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425142118.1448840-1-axboe@kernel.dk>
References: <20220425142118.1448840-1-axboe@kernel.dk>
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


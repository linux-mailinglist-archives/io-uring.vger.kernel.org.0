Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3721E508620
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352341AbiDTKmv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377798AbiDTKmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3922F3F887
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:39:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d15so1394511pll.10
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3WnrEnYNg1g0Dh4Tvap8h2GTaws8qD5fgOoS1LiUEFc=;
        b=Xuxr1GZJYJg/zeIBpiAKZU5dshbK9bjWtj3Skoa55KYBtT3V0eojpeqSr2UCxenUuZ
         EG9wNUu/cdm0/GsCg5FelU6BGDP25uT8VAjbrGc1SMRtzUNA/w5F98jV9AAyF0QmJU/0
         QsQgxMLaOxvztERzRaf0WIN0gxfYE2HynaRqEHKJWgEZtgukD4OQ9FJ1rmGSLrHSMhi7
         Uu42wV4oH3ENUx9t/9w2j+yO6tx7Zu1BDP3Q/jYWZzetAwIl6acD98kr/SZV6qy/5buD
         TZrQiULxj/WfG6s9cNBHJtXYRulfoZVprchDEzx5EnE5wDuUCvXAAb7IQaLR1JgAp4F0
         dlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3WnrEnYNg1g0Dh4Tvap8h2GTaws8qD5fgOoS1LiUEFc=;
        b=DYitpRruxnVAYLz9JUvPAmmv14iOnWY6HZ/xD3iPTIOzBme3RdNl5i9W+SfKSCC5y5
         qGrXLok5XDQr6oSRZ4CPeKva4n07KolN0PIg8BPy98ZokX8ockC9J/cJEG95Nt3qDhxK
         ovx9q6wYw1KCju8Fz1z2BmfFOkTXqIX0zmWdhveTzvB1WYkIf+yHBi0d9QP4TdL4Yw5j
         zOLHj1sxEQTaOTJ9FhbD9gXito1jdiWnu8kn84eKCxIm8gihAhASa2/7D8rUDaGl+Jmu
         fYIrU9rV7QtU0Sg4TBabFp+rtscooCQKHXlKQkZ+9OjDWHbc9wLPZJRw1BbAUCRtmoMZ
         0Ftg==
X-Gm-Message-State: AOAM531KcdAt7Gx07fC/R/oOttHLCclKhMj4v+CAduigkOoyUh5MCeFg
        a8NKd3cEj846z5p1kycDK72gXD/k1cAZfA==
X-Google-Smtp-Source: ABdhPJxuljgYwk5A90rz9tGXaEkwaWfmZt3t7FEgjwvDhOthUyKyajiqB6lyj5alnBfrREh/ADuELg==
X-Received: by 2002:a17:902:a714:b0:154:6dfe:bba9 with SMTP id w20-20020a170902a71400b001546dfebba9mr19913615plq.124.1650451198636;
        Wed, 20 Apr 2022 03:39:58 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.39.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:39:58 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/9] io-wq: add a worker flag for individual exit
Date:   Wed, 20 Apr 2022 18:39:52 +0800
Message-Id: <20220420104000.23214-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420104000.23214-1-haoxu.linux@gmail.com>
References: <20220420104000.23214-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a worker flag to control exit of an individual worker, this is
needed for fixed worker in the next patches but also as a generic
functionality.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 32aeb2c581c5..4239aa4e2c8b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
 enum {
@@ -639,8 +640,12 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
+		if (worker->flags & IO_WORKER_F_EXIT)
+			break;
+
 		set_current_state(TASK_INTERRUPTIBLE);
-		while (io_acct_run_queue(acct))
+		while (!(worker->flags & IO_WORKER_F_EXIT) &&
+		       io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
@@ -656,6 +661,10 @@ static int io_wqe_worker(void *data)
 		raw_spin_unlock(&wqe->lock);
 		if (io_flush_signals())
 			continue;
+		if (worker->flags & IO_WORKER_F_EXIT) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.36.0


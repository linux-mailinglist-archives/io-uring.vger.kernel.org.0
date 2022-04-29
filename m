Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6EB51467C
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357321AbiD2KWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiD2KWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:16 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231385006B;
        Fri, 29 Apr 2022 03:18:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t13so6175732pgn.8;
        Fri, 29 Apr 2022 03:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojYkz2WFnCyMkIo6Kcyb7VK8syyaiI7oyaliYd8tciM=;
        b=Wvgfd4XGjkZMc/TTyXhiWMWrxSAs+uCdtRlewuOHb+p0JGkge4uCjqOOzuHXxF/DX7
         PCQjYq17xQj6dpyCAIUUoQQjjdsZ83SjL47mUObUTwvo2M/PJhDgsw1RhQXkR5mEhJHf
         OTF53kKT+TP95T3Pl8sRX/JNQyVS9mhsF02QquiIV8YlTFJ9vkmUJ3ygL+JtjAN40Hr7
         Vj2zYF1STxO/+Z6tbDssS8gzSXGhU+zBmNqIL0C0pyaKOM+qRz0XUDntdgtw2IKmr69j
         iDPYxj1ZnqWH0kr7cnzfGaiCYqZvj3dU5euHQFSvoUgCXTC7uWJrwWSl9CXauBIPenCf
         gQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojYkz2WFnCyMkIo6Kcyb7VK8syyaiI7oyaliYd8tciM=;
        b=llIwZdorYucztVy6nhqJKurYnVPkniQ+V3afgqljU9dVs5iWdDeV30FfXbRPkYkqVh
         Dfv8+DphFmhbFK53Guq5iqy6QaPPZfxwc9Px61ZJPFj2PenOmZ2I3bxwJUrIO+yuq6w9
         C79MOu6WwtxDYg3jqSGiumOzLWH8Bo9bv4bz8UvL5rYH4Q+dKm5LLqxSp74JbyG3OMg0
         pOL4WrfHe2Ar+sNk7X3L7u16Znt7Uiw2fz432d6ay6OO5KYdGNhtu5ULbGNGEScoS6Uy
         caC/Oh84JJXJtuoBMZ7YP1D4is0TUmOl9KLrZUpXKh2pjveL5UdB0tcIe1GRqZx+h0y6
         HZjA==
X-Gm-Message-State: AOAM530jhMcgjm1w3OR6MreRu8UtvCKU8MvOIaOekDZeeU9H3IoNWCpI
        R3BiP+5npo7iDUI8puzPujqOV6RQWeE=
X-Google-Smtp-Source: ABdhPJxLV/pnpnmXeOT+7c3YZtblxroNP3GJskLx7gMBFUlfMz1coovzCx8cS+3gRjZcBgPZopAtyQ==
X-Received: by 2002:a05:6a00:2258:b0:50d:9c5d:e1fd with SMTP id i24-20020a056a00225800b0050d9c5de1fdmr6910614pfu.82.1651227537553;
        Fri, 29 Apr 2022 03:18:57 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.18.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:18:57 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] io-wq: add a worker flag for individual exit
Date:   Fri, 29 Apr 2022 18:18:50 +0800
Message-Id: <20220429101858.90282-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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
index 824623bcf1a5..0c26805ca6de 100644
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


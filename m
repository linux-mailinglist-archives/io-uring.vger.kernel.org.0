Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C910552DFE
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346590AbiFUJKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348472AbiFUJKb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:10:31 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451BF9FF8
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:30 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id v1so26026446ejg.13
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66rhTpeiVCVuXrNZ0fvyk2Otyipnp7dr2D8O/HIACXY=;
        b=Ji0Az+Bqpvob5g4KPz3IBJO9StokKvbgEnnUTSq5wXpUUaVQTCFrWw2oztF2ZqEuhq
         /W97AJt1h36JnSXQ1xlGX4VgPbGAEHoMVpJrB0hPt6ix6b54PSVThXb/IZDTR0OQcohJ
         Q6qK3+pMR4ZSsZS2Er3GjeuCyrWSePxNjw84897xkl+pU0PUmzcXvkKc2x5tHVARzstC
         f4W9XxfHJT4X5iXby0uczlSJLyadZBzWuLDZr0s0acCsRhlwO6gjqrA7BaVICKpMnArP
         5yvlbZVSEcYsG/KB742kREctvuSf9SP4KhXjJsVn/asfM+gNXQB/MpD8Qs8kJmeHxYQJ
         lY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66rhTpeiVCVuXrNZ0fvyk2Otyipnp7dr2D8O/HIACXY=;
        b=SZTH0kBQ7n1yihHnfcI/wNQgjYT/8uC74OqvQmv5qkMLxSTR9SPV8+Ag7X+VRqwBZN
         +eb5Za+6qQ6/ceP8hNPrXIhVNGO+PuKDVqR3v1Mw4GpdopOQ5LY38D7to98Bfj4UB0IM
         vBSzGTRvwzm6NtVVxQIIfjU33cjLIKkOa98I3xY7ZnZy0mcAL7TPipdUsxTesHvAI/CU
         QyQRLoF2BO7MrUM+wlm075YOi1dL4Xejj9BopCmB46Y6BrlLiR8l4K92AZVKq1fpxjMR
         MqqIy+RrLfu4hJX8ikbp9rE8kTqRYcwxbBnAYoQ/5sDjoPaKefXxZNXzAcS8mOEAd7oK
         p2PA==
X-Gm-Message-State: AJIora/btDw1z+p510RulccUUXXhDeb27b8HJpBbGC0ES2K1UEjel1Wy
        fZBipY2lPktFp7b10+Ve6Do1h6SZAR8EMg==
X-Google-Smtp-Source: AGRyM1surNjNq7ra3BGj658lNlBiNgqAqr9usD4KDdVUq8i0RNzAtg0khVWeOL0nVsU5oQSEJfV7KA==
X-Received: by 2002:a17:906:9c96:b0:711:6c3:c9d7 with SMTP id fj22-20020a1709069c9600b0071106c3c9d7mr23472909ejc.60.1655802628561;
        Tue, 21 Jun 2022 02:10:28 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:d61a])
        by smtp.gmail.com with ESMTPSA id cq18-20020a056402221200b00435651c4a01sm9194420edb.56.2022.06.21.02.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:10:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/4] io_uring: dedup io_run_task_work
Date:   Tue, 21 Jun 2022 10:09:02 +0100
Message-Id: <a157a4df5fa217b8bd03c73494f2fd0e24e44fbc.1655802465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655802465.git.asml.silence@gmail.com>
References: <cover.1655802465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have an identical copy of io_run_task_work() for io-wq called
io_flush_signals(), deduplicate them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.h |  2 ++
 io_uring/io-wq.c     | 17 +++--------------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 6b58aa48bc45..fb5a274c08ff 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -2,6 +2,8 @@
 #ifndef IOU_FILE_TABLE_H
 #define IOU_FILE_TABLE_H
 
+#include <linux/file.h>
+
 struct io_ring_ctx;
 struct io_kiocb;
 
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 3e34dfbdf946..77df5b43bf52 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -19,6 +19,7 @@
 
 #include "io-wq.h"
 #include "slist.h"
+#include "io_uring.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
@@ -519,23 +520,11 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	return NULL;
 }
 
-static bool io_flush_signals(void)
-{
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
-		__set_current_state(TASK_RUNNING);
-		clear_notify_signal();
-		if (task_work_pending(current))
-			task_work_run();
-		return true;
-	}
-	return false;
-}
-
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
 	if (work) {
-		io_flush_signals();
+		io_run_task_work();
 		cond_resched();
 	}
 
@@ -655,7 +644,7 @@ static int io_wqe_worker(void *data)
 		last_timeout = false;
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock(&wqe->lock);
-		if (io_flush_signals())
+		if (io_run_task_work())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
-- 
2.36.1


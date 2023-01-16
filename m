Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC57266CB11
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjAPRKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjAPRJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:31 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C607C30B11
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:02 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id n7so1990535wrx.5
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFfuY2FIYBGT3MQ4l0bmPjzvtk+g3u3hZ3J6Nx17mmM=;
        b=fWjCS6PiknUy8oedOnmk3DMiZzXxq7my0qw4+Jeb+NemqBK7Kok39qajOcIZSYrMnc
         WmWaDPzgPr6bGJ+crAXMc+1O/VG/HmwNqNe/a1BLkPqXUVlfSg6+LU653SRMPekFMQGK
         LzlRg/7rHgoQsSLNS2VRQxREVsEeyTv9EzG2UyAWJRbsH8LqZvpKe64+hzkDAFa1eDJM
         PeHqVmzK9Q5torOLAOKgslOdTC+EEcImI99eWgM8CuYp1CMDWiMVqzY6myYJyHxAsktC
         DMyQOEirJlsfG/fxanTzS8MVWrPFolcPDRgFGeiYBbcQvvagOpP0MdXO1rluSICpdGPV
         Igtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFfuY2FIYBGT3MQ4l0bmPjzvtk+g3u3hZ3J6Nx17mmM=;
        b=p6oMLAZupeeBzmqlb7CmRg9/tBlAJdyr9YEpVQUaOKkPFa87q2WSExGmZ83vXiFSNs
         iYcnl1FzX5E23vSqKqYD4SC5JhhYIdvpZWWV+iUc6vLxEtTwotCG4/h7QhX8O6rNt4mq
         cdm5Pw30pt6/jg4XZIo7j/9prMuZkkasLRMGVVGDLGBRAbeHHCiWN4xtfjKl8VYhdvwN
         dTo+ZVR/WcgT00gkrYhMJXAlmR/7qItcqLYcNYlRtK9Hlazoetx8RQWQbnbCiv3QFbV1
         9Ek08d/bk61XF8a1gMeZA6/1lToFBmBiD5cpRWrz7+nISbmeaOsvb+AWxnXYlg4HSWCF
         vN9Q==
X-Gm-Message-State: AFqh2kqFAfZ9F0Jd9Kiu9cixdSunFR+VOixT34wTtJo7HLitVXpjVr+p
        mxQeUT4TninbIcxR6FcmQC4YrgOXPZo=
X-Google-Smtp-Source: AMrXdXvNFYEQ3MgTKt17fYr+OjrWS2fJ0hi/d/6EI+4NKf2GxspQ1+0vJnaMDa/a3bLt5AFD62pqyg==
X-Received: by 2002:a5d:4e90:0:b0:2be:127a:6cec with SMTP id e16-20020a5d4e90000000b002be127a6cecmr117624wru.49.1673887801214;
        Mon, 16 Jan 2023 08:50:01 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:50:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/5] io_uring: don't export io_put_task()
Date:   Mon, 16 Jan 2023 16:48:58 +0000
Message-Id: <43c7f9227e2ab215f1a6069dadbc5382bed346fe.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
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

io_put_task() is only used in uring.c so enclose it there together with
__io_put_task().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 ++++++++++-
 io_uring/io_uring.h | 10 ----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5570422dc2fb..1b72ff558c17 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -715,7 +715,7 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		io_cqring_do_overflow_flush(ctx);
 }
 
-void __io_put_task(struct task_struct *task, int nr)
+static void __io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
@@ -725,6 +725,15 @@ void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	if (likely(task == current))
+		task->io_uring->cached_refs += nr;
+	else
+		__io_put_task(task, nr);
+}
+
 void io_task_refs_refill(struct io_uring_task *tctx)
 {
 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5113e0ddb01d..c68edf9872a5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -70,7 +70,6 @@ void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
-void __io_put_task(struct task_struct *task, int nr);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
@@ -319,15 +318,6 @@ static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		__io_commit_cqring_flush(ctx);
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	if (likely(task == current))
-		task->io_uring->cached_refs += nr;
-	else
-		__io_put_task(task, nr);
-}
-
 static inline void io_get_task_refs(int nr)
 {
 	struct io_uring_task *tctx = current->io_uring;
-- 
2.38.1


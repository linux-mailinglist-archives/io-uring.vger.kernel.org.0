Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A7933A81A
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhCNVB1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhCNVBU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6C5C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso19070972wma.4
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jeDNcF+vZVYLbmD/x1US0KwS5uMa4XuQx5FZs2J9Mek=;
        b=oaCirBjru4aw1ZqHId/Qqf5cnhwJahnbuv8QjbNWUIPJyfk9CKrak0g5AvE8AEDorE
         qyFMpYgdlxq2x11B2/Am9iSz4ON2uTKwMVhYU+WQbCs5NSp/wFrUs2KYrbsWftizNa0q
         kHfMtBMnETBsJXn0M5jreA8YFTiH1MNWciLDFkh5yTEuw2rbzFuQc8+sGA1ly7aR3P4t
         fHfxp9OFY9f1Y+M+ClU34BaeNTHArxX7bucjtDBG2SJMFQDYgxGCWohkUuYv5XUoqVKw
         UJwefpA8MYwOW0G7C7ayNdQ7+Zfd9OKYlL9H7VZIi/ez3pTF+HsaWMH50gSwkcocNTuC
         9LKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jeDNcF+vZVYLbmD/x1US0KwS5uMa4XuQx5FZs2J9Mek=;
        b=gWSvWnY2ZsG5G3etSBHNlSw/eEVu+Riye2GBnGEmXEfk84B/tCYYFJVK09yTqMZTSz
         asnpAiN8yg7m/lFLlCJ5/xiUicgnSMDvolNF4Cw2Nohv1UZ6llUBh7s7LDgozVjL9cC1
         GgKAXHtqJs958woXnC15JLFb1KHEgFHIzeeZ/hOeIsllQg7N3WFkyZ1heRC1UY78QeZ7
         2bziN7ibo4UZgB/gJ3BnzkJGtp3xR+w+wJSNsLoxWwQCFduQbWu2rMQoXrIUupovLc6g
         opnlQaziKRuwzcwvc2ITUzm7aP0HSiPNLg/1JJlc1sTN7sIQATwWS8SCRx6fmlGckHRK
         kw/A==
X-Gm-Message-State: AOAM531MkJe4umKsI0xIrxnsKiopWDzDMTFEY3N8EyUNG7w3Zloa/+IZ
        FVTZ/vCdA3/eEUJ0lQe2TPlO78UErgFpEA==
X-Google-Smtp-Source: ABdhPJwuFKQphlPlEseOpKgd+DfplL/V5eRh26l6Idgxpe4lQkGCGPH7KFT13DDViL9fTICJ0Wh14Q==
X-Received: by 2002:a1c:dd43:: with SMTP id u64mr22881883wmg.160.1615755678450;
        Sun, 14 Mar 2021 14:01:18 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: replace sqd rw_semaphore with mutex
Date:   Sun, 14 Mar 2021 20:57:10 +0000
Message-Id: <3137484129e298fb384bb8c62cf9f707d3a51c51.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
References: <cover.1615754923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only user of read-locking of sqd->rw_lock is sq_thread itself, which
is by definition alone, so we don't really need rw_semaphore, but mutex
will do. Replace it with a mutex, and kill read-to-write upgrading and
extra task_work handling in io_sq_thread().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6548445f0d0b..76a60699c959 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -258,7 +258,7 @@ enum {
 
 struct io_sq_data {
 	refcount_t		refs;
-	struct rw_semaphore	rw_lock;
+	struct mutex		lock;
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
@@ -6686,16 +6686,15 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	down_read(&sqd->rw_lock);
-
+	mutex_lock(&sqd->lock);
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
 		if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
-			up_read(&sqd->rw_lock);
+			mutex_unlock(&sqd->lock);
 			cond_resched();
-			down_read(&sqd->rw_lock);
+			mutex_lock(&sqd->lock);
 			io_run_task_work();
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
@@ -6742,10 +6741,10 @@ static int io_sq_thread(void *data)
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-			up_read(&sqd->rw_lock);
+			mutex_unlock(&sqd->lock);
 			schedule();
 			try_to_freeze();
-			down_read(&sqd->rw_lock);
+			mutex_lock(&sqd->lock);
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
 		}
@@ -6753,20 +6752,13 @@ static int io_sq_thread(void *data)
 		finish_wait(&sqd->wait, &wait);
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
-	up_read(&sqd->rw_lock);
-	down_write(&sqd->rw_lock);
-	/*
-	 * someone may have parked and added a cancellation task_work, run
-	 * it first because we don't want it in io_uring_cancel_sqpoll()
-	 */
-	io_run_task_work();
 
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_uring_cancel_sqpoll(ctx);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
-	up_write(&sqd->rw_lock);
+	mutex_unlock(&sqd->lock);
 
 	io_run_task_work();
 	complete(&sqd->exited);
@@ -7068,21 +7060,21 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 }
 
 static void io_sq_thread_unpark(struct io_sq_data *sqd)
-	__releases(&sqd->rw_lock)
+	__releases(&sqd->lock)
 {
 	WARN_ON_ONCE(sqd->thread == current);
 
 	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	up_write(&sqd->rw_lock);
+	mutex_unlock(&sqd->lock);
 }
 
 static void io_sq_thread_park(struct io_sq_data *sqd)
-	__acquires(&sqd->rw_lock)
+	__acquires(&sqd->lock)
 {
 	WARN_ON_ONCE(sqd->thread == current);
 
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	down_write(&sqd->rw_lock);
+	mutex_lock(&sqd->lock);
 	/* set again for consistency, in case concurrent parks are happening */
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	if (sqd->thread)
@@ -7093,11 +7085,11 @@ static void io_sq_thread_stop(struct io_sq_data *sqd)
 {
 	WARN_ON_ONCE(sqd->thread == current);
 
-	down_write(&sqd->rw_lock);
+	mutex_lock(&sqd->lock);
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	if (sqd->thread)
 		wake_up_process(sqd->thread);
-	up_write(&sqd->rw_lock);
+	mutex_unlock(&sqd->lock);
 	wait_for_completion(&sqd->exited);
 }
 
@@ -7179,7 +7171,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 
 	refcount_set(&sqd->refs, 1);
 	INIT_LIST_HEAD(&sqd->ctx_list);
-	init_rwsem(&sqd->rw_lock);
+	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->exited);
 	return sqd;
-- 
2.24.0


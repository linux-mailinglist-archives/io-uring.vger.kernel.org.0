Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99211266A0C
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 23:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgIKV2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 17:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgIKV2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 17:28:31 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708DAC061757
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n3so3119930pjq.1
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g0bySsshS3fhb3bvhvDGdd3ifzLD2e6p5ufz4J2OmO4=;
        b=Mm26mJW6eK3iByx3H/fobe+3D5HloccOQIce4Uu2DgpppeCxfeucovh3G+uKsn4woM
         7GXzq2qANR7AaePvUfs9MLrhSzAlfeCk/PhlkOw+qhlYJFuBuRGF+T3jvG9YvQsvavwP
         o5nNK4u4Q7ipnezSW1dL7wBmuJAoY0cQIfHOlvePB7sdg61+9eCxMrJgYWA+SdDtUk7/
         /D8MMNWhsymrORz4q7gli6I2qfCLHgjwrxrz+cDAi0shz7wI5q4yZ6FlJxIoTxLcTadX
         V6qypxXf6Ay2vmuyBE03Knan/agbjlLFwKPspN3fgbRmSyPASK1KTg1mvSDXzPu//wHm
         iFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0bySsshS3fhb3bvhvDGdd3ifzLD2e6p5ufz4J2OmO4=;
        b=HIB9qVPFuelsyA+ze3csogfPTkafJawdSQBvkafnhOhBCVXehavE34jwkFFjJjai1Q
         1Ar8S8DuzqqbO69QZWg6sHmOGNKQlsvQMZ0KIryM8aZ9dez3Pd+DIakibAPx2fO9MxLX
         Yf7et/KeM4AZRcztx96ECn0vAsua8N5MTAhAQBC58HZ1d+7+biLx4mIobdj6okHbYvpM
         cq5dcbeieTDC+CHsH5iczyouNkxha5NrTAgeDfWGQgBrck1ATEfuhZylaHU9d2Z1bFxs
         YHNrC5FJasCJCZXPxX3KkpgE2AIYKycQaioqEfmiD7H5qVhH6abq4gc6XyZy7Jgbmbhx
         fU/A==
X-Gm-Message-State: AOAM5329TUAXDvSSr7kiGAo2QuXvS0/wC6Jga2Zl8NGi0vZ+rcSOQRs4
        GCFFHowF8OsQZaPU8BGuyuiuF/uf8OdaGltQ
X-Google-Smtp-Source: ABdhPJyHU4e0lu4Tqbl88ju/OL82w3wlRAoAZwRzSPi/3uvoLyk2gjxWF5NCRe3wDQbj/Cz9VKR0Qw==
X-Received: by 2002:a17:90b:2341:: with SMTP id ms1mr3697217pjb.80.1599859710731;
        Fri, 11 Sep 2020 14:28:30 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u14sm3241876pfc.203.2020.09.11.14.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:28:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jannh@google.com, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: stash ctx task reference instead of task files
Date:   Fri, 11 Sep 2020 15:26:24 -0600
Message-Id: <20200911212625.630477-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911212625.630477-1-axboe@kernel.dk>
References: <20200911212625.630477-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can grab a reference to the task instead of stashing away the task
files_struct. This is doable without creating a circular reference
between the ring fd and the task itself.

This is in preparation for handling the ->files assignment a bit
differently, so we don't need to force SQPOLL to enter the kernel for
an update.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ee5e18218c2..4958a9dca51a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -290,11 +290,10 @@ struct io_ring_ctx {
 	struct io_wq		*io_wq;
 	struct mm_struct	*sqo_mm;
 	/*
-	 * For SQPOLL usage - no reference is held to this file table, we
-	 * rely on fops->flush() and our callback there waiting for the users
-	 * to finish.
+	 * For SQPOLL usage - we hold a reference to the parent task, so we
+	 * have access to the ->files
 	 */
-	struct files_struct	*sqo_files;
+	struct task_struct	*sqo_task;
 
 	struct wait_queue_entry	sqo_wait_entry;
 	struct list_head	sqd_list;
@@ -6824,10 +6823,12 @@ static int io_sq_thread(void *data)
 				old_cred = override_creds(ctx->creds);
 			}
 
-			if (current->files != ctx->sqo_files) {
+			if (current->files != ctx->sqo_task->files) {
+				task_lock(ctx->sqo_task);
 				task_lock(current);
-				current->files = ctx->sqo_files;
+				current->files = ctx->sqo_task->files;
 				task_unlock(current);
+				task_unlock(ctx->sqo_task);
 			}
 
 			ret |= __io_sq_thread(ctx, start_jiffies, cap_entries);
@@ -7155,6 +7156,11 @@ static void io_finish_async(struct io_ring_ctx *ctx)
 		io_wq_destroy(ctx->io_wq);
 		ctx->io_wq = NULL;
 	}
+
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+	}
 }
 
 #if defined(CONFIG_UNIX)
@@ -7804,11 +7810,11 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		io_sq_thread_unpark(sqd);
 
 		/*
-		 * We will exit the sqthread before current exits, so we can
-		 * avoid taking a reference here and introducing weird
-		 * circular dependencies on the files table.
+		 * Grab task reference for SQPOLL usage. This doesn't
+		 * introduce a circular reference, as the task reference is
+		 * just to ensure that the struct itself stays valid.
 		 */
-		ctx->sqo_files = current->files;
+		ctx->sqo_task = get_task_struct(current);
 
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
@@ -7850,7 +7856,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 	return 0;
 err:
-	ctx->sqo_files = NULL;
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+	}
 	io_finish_async(ctx);
 	return ret;
 }
@@ -8564,7 +8573,6 @@ static int io_uring_flush(struct file *file, void *data)
 		mutex_lock(&ctx->uring_lock);
 		ctx->ring_fd = -1;
 		ctx->ring_file = NULL;
-		ctx->sqo_files = NULL;
 		mutex_unlock(&ctx->uring_lock);
 		io_ring_set_wakeup_flag(ctx);
 		io_sq_thread_unpark(sqd);
@@ -8711,7 +8719,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_lock(&ctx->uring_lock);
 			ctx->ring_fd = fd;
 			ctx->ring_file = f.file;
-			ctx->sqo_files = current->files;
 			mutex_unlock(&ctx->uring_lock);
 
 			io_sq_thread_unpark(sqd);
-- 
2.28.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE292F9061
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 05:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbhAQEGH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 23:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbhAQEFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 23:05:36 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6CAC061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 20:04:55 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 15so8795693pgx.7
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 20:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nP/8iEafp7UqgEGMg88xt3iw0NG8THPprjsyAcQ5w8A=;
        b=2KalV/w6ph4p+APkztFI5URYts8PTLLO82DHNgh4TIYdfUCm20+8wB1tJcrHMcMP8D
         m+Bsx9y1pI71KrvwRkhZOg5lmdbN8aYtujzYcanydzA6xTbNIrZfJdKXoV54EybRJnl3
         3ki9yQQ2wt5+Z+jeZV7pUbSiFl9rhWKgIZOJjK6WNjUiKMDsst2aNWGaAVOL/ARlYUxj
         sVpU5jk/Cq2le82T9EXOgjCkEqh+4XBl+oVnAxRb6rb933y0GB35geAP8iG/wgZnXeWI
         jKpl3K478sw/AKbkwniiQttVyT0uCMqamuBSD1tX5kybK4c3N2Qy8aOC6SQxv180k3eP
         sKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nP/8iEafp7UqgEGMg88xt3iw0NG8THPprjsyAcQ5w8A=;
        b=JtGlkd5v8QCi1vFSARinGCcK6PHChGgOszhzlbSu8gVY4rSp/qFWuYyrO5WrqI2m2C
         049mGQwAQz7bGl+v7Mthw/3OL5eR+NwFj10ZiMcqCx7CoSvDI+3afApH8hdJE+aUI9e0
         tn8GCXl4YfxnE8OBjh+sexaubbvaZHyh10lT+jMEJ8S1PVqM+SF5pLhr3rx4ta7lcIXY
         wKUM/dSzJee+tMq9894eJuKvgjSiRYrpI1mQA0r4JEPpDXUB9Md4vokyZmlgAbfZe7yv
         kYG8R9YcqpwoWVWgEemwR+1G25vqM9IVEdGLmS+E55phn2YX08ZDsQVrhux1USogZDKo
         rhLQ==
X-Gm-Message-State: AOAM530z+J6n4StzQSOrJC3s+/uIQfdUJ1qlQQ6CPpgUz14F7g44lMOZ
        9Y8ADsQcrtPvVg8ak8xefOSs00MpUnEsng==
X-Google-Smtp-Source: ABdhPJyWMUh/O8xJ1Uxro/6njKtcgH/m8jwn50Qe4n4kEEqVjAqTg3TSPxrCactwKkkDfFaALKWUJw==
X-Received: by 2002:a63:e10b:: with SMTP id z11mr20159240pgh.40.1610856294164;
        Sat, 16 Jan 2021 20:04:54 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 22sm12024134pfn.190.2021.01.16.20.04.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 20:04:53 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cancel all requests on task exit
Message-ID: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk>
Date:   Sat, 16 Jan 2021 21:04:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We used to have task exit tied to canceling files_struct ownership, but we
really should just simplify this and cancel any request that the task has
pending when it exits. Instead of handling files ownership specially, we
do the same regardless of request type.

This can be further simplified in the next major kernel release, unifying
how we cancel across exec and exit.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 383ff6ed3734..1190296fc95f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9029,7 +9029,7 @@ static void io_uring_remove_task_files(struct io_uring_task *tctx)
 		io_uring_del_task_file(file);
 }
 
-void __io_uring_files_cancel(struct files_struct *files)
+static void __io_uring_files_cancel(void)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct file *file;
@@ -9038,11 +9038,10 @@ void __io_uring_files_cancel(struct files_struct *files)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_cancel_task_requests(file->private_data, files);
+		io_uring_cancel_task_requests(file->private_data, NULL);
 	atomic_dec(&tctx->in_idle);
 
-	if (files)
-		io_uring_remove_task_files(tctx);
+	io_uring_remove_task_files(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -9087,14 +9086,14 @@ void __io_uring_task_cancel(void)
 
 	/* trigger io_disable_sqo_submit() */
 	if (tctx->sqpoll)
-		__io_uring_files_cancel(NULL);
+		__io_uring_files_cancel();
 
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
-		__io_uring_files_cancel(NULL);
+		__io_uring_files_cancel();
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b2d845704d..378662dcfa02 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -37,7 +37,6 @@ struct io_uring_task {
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
-void __io_uring_files_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
 
 static inline void io_uring_task_cancel(void)
@@ -45,11 +44,6 @@ static inline void io_uring_task_cancel(void)
 	if (current->io_uring && !xa_empty(&current->io_uring->xa))
 		__io_uring_task_cancel();
 }
-static inline void io_uring_files_cancel(struct files_struct *files)
-{
-	if (current->io_uring && !xa_empty(&current->io_uring->xa))
-		__io_uring_files_cancel(files);
-}
 static inline void io_uring_free(struct task_struct *tsk)
 {
 	if (tsk->io_uring)
diff --git a/kernel/exit.c b/kernel/exit.c
index 04029e35e69a..81523e8d8893 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -777,7 +777,7 @@ void __noreturn do_exit(long code)
 		schedule();
 	}
 
-	io_uring_files_cancel(tsk->files);
+	io_uring_task_cancel();
 	exit_signals(tsk);  /* sets PF_EXITING */
 
 	/* sync mm's RSS info before statistics gathering */
-- 
Jens Axboe


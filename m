Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2834367C
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCVCDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhCVCCq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:46 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18320C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v4so14990091wrp.13
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=W+FovL9QDMp6ZVJ2PzQ2V9JdWpIhF7ZzjEu+RncVRqs=;
        b=aF6Ks6NDHmWN9YyZmuwlwUkV7oR8zbRso5MJLaGze2jls0QYHkVWFRKuOZo3ztXJar
         L+POpk7UeYycCiBn9ZffJI0NWUI0Ust4yStAUe8Tihc2iAM/ymb+sEw450PX4BUO7sAt
         SM2rbpHihH1LMx4rULEdt3bqwp9W5q+4SRf8RAtcw/0FJrUxk5ebvdUQ8fyisfMjBkdV
         AWqO8Sxz/od9g/b65bueSGX2gGuOLbIAxSIh9na8c0AGuQM28T8onVydIYoVyTegSESa
         7M0qr38EQlpwe/Dy3H7N8D6X5MQLV2h7xYrCvqYBKMeNjkY8+VOp3beXgL2slzjmKPZr
         tBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W+FovL9QDMp6ZVJ2PzQ2V9JdWpIhF7ZzjEu+RncVRqs=;
        b=SlWjxC9xqwkiEBPgVMr/H7a0Qj9xt6dG4yWhxVeOeydw8cnbExGM+uQPTJattjm+1Y
         bf0tS4kTis/2F7nL/6C3pLVWzTSfo/6qqHNmzGcsZFX0eE8WDQYI7o+ysBgAgtAa0KdS
         ynq8LJyyb1fW6OaENYzZYbyOrU7nmwt/sxl4aIzF772BtsimT0ARtENr7CxhbuXXqPER
         yAfvVeSdl82w2twQVoxkKm3BSfqArIuPmR6XFNKexaMwWKGUCtpe0a4dr/e08G1Gm9Ss
         lfoQzX7Qms0ZIwe0O9uyXadJNrPywJUgJf9KfFd3NOx+BX/FdHHPKwktRwfDvEeyk8i7
         prnQ==
X-Gm-Message-State: AOAM532R/+8vM0fMXTxAPVO5r8yI2Ob5jLSBEtFYzVugvTcIMhZ5rmo2
        EzV7Z8kqciuhdYxvYMXT4PQ=
X-Google-Smtp-Source: ABdhPJxgxWQA7JBkd6BPzslYuCfkUsgZXuITexHy/ZR07ofN6Ng9Rb19HDoG184PAVKnWox5VhnHbA==
X-Received: by 2002:adf:f186:: with SMTP id h6mr15986630wro.290.1616378564895;
        Sun, 21 Mar 2021 19:02:44 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/11] io_uring: optimise out task_work checks on enter
Date:   Mon, 22 Mar 2021 01:58:26 +0000
Message-Id: <ff3273b5111fdb10eea0e3d4f81f620fb58c5a5b.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_run_task_work() does some extra work for safety, that isn't actually
needed in many cases, particularly when it's known that current is not
exiting and in the TASK_RUNNING state, like in the beginning of a
syscall.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 080fac4d4543..45b49273df8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2227,6 +2227,16 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, kbuf);
 }
 
+/* only safe when TASK_RUNNING and it's not PF_EXITING */
+static inline bool __io_run_task_work(void)
+{
+	if (current->task_works) {
+		task_work_run();
+		return true;
+	}
+	return false;
+}
+
 static inline bool io_run_task_work(void)
 {
 	/*
@@ -6729,7 +6739,7 @@ static int io_sq_thread(void *data)
 		}
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			io_run_task_work();
+			__io_run_task_work();
 			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -6870,7 +6880,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
-		if (!io_run_task_work())
+		if (!__io_run_task_work())
 			break;
 	} while (1);
 
@@ -9117,7 +9127,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	struct fd f;
 	long ret;
 
-	io_run_task_work();
+	__io_run_task_work();
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
-- 
2.24.0


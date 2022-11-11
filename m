Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F70625FD7
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiKKQxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiKKQxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:53:10 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7236A77D
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:09 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f27so13895327eje.1
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t07JBdzVp59xt0k/Ro//XVYL7vad/co4b1YqAZhNq68=;
        b=l5T7t+8fKrcrh4Yw1JLJlZJNf6LXjApM8+w/awaHzMKGZrSiqScBizGSMs8b27iWlw
         ShGe+74jkdUFB0vd3qY4PNi9mJNACk8zQQLZmwpaggQJZ4cpIT79utKOmSDI/r2/4ERI
         B+00Cj/3MA9ht+LTZOufAyZuaruNwX+UUcY7jsjpHDJsZ/JqPJGviCbnlzPB4dIE/mWE
         yF3dp9yDovsscBCAmt6IhFD2J5ETsSJNEdqJGqmMTkmHF4vkR4zlxjI44B99hdLRrh5N
         Ng6Dt43026un55DToxPscBaDJuf4uDT/PQbHsqjC14//JS7OtDU70/ljocMSZFopvNR+
         LvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t07JBdzVp59xt0k/Ro//XVYL7vad/co4b1YqAZhNq68=;
        b=zAUTQLTU2abEdYv42g0xMWPgabKHrrR1bWY6rTPZpwB9O8s/b+aOS/DFgg4tu3gOoe
         v7fLxID6jOQdo6Jh4xr/7X8rXJSdEo0CydAk69VS1faqlVPpNeORw7rSDoeUH0vKdCWK
         wq6hB0zIrg7avqRsUlE4fgmHjQMZRGoD9m2Hh4puhh3vrsxPHk9llMoQPtob7KIrBIcA
         rxLzGjxkq662Jf94vDyFUoa13PDBaPyL7wu5tB5RXcVgPwcAa1V2eHgZc/bAoSTAU00Y
         4dBbRERD+s+NNV0JK1wz6kDkmOfCuIAL5mk23ezA3shM5XQEMXIyor8qRVD8ZSnrVnDF
         RLCA==
X-Gm-Message-State: ANoB5pk226lpwqPUNKIAEZ4aCBAsUYUKRKYgS+0iN9knEZtFlseoQR/G
        qw0cHbTiUFQT6T/dg2rSuvgIbA9v/OU=
X-Google-Smtp-Source: AA0mqf4qFZsgVaskBjt0Dr3hasqEU0MUH4gl/zxUVdlb356ZTmGdFz8bX4LQFschBOoydMtTG91Yag==
X-Received: by 2002:a17:906:2ac3:b0:7ad:b152:90f2 with SMTP id m3-20020a1709062ac300b007adb15290f2mr2613355eje.345.1668185587861;
        Fri, 11 Nov 2022 08:53:07 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id ft31-20020a170907801f00b0078d9cd0d2d6sm1103837ejc.11.2022.11.11.08.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:53:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 1/2] io_uring/poll: fix double poll req->flags races
Date:   Fri, 11 Nov 2022 16:51:29 +0000
Message-Id: <b7fab2d502f6121a7d7b199fe4d914a43ca9cdfd.1668184658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668184658.git.asml.silence@gmail.com>
References: <cover.1668184658.git.asml.silence@gmail.com>
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

io_poll_double_prepare()            | io_poll_wake()
                                    | poll->head = NULL
smp_load(&poll->head); /* NULL */   |
flags = req->flags;                 |
                                    | req->flags &= ~SINGLE_POLL;
req->flags = flags | DOUBLE_POLL    |

The idea behind io_poll_double_prepare() is to serialise with the
first poll entry by taking the wq lock. However, it's not safe to assume
that io_poll_wake() is not running when we can't grab the lock and so we
may race modifying req->flags.

Skip double poll setup if that happens. It's ok because the first poll
entry will only be removed when it's definitely completing, e.g.
pollfree or oneshot with a valid mask.

Fixes: 49f1c68e048f1 ("io_uring: optimise submission side poll_refs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..97c214aa688c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -394,7 +394,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	return 1;
 }
 
-static void io_poll_double_prepare(struct io_kiocb *req)
+/* fails only when polling is already completing by the first entry */
+static bool io_poll_double_prepare(struct io_kiocb *req)
 {
 	struct wait_queue_head *head;
 	struct io_poll *poll = io_poll_get_single(req);
@@ -403,20 +404,20 @@ static void io_poll_double_prepare(struct io_kiocb *req)
 	rcu_read_lock();
 	head = smp_load_acquire(&poll->head);
 	/*
-	 * poll arm may not hold ownership and so race with
-	 * io_poll_wake() by modifying req->flags. There is only one
-	 * poll entry queued, serialise with it by taking its head lock.
+	 * poll arm might not hold ownership and so race for req->flags with
+	 * io_poll_wake(). There is only one poll entry queued, serialise with
+	 * it by taking its head lock. As we're still arming the tw hanlder
+	 * is not going to be run, so there are no races with it.
 	 */
-	if (head)
+	if (head) {
 		spin_lock_irq(&head->lock);
-
-	req->flags |= REQ_F_DOUBLE_POLL;
-	if (req->opcode == IORING_OP_POLL_ADD)
-		req->flags |= REQ_F_ASYNC_DATA;
-
-	if (head)
+		req->flags |= REQ_F_DOUBLE_POLL;
+		if (req->opcode == IORING_OP_POLL_ADD)
+			req->flags |= REQ_F_ASYNC_DATA;
 		spin_unlock_irq(&head->lock);
+	}
 	rcu_read_unlock();
+	return !!head;
 }
 
 static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
@@ -454,7 +455,11 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
-		io_poll_double_prepare(req);
+		if (!io_poll_double_prepare(req)) {
+			/* the request is completing, just back off */
+			kfree(poll);
+			return;
+		}
 		*poll_ptr = poll;
 	} else {
 		/* fine to modify, there is no poll queued to race with us */
-- 
2.38.1


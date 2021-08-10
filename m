Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B83E7DD7
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhHJQzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhHJQzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:55:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F89C0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:54:31 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h14so27186649wrx.10
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYANbbmqnOZ58/hk5KLfX/AVuT/OaN6W3Tp7UuMGsVk=;
        b=FGNXY1Fb17nYwm6LfBaQS8bpPnY3elx7pxmAN5reHG9xLDJ8QR4N4S5IX8JGAOV/8N
         JTCpyRaVYf1R3bexiOS9CTuel81bnCRS9C2c8THBI7s87e3S3eDOiFsXZ0/FqhhjrCeM
         WC0IBV/KXIjW5Z0ez/dqWp0+6eHQZkm9RLrzp7BBc47VlIdiNpwZuSatzA1sYeCnzI1p
         rGBd1N1pq8FhTROZ5KilQ1v2dNzLhRwYp1TOrfCJ56nnPqOHqtMtnPX+hSlOPXENAwJi
         Xzt7l0VBM5B6X5eJEwSzAldIcWTZ+6UOYhNthubVONyI4Q2PR5lUXR/VZb8sIGD8+SyE
         R6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYANbbmqnOZ58/hk5KLfX/AVuT/OaN6W3Tp7UuMGsVk=;
        b=ppZdyk7UuX+uUga2jTgO7rmmKwMHMueY69fsWq904j7W5Bbk35vKcTzpk+zRn/MdPD
         HozdF55Wr/8pgfjzXydtNkAtvHXTrGgo7cEwBU5ePISxi91t0c8nKHO6uEN7Va0dU8Z9
         2oMANGm8aj2ooM2sasBTv7AS9cTHuz23HO5J4REraEoP1Dj4RGwuwReAPW6Mp/SX/h+E
         1gK9f3Qaj0cm21ggU/kx3KHNtTMa7XXWmhS9bCyz2w9XzWMJyplxAUMC8Qa8hcoGk9SA
         qVLcHZR5Nx19NN4TPBq+9zqnnQRVmjBaeRv1k0WffxGq94uExFL8YUkt1yDzRYJoC/X0
         nxpQ==
X-Gm-Message-State: AOAM530rEQ5Btt4WUHo7RMFfc9kv/4ADfJfTZ7svU0uDyeRYW3Vihp4K
        cujd5hJJR/pbLXXaF+nN7hs=
X-Google-Smtp-Source: ABdhPJy9onBfeCxv8cCJ9H7kJ8nJQlyR0ZAtORlsf/lY0nrSJnbY/i2GeBXRjmmZ641v/AKSNNKtGg==
X-Received: by 2002:adf:c549:: with SMTP id s9mr32201777wrf.344.1628614469907;
        Tue, 10 Aug 2021 09:54:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d9sm13332259wrw.26.2021.08.10.09.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:54:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: clean up tctx_task_work()
Date:   Tue, 10 Aug 2021 17:53:55 +0100
Message-Id: <d0d57262d757b564753c3e0b564a3a79e42095d5.1628614278.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After recent fixes, tctx_task_work() always does proper spinlocking
before looking into ->task_list, so now we don't need atomics for
->task_state, replace it with non-atomic task_running using the critical
section.

Tide it up, combine two separate block with spinlocking, and always try
to splice in there, so we do less locking when new requests are arriving
during the function execution.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 345ec0d44b66..57f7b6311395 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -470,8 +470,8 @@ struct io_uring_task {
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
-	unsigned long		task_state;
 	struct callback_head	task_work;
+	bool			task_running;
 };
 
 /*
@@ -1954,9 +1954,13 @@ static void tctx_task_work(struct callback_head *cb)
 		spin_lock_irq(&tctx->task_lock);
 		node = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
+		if (!node)
+			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
+		if (!node)
+			break;
 
-		while (node) {
+		do {
 			struct io_wq_work_node *next = node->next;
 			struct io_kiocb *req = container_of(node, struct io_kiocb,
 							    io_task_work.node);
@@ -1968,19 +1972,8 @@ static void tctx_task_work(struct callback_head *cb)
 			}
 			req->io_task_work.func(req);
 			node = next;
-		}
-		if (wq_list_empty(&tctx->task_list)) {
-			spin_lock_irq(&tctx->task_lock);
-			clear_bit(0, &tctx->task_state);
-			if (wq_list_empty(&tctx->task_list)) {
-				spin_unlock_irq(&tctx->task_lock);
-				break;
-			}
-			spin_unlock_irq(&tctx->task_lock);
-			/* another tctx_task_work() is enqueued, yield */
-			if (test_and_set_bit(0, &tctx->task_state))
-				break;
-		}
+		} while (node);
+
 		cond_resched();
 	}
 
@@ -1994,16 +1987,19 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node;
 	unsigned long flags;
+	bool running;
 
 	WARN_ON_ONCE(!tctx);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	running = tctx->task_running;
+	if (!running)
+		tctx->task_running = true;
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	/* task_work already pending, we're done */
-	if (test_bit(0, &tctx->task_state) ||
-	    test_and_set_bit(0, &tctx->task_state))
+	if (running)
 		return;
 
 	/*
@@ -2018,7 +2014,6 @@ static void io_req_task_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	clear_bit(0, &tctx->task_state);
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	node = tctx->task_list.first;
 	INIT_WQ_LIST(&tctx->task_list);
-- 
2.32.0


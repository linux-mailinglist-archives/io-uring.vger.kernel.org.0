Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6723932C9A6
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhCDBKA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390740AbhCDAci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:32:38 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3686EC061356
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:19 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o38so17616352pgm.9
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhQNKWfJNSlYiUMLwFyU/ZzCXdruxrXjJsLzUl+N+WI=;
        b=bndf7KRDiHUNm4QG4VBs1SZbzZPM6alL1o8pT66YxqFzQ/j/y6ByFoRNFH3j/ygZei
         aVs2MjbMNk+iuAINo/lZQbhbYF+LjpiiE7PmhR2GDeg2Cm9RvGAsKX/kLpTVuTS7TDgO
         FReXbwautjCqw0DvuZER2X0mfmagg5Fz2miey3trD9d8odeWJi1DpYU54lnGewxKv3cu
         RLg2ALnUDPy6KRYql8bMlli9MlDcE8b7F3ZuscK41nYtX2yMvMhKCyVEX6JeA3jN6ZFT
         BZE4/dcZI3mYfO8nWDKglMw94iPxjdlqF98CfAR171uMtQCfFyEwzokZJkv8STWjidr7
         k03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhQNKWfJNSlYiUMLwFyU/ZzCXdruxrXjJsLzUl+N+WI=;
        b=C6XZe9g87ASbltfVP0QolFjyrenVaFIyX3Fo8CmiBeCr9eLz+CNNGXsWs23ZggWxzw
         sI1j5OY9K6yHwqVCLklIhXNNFbi7fBqZ9h5Ag+JAcakB5lumTNgGrlwmtlVRZJCTkx7m
         gpwBn1ZcU8L0wj5KsnZ2aU1uyYnQQv/qhrIzBfvdYmf2zkmfZ4mlr44E2wXtWPm23wQg
         7EpHzcAXwGmW6k/uWdDCEhheZ6aKDqbHSwDJuoNyhdPdTcGHULXVvxgwKYIy/JQwRydA
         ajrnYdeYZtxIoMTKAX4++ynYq2FZqj61ggXMbpNPp2ASoUgCLTt77bKr2HyqYwRib3tP
         0ymA==
X-Gm-Message-State: AOAM533iVtqOUBe9nqeaQ447/G57WItYUs1Mk4Y4wVZ7MCDHNoWwf1Gt
        Is5tMxRTanYv1JoUKerGWzo3z5nGLIW267po
X-Google-Smtp-Source: ABdhPJxRCPqVPuW+iWZnN2tDmCqptjgphe+Bx7FSO27CmzZgDp7Jmihg6WNS9D3YPXRu+81FzhaXmw==
X-Received: by 2002:a63:5a50:: with SMTP id k16mr1312025pgm.155.1614817638529;
        Wed, 03 Mar 2021 16:27:18 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/33] io_uring: fix race condition in task_work add and clear
Date:   Wed,  3 Mar 2021 17:26:38 -0700
Message-Id: <20210304002700.374417-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We clear the bit marking the ctx task_work as active after having run
the queued work, but we really should be clearing it before. Otherwise
we can hit a tiny race ala:

CPU0					CPU1
io_task_work_add()			tctx_task_work()
					run_work
	add_to_list
	test_and_set_bit
					clear_bit
		already set

and CPU0 will return thinking the task_work is queued, while in reality
it's already being run. If we hit the condition after __tctx_task_work()
found no more work, but before we've cleared the bit, then we'll end up
thinking it's queued and will be run. In reality it is queued, but we
didn't queue the ctx task_work to ensure that it gets run.

Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb65e54c1b09..83973f6b3c0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1893,10 +1893,10 @@ static void tctx_task_work(struct callback_head *cb)
 {
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task, task_work);
 
+	clear_bit(0, &tctx->task_state);
+
 	while (__tctx_task_work(tctx))
 		cond_resched();
-
-	clear_bit(0, &tctx->task_state);
 }
 
 static int io_task_work_add(struct task_struct *tsk, struct io_kiocb *req,
-- 
2.30.1


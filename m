Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9B3ABA65
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhFQRQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhFQRQy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:54 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EABC061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id y13-20020a1c4b0d0000b02901c20173e165so4156938wma.0
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pGnT0d28jRinbS3BQjvyRdZZrH1G0vk0YePIkunkwus=;
        b=MUV9fAxZNM6xP+xDyVxpl07uvzhm+nvzRydxD1Sb1tMTBMf0q12Nie/igrIbE31GyL
         c1USrKtD9+jShG8ENTEwJ58FjJWp7i41HFdBsEL3fqtAorxYPgl3EocrXil51TIUH23X
         1h3NwXY2XgShMcq4ziaoW3u3EF0YtAuQ6MEL/JHCzrK2s1PngQhhNzKe/uWmIa2PDE+A
         8UswVmk2vMRiz7Td59lweJIufu3E6R02idN+fiNnLwDDSOzBugA2MH8YFeHgUeoSxts0
         nk/MuzwKVXTgT9nCfmKlZLsIkjA1tGXRJvnmv/1EBA1RRzCyu8ZPVP6I2PGtg8IcO9CY
         02Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGnT0d28jRinbS3BQjvyRdZZrH1G0vk0YePIkunkwus=;
        b=IB7g0u55TWIbATkmd2/3dCpehBJ1UNPjs268QHKqCuSN8H7REdJRKVLUVL8fhe2gtL
         pBiQwW4W6Bge4KIHFj423E1KxAEEFFyXpRW+LzUc3hdRsVPQCUk73MdiiMJAKonloRA7
         xHmLDrUvzeU2Xc+uaRIRUk/8toYSgZbPgjqCM+mRfydeVOIVHFrNFOx2JKAjtF6dLtLh
         vNb/lo6KF/Qf+FPmyMpmpY9opUkz1ZSRVSpPIbiRLoOGXlNuVtRfkrx0EJFJMhrICkbG
         IKCGF1MqyYWg+lUbJlnIaAF8gJx/DSASVC3/wRAJgCJUFW+k4cjTmoG7xEMSxAyq64Zb
         sgAA==
X-Gm-Message-State: AOAM532I8S7NelTCCnSREOu0F653IywhLulZcjW8AKIQZsrJcpwBaBiA
        PiKnb5gxrpWLoCfoblS18uk=
X-Google-Smtp-Source: ABdhPJyAclJcZTIiW1CmLFZwUiQQcXVbhPNRgh33GBnZB0Ra2/l/OaLKgYV6dzJm7kd/EAn0pJkQRg==
X-Received: by 2002:a7b:c099:: with SMTP id r25mr6380792wmh.144.1623950084767;
        Thu, 17 Jun 2021 10:14:44 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/12] io_uring: improve in tctx_task_work() resubmission
Date:   Thu, 17 Jun 2021 18:14:10 +0100
Message-Id: <1ef72cdac7022adf0cd7ce4bfe3bb5c82a62eb93.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If task_state is cleared, io_req_task_work_add() will go the slow path
adding a task_work, setting the task_state, waking up the task and so
on. Not to mention it's expensive. tctx_task_work() first clears the
state and then executes all the work items queued, so if any of them
resubmits or adds new task_work items, it would unnecessarily go through
the slow path of io_req_task_work_add().

Let's clear the ->task_state at the end. We still have to check
->task_list for emptiness afterward to synchronise with
io_req_task_work_add(), do that, and set the state back if we're going
to retry, because clearing not-ours task_state on the next iteration
would be buggy.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2fdca298e173..4353f64c10c4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1894,8 +1894,6 @@ static void tctx_task_work(struct callback_head *cb)
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 
-	clear_bit(0, &tctx->task_state);
-
 	while (1) {
 		struct io_wq_work_node *node;
 
@@ -1917,8 +1915,14 @@ static void tctx_task_work(struct callback_head *cb)
 			req->task_work.func(&req->task_work);
 			node = next;
 		}
-		if (wq_list_empty(&tctx->task_list))
-			break;
+		if (wq_list_empty(&tctx->task_list)) {
+			clear_bit(0, &tctx->task_state);
+			if (wq_list_empty(&tctx->task_list))
+				break;
+			/* another tctx_task_work() is enqueued, yield */
+			if (test_and_set_bit(0, &tctx->task_state))
+				break;
+		}
 		cond_resched();
 	}
 
-- 
2.31.1


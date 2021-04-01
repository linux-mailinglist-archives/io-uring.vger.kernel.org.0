Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B09351BDF
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhDASLl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbhDASFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:05:36 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7920C0045FC
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j9so2085319wrx.12
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iFI5WQgZtkteN94Dz5c/qc6G2gPWnPMM0CdMa0VKs8o=;
        b=Y9BwY2n1sogARqLkip/6eA8VibpWRR7oP7/CzsH7xV8J29T58SsxipS2JHGOH1qB03
         nBAltNA3eUlsejp5tUJOKUrSeqzzvoOIaiktLIVdpJz5czc02iTgNACSzR7Sgn3QWN38
         rpJXBOWeCqgTXxMtCm2t5RR6rP9sz/JN+zTZ9OhDJGK8SOb0HHkGu5VNtU2S5nYnADuf
         KJU4ixBIjI04MwBqnS1y2xn7H125EawkIp+FboRFVvu9ALoELkzJg92SIokAP5UP9msJ
         0Y0hXdVIxV5T8oFq7v1fl8b1MRTNCbWcn6Di0/sReuZ+bNyRwY0niqpFSXsE/R6oSCaB
         Edig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFI5WQgZtkteN94Dz5c/qc6G2gPWnPMM0CdMa0VKs8o=;
        b=sO8NT3IYwAsdvFUD1mDhi19Xe806Y0b4TLEoB66Gd7vuDGnb6AtocEeCDOn/Co5Vxi
         5mJZW26teNFJvWtF37ZMu11y9+bxOzxXqK9lUxA3ef/ymA+65xIStbM8Qyo5TX014k5l
         aWCFd6uTZ9ZN8EZilPbosQQ3F9X1RnABSAJX7uooIQnx7sX5MwglNd4ZCTEMnvxQBi6c
         ybMyQQkg1SObeWqLEgnfFJgF8H/IEFYpXWYgyDPwJGIyli9jvZJkWs8IwZLSzeibbeAl
         roTcV0+LmMRv2AFCY+zx6ZkDexySjdVNcj5XXXpEhK9bsH3x/pFQf8+YaLk2RmPCL95A
         8N7w==
X-Gm-Message-State: AOAM532Me2GTSumc2DI8a1JAnkyvAOBOrPfpZQ+MEZRgJ45ABO+15K5t
        WSj9am5Ovp6YjbI0fzJxi0fAVGzGXnjHWw==
X-Google-Smtp-Source: ABdhPJxSnCdwEHYqCH5UXyk+Maeb3D6H85D3tIsaVL71PNHpg3tVxoGe/5VYzyPYM6CUGI5LlXVH7Q==
X-Received: by 2002:a5d:6b50:: with SMTP id x16mr9959165wrw.379.1617288508460;
        Thu, 01 Apr 2021 07:48:28 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 11/26] io_uring: combine lock/unlock sections on exit
Date:   Thu,  1 Apr 2021 15:43:50 +0100
Message-Id: <a8ae0589b0ea64ad4791e2c282e4e9b713dd7024.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_ring_exit_work() already does uring_lock lock/unlock, no need to
repeat it for lock waiting trick in io_ring_ctx_free(). Move the waiting
with comments and spinlocking into io_ring_exit_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9bfe137270c..9ebdd288653f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8455,16 +8455,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
-	/*
-	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see __io_req_task_submit(). Wait for them to finish.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	mutex_unlock(&ctx->uring_lock);
-	spin_lock_irq(&ctx->completion_lock);
-	spin_unlock_irq(&ctx->completion_lock);
-
 	io_sq_thread_finish(ctx);
 	io_sqe_buffers_unregister(ctx);
 
@@ -8615,6 +8605,12 @@ static void io_ring_exit_work(struct work_struct *work)
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
+	/*
+	 * Some may use context even when all refs and requests have been put,
+	 * and they are free to do so while still holding uring_lock or
+	 * completion_lock, see __io_req_task_submit(). Apart from other work,
+	 * this lock/unlock section also waits them to finish.
+	 */
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
@@ -8635,6 +8631,8 @@ static void io_ring_exit_work(struct work_struct *work)
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
+	spin_lock_irq(&ctx->completion_lock);
+	spin_unlock_irq(&ctx->completion_lock);
 
 	io_ring_ctx_free(ctx);
 }
-- 
2.24.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5931AD04
	for <lists+io-uring@lfdr.de>; Sat, 13 Feb 2021 17:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBMQPd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Feb 2021 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhBMQOy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Feb 2021 11:14:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66785C0613D6
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:14 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t2so1362998pjq.2
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utwJugLzHYqmeGiJAnki3VhdViD/nqd7hf6erNKlvSY=;
        b=VF1jIIywHzkzGFBhtVfz/PU2pgYOCeN2sW/ZozJN1UZ3kyKFSMm8Lrt4w4abcg5Dq6
         vAsM5evm8QUEFLldSwTw7zNK5/TgjkUpQPwJo4COkHKxWQCR7X1PPtQSXBNrVGmWOgjJ
         37NQ1JCKqnApnekg6RWBDMCFKCW7HkrPjXPuKKDE6UH/l2/nBEe3ONQGcsPUJ/Rnb1oI
         iOf3SAGaI3cmNlGHPcIWoq5or3KfI7he4HwcfaUddsMybC2OI+wQluWyOqmMnt/4nyU6
         A65D+vXSE3f9ssh+taHOwBUdFnZ3rEeG3gbgHxiT37X3H5KWdUb/myQ/uYaf4/y9MfPM
         J7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utwJugLzHYqmeGiJAnki3VhdViD/nqd7hf6erNKlvSY=;
        b=ZHk9ia5s02JZmNdSUKHQpzoIYy4vW+NQUbJqdG9hGMwxe+XVJDPoM1vdG6fZzGA6XW
         mAl66jVB0N72cUa8UllOeGMl8eDZGCLLMCBtZXPIAknOk1zIxgxTnvV7OduOP1Oyy6Df
         WVyDfOEFybpV/UNcsC2IpsORI5LyKFwErizbk0yvHNBUmWg9Fayr/08rRjhrldQ0+ou8
         fNQEnweXJf6EU2nCD6b5Ig/WHcIfThSPeqRGuia0TZe3CUpE2ct8+1Ta4PyiiUifL4+T
         UCJoYk9yoVymJ+OC0aOmxI/TPtRnvMke/9BC1yr5dCAMO5ZoLRetRTuYph8HE65344XM
         QWBA==
X-Gm-Message-State: AOAM533IdGtjC0mlnPQ8Xb0gTKEP1wT9dQ+k6ZTcPT4ziQMSPj+1u/I0
        XsjVaR+6zxDOgmmQCtpnFEQrRq0tsikIcw==
X-Google-Smtp-Source: ABdhPJxS/iC07md5dyrIqXTLYDarwXNIke/SShYKm2JBB5LmLVzyp0uSHvM/8x9LtEJqFqc2g77hSg==
X-Received: by 2002:a17:902:e309:b029:e2:86e9:cc75 with SMTP id q9-20020a170902e309b02900e286e9cc75mr7236145plc.59.1613232853701;
        Sat, 13 Feb 2021 08:14:13 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 124sm11984975pfd.59.2021.02.13.08.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 08:14:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add helper to free all request caches
Date:   Sat, 13 Feb 2021 09:14:05 -0700
Message-Id: <20210213161406.1610835-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210213161406.1610835-1-axboe@kernel.dk>
References: <20210213161406.1610835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have three different ones, put it in a helper for easy calling. This
is in preparation for doing it outside of ring freeing as well. With
that in mind, also ensure that we do the proper locking for safe calling
from a context where the ring it still live.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9cd7b03a6f34..1895fc132252 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8693,10 +8693,27 @@ static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
 	}
 }
 
-static void io_ring_ctx_free(struct io_ring_ctx *ctx)
+static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
 
+	mutex_lock(&ctx->uring_lock);
+
+	if (submit_state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, submit_state->free_reqs,
+				     submit_state->reqs);
+
+	io_req_cache_free(&submit_state->comp.free_list, NULL);
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_req_cache_free(&submit_state->comp.locked_free_list, NULL);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_ring_ctx_free(struct io_ring_ctx *ctx)
+{
 	/*
 	 * Some may use context even when all refs and requests have been put,
 	 * and they are free to do so while still holding uring_lock, see
@@ -8715,10 +8732,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 
-	if (submit_state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, submit_state->free_reqs,
-				     submit_state->reqs);
-
 #ifdef CONFIG_BLK_CGROUP
 	if (ctx->sqo_blkcg_css)
 		css_put(ctx->sqo_blkcg_css);
@@ -8742,9 +8755,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
+	io_req_caches_free(ctx, NULL);
 	kfree(ctx->cancel_hash);
-	io_req_cache_free(&ctx->submit_state.comp.free_list, NULL);
-	io_req_cache_free(&ctx->submit_state.comp.locked_free_list, NULL);
 	kfree(ctx);
 }
 
-- 
2.30.0


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F80856AEFA
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiGGXYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiGGXYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:24:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98CC4F198
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:24:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id o18so19745968pgu.9
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8TenpyQ7kAr/OpTPiY+oFdS6T5ffBnYy9vk7ymSI9mw=;
        b=fBARGdOJRaKeY6Uj8JAMYFMJ2wZzY4iSXEbbg/omO0Rezz0GXU68lm/Y7ZeKWE5ZFM
         mo6Rs+KPkrx6xqcXq6q/sCkgYby2sX3YmJELt0j5Ncg3jORkEwBiyXqDIQhhVdlbsuXd
         agmwRjNB521zqc2Tbz+xfh/YHlCEac8q8H7aawv8S+em8Hh9qRbyuzxE6cfm5WgeMLah
         ZZ0WU8uV+/KlAZjTHozGdbvkSo/ZNwj7FSrIWITO9YzZit989TTst/Bf+T8AoThJzv+x
         8U/TR0z7XmskPU80/6gXxsqEC/VjTgYlF9WMfJB1e7q7DBC9z/JCTwprFIzcfEtR3znr
         JO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8TenpyQ7kAr/OpTPiY+oFdS6T5ffBnYy9vk7ymSI9mw=;
        b=4cTlzf+acQdrnf8ANWVFlx0ZJ11RX81C+1HeCEAyWicj2RCNIx0CeX3mu8oAdOwitD
         rQLIeQyX2OY8TTEkVk5/3V/tL478yCoR3JBCYvqKwZdS4CZC6SPP3TWKu2sjAr6uvfYH
         HNtJAm1GX1z09bD19cll3o6UGo6Meatgn4cHM2XvKFTYdrNCxjF3lTXt2Jam4f4AzHFi
         W/sXiwmoD+xpUldjVvHO9kL9smabZtMPgg0EtvkvireCHnGS2OA2ZjfO7KAjhiVTFaue
         tB8QgOUFZRSRhvkm/XYQH/u29an7HeeNJzRJwOK6NeHvvSzLqOycPfkOtr5W35Syfpso
         26WQ==
X-Gm-Message-State: AJIora/QzqyIeb0IFdcMlrUqLunHg8NzpnNh4Z71TP3H54Fi6eRPuH+w
        0sZ1Xnv6zsp9QKsxdmxv97jsHMzALd/DOQ==
X-Google-Smtp-Source: AGRyM1te30gT4WDkJSV2XDPkM0UV+iGzdZu4vUtleQGiFIkXe9Kdw65n/BYYxIzZ8sE1SC3YLMA75g==
X-Received: by 2002:a63:a748:0:b0:40c:9a36:ff9a with SMTP id w8-20020a63a748000000b0040c9a36ff9amr453411pgo.545.1657236259119;
        Thu, 07 Jul 2022 16:24:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s65-20020a17090a69c700b001efeb4c813csm94014pjj.13.2022.07.07.16.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:24:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move apoll cache to poll.c
Date:   Thu,  7 Jul 2022 17:23:43 -0600
Message-Id: <20220707232345.54424-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220707232345.54424-1-axboe@kernel.dk>
References: <20220707232345.54424-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is where it's used, move the flush handler in there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 12 ------------
 io_uring/poll.c     | 12 ++++++++++++
 io_uring/poll.h     |  2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index caf979cd4327..4d1ce58b015e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2445,18 +2445,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_flush_apoll_cache(struct io_ring_ctx *ctx)
-{
-	struct async_poll *apoll;
-
-	while (!list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del(&apoll->poll.wait.entry);
-		kfree(apoll);
-	}
-}
-
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 57747d92bba4..f0fe209490d8 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -958,3 +958,15 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void io_flush_apoll_cache(struct io_ring_ctx *ctx)
+{
+	struct async_poll *apoll;
+
+	while (!list_empty(&ctx->apoll_cache)) {
+		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
+						poll.wait.entry);
+		list_del(&apoll->poll.wait.entry);
+		kfree(apoll);
+	}
+}
diff --git a/io_uring/poll.h b/io_uring/poll.h
index c40673d7da01..95f192c7babb 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -30,3 +30,5 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
+
+void io_flush_apoll_cache(struct io_ring_ctx *ctx);
-- 
2.35.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4418750EE4A
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiDZBwV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbiDZBwT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:19 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932CC55492
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g9so14807605pgc.10
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2HaDp8o9OYUpebmbji1WyT36A48ETwAR600/PzNGTEA=;
        b=67HqywTIMO3GqDDyFdvvwfMC6exst0mhKC9ATI5NEdwC1mqumSHyG362g7JIsKWWUW
         cF68JnkS+xWCVAdWXTMzGIDPr1aNyBKdUpKz2j7OygZfg8Ag7671vPfeo6WuyswJfPKy
         vVcLDWDtl26KHCAhgYK2TvF2Xx83xZyURyVIhIdb0VCHDdndXJuJA2lttXiw8c74Vz1u
         5s5AbzLRX57ZLNovdZf2lMIS7G3bKuSQ7+ZlLyzH41mVIPCEjnYgqp+924wxsZecfi6/
         CszGegB8u+Lxieag+KGraUqEi2lEUqrqfJqvH2ttEOJPLpNkjRW+3YZYkoj/C6gLIAjB
         /0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HaDp8o9OYUpebmbji1WyT36A48ETwAR600/PzNGTEA=;
        b=HyOPu9TefguruYxogBFgDrB4zrOoaw/3gkhzFOttXBmzb/8FWYYp/q1K/zYKu65dSd
         XBtX0/Hq19gj/lJE0lZod5nPSHy51yHlVJjsibO33bocbpxYcJLxcKWkAa78XW1MZ3qV
         pxW+DRuVdZ3hrhxbcjqAQbJ6ec9D0W+KmEToeMOOpGE9LqF3F6r/066C/1qVpZiRdW3F
         icg1v65V8ZnBvxja9Eh4jxagyupEF3Ejuketlgsfk65SD12T1+1KrgdjAejxbGa/e3uG
         L2pGkdF0mbvr+viBvVG8SlsHb+PB19aKCEPSXySjQT0SlIRSWLprX4s0vY6Zir0Dkojz
         XKrg==
X-Gm-Message-State: AOAM530kpoSJjpl0XwtuWWswwDkZeeK4y+5thv70ewMLlb0Q2606Po8s
        dlyhJp2wu21RdfbZTOkPET+VFr6DixwXlxla
X-Google-Smtp-Source: ABdhPJz2AF7so5LiRe/yyjXrMEZT0YAj/IRIbIBzkTa3CI889D4RD1UsN8Q2EP9zWIfr8dTa/o0KLA==
X-Received: by 2002:a65:6cc9:0:b0:399:26da:29af with SMTP id g9-20020a656cc9000000b0039926da29afmr6108226pgw.489.1650937752732;
        Mon, 25 Apr 2022 18:49:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_COOP_TASKRUN is used
Date:   Mon, 25 Apr 2022 19:49:03 -0600
Message-Id: <20220426014904.60384-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this is set, io_uring will never use an IPI to deliver a task_work
notification. This can be used in the common case where a single task or
thread communicates with the ring, and doesn't rely on
io_uring_cqe_peek().

This provides a noticeable win in performance, both from eliminating
the IPI itself, but also from avoiding interrupting the submitting
task unnecessarily.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 17 +++++++++++++----
 include/uapi/linux/io_uring.h |  8 ++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e9ac5fd3a8c..5e4842cd21c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11696,12 +11696,20 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->user = get_uid(current_user());
 
 	/*
-	 * For SQPOLL, we just need a wakeup, always.
+	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
+	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	ret = -EINVAL;
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		/* IPI related flags don't make sense with SQPOLL */
+		if (ctx->flags & IORING_SETUP_COOP_TASKRUN)
+			goto err;
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	else
+	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
+		ctx->notify_method = TWA_SIGNAL_NO_IPI;
+	} else {
 		ctx->notify_method = TWA_SIGNAL;
+	}
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
@@ -11800,7 +11808,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
+			IORING_SETUP_COOP_TASKRUN))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5fb52bf32435..4654842ace88 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -104,6 +104,14 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+/*
+ * Cooperative task running. When requests complete, they often require
+ * forcing the submitter to transition to the kernel to complete. If this
+ * flag is set, work will be done when the task transitions anyway, rather
+ * than force an inter-processor interrupt reschedule. This avoids interrupting
+ * a task running in userspace, and saves an IPI.
+ */
+#define IORING_SETUP_COOP_TASKRUN	(1U << 8)
 
 enum {
 	IORING_OP_NOP,
-- 
2.35.1


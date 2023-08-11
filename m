Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AC47795EB
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbjHKRMy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 13:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbjHKRMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 13:12:53 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4C3E54
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:53 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6872c60b572so446637b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691773972; x=1692378772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIVeZnOogR+pDqXW8mczJRQ+AF8mak/aVUoiJjKFlV8=;
        b=YQb7C099suF8kAVB8HYMgRrnfZuo2q0NGrHX1LAks1XcV8Ww7gZ9rFEuiPHWDr9qwb
         1Dl4XDdG4FMqGmpATFLk8FLCVeH+0nYiCRUA4JP6MZqh3zQmbkCodKCVUQ6lwkW+0b1B
         0fCAdbJ/ylDnI0uscjVMRIzR5PEqWJ83GkBZaAAcmEa1c2/foUf3ywXblr2AiZ9MBayr
         dYIR6/+IltBeygqpVzBAnli2exh5ry64ajv65swJ5vQ6P+pgou4EcAut7K9dv4tkflzv
         TGRFIsiGCRVmqMuCc28xK3a2YZoATt8WWsTavZ6rig+ywYCOqooZ8LwOeXKGCQ9haIMu
         ZlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691773972; x=1692378772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIVeZnOogR+pDqXW8mczJRQ+AF8mak/aVUoiJjKFlV8=;
        b=iQ5r4Lhm0K/8zPAX7ABysRUFBBVZNd3T/sZUSOVmqTW2uPCxZaGoCce0imtxdChUGv
         WJ4wXXT00ok+9WDxtu5h3w6s8CiEOrZzjaWcDxqOjR9MZFM/SzS4cCvYGUhU+R/2r4e/
         RMN3uSxUVAnsG6TQMQJ8Wic0t3hpHsCFaKwwVI+XcBtRHiq+OnFm2mZmnDTQnuaUjYHJ
         eETIJaTACbLR8QxvKsAjyfX4CTo84tBRgXIXR/hftaH9beiwx8EhWrMDVtt+Ynt4c31c
         hZEC4ftIRiUTcFi4R7VA9Bi87wEclprC+bQO//wr47sgczXVcOkFtAAbRP2aMQ8Ao9mV
         f9ww==
X-Gm-Message-State: AOJu0YzDENn74LdNfegbo9NcgJpmVclEzfvxSrdFI0EZW65bWput1+2S
        8oWQhWe2Ft2XY25x3V8B9yCXMYeCYAsWhrls/bo=
X-Google-Smtp-Source: AGHT+IFmnJMJWDRudjaHKIcnM73TMLW7ug40pRIXsNUY/4lJK5SGtEY1/gC6KfbwgEmqNzzZHxj78w==
X-Received: by 2002:a05:6a00:2d29:b0:686:b990:560f with SMTP id fa41-20020a056a002d2900b00686b990560fmr2974254pfb.2.1691773972027;
        Fri, 11 Aug 2023 10:12:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u20-20020a62ed14000000b006870b923fb3sm3541250pfh.52.2023.08.11.10.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 10:12:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: wait for cancelations on final ring put
Date:   Fri, 11 Aug 2023 11:12:42 -0600
Message-Id: <20230811171242.222550-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811171242.222550-1-axboe@kernel.dk>
References: <20230811171242.222550-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We still offload the cancelation to a workqueue, as not to introduce
dependencies between the exiting task waiting on cleanup, and that
task needing to run task_work to complete the process.

This means that once the final ring put is done, any request that was
inflight and needed cancelation will be done as well. Notably requests
that hold references to files - once the ring fd close is done, we will
have dropped any of those references too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c30c267689bb..df6ee78b70aa 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -374,6 +374,8 @@ struct io_ring_ctx {
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+
+	struct completion		*exit_comp;
 };
 
 struct io_tw_state {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 68344fbfc055..c65575fb4643 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3068,6 +3068,9 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		 */
 	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
+	if (ctx->exit_comp)
+		complete(ctx->exit_comp);
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
@@ -3116,6 +3119,8 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	mutex_lock(&ctx->uring_lock);
 	io_ring_ref_kill(ctx);
+	if (current->io_uring)
+		io_fallback_tw(current->io_uring, false);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	if (ctx->rings)
@@ -3144,9 +3149,20 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
+	DECLARE_COMPLETION_ONSTACK(exit_comp);
 
 	file->private_data = NULL;
+	WRITE_ONCE(ctx->exit_comp, &exit_comp);
 	io_ring_ctx_wait_and_kill(ctx);
+
+	/*
+	 * Wait for cancel to run before exiting task
+	 */
+	do {
+		if (current->io_uring)
+			io_fallback_tw(current->io_uring, false);
+	} while (wait_for_completion_interruptible(&exit_comp));
+
 	return 0;
 }
 
-- 
2.40.1


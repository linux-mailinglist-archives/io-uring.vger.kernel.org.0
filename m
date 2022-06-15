Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1954CEC6
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356588AbiFOQel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356664AbiFOQej (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:39 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5CD35277
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m24so16082309wrb.10
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YslBqT2nf9mKwXwSapr90WAkEwuBkksdeZNpVq3Qt0E=;
        b=Gulur6szQmdJcVyVzv3xbacBYgFHdyp3hQ2GLusEwaLr5c2/nCbnfYq5fOrnsxhuVg
         Bm03PmKGW+7qiU5oIhIWIdIzWekEnRPRDvW/DU1VViREnrhBOxjz6jgKDjDe1PJT8CzU
         yybFdjpJ1VmqoSoS3HpOa4ilFPfEft3jRMwhzMFOOVT4Myp6lWMxaLT4gojLEredLkfd
         YaUfX+pILEGJThV3px0RYLd2LF3mkKOkqTsz5SRtccdwQpHhMC522NjTp3l/YeM08sDM
         iiTIW7spzLWj+kKuYjoqWSnGWYLR8DHu7S2tw8P0OQkxptwT0pbVJR8eGGSsLWk7WA4q
         PWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YslBqT2nf9mKwXwSapr90WAkEwuBkksdeZNpVq3Qt0E=;
        b=ErdPbbB06dpi9C+8nD2eHBAokbP3IWVxIEVYduq+CFJ9WTyC53K9OoDT1d8XJ/tCNv
         Q598Id9oInbw21Om8tZNV7MZyLom0ArYu+8MIafClWhhc6Vsyp5Ju22NeMidjYy7LoS9
         /0fbRZwZdqyyRETyfNbzOtVMKuWzGeVtorewetcDAQk26YvMPswjSu0NS3h0CwmnZ9NZ
         Hy5GriBTzuH8NN1BefFMh36Rw4KX54FI1rsJAM/EMvpHveYW1Cnnm+K8st/F0Ibtv6Ne
         4jjQ8eOnL6fmRfqoVD5xPVlJlvhW5uJ4XMYZvqd0zqnuuPFtfQWVaLqP/fupHyC4Wq44
         1bvA==
X-Gm-Message-State: AJIora+XAgskoKIcPJB7EwnfLHB2VbQUy1Kq63MOXX/vT2ddRqmGaclI
        JlWlzylRET6pr1/JSbdBSfPufZ7hX1BOww==
X-Google-Smtp-Source: AGRyM1vHmTjCN5WUHLg+JcHjHEzv3EEqmxBYOxod3YDyI7iEHHEjNTFFGzS2cq43wbW0FpkiLCD1ZA==
X-Received: by 2002:a5d:4b81:0:b0:216:592a:9775 with SMTP id b1-20020a5d4b81000000b00216592a9775mr645523wrt.350.1655310872202;
        Wed, 15 Jun 2022 09:34:32 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 07/10] io_uring: inline ->registered_rings
Date:   Wed, 15 Jun 2022 17:33:53 +0100
Message-Id: <495f0b953c87994dd9e13de2134019054fa5830d.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There can be only 16 registered rings, no need to allocate an array for
them separately but store it in tctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 io_uring/tctx.c     | 9 ---------
 io_uring/tctx.h     | 3 ++-
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 38b53011e0e9..dec288b5f5cd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2744,7 +2744,6 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-	kfree(tctx->registered_rings);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index f3262eef55d4..6adf659687f8 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -55,16 +55,8 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (unlikely(!tctx))
 		return -ENOMEM;
 
-	tctx->registered_rings = kcalloc(IO_RINGFD_REG_MAX,
-					 sizeof(struct file *), GFP_KERNEL);
-	if (unlikely(!tctx->registered_rings)) {
-		kfree(tctx);
-		return -ENOMEM;
-	}
-
 	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
 	if (unlikely(ret)) {
-		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -73,7 +65,6 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
-		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index f4964e40d07e..7684713e950f 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -20,8 +20,9 @@ struct io_uring_task {
 	struct io_wq_work_list	task_list;
 	struct io_wq_work_list	prio_task_list;
 	struct callback_head	task_work;
-	struct file		**registered_rings;
 	bool			task_running;
+
+	struct file		*registered_rings[IO_RINGFD_REG_MAX];
 };
 
 struct io_tctx_node {
-- 
2.36.1


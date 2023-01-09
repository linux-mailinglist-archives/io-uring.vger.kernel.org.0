Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0D662901
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjAIOvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbjAIOvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:02 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EA25C1E1
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:28 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so20715133ejb.6
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXZ0R/vngPIHzg49UY7ejzbbt7EIlOcMiLJQ3nWY+40=;
        b=VjFnHpJtRI4Jxz1fORNuvOs0FeJs0FQ6dsB7TTYfLTn9xZ7QE8o6E36kzx8jqCFmim
         neWPhd5WcYLvLqpBKpx8MHBr/f/MDIytjqFtuFJdaCzYKT1Ox5Rn4LUJO7r39BawvN7+
         1cuKCVQZwitmTkEXTRbQ0+i/zv587Q03oxnJoCTjPexmGGDai4V7sQZDR5b62cnQwBw6
         8fmCotkAnHm0/I2lM13/0BUz/9tC9scrv/QxDD8TnpWJoBx7p3HOiQYrXj5LFrqsbLdN
         9H+edrvN/7nx08OoXDpL70OjBm5e1Gg2zSBSTAaFqjxXqasH7z9sDhP/jH2FtfQy0B4K
         Tjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXZ0R/vngPIHzg49UY7ejzbbt7EIlOcMiLJQ3nWY+40=;
        b=FwtVJJAcjmoQ31kBu53/mD5i156GXR1z7wXWANH2r/l/4Md5j0i1wbZqL61nEU54fM
         DR+PcA+a40Fj4ASS60UevpurQMUpM5z3JvZ50vjfCiRnMNlrZwanf4gAIHgsHktmIP4A
         4aAbmSTPjNLWAwDJFbcGVK06bg9WbTgOo0f25iZjgFpKWdWnQr98dLTReBBMghB9LQ+B
         RljvUp/Vd9G27vztTfbohYsF1HPNIW1gNGSy8Z61KQXcY8nl3/r0LHhzPMeu/jevyvmq
         PIHeKV5b0+7rsuN+TTTelIgEusOOEA2xZZiJtl30ZlrDk6KOTewHLwbi3cicJAICz/2i
         reVQ==
X-Gm-Message-State: AFqh2kpeRQFmfwUeB0Ldxifi7epmvrL0DKrpbVMcIUSYZGmPPKZbOfFC
        D9wpzALSgi0Tt+GghjCXDpuCIY7dIzc=
X-Google-Smtp-Source: AMrXdXsvprBQVk2T97NG12cff8/Pa36XKnxVNIMH4YpYguBBSL2eN/ZA2GZUZCO9AhoDFyPG2he4pw==
X-Received: by 2002:a17:907:9a85:b0:81b:fc79:be51 with SMTP id km5-20020a1709079a8500b0081bfc79be51mr58742182ejc.50.1673275647025;
        Mon, 09 Jan 2023 06:47:27 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 03/11] io_uring: don't set TASK_RUNNING in local tw runner
Date:   Mon,  9 Jan 2023 14:46:05 +0000
Message-Id: <9d9422c429ef3f9457b4f4b8288bf4789564f33b.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

The CQ waiting loop sets TASK_RUNNING before trying to execute
task_work, no need to repeat it in io_run_local_work().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 157e6ef6da7c..961ebc031992 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1339,11 +1339,9 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 
 int io_run_local_work(struct io_ring_ctx *ctx)
 {
-	bool locked;
+	bool locked = mutex_trylock(&ctx->uring_lock);
 	int ret;
 
-	__set_current_state(TASK_RUNNING);
-	locked = mutex_trylock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, &locked);
 	if (locked)
 		mutex_unlock(&ctx->uring_lock);
@@ -2455,6 +2453,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
 	if (!llist_empty(&ctx->work_llist)) {
+		__set_current_state(TASK_RUNNING);
 		if (io_run_local_work(ctx) > 0)
 			return 1;
 	}
-- 
2.38.1


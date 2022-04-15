Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54945031D1
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiDOVMO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352683AbiDOVMD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:12:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E122CE1D
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id p15so17121575ejc.7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lrIO8U7BrCYpluFDkAl7ZrYxVXte8hWv+FBYNYWgow0=;
        b=qDZOAEVBl4uEo6aNvRbkzlqTCwpcbFdZWTde0S3Ok3eEZUXonRa4doE+sxzPWyMHSF
         9+gXZNnrubfI5q2dLT4yIkSYnnOSUEtKcKs5H/4VCvGaZNwxmAy/krjnh/PrsoLGKLCW
         yaa+O6fCOaXi7K0S9f3Wn45wzH+2s98BBhbsKWb/m1l8BxetN6YSRd2lgEJ+zQpxJ59N
         tSysY5EOYb3znuCsb4VclKL+PCudL0tP42GNf97W8MxGsRM34ZkyWbb65HXOdfmgUpSv
         l5jbRBhduFB83GSd69f4pB2crqysCUCxnenicsHMcQORHGTxSic+dM2REFr4AEhFPnxj
         ofng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lrIO8U7BrCYpluFDkAl7ZrYxVXte8hWv+FBYNYWgow0=;
        b=Hb7DI8Iu8vupxwTpusTWlOYgtW6pye8mX3q4zgWdlnS4sV92P5AKQIPs+wI27FcVtT
         YQ8Qn5G0gjF3dO6D5WM4jSrHKhYiQrJr1+ff7lm5KD3t+r2v3bJtQhn7QxxPoWxcqQMW
         kUaTOnJjnogRzbGlXx3bvVs9jBdU9vVG4oLklf2adw8LHPHvo20ws30uZJTlJaLy54tQ
         RT5SLprfwCr5kGjAZTxiIBADV+eDlkGSNUARmyTCoRgOu8LpGyb0ZBvCTfZfxjEymw5c
         Dd4r47ybPe1Xl8t7c8yyNTfuQs9oh132YYrslK3zORUCVCS672D1oD2+txpM8HDw4B+H
         nwIg==
X-Gm-Message-State: AOAM5321TDPUr0mdJgiqJCRUF2VXU65QfTVQZhNYgVP7hA/Qy2A8eZ7T
        axr5Z/Yp69XyIwsUwVK0smzuryyPLCc=
X-Google-Smtp-Source: ABdhPJzw5N5+O5mf/aNoMrmalaI8hiqFQSaMDnIOyagmjlm4S+FvixMSfu3rHQvbnBjub81GJ0qMbQ==
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr672056ejc.149.1650056971585;
        Fri, 15 Apr 2022 14:09:31 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 14/14] io_uring: add data_race annotations
Date:   Fri, 15 Apr 2022 22:08:33 +0100
Message-Id: <7e56e750d294c70b2a56938bd733386f19f0eb53.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

We have several racy reads, mark them with data_race() to demonstrate
this fact.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a828ac740fb6..0fc6135d43d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2272,7 +2272,7 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	 * locked cache, grab the lock and move them over to our submission
 	 * side cache.
 	 */
-	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH) {
+	if (data_race(ctx->locked_free_nr) > IO_COMPL_BATCH) {
 		io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
 		if (!io_req_cache_empty(ctx))
 			return true;
@@ -2566,8 +2566,8 @@ static void tctx_task_work(struct callback_head *cb)
 			handle_tw_list(node2, &ctx, &uring_locked);
 		cond_resched();
 
-		if (!tctx->task_list.first &&
-		    !tctx->prior_task_list.first && uring_locked)
+		if (data_race(!tctx->task_list.first) &&
+		    data_race(!tctx->prior_task_list.first) && uring_locked)
 			io_submit_flush_completions(ctx);
 	}
 
-- 
2.35.2


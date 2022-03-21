Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C24A4E3394
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiCUW4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiCUWzm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:55:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3008444AE01
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:34:11 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id pv16so32802119ejb.0
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SjMIkZL36Docpza2lFel3cf/TRz1rCQGbkr8HbFiuQs=;
        b=cJ1yn/aYVcWa021w2E40ZGvEQVJQDNjD1HyzVsLLs5oRUNQQxUqIPJMe3MxF5XLHUo
         OsIIsCuTDSkqguUrbhP0CT2STvF7MIM4LKgWEJpyC/RvZhdSoFIA6QO0UP19OH6FFggW
         viGLeX9HN8386F4Gn2M6VYrgLyL1TOcNQHcOAK5pfExNlqrY9QkofnWnUaM+lc7negOm
         NGS5ZueSvEowcECxu0Rpf46DCL0QLbKHPdd2MPMf4DYD2T+Ycw9AuQuq4SsrJsa+Glef
         cv4t6zPbLRZqnv7jB0rgqDa8bIzOKh50WP+ptzhjQCT0DrwYIP8FDnDVVZE5VZzgZnrp
         GKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SjMIkZL36Docpza2lFel3cf/TRz1rCQGbkr8HbFiuQs=;
        b=1HAfNgJZd3UzoX/NLeETiai5D8zvWhkcGSKafm58uccMzH8rncV1xhHdlJXITN5uvX
         lG67UDkVsE0grlMXQ9Qs+Ux60Rfv3spra4fdyQ8lSvc53dSSb4ugPA6r6zRNjnJlh3kM
         EILTnSEoDJQvr2+Q3NybkPbR5DyZi87GGVlaIJbWV7YjkWbY73EuVwEz+0l9kQbpDim6
         WAgSw6VVuysJjFaCojfGPt63w3tz04qWhzNhlRhOh8qUabhskkhWOHd76r/FnzBGRC5c
         gdk1iobPT2ep/yweKMsyynnczsgY/OjAuIhPZBNy0fWAByvIbUDL29IIFO2YWHfvKPHB
         h2ZQ==
X-Gm-Message-State: AOAM530+pd0Q6kZtzBuVqrH4PgK6fKvvmWFGh9HNJnlw+Xv88Qsi4gbd
        VjLI/ze5UWWXK7AFS64gysaFi3br8CrfOQ==
X-Google-Smtp-Source: ABdhPJykT3Wx5Ce7lQVzx3KMginn0SjxB7N4vgnaKIAKZxKz24SYu5qak2UIFEqlktP2Ngp8B+4b4g==
X-Received: by 2002:aa7:d5c1:0:b0:419:113:3e2b with SMTP id d1-20020aa7d5c1000000b0041901133e2bmr21741332eds.237.1647900236997;
        Mon, 21 Mar 2022 15:03:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:03:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/6] io_uring: small optimisation of tctx_task_work
Date:   Mon, 21 Mar 2022 22:02:19 +0000
Message-Id: <c6765c804f3c438591b9825ab9c43d22039073c4.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
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

There should be no completions stashed when we first get into
tctx_task_work(), so move completion flushing checks a bit later
after we had a chance to execute some task works.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a65d7880440..bb8a1362cb5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2492,10 +2492,6 @@ static void tctx_task_work(struct callback_head *cb)
 	while (1) {
 		struct io_wq_work_node *node1, *node2;
 
-		if (!tctx->task_list.first &&
-		    !tctx->prior_task_list.first && uring_locked)
-			io_submit_flush_completions(ctx);
-
 		spin_lock_irq(&tctx->task_lock);
 		node1 = tctx->prior_task_list.first;
 		node2 = tctx->task_list.first;
@@ -2509,10 +2505,13 @@ static void tctx_task_work(struct callback_head *cb)
 
 		if (node1)
 			handle_prev_tw_list(node1, &ctx, &uring_locked);
-
 		if (node2)
 			handle_tw_list(node2, &ctx, &uring_locked);
 		cond_resched();
+
+		if (!tctx->task_list.first &&
+		    !tctx->prior_task_list.first && uring_locked)
+			io_submit_flush_completions(ctx);
 	}
 
 	ctx_flush_and_put(ctx, &uring_locked);
-- 
2.35.1


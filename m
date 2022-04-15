Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608A2503124
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245670AbiDOVLs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345968AbiDOVLq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:46 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8C1D4CAD
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 11so6068145edw.0
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jMS/o6t15jMIzU1TwrLp702CdPyD57WZQMKvWIJuKfE=;
        b=ICIGOQuJEh0y/ezrSAd113+DgEgmQMilal8KK5FV9jyjdz8yGokv1sAt3FJgvJtgGb
         iBjwnkD9+H0TQ6stpc7nUrB4jJCRl1URZBOfplm+fNN4qjaz1wLyVGagw8+FtEGn5MUq
         mZd5rsLpifldz76H3KVWy7w5mndidUp1S8PGTtIhlPrPdqU5j7XOb/r7YtFekkzPiCFg
         TFlYpyMReCQxZEtU8o+hRIBg5kTEhXXSkAUNM1Jf1NUSerQyV6swx8YT8C3JOIGX7o+V
         ukxxTmhRSjNFUNfkcA/9NFybM4SaOMcabWOdzYDbNyIJZ/Tt/oEXlYNkTmHPZTYVeaw/
         TL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMS/o6t15jMIzU1TwrLp702CdPyD57WZQMKvWIJuKfE=;
        b=BvaBq1s1O0dIQlk5tUVCExglezYGdaiFN6fG21/ew7UY7wsOM8c7vwd48cF5E1pPYg
         KLawnWudRZwqAAu5tnnH+bI7etHQODKSk7i9YN1zS7mTPYKy4Eo4DssV+S86i+TJ0BDk
         CsrQd+9DIuXbvCmnEB42w2XTJQ5TtBViXieKp/3QIytt64FHNKCxuD8sTT1evXM3b/6R
         BmW60JRyI7i7eLXURQ5viwJO0/XWDTcNT0ANTTHTOqTvdF+vWcmOoEMnneRuE2trisaO
         WWXrJusuJI425hMw925yxshMTHeuECkpb9dXMjEqsjk0HhKaq77hglPv0K6GqWYggVaa
         r+LQ==
X-Gm-Message-State: AOAM531sobs9+hwbjfx6UGjejNBJNz0E3aVS9F7jxfzQU2s6oeNd3aHd
        h2x89tPUZkOCmhRn194CkYhKXAJcB7s=
X-Google-Smtp-Source: ABdhPJys+TqBKTFR5kf9kRot9umM5b9iA5fpedYY7xlt0Dw8UGs/C/QIJnhnuJHAmR8Rv6Zx2W6xag==
X-Received: by 2002:a05:6402:2554:b0:41d:7f40:a8bc with SMTP id l20-20020a056402255400b0041d7f40a8bcmr960735edb.371.1650056955402;
        Fri, 15 Apr 2022 14:09:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 05/14] io_uring: inline io_free_req()
Date:   Fri, 15 Apr 2022 22:08:24 +0100
Message-Id: <ed114edef5c256a644f4839bb372df70d8df8e3f.1650056133.git.asml.silence@gmail.com>
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

Inline io_free_req() into its only user and remove an underscore prefix
from __io_free_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92d7c7a0d234..d872c9b5885d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1189,7 +1189,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
 static void __io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags);
-static void io_put_req(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
@@ -2332,7 +2331,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 }
 
-static __cold void __io_free_req(struct io_kiocb *req)
+static __cold void io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -2676,12 +2675,6 @@ static void io_queue_next(struct io_kiocb *req)
 		io_req_task_queue(nxt);
 }
 
-static void io_free_req(struct io_kiocb *req)
-{
-	io_queue_next(req);
-	__io_free_req(req);
-}
-
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 				struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
@@ -2770,15 +2763,17 @@ static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 	if (req_ref_put_and_test(req)) {
 		if (unlikely(req->flags & (REQ_F_LINK|REQ_F_HARDLINK)))
 			nxt = io_req_find_next(req);
-		__io_free_req(req);
+		io_free_req(req);
 	}
 	return nxt;
 }
 
 static inline void io_put_req(struct io_kiocb *req)
 {
-	if (req_ref_put_and_test(req))
+	if (req_ref_put_and_test(req)) {
+		io_queue_next(req);
 		io_free_req(req);
+	}
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.35.2


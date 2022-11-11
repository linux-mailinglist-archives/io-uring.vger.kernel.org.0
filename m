Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CB9625FE4
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiKKQzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiKKQzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:55:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2C463B98
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:33 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u24so8355927edd.13
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGWOkZNOuuV6a52KBZquSf2FBeo2kJvlLv1fLViLMvI=;
        b=MEj4MToJZQGYqQITuav0q28XlLKfeU3A62ONwekFqa4xAZYX5lR8DVt2Ps5GQOYbNm
         FiUQ0PNnBBjimzy3+wHOGMHjt1pNgnxg59fKOz0AYcLZDKHUbM5e7cwdO2LAHj3zHEHd
         IBJYPqvAJfRspX/HKEXxSkSDxORu1S9yO7DUIcsrBkRSka4SwqIz5C2zszpCLnsDMzh7
         yowoRYytg8cBBAu/SzqsUxzgkRTCyxoVX3JC7/nVDd5RD87Fu79xydvlg3cDp3QLmBpp
         DzCfoXtnye2StOjB0TlSxGAKDNoDiQlfe4vdu+FMKNhwr16BF6NczlldwaoRCjFka5/z
         gi1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGWOkZNOuuV6a52KBZquSf2FBeo2kJvlLv1fLViLMvI=;
        b=TMHUE+/lo1EHG+R1Wm0K9jM/2urmhtcJyQUQbE+G8M0Mn+Icjktxb2GDFraqhufEOZ
         nwfiQZ8ZplMnNhFe6RJ+TjQBCG1pXnvdBApyfed5Q6pxsMiXV70m7iFzyqgUlqeuY8mi
         KUlT/O42+73C53R6XFDSW9hOnR7G7GrNc8RbaAYq6KP84/hHcbainCYzEpuzdSM2T9sj
         7xXz2siarxS8ovOH04LzSAMFTR7G7Bv5FyKGI948R47KLSR/aJ4Hs9R6qJvWCqKveCVN
         oPpwqYblbauRjrkFmXr+5QqZVlih7sBbGYgMEJESLhlVOoIxUxAEWmGhuFZg7FIhM0o6
         dtDg==
X-Gm-Message-State: ANoB5pkCrxHerCpUStWFA0dVduKDc96+pf55Bfrt/gZ56TUdR2/ORu+w
        Jy1FtTkS0lId+1Aq+8eHwwzHYMxZsX8=
X-Google-Smtp-Source: AA0mqf6ukwPfCSUZCmvus1x8F4b1DzZOGN7vp5WRvWlrx/DnVXvwzr9gqwN7n29yaSRXgdSJgYMQaQ==
X-Received: by 2002:aa7:cdc8:0:b0:463:f8aa:d2bf with SMTP id h8-20020aa7cdc8000000b00463f8aad2bfmr2252385edw.358.1668185731410;
        Fri, 11 Nov 2022 08:55:31 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id 20-20020a170906329400b0079dbf06d558sm1022540ejw.184.2022.11.11.08.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:55:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/2] io_uring: inline io_req_task_work_add()
Date:   Fri, 11 Nov 2022 16:54:08 +0000
Message-Id: <26dc8c28ca0160e3269ef3e55c5a8b917c4d4450.1668162751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668162751.git.asml.silence@gmail.com>
References: <cover.1668162751.git.asml.silence@gmail.com>
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

__io_req_task_work_add() is huge but marked inline, that makes compilers
to generate lots of garbage. Inline the wrapper caller
io_req_task_work_add() instead.

before and after:
   text    data     bss     dec     hex filename
  47347   16248       8   63603    f873 io_uring/io_uring.o
   text    data     bss     dec     hex filename
  45303   16248       8   61559    f077 io_uring/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 +------
 io_uring/io_uring.h | 7 ++++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 19a17d319901..f4420de6ee8b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1117,7 +1117,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	__io_cqring_wake(ctx);
 }
 
-static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1149,11 +1149,6 @@ static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local
 	}
 }
 
-void io_req_task_work_add(struct io_kiocb *req)
-{
-	__io_req_task_work_add(req, true);
-}
-
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
 	struct llist_node *node;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d14534a2f8e7..0b0620e2bf4b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -48,9 +48,9 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
-void io_req_task_work_add(struct io_kiocb *req);
 void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
@@ -80,6 +80,11 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+static inline void io_req_task_work_add(struct io_kiocb *req)
+{
+	__io_req_task_work_add(req, true);
+}
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-- 
2.38.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524286452BA
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLGDyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiLGDyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:41 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E352158
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:40 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e13so23144085edj.7
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5fgO8A8lvZ98Yk+tc8eOFrqMx1DtgiAeuBltW/yuOA=;
        b=mNyRTWAGsag5ljFZSekhTerSRx48o8RQeSDc449OmHrp18NxwHe129CrQJH+hi6dU0
         pRc7tLDOx2LAEMHA+hLaQHOm68hGqft6/vHnM6+Ha60fzk135CTaUICAglpvD9UuCO0u
         FRFLcBpznBV1LGkyO1BFsTyq0HaNLs7yqDYlVHZArrF/s/PFCT5bCZ7hUJJH5SarxkKg
         rmn7QPcRMd2K8X4Iv+FP7hjOZvUT+dVN8RarQzluuwyz8+pThYJPgJ5Jripu/bNrFEaU
         Ssmzp8d3Uqya1lfvlKmBtWwGUEv6jGOqbbEu5Vn9QcRSls56X//7LBP86cQ/evZ3v4mz
         6J5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5fgO8A8lvZ98Yk+tc8eOFrqMx1DtgiAeuBltW/yuOA=;
        b=qKcTpg083qxNIpZvxD3m6Vb1ERstiqf9aHm3Go3Hb2ZUNvcBNHDbkKNcig0QqqnbMb
         ayEYJwIfFU9IINXb/hkvSLzRLoipGhmZkXWeR9AREP15X6CJrIse+uVPcbKBxjYq4Wu3
         vvDZBJru6EK7X5hFfWTeLxrl6osYz9hDrptxm90RsxnyxFMOMZN5ZfPW75lEaCGZGjOI
         ZDj5MBkJ+CiuX6ne8AW/7Sn0OKOYEh91wA0K7ibQJyG6HhLzAP4Z3PtIGHBRt8OrxaRW
         KOj0pwogCy+AbfuMKQGF+pfC5U/Sldn2FTLoKmIdJBgn5Jh3CiJpAr4hYCqUKv8Jj753
         51cQ==
X-Gm-Message-State: ANoB5plaEhljU7+gi1Va5n+9Dv/dhd9QAhyChN+C6lL/8rLWkDQXtdfG
        D1BFJY3x6ivbWkHlRvzIzjWL3SxOj1A=
X-Google-Smtp-Source: AA0mqf7dM3J636vTKokAE6NkXwDWARNABM005EFropR0+g4fqlcoTze3SMNXWR3vbnr3hydMCxBh1Q==
X-Received: by 2002:a05:6402:548a:b0:468:e8e2:31c9 with SMTP id fg10-20020a056402548a00b00468e8e231c9mr14184891edb.310.1670385279242;
        Tue, 06 Dec 2022 19:54:39 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 08/12] io_uring: never run tw and fallback in parallel
Date:   Wed,  7 Dec 2022 03:53:33 +0000
Message-Id: <96f4987265c4312f376f206511c6af3e77aaf5ac.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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

Once we fallback a tw we want all requests to that task to be given to
the fallback wq so we dont run it in parallel with the last, i.e. post
PF_EXITING, tw run of the task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a422a7b7132..0e424d8721ab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -149,6 +149,7 @@ static void io_clean_op(struct io_kiocb *req);
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
+static __cold void io_fallback_tw(struct io_uring_task *tctx);
 
 static struct kmem_cache *req_cachep;
 
@@ -1160,10 +1161,17 @@ void tctx_task_work(struct callback_head *cb)
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 	struct llist_node fake = {};
-	struct llist_node *node = io_llist_xchg(&tctx->task_list, &fake);
+	struct llist_node *node;
 	unsigned int loops = 1;
-	unsigned int count = handle_tw_list(node, &ctx, &uring_locked, NULL);
+	unsigned int count;
+
+	if (unlikely(current->flags & PF_EXITING)) {
+		io_fallback_tw(tctx);
+		return;
+	}
 
+	node = io_llist_xchg(&tctx->task_list, &fake);
+	count = handle_tw_list(node, &ctx, &uring_locked, NULL);
 	node = io_llist_cmpxchg(&tctx->task_list, &fake, NULL);
 	while (node != &fake) {
 		loops++;
-- 
2.38.1


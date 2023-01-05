Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4355465E9BD
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjAELXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjAELXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526DB4E42B
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:32 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o15so27765809wmr.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMmgDhX/8Q1PK6d4K+oWZL4fFf/Ozl6eNXYKVdbXoII=;
        b=AFboG8pjKdO3R3Y+V9LC9L8LAGkRoZ0cOXUcSZ4ckPTHJ/CGUPsKztRVmj2HQuq15O
         86ZlbGfFwUY2dnBNYoI28QiYaNbEtYfW2FD13x4802t6FKbQz9VVi/vJsXEWxRvR3lhW
         eoK4lKXkzGIw8MGv5qkVZeG9hYxy85eLs4yogQFmOWukSqeYNXJXxc3pBzh+HzJ+p+B2
         DMuX73i2ao43odoUB+2A+3wfV0RgpEC48fXJafS/mrs186ATTApFMEhSIo6UEhejF/wD
         kXYuxHeUqG46GGvvcEUjRtEidx2l+NzgFK5EEUfmTpK0IficllqdzBzLbwz/CjZhC36q
         f7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMmgDhX/8Q1PK6d4K+oWZL4fFf/Ozl6eNXYKVdbXoII=;
        b=faBc2eOEFIpPoaV1Nni64RIIOxyp/uY5m64NhxZ7yBnwbZPvXok5yXGFxmxhGiKvVA
         QSru4C89wNoTVatiTQ2ZH3Ju+GtsFVHdvEVZGIDAEwaLb3mWODrcCaaPHowjfw0s5Fz9
         Q46DgAtO+CT1rk7Dg9qoYy8Ljv/mpFY8bRFwao5Ee4N/t4HnBcr1OJjW6VNn93GMUJKK
         YSZFVsw+xE0r60bnuk1cE+u2+szCavBpoq4FgB023sGjJJjfGZWoI78+eKJ6gDIp3KCC
         Ie/dfb1Xvk+kpP1JQj/kAGuho4iEX2HF4zCbcpJflgEfpprN8E+Io+8t6oKgHxVnCqjh
         DabQ==
X-Gm-Message-State: AFqh2koVb41X/oHRkrcDta3BtKn4Ii1gHDZozaqGtGWOGxx7c6RU5PgD
        Nk63kKRa47jwFLPo1P2t7NIKkkHxszc=
X-Google-Smtp-Source: AMrXdXs4ChaL5Ey3IfQ1XFthUDnASDSd1eMhO1chjNPsBvkjr+IJIs7LTVOeTZk8ASYf5CrUZu5nlw==
X-Received: by 2002:a05:600c:4fcf:b0:3cf:360e:f37d with SMTP id o15-20020a05600c4fcf00b003cf360ef37dmr35769533wmq.22.1672917810787;
        Thu, 05 Jan 2023 03:23:30 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 04/10] io_uring: move defer tw task checks
Date:   Thu,  5 Jan 2023 11:22:23 +0000
Message-Id: <990fe0e8e70fd4d57e43625e5ce8fba584821d1a.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

Most places that want to run local tw explicitly and in advance check if
they are allowed to do so. Don't rely on a similar check in
__io_run_local_work(), leave it as a just-in-case warning and make sure
callers checks capabilities themselves.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 15 ++++++---------
 io_uring/io_uring.h |  5 +++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bf6f9777d165..3bb3e9889717 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1296,14 +1296,13 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 	struct llist_node *node;
 	struct llist_node fake;
 	struct llist_node *current_final = NULL;
-	int ret;
+	int ret = 0;
 	unsigned int loops = 1;
 
-	if (unlikely(ctx->submitter_task != current))
+	if (WARN_ON_ONCE(ctx->submitter_task != current))
 		return -EEXIST;
 
 	node = io_llist_xchg(&ctx->work_llist, &fake);
-	ret = 0;
 again:
 	while (node != current_final) {
 		struct llist_node *next = node->next;
@@ -2511,11 +2510,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-	if (!llist_empty(&ctx->work_llist)) {
-		ret = io_run_local_work(ctx);
-		if (ret < 0)
-			return ret;
-	}
+	if (!llist_empty(&ctx->work_llist))
+		io_run_local_work(ctx);
 	io_run_task_work();
 	io_cqring_overflow_flush(ctx);
 	/* if user messes with these they will just get an early return */
@@ -3052,7 +3048,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		}
 	}
 
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    io_allowed_defer_tw_run(ctx))
 		ret |= io_run_local_work(ctx) > 0;
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 8a5c3affd724..9b7baeff5a1c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -352,6 +352,11 @@ static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return container_of(node, struct io_kiocb, comp_list);
 }
 
+static inline bool io_allowed_defer_tw_run(struct io_ring_ctx *ctx)
+{
+	return likely(ctx->submitter_task == current);
+}
+
 static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 {
 	return likely(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
-- 
2.38.1


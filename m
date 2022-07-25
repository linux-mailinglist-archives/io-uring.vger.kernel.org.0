Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA4D57FCBF
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 11:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGYJxp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiGYJxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 05:53:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E7917043
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b26so15193165wrc.2
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MTnTDrcZSjv/YbBe8gL7V5fAUWxTpbrm1lJ1oNJUf4w=;
        b=RrFOEUs5uYDk4sl+gNxqOkJW8x3L7CckgdD+sMpjYeFTowwUNn/5baHELy8B9/O8a8
         o9Qes/jc3BBhy0ucegnP+pwKNcc8gZhbz0Pf8NHgwXyxKcji589FinuSjQ8ScGJEiTsf
         vs45xWkryrxySX3JY+NiGDl+eYo+zY/cvs7sPXtQfdE+5XLVBVdYe1KnEn6310N7u2g+
         PV9kpicqrKuxjE56/V7XgJP+N9eZ0z1ESaO6j31c819hO3aTuqHy6urgDlPiL98t2WYv
         35ZT47AZLhpMmct06uA1Z6laZak/r/Qq8RGW/B/1Tux3EFCwkA4pxZl35n39Wk7OoC/d
         n0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTnTDrcZSjv/YbBe8gL7V5fAUWxTpbrm1lJ1oNJUf4w=;
        b=jrGmZ3lGOcTNNn7YMQIyS9KzbNhqtqzqOvWHXDvZU1vv5h3oncyRh/XS4z4lu7+Yrf
         MOLdRTy+WVW/8yiBUeZJ6H+9kc5TFjUUQRmvBopTq7o1ANvG6IjuCWAN8DjXqMNvQlhY
         4c3mIh+58hWGpPR1QyCrhFBE197LkkOzkRb9lDYbcuUF4uVcH/QnPthuLX/e0Kkpzbe0
         7gfudrvc+dokVlCioquKKsJgWl+pntA82IKOa+PhV4mqMoRJ7MhQSCQLqSL/hjLcqjyr
         yDB4J/oQ4PaXxW3VwssHtIXV4BUHnMWekrQjaqG/tGfPkZ5ONePxKbrTxQ4EgpykyC4x
         53ig==
X-Gm-Message-State: AJIora+mlsjIIIcyrbR1HVL/o+cWMJkoZvBFFmOyl0Lp419s8wgjghxC
        AcMCy3hKadfuggn/O9iWQecAXo1l7FnL+Q==
X-Google-Smtp-Source: AGRyM1tiwlTYHhLOmvFQCLO5XPg1WamQ7rlQkwoeLL/SdAWI05PjT0kCxx+7tF4GNCI2NKQFbSscXw==
X-Received: by 2002:adf:eb50:0:b0:21e:3d13:3a91 with SMTP id u16-20020adfeb50000000b0021e3d133a91mr6943726wrn.484.1658742822251;
        Mon, 25 Jul 2022 02:53:42 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:1720])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm18909636wms.17.2022.07.25.02.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 02:53:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/4] io_uring/net: make page accounting more consistent
Date:   Mon, 25 Jul 2022 10:52:05 +0100
Message-Id: <4aacfe64bbb81b27f9ecf5d5c219c69a07e5aa56.1658742118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658742118.git.asml.silence@gmail.com>
References: <cover.1658742118.git.asml.silence@gmail.com>
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

Make network page accounting more consistent with how buffer
registration is working, i.e. account all memory to ctx->user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   |  2 +-
 io_uring/notif.c |  9 ++++-----
 io_uring/notif.h | 19 +++++++++++++++++++
 io_uring/rsrc.c  | 12 ++++--------
 io_uring/rsrc.h  |  9 +++++++++
 5 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8fb8469c3315..c13d971c7826 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -985,7 +985,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 					  &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
-		ret = mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+		ret = io_notif_account_mem(notif, zc->len);
 		if (unlikely(ret))
 			return ret;
 	}
diff --git a/io_uring/notif.c b/io_uring/notif.c
index a93887451bbb..e986a0ed958c 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,12 +14,10 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
 	struct io_ring_ctx *ctx = notif->ctx;
-	struct mmpin *mmp = &notif->uarg.mmp;
 
-	if (mmp->user) {
-		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
-		free_uid(mmp->user);
-		mmp->user = NULL;
+	if (notif->account_pages && ctx->user) {
+		__io_unaccount_mem(ctx->user, notif->account_pages);
+		notif->account_pages = 0;
 	}
 	if (likely(notif->task)) {
 		io_put_task(notif->task, 1);
@@ -121,6 +119,7 @@ struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 		notif->ctx = ctx;
 		notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 		notif->uarg.callback = io_uring_tx_zerocopy_callback;
+		notif->account_pages = 0;
 	}
 
 	notif->seq = slot->seq++;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 3e05d2cecb6f..d6f366b1518b 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -5,6 +5,8 @@
 #include <net/sock.h>
 #include <linux/nospec.h>
 
+#include "rsrc.h"
+
 #define IO_NOTIF_SPLICE_BATCH	32
 #define IORING_MAX_NOTIF_SLOTS (1U << 10)
 
@@ -23,6 +25,8 @@ struct io_notif {
 	/* hook into ctx->notif_list and ctx->notif_list_locked */
 	struct list_head	cache_node;
 
+	unsigned long		account_pages;
+
 	union {
 		struct callback_head	task_work;
 		struct work_struct	commit_work;
@@ -85,3 +89,18 @@ static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
 	}
 	io_notif_slot_flush(slot);
 }
+
+static inline int io_notif_account_mem(struct io_notif *notif, unsigned len)
+{
+	struct io_ring_ctx *ctx = notif->ctx;
+	unsigned nr_pages = (len >> PAGE_SHIFT) + 2;
+	int ret;
+
+	if (ctx->user) {
+		ret = __io_account_mem(ctx->user, nr_pages);
+		if (ret)
+			return ret;
+		notif->account_pages += nr_pages;
+	}
+	return 0;
+}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9165fdf64269..59704b9ac537 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -44,17 +44,13 @@ void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline void __io_unaccount_mem(struct user_struct *user,
-				      unsigned long nr_pages)
-{
-	atomic_long_sub(nr_pages, &user->locked_vm);
-}
-
-static inline int __io_account_mem(struct user_struct *user,
-				   unsigned long nr_pages)
+int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
 
+	if (!nr_pages)
+		return 0;
+
 	/* Don't allow more pages than we can safely lock */
 	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 21813a23215f..f3a9a177941f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -169,4 +169,13 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+
+int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
+
+static inline void __io_unaccount_mem(struct user_struct *user,
+				      unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &user->locked_vm);
+}
+
 #endif
-- 
2.37.0


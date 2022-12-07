Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1616452B9
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLGDyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLGDyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:41 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3222027168
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:40 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z92so23228278ede.1
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP2+0OXomyqgmdewLzhRA7A0yMZuCYWYtsUc2p+oA/E=;
        b=jZEtXosr1wHSijYps7NTiYoCV9t5ecY9GqrKTPRvTz1aXlx+2+cz3WhfSv1euMFuWx
         xj1vY1gxKIR+lO9v0rvSo4IBsTsMGoLIN0bmShQgElg5sacHP/0n6bptv3rw8S8NSpFm
         I91LFmJdRWNJGqqLm2hWQ45WOldmG7X1YcRZoCCscMU7hU5iVJ5sK4mG7SEsiGRm+Jwn
         74b8il++wbEl1w8c+fzoJdqrJTEtxzS7bhoOsJmOHQQ3nnPOYTXqFBID74u1O36wURI+
         nYb/CD+ck6Ywazq62IHg/qMZ7nLqZ0aTRSw+lOLB+A3/3+dm5yo/xS+HiZ/vFDOuD6hp
         QoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dP2+0OXomyqgmdewLzhRA7A0yMZuCYWYtsUc2p+oA/E=;
        b=B/589n3+6rJt5dt0HqI4xHAWwZUiqFMIOTGDG21a870g4q5tFZjpcWsqBoT8JeBNF/
         l4tKhSMRKGMgZl//TpN2qyl5vzml9Z7rklU4R48gM46aUQQ+7J0wq1N3raQiCaIJpipz
         m6K7tNsmKop/oCdymjDd6KXhqMfHmR1jtd8x8MpY5Ohh0hmhJRk4I4D+AIZIckPq77Tp
         c8B52Jo2GYDfKxBHSjs9C1LcGBKX/Kve6C89bo4apG5+klVtgQ0SYuaIlLnNE3+IUvYQ
         f1qaI4oiM+jzcoeEK/gsBsXBCbityNqXmEkfRAIH2TsqvKlf11ooxsnepO6GTkUjGOpd
         8vZg==
X-Gm-Message-State: ANoB5plqptYEDXpKLiNcSWyu74Fi66AYt1xE0qUqEZrUaSoDHwLsac9L
        FvqQpXNhpVjUQdcheMMIJvBdyM/G9n0=
X-Google-Smtp-Source: AA0mqf46lduNoX0OZAZJgZJLLMHAAU5QRm7jafa5d9NdBCUEFnDW3f2R8WTg0v7hx0TWbtsZFiQ/Yg==
X-Received: by 2002:a05:6402:2052:b0:46b:5dcf:5365 with SMTP id bc18-20020a056402205200b0046b5dcf5365mr33369699edb.157.1670385278600;
        Tue, 06 Dec 2022 19:54:38 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 07/12] io_uring: use tw for putting rsrc
Date:   Wed,  7 Dec 2022 03:53:32 +0000
Message-Id: <cbba5d53a11ee6fc2194dacea262c1d733c8b529.1670384893.git.asml.silence@gmail.com>
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

Use task_work for completing rsrc removals, it'll be needed later for
spinlock optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  1 +
 io_uring/rsrc.c                | 19 +++++++++++++++++--
 io_uring/rsrc.h                |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6be1e1359c89..dcd8a563ab52 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -328,6 +328,7 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*buf_data;
 
 	struct delayed_work		rsrc_put_work;
+	struct callback_head		rsrc_put_tw;
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 52ea83f241c6..3a422a7b7132 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -326,6 +326,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	init_task_work(&ctx->rsrc_put_tw, io_rsrc_put_tw);
 	init_llist_head(&ctx->rsrc_put_llist);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d25309400a45..18de10c68a15 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -204,6 +204,14 @@ void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
+void io_rsrc_put_tw(struct callback_head *cb)
+{
+	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
+					       rsrc_put_tw);
+
+	io_rsrc_put_work(&ctx->rsrc_put_work.work);
+}
+
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (data && !atomic_dec_and_test(&data->refs))
@@ -242,8 +250,15 @@ static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
-	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	if (!first_add)
+		return;
+
+	if (ctx->submitter_task) {
+		if (!task_work_add(ctx->submitter_task, &ctx->rsrc_put_tw,
+				   ctx->notify_method))
+			return;
+	}
+	mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(void)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 81445a477622..2b8743645efc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -53,6 +53,7 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[];
 };
 
+void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
-- 
2.38.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0309C5727F1
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 22:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiGLUyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 16:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiGLUxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 16:53:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0866D0E15;
        Tue, 12 Jul 2022 13:53:26 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f2so12810162wrr.6;
        Tue, 12 Jul 2022 13:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vE3qFQ8ddlENz32QVzcPsvY6xTeH/TIslKWkfAbKxUg=;
        b=Uro7tQbm/+uYzh7ZSgzm9Ae9KYWXN0i1e5qvUPuLNSpyLqman93RwXJ8tsx4LvAp3a
         ObsNOgUN4toJoeFFiqxnylasNI72+cLMXjZSFnzGjASIufcRVLENsB1UUzwHrQ4dDpwV
         u0mOY4RgdwH1X6VO18JoxLIeAPMJELNemuNq3Xpfq4rd+VSwasnvKlrClDWaZ0OBwpii
         rdfhyn5SUFFLslukhiaF0cLeuyzHqoFpvhp2WAXGcd1QjmmURHvHzKxKEhbmAvXnVEZ9
         A3P8GtEB48LQH6H/n3Gi6oTQAzSSRV5Pqs7zUv83UnKMDsgIv6dN+MS6zNKYOy9Bz/BL
         Aq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vE3qFQ8ddlENz32QVzcPsvY6xTeH/TIslKWkfAbKxUg=;
        b=m1oeHXOwoBLYLljAFuvXFAcbl5NPxfIPdLECuRfQtiG6LnD7gvcGH5LkH+XMywqRqe
         nyduTqY1qsnNsK+mi891Gr3VTxycWdAEfbUdYcoIxCkPAff/Ni9HwMFPjujtIa/5kfou
         kAICwOIapRi4X0BdlCG49MNk5xMz/NodJbNt0/km9LLCgkLWfXeMriFEes0LmOcwy35H
         zsBj1dOwAYb21EYrNfQ+0Ryv8YHQXKZJkpJkAKnRu7mY+v0w+nRYYiSSA1ga9/JK5RRF
         EhitYPoHxoISrRykR8+wYnOhe4wT6T98vObbQohQb2zv2/zgUPN0yMug5rW/PfaZnivz
         kryw==
X-Gm-Message-State: AJIora8yQmEzBijhCkfPoR9KleXYARA8DQXndnu+0X1/aNKRQWf8u+Gx
        QrV8HG3BcM6vbWL4brOWviMJlQCcBHw=
X-Google-Smtp-Source: AGRyM1vmcTiRUiaTt7Z8+3CF2mqaXewDfFH5/VL59cyKWbiOxMKKJDKFhtm2JOBe2FOgJMPUXH1mCQ==
X-Received: by 2002:a5d:6d8a:0:b0:21d:a6f3:f458 with SMTP id l10-20020a5d6d8a000000b0021da6f3f458mr11509671wrs.574.1657659204209;
        Tue, 12 Jul 2022 13:53:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 14/27] io_uring: add zc notification infrastructure
Date:   Tue, 12 Jul 2022 21:52:38 +0100
Message-Id: <3ecf54c31a85762bf679b0a432c9f43ecf7e61cc.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

Add internal part of send zerocopy notifications. There are two main
structures, the first one is struct io_notif, which carries inside
struct ubuf_info and maps 1:1 to it. io_uring will be binding a number
of zerocopy send requests to it and ask to complete (aka flush) it. When
flushed and all attached requests and skbs complete, it'll generate one
and only one CQE. There are intended to be passed into the network layer
as struct msghdr::msg_ubuf.

The second concept is notification slots. The userspace will be able to
register an array of slots and subsequently addressing them by the index
in the array. Slots are independent of each other. Each slot can have
only one notifier at a time (called active notifier) but many notifiers
during the lifetime. When active, a notifier not going to post any
completion but the userspace can attach requests to it by specifying
the corresponding slot while issueing send zc requests. Eventually, the
userspace will want to "flush" the notifier losing any way to attach
new requests to it, however it can use the next atomatically added
notifier of this slot or of any other slot.

When the network layer is done with all enqueued skbs attached to a
notifier and doesn't need the specified in them user data, the flushed
notifier will post a CQE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |   5 ++
 io_uring/Makefile              |   2 +-
 io_uring/io_uring.c            |   8 ++-
 io_uring/io_uring.h            |   2 +
 io_uring/notif.c               | 102 +++++++++++++++++++++++++++++++++
 io_uring/notif.h               |  64 +++++++++++++++++++++
 6 files changed, 179 insertions(+), 4 deletions(-)
 create mode 100644 io_uring/notif.c
 create mode 100644 io_uring/notif.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d876a0367081..95334e678586 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -34,6 +34,9 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
 
+struct io_notif;
+struct io_notif_slot;
+
 struct io_hash_bucket {
 	spinlock_t		lock;
 	struct hlist_head	list;
@@ -232,6 +235,8 @@ struct io_ring_ctx {
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
 		struct io_mapped_ubuf	**user_bufs;
+		struct io_notif_slot	*notif_slots;
+		unsigned		nr_notif_slots;
 
 		struct io_submit_state	submit_state;
 
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 466639c289be..8cc8e5387a75 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bb644b1b575a..ad816afe2345 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -89,6 +89,7 @@
 #include "kbuf.h"
 #include "rsrc.h"
 #include "cancel.h"
+#include "notif.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -726,9 +727,8 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
 	return &rings->cqes[off];
 }
 
-static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
-			    u64 user_data, s32 res, u32 cflags,
-			    bool allow_overflow)
+bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
+		     bool allow_overflow)
 {
 	struct io_uring_cqe *cqe;
 
@@ -2496,6 +2496,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
+	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
@@ -2672,6 +2673,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
+	io_notif_unregister(ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* failed during ring init, it couldn't have issued any requests */
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2379d9e70c10..b8c858727dc8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -33,6 +33,8 @@ void io_req_complete_post(struct io_kiocb *req);
 void __io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
 		     bool allow_overflow);
+bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
+		     bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
diff --git a/io_uring/notif.c b/io_uring/notif.c
new file mode 100644
index 000000000000..6ee948af6a49
--- /dev/null
+++ b/io_uring/notif.c
@@ -0,0 +1,102 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/net.h>
+#include <linux/io_uring.h>
+
+#include "io_uring.h"
+#include "notif.h"
+
+static void __io_notif_complete_tw(struct callback_head *cb)
+{
+	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
+	struct io_ring_ctx *ctx = notif->ctx;
+
+	io_cq_lock(ctx);
+	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq, true);
+	io_cq_unlock_post(ctx);
+
+	percpu_ref_put(&ctx->refs);
+	kfree(notif);
+}
+
+static inline void io_notif_complete(struct io_notif *notif)
+{
+	__io_notif_complete_tw(&notif->task_work);
+}
+
+static void io_notif_complete_wq(struct work_struct *work)
+{
+	struct io_notif *notif = container_of(work, struct io_notif, commit_work);
+
+	io_notif_complete(notif);
+}
+
+static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
+					  struct ubuf_info *uarg,
+					  bool success)
+{
+	struct io_notif *notif = container_of(uarg, struct io_notif, uarg);
+
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+	INIT_WORK(&notif->commit_work, io_notif_complete_wq);
+	queue_work(system_unbound_wq, &notif->commit_work);
+}
+
+struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
+				struct io_notif_slot *slot)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_notif *notif;
+
+	notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!notif)
+		return NULL;
+
+	notif->seq = slot->seq++;
+	notif->tag = slot->tag;
+	notif->ctx = ctx;
+	notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	notif->uarg.callback = io_uring_tx_zerocopy_callback;
+	/* master ref owned by io_notif_slot, will be dropped on flush */
+	refcount_set(&notif->uarg.refcnt, 1);
+	percpu_ref_get(&ctx->refs);
+	return notif;
+}
+
+static void io_notif_slot_flush(struct io_notif_slot *slot)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_notif *notif = slot->notif;
+
+	slot->notif = NULL;
+
+	if (WARN_ON_ONCE(in_interrupt()))
+		return;
+	/* drop slot's master ref */
+	if (refcount_dec_and_test(&notif->uarg.refcnt))
+		io_notif_complete(notif);
+}
+
+__cold int io_notif_unregister(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	int i;
+
+	if (!ctx->notif_slots)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->nr_notif_slots; i++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[i];
+
+		if (slot->notif)
+			io_notif_slot_flush(slot);
+	}
+
+	kvfree(ctx->notif_slots);
+	ctx->notif_slots = NULL;
+	ctx->nr_notif_slots = 0;
+	return 0;
+}
\ No newline at end of file
diff --git a/io_uring/notif.h b/io_uring/notif.h
new file mode 100644
index 000000000000..3d7a1d242e17
--- /dev/null
+++ b/io_uring/notif.h
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/net.h>
+#include <linux/uio.h>
+#include <net/sock.h>
+#include <linux/nospec.h>
+
+struct io_notif {
+	struct ubuf_info	uarg;
+	struct io_ring_ctx	*ctx;
+
+	/* cqe->user_data, io_notif_slot::tag if not overridden */
+	u64			tag;
+	/* see struct io_notif_slot::seq */
+	u32			seq;
+
+	union {
+		struct callback_head	task_work;
+		struct work_struct	commit_work;
+	};
+};
+
+struct io_notif_slot {
+	/*
+	 * Current/active notifier. A slot holds only one active notifier at a
+	 * time and keeps one reference to it. Flush releases the reference and
+	 * lazily replaces it with a new notifier.
+	 */
+	struct io_notif		*notif;
+
+	/*
+	 * Default ->user_data for this slot notifiers CQEs
+	 */
+	u64			tag;
+	/*
+	 * Notifiers of a slot live in generations, we create a new notifier
+	 * only after flushing the previous one. Track the sequential number
+	 * for all notifiers and copy it into notifiers's cqe->cflags
+	 */
+	u32			seq;
+};
+
+int io_notif_unregister(struct io_ring_ctx *ctx);
+
+struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
+				struct io_notif_slot *slot);
+
+static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
+					    struct io_notif_slot *slot)
+{
+	if (!slot->notif)
+		slot->notif = io_alloc_notif(ctx, slot);
+	return slot->notif;
+}
+
+static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
+						      int idx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (idx >= ctx->nr_notif_slots)
+		return NULL;
+	idx = array_index_nospec(idx, ctx->nr_notif_slots);
+	return &ctx->notif_slots[idx];
+}
-- 
2.37.0


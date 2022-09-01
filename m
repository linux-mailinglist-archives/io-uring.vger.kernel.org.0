Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAFA5A953A
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiIAK6x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiIAK6i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36029A74FE
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u9so33875297ejy.5
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=PzkNuQUSc1+HiVvJqmmOCpkLUxKhP+pE+W3mIOGQ47M=;
        b=UNIDHPOoNZWbvUPoWtG3mgbUmT/lAZ7aVWS5QEZexFQOhBh/TO/hNO2fuHSesaqcpZ
         5E8UgzveBL4SZvtLpUNloW32zi88DjbTLJt/KIFHcceVJQGNsV3gI7KR3GYOFo6t47jl
         GOPxRcZZraDD36o/RrST+27L1fPGGjL0UKrvTQTFZZeDE7AMGum1bOoRcJt9kP5C0OFU
         X0k825L14tUxfgIIxASQ91GK5mamlltlRM64s0VkqsPbBWMTavym/qJTkIzl2e29K3sT
         RE8gJxfqtQYgVxDWMgn1tAVU/f3VGtb4Gyxwj1VuC0S1nwi589G2w38NrHBXqkzOq1N9
         +EXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PzkNuQUSc1+HiVvJqmmOCpkLUxKhP+pE+W3mIOGQ47M=;
        b=3mR9m0l3A5k9VIBb8eMG4xaz6Wmr+2C1R2kWVm5mpMEeZYdQlv/PZ/KDdQ7ud4/l+7
         w7QwhBRWrUnydgDPz1ygtR7GcOdTXnLP6S2ajzgepCp6Lgdxn3iCfSaaeNcgcfVX0z/0
         Su2mmYv438ypG8HpCKDtlOv9qagRp11OjTNtCyzzY1iApCsCWFiMRt+YolCDDd5osG0w
         LtywCGjXbFN5oT0aSupobU4i9kv1Kao1duDLFj+rakN4+9F0Pz7y62Rd7UkXyr6jMDJW
         Ccwsgb9uHYZ4SPeoiXGOO7plhZOT+bIHmLopMEicaRjZBEnZE+fbw043p0nWd1k5vAY9
         bN8Q==
X-Gm-Message-State: ACgBeo2CB8yLa8C4yX7JZVyoxvpu1TISY51v9v4lsPXLfyVWb1UcIr3b
        6XgwHCyGIpQDJrLYSGEo6Vf8wdC2wk4=
X-Google-Smtp-Source: AA6agR5PVSZ204SwAemiLFYe09jCQ3X3j1H74O7CF6HbZoyL19GCxSp3GFXTViE4KKrEkJq7SsPXfQ==
X-Received: by 2002:a17:906:4794:b0:742:a5b2:546d with SMTP id cw20-20020a170906479400b00742a5b2546dmr4654356ejc.158.1662029915323;
        Thu, 01 Sep 2022 03:58:35 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 4/6] io_uring/notif: remove notif registration
Date:   Thu,  1 Sep 2022 11:54:03 +0100
Message-Id: <6ff00b97be99869c386958a990593c9c31cf105b.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
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

We're going to remove the userspace exposed zerocopy notification API,
remove notification registration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  8 ----
 io_uring/io_uring.c           | 10 -----
 io_uring/net.c                |  4 +-
 io_uring/notif.c              | 71 -----------------------------------
 io_uring/notif.h              | 11 ------
 5 files changed, 1 insertion(+), 103 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 111b651366bd..b11c57b0ebb5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -279,14 +279,10 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
  *				the buf_index field.
- *
- * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
- *				successful. Only for zerocopy sends.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
-#define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
 
 /*
  * accept flags stored in sqe->ioprio
@@ -474,10 +470,6 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
-	/* zerocopy notification API */
-	IORING_REGISTER_NOTIFIERS		= 26,
-	IORING_UNREGISTER_NOTIFIERS		= 27,
-
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 77616279000b..c2e06a3aa18d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2640,7 +2640,6 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
-	io_notif_unregister(ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* failed during ring init, it couldn't have issued any requests */
@@ -3839,15 +3838,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
-	case IORING_REGISTER_NOTIFIERS:
-		ret = io_notif_register(ctx, arg, nr_args);
-		break;
-	case IORING_UNREGISTER_NOTIFIERS:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_notif_unregister(ctx);
-		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/net.c b/io_uring/net.c
index 7a5468cc905e..aac6997b7d88 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -889,7 +889,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
+			  IORING_RECVSEND_FIXED_BUF))
 		return -EINVAL;
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
@@ -1063,8 +1063,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
-	} else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
-		io_notif_slot_flush_submit(notif_slot, 0);
 	}
 
 	if (ret >= 0)
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 96f076b175e0..11f45640684a 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -86,74 +86,3 @@ void io_notif_slot_flush(struct io_notif_slot *slot)
 		io_req_task_work_add(notif);
 	}
 }
-
-__cold int io_notif_unregister(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	int i;
-
-	if (!ctx->notif_slots)
-		return -ENXIO;
-
-	for (i = 0; i < ctx->nr_notif_slots; i++) {
-		struct io_notif_slot *slot = &ctx->notif_slots[i];
-		struct io_kiocb *notif = slot->notif;
-		struct io_notif_data *nd;
-
-		if (!notif)
-			continue;
-		nd = io_notif_to_data(notif);
-		slot->notif = NULL;
-		if (!refcount_dec_and_test(&nd->uarg.refcnt))
-			continue;
-		notif->io_task_work.func = __io_notif_complete_tw;
-		io_req_task_work_add(notif);
-	}
-
-	kvfree(ctx->notif_slots);
-	ctx->notif_slots = NULL;
-	ctx->nr_notif_slots = 0;
-	return 0;
-}
-
-__cold int io_notif_register(struct io_ring_ctx *ctx,
-			     void __user *arg, unsigned int size)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_uring_notification_slot __user *slots;
-	struct io_uring_notification_slot slot;
-	struct io_uring_notification_register reg;
-	unsigned i;
-
-	if (ctx->nr_notif_slots)
-		return -EBUSY;
-	if (size != sizeof(reg))
-		return -EINVAL;
-	if (copy_from_user(&reg, arg, sizeof(reg)))
-		return -EFAULT;
-	if (!reg.nr_slots || reg.nr_slots > IORING_MAX_NOTIF_SLOTS)
-		return -EINVAL;
-	if (reg.resv || reg.resv2 || reg.resv3)
-		return -EINVAL;
-
-	slots = u64_to_user_ptr(reg.data);
-	ctx->notif_slots = kvcalloc(reg.nr_slots, sizeof(ctx->notif_slots[0]),
-				GFP_KERNEL_ACCOUNT);
-	if (!ctx->notif_slots)
-		return -ENOMEM;
-
-	for (i = 0; i < reg.nr_slots; i++, ctx->nr_notif_slots++) {
-		struct io_notif_slot *notif_slot = &ctx->notif_slots[i];
-
-		if (copy_from_user(&slot, &slots[i], sizeof(slot))) {
-			io_notif_unregister(ctx);
-			return -EFAULT;
-		}
-		if (slot.resv[0] | slot.resv[1] | slot.resv[2]) {
-			io_notif_unregister(ctx);
-			return -EINVAL;
-		}
-		notif_slot->tag = slot.tag;
-	}
-	return 0;
-}
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 80f6445e0c2b..8380eeff2f2e 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -8,7 +8,6 @@
 #include "rsrc.h"
 
 #define IO_NOTIF_SPLICE_BATCH	32
-#define IORING_MAX_NOTIF_SLOTS	(1U << 15)
 
 struct io_notif_data {
 	struct file		*file;
@@ -36,10 +35,6 @@ struct io_notif_slot {
 	u32			seq;
 };
 
-int io_notif_register(struct io_ring_ctx *ctx,
-		      void __user *arg, unsigned int size);
-int io_notif_unregister(struct io_ring_ctx *ctx);
-
 void io_notif_slot_flush(struct io_notif_slot *slot);
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
@@ -67,12 +62,6 @@ static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
 	return &ctx->notif_slots[idx];
 }
 
-static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
-					      unsigned int issue_flags)
-{
-	io_notif_slot_flush(slot);
-}
-
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
 	struct io_ring_ctx *ctx = notif->ctx;
-- 
2.37.2


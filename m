Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF906D60F7
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjDDMlC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjDDMk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4C1195;
        Tue,  4 Apr 2023 05:40:54 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id er13so89026783edb.9;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjQOCF2m5FEa29JFzTi+p7tq3jGoDrTcPjGyMCsupCY=;
        b=EBSA+3FSAf2l0JlcdciCq2q1iDCL5Fj9iJsuAytH19HB+lDwtMeCWQJbjez84ctk8e
         cL8RFWEaRknf2qPJnJ3mS866NUVCdPzTF79WEzjQq9Bg2psWDV6P3vlXgftoMpRhrYJG
         Pym+m7uEycWCVDjvJ71mHste7SR/zMPE2EZifzMYJMrq14ViFjn5ukgQgccGL68nAdgO
         tt5Z1TEjDuXxPnTvrjwDODfP3mGtv8vgGgn5FUlhy/Sh+HEcT7RO56VoTQRFxtpVSTfd
         8gfcY8mlesRSTpb7EO501tUVnelH73/lRsss0nP3T14gUxmAQ3fJhOOZIM5qD4cAY0Ad
         tksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjQOCF2m5FEa29JFzTi+p7tq3jGoDrTcPjGyMCsupCY=;
        b=SZ5vQX7x0Vh9BMFKgmCuVJIqiPK97VhYl6zfxtkdVzG2iTzq5PFEQaiE/nqHp3zLKJ
         6WRHKJK+GVO0LbowJ/T3XM73rcsQ50XNvl2ck7lgOECL/3k+TxWJnV8NQradUN6vW5Nu
         GA2XXijjS7O0WLchoXeUgq0C6arHuLIk0VM3rFCmA+ZhY5ZA+IicnD+bQFRvHd8YJ5YI
         LesJ/FS1k9YVIODhzhmO2cRRG6jJ4tPJyEKobI7lDbpi0V1VyiyhNs5pMRY8PrW5ASQY
         kz0OLGOiepueJqPez3vJkiSjiSWN8jesR/vxVLYaJTMopzmZxicL/0vlma9zn0eKtxxE
         2obg==
X-Gm-Message-State: AAQBX9elgQvDrkwyP4Tm8aH0FqB2aCHCCCnKvyWDqft94ZOrqmqcEfxX
        JMPniDmWmS735DKaC5qpkAP82Wle6Z8=
X-Google-Smtp-Source: AKy350at0lNxTXxovSbhn5SdrJ8NSNawSPbTAfTmXnSpHMMqhitx6YtbuScJPMliFWPD1oLoOG2Llw==
X-Received: by 2002:a17:906:95ca:b0:931:4f2c:4e83 with SMTP id n10-20020a17090695ca00b009314f2c4e83mr2479643ejy.63.1680612053938;
        Tue, 04 Apr 2023 05:40:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/13] io_uring/rsrc: kill rsrc_ref_lock
Date:   Tue,  4 Apr 2023 13:39:50 +0100
Message-Id: <6b60af883c263551190b526a55ff2c9d5ae07141.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use ->rsrc_ref_lock spinlock to protect ->rsrc_ref_list in
io_rsrc_node_ref_zero(). Now we removed pcpu refcounting, which means
io_rsrc_node_ref_zero() is not executed from the irq context as an RCU
callback anymore, and we also put it under ->uring_lock.
io_rsrc_node_switch(), which queues up nodes into the list, is also
protected by ->uring_lock, so we can safely get rid of ->rsrc_ref_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 2 +-
 io_uring/io_uring.c            | 1 -
 io_uring/rsrc.c                | 5 -----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a0a5b5964d3a..9492889f00c0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -333,8 +333,8 @@ struct io_ring_ctx {
 	struct delayed_work		rsrc_put_work;
 	struct callback_head		rsrc_put_tw;
 	struct llist_head		rsrc_put_llist;
+	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
-	spinlock_t			rsrc_ref_lock;
 
 	struct list_head		io_buffers_pages;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 36a76c7b34f0..764df5694d73 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -325,7 +325,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
-	spin_lock_init(&ctx->rsrc_ref_lock);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_task_work(&ctx->rsrc_put_tw, io_rsrc_put_tw);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 89e43e59b490..f3493b9d2bbb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -209,11 +209,9 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 	__must_hold(&node->rsrc_data->ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
-	unsigned long flags;
 	bool first_add = false;
 	unsigned long delay = HZ;
 
-	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
 	/* if we are mid-quiesce then do not delay */
@@ -229,7 +227,6 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 		list_del(&node->node);
 		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (!first_add)
 		return;
@@ -268,9 +265,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
 		rsrc_node->rsrc_data = data_to_kill;
-		spin_lock_irq(&ctx->rsrc_ref_lock);
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
 		/* put master ref */
-- 
2.39.1


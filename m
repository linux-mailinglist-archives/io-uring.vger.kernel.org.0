Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693526D08DF
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjC3O4v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjC3Oyt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73B0BB9C;
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v1so19392652wrv.1;
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBkviYTvQX5do4saoK2KG74OjTaM9gN+C198bVZ0XcA=;
        b=WSAv013ms1/pzIyLkw4lGdHYzlytBUueBGnxq6JYDswxuiARTBXPhRIzJsx4xnCirS
         BrpknhFxgFsE0H934q/yLcThuaSk/4aeQzNY0hAhrsb2ypDepJWq5GY+/wzLnL1ClZm0
         0xFdYpHaUR4wliz/kwKKHYVIG1rSwxeqLZvMqALYupXguyvhu7mG6JzhaKKWMhqndtPV
         2PjRLKYSW7SUYwbQYioG+TZykNnTM1BEnf3KXpDF5iCULV/gnj/NZRIljXHOGXYM3J2q
         Mh8OX2Yzg1pQOLdanyhPELplfN7+8S6v48lq4AjvHAN5dP75Fgw5ObTHUStaekbadlOS
         RZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBkviYTvQX5do4saoK2KG74OjTaM9gN+C198bVZ0XcA=;
        b=e5hA1kSikkRTU+dQFFvvmAOO2Dzk11V2EJXhHSx27SgODyqsE9VAJ9UQFUuNM5/ONc
         5EPn51WvvgA6mLlbeaiCiNkf5ygubBMZK3fE1l+jL2Bj08R8BC79pyBg2X4olKY4ldz1
         JOVv/YOZ7qhwpG4niat+OhW5a08RympMJGQny06na+Odxm9hpWFdg+SgxNrSV2VM2+TV
         LCgULuqQUGsyxVDCv5xt9KMKLijdWSzrODT0kGG+iTrSRwP/DuSVaUrVRMGfCisF8L0C
         z1w9TPy3R3dFkorIlTizsmWXv9IdV4EvAbDmLiQG9jKAx1P0ubWrROS8MrcR/spWJ54+
         oMwA==
X-Gm-Message-State: AAQBX9elmaqalEb+XrZ9VAL83ekD989AqtMwEOsUMCKQjttCzco3WMLQ
        W8kDLJv6trRTp7IIQlS/K5zSYbsgFBA=
X-Google-Smtp-Source: AKy350bxHT4LZAk9AhO30h16NHSllIGRMDFqNeCz8YcyZDaG+5ho6qaiJlPfNfkg+sTT5t0PFqMJLg==
X-Received: by 2002:a5d:404c:0:b0:2e5:1ee3:df77 with SMTP id w12-20020a5d404c000000b002e51ee3df77mr1142541wrp.46.1680188081160;
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] io_uring/rsrc: kill rsrc_ref_lock
Date:   Thu, 30 Mar 2023 15:53:24 +0100
Message-Id: <80e76722fb1317d5315528b8b57de559ca5aea33.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
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
index e55c48d91209..e94780c0a024 100644
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
index 1237fc77c250..e122b6e5f9c5 100644
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


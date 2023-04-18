Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872BF6E6560
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjDRNHZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662A44AE
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id q23so63535151ejz.3
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10fQcA/svKRuqZd5Nyyvu/RW0+SRmiK1DY7rrVIZsO4=;
        b=X0qGmNBggWzQ4LQMFozaQ5KqUsvi5MLSa6kqGYWI719qx58UPWEu07u/73mT9ZmyhF
         25PfouX39T2tVzkcprYNsR+oPLUrTYgKkfeyRd2GxLmOlcJJmzyKfhIj1ItxItGfz/Rb
         uqWJ/5VW26U6OlhbHjCC1E7z9xU6oI7F7IxMFpLu6Outqw7I5ZFa0H7RPMFwjkSIlvQP
         LfX2ta0wHTjKmeQzWUNiMAwdaULw55LMbms3YQwXLH3alcOdN2kV/vKlhlt/3uvZVmvt
         ou0wc/230XEwxDdoQWKMcgH5oyOgMxP/TV/9oVv8culqYw877gdHKEug5LWKC/d25GuR
         lUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10fQcA/svKRuqZd5Nyyvu/RW0+SRmiK1DY7rrVIZsO4=;
        b=g1pVEkp7GxsmFBHzp4Q2FbQXTSAvu8fijldIaCNfaxPL1tw1m645gyVVQIzz5fZdP4
         b3DUfFZ5MX1Tb+2CxtnqY0vdGXYRz7yUp/vTWrU/gOoaYmnnaB9ZYXg5uzecLKA4H6x/
         VOdMjoGC/t3RyvkzpX8Vf5Q5FECwtHaFPx10be0Fkcp+UgybTcQsu88w1T9S6Ft3CSsZ
         P+oCaYyfRoJR9ORzhPScy84t5lKgz2zpn820zCl8kSEutMuec0De9oRnxhz+lBJuHwo2
         Vm/AjGNHxYPkv6WP1DRXN3SBw4rva/CDyHRz19l630+JFqUb1B4Xh1bru+QlQUWLLyMc
         ZIcQ==
X-Gm-Message-State: AAQBX9eoQ+fYJk2iuiLdOt8+Pu6dirAUIDjMDSRnG3xHQvYStucZOnIH
        NN8/hTwFQ5ocNioZSywL/dLeNwAjr7Y=
X-Google-Smtp-Source: AKy350YLierP5/0sJYx1t2kL/hDADM7B1fEfuOuzuYjBv8fJK/yTaGYbLwXMAz5znXPyQxhNUYWLPQ==
X-Received: by 2002:a17:906:d047:b0:94e:116:8581 with SMTP id bo7-20020a170906d04700b0094e01168581mr11179134ejb.5.1681823230632;
        Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/8] io_uring/rsrc: inline io_rsrc_put_work()
Date:   Tue, 18 Apr 2023 14:06:38 +0100
Message-Id: <1b36dd46766ced39a9b160767babfa2fce07b8f8.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
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

io_rsrc_put_work() is simple enough to be open coded into its only
caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 19 ++++++-------------
 io_uring/rsrc.h |  1 -
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 127bd602131e..d1167b0643b7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -140,8 +140,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
-static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
-				 struct io_rsrc_put *prsrc)
+static void io_rsrc_put_work(struct io_rsrc_data *rsrc_data,
+			     struct io_rsrc_put *prsrc)
 {
 	struct io_ring_ctx *ctx = rsrc_data->ctx;
 
@@ -150,16 +150,6 @@ static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
 	rsrc_data->do_put(ctx, prsrc);
 }
 
-static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
-{
-	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
-
-	if (likely(!ref_node->empty))
-		io_rsrc_put_work_one(rsrc_data, &ref_node->item);
-
-	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
-}
-
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache))
@@ -178,7 +168,10 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 		if (node->refs)
 			break;
 		list_del(&node->node);
-		__io_rsrc_put_work(node);
+
+		if (likely(!node->empty))
+			io_rsrc_put_work(node->rsrc_data, &node->item);
+		io_rsrc_node_destroy(ctx, node);
 	}
 	if (list_empty(&ctx->rsrc_ref_list) && unlikely(ctx->rsrc_quiesce))
 		wake_up_all(&ctx->rsrc_quiesce_wq);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f3fe455c6c71..232079363f6a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -58,7 +58,6 @@ struct io_mapped_ubuf {
 
 void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
-void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc);
-- 
2.40.0


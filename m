Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1CB6D60FB
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjDDMlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjDDMk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40D135AC;
        Tue,  4 Apr 2023 05:40:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h8so130056090ede.8;
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgmgIweSfjINzgFXMjWSh8rgR6O7dvb7i4eqwTPbb1A=;
        b=CD/HtzQQLAjag/OQbDs6IryLQwHEpG9SXXXTqYvROafActLs1tDcaGlOMLU9KNHfjA
         lW2BTZI6EzPRmCopK0CB0uUDtOV4KbTRSyBMATh8KMVNYYmjPq2+Zspnl+40GCUDh1Lt
         0xtuaTH6wWSEGVy3Hq9SGkn6DO6L61SqTOUkMcBwwt1o152GRY6PyHU+bygxcOU51X9K
         vkvSvbz8ocmBdquouI+tU5gNKowH8aBZ29PdRaKarjt1LR2rj1tLUC+77umQ8WE9oU2h
         Fn1D3gh4lJUB2ALhTwVL8kEBQRHMINtIIlnOMSycxTkJ3ylHh586DaEjFM64WnqIYnA3
         1pKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rgmgIweSfjINzgFXMjWSh8rgR6O7dvb7i4eqwTPbb1A=;
        b=pFket0w3gF4CNf3iQ2K/Sntwob8nDNR5+D6ZdXaIaTQ245jhttpk/hS82r2FzwLMEc
         xx0c6EsLjzM5xtZ+pQHQ+krSSEYfjJvVsUjjacHlFJtb8Umf3UqSfO92n32O3jW+RNBd
         bLPExElJngz9Mq2Nrb1MajrT69OzGqeR3jvy69enTjZR+BJpvs7K9AAZhr6gm5dBc/YW
         ISotbmhpihbqQyklSOc09t2UEd3bJUKOLVvRkhbGfOgT6jZ70V3FyllkXZojH7X8ymYU
         G+s4vd7A+zKDKf9ekoXixfn01vAg9sYU/I8WXq+/X3TtX/yiRtKwyvI5KLt3zB4sRbsO
         bJbQ==
X-Gm-Message-State: AAQBX9eQFIsnkWIdbU5y3yX4UDeNMM/0gCS0eNlwH9twu+oi3BMnM7YB
        xRuqB3Y9FKFrqCEqV7MXJpiVBFtKOfw=
X-Google-Smtp-Source: AKy350YKPn9j9Gl5ivjqob/1BUD8637oTjk+dN0A70D7PaZIkofLP2KqFJnGvGcdMIdxoL2O6N+PAQ==
X-Received: by 2002:a17:907:988e:b0:947:bd54:cb8e with SMTP id ja14-20020a170907988e00b00947bd54cb8emr2478777ejc.10.1680612054982;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/13] io_uring/rsrc: optimise io_rsrc_put allocation
Date:   Tue,  4 Apr 2023 13:39:52 +0100
Message-Id: <c482c1c652c45c85ac52e67c974bc758a50fed5f.1680576071.git.asml.silence@gmail.com>
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

Every io_rsrc_node keeps a list of items to put, and all entries are
kmalloc()'ed. However, it's quite often to queue up only one entry per
node, so let's add an inline entry there to avoid extra allocations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 51 ++++++++++++++++++++++++++++++++-----------------
 io_uring/rsrc.h |  2 ++
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2378beecdc0a..9647c02be0dc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -140,26 +140,34 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
+static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
+				 struct io_rsrc_put *prsrc)
+{
+	struct io_ring_ctx *ctx = rsrc_data->ctx;
+
+	if (prsrc->tag) {
+		if (ctx->flags & IORING_SETUP_IOPOLL) {
+			mutex_lock(&ctx->uring_lock);
+			io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+			mutex_unlock(&ctx->uring_lock);
+		} else {
+			io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+		}
+	}
+	rsrc_data->do_put(ctx, prsrc);
+}
+
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
-	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
+	if (ref_node->inline_items)
+		io_rsrc_put_work_one(rsrc_data, &ref_node->item);
+
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->item_list, list) {
 		list_del(&prsrc->list);
-
-		if (prsrc->tag) {
-			if (ctx->flags & IORING_SETUP_IOPOLL) {
-				mutex_lock(&ctx->uring_lock);
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
-			}
-		}
-
-		rsrc_data->do_put(ctx, prsrc);
+		io_rsrc_put_work_one(rsrc_data, prsrc);
 		kfree(prsrc);
 	}
 
@@ -251,6 +259,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(void)
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->item_list);
 	ref_node->done = false;
+	ref_node->inline_items = 0;
 	return ref_node;
 }
 
@@ -729,15 +738,23 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 {
 	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
+	bool inline_item = true;
 
-	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
-	if (!prsrc)
-		return -ENOMEM;
+	if (!node->inline_items) {
+		prsrc = &node->item;
+		node->inline_items++;
+	} else {
+		prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
+		if (!prsrc)
+			return -ENOMEM;
+		inline_item = false;
+	}
 
 	prsrc->tag = *tag_slot;
 	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &node->item_list);
+	if (!inline_item)
+		list_add(&prsrc->list, &node->item_list);
 	return 0;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 509a5ea7eabf..11703082d125 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -49,6 +49,8 @@ struct io_rsrc_node {
 	 * came from the same table and so are of the same type.
 	 */
 	struct list_head		item_list;
+	struct io_rsrc_put		item;
+	int				inline_items;
 };
 
 struct io_mapped_ubuf {
-- 
2.39.1


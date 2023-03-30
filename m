Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0BE6D08CF
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjC3Oy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjC3Oyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:51 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE967CA33;
        Thu, 30 Mar 2023 07:54:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v1so19392779wrv.1;
        Thu, 30 Mar 2023 07:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5UqEuOCJJfrll2Bn9RfMOzzWqUksKYu3hj36bqt65g=;
        b=ZV3O1gZvzbcSV9N01nRjxEXlT1bE5bVrzuzGPkbJEMK3lyPmu8mkDZhDpCBqhkg0cR
         zdmioPHKXXP7kioj47w4vHRX96j5rdpk16up0OUTOvY2RCZjdHkaNzEWWIJF6ARNg82i
         YAw6u1a14YutSOwyhHtBqZSgX5fxgNcY31F1AZTVVPObhcJrRAzpw37Dd2s4JL05NlDM
         KQiSUc2kTw/LAP69o2xXedgkAQzeYVDRC4BfCcGi5+n8bmzrTT4OI+Xf/nZp1Rw6RCXh
         YrMKkwiuOU7BCd/MHcqtn1iT6Yq7hGSHRF0clJJhQ47vxc5rwx7aVSJMqEFlanWQg0JX
         r+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5UqEuOCJJfrll2Bn9RfMOzzWqUksKYu3hj36bqt65g=;
        b=rDVHcY8pTewPfeYwCp0x4IY7n+AXmSK2LfiqBiZmA4R7IOVjE+IjUp2JXnLP+F1ocD
         LiRFjZnxHt9ZOcw6qGgZyt4RoHgQzwlOIY79AbrW6HFu5gmPumIG5qrwUhyZXJSqKkPc
         Q40On2B6Ry6ytikQkMQy8zglir2EJxZVdDj/MQEy73hB+Thg8USPFUzgRUrIkvb4Ecup
         gY0xBhsXLmUdArcNi8vVQu8lVRuWxdZV0krI03a+Ms2f4O4Bi4lIJuZM4C7ZX5JZBtYz
         NFAlgpQ9qxSnxli8Un26aoTT+y9Y/558qrgN2GUVePf+WkPIJtczYuPHSflySEQIWnD0
         +xiA==
X-Gm-Message-State: AAQBX9dIkC2bNbGZkZoq5bOyyp7etffrO5rR+/FyQ5xa0rvGu0SG2vQW
        IKYjf8H0Bu9wims8vUJ6eHtMsABP7mQ=
X-Google-Smtp-Source: AKy350ZWndoACgthbhEEaxmyTm76K0EShpk6E2/GgEhGBrd0yM05B/swKX0ll08af/vfgf+V8SiRgQ==
X-Received: by 2002:adf:e552:0:b0:2d6:8d2d:5a7c with SMTP id z18-20020adfe552000000b002d68d2d5a7cmr18407231wrm.57.1680188083411;
        Thu, 30 Mar 2023 07:54:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] io_uring/rsrc: optimise io_rsrc_put allocation
Date:   Thu, 30 Mar 2023 15:53:26 +0100
Message-Id: <ca4a431ae9c57c06b026bdd01e7bca90488fbcf9.1680187408.git.asml.silence@gmail.com>
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

Every io_rsrc_node keeps a list of items to put, and all entries are
kmalloc()'ed. However, it's quite often to queue up only one entry per
node, so let's add an inline entry there to avoid extra allocations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 51 ++++++++++++++++++++++++++++++++-----------------
 io_uring/rsrc.h |  2 ++
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 10006fb169d2..95e71300bb35 100644
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
index c68846de031f..17293ab90f64 100644
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


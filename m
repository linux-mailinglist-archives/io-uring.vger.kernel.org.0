Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876FD6E0FFE
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjDMO27 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDMO26 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:28:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4848644B6
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e16so1100052wra.6
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396135; x=1683988135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6WVIjemP9BBMRHiCNa00K2kQtNxwSekoN4VHF7m2Es=;
        b=p9hEWXXAdSxrQH8/jjLISmB2eV26h3z+JomPdu3uoK2kHs0v2AmAmnBokLcMSqav9w
         9bzTycCJOOtUbvSlERI1KDdygYOo/dEwl5nuUVjmf/Z/RgjLN/z2X3RHOylPDUDF4G3S
         aehwLTgSkDzyMQOiZ4OmZMqCegnLtgiDqE3aG1aqDfzo02P8KfGLpGbwCWeBWwVBJzEM
         /ZkfYxP3BfXyZRenGi4B2/UG4WaxmryKxujuEbpVj0eYlz1mAdTjyfz+klK2KXgsTJZo
         P/3DeOPFpTzIOVCRuLWLcQGFCz5jxVNcf5c5QzXvN54vIM1L4r7r686o3ltDo+J5G12t
         D7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396135; x=1683988135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6WVIjemP9BBMRHiCNa00K2kQtNxwSekoN4VHF7m2Es=;
        b=Nmllot3F/x72DbkjY+Ez4tcHgZUmgCPpa8lK8dr6sbVkevB+OEYbXdyQJhR2furCu6
         4Wkr2D4/szG0vAJwyiGtgb9SeOBRIeCjsuStkgA48+zj5Frn+qTWJLCSiiJ0b9xgJ9zL
         /Ozwq0C20nqpmpu2aZHpwaZG4/QvWpYzwdYZnAY8aOW/pR69wd/2wrJtc29cpQIZD5by
         8puYOKc0+N+oCUDDWAbjeBXJLdUFrLGvwa3+BLIp3fu0MAWygmVJe+N7zbwRoc0otjD4
         CPTdfKoGg1L0x7qvOG7anxUI2r1Pbhdv83N+3hgj5qw9wUr+IhOraNEjiC3chwW8HsqZ
         v2qg==
X-Gm-Message-State: AAQBX9e3fBKyyHBvu3YvnGqHKij6hr2HzET5j611ScLa7pZxeBv1g2JN
        uFJ7GmJ927Lbqu+TZtxQ1ghzjkysX0w=
X-Google-Smtp-Source: AKy350bavVRt61KZOPXKH7++x1Oi6GQGRn5ghWzS6l/dOvnev3HjZ6qGpjR9bOa93sRz3JTirGKtSw==
X-Received: by 2002:a5d:6d4c:0:b0:2f2:a03f:6066 with SMTP id k12-20020a5d6d4c000000b002f2a03f6066mr1684408wri.56.1681396135520;
        Thu, 13 Apr 2023 07:28:55 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 02/10] io_uring/rsrc: remove io_rsrc_node::done
Date:   Thu, 13 Apr 2023 15:28:06 +0100
Message-Id: <bbde361f4010f7e8bf196f1ecca27a763b79926f.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
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

Kill io_rsrc_node::node and check refs instead, it's set when the nodes
refcount hits zero, and it won't change afterwards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +----
 io_uring/rsrc.h | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3c1538b8c8f4..5fc9d10743e0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -191,14 +191,12 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 {
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 
-	node->done = true;
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node = list_first_entry(&ctx->rsrc_ref_list,
 					    struct io_rsrc_node, node);
 		/* recycle ref nodes in order */
-		if (!node->done)
+		if (node->refs)
 			break;
-
 		list_del(&node->node);
 		__io_rsrc_put_work(node);
 	}
@@ -222,7 +220,6 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	ref_node->refs = 1;
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->item_list);
-	ref_node->done = false;
 	ref_node->inline_items = 0;
 	return ref_node;
 }
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 17dfe180208f..88adcb0b7963 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -48,7 +48,6 @@ struct io_rsrc_node {
 	struct list_head		node;
 	struct llist_node		llist;
 	int				refs;
-	bool				done;
 
 	/*
 	 * Keeps a list of struct io_rsrc_put to be completed. Each entry
-- 
2.40.0


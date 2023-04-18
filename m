Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F836E6563
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjDRNH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB240EC
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id q23so63535119ejz.3
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3s+aLd2VlnZ+D8NqSLeKDFBL4Pvzk/Q27FV4OleDAMY=;
        b=o7FaeMEc8/vveBiXyG4QC8am904TSKfSdwqYebxsookncx8UHViXCYpls1+seE+hLA
         0OQnyvXA3G9H5ARaLl9jE3B+Z1r7OLR5hDFlUEZtiJ4GmEl0Hb/0jaVDes/8/zD/E4hj
         F/76+7kXL+9cVLdubvGeXJ8SGihzcqWj6siRnZHcPO44CjIvrtCeJpoVbAQUkxXucoIv
         7dWGG45BU5lFbZCKIXW7B2tq7hL7CbD/R0BswNGCtdZzCOiGbdQAf3yV+rBUqPtbBh1l
         p+CnDDjrXXk85L+Pd0Q+TdTIePJ/R/c2xsMboRRc6Xystidm2HZX2t75uxPk+y7Ji3Qu
         Cu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3s+aLd2VlnZ+D8NqSLeKDFBL4Pvzk/Q27FV4OleDAMY=;
        b=HgEpEYevhL+FkkdLJ0eRB4f7YgHW1iaVf6ul9DTt5gC5+N0zdQd69HOmTPNvup3xUM
         WkJh6Ihm25T10+ZF3keLpf2lkLmP2eBgS8+1gFI3D9BmR46C5SZqxwuWt9g7z6//GzAA
         m83lmGnG7F9d1kuW5gV9y9wWOfpB+hMpNgzuCT+cIlsi1mnwE4Rry0MO6iuZpzXA9KYg
         zTiUUT2zcp9mnevZ0Efpxb6DY3B1awcWkYefDX4ZvWuHtjgr19FmW6I59BjluekLAMgZ
         63okGxobN+LOUFBjU44x9KoOyrFY16ePgwOMFtyHBeHiiwW6bx+2lFwRxBN7L6C9CGIt
         /log==
X-Gm-Message-State: AAQBX9fui1aI+WRxjSy8pCl1Talihs0lKr5HNRKmevmP8YvE7ZgYnsVw
        0lmGKYF+Zf16KnBKeuqUWua7HbrKnTE=
X-Google-Smtp-Source: AKy350azwT1ucW6TCwK7zBlCX97gXXS5g3ytpGRwNbjWAvToftlkmG4Z2bCNNfB5FS7MPdFVf9RbDw==
X-Received: by 2002:a17:906:e247:b0:947:d875:68f9 with SMTP id gq7-20020a170906e24700b00947d87568f9mr10520682ejb.0.1681823230257;
        Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/8] io_uring/rsrc: add empty flag in rsrc_node
Date:   Tue, 18 Apr 2023 14:06:37 +0100
Message-Id: <75d384c9d2252e12af73b9cf8a44e1699106aeb1.1681822823.git.asml.silence@gmail.com>
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

Unless a node was flushed by io_rsrc_ref_quiesce(), it'll carry a
resource. Replace ->inline_items with an empty flag, which is
initialised to false and only raised in io_rsrc_ref_quiesce().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 6 +++---
 io_uring/rsrc.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a54a222a20b8..127bd602131e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -154,7 +154,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
 
-	if (likely(ref_node->inline_items))
+	if (likely(!ref_node->empty))
 		io_rsrc_put_work_one(rsrc_data, &ref_node->item);
 
 	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
@@ -199,7 +199,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	}
 
 	ref_node->rsrc_data = NULL;
-	ref_node->inline_items = 0;
+	ref_node->empty = 0;
 	ref_node->refs = 1;
 	return ref_node;
 }
@@ -218,6 +218,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	backup = io_rsrc_node_alloc(ctx);
 	if (!backup)
 		return -ENOMEM;
+	ctx->rsrc_node->empty = true;
 	ctx->rsrc_node->rsrc_data = data;
 	list_add_tail(&ctx->rsrc_node->node, &ctx->rsrc_ref_list);
 	io_put_rsrc_node(ctx, ctx->rsrc_node);
@@ -649,7 +650,6 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc)
 
 	node->item.rsrc = rsrc;
 	node->item.tag = *tag_slot;
-	node->inline_items = 1;
 	*tag_slot = 0;
 
 	node->rsrc_data = data;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index bad7103f5033..f3fe455c6c71 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -43,7 +43,7 @@ struct io_rsrc_node {
 		struct io_rsrc_data		*rsrc_data;
 	};
 	int				refs;
-	int				inline_items;
+	bool				empty;
 	struct list_head		node;
 	struct io_rsrc_put		item;
 };
-- 
2.40.0


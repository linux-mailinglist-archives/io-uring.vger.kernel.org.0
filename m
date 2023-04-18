Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833246E6561
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjDRNH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131B37EE6
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id xi5so72986954ejb.13
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823231; x=1684415231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1l66WSVLYWxzDyQULvNJbJOAPLJVOshaBZARMBezD5U=;
        b=lD0GwjUvXBLIt2El6dB/S7zZaGnIhc9kw7a65nlGdvi7CzjP1CJnMuy/SUHXRtB9tq
         BEe5j6r3Y9c5Ctn66Tt12WMa04n2fXjxlE/6CM4qWrRd/3+ioo3bXVcyekjn67GdQdHv
         gPf2s7SKuy7vDkRNsDvVo1At8VRqHGgy2vBdGsLYKtGRAJCYPM6w/C/UsVdAio2ZNZxQ
         N1KwavPkqwq8C3LVOOq0ZP+OvCAsr5z7msMtm4u3UxT2Ab16OLqYJTe2rtXWQNecHbXH
         oUApQGMae8QwemUa0OJ44kNHVj4bdgQ33iZVysAAzLrH0GbUs89aHJOqL5WW6sFE4xw5
         6CaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823231; x=1684415231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1l66WSVLYWxzDyQULvNJbJOAPLJVOshaBZARMBezD5U=;
        b=MooxIwExzMIh7KVR89wgUzUhzAozyRaBeiyqnZxQyv2v0OMVn8rqWtHU8qlbm7RxpH
         D+2UzcJVDSCteM8WY80BbdeZVSIl226gc7BwjmxzWzqfKKVvsStc39Hgh/cR4oV0Cl7s
         SLevhq/amFEuOOk7s8Cvw9RDoHJX5rNsIX0FWdLXwNkjZKXCuhJikD7ycjx42m5O5lNc
         glDn/SQthYm3iuQo5I4be4swxaf1KqEp6ZAExRBuFm3pvjbKA3JZSIO55oqKk6H1Ozad
         WnSADyRm50GdiTfWRe8UQSrZixXHL3akjp1SIQ6kRl+iW8rS4czo17FQ7dJ8po2/pjNS
         6G7w==
X-Gm-Message-State: AAQBX9d5noXZMX8LFUE7/gHzfUyNptqazMUe4TMeIP3AhjbCRipz2eRB
        TrRLo6j1UFkJKgfiT0SxAHg0zhn68Gk=
X-Google-Smtp-Source: AKy350Y1vdawcu4ZjOb/xHjTJywvhlcZ5gRN/6z1sy1aB8Q/6QaCp8ZuVbZMKU5gq6bdbvgZTmL2dg==
X-Received: by 2002:a17:906:9153:b0:94e:e9c1:1932 with SMTP id y19-20020a170906915300b0094ee9c11932mr10655996ejw.43.1681823231188;
        Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/8] io_uring/rsrc: pass node to io_rsrc_put_work()
Date:   Tue, 18 Apr 2023 14:06:39 +0100
Message-Id: <791e8edd28d78797240b74d34e99facbaad62f3b.1681822823.git.asml.silence@gmail.com>
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

Instead of passing rsrc_data and a resource to io_rsrc_put_work() just
forward node, that's all the function needs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d1167b0643b7..9378691d49f5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -140,14 +140,14 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
-static void io_rsrc_put_work(struct io_rsrc_data *rsrc_data,
-			     struct io_rsrc_put *prsrc)
+static void io_rsrc_put_work(struct io_rsrc_node *node)
 {
-	struct io_ring_ctx *ctx = rsrc_data->ctx;
+	struct io_rsrc_data *data = node->rsrc_data;
+	struct io_rsrc_put *prsrc = &node->item;
 
 	if (prsrc->tag)
-		io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
-	rsrc_data->do_put(ctx, prsrc);
+		io_post_aux_cqe(data->ctx, prsrc->tag, 0, 0);
+	data->do_put(data->ctx, prsrc);
 }
 
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
@@ -170,7 +170,7 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 		list_del(&node->node);
 
 		if (likely(!node->empty))
-			io_rsrc_put_work(node->rsrc_data, &node->item);
+			io_rsrc_put_work(node);
 		io_rsrc_node_destroy(ctx, node);
 	}
 	if (list_empty(&ctx->rsrc_ref_list) && unlikely(ctx->rsrc_quiesce))
-- 
2.40.0


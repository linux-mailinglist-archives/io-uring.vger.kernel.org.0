Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67B06D6101
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbjDDMlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbjDDMlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:41:01 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBC31BCB;
        Tue,  4 Apr 2023 05:40:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eh3so129968552edb.11;
        Tue, 04 Apr 2023 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5A3CaykmQoi1hwmp2XQWbZMbgV4kSoJXYsNmB3sL+Q=;
        b=Va0857XBhN3i/RceyFvKAGG9NyTjeRMoHgviPepMFyhspMvR5xQoNdjq6JcHUjpf28
         WQmrGfLNDfk5aNTyPmbQ1sLVZGhlvo+ADJpX+iIE3O6ehr5J2yNyQU5893OVV4DQi8hF
         rFcfE41F0gzqJAhU996/e1mjAjhRr1n5g2vx1+BxZ4ujdJ/KY53hgLHA4lDJ+VL7Ut6G
         0xNd/CH48gL4nDYivWdMqoWtnvL177k+quPFndCTV+D7B4aLnueFijUrhaWLex01WNHw
         QeiLlRrJqZvD9ZSL2WPV5S6hxIFY2prUFEruWMLIb927Pk0jR+YrLAfjwha2BdGLplnL
         TgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5A3CaykmQoi1hwmp2XQWbZMbgV4kSoJXYsNmB3sL+Q=;
        b=CaMCg7fn7xofEyxK+zgKP0FW7wE7KyqVLW79LFK/Jn2Hw0Peh6yO9tT2LUqq0LbeIr
         2wPlxK83pbtK14PGrAyi0gCuiDDFteWLmQzAyS0Bgyori5ZpC5n+ztmJm+Pp4InYvfdY
         qTxqCPP8J54ilkTVve3Yu/6d3jRaiL6LJBEEFdVLq1bhXbvbOS6XExQeamCkdEgUKk7l
         yzGmlCdnJm9Sh/LpWihYnXN4O6DtDD6Vkpug/SznGCwjyVRtytu426aKLyBvgvZTJyOw
         hDp3s0a3+loT8odxw2kogYPyka6Be6qiGNLjEAXbOda0A9fSIiRit194rJ7parH2sCqY
         RnUQ==
X-Gm-Message-State: AAQBX9dXIjzBvhawCEyesThhj7ytYAZzPrm0xt9/GYWyhHXMZb2X+TFx
        l75rEibnUxlvu4x1g7RwvFc4iKZ6vyE=
X-Google-Smtp-Source: AKy350bcgGwgNQHvUCl9RKpAz/t63NcEYgt3QdivXcHIQ4llVt2OMza++p+KHQ6xZ5z8aSjREU8j3g==
X-Received: by 2002:a17:907:a04e:b0:931:f132:5c61 with SMTP id gz14-20020a170907a04e00b00931f1325c61mr2130933ejc.47.1680612057264;
        Tue, 04 Apr 2023 05:40:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/13] io_uring/rsrc: optimise io_rsrc_data refcounting
Date:   Tue,  4 Apr 2023 13:39:56 +0100
Message-Id: <e73c3d6820cf679532696d790b5b8fae23537213.1680576071.git.asml.silence@gmail.com>
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

Every struct io_rsrc_node takes a struct io_rsrc_data reference, which
means all rsrc updates do 2 extra atomics. Replace atomics refcounting
with a int as it's all done under ->uring_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 30 ++++++++++++++++++------------
 io_uring/rsrc.h |  2 +-
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 95edc5f73204..74e13230fa0c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -31,6 +31,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
+static inline bool io_put_rsrc_data_ref(struct io_rsrc_data *rsrc_data)
+{
+	return !--rsrc_data->refs;
+}
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -165,13 +170,13 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 	}
 
 	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
-	if (atomic_dec_and_test(&rsrc_data->refs))
+	if (io_put_rsrc_data_ref(rsrc_data))
 		complete(&rsrc_data->done);
 }
 
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
-	if (data && !atomic_dec_and_test(&data->refs))
+	if (data && !io_put_rsrc_data_ref(data))
 		wait_for_completion(&data->done);
 }
 
@@ -234,7 +239,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		rsrc_node->rsrc_data = data_to_kill;
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
 
-		atomic_inc(&data_to_kill->refs);
+		data_to_kill->refs++;
 		/* put master ref */
 		io_put_rsrc_node(ctx, rsrc_node);
 		ctx->rsrc_node = NULL;
@@ -267,8 +272,8 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		return ret;
 	io_rsrc_node_switch(ctx, data);
 
-	/* kill initial ref, already quiesced if zero */
-	if (atomic_dec_and_test(&data->refs))
+	/* kill initial ref */
+	if (io_put_rsrc_data_ref(data))
 		return 0;
 
 	data->quiesce = true;
@@ -276,17 +281,19 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	do {
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
-			atomic_inc(&data->refs);
-			/* wait for all works potentially completing data->done */
-			reinit_completion(&data->done);
 			mutex_lock(&ctx->uring_lock);
+			if (!data->refs) {
+				ret = 0;
+			} else {
+				/* restore the master reference */
+				data->refs++;
+			}
 			break;
 		}
-
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-			if (atomic_read(&data->refs) <= 0)
+			if (!data->refs)
 				break;
 			/*
 			 * it has been revived by another thread while
@@ -361,6 +368,7 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 	data->nr = nr;
 	data->ctx = ctx;
 	data->do_put = do_put;
+	data->refs = 1;
 	if (utags) {
 		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
@@ -371,8 +379,6 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 				goto fail;
 		}
 	}
-
-	atomic_set(&data->refs, 1);
 	init_completion(&data->done);
 	*pdata = data;
 	return 0;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cf24c3fd701f..7ab9b2b2e757 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -33,8 +33,8 @@ struct io_rsrc_data {
 	u64				**tags;
 	unsigned int			nr;
 	rsrc_put_fn			*do_put;
-	atomic_t			refs;
 	struct completion		done;
+	int				refs;
 	bool				quiesce;
 };
 
-- 
2.39.1


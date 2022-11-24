Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551DD637FC7
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiKXTr1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXTr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:47:26 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9201D8A151
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bs21so3848637wrb.4
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6I8Br2+O7AmZFlVUs2UTNZXMDiNht16mvQDsR+WjJXU=;
        b=Ns4aM/wilOgt8IAOF+qsfyaIaRvMXj7ozhX3/cN7fJIXyKbPuKFs7a1LkCdaTp3BUB
         8vYFB1AJLvImwuIiYCa9ZaQ0DV+UOMPv0JH00sItywmitDg7Yno9exi3Xvc0VCP+nUG1
         Qn+h6MwWo/vFnVTAjAamoVF4SLQRmJaKctViMTGN4Ilim4ySn5lq8ymojXxEC/zgd2zZ
         aE5tBaj7xcB28Oq4Zr2RG1NY/BdkdDZKvtohv0Hz8Aj5c6Ht9HxjlUQuyiTkJjlbK617
         7ljUcnw/kps9UQFzjj+hlgeL3zM0YtjNv90f887bxpbQFOvipC7PJumAjPzHP5xfNoYw
         WutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6I8Br2+O7AmZFlVUs2UTNZXMDiNht16mvQDsR+WjJXU=;
        b=ENpKjx7q6r0Dk0cSHEOVcBPQHuV600kqukKpiz3OyQEKEsxUtmWR8MpFCcxqXT5QGc
         MMOmwdbaYP7d8qRmAi1iQIX7Apq8RgipkZXb83UxBNzhw5zV48YULc/izYR+sJXjrJEZ
         8W5H/79XGbBsH3n+We0wxb7t5TGUoJ5BgfeMkdzuDgb1g0vrxwHjOLbdAKwhWaa6riHD
         EAkfnmaDWSN/9ZggBM3Uw9CkCiKBJM9IdgiCFl1wp8yOvtqRdKAjPsRVn7YS8w4WzQRl
         +KXZKQvDsK0/8CCNR3lswU/vU9mS9TRkWy1EJnUR954sMblV8E6lsqydz9ltuI+EwjyB
         Q+Cw==
X-Gm-Message-State: ANoB5pntvaSo1dk4jFjgCh6uVJrHSDEhdTz0zTF4GJNNS/FlnReadszf
        4ClYq91GZFdbztDfpUS9CN53d7Qkwp8=
X-Google-Smtp-Source: AA0mqf6dwQyP0aJ/reElz5rC0yoU2O2X9gd8aWadPpj3Ib/xNbXEGcsMiqiYmYKxZUfNiDJALuxDqw==
X-Received: by 2002:a05:6000:1c15:b0:241:d30c:62c4 with SMTP id ba21-20020a0560001c1500b00241d30c62c4mr13680080wrb.219.1669319244002;
        Thu, 24 Nov 2022 11:47:24 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id fn27-20020a05600c689b00b003cf75213bb9sm6999308wmb.8.2022.11.24.11.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 11:47:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/2] io_uring: keep unlock_post inlined in hot path
Date:   Thu, 24 Nov 2022 19:46:41 +0000
Message-Id: <372a16c485fca44c069be2e92fc5e7332a1d7fd7.1669310258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669310258.git.asml.silence@gmail.com>
References: <cover.1669310258.git.asml.silence@gmail.com>
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

This partially reverts

6c16fe3c16bdc ("io_uring: kill io_cqring_ev_posted() and __io_cq_unlock_post()")

The redundancy of __io_cq_unlock_post() was always to keep it inlined
into __io_submit_flush_completions(). Inline it back and rename with
hope of clarifying the intention behind it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 164904e7da25..e67bc906a9d0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -582,7 +582,8 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_flush_signal(ctx);
 }
 
-void io_cq_unlock_post(struct io_ring_ctx *ctx)
+/* keep it inlined for io_submit_flush_completions() */
+static inline void io_cq_unlock_post_inline(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
@@ -592,6 +593,12 @@ void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
+void io_cq_unlock_post(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_cq_unlock_post_inline(ctx);
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -1391,7 +1398,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		if (!(req->flags & REQ_F_CQE_SKIP))
 			__io_fill_cqe_req(ctx, req);
 	}
-	io_cq_unlock_post(ctx);
+	io_cq_unlock_post_inline(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.38.1


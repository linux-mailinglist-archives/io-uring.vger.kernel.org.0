Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBAF54B10B
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243679AbiFNMeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiFNMeZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:25 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D504B86F
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so4731124wme.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZkF0//vS8P5S/motkhyB8BSxXm8jA0xCFMYcO1lVP80=;
        b=FLSAmJFnXDo9VqrHKzAXTLRo+bBnC+/da/43PqD/IQ7wxuUdCHBR//NF3v++iYzUFH
         AxJt7ZPUuA7IWD5buKn1uLZj3eRg9KAWuuIo5C/+OrzMBdqHqXbjwahiko9DJ83/nOP2
         SkRNrb1sxfekN9lDUdRuBCoEIT4mdz8qhNHFiywY+5Hxd14CakRZAlfvEljOUOmTri7B
         xqM4viwH8zSFaN/z3QOyCbt2v/xoiQ2+3R0E8HQ+x3gZcx4/IYZdaM+n3cURavxSxA+2
         XY++quULOwfNFfT/TOL1Ca5TtthK9XlNuLJqXLMVxg+/0E46Cj1wHF+xtSsZ1N9b4Jql
         23zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZkF0//vS8P5S/motkhyB8BSxXm8jA0xCFMYcO1lVP80=;
        b=OCE4y47aFnsOwBwSWvoCdskLltmtvaawoKYCzUbzB3jEfd84ezJzqhieHqwv2hc5lP
         52q/MI/hI3K2dm3ktWUPJMxBW1wmOEuR7mD3Y4i2M1vA6nASgFfLjVd0mVhxP/lmPoaq
         aZr46ukLB1xMwlxVudJaOzbkrKEY2299X5RXkao1Ny/8BLjYiqIJqpkKFLSXqrhVLe0Y
         HY1MV7IRmuc2wh7eJTcCMrwoWeKQAAHYTxJCO+3EeJf6camdt7xnXv5YGi2j37bAwMZv
         OcjyFs9TJJDhTIaVsKvjrioxt4n5MxyLL9bASgcXetNfHnNCKyIaveMxPbWB6LDtOWNY
         wg9w==
X-Gm-Message-State: AOAM531Rr3KieqS99AiOazAdLKbWzUdaGloWYn7IyWlyh4vAVuqJPJwC
        iTUraF1V+HLYuDP+gAHMutqTfQdUOrzI3g==
X-Google-Smtp-Source: ABdhPJzsaOl28+DXEVBZxr17oxsJ+Im0UfdYOoDjBfRRlCX2XNmWHRS5x0nygldfHP6m4eQTmiCQrA==
X-Received: by 2002:a05:600c:190d:b0:39c:8216:f53d with SMTP id j13-20020a05600c190d00b0039c8216f53dmr3962769wmq.108.1655209862637;
        Tue, 14 Jun 2022 05:31:02 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:31:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 22/25] io_uring: pass hash table into poll_find
Date:   Tue, 14 Jun 2022 13:30:00 +0100
Message-Id: <7584a10fa437dc45e3e75141cc9d3f5596bc180c.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

In preparation for having multiple cancellation hash tables, pass a
table pointer into io_poll_find() and other poll cancel functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2688201e872a..b57e39082bac 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -556,11 +556,12 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd,
+				     struct io_hash_bucket hash_table[],
 				     struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
 	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
-	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
+	struct io_hash_bucket *hb = &hash_table[index];
 
 	*out_bucket = NULL;
 
@@ -584,6 +585,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd,
+					  struct io_hash_bucket hash_table[],
 					  struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
@@ -592,7 +594,7 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 	*out_bucket = NULL;
 
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
+		struct io_hash_bucket *hb = &hash_table[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
@@ -619,15 +621,16 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			    struct io_hash_bucket hash_table[])
 {
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd, &bucket);
+		req = io_poll_file_find(ctx, cd, ctx->cancel_hash, &bucket);
 	else
-		req = io_poll_find(ctx, false, cd, &bucket);
+		req = io_poll_find(ctx, false, cd, ctx->cancel_hash, &bucket);
 
 	if (req)
 		io_poll_cancel_req(req);
@@ -636,6 +639,11 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	return req ? 0 : -ENOENT;
 }
 
+int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+{
+	return __io_poll_cancel(ctx, cd, ctx->cancel_hash);
+}
+
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 				     unsigned int flags)
 {
@@ -731,7 +739,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 	bool locked;
 
-	preq = io_poll_find(ctx, true, &cd, &bucket);
+	preq = io_poll_find(ctx, true, &cd, ctx->cancel_hash, &bucket);
 	if (preq)
 		ret2 = io_poll_disarm(preq);
 	if (bucket)
-- 
2.36.1


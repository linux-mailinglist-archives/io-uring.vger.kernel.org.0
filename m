Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2000D677E41
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjAWOmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjAWOmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92649126FD
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bk16so11003863wrb.11
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMvHvBXJ6HVq2ctrCftC5eJz76/irYGFUMsWT9/tXuI=;
        b=JkaLi9aKj86qLQhn09LsiJr+DqcdfGFZUaeoHxI5OYHoPzZ5l4IEKm4QIO0b67n99b
         gRal2gRnKgfgAkZseplIZvU+ec5LmGIBue/vzTErNWnEAOG1i9OUT7WyCAYxysZdk1sk
         axdvVVKQF8NK1W5TBEnsF8qSEosAKv1uzgx+7Apol6/6MY5wHLsdg3rSgR1Xk4Ph41If
         UyWKujActklFC8FkIdSvgf1rHUgjuh5UfoNciiOOOSNtdGfNux/7XjTJM0kW4t/hK+kr
         3hdx+qwOwVj9j35nTszAPZWuWuV7Cej67y05Hzwbi/RjpLByd9rbhHiivWjf4ORJh44A
         W/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MMvHvBXJ6HVq2ctrCftC5eJz76/irYGFUMsWT9/tXuI=;
        b=E6BpLkWxKtkbQmRw+krST8TXiA3jG5wAnPO92rf5KfKQtKrASqHGZw/EUYTIobF6oj
         0oma2gRV1ky6h7PvYjEt2JS+WMZbZ1trOA/NJQpWQmIRnbKvnLrsPt9avRGu8HNYDySf
         Er8F+Nh2B8X6M76mhsoXcD5FQpAx/2SHPNYbRaeccLT0DpD0DkvfqJ4XCQE/2UColqWu
         rMkpYHni302A8P/YflxKBxM9LMXB9iR8PeIg8kCZUr99A8vhpdd6EupETFeKB5mawc61
         h/xhPj/RHfZ23SBrqCDdzdannFuICdpi8SthjKMR2NQ2aZxlomtW7yv9EaX4ZOqX1NBY
         VYBg==
X-Gm-Message-State: AFqh2kpvof8xl82b2/svwr+6WoR/lrn7ocWA75+bAtkaMSOtO8IxVlrb
        9X3g/M8ikyx+Gjni0WNy0Pt2NFd84sY=
X-Google-Smtp-Source: AMrXdXvqvrdSnu1XAVQvB7A+n2qVlNe5bS/jq4naoqsIQQyFJTTP2VUDfpcpzwsvkdk4FV0lq+Q7iw==
X-Received: by 2002:a5d:6648:0:b0:2bc:805a:3e77 with SMTP id f8-20020a5d6648000000b002bc805a3e77mr17591222wrw.15.1674484930894;
        Mon, 23 Jan 2023 06:42:10 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/7] io_uring: improve io_get_sqe
Date:   Mon, 23 Jan 2023 14:37:15 +0000
Message-Id: <9cceb11329240ea097dffef6bf0a675bca14cf42.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

Return an SQE from io_get_sqe() as a parameter and use the return value
to determine if it failed or not. This lets the compiler to compile out
the sqe NULL check when we know that the return SQE is valid.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 118b2fe254ba..6af11a60dc8a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2370,7 +2370,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
+static const bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 {
 	unsigned head, mask = ctx->sq_entries - 1;
 	unsigned sq_idx = ctx->cached_sq_head++ & mask;
@@ -2388,14 +2388,15 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 		/* double index for 128-byte SQEs, twice as long */
 		if (ctx->flags & IORING_SETUP_SQE128)
 			head <<= 1;
-		return &ctx->sq_sqes[head];
+		*sqe = &ctx->sq_sqes[head];
+		return true;
 	}
 
 	/* drop invalid entries */
 	ctx->cq_extra--;
 	WRITE_ONCE(ctx->rings->sq_dropped,
 		   READ_ONCE(ctx->rings->sq_dropped) + 1);
-	return NULL;
+	return false;
 }
 
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
@@ -2419,8 +2420,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		if (unlikely(!io_alloc_req_refill(ctx)))
 			break;
 		req = io_alloc_req(ctx);
-		sqe = io_get_sqe(ctx);
-		if (unlikely(!sqe)) {
+		if (unlikely(!io_get_sqe(ctx, &sqe))) {
 			io_req_add_to_cache(req, ctx);
 			break;
 		}
-- 
2.38.1


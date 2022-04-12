Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577AD4FE372
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiDLOM6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355635AbiDLOM5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9798C1CFF1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k22so9356029wrd.2
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3uTZg8w0NzrkKLp1jXt5sOJjVPjDIceoRpraC6w7NGg=;
        b=j/jhOk2T9ETGwrVYjDmy0nRfCzEgYEu3DBzQncf9B9KBi4NLTh4o5PVQOWwrCD8gWx
         GX+Ro3zwUqHkwrV4CIHnnAYHN3gWQ+kaJHdmFGCf4H6VPH+/4vnwA1KTFYHhubRU3qS8
         9M5sWiVo/WNbJmTgfyDiVziUVmSyK7BV43Arfvl8f0nxlcl7qRPPg84JwuDkNlfzqHuD
         GSjv7vihbSrogY6XVBQUiQ1xHcvxAE8ZkR+jHyyHpycWN15SLN0nZ/jTrenbWmodMVUx
         C2kZoIY/JyUh/n9FMMD+49typm/jFYylZ4SQIdSjNBetmSygftspIBePDrSJIVN9jz6h
         C0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uTZg8w0NzrkKLp1jXt5sOJjVPjDIceoRpraC6w7NGg=;
        b=v585Hk0wzWfViel1M/H2QSgMskZvQH05JPbM7dTHBMuRuUiQIn3nXZplZnmns7qadr
         3tiPTzJYKtOSXhH3+f09wRHc2X4FSiCqcE18vW8p1UIUAd9sps2g9of5VYlrgo4r3l2q
         107L7WgSmVgC7MnJzjhHt5dpdX2LWVK8At9+ufhv3FSR+16PVvdQkM0DIK6T/ehN/wtU
         srxkh+VnkWIIdqdx+O+bovYTvZA9AQarM8KRzGNKH1Fasilu0tiJGYHPU7o09mDIIVgm
         z0TQv3PtOGJQgUdovVkavzHKCBhGiAB6e2ebldClwVLpyq4IuQHmg35d7gigEsWsj8oN
         06dg==
X-Gm-Message-State: AOAM531M4qJELQQD+MpRIw0JrI19wVQ6SeNmoe/eDxRb4T89BMqYAdG+
        743zFPdY3DRZRXZz0AGvwKjj8MceK4M=
X-Google-Smtp-Source: ABdhPJzwfjxlsH0oE7O0YtvAw/IGPJl6gO8o75ur8tzTrhgMz6SZw78/ulztH/+xtbC7LJl9dqmYmQ==
X-Received: by 2002:a5d:47cf:0:b0:207:ac31:c2ce with SMTP id o15-20020a5d47cf000000b00207ac31c2cemr4573325wrc.422.1649772637977;
        Tue, 12 Apr 2022 07:10:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/9] io_uring: helper for empty req cache checks
Date:   Tue, 12 Apr 2022 15:09:47 +0100
Message-Id: <b18662389f3fb483d0bd07906647f65f6037475a.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

Add io_req_cache_empty(), which checks if there are requests in the
inline req cache or not. It'll be needed in the future, but also nicely
cleans up a few spots poking into ->free_list directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73422af2dd79..3ccc13acb498 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2211,6 +2211,11 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 	spin_unlock(&ctx->completion_lock);
 }
 
+static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
+{
+	return !ctx->submit_state.free_list.next;
+}
+
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
@@ -2232,7 +2237,7 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	 */
 	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH) {
 		io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
-		if (state->free_list.next)
+		if (!io_req_cache_empty(ctx))
 			return true;
 	}
 
@@ -2261,7 +2266,7 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 
 static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
 {
-	if (unlikely(!ctx->submit_state.free_list.next))
+	if (unlikely(io_req_cache_empty(ctx)))
 		return __io_alloc_req_refill(ctx);
 	return true;
 }
@@ -9790,7 +9795,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	io_flush_cached_locked_reqs(ctx, state);
 
-	while (state->free_list.next) {
+	while (!io_req_cache_empty(ctx)) {
 		struct io_wq_work_node *node;
 		struct io_kiocb *req;
 
-- 
2.35.1


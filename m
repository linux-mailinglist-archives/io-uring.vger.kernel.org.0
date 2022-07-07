Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4456AEFB
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiGGXYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiGGXYW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:24:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9895E313B0
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:24:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 5so9081638plk.9
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaGUxvs10Ulhn93ZjMjOX9W/ckj62/WTCRGEn6oMv7I=;
        b=7mAgbMNxUT+U/28M4ozadcpFyT6ozoPs0vaONbhkb6QiDlcg0/LjkFZQXQYbb25J1p
         fIBDFKIkPk3uoqbV6/rY0LFUY04Z62yGtv8KPXlT6qeE8B06Mx1g4qq98abg3+1fzGEO
         uLL5a7NxiW77q0pmwuJvnTFoHIF3RG8tsMWrcBnA0BSbAPz0Y81ADrVkeJH9LuaVRtxS
         h3wVPgkSbGz/NExUzgEc3ZaRn1cWJGk6NRHt0kFoUcU2wjVI0may7MMGIc2mMF+45K2a
         dv033fjTOgaJgrB9Une6EdfUSO0tysqY07D6YjZloiPaajSJpWzgquXUHPlURiR2aZ13
         W2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaGUxvs10Ulhn93ZjMjOX9W/ckj62/WTCRGEn6oMv7I=;
        b=Onue4rfnIfEGxB7OTpNlmgW5ySFjQwZrihJK5l6bf0pPC+CN7q0/gWMXCU8WczRyPX
         yQ7c671WSJSN7E8OTs0gpjjMZUng7o3haY4B6y2MF7XKu/vJGRUPMWSLihFn/qvcOLZp
         PYXtSwRlLm0KpPxkROY9xJsxR0/5MbuSbCP874UBsdosB2xOtqIhkd8u2SLqlU0fJ6GE
         x9V9+EYwBxVTeu/nlyjxPFIlgzzmq3UCtm7nKyNTJur3f+TEHn8EdfZpVlhXPCotctua
         Hj8gzaU17KK4KHkwAUC8zsU+LZ5AiueVxcIK4mf4rW1n2f6waJLjzuSHLdW9DjYOsdvk
         I73g==
X-Gm-Message-State: AJIora8aJD/F4x8X+nit7DhZ7ZIwgk4UXUJmvxB6RF6nSanzwbcqJqPC
        4ga4TfZlKvHXrQlqPitmdfdZWcbYcTK+Hg==
X-Google-Smtp-Source: AGRyM1sQQPT65Z9vOWDjdPaX3NHA2ru7exYW2zo0z3uL7QqF3+L6vlcDNNTGWqYC6atDYcci7JBUAA==
X-Received: by 2002:a17:90b:4acb:b0:1ed:fef:5657 with SMTP id mh11-20020a17090b4acb00b001ed0fef5657mr7852450pjb.142.1657236260963;
        Thu, 07 Jul 2022 16:24:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s65-20020a17090a69c700b001efeb4c813csm94014pjj.13.2022.07.07.16.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:24:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: impose max limit on apoll cache
Date:   Thu,  7 Jul 2022 17:23:45 -0600
Message-Id: <20220707232345.54424-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220707232345.54424-1-axboe@kernel.dk>
References: <20220707232345.54424-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Caches like this tend to grow to the peak size, and then never get any
smaller. Impose a max limit on the size, to prevent it from growing too
big.

A somewhat randomly chosen 512 is the max size we'll allow the cache
to get. If a batch of frees come in and would bring it over that, we
simply start kfree'ing the surplus.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/alloc_cache.h         | 15 +++++++++++++++
 io_uring/io_uring.c            |  8 ++++++--
 io_uring/poll.c                |  2 ++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b548da03b563..bf8f95332eda 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -160,6 +160,7 @@ struct io_ev_fd {
 
 struct io_alloc_cache {
 	struct hlist_head	list;
+	unsigned int		nr_cached;
 };
 
 struct io_ring_ctx {
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 49ac6ae237ef..0e64030f1ae0 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -1,4 +1,19 @@
+/*
+ * Don't allow the cache to grow beyond this size.
+ */
+#define IO_ALLOC_CACHE_MAX	512
+
+static inline bool io_alloc_cache_store(struct io_alloc_cache *cache)
+{
+	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
+		cache->nr_cached++;
+		return true;
+	}
+	return false;
+}
+
 static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
 {
 	INIT_HLIST_HEAD(&cache->list);
+	cache->nr_cached = 0;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3b9033c401bf..b5098773d924 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1181,8 +1181,12 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				hlist_add_head(&apoll->cache_list,
-						&ctx->apoll_cache.list);
+				if (io_alloc_cache_store(&ctx->apoll_cache)) {
+					hlist_add_head(&apoll->cache_list,
+							&ctx->apoll_cache.list);
+				} else {
+					kfree(apoll);
+				}
 				req->flags &= ~REQ_F_POLLED;
 			}
 			if (req->flags & IO_REQ_LINK_FLAGS)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index f3aae3cc6501..cc49160975cb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -593,6 +593,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		apoll = hlist_entry(ctx->apoll_cache.list.first,
 						struct async_poll, cache_list);
 		hlist_del(&apoll->cache_list);
+		ctx->apoll_cache.nr_cached--;
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
@@ -969,4 +970,5 @@ void io_flush_apoll_cache(struct io_ring_ctx *ctx)
 		hlist_del(&apoll->cache_list);
 		kfree(apoll);
 	}
+	ctx->apoll_cache.nr_cached = 0;
 }
-- 
2.35.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E9D514947
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359149AbiD2Mbg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359010AbiD2Mbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7840C8BE5
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:14 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so8440800pjb.3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NRf6s+5qn9Gz0eToO3n2mT6QamFu+XJm4HProgltwE=;
        b=5sfAPZ+cs1jAuPmrlW6zpNVyOIS+yFGo4Yw0GQwWIMUihlHC2YH4n660m9m+AMxk1H
         dT8NGrflUIXWq1urF0rrjveG37oz78/COmRyX0QI3Y47jkQ1hJuYp2ZFtGhy/oCLclkG
         3O8/HSKvk9/KHgrHTBW3jt1v/8jWhGm1D4jXbaWmQ077IeMmGcTDorE1iF9TjbkBydbT
         7LkttXIomPWgzmFgRAQfXQMa03jGd5zlazpYvfmsOxUoffbzg3d89XS6bx+0QaPwlc3V
         rSG+oZ0MKFM2uOEHTm7dZLJ0FG8qsLbsgblSe1Jow9Kc1rHfK6OkFYV8OEHuMaBolqP1
         hnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NRf6s+5qn9Gz0eToO3n2mT6QamFu+XJm4HProgltwE=;
        b=14ikQO/T9an4XDvLvXdZOzs530RgBj9+qyuXF8GFxevlaiKkXTMNkL7fxz2PSuIGNT
         l6ZcSpI/64djAt9uaOm5gnUw04/Ur0/kQ+8i+qhqZGRsi/vfT+j9lBVLBVVymRP06q5N
         7u4jzjp5Y6A7TO0RPwiFROo37svh3Nysk27YQGeYrZzcJr4KOVSCn/hSnN49OnYe48Kn
         lezeLWcvzMAUCTeJeBG9lrkWWsaoEFOprrnYlUW6VFGNgaafTmqLnNibfb+FyF9YVyfh
         piM064P0RcgC/f7YoOCUQoylPCDK8rEXo+6nz3q6GjNnMHRYvzuBmyo3HrARnYCgIF1D
         NepA==
X-Gm-Message-State: AOAM532TozBEWrhE78o6orf/f6Wc0qjuWV8SWeLH5XFnE0IyYRWP2bLB
        JYB1u1TL4CMvyZt6KqOrRaXvn3CHaPr7w4QY
X-Google-Smtp-Source: ABdhPJwXwsIuL/26raNj46mzvn3/0ddz17g3BZ0LS3nIEnQ19Kq/snMHDSc6yUNEg+EVfUKG1TlL9Q==
X-Received: by 2002:a17:90b:2247:b0:1db:f52b:d3da with SMTP id hk7-20020a17090b224700b001dbf52bd3damr3621883pjb.229.1651235294085;
        Fri, 29 Apr 2022 05:28:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] io_uring: cache last io_buffer_list lookup
Date:   Fri, 29 Apr 2022 06:27:58 -0600
Message-Id: <20220429122803.41101-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Most use cases have 1 or few buffer groups, and even if they have
multiple, there's often some locality in looking them up. Add a basic
one-hit cache to avoid hashing the group ID and starting the list
iteration.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3c46915ebf35..50d48d3e05b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -411,14 +411,16 @@ struct io_ring_ctx {
 		struct io_mapped_ubuf	**user_bufs;
 
 		struct io_submit_state	submit_state;
+		struct list_head	*io_buffers;
+		struct io_buffer_list	*io_bl_last;
+		unsigned int		io_bl_bgid;
+		u32			pers_next;
+		struct list_head	io_buffers_cache;
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
-		struct list_head	*io_buffers;
-		struct list_head	io_buffers_cache;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
-		u32			pers_next;
 		unsigned		sq_thread_idle;
 	} ____cacheline_aligned_in_smp;
 
@@ -1616,10 +1618,17 @@ static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 	struct list_head *hash_list;
 	struct io_buffer_list *bl;
 
+	if (bgid == ctx->io_bl_bgid)
+		return ctx->io_bl_last;
+
 	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
-	list_for_each_entry(bl, hash_list, list)
-		if (bl->bgid == bgid || bgid == -1U)
+	list_for_each_entry(bl, hash_list, list) {
+		if (bl->bgid == bgid || bgid == -1U) {
+			ctx->io_bl_bgid = bgid;
+			ctx->io_bl_last = bl;
 			return bl;
+		}
+	}
 
 	return NULL;
 }
@@ -1760,6 +1769,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 	for (i = 0; i < (1U << IO_BUFFERS_HASH_BITS); i++)
 		INIT_LIST_HEAD(&ctx->io_buffers[i]);
+	ctx->io_bl_bgid = -1U;
 
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-- 
2.35.1


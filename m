Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA72515312
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379834AbiD2SAI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379836AbiD2SAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF35DD0AA8
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:46 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id i20so8877606ion.0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BWepBErWF/DJjzuLEOb1afuCPgdaTwd8ujyEo/Nnt3Y=;
        b=nUJXbZ6W0Noq/AE5F9DzAPu3afRh9zUny95zWI+MvQRCpoW2bjiSoLAfN9F7XTavhH
         6yDrzpMn+lYJWhzvy1T7jTeCTwI3V7tZqQWEXixEM4d9U7qVKeMD/6Cb3y9EA3BCY/Cv
         rq3QUAwBaiXU7CpWU1Kj2Nh6z5GtQA2lI6BQQBokAuKpXESAwIfXSLYVfNfqbcvoxTCA
         aiQmLDEYGxcVijQhrZKAyC0K2AO5tGSdoitU00q9eXbytUxb71jPIEdXZKYJG85IC00c
         sr3+XWiF8Vag9oWlk3lVoScr5Cdyd309W916AUaBklG5okCuq5Xs5NzbqGGlt3OlYizM
         V6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BWepBErWF/DJjzuLEOb1afuCPgdaTwd8ujyEo/Nnt3Y=;
        b=KFO2noiZPbSkj+khBf9stgpryxIh8cIqzoUHn/7EcwzD7iooOc38N65cqI5JdEwxAl
         RDUDI6fN8/nSg3g1VFuQ15VYn0l4JISbnSyRDRV5TvIIWpthAhd5oJuTOAUdn/OV0qHJ
         yAXdJFFL5L6kf8rOfqTaaMspLvXo1DTf5vF7YmrRu/ClV3HkzpiAxJhtEGfhD9M4hK1w
         lhi8rsfI2yUrpbCN77f8NhFEOCKVoYmSaenR72XON2lJs9yfEx6+OnMkanl7CyqPaCzO
         LpXYcrJxaMQC+BJhNScs1+X9kvmHVbjYh+hoGq290OJTEALICC1qqI+OhJiyPF/CDJ9k
         36tA==
X-Gm-Message-State: AOAM532RdR395b3DytSkFWNDJ65w6hDktN5qyNEI/zj5n2lutWIls22d
        cCBfEGDUHGgSdUvkiSyaIw2NZ85voNfdLA==
X-Google-Smtp-Source: ABdhPJydGPyfxp/v6n5N+7YDXK1lGOqPjpL31YBWEcA4S68BJIlWdIYUTt1QgqfQtzBgrhV/TWneIg==
X-Received: by 2002:a02:62c6:0:b0:32a:b876:218f with SMTP id d189-20020a0262c6000000b0032ab876218fmr229352jac.240.1651255005828;
        Fri, 29 Apr 2022 10:56:45 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] io_uring: cache last io_buffer_list lookup
Date:   Fri, 29 Apr 2022 11:56:30 -0600
Message-Id: <20220429175635.230192-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 41205548180d..4bd2f4d868c2 100644
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


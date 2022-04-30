Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3347E51606B
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiD3UyK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245145AbiD3Uxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5C36149
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r83so9012604pgr.2
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BWepBErWF/DJjzuLEOb1afuCPgdaTwd8ujyEo/Nnt3Y=;
        b=o0i0hlgOHrrFfYr+ijquytqA8et8Zory95DMAfUOI4k/P38CcKNdY29P1pKuVTgcVw
         YEdkKbi29+g8GZRv1FK5V2d1MrIxjOfEoZmvdwCprrGy1Ky+fUOcZb9ino3V3evxvKdV
         xROOEj3Q3MdzCTqo2cMWCwVMO+xceBECqfSYbOI+BgSgyVltnCD5H2PHDNUzigMSArUl
         Bo3HL6yWz18bZyy2nlde1Hqznkd8EaueXlXEc9Z32AkdlfCrATTnc8VUDhKQqNLknAkl
         LIwikznmvNwqxpXgrxtCx382wptLe05RLSVuZa1bnxBtbMF6KXHPgxQWulnhbJymHN8+
         APsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BWepBErWF/DJjzuLEOb1afuCPgdaTwd8ujyEo/Nnt3Y=;
        b=fpfMr3WUNSr9dqAttPb2daL4gueGexmyxVXa6i+AbLAlHgAk3ezx+9Ih8a5lSj8GSS
         JrE9doLYK1fTJEJGRi9sVCb44IA+ZjE1UJA/ZBw6mPNp2OuhfnetwpxvUPM4pwTcuZ/B
         Y8VdmygSs7R5cLCo2Ufz+3xDJdqPHkJJMKYOmYrnDEefL29ukutCucMXF2CGeLr9zi5O
         uPaFoVteqxkY4qPl7kK+6rGIuO9lIpKk+hI/EGjurku3wAW7Lv0UK/QLqe9eC4tbk7YL
         1SY681YQ7QTxZ1cz/tKnLFHfotazFvYscxg4pKmncb+jxj9pKU1mEXPJuJ+1bEq+Hzsg
         91Mg==
X-Gm-Message-State: AOAM530aUpdjk4Sz5iwnzBWllDE4XLSYd6STVmybzR5eayv6AhyVkqGB
        qjkiTw9P7CFonRH0ua8mRXNAZj1EIlpa6jwz
X-Google-Smtp-Source: ABdhPJwXc4LN9kSLsiA9svx0pMNNl4wK3VvORv8iPONQfLMNIPmjAUJyMxywbISqbvNGd0+96r+YAw==
X-Received: by 2002:a05:6a00:168a:b0:4f7:e161:83cd with SMTP id k10-20020a056a00168a00b004f7e16183cdmr5027105pfc.56.1651351832308;
        Sat, 30 Apr 2022 13:50:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/12] io_uring: cache last io_buffer_list lookup
Date:   Sat, 30 Apr 2022 14:50:16 -0600
Message-Id: <20220430205022.324902-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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


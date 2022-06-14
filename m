Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965F54B0C3
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbiFNMdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245727AbiFNMd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FD145063
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q15so11035551wrc.11
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43ATD8fKnmjyJdZ2R6qxl1QYnz/Icg31elC1cRBKr+w=;
        b=Gna1ys5pfe3cJOu1n9NdsRTUGvJhdA5kqAw2G4tlYv4x1/52D5HMpeKTuiSIndkpTT
         IWfr94ieH2OEB5R7UW0UJfTNqXdP8V2+bctQ1i29qSvsWe9Xp7AtG368QLez1PHOHG4x
         sEI5v1e7WznGsNyuoyp42j24U56QAglG6XXCJWgKW0szn02YVrIH/LIc+GC9pEETPwWc
         BVsayvpDp2S2spAT0Ol5E/ZdIY/uEky2rOS5judGmm2mAsgfO1ekv4NYpECKVPrfeO5p
         VhOioUJ80It2DSr75DfQAq0OU3NlYZoH39pLGo8I4CARPFTZXQBWGCMwyu4lc/Qi+eIj
         T21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43ATD8fKnmjyJdZ2R6qxl1QYnz/Icg31elC1cRBKr+w=;
        b=F6nRlhBQ8U4UOul/oqIGuLwZNKPQahvLyYrn/SZ8FzRCK+GsfIbWZtxAVpZ9IoisyI
         ietFwPYlKDtLGuVWwkwzfUzTS7HnU4Z6x00SNPyps3PhD4pS1QGl18z4ELzAlbZ7Cs5Q
         pBoU/NO2O1W+QeDHDMdcajeOp5k5A9WvhYxu0IVFDmpQGeihNP2RGcIJbY7y2pZua5ll
         MiClp2FoB8H33TPFD0N4ocL4tgAKmn6Z7qSiFJiKOtAZKL5eWgrab7S2i77KWV0uUN+f
         eXzGWLkEKdln+olx8NI0xI/LmK9sMgKIWDV514DILcetq7Z+nwHly/wdM8uVXkTuEy0r
         KjoA==
X-Gm-Message-State: AJIora/FI66TJ5ja2v8O3AHThKxWUx5biGB91/qubBP5E8gfH6JwVwzc
        DSKFcnwMxnx8k1BspcNCcIGcwiAMgyK6sQ==
X-Google-Smtp-Source: AGRyM1vS/ytzSJDnimxpkRfjdk9iGlyUfaSj95AHRK9YVtLAUh9+/nSWph2DvHycCRjcFDdRFrju1Q==
X-Received: by 2002:adf:f584:0:b0:218:5a97:8f05 with SMTP id f4-20020adff584000000b002185a978f05mr4658518wro.333.1655209838539;
        Tue, 14 Jun 2022 05:30:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 03/25] io_uring: better caching for ctx timeout fields
Date:   Tue, 14 Jun 2022 13:29:41 +0100
Message-Id: <51f0bc096197ab07fbc54b975dafbd22a31a634c.1655209709.git.asml.silence@gmail.com>
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

Following timeout fields access patterns, move all of them into a
separate cache line inside ctx, so they don't intervene with normal
completion caching, especially since timeout removals and completion
are separated and the later is done via tw.

It also sheds some bytes from io_ring_ctx, 1216B -> 1152B

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring_types.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 52e91c3df8d5..4f52dcbbda56 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -179,8 +179,6 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
-		struct list_head	timeout_list;
-		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
@@ -213,15 +211,11 @@ struct io_ring_ctx {
 		struct io_ev_fd	__rcu	*io_ev_fd;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
-		atomic_t		cq_timeouts;
-		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
 		spinlock_t		completion_lock;
 
-		spinlock_t		timeout_lock;
-
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
@@ -253,6 +247,15 @@ struct io_ring_ctx {
 		struct list_head	io_buffers_pages;
 	};
 
+	/* timeouts */
+	struct {
+		spinlock_t		timeout_lock;
+		atomic_t		cq_timeouts;
+		struct list_head	timeout_list;
+		struct list_head	ltimeout_list;
+		unsigned		cq_last_tm_flush;
+	} ____cacheline_aligned_in_smp;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct {
 		#if defined(CONFIG_UNIX)
-- 
2.36.1


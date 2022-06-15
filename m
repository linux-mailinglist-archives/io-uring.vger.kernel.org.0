Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973AF54CEC0
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356290AbiFOQec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356571AbiFOQeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:31 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E337BFE
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s1so16098995wra.9
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2M2vqRQ9RAoU3bnpdZxapmtH2oq59EBP0ozhlRRLD0=;
        b=n+D5Z7h0EBWZocZu3NTaQ99ROfPBOfhlspVUjwaQPpXbQ1fi9NJYO97FzzzPAaPcZ/
         2Pjr9jXfVywH8k1Y/r7Stav4Z6ZcCgl9S5F3r1X7T+bM1uhtWE8Q1BoItHgnp02ShyH7
         +EuWQulc2YzHdCBKrnT/Y5j3VJbEQOSo4x2XjBHLH58MBQvL1CaM+7euUhcoCmPstHnm
         USTt/Ak9Ji+PYgGY41c8NRaAc8j17Lje+O37O+9J2D5003ep0t9bk45V1VsY+YVQ/exl
         MbtwYRY/zgFfYafiaT3t5HMjME53uDIjYVmu5GkOUaaM270iz7ry2L5zeZtcvw4DLQ/Y
         Gq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2M2vqRQ9RAoU3bnpdZxapmtH2oq59EBP0ozhlRRLD0=;
        b=fqpyCJKUKctK3tXbXvm7lgjWGuZQjrqiErPLGZ+ldvbp+4pHa2FOROWir3g/XBD1WE
         TI53kvbz5jYJ7f/lHWBbeZsn603sWHPTy4zAUDSGljYaowUtj96Ji/oiYaTyU6DIn5R9
         +Qlm1AvfIH1J/Hk2LDMxspTsbPNFI/KD5gfsQnOvLQiFJ4ymseDv5cUI7hNzKpBPvE1X
         nc4ifR0y2Lo4xL+Shr+oW8Jli/Ov3CrDvRqjNYuOXeEtd7Rm8bFlCzIh6kkqta1JSne9
         SfFNOmEiMYKqBFBGFJW3mAJxSseg4nyZ0bsdDkg4szk710BGcyYjlXVIy66SrPL67B0z
         a9/w==
X-Gm-Message-State: AJIora8W6AzG9AVgG5nps+yEloZNt4kcm2hV08YAZWOeEKNgdxNNfVv6
        vOI9bn96oj9/AjM7ok2xQeiGw4GiGtumFw==
X-Google-Smtp-Source: AGRyM1tWHHKe4uGZMAppyDKdJ5WD3gwlXi15FPRbwJS/Z1Oxs9Se0GZiVFkBjYT/QPxmfmujIsgtCQ==
X-Received: by 2002:a5d:47cf:0:b0:213:bbe1:ba4d with SMTP id o15-20020a5d47cf000000b00213bbe1ba4dmr620714wrc.173.1655310867975;
        Wed, 15 Jun 2022 09:34:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 03/10] io_uring: better caching for ctx timeout fields
Date:   Wed, 15 Jun 2022 17:33:49 +0100
Message-Id: <4b163793072840de53b3cb66e0c2995e7226ff78.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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
index bff73107f0f3..e050c3c4a7ac 100644
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


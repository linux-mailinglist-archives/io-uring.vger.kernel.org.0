Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B833D54B38F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiFNOhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbiFNOhp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68101147A
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x17so11577589wrg.6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43ATD8fKnmjyJdZ2R6qxl1QYnz/Icg31elC1cRBKr+w=;
        b=dWSJcQy861faEAMob54R9WAvsnQs2gN2exzOxO9MfDV5fZ/Q4hoyzssXere454eLQi
         It3xv6q0Vl0aNw9vhLM38zpvZdoS8zNKawymC44is2WpJnLoNe8r8u92erbikD7EQWaM
         uldltSzhgrgwkdRonSejQ0L3CMnlWLYj/KxLrCBI6QyDFZg6nL6YQGXh8ydcLTz3xQin
         P5SSNF5kpr6kCHFvAzLj8T8cSLkE90c1KwEI/OMDupPVMtARaHg1smfIvsitwHOW0G5h
         fh5tu0F53ewQynV8MIXMTZY6r6Um/PvMo0MMm0Mlb3kWdt/W2a7bSzo2sIl11ATUiD1d
         dYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43ATD8fKnmjyJdZ2R6qxl1QYnz/Icg31elC1cRBKr+w=;
        b=lASKtwL4vV9csIhhAYARouOZmqE+Cvv8XCE1qevjuuvlO0S/LnEWLFxPBzjujjdoHz
         7s5FuSjYejTabw/SEMqPlLruOqPgow9Me9YPTBVzVD5GljayWuHcfUs0lYTDSIYGirR0
         o4ZF9BFt4jCyTlfSPhAc+j6SOjpqHAJmyNiwDkqTbt7ql2cSwp0BRkYlYy+lZWlHx8Hl
         yL7hqkP+reLWga32PnHy9ZTt2A0Xlzi5LLhssZAU//+3Z0T7NQne2lHEgAfDSbwX4p3D
         WK9C7htYOQvM/7p6bAgnOP2/fxAIFb1pcKgfMUItE0HiO0di1960U3II978VGkVxtY9d
         fcmw==
X-Gm-Message-State: AJIora9JgLr2k3m5P76iNXZDssb1u/JnavZvu9hjC1tH6i0+Sp3OR2Hn
        b1sptIL+47eteCu62lkN5c1Dc6QeZw95SA==
X-Google-Smtp-Source: AGRyM1vNQNKrvWhUjOitvg2CNSvKDDpY7+NbodWCJh3jGKqGG0zYlC9L+5kG0fEu4kMhS+f6OJat0g==
X-Received: by 2002:a5d:55ca:0:b0:211:4092:1c27 with SMTP id i10-20020a5d55ca000000b0021140921c27mr5404546wrw.108.1655217462025;
        Tue, 14 Jun 2022 07:37:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 03/25] io_uring: better caching for ctx timeout fields
Date:   Tue, 14 Jun 2022 15:36:53 +0100
Message-Id: <51f0bc096197ab07fbc54b975dafbd22a31a634c.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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


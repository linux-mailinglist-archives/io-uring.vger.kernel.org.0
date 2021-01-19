Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482642FBA71
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbhASOz1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394420AbhASNhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:53 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F1C0613D6
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id 7so12506839wrz.0
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8xoq8fIBmYIu9omNtZICLlSUizhHZhV+USIZ61Ml4vY=;
        b=H1u6/GIp/UECvtrYFKGIkrTafWA2XX5+F4gKGTp8hOnUl44qUbZSYClMdQLmsvKMMR
         rouzC/osP85/dvqff3/BpD2PgEtiiromFQ1f6LIuqsaqFsDHnrxokvQpPzYsK2tuA1PC
         QseAucNPO3xWoEOdTCbdfbApGAlGzYjjEweo8G6GB/HdTdeOo0/J+7B3eoldptj2S0vU
         1jP9owZxd4YTPoCvsqvXGvOGB0OdTu6zzj5neIGRTTyP4X5+xMj4ueufKuqdtV7cuaik
         e4XJLJPu+OkW32w5niRJC6UaDZjHgLnkM15VuZUuNHGA2eSOhPvuKw6iKHqSye6ggCJ+
         u7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8xoq8fIBmYIu9omNtZICLlSUizhHZhV+USIZ61Ml4vY=;
        b=TcxoAHGSGipIMrHwnBZJMYebk3Hjitq3FM/wg4yr0w9sy2bQJ8bxKBDVy3lN/a02L1
         ph7tdJDGtX/T7UBVwnQnz7eP+0EZyJdQ8baGa1Ge5DQX1jsuKY+t/65k9/+4C64gRPQ6
         BuHC/+ULGuU/eHPQYyPElmZ1hSiPTfqL6VrGUydJEbZgUsuDxU1AW5az9ZBZgy+4C+Lg
         hpGfuhatT2WSVNsOH5VYr1rwgCYAzMPZOmrtylogRYrxGIzBhAf893pxNLIzPKgG4i5y
         lcxajg7Df0G9ELam/W5aMHwbQbnoWA12oZXuzNL2jgh+SOgoe49a3q8rRzWb9eoUtxH+
         KDaw==
X-Gm-Message-State: AOAM531zdl6y69pXWhENKNsWvVRa3Npj5UsL7EzdnOzICF2z3S3gfYZ6
        UQnHqRvajqUVkiaJAs8mKbiYj27Aa3Ro6Q==
X-Google-Smtp-Source: ABdhPJw1YH7Z1HjyfDDtbOZP+Pj3V+QF9BR5X/daGgOVW6+JMG17K7u0KsrVrzySjFdQz9F1ACu51g==
X-Received: by 2002:a5d:47a8:: with SMTP id 8mr2286779wrb.180.1611063398080;
        Tue, 19 Jan 2021 05:36:38 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/14] io_uring: further deduplicate #CQ events calc
Date:   Tue, 19 Jan 2021 13:32:39 +0000
Message-Id: <836a8e09e57da7f090d3604c8d856881c22cbbd6.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apparently, there is one more place hand coded calculation of number of
CQ events in the ring. Use __io_cqring_events() helper in
io_get_cqring() as well. Naturally, assembly stays identical.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5dfda399eb80..b05d0b94e334 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1679,21 +1679,25 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
 }
 
+static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
 static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail;
 
-	tail = ctx->cached_cq_tail;
 	/*
 	 * writes to the cq entry need to come after reading head; the
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (tail - READ_ONCE(rings->cq.head) == rings->cq_ring_entries)
+	if (__io_cqring_events(ctx) == rings->cq_ring_entries)
 		return NULL;
 
-	ctx->cached_cq_tail++;
+	tail = ctx->cached_cq_tail++;
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
@@ -1708,11 +1712,6 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return io_wq_current_is_worker();
 }
 
-static inline unsigned __io_cqring_events(struct io_ring_ctx *ctx)
-{
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
-}
-
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	/* see waitqueue_active() comment */
-- 
2.24.0


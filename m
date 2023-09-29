Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE67B3250
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 14:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjI2MTd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 08:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2MTc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 08:19:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B61CDB
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9ad8a822508so1893572266b.0
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695989968; x=1696594768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uKeGxO4ufV4P7wCwhce7Ud8UMY3xuDbgrMxlBH9ZuY=;
        b=EyoTTJsPMI2DRDeHQzs7h00q6N/pbo4DpPPF20CblfwiPI915KOKjxathA2optzgHk
         cMDyOFaPo4RaypOVFE1ROcYFieHNXFuLFyaDL+X4fP6ymXtV1I1EF6fJCKVeLh06KJah
         +OwlFycPSIUh7mXkn5Ew72yagC1w9XyH482c1d40vdyAVHvI0WkdMMjbRaDchQn6GeNf
         IdUyK51HkZpnJAjbqHGoXyq7ZkEPoSOy4XZmOqx61MJWya1knXhBtrv/o8meEasFf2Op
         SyOpMgMPKuRBFiB9UVXzPKANtLOK/9SjFWU9WvG0hr9J2XmJtwUIgPbBtnc1k4QnlboA
         3Qeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989968; x=1696594768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6uKeGxO4ufV4P7wCwhce7Ud8UMY3xuDbgrMxlBH9ZuY=;
        b=FVM1XVxiBhfIvtgjErE5JP4+6xc+/qtbstRHSq+dfcixvEtLiQKIAS3auq4KcdgVda
         /A/IZ43CIlL/Qcv4eou81f0djf+URJcUf8kpYR4nXHT0FlBPLPEttjlPGSq9T5a77HlN
         My+BMq1BqNpDW5io+Btn3RPD6KVqS/dLLMly8h0+pHAqRybJ7SNRfTKPMA9Um6llwTPk
         VW7P4Ig6sJxYr03UPfcfhAgKSGLvgY0L/fh7/B/176y69J7stkQon6Jb9uCrKHhDVP43
         vlmJ7BFemnhnkDZWlV1UuWhJ3cnvco028xyUa8T+iHFDnIrlpuw+eM+S4BMn1bTHDdUT
         ot6A==
X-Gm-Message-State: AOJu0YwxjN3SfYTEM7pfMPs+JPaoJu3o028Qyh7XXbepLx8XeePgPIQo
        XqcXFX+DRZwKNzSjPU3enM1V3M1kIhPH7g==
X-Google-Smtp-Source: AGHT+IE3TR7BBrAr3DFmdtVfobjragTWsFkdvWpop8vtAAHuy2SxqVN9Qt3FuUqhXvceeHuWdixv1w==
X-Received: by 2002:a17:906:76d4:b0:9a5:ca42:f3a9 with SMTP id q20-20020a17090676d400b009a5ca42f3a9mr3570584ejn.2.1695989968140;
        Fri, 29 Sep 2023 05:19:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-229-128.dab.02.net. [82.132.229.128])
        by smtp.gmail.com with ESMTPSA id jx10-20020a170906ca4a00b009ad87d1be17sm12211878ejb.22.2023.09.29.05.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 05:19:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/2] setup: add IORING_SETUP_NO_SQARRAY support
Date:   Fri, 29 Sep 2023 13:09:40 +0100
Message-ID: <2badb194856fad38ef1a9049e4cf121a9516b7f9.1695988793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695988793.git.asml.silence@gmail.com>
References: <cover.1695988793.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_SETUP_NO_SQARRAY removes sq_array from the kernel, and hence when
set liburing should not try to mmap and initialise it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |  5 +++++
 src/setup.c                     | 14 +++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 10a6ef0..793d64f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -185,6 +185,11 @@ enum {
  */
 #define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
 
+/*
+ * Removes indirection through the SQ index array.
+ */
+#define IORING_SETUP_NO_SQARRAY		(1U << 16)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/src/setup.c b/src/setup.c
index 2dcb5aa..a0e8296 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -76,7 +76,8 @@ static void io_uring_setup_ring_pointers(struct io_uring_params *p,
 	sq->kring_entries = sq->ring_ptr + p->sq_off.ring_entries;
 	sq->kflags = sq->ring_ptr + p->sq_off.flags;
 	sq->kdropped = sq->ring_ptr + p->sq_off.dropped;
-	sq->array = sq->ring_ptr + p->sq_off.array;
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		sq->array = sq->ring_ptr + p->sq_off.array;
 
 	cq->khead = cq->ring_ptr + p->cq_off.head;
 	cq->ktail = cq->ring_ptr + p->cq_off.tail;
@@ -220,7 +221,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
 	ring_mem = cq_entries * sizeof(struct io_uring_cqe);
 	if (p->flags & IORING_SETUP_CQE32)
 		ring_mem *= 2;
-	ring_mem += sq_entries * sizeof(unsigned);
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		ring_mem += sq_entries * sizeof(unsigned);
 	mem_used = sqes_mem + ring_mem;
 	mem_used = (mem_used + page_size - 1) & ~(page_size - 1);
 
@@ -335,11 +337,13 @@ static int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 	/*
 	 * Directly map SQ slots to SQEs
 	 */
-	sq_array = ring->sq.array;
 	sq_entries = ring->sq.ring_entries;
-	for (index = 0; index < sq_entries; index++)
-		sq_array[index] = index;
 
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY)) {
+		sq_array = ring->sq.array;
+		for (index = 0; index < sq_entries; index++)
+			sq_array[index] = index;
+	}
 	ring->features = p->features;
 	ring->flags = p->flags;
 	ring->enter_ring_fd = fd;
-- 
2.41.0


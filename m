Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D915B5082
	for <lists+io-uring@lfdr.de>; Sun, 11 Sep 2022 20:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiIKSSJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Sep 2022 14:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIKSSI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Sep 2022 14:18:08 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C5024975
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o5so1611245wms.1
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=39FBJTRng/1zJh/tOPCqg7gk9AHqZOjn0ySnL6ZiRuY=;
        b=H3PGcLwuC+8EsqHXEy0ink7RJtZ4+SiTBBYSN3E6mJq6DLUBMAUdAJ0MhXJ1dMwmYj
         VSycyCjepcFmbGzAfhOpGjEdMPZI2lrVBw8S8+pZQ1TV3sq16w4me+ITNCchhSvLhCRJ
         3438exhIbgJO7ncyur5/33S3XNNri5ueZ/i2x6TXEkAJZZCfyFlhIXgdBjCrrHcRtxO3
         KmNmTCepJ4N50S06PeMJ19iX3Zbdb1AA0rX02ePfqHqhJ8mcYH+IJxhyYWHUYJdSEt0t
         pscCX7Sbb5ejIzUUE8TcxLmo63GrtUcN1hFxBhbx+69wjCP9M3RWd/sUfX1WXcCYzngL
         M2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=39FBJTRng/1zJh/tOPCqg7gk9AHqZOjn0ySnL6ZiRuY=;
        b=KEY9H9zf4DzR2K9/5W0z7W6ULz1JPzl3U8Ns1I/rFpEa242iDAqY2g/yjjgFif0D7j
         mS66mJ0gRGyAvN6X2cYoeTA3xBVea5tRj7oNxoiaTQNURBcB4yE9qxZnUN6XzGSUX1EF
         A4aKfrO+tcgzGQtXNspLJSXez9g3D+3RRMKNjc9xM4SMBMA8syDKFy33l/wTe9zwzh6Z
         7w9guEwsEJ4/GXxObDPrU7qx63KBA3DuAgrYnIrAUKeGty0HolDtki9xsIQw6obv4YfX
         EYyPSHUCZJUluiIJYwJWTw9lexlLK/hEkL5PZK5I4TeApoAuFGW5WlFR10uigyx/Ctka
         w46A==
X-Gm-Message-State: ACgBeo1imj0W9NCoOnCFcQsNmEJCywwBt9fSQA43PyhMfGarGR1/VkfN
        7YMzj80oSOo4xHBrjd99RIjElxVviE02CHe3D9A=
X-Google-Smtp-Source: AA6agR5J4UhLbHNBgpNJsvaSssOSlLM+kTpcIGZXhLPcUSly80818ipqzwKKgV/lsg1m9tKomfB+GA==
X-Received: by 2002:a05:600c:348d:b0:3a6:b4e:ff6d with SMTP id a13-20020a05600c348d00b003a60b4eff6dmr11000599wmq.95.1662920285769;
        Sun, 11 Sep 2022 11:18:05 -0700 (PDT)
Received: from m1max.access.network ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id v2-20020adfe282000000b00228dff8d975sm5160056wri.109.2022.09.11.11.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 11:18:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128
Date:   Sun, 11 Sep 2022 12:18:01 -0600
Message-Id: <20220911181801.22659-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220911181801.22659-1-axboe@kernel.dk>
References: <20220911181801.22659-1-axboe@kernel.dk>
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

If we have doubly sized SQEs, then we need to shift the sq index by 1
to account for using two entries for a single request. The CQE dumping
gets this right, but the SQE one does not.

Improve the SQE dumping in general, the information dumped is pretty
sparse and doesn't even cover the whole basic part of the SQE. Include
information on the extended part of the SQE, if doubly sized SQEs are
in use. A typical dump now looks like the following:

[...]
SQEs:	32
   32: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2721, e0:0x0, e1:0xffffb8041000, e2:0x100000000000, e3:0x5500, e4:0x7, e5:0x0, e6:0x0, e7:0x0
   33: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2722, e0:0x0, e1:0xffffb8043000, e2:0x100000000000, e3:0x5508, e4:0x7, e5:0x0, e6:0x0, e7:0x0
   34: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2723, e0:0x0, e1:0xffffb8045000, e2:0x100000000000, e3:0x5510, e4:0x7, e5:0x0, e6:0x0, e7:0x0
[...]

Fixes: ebdeb7c01d02 ("io_uring: add support for 128-byte SQEs")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d341e73022b1..4eae088046d0 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -60,12 +60,15 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int cq_shift = 0;
+	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	bool has_lock;
 	unsigned int i;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cq_shift = 1;
+	if (ctx->flags & IORING_SETUP_SQE128)
+		sq_shift = 1;
 
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
@@ -81,19 +84,36 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	seq_printf(m, "CqHead:\t%u\n", cq_head);
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
-	seq_printf(m, "SQEs:\t%u\n", sq_tail - ctx->cached_sq_head);
+	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
 	for (i = 0; i < sq_entries; i++) {
 		unsigned int entry = i + sq_head;
-		unsigned int sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		struct io_uring_sqe *sqe;
+		unsigned int sq_idx;
 
+		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
-		sqe = &ctx->sq_sqes[sq_idx];
-		seq_printf(m, "%5u: opcode:%d, fd:%d, flags:%x, user_data:%llu\n",
-			   sq_idx, sqe->opcode, sqe->fd, sqe->flags,
-			   sqe->user_data);
+		sqe = &ctx->sq_sqes[sq_idx << 1];
+		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
+			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
+			      "user_data:%llu",
+			   sq_idx, io_uring_get_opcode(sqe->opcode), sqe->fd,
+			   sqe->flags, (unsigned long long) sqe->off,
+			   (unsigned long long) sqe->addr, sqe->rw_flags,
+			   sqe->buf_index, sqe->user_data);
+		if (sq_shift) {
+			u64 *sqeb = (void *) (sqe + 1);
+			int size = sizeof(struct io_uring_sqe) / sizeof(u64);
+			int j;
+
+			for (j = 0; j < size; j++) {
+				seq_printf(m, ", e%d:0x%llx", j,
+						(unsigned long long) *sqeb);
+				sqeb++;
+			}
+		}
+		seq_printf(m, "\n");
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
-- 
2.35.1


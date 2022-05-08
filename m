Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7002951F229
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiEIB3T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 21:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiEHXxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 19:53:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA88BF4D
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 16:49:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c11so12327079plg.13
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=76e9yu7mj9h8yyptPk4D1Ida9qMWlDUrEpEQV3xm7jI=;
        b=exBnRazanJVG4HJaoclfefazQDAIi70FerN8lv0pt1yR+24ceV1S5zDh2tObCR/aFM
         TL2pdG7oUClAtzWVJk6PpTh8ccpxL/h+e5pA3Z2qpOixCC2HIYzxk76nDA5o9t+yzpfb
         NpZPQhneOFQDSiBSmBar3LR8KTAeAIsLRY3iCk4LtKxfIR7SE7M47mFkcuHSm1NePLzE
         pKN7lA0MfsgcYhb82iTN+bUCR4TwvK4JERGM+M3KgOoqfIr0IcFHFhtRtlLrSq+hGoGt
         fZqro8QCYR6qSRUIfQZ5CjENFENJnGoeOntQYgACy7RZf/IboO8jFfypOJCaa+iLzGnJ
         1BGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76e9yu7mj9h8yyptPk4D1Ida9qMWlDUrEpEQV3xm7jI=;
        b=MHJYUILzaGUUtVrdmNnm4QWHTkjNIdyOpdvUnYPzF6Khvo9NOlP4LcGX078cO5g2ft
         3sM2IuSAaX5GVA90/co+8kwI4weL0yuntbCttwD5rhNk12cRbVQ7HRbfrBQi53N/mHW9
         jRSb7gIvGhSPrI8kbiCmvaXF4yINMQAkG0Q5aIUy/emyd0EyIsJ2V3BwjflR8SxrrBEr
         axiYty7mTuCACegA0eQvv/G682tu+gpRmrpNMMIYRzdp1tcnTK5nXaWSBjYHGb/3AzFo
         7ZIL+Zws8cZdBYT/r5h8WIpdGr0XwRYgP/lcn9lb5vf9E9m+HjcVmNt2ecLE1IE5MWrA
         AYEw==
X-Gm-Message-State: AOAM530U8A7wlwRRFB/v7wfJVLY96c4WbIVmqcyaD2g1Ue+tG3IC05m1
        OZBp7T0Wt4X9XZy1f4LYZMEffO26VeQ8hoOP
X-Google-Smtp-Source: ABdhPJxBRedehBeJWvKjR9GAK8exdz3mWNRX0GO6MpoejoiXOBnsw+/whrtRRMyUPKm17kab9jsrkQ==
X-Received: by 2002:a17:902:e8cd:b0:15e:ee3b:7839 with SMTP id v13-20020a170902e8cd00b0015eee3b7839mr12425471plg.92.1652053754953;
        Sun, 08 May 2022 16:49:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902ccd100b0015e8d4eb2a2sm5675249ple.236.2022.05.08.16.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:49:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add basic fixed file allocator
Date:   Sun,  8 May 2022 17:49:07 -0600
Message-Id: <20220508234909.224108-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508234909.224108-1-axboe@kernel.dk>
References: <20220508234909.224108-1-axboe@kernel.dk>
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

Applications currently always pick where they want fixed files to go.
In preparation for allowing these types of commands with multishot
support, add a basic allocator in the fixed file table.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6eac6629e7d4..6148bd562add 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -258,6 +258,7 @@ struct io_rsrc_put {
 struct io_file_table {
 	struct io_fixed_file *files;
 	unsigned long *bitmap;
+	unsigned int alloc_hint;
 };
 
 struct io_rsrc_node {
@@ -4696,6 +4697,31 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_openat_prep(req, sqe);
 }
 
+static int __maybe_unused io_file_bitmap_get(struct io_ring_ctx *ctx)
+{
+	struct io_file_table *table = &ctx->file_table;
+	unsigned long nr = ctx->nr_user_files;
+	int ret;
+
+	if (table->alloc_hint >= nr)
+		table->alloc_hint = 0;
+
+	do {
+		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
+		if (ret != nr) {
+			table->alloc_hint = ret + 1;
+			return ret;
+		}
+		if (!table->alloc_hint)
+			break;
+
+		nr = table->alloc_hint;
+		table->alloc_hint = 0;
+	} while (1);
+
+	return -ENFILE;
+}
+
 static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
@@ -8665,11 +8691,14 @@ static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
 {
 	WARN_ON_ONCE(test_bit(bit, table->bitmap));
 	__set_bit(bit, table->bitmap);
+	if (bit == table->alloc_hint)
+		table->alloc_hint++;
 }
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
 	__clear_bit(bit, table->bitmap);
+	table->alloc_hint = bit;
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-- 
2.35.1


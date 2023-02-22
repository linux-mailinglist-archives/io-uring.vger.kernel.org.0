Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3CC69F6BC
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjBVOjY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjBVOjW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:39:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8183803E;
        Wed, 22 Feb 2023 06:39:21 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r7so7797051wrz.6;
        Wed, 22 Feb 2023 06:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yqisb0p/1TgnFfChFg4hQVIMzPMIgaeBy+4V1ZQduJ4=;
        b=Fg0LA5G3eErF0j0+tGhZ9F2ZwjIou9MWYHnsZZbtNv/lNRl+rkgFrA2Tc9infoD9e5
         +15HKDFakYlv9lZiQCsj1qmClc8lWeS/HkiT5ZaWJnpgBN/HqJyC2j3WAi5d5EA4oVrc
         sAMI1q/GZVfTdR5YXHfHqkz7V1q5gfwU4mxUKz/mUa3GQvQlm9Pwjs2FMXDtvE2Pp4p+
         L0IXcCLFNCFa2sAEx1Mr5ig9Q+JXxDYbj03y2FfRDfKUKLN/vjvnRWFeBfbQOT9ePSKt
         o80GCrstl32fZhtCKotgPXlldos+JaKLyEHqAlTiUfmLXIh3QNhNzcS6bi8Tyxop7CtO
         9now==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yqisb0p/1TgnFfChFg4hQVIMzPMIgaeBy+4V1ZQduJ4=;
        b=htMdd9gq2chFCkHcTkv9trMK/jX8D+wOaazY1Pn2VSz6CLUiqZ+5XZ7YEIw4Ke/O3J
         hn2aK8uw4XNt0W/2rT/0SyNLRjhjsjulXQeSHgKDmokdnT8/OghMdEjhctqzwHc/2Bq9
         NEEMxVv0Tm9HLb7JclJjtK7ajCzOpGfkJBbbmnvN6zJdgAdjRli43JRwAe0UEur5YaQz
         PLyPlzwT2qKCZtlTp9ACx7C9gr3SQMbUWQOCzsn5XeAZAZsmjLE0YGZolxe5clhmgQai
         ApXKsaUF0tJ3DO1l4dvAR2ShckizUy3Kx0l0UbDbfUGuDwNt4YoUzsF2PXwbjOeQU/ON
         6xMQ==
X-Gm-Message-State: AO0yUKXwlkaU/JPomul/h6MnlFGR8RNe+UFMYEHLdPP4kBLnh8cCXJCY
        Hd+byopJi6AlAlMowFFflYoa7UE1CQo=
X-Google-Smtp-Source: AK7set/y6zFHJXaafEe6jphQJOgrhJdwRhp4l4WKN2gjsCRmWRGW28GWxZPNkzLOY3euHphGIKQYkQ==
X-Received: by 2002:a5d:6190:0:b0:2c7:a0b:e8d2 with SMTP id j16-20020a5d6190000000b002c70a0be8d2mr2569920wru.19.1677076759581;
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b002c59c6abc10sm8151735wrs.115.2023.02.22.06.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 4/4] io_uring/rsrc: optimise registered huge pages
Date:   Wed, 22 Feb 2023 14:36:51 +0000
Message-Id: <757a0c399774f23df5dbfe2e0cc79f7ea432b04c.1677041932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677041932.git.asml.silence@gmail.com>
References: <cover.1677041932.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When registering huge pages, internally io_uring will split them into
many PAGE_SIZE bvec entries. That's bad for performance as drivers need
to eventually dma-map the data and will do it individually for each bvec
entry. Coalesce huge pages into one large bvec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index ebbd2cea7582..aab1bc6883e9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1210,6 +1210,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
+	struct folio *folio;
 
 	*pimu = ctx->dummy_ubuf;
 	if (!iov->iov_base)
@@ -1224,6 +1225,21 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
+	/* If it's a huge page, try to coalesce them into a single bvec entry */
+	if (nr_pages > 1) {
+		folio = page_folio(pages[0]);
+		for (i = 1; i < nr_pages; i++) {
+			if (page_folio(pages[i]) != folio) {
+				folio = NULL;
+				break;
+			}
+		}
+		if (folio) {
+			folio_put_refs(folio, nr_pages - 1);
+			nr_pages = 1;
+		}
+	}
+
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
 		goto done;
@@ -1236,6 +1252,17 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 
 	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
 	size = iov->iov_len;
+	/* store original address for later verification */
+	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->ubuf_end = imu->ubuf + iov->iov_len;
+	imu->nr_bvecs = nr_pages;
+	*pimu = imu;
+	ret = 0;
+
+	if (folio) {
+		bvec_set_page(&imu->bvec[0], pages[0], size, off);
+		goto done;
+	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
@@ -1244,12 +1271,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		off = 0;
 		size -= vec_len;
 	}
-	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->ubuf_end = imu->ubuf + iov->iov_len;
-	imu->nr_bvecs = nr_pages;
-	*pimu = imu;
-	ret = 0;
 done:
 	if (ret)
 		kvfree(imu);
@@ -1364,6 +1385,11 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset <= bvec->bv_len) {
+			/*
+			 * Note, huge pages buffers consists of one large
+			 * bvec entry and should always go this way. The other
+			 * branch doesn't expect non PAGE_SIZE'd chunks.
+			 */
 			iter->bvec = bvec;
 			iter->nr_segs = bvec->bv_len;
 			iter->count -= offset;
-- 
2.39.1


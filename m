Return-Path: <io-uring+bounces-10918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA18C9D6EB
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B22C63A24E3
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6A322CBC0;
	Wed,  3 Dec 2025 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIbCe6/9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2CA22B594
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722230; cv=none; b=iSmWNKh3uhz3uD8FYxpjlqFdlSJGRY5qH4nkeR2T1DwAC5FVhbfCEhdOVAhjpYAC0WyeraGORloJPKmpDB4lddVvJaQutf9lJ18KskYjUMexs4vXgBe5BXhSxkbNCJe0Mzp2QHSIfzxCLJQdTxnb4vl2z8LF36/pGVEogmJFdWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722230; c=relaxed/simple;
	bh=Dx25h3qnu7ew3OFUNFY2J1netXwmriovnXf1iYGXQAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpQVz7edflNn9lZk0UhflrxlYrnI9Hppp+pvk5LoKW+ltzWkzJSg4OjpYIxwCcfdUw6G7AmYuU1nNgLq4sCTduyrsheeKADcmS2V0HiSO2vprFRYzhwV5HjF4dKDyHtxqqU71HdtIw/53mQa4L7ovWQfQY+4a6hFYcl+ychvGJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIbCe6/9; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so5451926b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722228; x=1765327028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bIdUku4rBjvfs+wizq/smO3ocS8rb/JwYKIUM74TRjQ=;
        b=jIbCe6/9mvs7VhTKu27G8TAoU9Gu9+4R5wwb+XTy8Ly0G07iyQh5wDGVLMS0MLYjxC
         Q/ex6jLhGFYtdLLx8yZU3Zx+ZVlxNdorK/mC8ywYfsofeU8cCeiSim4vZb1OFqv9gogl
         Im5SJdG2CYPPxcplBQW5cOrRd8wwQQxjBo7drGnOrtctRgwBUsO5UVmrL2s9ctm/R7v5
         VWUDOxkOfuxcLrzMJEnALYEVyJC/hsY/BQhrhGtKI3+5RmJ9CvlPKsazuoQPlxa1sSC2
         FUH9tJmY3gC8qUPEQ4ZO2oCnSaMEN8HBTeEnvoo/6ppM89ftgPmkZiClKLW+Gld1fIok
         AfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722228; x=1765327028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bIdUku4rBjvfs+wizq/smO3ocS8rb/JwYKIUM74TRjQ=;
        b=e1d9Dm8qcwuQy7e5qIhjlNvaBOHzYv+peyT0HVbtJNIMzI+klO9oXWSTQO0m78NbwK
         lgBcT3+rx4oW2XwaYEQOotuLmG9K433SsclI3BhkQ5DthI4c454Tyis1j+JIA22klULF
         yjrYO2Jn5RxgIneBBrymGp0cdgmReodjXP257qpyFIYnyY+OXFMM4n0KzVAlDSZuPcP6
         DMmlDsUdU/d0yFwoIsW3zIkNQXH6Mx56joP4dCAQyw3fq9KgJIDpCKRRu8y5ireZu9Vf
         wdIa/Y9y9hWC4WTTf6PrB+wYcOy58F4tUftOLt7JI8Q0cVeXzPDTZ6878LkiD/YxWr14
         E/4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbY6l28kWInSUUhDqCokub5tSU15NCrN6/5gWfpmL02YxaRkpdhR4FjmCwZSgNX0n15Nir+kHl1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEIyioGQSP/zHzdVX2/IzjyUG0XVI3XGMrYv64c11QnNg5cM/a
	5dgWTxo3lyIiHu653FtCaqjh8gkEgNdk2lSyA21UU7JtJK7m+zcleMfZ
X-Gm-Gg: ASbGncvDQoicx7BSBS7Q3IoaHCjNK5aXTfu/mfHjx592CuW4ASuyod+wQl+zdGnAFmx
	fn3oyGuqC/PIR6pFQtzFj2exN2hKqzGLNnaxXOuvEja74VhV7EhYhNw6eyc4pIHDfseftvGfLSf
	y/E8GURTG80MHDzYN4P7/tMkwtMc4pJrg4uOS1JdKm/GbWMJAPkQBkK6ECaz7AhIv2dogzPZEGD
	3W1vbr/mU0MBcJmD46+gqJtkG+2mHvZp0awMHICzwvKiDofuF+JZrU++S7XqA1VzQdPm9Z91CBw
	GyelozPLq7S1d4nsXxaaSJKVWJ/i/xeGQaidpyd4gzoq7+TuyfIv8uEx0doKQCpHmTV1ZkuIw4A
	mroV2lGTJF+taNiB5I1SP8VByVAkdRXolyyP9kd2thCLF6R5YBIPxBsE2z1AHSx8oq3e8Ibdv82
	YOmMRohafl3aozAUo+
X-Google-Smtp-Source: AGHT+IE6auAAGE2f4ZLl7pW0qxgTVrRLrFYp/xcdvbfLfBOMEj6TOzAL4zuRBQcasT88f/7+3OqbUg==
X-Received: by 2002:a05:6a00:813:b0:7a5:9cf5:b341 with SMTP id d2e1a72fcca58-7e00a2c7aa2mr476804b3a.7.1764722228179;
        Tue, 02 Dec 2025 16:37:08 -0800 (PST)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15f17602csm18206891b3a.56.2025.12.02.16.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:07 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 23/30] io_uring/rsrc: split io_buffer_register_request() logic
Date: Tue,  2 Dec 2025 16:35:18 -0800
Message-ID: <20251203003526.2889477-24-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the main initialization logic in io_buffer_register_request() into
a helper function.

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which will be reusing this logic.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rsrc.c | 80 +++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 32 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 59cafe63d187..18abba6f6b86 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -941,63 +941,79 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *rq,
-			       void (*release)(void *), unsigned int index,
-			       unsigned int issue_flags)
+static int io_buffer_init(struct io_ring_ctx *ctx, unsigned int nr_bvecs,
+			  unsigned int total_bytes, u8 dir,
+			  void (*release)(void *), void *priv,
+			  unsigned int index)
 {
 	struct io_rsrc_data *data = &ctx->buf_table;
-	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
-	struct bio_vec bv;
-	unsigned int nr_bvecs = 0;
-	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (index >= data->nr)
+		return -EINVAL;
 	index = array_index_nospec(index, data->nr);
 
-	if (data->nodes[index]) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	if (data->nodes[index])
+		return -EBUSY;
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
-	if (!node) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!node)
+		return -ENOMEM;
 
-	/*
-	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
-	 * but avoids needing to iterate over the bvecs
-	 */
-	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
+	imu = io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
-		ret = -ENOMEM;
-		goto unlock;
+		return -ENOMEM;
 	}
 
 	imu->ubuf = 0;
-	imu->len = blk_rq_bytes(rq);
+	imu->len = total_bytes;
 	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
+	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
-	imu->priv = rq;
+	imu->priv = priv;
 	imu->is_kbuf = true;
-	imu->dir = 1 << rq_data_dir(rq);
+	imu->dir = 1 << dir;
+
+	node->buf = imu;
+	data->nodes[index] = node;
+
+	return 0;
+}
+
+int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags)
+{
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec bv;
+	unsigned int nr_bvecs;
+	unsigned int total_bytes;
+	int ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	/*
+	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
+	 * but avoids needing to iterate over the bvecs
+	 */
+	nr_bvecs = blk_rq_nr_phys_segments(rq);
+	total_bytes = blk_rq_bytes(rq);
+	ret = io_buffer_init(ctx, nr_bvecs, total_bytes, rq_data_dir(rq), release, rq,
+			     index);
+	if (ret)
+		goto unlock;
 
+	imu = ctx->buf_table.nodes[index]->buf;
+	nr_bvecs = 0;
 	rq_for_each_bvec(bv, rq, rq_iter)
 		imu->bvec[nr_bvecs++] = bv;
 	imu->nr_bvecs = nr_bvecs;
 
-	node->buf = imu;
-	data->nodes[index] = node;
 unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
-- 
2.47.3



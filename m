Return-Path: <io-uring+bounces-3934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0DA9ABB9F
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F6C92835B9
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DBC45038;
	Wed, 23 Oct 2024 02:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhZeWIhu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7AB3E47B
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651070; cv=none; b=uKNBthVx/SOYhn6vE7Sb6sGJve5HKy4ptveUCWqtRHPDiYN5JXSOtt4KxXzZJCgEaHTSOZpIIYlK6UGrszi3HX3kay0Z4gg7h249VLWV87p6+PalQe6/tC1m1YwMF3A6nmPWhWH9RBx0attOk2LP1YXkEs6OY2x8EezoF72GemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651070; c=relaxed/simple;
	bh=wmy/0xUu8rdddj78sP03A17QHFp6S7LvaSQUEZU4HTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3Kp3BErb5/M7SPdvjSTMtjzILVyRQCbR9TZ63xwLbnFSiP6P1N6abBhblQd/l8MxHaVoTG/oIDVs9QwDC/jWlm/v6h44YWOdvDUHEvuWPKfazZeN4ItjXuKptVel4El4HRyyLu7ABXqC2IPMaNgJlhz4qCxg2gOlX99kGVRDZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhZeWIhu; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a0f198d38so870843166b.1
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651067; x=1730255867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZmFUg4K3Gqw0+UKGPY7kgfm/3RIi1Y7zSVrNyfsSM8=;
        b=mhZeWIhumtgz0JYhAnnBFAUBsC7YSX5de1+1SLsKk5WG28BDAjDtlCtWDYdfVdlBT5
         fQVQ/ePX8G47XzSAgCrIWg4bySLkChRlH3CDBq5P/EcZJIulEpmybLKd/RvHPcRjilPJ
         SjljfiQ8/rU/Btp+8kL+mUr5Z4SnK2CoZ4ArQVRlUDaI37uSFHWMQdUtM0gaBZY8+30e
         4twWGQg13AQcVs40mLC5SFT2WNTGKNhaRl0HCf30+axFr1+8g11ggdHeZO+o8XXpjvzZ
         eonRvXpzyeBxX6xi96OBFV56Mjyr81qmo9IVOimq32y8eQWfGPwqzPIkltuUdQGAHqM1
         bV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651067; x=1730255867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZmFUg4K3Gqw0+UKGPY7kgfm/3RIi1Y7zSVrNyfsSM8=;
        b=rGrBYeTTpODHSoL7RWZgyikWPPC2Ge4mSBXqEyn5F1Jkt21LPtRJCkrfuxo43uL7K/
         0HV5av3J4TVIa/m0IA1VWiOx4eL0wAOPLraCZ5rMiAm2C4P91B17U1OsiyH641KlJRd6
         q5rV36vvadAXJBr7dHGLOHkgM1bbg+m00pGavssBMTCBN6lam5lKt3TILlLQkaLQFqB6
         bANQg/z5Uj0l7kcwIIUQBos4KukVgtCPpWZmuisQwALrQaIDcs0+ZOG4ZjB0GniWBW2B
         cf5r7CcdFtm877dZNGvAR/laRHykQ09Mm77MNg0TXnO5tV+FIVeQtjGAvp1NoKuzsvUx
         FelQ==
X-Gm-Message-State: AOJu0YxPpyAzyU0kKt6X74JYpeiKNRhVBbe80Bh8rB3kGR1BiqggSOIu
	ErramuW2CfvNTv7LglULz3Sh+UKMtN0RNtDBiG/lD5KeFWB/5YRV8rjWww==
X-Google-Smtp-Source: AGHT+IFp/86cXf6G8J19MixL2hCyJGI2nPQizbSxWSSC9Y+ty4BD8aQo3VxSBYoTWWLcPY/Dj3ogWw==
X-Received: by 2002:a17:907:72d4:b0:a99:2ab0:d973 with SMTP id a640c23a62f3a-a9abf96ce13mr86143266b.55.1729651066640;
        Tue, 22 Oct 2024 19:37:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91371046sm410418766b.139.2024.10.22.19.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 19:37:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: vectored registered buffer import
Date: Wed, 23 Oct 2024 03:38:20 +0100
Message-ID: <2b49bea692514ef41d9e5cdd3a1516caf7eacd98.1729650350.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729650350.git.asml.silence@gmail.com>
References: <cover.1729650350.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper that takes a registered buffer and an iovec with addresses
pointing into that registered buffer, and return a new bvec
corresponding to the given iovec. Essentially, each iov entry is
resolved into a bvec array, which gives us an array of arrays of struct
bio_vec, which the function flattens into a single long bvec.

Note, max_segs is overestimated, that can be improved later. The
allocation also can be optimised by doing it inline into the same array.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h |  3 +++
 2 files changed, 63 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fa5f27496aef..6f9f3cb4a2ef 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1085,6 +1085,66 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+struct bio_vec *io_import_fixed_vec(int ddir, struct iov_iter *iter,
+				    struct io_mapped_ubuf *imu,
+				    struct iovec *iovec, int nr_iovs)
+{
+	unsigned long folio_size = (1 << imu->folio_shift);
+	unsigned long folio_mask = folio_size - 1;
+	struct bio_vec *res_bvec;
+	size_t total_len = 0;
+	int max_segs = 0;
+	int bvec_idx = 0;
+	int iov_idx;
+
+	if (WARN_ON_ONCE(!imu))
+		return ERR_PTR(-EFAULT);
+
+	for (iov_idx = 0; iov_idx < nr_iovs; iov_idx++) {
+		size_t iov_len = iovec[iov_idx].iov_len;
+		u64 buf_addr = (u64)iovec[iov_idx].iov_base;
+		u64 buf_end;
+
+		if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &buf_end)))
+			return ERR_PTR(-EFAULT);
+		/* not inside the mapped region */
+		if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
+			return ERR_PTR(-EFAULT);
+		max_segs += (iov_len >> imu->folio_shift) + 2;
+	}
+
+	res_bvec = kmalloc_array(max_segs, sizeof(*res_bvec), GFP_KERNEL);
+	if (!res_bvec)
+		return ERR_PTR(-ENOMEM);
+
+	for (iov_idx = 0; iov_idx < nr_iovs; iov_idx++) {
+		size_t iov_len = iovec[iov_idx].iov_len;
+		u64 buf_addr = (u64)iovec[iov_idx].iov_base;
+		u64 folio_addr = imu->ubuf & ~folio_mask;
+		struct bio_vec *src_bvec;
+		size_t offset;
+
+		total_len += iov_len;
+		/* by using folio address it also accounts for bvec offset */
+		offset = buf_addr - folio_addr;
+		src_bvec = imu->bvec + (offset >> imu->folio_shift);
+		offset &= folio_mask;
+
+		for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
+			size_t seg_size = min_t(size_t, iov_len,
+						folio_size - offset);
+
+			res_bvec[bvec_idx].bv_page = src_bvec->bv_page;
+			res_bvec[bvec_idx].bv_offset = offset;
+			res_bvec[bvec_idx].bv_len = seg_size;
+			iov_len -= seg_size;
+		}
+	}
+
+	iov_iter_bvec(iter, ddir, res_bvec, bvec_idx, total_len);
+	return res_bvec;
+}
+
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8ed588036210..675161cf8b92 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -66,6 +66,9 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc);
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len);
+struct bio_vec *io_import_fixed_vec(int ddir, struct iov_iter *iter,
+				    struct io_mapped_ubuf *imu,
+				    struct iovec *iovec, int nr_iovs);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
-- 
2.46.0



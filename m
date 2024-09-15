Return-Path: <io-uring+bounces-3191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC1B97977D
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 17:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35971C20E35
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 15:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2678018B04;
	Sun, 15 Sep 2024 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t29wSH1E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304661C8FA6
	for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726413804; cv=none; b=XI6ms+hHAUjMv5KnZowmccZ0tKaIFTLaDTc0Yu5cCFZbKtft4/sbzN6rv2Rpk+Zjnl85JUCvN8VrPRU5l28qrwGusED+6CEPOXOm3HlLetOSd7zU7gc9si4fi4NRj5cwRA9pULCTN5CUKw9w4Sh6W4gzPz9TvvHZuq8oCJIKdiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726413804; c=relaxed/simple;
	bh=PFVEqTRwmoEFJ58JZGtxCQiSxQGvZyj2plGvAfO8If4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcVICgmrUqCEaXbQ0XwGtv8TNtXEKs1Nimz8nW6WjErKdUwwSPxhEbchFnHWq6hT4fi+pF+sLdn5BxaPh6PWMmY4vIeX5ATPGTr90YXkak7S0Cd/9bMtnHcMbxC8JmGNNRraU1IdW2Gcza8RhE4gvSjqKdt4biYg8Srme+9keUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t29wSH1E; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-201d5af11a4so41076535ad.3
        for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726413801; x=1727018601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ltK6eCpctxMLHRTitX0PPoUMOCF4iLvkdaO1XE7mEM=;
        b=t29wSH1EMIhSHfbCeSBRwQ4l6LlXGmw42BO5PkX0JpZcpXjhLrL6GqDhxD3AzPylHR
         FTGfhswgD2PcdJysbXXaHS/s8qBW5Srhq3nHEK4Ur7PSGFoC3euOjQv6r13GZJzN64P3
         UhAntVp6t8O8SVxsFD548Nzi+spTjr8lzoqcRpgno0AbMpkK86OkQvbFqz10PvSFAOxs
         /AOicPM4xfCDGS16pgGHIriwhRlVJDJhyK62zhITg+04Tw4zeTlEDQ8hJrFGN3jrK3sM
         sWtU3HzoXPy8mAZu63zJdGMXmjj3UDPaULTD+rGD/+hFwukGYI4/bfUTLP+OJaDUFujR
         NlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726413801; x=1727018601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ltK6eCpctxMLHRTitX0PPoUMOCF4iLvkdaO1XE7mEM=;
        b=utMgzOcHvNmsixtw7gSe4l21OV0tROiHdOxTv65ORTVBEyVJIACBU/mpwzBqWH86yY
         z59cTh9+sztIFfkK89GhDnqBAJIlJaxA0EBSmh/1cdJZkDGjOPPDCTqaKG6UMrsqrIX/
         8YipHZSfDQyFOCUflzL9bd/hG4UyzdCy9RzuKp09rcuy0ualvIEFUJmrsB+5p43SFxYo
         1S6KMWYmKbpKzSgNeINBv2pa/yrs4FuL3f2gavCBYViup3iZ3UuuYzi02c2r62Rn6z8R
         P17W4hdtJWvNtgJ1zt6OrFLYhqnBB6TI2SoFm5cIG5EbA3LSpqnmJcbHlGR9HHliyKwl
         97kA==
X-Gm-Message-State: AOJu0YyuJ6l5V60wtrD6vuW+9Nk37CR615U2y6hxjrqZShxsiwjHNuzJ
	3bJ6HOgvSchBjJk8O2DAdoOZyZ0MILklBiA1JDoKy7FdhAnEX89tTc4/yHVb5lLeNAEzPz99nip
	w
X-Google-Smtp-Source: AGHT+IE0orYMTeXqQj55khnbxu0K4XohcoplOtOPdMtkKE9bMN5ME2TZa3dlwpgh36AWl+9LR/dqdQ==
X-Received: by 2002:a17:902:d4cd:b0:1fd:8eaf:ea73 with SMTP id d9443c01a7336-2076e393a6amr192304475ad.35.1726413800863;
        Sun, 15 Sep 2024 08:23:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207964a5ec4sm22083755ad.232.2024.09.15.08.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 08:23:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: cliang01.li@samsung.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/rsrc: get rid of io_mapped_ubuf->folio_mask
Date: Sun, 15 Sep 2024 09:22:34 -0600
Message-ID: <20240915152315.821382-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240915152315.821382-1-axboe@kernel.dk>
References: <20240915152315.821382-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't really need to cache this, let's reclaim 8 bytes from struct
io_mapped_ubuf and just calculate it when we need it. The only hot path
here is io_import_fixed().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 9 +++------
 io_uring/rsrc.h | 1 -
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9264e555ae59..2477995e2d65 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -988,13 +988,10 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
-	imu->folio_mask = PAGE_MASK;
-	if (coalesced) {
+	if (coalesced)
 		imu->folio_shift = data.folio_shift;
-		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
-	}
 	refcount_set(&imu->refs, 1);
-	off = (unsigned long) iov->iov_base & ~imu->folio_mask;
+	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
 	*pimu = imu;
 	ret = 0;
 
@@ -1132,7 +1129,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~imu->folio_mask;
+			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
 		}
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index eb4803e473b0..e290d2be3285 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -46,7 +46,6 @@ struct io_mapped_ubuf {
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
 	unsigned long	acct_pages;
-	unsigned long   folio_mask;
 	refcount_t	refs;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
-- 
2.45.2



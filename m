Return-Path: <io-uring+bounces-3149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F64F975B57
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5207C1C22292
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB9E1B7917;
	Wed, 11 Sep 2024 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vKyIsyx3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19721B6520
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085237; cv=none; b=quxbURpT4ZuLR1J/Clv4GzBWLFBU2WbfacNiICiGkMWhZH8w2oZofOuh+r+xieHdhyQXGnKH5TUlqsAPymUV8kpbCOWLVsaUIETBlyAOVsQ3Ypvumqgkgd5pXr7sEpuGk4dlB0O/pCr8OiI2tHEBkgbjk69/eERr/1hfi7nWSqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085237; c=relaxed/simple;
	bh=GM5rez7i8AcYityEiDjC4PZI1ccMmlLlITNVJtUHxTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBvHn5xM/5sa5WFFdhxY9+BASlAp1T9vLXbQEQzOn1zUaB8n3FdW/MLazSxMjj9zqA9zwePu60IiOn24Gk0aE5uSOixo3bxhsdHs1V1g3ihLmCJjhYsmX9VoR5vrGusHKlY7tpMrYIrEwT/asy+aw/LArywXFqC/9j2FX8TqB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vKyIsyx3; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82cd869453eso9070739f.0
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726085233; x=1726690033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=vKyIsyx3i8UHOK7MTPFJ/QnN1Iewad1PhoysqdyFdx416vttKmEs2y1kYrcH56Ecfk
         rFs/YLeGOtec+uwrlwqv8maGdXOV993NcZrCxawtEY9f5GEhYPJFRgo6MC1AXpdsXSUF
         VCsYpuGt3p8lpVqUme3HsYMj3+fa75ld89nON6ylCwH1wOkVrkJ44LtK85WjRlhJKMtd
         lKVKRQFgUCAUWJ0KMRXVtQiGq/ja8xs3sscQnt4FCxcSCQkBLrxw43N19Lf6qijRGkpU
         87lIdEgoS0bEkLkYUWy/WB4tOo3vXL4QEFdLUnOYTcTD5ozZ3F5nNr14qo7gWJKNDwpg
         l9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085233; x=1726690033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=w3kFzHVYXgtRqYMLf3j/eFZ26nuZF6Jk6bvQOxuZAw+BdcH1U6euCZlvss4/yb/kAT
         lGmEW/oRitQnHqbfht3Y6YDQ26sLvaoqPN2jfOKen1bmZ5xgN/WNIAx973elxf8SRrGm
         cj1rC33/BDOZXz+eBnlgkXm97+stEztxiOI6ImkrHRAczwI9Kp/bv113Pgsn4MtaEicd
         KOAPvfYSSPyaxbb+stmWoBx8RWRaS3Gp1eg2zvSfAt2h+9Ql0Gc3RTEiaHfRigHyDXAQ
         fc4m/rVxsD6VMf6KDJfr5dMkN1nRQUZV25JdTiW2QyKDTSe9Wsr4bNu+7Pda/ehWHv7Y
         /GxA==
X-Gm-Message-State: AOJu0YwyxAS42KeTQ4K+jDppHF1gRacWCsq1jlgq1jINazTD8Iq2LJTX
	g30NbM69MKmyXejQrKREHwNhwHdGjL9xd6NQMFqnbFaFQZYw4PdbD8pNzwbjJlTGFYdhvdFWQsr
	cO0U=
X-Google-Smtp-Source: AGHT+IGBYqW2ZAz0z/30zJzJ6WIo1Ls3V4PGZj322ssfjujSLuo+ksg/iQXsomqCQP5GhKmUdnwD8w==
X-Received: by 2002:a05:6602:6d13:b0:82c:f30d:fc72 with SMTP id ca18e2360f4ac-82d1f8b72dfmr118386039f.2.1726085233383;
        Wed, 11 Sep 2024 13:07:13 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa733a1d6sm289860239f.1.2024.09.11.13.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:07:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/rsrc: add reference count to struct io_mapped_ubuf
Date: Wed, 11 Sep 2024 14:03:53 -0600
Message-ID: <20240911200705.392343-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911200705.392343-1-axboe@kernel.dk>
References: <20240911200705.392343-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there's a single ring owner of a mapped buffer, and hence the
reference count will always be 1 when it's torn down and freed. However,
in preparation for being able to link io_mapped_ubuf to different spots,
add a reference count to manage the lifetime of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 3 +++
 io_uring/rsrc.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d42114845fac..28f98de3c304 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -116,6 +116,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 
 	*slot = NULL;
 	if (imu != &dummy_ubuf) {
+		if (!refcount_dec_and_test(&imu->refs))
+			return;
 		for (i = 0; i < imu->nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
@@ -990,6 +992,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		imu->folio_shift = data.folio_shift;
 		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
 	}
+	refcount_set(&imu->refs, 1);
 	off = (unsigned long) iov->iov_base & ~imu->folio_mask;
 	*pimu = imu;
 	ret = 0;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 3d0dda3556e6..98a253172c27 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -47,6 +47,7 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	unsigned long	acct_pages;
 	unsigned long   folio_mask;
+	refcount_t	refs;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.45.2



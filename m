Return-Path: <io-uring+bounces-3154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EB96975BC1
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD423B219DA
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC32F1A3031;
	Wed, 11 Sep 2024 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PgW6H4/q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7DB14386D
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726086630; cv=none; b=kEzv9HT9NDgz/XIvc4Bv+9SlIMZnTVdgPnfiUznDRsfTCZjMpfG696F3H8Hj0YumqMW/OqPKlixxwney9H4mUoBE+LG8yAcpv0lYr1o2L7t/TxqxtXz725ePOmmxDAb+Sa8fzbgXL/ttoUPrJ57JIaZZk0xzTJkCi6qZn3nt/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726086630; c=relaxed/simple;
	bh=GM5rez7i8AcYityEiDjC4PZI1ccMmlLlITNVJtUHxTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgigX1msdEsW5fTIA/rrJN2iG+EdJbphVRiUf0MMkXE3S2dFAItE3WzGV+M/AkCqZDx4CHft8/I02E7HILRPMYsD7CThIlJgpGl4S/G23Og6mYczNNMiSkO9wzT7P8oKhyW46Pu4ibS0Zts0TLylyLn+cxs1tAKgovnmQppuzn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PgW6H4/q; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-829f7911eecso9070339f.1
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726086626; x=1726691426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=PgW6H4/qfR+fa9xRZpxB10Iqm1WYklhlFnH1/QJsvq8qFc1eefkO5dxv4Cn4Q5I9UB
         BOogPXJRwg3rR2CEAPcIVQdiTNj8ZOyz6PePDkHF5RAeF5DqPXuoG7cmczdn4vdsJDU6
         4/wKzg0HLntMBossAa8pkmDP9xpK72ROkgsdmnDnvwZ/zqpqg7/GuLMnN0hNPCSUn8VU
         AmH2PvE5a0lXdTyX/mWy4bbTla5ncaFUFHvPrIqaceQfNreNiRmmnvBsKiusPXob5X01
         50L3IKPyss14T11WR+K4oTxDnkQxKfmvx1+am6miNpoQiRR6NirNd9WsfVdccEBXCSI9
         LAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726086626; x=1726691426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=tIdaoK2sFGviMIcFpJx8I/wBmChIeZi3i2HiUOP4JAnb6jriDGdXz8yWMfm25+CDwJ
         ZR+q1r3MIk6IGjUn/8IaI5W+wNv8qcfbdolX6Ot+LfqsOweSnPo94GrdEkEW2InoURh6
         pndFTnacrCFGK9kS8GgS4Ck/ogPA1nPQvejW/yyigcDnVy1e1k5xFxO8gy7Ww6KhnK4f
         9lt1AxSL0w84+8g7J0ZIX+4qug/9ngVhTvvx3Ci1Yh2skkiY0PQXo4layHuw9RH5DT16
         r/aGOxKSfq2bUV/VxNm2Ml0CEIb6Cop5kR9bvHl4mbqSkITNtoLq/UoFA/Pv55KAaFUb
         xwHQ==
X-Gm-Message-State: AOJu0YyhIvuZsw0TzWMutaoMZ6rJYxG9HDF/FJWXi717kGNnS2fS7OhF
	Gfg0HL/FSi6eft7IUWqDO047mnAePpyC5b5xeVgE6S/24vQMVu4/HnLtppNEYMOS0ljX9SWUIA+
	BLRI=
X-Google-Smtp-Source: AGHT+IE8QSi7rRuxJXP5MFAxMTfbnQXLmVdlh+6QaifvAXACmGm3dL5U8hEkzzPEc/nh4bKy5p5qtw==
X-Received: by 2002:a05:6e02:1a88:b0:3a0:80c6:367 with SMTP id e9e14a558f8ab-3a084931e1emr4426075ab.19.1726086626610;
        Wed, 11 Sep 2024 13:30:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433d60sm185173173.26.2024.09.11.13.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:30:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/rsrc: add reference count to struct io_mapped_ubuf
Date: Wed, 11 Sep 2024 14:29:40 -0600
Message-ID: <20240911203021.416244-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911203021.416244-1-axboe@kernel.dk>
References: <20240911203021.416244-1-axboe@kernel.dk>
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



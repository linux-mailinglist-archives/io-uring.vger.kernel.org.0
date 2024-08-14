Return-Path: <io-uring+bounces-2766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 140F495194E
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C59FE2852F5
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1441AED22;
	Wed, 14 Aug 2024 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhBIQJ4M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00661448D4;
	Wed, 14 Aug 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632330; cv=none; b=oI28P77ixu5O3VveWWvuBod5Mxl3rYjjOhHmYWEyS5UwmKGruiwdceVoTRpnmhddvURWlh86jyrivC3/EqyM2CVPraOk22kCjaC/XRQWl7/O012geSsORzZ4P80B7ojPmEzkXswNwP25Lg1XcF5EZ3FV+2hhdtuoyUBF70FvRlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632330; c=relaxed/simple;
	bh=u3n4zzz10biwWSRIUfBz8MlJPLdBSaqHZ7gqivjEoC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOJXvox6oW8hM/tWxKFWG7c9EK8dl5VfWZdM1IL03Rs+ICLg/aDIOOEQw/Q1QCIU26rOYU5xUnDfbsLp1p6S/YbA/dNRfS6FYOo1EXpJXqJ8txqh/wAKo1CKMYVDqHQm2izw4YpqL+JBpmtXQA2qJxzYei3/yoipev7gb/owTv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GhBIQJ4M; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7ad02501c3so778841466b.2;
        Wed, 14 Aug 2024 03:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632327; x=1724237127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvJpr7p454Y/UfNPCoQA/axDAfLDDtHMeofcmIJVphY=;
        b=GhBIQJ4MCSlsJF2LpP+qfSjtNFQsfpCeIVggH5KwmIjla2A5BFnLC7hv7qDbxGg2yw
         pbDim5hjT29SX0gQqBT680NdWwQgDQZKTS6ZG4+zexllpb6Cz8UoxW0ZC3iV5jffa5+z
         nUjzlEAkr2Pb5TAmV84ysPyXnOmu68erh7pQOABc0SqSlI9b/Kn7ayT1Hb6yUAyE4wTy
         FquT432h4R8zSDFBRAkmhrcGBQnoZ1LkeWPEA8B2xNZ+5IrIFGoV/sD/34ETlcjKv9iH
         liONV2NWTbup5IZyoovyI6ISi0yThmj6HnEwg/GDXOSeU80WIXJyaUYA0++rNKJ/E6qg
         SrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632327; x=1724237127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvJpr7p454Y/UfNPCoQA/axDAfLDDtHMeofcmIJVphY=;
        b=nmqS4Ay989UcgykCa6JtGkFg0uGrC7tOlQwve1QcOhb0ZUVJEOL4SSTeJCThfF4dVC
         DsQOtMfeWWNh9binZohaRT20QMJoHJR9y+6ZMAHSkGlJUGZv+hhTMGyy8opGhKU907Zw
         9+Mse0Ljf8p9zEA1bMAOOe578N+Qq/504Cu+obecvn7uSFAYGfSoa83YnL/3c++ppQgM
         m877Rle1ax6U6RwZdwyXkiGwrzvrY3l+O8es4dRPN+TmFiTR9Gr2jsP2Cd8ddesFeSnn
         YX+zOC1UCnLGB7ZY5e6GbCFgMaeqrrI5hmWthhSePTrB3rIxWcufgpcPZDTmIparp4cU
         pBcg==
X-Forwarded-Encrypted: i=1; AJvYcCWSsJqr4PSbrc78s8QR0G2+fCT0leSHcPW5eL4RT+8M8tgy7VD13a7Ry0FDWTwGRfoXNsc4ZU7XNZBk6/jVlLdPlaI4valZV/m5NSs=
X-Gm-Message-State: AOJu0YwYN3rmVhF3T7m/pwr8DHGGxQaDCijqBvhvmKKVmtHWTeB0SjEY
	87wvfCMwkMzsRd2WXyR3rOd5oH7DKhBaQguyEnnmWolv/oOAOCIcgpVpsk0H
X-Google-Smtp-Source: AGHT+IF5x7vVq+APZiVW0Zf/kYmxy4TtcaaAPS1Fj1piCtyS5MQvRUzOqgbF+0Kt0wNs5ja3bp6E1A==
X-Received: by 2002:a17:907:e601:b0:a7a:c197:8701 with SMTP id a640c23a62f3a-a8366d5b86cmr180254766b.31.1723632326621;
        Wed, 14 Aug 2024 03:45:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 4/5] block: introduce blk_validate_discard()
Date: Wed, 14 Aug 2024 11:45:53 +0100
Message-ID: <41ac9ff000cbd47fd8e386ee70e8049c3ac80ead.1723601134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723601133.git.asml.silence@gmail.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to further changes extract a helper function out of
blk_ioctl_discard() that validates discard arguments.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e8e4a4190f18..c7a3e6c6f5fa 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -92,39 +92,50 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
-static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
-		unsigned long arg)
+static int blk_validate_discard(struct block_device *bdev, blk_mode_t mode,
+				uint64_t start, uint64_t len)
 {
-	unsigned int bs_mask = bdev_logical_block_size(bdev) - 1;
-	uint64_t range[2], start, len, end;
-	struct bio *prev = NULL, *bio;
-	sector_t sector, nr_sects;
-	struct blk_plug plug;
-	int err;
+	unsigned int bs_mask;
+	uint64_t end;
 
 	if (!(mode & BLK_OPEN_WRITE))
 		return -EBADF;
-
 	if (!bdev_max_discard_sectors(bdev))
 		return -EOPNOTSUPP;
 	if (bdev_read_only(bdev))
 		return -EPERM;
 
-	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
-		return -EFAULT;
-
-	start = range[0];
-	len = range[1];
-
-	if (!len)
-		return -EINVAL;
+	bs_mask = bdev_logical_block_size(bdev) - 1;
 	if ((start | len) & bs_mask)
 		return -EINVAL;
+	if (!len)
+		return -EINVAL;
 
 	if (check_add_overflow(start, len, &end) ||
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	return 0;
+}
+
+static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
+		unsigned long arg)
+{
+	uint64_t range[2], start, len;
+	struct bio *prev = NULL, *bio;
+	sector_t sector, nr_sects;
+	struct blk_plug plug;
+	int err;
+
+	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+		return -EFAULT;
+	start = range[0];
+	len = range[1];
+
+	err = blk_validate_discard(bdev, mode, start, len);
+	if (err)
+		return err;
+
 	filemap_invalidate_lock(bdev->bd_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
 	if (err)
-- 
2.45.2



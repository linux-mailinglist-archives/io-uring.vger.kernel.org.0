Return-Path: <io-uring+bounces-3022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D3696C007
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E530A1F2610E
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C4F1E1303;
	Wed,  4 Sep 2024 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fw5HBQgH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7A1DB53C;
	Wed,  4 Sep 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459472; cv=none; b=fCVnf2vBuKK0w1nXkwwDnblsARVHlrznDReCl8kSAi9FMAQM4cvdRx1UT4cTfc9AoubFWwikOn9FKXWjbdZSwQov70gw9+1ZaP23NBMcGYd/AuKoqPrCUiY66hS54z8Z613SaOl1lKzUYMoBcDoX/0VdRHyrO/YNObPY2Hi4Bdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459472; c=relaxed/simple;
	bh=hjZDHvkTsBuwkkkqnazOc/370IgWi6PLEmiOKefcDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=np+oAN9qyi7PUk7M6YU/x3xCRAPLurhywDKzEnrDE6pg0VFydjlVcix949vGt6H57YtFrFZLwiKxcBGL0chDN12saZLqKCmetDQowAt9PdErpCQnHJEGJGzdKVpnBdBKZ8BG+VcBvStnZlSqOjyar5i2eadzjYyhCdJIRLvfbWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fw5HBQgH; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa69dso6224602a12.3;
        Wed, 04 Sep 2024 07:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459469; x=1726064269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCQ1sFR6q4N5GvvlFRQ23FRxGveAlTZ5FLsIiX1fOqY=;
        b=fw5HBQgHIRDoHiuG4hzNdI9ssLFW8Mfr97WJvinnJ6pL2ADXeXOu25NoMuosss2/4e
         xlFHPYar4CgBSNqX4NT/rv5yL0yz38EjwmSGTDdYZ7rQ7/NC+PZGYgc2KIkPqy45swtN
         u7Aq8k4DWc/xnx06Z9htIpYqq01jgkgW1B3mMymxt/viZRZfRNOYug5HSCESFADqKuOx
         Ex3sBBMmK0jFtu3H5iYDh+PjAcGHA5hhFRIIuLFgYPpBDA5vbgd4F0JRd+Uy+6dON8Nm
         /lG840iQafEHdfHDGH9A9kDioq40tWKATQy+/4hH0AHHQugOZ454Yip3xaRRY90/Ux1q
         Xx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459469; x=1726064269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCQ1sFR6q4N5GvvlFRQ23FRxGveAlTZ5FLsIiX1fOqY=;
        b=n0cd2UgqTaBv8Q4Wqwk8bSLJJrHEl9Ecs3KcbQIGRvflcnZKF8/tiuGKZmBMVxonSh
         ckY/TPop5fTxaYBK9FN3CmsDJtfjib0R8TT0uoFnP421UgN/y3BnbGBcInO1MrFuzdSb
         s//wVwHfjLCiBFsBFEU1X1ziA4za/Mo7aF5trqDGwcpHmOWIz4U502in5fQiG62KiS8d
         l6pQVsb30TIWSQ6jZJTmECZnYEV/iUR5Lnh7Gl1y0RjWS4wfG24t6PVwngX7/NNr0iKm
         rUrZDonCjKeTYENcRRp5NdOfQhA7JPVnQ2JkXtG4BmptW9cv3OQS2/rHT+mGg5/LaJpg
         tBSA==
X-Forwarded-Encrypted: i=1; AJvYcCV1Za7D3JkoD2y2+b2fEh/4lzp9B8xBr9HqACdL0SaEHM+x728EnIskCIHp++lO0wSECHv9meh0XG70Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbJ6BqcSyYW7ciaALZ1VJkFFtGq/JRHctqC/fgqmrYZ7UaTyM0
	YqY5rTwEnCqhNNfdVO35Pe3A1hfHsW7tNIB6F/6ilytjjf17YsvJ22Be+QPR
X-Google-Smtp-Source: AGHT+IEHqBvvipKDt3pVc4/T+6L4m8BSlDWTikVIuwjQS1tXdrsvfLbUudOAA51rWESeq0to4VuuuA==
X-Received: by 2002:a17:907:6d02:b0:a86:a866:9e25 with SMTP id a640c23a62f3a-a89b9727ea8mr1148556666b.56.1725459468821;
        Wed, 04 Sep 2024 07:17:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 4/8] block: introduce blk_validate_byte_range()
Date: Wed,  4 Sep 2024 15:18:03 +0100
Message-ID: <fa8054b786555785c7a181fbd977539342960fe4.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725459175.git.asml.silence@gmail.com>
References: <cover.1725459175.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to further changes extract a helper function out of
blk_ioctl_discard() that validates if we can do IO against the given
range of disk byte addresses.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e8e4a4190f18..a820f692dd1c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -92,38 +92,46 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
+static int blk_validate_byte_range(struct block_device *bdev,
+				   uint64_t start, uint64_t len)
+{
+	unsigned int bs_mask = bdev_logical_block_size(bdev) - 1;
+	uint64_t end;
+
+	if ((start | len) & bs_mask)
+		return -EINVAL;
+	if (!len)
+		return -EINVAL;
+	if (check_add_overflow(start, len, &end) || end > bdev_nr_bytes(bdev))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
-	unsigned int bs_mask = bdev_logical_block_size(bdev) - 1;
-	uint64_t range[2], start, len, end;
+	uint64_t range[2], start, len;
 	struct bio *prev = NULL, *bio;
 	sector_t sector, nr_sects;
 	struct blk_plug plug;
 	int err;
 
-	if (!(mode & BLK_OPEN_WRITE))
-		return -EBADF;
-
-	if (!bdev_max_discard_sectors(bdev))
-		return -EOPNOTSUPP;
-	if (bdev_read_only(bdev))
-		return -EPERM;
-
 	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
 		return -EFAULT;
-
 	start = range[0];
 	len = range[1];
 
-	if (!len)
-		return -EINVAL;
-	if ((start | len) & bs_mask)
-		return -EINVAL;
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
 
-	if (check_add_overflow(start, len, &end) ||
-	    end > bdev_nr_bytes(bdev))
-		return -EINVAL;
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	err = blk_validate_byte_range(bdev, start, len);
+	if (err)
+		return err;
 
 	filemap_invalidate_lock(bdev->bd_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
-- 
2.45.2



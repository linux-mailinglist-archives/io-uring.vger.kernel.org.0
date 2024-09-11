Return-Path: <io-uring+bounces-3142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A76975885
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3EBD28863C
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4281B141B;
	Wed, 11 Sep 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDMavKUa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB651AB6FE;
	Wed, 11 Sep 2024 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072469; cv=none; b=cTvxwtwnc+ATG1btuDK4k+ftRx8y71W67+gsbned6iuU8r7yvW75axWL6v3wEJOL67wJqv7RwEQl9bH/JxFBPbHxtNYt2EtTZp0RBLHDsO1fqpypi08TywJVohv9IY0+dOKxWfrGxHpKy3EXaE8pobvrJ3XRExzzhpfNQ6Gl1bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072469; c=relaxed/simple;
	bh=NsxbMHzpxEJqp1hRxkl/Mk3cVq+Wxp/7/7/GHuqLwVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFPQ0AfirT+EeItxQYc6fGZOpLmih2jRKfSPztYoaiIzi9fMS4R4E2fCA/pQPU39TmhwZanYNyVvYSB7lsUlWa9ZWuL1qCB3ePbGe1aGredl0VlaTASINdbirJhAvBEzP+5BsdJEiAdux9Hy68z0bA/+mWhH46fQrFXYVLthOVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDMavKUa; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a90188ae58eso3537166b.1;
        Wed, 11 Sep 2024 09:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072466; x=1726677266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1ilgt3VEuuXKV+jcKbpBuwPBu7e3oK2wW8bPbjcXIU=;
        b=JDMavKUa7qJaADOOt8aPhSlM0oUKcrYIwtbOTGRt0ldOuxib3CRYCADlx3fHLu9PoL
         Rvx3NHrvm/N/mlB2s30gt78ViYahUYrcu1v00Z6WdYHCjQf3974T6LC8030Ev4zL+Iz4
         8wdgREWMtRSbnGz6qxeIJVY6owc5Hy1i2sJaDUTABL2LZceGrj+2aGjorIHSTDMSbhHP
         Bw2ThRQiFYJr6cNL3mnzKyVZJ+lRq5nOTbgdO/P2GBYvobMfauBj+RIIwsWOrplmlW+J
         74eQwfgcHgQTLNtIyYinDMq3mriNNPAz68xKszAy74jz08LQ9HNpPeS/T3MfTBccNqCk
         5hEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072466; x=1726677266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1ilgt3VEuuXKV+jcKbpBuwPBu7e3oK2wW8bPbjcXIU=;
        b=CXZ9/J+rBD9q7p0igSeI/mHNkakxpvKz/ehWBpxoZpVwTZD31fUdJWBxP6FnnnrKXS
         +ABeCgPqxZIVby7gGOGOTnTAxg7cppt8O9+fpzXwGo2rnhdspTppvq5tu6XR5WST0BE9
         J1EkEh57G+zEFgiSYSxQpDVftQaRPKq/Bji55123Va9gVJOOn7wF9nGsRidEWOC6eoB1
         1vH7Dly8/TWHqnVYrRX1+136scCdJb1GT95RsO3YAkoKprMmBo51+gjQKH/EK6Oo92tI
         /KrdR/trE49lPLqFohGC/fxoWidOhniAdFwXzCPpb3U4fTn5cPkOk77c4/YfSIGRPo9f
         49OA==
X-Forwarded-Encrypted: i=1; AJvYcCWlekmbnwJFXA760hdqIw3KgzLJHYYsp9G65utFEWOnypB0hCoyEpmvwaeK9BwTfPGnIo3k+iG+FC4iwA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yym/V1Rj5EIjNZVHWPpEsCRbaTQLGhS3LFPjFj3kacyC9iJEb2S
	Iw7wS2PMTn2NIrNHNIEhYtmG2m83KG+PcJl9amSEqkGQuOdDwy4lt4Hdenqf
X-Google-Smtp-Source: AGHT+IFotWTb4zxEeL7XJDWd5BKSyUFpJRfVXT5ql2T0pZNPygKiYk4YlGgrsyP58zfDitbg48lEeQ==
X-Received: by 2002:a17:907:d3cf:b0:a8d:2d35:3dc6 with SMTP id a640c23a62f3a-a902945f284mr8613966b.26.1726072465802;
        Wed, 11 Sep 2024 09:34:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 4/8] block: introduce blk_validate_byte_range()
Date: Wed, 11 Sep 2024 17:34:40 +0100
Message-ID: <19a7779323c71e742a2f511e4cf49efcfd68cfd4.1726072086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1726072086.git.asml.silence@gmail.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
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
 block/ioctl.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e8e4a4190f18..6d663d6ae036 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -92,38 +92,51 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
+/*
+ * Check that [start, start + len) is a valid range from the block device's
+ * perspective, including verifying that it can be correctly translated into
+ * logical block addresses.
+ */
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



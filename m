Return-Path: <io-uring+bounces-3024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AFA296C00B
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9BC1C2503A
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130861D79B3;
	Wed,  4 Sep 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSm4NMN2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417891DB53C;
	Wed,  4 Sep 2024 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459475; cv=none; b=TGQOKF/fWXzyIKgE5qw7GcfDjI2KrIyUf1hzpr0T+63fV/CaOAmGkRArDk8ev40eOSS/Ocytyeza1tbCkr2K15D03C45DRzFdd7xdLRJxw/AqFr2v1NT+s8aLLR3Xs5WV7rKYD0KmmiSgWYMYUVyyZcOnIyFFeE3+SxtSaynRmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459475; c=relaxed/simple;
	bh=lyDccPclJxGZedhLYadtZmxYdaswgU6YsCGNLhOcKgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elWfv3QNJHILSsao9MXLj6fsp6EVqdxmmtwUWCqcIYphGzXt0vxRdAGC880ydNWNGvFhhg3fZFYDa1m2djHxibNhOPLU/kXXRQsmm+/wiow3tuUO4+MHJJT2BM8pr71hyo5s+4GIn7DGSQNmDIjXaoHN6/Oc5dM3GL4hycG0VQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSm4NMN2; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a86c476f679so804053766b.1;
        Wed, 04 Sep 2024 07:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459471; x=1726064271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVNRBhtechMDGkg+NH1UKI/XUcjXx3fSa2oGaERaZjA=;
        b=MSm4NMN27P67UAoe+oI1joUVcnV7k/TTq5jdw1sQx5ONcluJOANzau8VkEHcxL900n
         Q0Xg44l8DIqtYHKBdegYqlr8zaQWW/cwpZpJIJN+xqfnO7HCc2RKkCZ4dMjM+LsBngMI
         H4+dXPeDBb+tHJalCDwi4KXj+DOH201uQ+42+CdcgiRimEqwBoMf6O8jTMoFtGSr20T1
         ShAsjWjxKh9chCXM4SAko9YGWOSjbw/bWsaqSrb6aunuLNUoS6ul/weh2PfUQSbssG1t
         IDwwaP1s13pR2+h+5R5ioT0R3YUfmDTehnvXIusAbLfUdv6FFaYrUPTPbetrhBQ1AjKQ
         Pcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459471; x=1726064271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVNRBhtechMDGkg+NH1UKI/XUcjXx3fSa2oGaERaZjA=;
        b=w2hWYVM1pH70XBiTfno5Z1ihVt1kbDSZeWnl7m2ANE7cvFNzbR1A6nf91D0RIJ6xj6
         CFjkU35YsLBEEDWRtLPkU5HR+jtkKZBfpLnvXQanO+Tk5slzhBwLhS+IKG9r8zzkpl5G
         2RfD3Dm/WHWB3J9zkhzF4cW5ozz40aIJIzkUg9fGsL4dUQSrU1/OxHoDfsojFn9usCt4
         FO1qKh/pISH9pMd5OFk0ScZ8rynUC5/bwOz6Dm5Qs/Gk6P7vKY9jJ+Q2qLqmF1Esp1RJ
         RDVIDjBuP+NXXxERj0v82VXD+0LgKT4qPAv6TnQY7hZsBBYG47G22eyt/RdRdMgvr9oa
         /zNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQZIdK/dSFjYngejqz0LD76ZhmVGsvU/n/R8rWMzF4CL1y3Q2FkbpmaTCs5y/Sdfah8UDMfmOBFGEbvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGjAEBNzVtSJx7swD5SWlAJ8jthITixgHF52BZwF3DCTxvieoE
	Tp/ozz6cdWfHwSsCgQjo+0K5d+VJ8by/RR15Y3G/SqsnyDxsZc1zenpKYA==
X-Google-Smtp-Source: AGHT+IHb0jlP4IioizAxaoRrXvgoAIk/f8ER3xkL75iNWvRggyazpylQKgjr9C/Pc8pltG39ZfMk2Q==
X-Received: by 2002:a17:906:730a:b0:a86:a4b1:d2b8 with SMTP id a640c23a62f3a-a89b93da137mr930271466b.4.1725459471238;
        Wed, 04 Sep 2024 07:17:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 6/8] block: implement async write zeroes command
Date: Wed,  4 Sep 2024 15:18:05 +0100
Message-ID: <2a99dd14c2e0c1fced433822a13ff00735a84816.1725459175.git.asml.silence@gmail.com>
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

Add another io_uring cmd for block layer implementing asynchronous write
zeroes. It reuses helpers we've added for async discards, and inherits
the code structure as well as all considerations in regards to page
cache races.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c           | 64 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  1 +
 2 files changed, 65 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 19fba8332eee..ef4b2a90ad79 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -772,6 +772,67 @@ static void bio_cmd_bio_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
+				   struct block_device *bdev,
+				   uint64_t start, uint64_t len, bool nowait)
+{
+
+	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
+	sector_t limit = bdev_write_zeroes_sectors(bdev);
+	sector_t sector = start >> SECTOR_SHIFT;
+	sector_t nr_sects = len >> SECTOR_SHIFT;
+	struct bio *prev = NULL, *bio;
+	gfp_t gfp = nowait ? GFP_NOWAIT : GFP_KERNEL;
+	int err;
+
+	if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	err = blk_validate_byte_range(bdev, start, len);
+	if (err)
+		return err;
+
+	if (!limit)
+		return -EOPNOTSUPP;
+	/*
+	 * Don't allow multi-bio non-blocking submissions as subsequent bios
+	 * may fail but we won't get a direct indication of that. Normally,
+	 * the caller should retry from a blocking context.
+	 */
+	if (nowait && nr_sects > limit)
+		return -EAGAIN;
+
+	err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1, nowait);
+	if (err)
+		return err;
+
+	limit = min(limit, (UINT_MAX >> SECTOR_SHIFT) & ~bs_mask);
+	while (nr_sects) {
+		sector_t bio_sects = min(nr_sects, limit);
+
+		bio = bio_alloc(bdev, 0, REQ_OP_WRITE_ZEROES|REQ_NOUNMAP, gfp);
+		if (!bio)
+			break;
+		if (nowait)
+			bio->bi_opf |= REQ_NOWAIT;
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = bio_sects << SECTOR_SHIFT;
+		sector += bio_sects;
+		nr_sects -= bio_sects;
+
+		prev = bio_chain_and_submit(prev, bio);
+	}
+	if (!prev)
+		return -EAGAIN;
+
+	prev->bi_private = cmd;
+	prev->bi_end_io = bio_cmd_bio_end_io;
+	submit_bio(prev);
+	return -EIOCBQUEUED;
+}
+
 static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
 			      struct block_device *bdev,
 			      uint64_t start, uint64_t len, bool nowait)
@@ -841,6 +902,9 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	switch (cmd_op) {
 	case BLOCK_URING_CMD_DISCARD:
 		return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
+	case BLOCK_URING_CMD_WRITE_ZEROES:
+		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
+					       bic->nowait);
 	}
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 7ea41ca97158..68b0fccebf92 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -209,6 +209,7 @@ struct fsxattr {
  */
 
 #define BLOCK_URING_CMD_DISCARD			_IO(0x12,137)
+#define BLOCK_URING_CMD_WRITE_ZEROES		_IO(0x12,138)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.45.2



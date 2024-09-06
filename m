Return-Path: <io-uring+bounces-3080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7774B96FE39
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED2C71F22AC3
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F9E3158DC3;
	Fri,  6 Sep 2024 22:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpizstF0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B1D15B10B;
	Fri,  6 Sep 2024 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663429; cv=none; b=BE0+n3Cv3B8/ct+vyRtgSat7K97YKLaHLxWvF2krVq5E3cNf3eCXgpYhmXTn2csxZU3xYvC/l2wwQSjrQDkGsDKmC4YM5B84fTPUKyRptPQ9eHG7hVUon9ocWnfISKcW7iJjCHSz3jMcLqab53yR2RmQePQ0aFk+/IeN9IFbYM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663429; c=relaxed/simple;
	bh=lyDccPclJxGZedhLYadtZmxYdaswgU6YsCGNLhOcKgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxMgGmAscrtnuAkMY+J6jFqjuz21SYpo3P6fsHpDa83uwxLXxg9MFkHpAj5Jd5pXTKys4DRmP/E9Vp//LxGO6j20cmXr2lxY0FvLFSC2X+1cSrOidDYFJoTnMgTcea5PBY6114Wjli+U2vBYYzmUhIwI9beQfaSfPk7qsB2O5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpizstF0; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a868b739cd9so336002466b.2;
        Fri, 06 Sep 2024 15:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663426; x=1726268226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVNRBhtechMDGkg+NH1UKI/XUcjXx3fSa2oGaERaZjA=;
        b=gpizstF0vvM1yQQkTvSDZes8KRn6U+zPNVRbOqmOadV1qwfNi69Y0dvwLzzbUMteRq
         ickWom9bpeVno/N8S4T7Pv/o9CYFA2y421o2NvX3ZOnBOS+5WkKEaavk4YPiohXHubzW
         vr/BGiwXVKcFjLUwm+vnR4zYqtMRzVk2DtPjLLLydLp0ye7coz8cq6Zar+M5DlpDOwmZ
         EVP+pzoeedOjeYJzxWIoC3/nkVBdh0jCgKgho2EZUqOrxw2EBdb5RfHebHkqYNFs1YkH
         YGznCFGJpl/etPkwbNTzqIIRBF1LSLfMLLmsXU7sHR3fZlSpJY6omWB0L98lUNzjPMee
         xwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663426; x=1726268226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVNRBhtechMDGkg+NH1UKI/XUcjXx3fSa2oGaERaZjA=;
        b=PNYU0Rz09vnwsSM77wDEW5rdVehVvq4F7etNiv/z2IlNV5WxQZRqXxSTa8/tKiN2/V
         8zwrVk9C8qad5DW8NTn9PeD1o6yrLmq0bAm5E58PPK2EZ5iqnZ8SxKmy5yP8XMr3/gum
         e/POW9kVWocN8qtU76c3GUEZvJEjRk7pdHnrME3S0XtxUXBSUWV6jxJVpwSQuEph+F/y
         n6kPSP/wc1j9yVM8ZBgeOQO0lky3qqp92/SGK4nU1UH95GVfYIZjoAQlb6nEGbjM8nZp
         qU654sx2REuqF1Nvt9q5WwRAWcd/4IqPb+WHdTY6oPxE2XBKA+Gu+U6H30prLyqsP5tM
         LKGA==
X-Forwarded-Encrypted: i=1; AJvYcCVLf01gYazF45YizydxE5J0k04F3tJNsOUHkQesuMQrJ7/kyugkuSsY5mts4PeWC4BVXUR1CXfA4e0gdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQHV0f63qdKogFyFzCw1xaJKrzyAM2jQi2gFiUxsnMLYvj2Trp
	d8ib0ciQNPaSUKPd5Aw1XBe+5cAy0Mrg/gGrpV5rQhsUktzb0XlVBhm4u+3w
X-Google-Smtp-Source: AGHT+IGwtkNX+b7B+F+E65xCqdvf83CYwy/QQoEkioql8r4UWUgpbreyku1f9KDVfE9jAVw9Or4nJQ==
X-Received: by 2002:a17:907:968b:b0:a86:b46b:860a with SMTP id a640c23a62f3a-a8d1c738eedmr53296966b.54.1725663425531;
        Fri, 06 Sep 2024 15:57:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:57:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 6/8] block: implement async write zeroes command
Date: Fri,  6 Sep 2024 23:57:23 +0100
Message-ID: <2a99dd14c2e0c1fced433822a13ff00735a84816.1725621577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
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



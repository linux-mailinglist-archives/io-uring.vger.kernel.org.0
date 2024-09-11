Return-Path: <io-uring+bounces-3144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1684E97588A
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF894288E17
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18551B251A;
	Wed, 11 Sep 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBFxrCIo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F581AED3F;
	Wed, 11 Sep 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072471; cv=none; b=cmXOllqFuPDWsFvmtkMduiMmRN/Egkutm8clUTl+8/Qr6MpQ6tkGMSaKn9Q0lepUc8vDuCRc+Za0Io/7DG/ZEPxyzufznD5e786ZLTDVInvLnZQF7QWUYXYBNzHHoPMBZ4Z9Fu2BuSvbkq9KdtitrlS4/uHQIOaouzU51T/Cmmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072471; c=relaxed/simple;
	bh=ikFHeLGNtER3kiAGY6dEyQFelOp7bVS4cCMwIaMUdFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMslUKfxkLCFr/XMAPAE/o4bIUR3k6mfepBu9OwCpEmi8wqPdORMqlPFpA0H7OKtQvOzqZIPXy+cYSAoH/qZmKO3vrrd87+tszv/mUDds3ETTtpmKHX6ClXH4e8x3eIXJGs6UXGSHlSKqT2D7BpsrI5x34NuqBNM47a7s6JMKXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBFxrCIo; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so190251366b.0;
        Wed, 11 Sep 2024 09:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072468; x=1726677268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scYTie9WkhCZlLX/43ma4VJqtQTMJpI9jsSYXTTakWw=;
        b=cBFxrCIofe3HyW4VhFWV9uoo9qFFieOHGlbCVvE8bAiXh7+lme8TFYx2I+xpOFTycv
         Ois1phsPEJx1Wa4BYtnAC9smTSbaMuDXPR+/Ql7emVkGGbEGEdbxw530WxJeKBnp3s/8
         zCT5Yo0BpLR9OQqRFnJPydcM8ZV29PKa5lCaHLbUVh2nNfOa/XVkblYPwxlqdHB3A2nB
         W62mbC7NNh9ey5qqSy0dC2A7HUiCjuhgFLl6J2BOSUibF66AdpZOy/kcFpC/QUH6GsYv
         T+mfzp+GjHRVVYnCYWEnCOcpSaGI8+2fMNd7NRz+dZcYcdKyqDVMV2z6MgZSnY4NW2Um
         QlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072468; x=1726677268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=scYTie9WkhCZlLX/43ma4VJqtQTMJpI9jsSYXTTakWw=;
        b=uP+CqU54FyVw4FC3rpFCbnBSYgmKeqHN5KNi0dOWV0KfmGcPTKxw67pM/bI+wlx3Se
         be9dVNvRVLSO+7ByR+9Yv10XdG/dHB5H72q/G6iMsbKJrYpcanv5XnZekTwZLRfk9lR+
         PPTU39UbOvOgh5b0rF9fGLqE9H2piwq8XeitD8HMUcoazwLfDtooppZrsI/0dEs8+5t/
         5H5Hte+faiJxgahQ7lFsRO+2e071RKMFNsuSqmkLgl0Uv78l/3p6anpK0Mqok+0W13Pd
         ZeEOD7FT8Xw4/L9+j+u2zBL3m+epfaJ7OvpqEhFuZJuHKHu1szAH+0Q6BjQ+CHr2Zkns
         oWnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUADBB/qCgLb1Nz1jxQpDzer5YZ/u5fPuH7DzTuV9KhzLHoa/v2wWqXllUH3VpcyyqxM1QjArENMVic4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9gPbXkAfG7gAWi5scalggcWfvsSqZjrVvP/44bFm2uwjd47I3
	W8ntlQjimp6C4GlkzmrbOMNvvCdwp19RRKRAAGmQFnkGpo/m6DwF6Z1wpnNL
X-Google-Smtp-Source: AGHT+IFtkK/R+pcDbDqSnBe+yOdtrkxtJbf96YiBq1nB7U6U1178eNxdDg00TSuprdAdoC34frzF6g==
X-Received: by 2002:a17:907:944b:b0:a8a:87d5:2f49 with SMTP id a640c23a62f3a-a8ffae3a20cmr485726666b.28.1726072468161;
        Wed, 11 Sep 2024 09:34:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>,
	Conrad Meyer <conradmeyer@meta.com>
Subject: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
Date: Wed, 11 Sep 2024 17:34:42 +0100
Message-ID: <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
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

Add a second io_uring cmd for block layer implementing asynchronous
write zeroes. It reuses helpers we've added for async discards, and
inherits the code structure as well as all considerations in regards to
page cache races. It has to be supported by underlying hardware to be
used, otherwise the request will fail. A fallback version is implemented
separately in a later patch.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c               | 66 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/blkdev.h |  1 +
 2 files changed, 67 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 007f6399de66..f8f6d6a71ff0 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -778,6 +778,69 @@ static void bio_cmd_bio_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
+				   struct block_device *bdev,
+				   uint64_t start, uint64_t len, bool nowait)
+{
+	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
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
+	if (unlikely(!prev))
+		return -EAGAIN;
+	if (unlikely(nr_sects))
+		bic->res = -EAGAIN;
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
@@ -856,6 +919,9 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	switch (cmd_op) {
 	case BLOCK_URING_CMD_DISCARD:
 		return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
+	case BLOCK_URING_CMD_WRITE_ZEROES:
+		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
+					       bic->nowait);
 	}
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/blkdev.h b/include/uapi/linux/blkdev.h
index 66373cd1a83a..b4664139a82a 100644
--- a/include/uapi/linux/blkdev.h
+++ b/include/uapi/linux/blkdev.h
@@ -10,5 +10,6 @@
  * It's a different number space from ioctl(), reuse the block's code 0x12.
  */
 #define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)
+#define BLOCK_URING_CMD_WRITE_ZEROES		_IO(0x12, 1)
 
 #endif
-- 
2.45.2



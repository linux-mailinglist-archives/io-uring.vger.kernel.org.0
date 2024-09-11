Return-Path: <io-uring+bounces-3143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD40975889
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31242B2783B
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667EF1AB6FE;
	Wed, 11 Sep 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQBJAFaW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E291B0131;
	Wed, 11 Sep 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072471; cv=none; b=BqQdlk+aYQl1capBNjGq12FuYNDoBjr2c9QR0rzZBGQFN1/hw+nyH4dS4rMNzGBFgEC7707DkegQ3vioUF9ARyJ33LWMQqDB+aNbwNHVMfKVcZpVUhUdYLfIlJJ895B273DE2bZuu4nMI/2zfFtrzAE4NiKpA+GW4EwGwqVypp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072471; c=relaxed/simple;
	bh=ZoYFjq6YenltACEj5sQRlsTFXK59L0GNjOmH0s3i/qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3Fy4lBQVQyYdj+G+aiMxvxgAIV5DYP/H1TCXgaxxEMVgM/0yEnTsjGAn8Nh4pbpFc5wjI2i4+eaZN7TSmIXUGqXmdxB8d4VeUCNU4Ur7uO1QOX5KvNgxl/ZFxlhmUIm+3/B+syOoT4lTaRQPVG5/JRm7Vx7AELtaUXTyVxcXC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQBJAFaW; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5365aec6fc1so6767050e87.3;
        Wed, 11 Sep 2024 09:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072467; x=1726677267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kF1so/Smn2x5rpzm017teUbERvLKVA5uX9EtHevfvOw=;
        b=nQBJAFaWJ7jK4KKdEN2YQDLFuOZs6eLZBTHxOhz40EpmCuhraewiq6+PtrGrebniKj
         7+PFbSfciLCly9xRJPSt59G1Ck0NBfWvNWy4fY2/qqNSz/VJfWUyWPSRs5vWkj5uCdN/
         x/9NKYMlfUNZLcizlDOuaeVLc3DxFDNLFWHZvyIkaLNxfai5qQdpEmcXvtWE1TgJ/xCe
         6YSlCZiEA7cXdBiuaCSEtI5di5rH6fmNO8f0OhQUAX3qkAoj7xmr7BEm//6dcqyIE6dg
         oPze7i32s8pxYDtYKL/HdndfbZNDKlvN/bdcYuXDg+djgbx9iHVvS64Leq9Upieod5U/
         MLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072467; x=1726677267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kF1so/Smn2x5rpzm017teUbERvLKVA5uX9EtHevfvOw=;
        b=rAqbXiuqpS0odkVCZhzR1814vbSkWkSYo8Vjk/yKeg9eziAXCydO3ou+NqwLDL+cEk
         WZVBkhzGQEyeeAQHfgRVdCmo8Ow8n753g3pvgUcRlZlORAgEaO9UCcoT5VSEf2UX01j1
         cNenq0c3EWyeHGgVtaIx0tyOF6ci21kKfqz5Hok80azxzvuGh1Yn6JxAeadHzYfhncqq
         HGCmmEqgWsdQg+Cxs/YY9wB1nSx+K2gJ3UhsrdGoo5MucM1s6tWI0Ws0MYGFTIhCnTo7
         9fZLU0hCKvdWIsUPTZJD4EH6kUOmDM+ogz/+WKSJdbLsTNJWGkyOa1trV1LUJMUVjPFj
         RZTA==
X-Forwarded-Encrypted: i=1; AJvYcCVJj2KsSerWBg9pE/HMndU9SCguI50PPYdw4irPYK+Lnk09YgQZIkF3YMJ9hFWV9STp7sEmrmtAiNhvIA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yznr5XDC7Ew2oCy8nzun6qM1gWh5ZgQaKB5LNhwQFZXkpKZatNW
	42fQ5ER7dfJlcK7vjLNTr2wfoTwBuOGTIVc+xWKsdxfyyhSpq5BdLNrWCXG/
X-Google-Smtp-Source: AGHT+IHLIiqymTGBUF58wtBP7zqzsomLZiPzbl4k1nvQcQaXuT38DwgIAaWI4pNf9MD33TwjU3QnoA==
X-Received: by 2002:a05:6512:68b:b0:536:53fc:e8f5 with SMTP id 2adb3069b0e04-5365880a221mr13417594e87.55.1726072467080;
        Wed, 11 Sep 2024 09:34:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>,
	Conrad Meyer <conradmeyer@meta.com>
Subject: [PATCH v5 5/8] block: implement async io_uring discard cmd
Date: Wed, 11 Sep 2024 17:34:41 +0100
Message-ID: <2b5210443e4fa0257934f73dfafcc18a77cd0e09.1726072086.git.asml.silence@gmail.com>
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

io_uring allows implementing custom file specific asynchronous
operations via the fops->uring_cmd callback, a.k.a. IORING_OP_URING_CMD
requests or just io_uring commands. Use it to add support for async
discards.

Normally, it first tries to queue up bios in a non-blocking context,
and if that fails, we'd retry from a blocking context by returning
-EAGAIN to the core io_uring. We always get the result from bios
asynchronously by setting a custom bi_end_io callback, at which point
we drag the request into the task context to either reissue or complete
it and post a completion to the user.

Unlike ioctl(BLKDISCARD) with stronger guarantees against races, we only
do a best effort attempt to invalidate page cache, and it can race with
any writes and reads and leave page cache stale. It's the same kind of
races we allow to direct writes.

Also, apart from cases where discarding is not allowed at all, e.g.
discards are not supported or the file/device is read only, the user
should assume that the sector range on disk is not valid anymore, even
when an error was returned to the user.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/blk.h                 |   1 +
 block/fops.c                |   2 +
 block/ioctl.c               | 112 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/blkdev.h |  14 +++++
 4 files changed, 129 insertions(+)
 create mode 100644 include/uapi/linux/blkdev.h

diff --git a/block/blk.h b/block/blk.h
index 32f4e9f630a3..1a1a18d118f7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -605,6 +605,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
 int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
 		loff_t lstart, loff_t lend);
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
+int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
 extern const struct address_space_operations def_blk_aops;
diff --git a/block/fops.c b/block/fops.c
index 9825c1713a49..8154b10b5abf 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/iomap.h>
 #include <linux/module.h>
+#include <linux/io_uring/cmd.h>
 #include "blk.h"
 
 static inline struct inode *bdev_file_inode(struct file *file)
@@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
 };
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 6d663d6ae036..007f6399de66 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -11,6 +11,9 @@
 #include <linux/blktrace_api.h>
 #include <linux/pr.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
+#include <linux/io_uring/cmd.h>
+#include <uapi/linux/blkdev.h>
 #include "blk.h"
 
 static int blkpg_do_ioctl(struct block_device *bdev,
@@ -747,3 +750,112 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return ret;
 }
 #endif
+
+struct blk_iou_cmd {
+	int res;
+	bool nowait;
+};
+
+static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
+
+	if (bic->res == -EAGAIN && bic->nowait)
+		io_uring_cmd_issue_blocking(cmd);
+	else
+		io_uring_cmd_done(cmd, bic->res, 0, issue_flags);
+}
+
+static void bio_cmd_bio_end_io(struct bio *bio)
+{
+	struct io_uring_cmd *cmd = bio->bi_private;
+	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
+
+	if (unlikely(bio->bi_status) && !bic->res)
+		bic->res = blk_status_to_errno(bio->bi_status);
+
+	io_uring_cmd_do_in_task_lazy(cmd, blk_cmd_complete);
+	bio_put(bio);
+}
+
+static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
+			      struct block_device *bdev,
+			      uint64_t start, uint64_t len, bool nowait)
+{
+	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
+	gfp_t gfp = nowait ? GFP_NOWAIT : GFP_KERNEL;
+	sector_t sector = start >> SECTOR_SHIFT;
+	sector_t nr_sects = len >> SECTOR_SHIFT;
+	struct bio *prev = NULL, *bio;
+	int err;
+
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+	if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	err = blk_validate_byte_range(bdev, start, len);
+	if (err)
+		return err;
+
+	err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1, nowait);
+	if (err)
+		return err;
+
+	while (true) {
+		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp);
+		if (!bio)
+			break;
+		if (nowait) {
+			/*
+			 * Don't allow multi-bio non-blocking submissions as
+			 * subsequent bios may fail but we won't get a direct
+			 * indication of that. Normally, the caller should
+			 * retry from a blocking context.
+			 */
+			if (unlikely(nr_sects)) {
+				bio_put(bio);
+				return -EAGAIN;
+			}
+			bio->bi_opf |= REQ_NOWAIT;
+		}
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
+int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
+	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	u32 cmd_op = cmd->cmd_op;
+	uint64_t start, len;
+
+	if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
+		     sqe->rw_flags || sqe->file_index))
+		return -EINVAL;
+
+	bic->res = 0;
+	bic->nowait = issue_flags & IO_URING_F_NONBLOCK;
+
+	start = READ_ONCE(sqe->addr);
+	len = READ_ONCE(sqe->addr3);
+
+	switch (cmd_op) {
+	case BLOCK_URING_CMD_DISCARD:
+		return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
+	}
+	return -EINVAL;
+}
diff --git a/include/uapi/linux/blkdev.h b/include/uapi/linux/blkdev.h
new file mode 100644
index 000000000000..66373cd1a83a
--- /dev/null
+++ b/include/uapi/linux/blkdev.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_BLKDEV_H
+#define _UAPI_LINUX_BLKDEV_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/*
+ * io_uring block file commands, see IORING_OP_URING_CMD.
+ * It's a different number space from ioctl(), reuse the block's code 0x12.
+ */
+#define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)
+
+#endif
-- 
2.45.2



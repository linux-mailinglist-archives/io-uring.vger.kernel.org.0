Return-Path: <io-uring+bounces-3023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E2596C00A
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E3DE1F25BAA
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041AC1DC07F;
	Wed,  4 Sep 2024 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxtWxh9k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB1F1E1301;
	Wed,  4 Sep 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459473; cv=none; b=R2iDprv0vYqsOrB9KOA/ralYmYMytR6qdE/6etaBYKlxfhiQkzBtOKXxp074K75b9XOdH4pxP798P6XaBNae5HRXccfmTm6HmoHeoGJUmXu4SE77nyLcqi04txhbxp8M7qLIR3oBXH7piDNG6T4XSA9xX+eM/oKl6z8XQXzUE9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459473; c=relaxed/simple;
	bh=j+7zM8nY7uAZN93ODz2NwhZQYv08k76ZVh99E9m/LeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrnF3ix/CZQ1oRVQb0BGWjZ5ZPbeZkZWolmsrGygXigBtuDyYsJcUXi7iou4FSI7KqqF+jYskklHfQMr8mmvPB0DyfEJ11bzUcltt09fcuGQkuMOajxmHa3aANdzvUomdJYgJt5QpS3hiYkdQqkC0206hH81nkpTouIbgavFKao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxtWxh9k; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a86e9db75b9so739476566b.1;
        Wed, 04 Sep 2024 07:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459470; x=1726064270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7dFMMDbVFAIV5pvquHCkne/t7NzjwwosACmczIEiUs=;
        b=NxtWxh9kNyK1x2XWNmtezXK7d3flh5bfYQQ+k+7QtPwoV2Ey6TpZkWtei58yvHwe6u
         FFa0edrHIwrSLgMYZqr7ZNSBC1c9h93Ybp1YpzmejqTlJk3LEt4gVoqk2z6JnDg2nFlh
         S118FvIHcD+8IPDFVvijLmYuS53iRxzKKQTmvm61hdWwLPoRwHSn0LVcGm0WRTAmJ5pS
         N0clmkEgmX9FcvowbhQ2qDjKP0u1J/SLRIxF2B4ukf3f1HL3FXr2kUvkb/3Bek40yjK/
         sGaGwKTQZ6ML5vwLAfhIrSwirJvfdoHMb60RrRLj25q4ssIn0D5ZsF6wNmNB6l1dVkuM
         ljAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459470; x=1726064270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7dFMMDbVFAIV5pvquHCkne/t7NzjwwosACmczIEiUs=;
        b=ozdcR9CTi01NhjimufoTWgeeeDC6cVVVCblcj1JN1b2xGVyPjSNSQjjqc1Vdjh+hSN
         qSADgYTZLQAzzWpIVLRhqaXQK2j3FsV20GM2fQHySfMbOUCiDoVCiXmgHJaV6dZifXL3
         QXkC37WUQzSeT2ZsLkVueFc4SOZnMRwOF8Pvoo5+U5rEJt48Ttj4J9xEeZagnoqI8iTS
         WpdWIdbkqMhTSpMH/Tx4wziZzKVMlanG8v4jGwOvJTZNY1ngTE2kRtxNVIA0Hp7s7RVe
         wRmCU3RQVSxb6ies0O2AE/e2hO1wJm7SWEArMz2/p6jFJxSO7nlhCPYGWmT5X/fPYrg0
         4lDw==
X-Forwarded-Encrypted: i=1; AJvYcCVCbKpVeCo8tNulqzE20LeySkA95NKwkT4rPykNuWP5na98AbhpPztY8C4wyH7YFNbFajQK6w5re24D0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx5H7PNV10UY63TsrqHflQBEXMyn8oEcMfvLkd+CXEXWtR6KJ+
	IFsoRQjaCrLbBYVmxMPT8afLj8OtitYZgsFVa/3PEeG0DB1S/A2FM1/A8A==
X-Google-Smtp-Source: AGHT+IE26wVQR2LgzuFQ4epQHPbTKn3Zvnc693bAIlnah2akuYCekc7BKlc1sYCNhwYDpPPSQe9AfA==
X-Received: by 2002:a17:907:7e9b:b0:a86:6cb1:4d49 with SMTP id a640c23a62f3a-a8a1d29b736mr490505366b.13.1725459469967;
        Wed, 04 Sep 2024 07:17:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 5/8] block: implement async discard as io_uring cmd
Date: Wed,  4 Sep 2024 15:18:04 +0100
Message-ID: <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725459175.git.asml.silence@gmail.com>
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

io_uring allows to implement custom file specific operations via
fops->uring_cmd callback. Use it to wire up asynchronous discard
commands. Normally, first it tries to do a non-blocking issue, and if
fails we'd retry from a blocking context by returning -EAGAIN to
core io_uring.

Note, unlike ioctl(BLKDISCARD) with stronger guarantees against races,
we only do a best effort attempt to invalidate page cache, and it can
race with any writes and reads and leave page cache stale. It's the
same kind of races we allow to direct writes.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/blk-lib.c         |   3 +-
 block/blk.h             |   1 +
 block/fops.c            |   2 +
 block/ioctl.c           | 102 ++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h     |   2 +
 include/uapi/linux/fs.h |   2 +
 6 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 83eb7761c2bf..c94c67a75f7e 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -10,7 +10,8 @@
 
 #include "blk.h"
 
-static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
+/* The maximum size of a discard that can be issued from a given sector. */
+sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
 	sector_t granularity_aligned_sector;
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
index a820f692dd1c..19fba8332eee 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -11,6 +11,8 @@
 #include <linux/blktrace_api.h>
 #include <linux/pr.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
+#include <linux/io_uring/cmd.h>
 #include "blk.h"
 
 static int blkpg_do_ioctl(struct block_device *bdev,
@@ -742,3 +744,103 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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
+	gfp_t gfp = nowait ? GFP_NOWAIT : GFP_KERNEL;
+	sector_t sector = start >> SECTOR_SHIFT;
+	sector_t nr_sects = len >> SECTOR_SHIFT;
+	struct bio *prev = NULL, *bio;
+	int err;
+
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+
+	if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	err = blk_validate_byte_range(bdev, start, len);
+	if (err)
+		return err;
+
+	/*
+	 * Don't allow multi-bio non-blocking submissions as subsequent bios
+	 * may fail but we won't get a direct indication of that. Normally,
+	 * the caller should retry from a blocking context.
+	 */
+	if (nowait && nr_sects > bio_discard_limit(bdev, sector))
+		return -EAGAIN;
+
+	err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1, nowait);
+	if (err)
+		return err;
+
+	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
+		if (nowait)
+			bio->bi_opf |= REQ_NOWAIT;
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
diff --git a/include/linux/bio.h b/include/linux/bio.h
index faceadb040f9..78ead424484c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -684,4 +684,6 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new);
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask);
 
+sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);
+
 #endif /* __LINUX_BIO_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..7ea41ca97158 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -208,6 +208,8 @@ struct fsxattr {
  * (see uapi/linux/blkzoned.h)
  */
 
+#define BLOCK_URING_CMD_DISCARD			_IO(0x12,137)
+
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
-- 
2.45.2



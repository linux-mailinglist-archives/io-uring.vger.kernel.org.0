Return-Path: <io-uring+bounces-3079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 463C796FE36
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 645491C24899
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5685E15B10A;
	Fri,  6 Sep 2024 22:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTjdm3X7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E15C158DC3;
	Fri,  6 Sep 2024 22:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663428; cv=none; b=GhACAaQQ4WAjVVXdDGrFXWarMl5pxFSGKNHoa1Y0d5gtclUJcaPBArGUrOHj+2S1JOjAWbhOU0dnSdk7KUICy0yHSrJq2g3W36yTJivAKQQwzb77Mb26DDCW2rzfXtLmLHn09Wu+IBxjFtBwVrnAjdzoLxgMJ31JKP+aj6K6YIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663428; c=relaxed/simple;
	bh=j+7zM8nY7uAZN93ODz2NwhZQYv08k76ZVh99E9m/LeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRUu6jE0jWKY87neyzS/YDzc6JLsC1ke5KixI6NRIS8zWrjUfxFyUashVsSipEj1wz6c7z3gHUsZN5BzsBCX6xp1Z5rsOw1aYdfaHGYbkvlH6IJ11cosLwuaT8Momhd1rqMOmrthWHNMQ0XYHrWoQXQ3kUYfGXHUhvrElcKV/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTjdm3X7; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5365aa568ceso1286937e87.0;
        Fri, 06 Sep 2024 15:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663424; x=1726268224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7dFMMDbVFAIV5pvquHCkne/t7NzjwwosACmczIEiUs=;
        b=fTjdm3X79fX4NWw0EGm/jSeeQufTJLkgFtpCGHjwwFfq/w3v8TDjXOu5/SwyCT97Rt
         ptZ5/Y0UBuLunK57ypC+roFURLgJYvOg+MI+8nMBphBNYEkePMxVbh+s90R3IRgWJhOi
         +zuAjuHwO74PUzBEhtQyJObV3wrAJW62MehsSdhcaup7a0skUU3l7G0rDORM6zu1UYj3
         nUkX3jKnfnAwXmngP0XyPOBjtlJ29gAiA8gUOnS8gA1cVj/tEMvz1A1D5DGGUCnsbJGM
         FgSBwEmcZ8K2K5GsIuUnF1RKOB8y9Br7H+3MZIpnItett77dVmv7ZdR+0fiCJp/K0Gen
         8ehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663424; x=1726268224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7dFMMDbVFAIV5pvquHCkne/t7NzjwwosACmczIEiUs=;
        b=AGxwpmefcy6mHT49mpynXFhkYOmDt4BHGWfff7ogLFAg/NmCBFlHs/PeQoCSYh9u1o
         wIQaxwzA6IZv5upe8mvBSj+meS8R2omnVt3XrIKHvfZV2Kpvw1TCLAHZG5Mn2GH+ObbO
         S6kUy2RFzM3nsCN2zTwzeESZBETrvtIAmZ8HdYLkqa+eX/04R2sJ2pEzUcjOUBd2hAe1
         UMd5Ier7OpPmzGlYwOe3iMTYQVqIUyoaW45IJ3ZYXtc69RemK4p4jas1hewqjpxm4HsN
         EmH4lyyl2UfFQKz0X/rJDCgffORUccEe3gyqJDDFlLOGpfPrj32ftdfvlWkjCpggbrJf
         CgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+3sd1IodeyHvMgyoJs2XlIF3OyzFhFojkI8oOCymCTrjYiBsi9cgFKNdg0ol4ZN1m6KNh3aNVZocuTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxSQhuyF3d554xFuDk4pvu254XeKit1s9S73HswY2FCtrZCXx+
	nASESGxjI5YEc9AczI4GxxTV3sX38ghwmRZWLYKm+i18hf8Q/Wa4xcfndUny
X-Google-Smtp-Source: AGHT+IHt+QYHmRu0nquydclberbtpO0LZ0vL2z0xJXuhII8HVhOpdcMo8Pgh0RIOwsY85+0VzuhDqw==
X-Received: by 2002:a05:6512:b88:b0:536:53d1:850d with SMTP id 2adb3069b0e04-536587f848emr3490089e87.39.1725663423587;
        Fri, 06 Sep 2024 15:57:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:57:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 5/8] block: implement async discard as io_uring cmd
Date: Fri,  6 Sep 2024 23:57:22 +0100
Message-ID: <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
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



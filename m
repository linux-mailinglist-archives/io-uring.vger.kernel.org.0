Return-Path: <io-uring+bounces-2884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2FD95AC00
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 036C0287B33
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381C3364A4;
	Thu, 22 Aug 2024 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSnjNSH8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529813B79C;
	Thu, 22 Aug 2024 03:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297745; cv=none; b=VCCKHQ9TVmdGawxmZ/PTMFobeAh2PhWrL9Q3m1KeNQg8UuO6TgvypKTH82Mzoz2zFP6mo+qwdOD1dzBHPDgsQfSPtH9DCLRH/NUgCl61ro4XBcGGza/zzBhQyT26WSbUBDE5KkpdDrDuYprtmACdcB8YBxT4uQZqpWZEmv6GpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297745; c=relaxed/simple;
	bh=gBDpG6pGeKhN8A/poyP7gUhVt5GhvHtARNXkIfHOrwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5+wSETxwR3yZ0hLekOe4xVShvUl5BEdtGqO5xr6hn2vnyrjh4FbsIZz159ecsut5f2H9SAx3q+IiHQqBjdldqSxzSXMxFZ4ulD7KoRJfd7Zj1gkNRRemcCQY13tT9iBitlLu+3JYCCBBxduAe/trhF7lUpnj/krzjWQzUz5osA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSnjNSH8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-428141be2ddso1724415e9.2;
        Wed, 21 Aug 2024 20:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297741; x=1724902541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGj49BU9lgDQwY8mNGLmILE2ejA/5ZP33Z20PIIjLDo=;
        b=kSnjNSH8Wt6C062y8Jp5cIR0L2l4VSGDaGk8hvMzJVzAWZG098iw6kUfVsyvpthnl4
         UUMtJD3TmkTkoDp8HQIpkvKbcHe0M0Jar3cfTFoxnuwgAZQQrYBKyyG8UnXj4bge3EPb
         MNlBxxiGLUWCvx1ylC4MAMELurq8gj58Wfh2JTb4F3qDgmg6RovyUW+25Y4yGHfyhHwp
         wYGevoCoKR9pDoMdJsvOQZiuv5XHr9QeA3NUPMfbJ2Z/7+NNTgzjxxSuTTwGf7H0c339
         H2fuw9RCOstGSlwZVvZZB2J2wKd5YhOIVlknwNuQBoKW84pvXTglIAg2c3e0tqcu2WT5
         lBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297741; x=1724902541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGj49BU9lgDQwY8mNGLmILE2ejA/5ZP33Z20PIIjLDo=;
        b=jo+pRlwkUfwoIcHpVMruy/sjQuUk2Xa9np15d37meu7tG4R5os3HsyD/FDG7UCsQaH
         XyvdtKjBAzZbAVO0PcFrYpPhUnjRSoZ8YQIpTwTeitaNAM4oNeDaUlglDaLeQm2Ii7Nj
         89aORTkwoXq/63Rpy6zElp679uBycW/kI11xH38595fkurOngx12n63WKEyc8m9kiKx7
         Kw/DWvUWpNJswbbziG1deyxSCpQdRT1gUZr6hAnQqul7xCX67btGY76qpA3jOwAw4E5w
         7EOXQcQoGWHqNmXAQjfof3BSt5Pfb6v2JG1HZyZBHI3IZ3+EAIKH+tfsTq5ivBSIYbGq
         o34Q==
X-Forwarded-Encrypted: i=1; AJvYcCW54HzlEsLl1Hk+VilgKXr7SfUsxd4DKSGIbynVLZeeDa3NcYCUWgDHViJ1kZnH1eB7ZG9nfCwdOGg8QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw54woWCfrpOylyy6N6TJgjBhcdiDRpXCOW1leUPKx8d6qamThC
	/C516z5b1ZewQ8okWDv+8GMF1aWfO1mz3fL831xezj0IST+VdkYOGSu5Xw==
X-Google-Smtp-Source: AGHT+IEgmvrrHLtdXgyQgbBcddGUU2deWM/qRpnDz7MB2b3ub/DdWnFYjjz5OkIhJ7k2yrrWHOHjOg==
X-Received: by 2002:adf:cd8a:0:b0:368:310d:c383 with SMTP id ffacd0b85a97d-37308c08adcmr230595f8f.5.1724297741164;
        Wed, 21 Aug 2024 20:35:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/7] block: implement async discard as io_uring cmd
Date: Thu, 22 Aug 2024 04:35:55 +0100
Message-ID: <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724297388.git.asml.silence@gmail.com>
References: <cover.1724297388.git.asml.silence@gmail.com>
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
 block/blk.h             |   1 +
 block/fops.c            |   2 +
 block/ioctl.c           | 101 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |   2 +
 4 files changed, 106 insertions(+)

diff --git a/block/blk.h b/block/blk.h
index e180863f918b..5178c5ba6852 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
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
index 8df0bc8002f5..a9aaa7cb7f73 100644
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
@@ -745,3 +747,102 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return ret;
 }
 #endif
+
+struct blk_cmd {
+	blk_status_t status;
+	bool nowait;
+};
+
+static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct blk_cmd *bc = io_uring_cmd_to_pdu(cmd, struct blk_cmd);
+	int res = blk_status_to_errno(bc->status);
+
+	if (res == -EAGAIN && bc->nowait)
+		io_uring_cmd_issue_blocking(cmd);
+	else
+		io_uring_cmd_done(cmd, res, 0, issue_flags);
+}
+
+static void bio_cmd_end(struct bio *bio)
+{
+	struct io_uring_cmd *cmd = bio->bi_private;
+	struct blk_cmd *bc = io_uring_cmd_to_pdu(cmd, struct blk_cmd);
+
+	if (unlikely(bio->bi_status) && !bc->status)
+		bc->status = bio->bi_status;
+
+	io_uring_cmd_do_in_task_lazy(cmd, blk_cmd_complete);
+	bio_put(bio);
+}
+
+static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
+			      struct block_device *bdev,
+			      uint64_t start, uint64_t len, bool nowait)
+{
+	sector_t sector = start >> SECTOR_SHIFT;
+	sector_t nr_sects = len >> SECTOR_SHIFT;
+	struct bio *prev = NULL, *bio;
+	int err;
+
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+
+	err = blk_validate_write(bdev, file_to_blk_mode(cmd->file), start, len);
+	if (err)
+		return err;
+	err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1, nowait);
+	if (err)
+		return err;
+
+	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
+					    GFP_KERNEL))) {
+		if (nowait) {
+			/*
+			 * Don't allow multi-bio non-blocking submissions as
+			 * subsequent bios may fail but we won't get direct
+			 * feedback about that. Normally, the caller should
+			 * retry from a blocking context.
+			 */
+			if (unlikely(nr_sects)) {
+				bio_put(bio);
+				return -EAGAIN;
+			}
+			bio->bi_opf |= REQ_NOWAIT;
+		}
+		prev = bio_chain_and_submit(prev, bio);
+	}
+	if (!prev)
+		return -EFAULT;
+
+	prev->bi_private = cmd;
+	prev->bi_end_io = bio_cmd_end;
+	submit_bio(prev);
+	return -EIOCBQUEUED;
+}
+
+int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
+	struct blk_cmd *bc = io_uring_cmd_to_pdu(cmd, struct blk_cmd);
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	u32 cmd_op = cmd->cmd_op;
+	uint64_t start, len;
+
+	if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
+		     sqe->rw_flags || sqe->file_index))
+		return -EINVAL;
+
+	bc->status = BLK_STS_OK;
+	bc->nowait = issue_flags & IO_URING_F_NONBLOCK;
+
+	start = READ_ONCE(sqe->addr);
+	len = READ_ONCE(sqe->addr3);
+
+	switch (cmd_op) {
+	case BLOCK_URING_CMD_DISCARD:
+		return blkdev_cmd_discard(cmd, bdev, start, len, bc->nowait);
+	}
+	return -EINVAL;
+}
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..0016e38ed33c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -208,6 +208,8 @@ struct fsxattr {
  * (see uapi/linux/blkzoned.h)
  */
 
+#define BLOCK_URING_CMD_DISCARD			0
+
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
-- 
2.45.2



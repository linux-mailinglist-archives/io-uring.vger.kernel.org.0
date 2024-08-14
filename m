Return-Path: <io-uring+bounces-2767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F018951950
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B6B1C21981
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314551AE053;
	Wed, 14 Aug 2024 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tciig4Ci"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556311AE86B;
	Wed, 14 Aug 2024 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632332; cv=none; b=j2b3QwXwltRQGlopdqc3ujPqWb+oojZZ8MzPa3u0jV4rlGIaGyuS8R4J4Kb/LXRquNn/xZwS6b5vviLR11eMdGzqZJ/YWiyQS2viotT7Ztr3CLOYyf1fGxRnlZpB7/E5EO6tNRemAcZRHQh/n0wy2W3l4K1I10okpsXKcXgTZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632332; c=relaxed/simple;
	bh=psn+4V45YBQ+6tX8s9X4iuZogIB3QAGe6mFbj/cnPUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME2T3SmbgUlt43mVJlGxP68nakdo75nMQo1/wkXzwKmLzpBG4WbPHJUPikwWJgJ4TsItevhdgiqDAfk1pawG2wXYgSdkkgItJjx/aXow1hAYdwkoKeN96639t/J0sQ6AODKtKNFkRcWmEeI9yfDTWwcEExUIl0/YmF0xYR+LHTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tciig4Ci; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5bd13ea7604so5210258a12.1;
        Wed, 14 Aug 2024 03:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632328; x=1724237128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tuo5pTUVgRqd7+Wu/p/7uLxEPhnfCWa8o0PxSIfrqWo=;
        b=Tciig4CiwyeK5rFGAdG+sTvwjGeUzncrLU32i8RXoT9A0Hdqe5dEzOKUIgAZ3HZuN9
         4cC5LV69zTWPI13ZzoscZc0vQFLa7jqtfCqQvl/LzDApgI+pg/e05QRUKmTxi3Zw1Wap
         nTZXZsNG59ioW9wlO/w3nefOqXWg4/PGnH0dxui4AXb/nWbsdYq5ltVT5R9RieZ/1Afw
         lF07W1YXc328ObPZ73rUMZRiUq/mwhTC4l0kuLRVlfB3OxtfKJ+q+YRY/Spy9ZE8M941
         cxXxXWiRqmdFbIe/4J7vYvfFgO42ofvLus7c0paXGOkVKX0k5BGleyKSfEEaQnPeJ+Xu
         SR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632328; x=1724237128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tuo5pTUVgRqd7+Wu/p/7uLxEPhnfCWa8o0PxSIfrqWo=;
        b=OLJU+1AZpOkvvN8ub/zsonwkMoO3ZVrEwYg73i5iYT8ARjtRIdcOXrIBOoGNbtaTS6
         b/Dpya87ZhxeTnMLWAp31PYq4D3wUQZXSomj/3UaiKlVvN3NgCuZeLyteQHg0sJw6e9L
         1SbzXJYXBpyl1Z08bp1XHUUJmMz5lM/rMAcqRpZI2HP6ySaftEYFQMBym4PXRXe8RtaO
         2f51UBTB8/1JirTVU08Ui+ZkaDii+HkUA2+4pC7Ytkby9LMOj/nugnnkDlHSZ6qpexB/
         5ii4sAi4WzCwvOnZ2kxOJz/6CCfCb8NWYkChMBaPEjt/5QI50XE70YCh28L07D9I4NXO
         CtTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUW/1T6dY0vSEn6JO5OinSIZ/LPdsg6Ae37OaJLHT1ZsO/cSg8J0c2GAbJ7nlKihmhnFoMJYbKTU27EDC47d7ETTdlTY4ytBLXk0U=
X-Gm-Message-State: AOJu0YxWTpj8lhvzcwpo5MRsokYVSH4md2+AjEb+rvSFm9JNktErvhpy
	KF1xpNolV2xeAF7sQJwq+7wSLAs/ogXVj5Qcj+7PlXv//JoBoU9IcnDXeqlJ
X-Google-Smtp-Source: AGHT+IG1KkX6wMcxGFIa+KqlcGfRZzjy0lHz5phQrjiJN6wASSWoiIqHMLk5BznC58MpKrZaWW6grA==
X-Received: by 2002:a17:907:84c:b0:a7a:bc34:a4c9 with SMTP id a640c23a62f3a-a83670bf16cmr128595066b.69.1723632328176;
        Wed, 14 Aug 2024 03:45:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 5/5] block: implement io_uring discard cmd
Date: Wed, 14 Aug 2024 11:45:54 +0100
Message-ID: <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
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

Add ->uring_cmd callback for block device files and use it to implement
asynchronous discard. Normally, it first tries to execute the command
from non-blocking context, which we limit to a single bio because
otherwise one of sub-bios may need to wait for other bios, and we don't
want to deal with partial IO. If non-blocking attempt fails, we'll retry
it in a blocking context.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/blk.h             |  1 +
 block/fops.c            |  2 +
 block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  2 +
 4 files changed, 99 insertions(+)

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
index c7a3e6c6f5fa..f7f9c4c6d6b5 100644
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
@@ -744,4 +746,96 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 
 	return ret;
 }
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
+	err = blk_validate_discard(bdev, file_to_blk_mode(cmd->file),
+				   start, len);
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
+
 #endif
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



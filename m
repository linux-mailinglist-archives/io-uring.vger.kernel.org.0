Return-Path: <io-uring+bounces-2885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F2995AC03
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11D091C20BD8
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D207A23749;
	Thu, 22 Aug 2024 03:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGEc46nA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A52822612;
	Thu, 22 Aug 2024 03:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297746; cv=none; b=ZHLTWNgQwZYdQ8B+3soVv3JJQG7VKC+dc5cKDDoArUW0VT5F4XO2mcZHRou8Sm9HoVwa8fNLNYfPnKNOLZ9GRxo9s7UCK/vfwLbZ9+EUwaatAKMwdEA+aAhHViA8b79cyMhfkMzSXrJI+Ji4yJjDd+mc2T0qCgx/d9N2jpUU80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297746; c=relaxed/simple;
	bh=IoTc07K0AVIjxOTptHn5WO5OuyWZ6NvBayNrDkbYFzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF/SVNwlDKt91zzuPt1ADMcMmCfo5WbbPATrzo5OeHz34MiY7PJjmqoAq17fMDtONAx1L3o4nvpVklbxzjFRrAvzJ+obobo6KIZ3qKXwGQbpF0gZPcdfXuJrGQjRJaoMd8kuxNOsnKlnkOXciMCQ6AiEEUNw0sNfWjAgZ0HMKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGEc46nA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42809d6e719so1726655e9.3;
        Wed, 21 Aug 2024 20:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297743; x=1724902543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVhT9OqiSkRhkZBmbxRRu3VwPAT0F6C3XigyZkc8g4k=;
        b=NGEc46nAsTOscibMBcN3CBf9bGe8MKjlFOOjLL2yL3osGzg8dUDVAOQUXMlozsEZgl
         n8aocM1E8P8eTGX1zeEXKyqos/Rf7aTnOVgq1k1/6r/jss+8I2fNY0qYKatLD3dGc5qr
         2kzX8NtXAByNcNWPCBckw9gMytI9wI5XAFJqBdsWLG5YMbdefXTHWZhnFHvoMben5gyD
         gYE6BUPsLI8AzH3nm4uJHdkmptajSFHPnR7u/oARNQEv3vHtnQE9nLZFacLLybPYR17g
         B1YXGUITGADH9UaO66kiLcj9mxoldP+TYtGiagGoACivlK5aXCKrVI9AJvPp89zCs8QM
         JYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297743; x=1724902543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVhT9OqiSkRhkZBmbxRRu3VwPAT0F6C3XigyZkc8g4k=;
        b=P/yUCmxe+mjhDp8hJfaR3YGPeM4vFEdJJU6xMsNPo3a67XQOptk+yIFZwxpicoG0MR
         HCQ/iwX+sGEMyo0kSGzU884iGBfRlM0MyonktRN1WjHHOgvHkQW2JTKIaroZl5VWgVvo
         02eRx0u+XqBCAdq2PhzvZvqbpxzPtn7knDFL5C+IOx0KDzro1f6UtS6++TLtM/wxEKNP
         lOiMA6EBgSSbLHw34TNfDddts8i2Cq/rl9TsPL4fsWo9/dkOP0h4vLXO/5sY33Xfxuwy
         KmlodguLns9N8Ejq2oUj5g3xu3IHeE8y6O9a4cOEmi5DqlpA/ZdUXH7CKAGZ0ORqIwtN
         hWTA==
X-Forwarded-Encrypted: i=1; AJvYcCX7hoIMlo89k4qYxEkbL+j36cJQX/GWZy5YxqwvNQ0PlcDE0sPlFZo3SXcaXyu3+xUjMGZiHWmnF/ACgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxem83suy07Xv9nUxxBF/39ztn0MiKsCxYWzktEdjrn3DSVIo6o
	+BeyiaFWVqe+tMdq+txZj3AUomzFpAl3Ljcecbl0VHc8fuk+kB6dsWvqCA==
X-Google-Smtp-Source: AGHT+IHqvEt/onVyk5pfq2MvnE1mDsVk/iF7QUbNipDxcqrMgadYUmb8t6sc6QQq2b3aRAiZt2CaSw==
X-Received: by 2002:a05:600c:4ed2:b0:426:5440:854a with SMTP id 5b1f17b1804b1-42abd21f727mr28548505e9.1.1724297742468;
        Wed, 21 Aug 2024 20:35:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 6/7] block: implement async wire write zeroes
Date: Thu, 22 Aug 2024 04:35:56 +0100
Message-ID: <09c5ef75c04c17ee2fd551da50fc9aae3bfce50a.1724297388.git.asml.silence@gmail.com>
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

Add another io_uring cmd for block layer implementing asynchronous write
zeroes. It reuses helpers we've added for async discards, and inherits
the code structure as well as all considerations in regards to page
cache races.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c           | 68 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h  |  4 +++
 include/uapi/linux/fs.h |  1 +
 3 files changed, 73 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index a9aaa7cb7f73..6f0676f21e7b 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -776,6 +776,71 @@ static void bio_cmd_end(struct bio *bio)
 	bio_put(bio);
 }
 
+static int blkdev_queue_cmd(struct io_uring_cmd *cmd, struct block_device *bdev,
+			    uint64_t start, uint64_t len, sector_t limit,
+			    blk_opf_t opf)
+{
+	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
+	sector_t sector = start >> SECTOR_SHIFT;
+	sector_t nr_sects = len >> SECTOR_SHIFT;
+	struct bio *prev = NULL, *bio;
+	int err;
+
+	if (!limit)
+		return -EOPNOTSUPP;
+
+	err = blk_validate_write(bdev, file_to_blk_mode(cmd->file), start, len);
+	if (err)
+		return err;
+
+	err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1, opf & REQ_NOWAIT);
+	if (err)
+		return err;
+
+	limit = min(limit, (UINT_MAX >> SECTOR_SHIFT) & ~bs_mask);
+	while (nr_sects) {
+		sector_t bio_sects = min(nr_sects, limit);
+
+		/*
+		 * Don't allow multi-bio non-blocking submissions as subsequent
+		 * bios may fail but we won't get direct feedback about that.
+		 * Normally, the caller should retry from a blocking context.
+		 */
+		if ((opf & REQ_NOWAIT) && bio_sects != nr_sects)
+			return -EAGAIN;
+
+		bio = bio_alloc(bdev, 0, opf, GFP_KERNEL);
+		if (!bio)
+			break;
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = bio_sects << SECTOR_SHIFT;
+		sector += bio_sects;
+		nr_sects -= bio_sects;
+
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
+static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
+				   struct block_device *bdev,
+				   uint64_t start, uint64_t len, bool nowait)
+{
+	blk_opf_t opf = REQ_OP_WRITE_ZEROES | REQ_NOUNMAP;
+
+	if (nowait)
+		opf |= REQ_NOWAIT;
+	return blkdev_queue_cmd(cmd, bdev, start, len,
+				bdev_write_zeroes_sectors(bdev), opf);
+}
+
 static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
 			      struct block_device *bdev,
 			      uint64_t start, uint64_t len, bool nowait)
@@ -843,6 +908,9 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	switch (cmd_op) {
 	case BLOCK_URING_CMD_DISCARD:
 		return blkdev_cmd_discard(cmd, bdev, start, len, bc->nowait);
+	case BLOCK_URING_CMD_WRITE_ZEROES:
+		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
+					       bc->nowait);
 	}
 	return -EINVAL;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e85ec73a07d5..82bbe1e3e278 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1095,6 +1095,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
 
+struct bio *blk_alloc_write_zeroes_bio(struct block_device *bdev,
+					sector_t *sector, sector_t *nr_sects,
+					gfp_t gfp_mask);
+
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
 #define BLKDEV_ZERO_KILLABLE	(1 << 2)  /* interruptible by fatal signals */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 0016e38ed33c..b9e20ce57a28 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -209,6 +209,7 @@ struct fsxattr {
  */
 
 #define BLOCK_URING_CMD_DISCARD			0
+#define BLOCK_URING_CMD_WRITE_ZEROES		1
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.45.2



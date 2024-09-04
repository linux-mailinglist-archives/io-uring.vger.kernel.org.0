Return-Path: <io-uring+bounces-3026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E66296C010
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 057371F264C0
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FEEF1E131D;
	Wed,  4 Sep 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKVNNA1R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C995E1DB53C;
	Wed,  4 Sep 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459477; cv=none; b=F/K0Yk7ugL6uWhWEVNSFzpBTIA7nKcF2dJbwvry2ubcXLxdWCNYMRNw0Mh32Vju1xRNRlrcFWtyk4hTYxP7RP1YrOTHY7b5W6AsDMQ/irp3ZneoQgzRl42cyBRt0agZm1E1U7XGoJFayLgSecBHEhQkZ1rsqgBbiCUVbPtD5IJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459477; c=relaxed/simple;
	bh=fX6prqf2VFD2UV5gx7IfCiSBWUdjjihLSk5KGUumqJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osx0UOhwv5rPHNeM8pvQsU9wqphewXK9EwV20Xk6UMnV2gVFW9pfLDVUpzme59mA8sf/cSuqVD67H9pydD/S0z5KzHhpPKiUriNDCjplFucAtoXHNATj63jAVGPlUWfQWb2kUiInwgADUfk7mq31V46YqjC4ZO4imsAKDFXjrpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKVNNA1R; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a869332c2c2so142217066b.0;
        Wed, 04 Sep 2024 07:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459474; x=1726064274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llWa+KY1CsE699NO6/Qz9OdhajA1Gh72FplwVQHN8Os=;
        b=XKVNNA1RzFuo0sRqQ/LxORPRf8ZexVEYz3YWZxM8WnchHpAXsspC14TUDtegrHCqMG
         7wky26m5O7ZGKgOWmYUZykJgJq6DLVXGbVSU0YII+rXmvNyaGMb6KmkYe+Hoew8sgzt8
         x2Y5KtW05NZIvXyWBqdoA26i+MhVVHQJ+ZMQ4duGpdmerqOzmht/B0CDNtUtdNd79ZWq
         +ETJ9Vp/qRY/fdA7rYWx4U/jhbWfTm8l6jEhBU3bNpa6e5hpkZPL4M031Yly2O8KTsfG
         QKLbN54xVNW7vK5MhMvDD9v4nRlRUE/MEs/E4FGF5jzXIwncqMMHAnqpg7UJeFVuENoW
         Uovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459474; x=1726064274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llWa+KY1CsE699NO6/Qz9OdhajA1Gh72FplwVQHN8Os=;
        b=mF4P4hoW5kx8LPBoSxY2zjb7wqgPI9/iDCi5Oxo43lAtXSmwK7qhm76uPBTtnKyoz8
         tsQlCwpP0db8kGOrBxLNv4klRq4Snm1TYeFO1Tv+fWg4u2r8vtvwQN0GJ93wV5i9VYf7
         2tyXF+5vS2gHk6nJDgx6Pg/73x8zreBM11Cs9FuglKsIufO5AcipIxLIqrhmS5EiTCn6
         uKCq4u7Te0DEI6oySJW/h4Dnn3TNMJcj3ROKyDxv+MpljNol9YOPn8lQTuu9bYJrfz6x
         +utIqtVqXidzipczLzfuBneeMQeFTlrTkdYwwCNL5vzbrTe2ixtvQ0ZJeMmBBqji8yBs
         dfGw==
X-Forwarded-Encrypted: i=1; AJvYcCWEo6x6jOfZWzM8cXGJM0IKplnZKL4M9mrmTejf1OYZhcFF/0uNVwHDJgf9gigvAUOcH7SPeQCONmI3QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp36G2nyYYpJmMj6XwdhCGQBe6f8E3mzfOK3sYNqCnyusoTz/E
	cU3O3p/5SDF0RzhlwVggFs9UM5iv8fyyTe5eFhtyykry2fD3o4/3SZeB3F7h
X-Google-Smtp-Source: AGHT+IFWD5NeSx4L5OBZcmDku0R0EHp0Mplv+v0QTrmPwvlzQ40tRMtryzZM6Z0h0n/l6uV8EPBdaQ==
X-Received: by 2002:a17:907:3fa4:b0:a7a:8dcd:ffb4 with SMTP id a640c23a62f3a-a8a430913f9mr290483266b.17.1725459473656;
        Wed, 04 Sep 2024 07:17:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 8/8] block: implement async write zero pages command
Date: Wed,  4 Sep 2024 15:18:07 +0100
Message-ID: <b4d59a6bdc1cf0f058398a1ab8189fab150f8cfa.1725459175.git.asml.silence@gmail.com>
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

Add a command that writes the zero page to the drive. Apart from passing
the zero page instead of actual data it uses the normal write path and
doesn't do any further acceleration, nor it requires any special
hardware support. The indended use is to have a fallback when
BLOCK_URING_CMD_WRITE_ZEROES is not supported.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c           | 24 +++++++++++++++++++++---
 include/uapi/linux/fs.h |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ef4b2a90ad79..3cb479192023 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -774,7 +774,8 @@ static void bio_cmd_bio_end_io(struct bio *bio)
 
 static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 				   struct block_device *bdev,
-				   uint64_t start, uint64_t len, bool nowait)
+				   uint64_t start, uint64_t len,
+				   bool nowait, bool zero_pages)
 {
 
 	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
@@ -793,6 +794,20 @@ static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 	if (err)
 		return err;
 
+	if (zero_pages) {
+		struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd,
+						struct blk_iou_cmd);
+
+		err = blkdev_issue_zero_pages_bio(bdev, sector, nr_sects,
+						  gfp, &prev,
+						  BLKDEV_ZERO_PAGES_NOWAIT);
+		if (!prev)
+			return -EAGAIN;
+		if (err)
+			bic->res = err;
+		goto out_submit;
+	}
+
 	if (!limit)
 		return -EOPNOTSUPP;
 	/*
@@ -826,7 +841,7 @@ static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 	}
 	if (!prev)
 		return -EAGAIN;
-
+out_submit:
 	prev->bi_private = cmd;
 	prev->bi_end_io = bio_cmd_bio_end_io;
 	submit_bio(prev);
@@ -904,7 +919,10 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
 	case BLOCK_URING_CMD_WRITE_ZEROES:
 		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
-					       bic->nowait);
+					       bic->nowait, false);
+	case BLOCK_URING_CMD_WRITE_ZERO_PAGE:
+		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
+					       bic->nowait, true);
 	}
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 68b0fccebf92..f4337b87d846 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -210,6 +210,7 @@ struct fsxattr {
 
 #define BLOCK_URING_CMD_DISCARD			_IO(0x12,137)
 #define BLOCK_URING_CMD_WRITE_ZEROES		_IO(0x12,138)
+#define BLOCK_URING_CMD_WRITE_ZERO_PAGE		_IO(0x12,139)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.45.2



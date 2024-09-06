Return-Path: <io-uring+bounces-3082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C74EA96FE3D
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F319E1C22A1D
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA6015B12B;
	Fri,  6 Sep 2024 22:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDIUu+Ao"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7563615B57C;
	Fri,  6 Sep 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663433; cv=none; b=pyhX3R8sX83NhvKnXq702YwJuC+ni7cdW1V/nkz0AIJAoYgZl6bOAeVCeVNfD6Rp0+fNSkHNj/KUIW5o4n3xwfPTbj7DxcWOUMHnwJqDOR+qIXErjqKHVS8nOyfVUDW0N0Jkk+bqQu2kS2eRcTXmeFwbQQUtrqoYuMR0x1rLpy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663433; c=relaxed/simple;
	bh=fX6prqf2VFD2UV5gx7IfCiSBWUdjjihLSk5KGUumqJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNyJNKctalR/RJDPPPN2cD97r01HOcurwVyiDg4EZovrHT+HzGNLAlBmcRjlsK0jFNvyKSGL5VjEs9jMT2VHio6Lc/lG76OccEHrGrVFc8Eus1JDDp+4S3Pyflk43zMEQbf+P+kFI/JeQ/2A8YQRG1mncwUtUNIqwKEbHuZoFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDIUu+Ao; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-535be093a43so3180061e87.3;
        Fri, 06 Sep 2024 15:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663429; x=1726268229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llWa+KY1CsE699NO6/Qz9OdhajA1Gh72FplwVQHN8Os=;
        b=CDIUu+Aox8Z3H8bOdSttwSPxdkc00prGvp90oFfJRsB4F9gphuR7MTmCX+hgBEBaAe
         PamvlXyfAzCzM8dc+tW91Mw+ei1zoQg8OyP2GkSHIrXQ37BgcKufbFr99WwxxrGHuSCe
         ZAHt95jc7uujescyQtei8SNqJKnTw0t1fIH0Ga01PHtgO3ONl2qzO/NsUaFiu2tJ9VpJ
         AkN2MBMX4Ee2UYjHcVNd9OE/BYGYRTMTm2S/IBOjdFB60qGNPUlxZMSjHoimDG6QkEGR
         FJKP7Z9UAnnj2QVxea9jkhtSep/nNH89vDcGOSnjLL7jiwTgLT1M297YBoSasHvuPE+1
         3zLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663429; x=1726268229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llWa+KY1CsE699NO6/Qz9OdhajA1Gh72FplwVQHN8Os=;
        b=kfGIOuFF2urkmb0TXdywkMIhNOHeRB+A/LLxgNL+ZT6pupsBhLu+Ke4QPRN95azygz
         /BqeiLooZl155xYgi1YDRGAekXUVEMMh/LWYTt1+3o2irsINavaVE2bGOHlRkGnK85St
         mNRUZeRZsaZfm90PQJoz4qQekHz/CXMqJwisOzADb+2T8qyw17dJpsggA451v0Dv4W78
         MH2jboDr/EjjB5Hzkr5uGsci3G80O4yz57UvMFDQyuLfIhbRWM2fEAYjB4qwUBWUMaBj
         73GqbmXQiYQeZqc0sfB0J7+LSImoXAgjpsNGdcf+FpRsTUbl2VgJh+3l0uVD7/mxEXrm
         +7dA==
X-Forwarded-Encrypted: i=1; AJvYcCUyBBO0Gz7J6fj8nD5JyFs4AkCpm/XqgL57pHzVxk0FFszlgcne61tq1CHGs2oQYSvIUgreBi6miY2otA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLUPJ+8kawVyv5QpXZtWXW83jMMDecCXjOYoxs7LFXUcHKFdOo
	vsz3Zuwkq/VhxOt7vav+FDcyqIBH59YvgFSjrS4gHCQhV+c6b5LVOf5F/xAQ
X-Google-Smtp-Source: AGHT+IF7dy6Fwnb2jmgqk1DE1zvsMyOI+fNBEs5xezgv4QpyDJkwby70G9EHhdLSnvBeBbSkACl5HA==
X-Received: by 2002:a05:6512:10d0:b0:52c:d904:d26e with SMTP id 2adb3069b0e04-536587abee5mr2790225e87.21.1725663429138;
        Fri, 06 Sep 2024 15:57:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:57:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 8/8] block: implement async write zero pages command
Date: Fri,  6 Sep 2024 23:57:25 +0100
Message-ID: <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
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



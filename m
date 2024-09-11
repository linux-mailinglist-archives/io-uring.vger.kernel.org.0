Return-Path: <io-uring+bounces-3145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C271097588D
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1AB2892F8
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5E01AE035;
	Wed, 11 Sep 2024 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="doF9fpPl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEFD1AED3F;
	Wed, 11 Sep 2024 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072474; cv=none; b=irtkP1vmZZRm8PnDLO5DAIlgHXlxE3dk14tQOwWdeNx7A64e+fYa2sHHeHlTx5juoztsBtDgmJHnsBBJZXW/uNkTHciMP3uIVEGQNTbRrDVJNKEIZg69rLBZwOKLx1CBpWn1nmO5/BTicjkK6AkfgwyI+4MO7YOGAIJcRdExlCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072474; c=relaxed/simple;
	bh=47FgsBjGylI50GriBm4QB0MtYvxzC2qf9DBpWjJOkco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7jJ7HZPLk+P1aaHuicK5GtAVjVvDgwCucr+RS14hqnbCkT22dyQOqIyWva9KxSliLpiyRqnpKvREuHUnuwpffFp3XA95LtN+vwJtFJtA7t5Zi54quvj7HT92trIptKFQiqSh013u2nsk1Qg3G8Gb/vATmmzq++1fw342ay4q10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=doF9fpPl; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a90188ae58eso3549366b.1;
        Wed, 11 Sep 2024 09:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072470; x=1726677270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tt1Sdp5HcYzfSkBqCxePJrZcv+DNb0SwUWNG181PEJo=;
        b=doF9fpPl6rDmTUVmE9TvTW8qnbFTiSAt6zz66lQQrYWEHFx0NW5lmBe8uo6GUiZgX2
         T7+nACbZnDwlJMPWzEwrbs2SIwpPe/hFhSb+cXqZQJaYP4Pnjv91CCrzr9+aw+WrY9Tg
         xLVUbwu/mVdqwuxBKlk+kKWwmpwjq+wU82dRZ3hUiEH67rc6iUbQETXHDoeNrMeDhgK1
         rTvvo79lh1C613ZMRkDfvwwmLW9dJNJ6xI3lgzsYqed2O/5hL2ZyJh3Wr9ecyrakQ5db
         J2zsmwHJBIW/bz3z0Qt7Kg+ybHpIIyQv8kM0wmiFU0Yh23b5Aboeb5jMml6PqNKbV31S
         BFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072470; x=1726677270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tt1Sdp5HcYzfSkBqCxePJrZcv+DNb0SwUWNG181PEJo=;
        b=aZiDFNLaOBYkfQrvrXYSo7qvdTkrCA5EY9AYg+tr0SNN0k2Sb8Vv/NudpwXg/1X9tf
         n4lx4GhF65aCERa39XngyO31QM98qbptJhT1sqs29684ec3JlpXzt+OKvK5EZ4Qy2Scn
         3COlwAI9FdE47C2SxLNg+s+XlKLIHZnDor+zZCAwG9EM9DFaJcPBd5UbEriOC90cy/6C
         ldd7wN8YIGIcu27lrwGe/mKnSCBuoZvdoTSR+dvWTERf+s0hYXs8a1nFW95u7qK2cJ7w
         EFQiihxjUfWTEo9/J4t9POIgCDNOE25pTZRXEOQbAsTp5RBMmo5m30r/FgsWUkWwdpEt
         TB1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD6iSR3Qo/JwKD2kJ6vP0KzX2WbZp7rpk3D5tmjjSFSmtqf9nLZT9OtDE5s+RKtqZSu+YKGLkgyyIEsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0MC5OevPaMomMUY4iwT56Qc9p8ru11ls9AVM1KFm3HN4Ua2/9
	XiyTiHm9PDLQ8pSmX3pXGkTBHkug7HcKmY3HZWhxwD/66UjIvFKv2s7BIYVt
X-Google-Smtp-Source: AGHT+IGzBI9+dMWJvPlTYbOfk11QQ+FrGskd3fYscDMuABz9+Q22m/SZtfuiKraKUWCJKvHI3YqGqw==
X-Received: by 2002:a17:907:d2ce:b0:a8d:3f6a:99ce with SMTP id a640c23a62f3a-a902961a769mr5471566b.49.1726072470444;
        Wed, 11 Sep 2024 09:34:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 8/8] block: implement write zero pages cmd
Date: Wed, 11 Sep 2024 17:34:44 +0100
Message-ID: <a6f63c935bc421deea26be418c14e2e925d344e3.1726072086.git.asml.silence@gmail.com>
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

Add a command that writes the zero page to the drive. Apart from passing
the zero page instead of actual data it uses the normal write path and
doesn't do any further acceleration. Subsequently, it doesn't requires
any special hardware support, and for example can be used as a fallback
option for BLOCK_URING_CMD_WRITE_ZEROES.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c               | 21 ++++++++++++++++++---
 include/uapi/linux/blkdev.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index f8f6d6a71ff0..08e0d2d52b06 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -780,7 +780,8 @@ static void bio_cmd_bio_end_io(struct bio *bio)
 
 static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 				   struct block_device *bdev,
-				   uint64_t start, uint64_t len, bool nowait)
+				   uint64_t start, uint64_t len,
+				   bool nowait, bool zero_pages)
 {
 	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
 	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
@@ -799,6 +800,17 @@ static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 	if (err)
 		return err;
 
+	if (zero_pages) {
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
@@ -834,7 +846,7 @@ static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 		return -EAGAIN;
 	if (unlikely(nr_sects))
 		bic->res = -EAGAIN;
-
+out_submit:
 	prev->bi_private = cmd;
 	prev->bi_end_io = bio_cmd_bio_end_io;
 	submit_bio(prev);
@@ -921,7 +933,10 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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
diff --git a/include/uapi/linux/blkdev.h b/include/uapi/linux/blkdev.h
index b4664139a82a..880b292d2d0d 100644
--- a/include/uapi/linux/blkdev.h
+++ b/include/uapi/linux/blkdev.h
@@ -11,5 +11,6 @@
  */
 #define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)
 #define BLOCK_URING_CMD_WRITE_ZEROES		_IO(0x12, 1)
+#define BLOCK_URING_CMD_WRITE_ZERO_PAGE		_IO(0x12, 2)
 
 #endif
-- 
2.45.2



Return-Path: <io-uring+bounces-3078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B5E96FE34
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C75A1F224C4
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E6315B0F2;
	Fri,  6 Sep 2024 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ie/dnWpC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045DA15B15D;
	Fri,  6 Sep 2024 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663425; cv=none; b=Y+Bz6AgAzeC6RIrurQov9pvVn4ezSXugtmZQltPnBIarnHObV/ZiKMKZRhjpXPsO9GDo35RQv/PPi4IqQUwysVFlB3y6xqxIhxrUGNu2wVXdjkSWwvOm72BzuSJTHF1REgZNmhNl1MkqjT+MUszkpVRTk40FqYjgEQ20PsKJyp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663425; c=relaxed/simple;
	bh=hjZDHvkTsBuwkkkqnazOc/370IgWi6PLEmiOKefcDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szyA+e5f1brehlQ6vcZyIxb8gDRKSOvJw33llhDTuV2FIE+LA2RvBx+1RBtQY51CQXihCyu7MPXiSR6giolDnDTluGs4LH66nTF+jcDD0PAn2j8o7G8BIZfk1+waEIwYADKIoThiVLQZfELE6AMf0yWs7go5/RN/6Qw6c+KJoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ie/dnWpC; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8682bb5e79so362391366b.2;
        Fri, 06 Sep 2024 15:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663422; x=1726268222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCQ1sFR6q4N5GvvlFRQ23FRxGveAlTZ5FLsIiX1fOqY=;
        b=Ie/dnWpCgiuoK5/tddvQ7LKGAgsbLtoCf6mgGbtcT71iHHnQGVQp1WtIRTygI0fC3Z
         oegirP1HlNV4Z+WLqLkA4ohe2/C41t+iJGlgE1egfiuVIDeVrp2JPkYDkOt+kNBUo7qy
         aaZjuqUdcg1ikjcayU/Tr5vRh9u72V4lL03VWfJaATZkB5h1rNAfA9MNG8R2q61Orbno
         DVP2pFWbKCt8ltD7tlWhEA4nbEtNFUl+wrrHi0N339SRDrJIOwjikjHfeP/fR/a7/zIA
         k5z7Q7jyHOoF7qZzBovlCjElHxcG2GiJjyFjdRyXsjE4R4zjc4lUCskd4MZuB1FF4JnZ
         FJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663422; x=1726268222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCQ1sFR6q4N5GvvlFRQ23FRxGveAlTZ5FLsIiX1fOqY=;
        b=A5P0DdcT+PrnWau9T/GDtKwb0bSbAa+YjW3dQh0e91VCaNnS8SiUhUQ5o3CVEm/M7P
         Sbv39hEmZwJtgCweCEHLbiACT7z+EM7A4G7EROIDLiNm/yQpx5jodg3FOTwA7bFAQ0gj
         8ZptpSqwfacdYJNyogfkxajh6MsUWBE3D8XlJXJtq1ivzQ0lsSL6ii+JgLmp7g3vMLtn
         wcLYTBp9x3fvOqPn9KI2bBzcIAl9odnmSwh+PA5TTuZwvyqkB5tGrUEn8iq9eMyu1Hxi
         Co8oXRi6HNJdh1vof5r6JeiIzSGiJFue+FRs05m6xI0AqItylb8g2lcftWNbIdFDMEX+
         0Apw==
X-Forwarded-Encrypted: i=1; AJvYcCVLt8fpM6Q4iArNmLvAvtJ4NHE+uo/S1LLp8sWHCigGQM+xuqPUOnohnoESBfF5fAXNjqLL2Cpob/x5sQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIZ0nQTqItd9M96xpOucAMFwvtU7G9tLRQK9CX4cXPBGmsEG9N
	aApxlWbYKKD64IleGgNTs1PjUloJ5ZPGGV7nFxOLra8iPmiwfJHB8I5OqlvY
X-Google-Smtp-Source: AGHT+IGJ6gzQkF2S9wNkzcDzctZY5nEoDtVuCYWlHsBqBW5skC54eWB3Kt2NmCi50PZKCSauBvcXGg==
X-Received: by 2002:a17:907:7b92:b0:a7a:9a78:4b5a with SMTP id a640c23a62f3a-a8a887fcdb3mr350202066b.52.1725663421631;
        Fri, 06 Sep 2024 15:57:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:57:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 4/8] block: introduce blk_validate_byte_range()
Date: Fri,  6 Sep 2024 23:57:21 +0100
Message-ID: <fa8054b786555785c7a181fbd977539342960fe4.1725621577.git.asml.silence@gmail.com>
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

In preparation to further changes extract a helper function out of
blk_ioctl_discard() that validates if we can do IO against the given
range of disk byte addresses.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e8e4a4190f18..a820f692dd1c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -92,38 +92,46 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
+static int blk_validate_byte_range(struct block_device *bdev,
+				   uint64_t start, uint64_t len)
+{
+	unsigned int bs_mask = bdev_logical_block_size(bdev) - 1;
+	uint64_t end;
+
+	if ((start | len) & bs_mask)
+		return -EINVAL;
+	if (!len)
+		return -EINVAL;
+	if (check_add_overflow(start, len, &end) || end > bdev_nr_bytes(bdev))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
-	unsigned int bs_mask = bdev_logical_block_size(bdev) - 1;
-	uint64_t range[2], start, len, end;
+	uint64_t range[2], start, len;
 	struct bio *prev = NULL, *bio;
 	sector_t sector, nr_sects;
 	struct blk_plug plug;
 	int err;
 
-	if (!(mode & BLK_OPEN_WRITE))
-		return -EBADF;
-
-	if (!bdev_max_discard_sectors(bdev))
-		return -EOPNOTSUPP;
-	if (bdev_read_only(bdev))
-		return -EPERM;
-
 	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
 		return -EFAULT;
-
 	start = range[0];
 	len = range[1];
 
-	if (!len)
-		return -EINVAL;
-	if ((start | len) & bs_mask)
-		return -EINVAL;
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
 
-	if (check_add_overflow(start, len, &end) ||
-	    end > bdev_nr_bytes(bdev))
-		return -EINVAL;
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	err = blk_validate_byte_range(bdev, start, len);
+	if (err)
+		return err;
 
 	filemap_invalidate_lock(bdev->bd_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
-- 
2.45.2



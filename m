Return-Path: <io-uring+bounces-2886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67FC95AC04
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D2EA287D78
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E85D23774;
	Thu, 22 Aug 2024 03:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfM1TmAB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8762E41A92;
	Thu, 22 Aug 2024 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297747; cv=none; b=kgc6lhdbfsI2OInldYUZ/USnzU4M7jndeApLS01gPegpPaYha0x75Nm5RxSSa1fPQ4aXz+qPTHtVpUpHsvIgbY3NNq+zL5mkYsSDdU97je9eHza7OYOh2Nrd8Xu+m8YljnP+s+u/p9AZLPpDOIKxkOzDJp5GRrB6CWv14iqsYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297747; c=relaxed/simple;
	bh=6fn6CsIOzyK68TmwcPPLBT3BLJJOWUnLS3iRmcSIu8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goI03oY+tkmZvkrAWlvc8uH3TH3MHBf/yuuc9zb+m/brIs8AbEKjSBeBVtPewvhHjjtJkK5CTPAzDuJfTDhQHLnrZxLxbXwsqmyZjAEPSu4ZAf3k+b4ka3+WAwA5o33rNT/6/ZgAjTaGykCSQl5B7DI4ArjJ3VWtdzgX0NxgdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kfM1TmAB; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-429d2d7be1eso1490095e9.1;
        Wed, 21 Aug 2024 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297744; x=1724902544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lswIDLrIj7CXYuFfzAb9ZDGauPy9RK0EG0P/gPYjyms=;
        b=kfM1TmABqcPDc+nGmjNYkQxkJbrJCxj7Jjww0Q7BljtKy5TBfYCJjPjfsLjX2nGxS4
         oUhF1Ma9+Bvf6Dqfug7sHEvfSh7UgGqnojkJ0xGpN4aLz8qcqtlQbtxs5akiwmHgngFt
         0EBSoYt0slJ0BtFVMCcbXDH1uNb7p+983i7m++NtXjc6U/yOtrLejpqD4NHmXYvgid+0
         y1+36ZKBAeA4mK70thdOF6hUOS+DhhChTx4nfymAr2pIlyxJLgBd9UbXT1mgIIRJCO0f
         km2Rom1K3ZoEUAmL+fpsXHI6z/V8y0o/Rzno7oNXL2uaVcI4+xAK+im2HwX8obzlwGcP
         Tfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297744; x=1724902544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lswIDLrIj7CXYuFfzAb9ZDGauPy9RK0EG0P/gPYjyms=;
        b=ERFTEabT8XurIkSP74WiiHGMdw2xlMWJLVy4dpd8dPIlWmDgc/90lhyxhqn929u52W
         yW9rW+LqwzlsLk2sjxOQHAfA245rhU9XzTI2FXtAyeZb8xSSa8o8IeLQjJWThFtHkePl
         VsGrxcOyX3IN3gZcTkI01KwglD8zAHQfbiky5/qMzltZllf07LoNr+CmaKF45rs++8BZ
         aLdKOF465AUuMttVGrXieSXPZF9ZTEEAFWkQHhRupi6hT4fPOlfMFFRoASKfhrksjH9b
         8Hxv+zPubEBfgws1B9YSOalVl05DQoWbJp6JwO1hEyj1Rl5IvpPql64wX7wR2myx9i2L
         ZTPA==
X-Forwarded-Encrypted: i=1; AJvYcCUFCC5sHbt9MeAGbr4GuUlK6GDYoynIO1YQgRB6BnT7LWmGPyaVMPt+QLUhxejB9KUHXNkMcsSmejiySg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4JEPCj4jS10sbimRAqNR/j4qFrrIVvDZ1nw5BjbMEZHQSwzUA
	Z3wmu4DphZ29hkQqdg67VJ7m2SAqYiUgSuku8uD9RQqUo+61bhzT48RgRg==
X-Google-Smtp-Source: AGHT+IG8hgkDMcLSSneo44THzR5IGgkExEMFh9iktxvoExcbZbFlYFw8o0WlWu1YjpgQLAsbGqHOpQ==
X-Received: by 2002:a05:600c:3c9d:b0:428:6ac:426e with SMTP id 5b1f17b1804b1-42ac3899e82mr7892605e9.5.1724297743449;
        Wed, 21 Aug 2024 20:35:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 7/7] block: implement async secure erase
Date: Thu, 22 Aug 2024 04:35:57 +0100
Message-ID: <5ee52b6cc60fb3d4ecc3d689a3b30eabf4359dba.1724297388.git.asml.silence@gmail.com>
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

Add yet another io_uring cmd implementing async secure erases.
It has same page cache races as async discards and write zeroes and
reuses the common paths in general.

Suggested-by: Conrad Meyer <conradmeyer@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c           | 15 +++++++++++++++
 include/uapi/linux/fs.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 6f0676f21e7b..ab8bab6ee806 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -841,6 +841,18 @@ static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
 				bdev_write_zeroes_sectors(bdev), opf);
 }
 
+static int blkdev_cmd_secure_erase(struct io_uring_cmd *cmd,
+				   struct block_device *bdev,
+				   uint64_t start, uint64_t len, bool nowait)
+{
+	blk_opf_t opf = REQ_OP_SECURE_ERASE;
+
+	if (nowait)
+		opf |= REQ_NOWAIT;
+	return blkdev_queue_cmd(cmd, bdev, start, len,
+				bdev_max_secure_erase_sectors(bdev), opf);
+}
+
 static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
 			      struct block_device *bdev,
 			      uint64_t start, uint64_t len, bool nowait)
@@ -911,6 +923,9 @@ int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	case BLOCK_URING_CMD_WRITE_ZEROES:
 		return blkdev_cmd_write_zeroes(cmd, bdev, start, len,
 					       bc->nowait);
+	case BLOCK_URING_CMD_SECURE_ERASE:
+		return blkdev_cmd_secure_erase(cmd, bdev, start, len,
+					       bc->nowait);
 	}
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index b9e20ce57a28..425957589bdf 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -210,6 +210,7 @@ struct fsxattr {
 
 #define BLOCK_URING_CMD_DISCARD			0
 #define BLOCK_URING_CMD_WRITE_ZEROES		1
+#define BLOCK_URING_CMD_SECURE_ERASE		2
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.45.2



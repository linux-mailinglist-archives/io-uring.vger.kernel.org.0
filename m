Return-Path: <io-uring+bounces-2883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F99F95ABFF
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF191B229A1
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE523BB47;
	Thu, 22 Aug 2024 03:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XyPh/weC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97134364A4;
	Thu, 22 Aug 2024 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297744; cv=none; b=SkOCK08jF6XesaFbzn8kMiEcVSSSJWlaesYdIdLQ9SmuegsUxcpxgidZFXsJNYl5C5xz3CuzoIxln1Cl5ZCyiG9KF9bAf+yhT8hHH7+xU2c1nmCuHExEE3nNvFw+U/URKAW2sO6rm2dWPigq+mAPfcljGt5AW3K5f50yNK1yCh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297744; c=relaxed/simple;
	bh=eor95KyuHkxSooEEY/l0Xm4XcRE0Im5ZycLWR04WdVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTp5irfDlezLeOvvHCE772ptHV2o7/7Zvb/dPwbVc+h0XT56GSy8GXa33Er0hu3qYpqh4SukqBgg489dMk/m5sI7S0V1BEn5Bgp5qp+7eWJC/HCNx6wTLHUIRllNUtKp7zaChSodL6FTWuMCmVvq+44R9jOqH6Ak+dpL6gO+rTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XyPh/weC; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37182eee02dso163163f8f.1;
        Wed, 21 Aug 2024 20:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297740; x=1724902540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7yUgVOy5MpRKfji6spWllEFui/I+HP/hnabDQ6U+Y0=;
        b=XyPh/weC9qV9n9T8M+iLxbtd+ztGWBiqkNFa643i4LsCQ0IfZIDFvcqqc3z58/5sH9
         YpQ+LrnLjo2P3JLwv0hNO0+VuhsC8ZaylbBEuVXQQ71kV1ZRtOOjXjFsXFyKh95YmZG5
         MKGHughWbjMfoMxP1blpH7+PqptE4dWI7UH5NRrmd4Q9l+lcPgf4JYWT2/0jlmKLfvB/
         lBnNB6I3wWTefzm5i7kdSSv55PPvQa1JmhiJcAPZgNM9PJ3GunP1oDwF7/yZLpou3fPN
         mOCgGpkDVl7af6Xx28BGTJeszrF2VfCWUEbSPOYQwu4bg3LfXXZyu9QLP7clODz7/QJ/
         904w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297740; x=1724902540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7yUgVOy5MpRKfji6spWllEFui/I+HP/hnabDQ6U+Y0=;
        b=VK0wmcnEox/t6bmoX/JBfKWQHOoGpG6oxwBsxru7YcGjWj/nGHBFO+oz8FJK0rWNhg
         MMzqO06dgsjSWZ1DrLwO2nDIEKaRaF4PnHfW2ru6r3rwvgWXXv/n+Fu/dQ3rB8Y8BKVM
         GTn5IKSE/CEGVX2351R9eEM1DBlUOICMgb5CLYAG5mIyJiAYFlKzGkStJgr76+UL3lEf
         ji/mTJYx6ILXDFXCLMkkXqVgsH8XCTH9fcRTQNTCZvz/f+xYV3q9M1jc3KqucIKjqmxY
         MS4OUQwWJXvl7Egvh1JEj3HJZBT8YXBzVkFePl7hUk6w7dI42WlytVjXtkiLxsCB2XzE
         5Otw==
X-Forwarded-Encrypted: i=1; AJvYcCV+WGoVOTNLs5yMqtus5bF/PUl7HHQUf7rAwbNrWrHaOwNn9CBiuC3xgM/dEc1RUIkhEL5h+N8wPJv8yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPnPf00X1puP7fOsZ999E/ctP5+IToeSucXxTQlv1MGN7K8Mdf
	CfnWNujdmHVC1hjyMb6GbUX48KT3niiD6VB80+kuNdgh48suZZVLQe6JJw==
X-Google-Smtp-Source: AGHT+IFHlvWFFCxl8YjFlJaGHJvsG1W8kc3fcAPScv4ZmRwi4I8WRIgqdUzhutwlfp/55qdQx9eetw==
X-Received: by 2002:a5d:4487:0:b0:365:aec0:e191 with SMTP id ffacd0b85a97d-373052b4b25mr815314f8f.21.1724297740108;
        Wed, 21 Aug 2024 20:35:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/7] block: introduce blk_validate_write()
Date: Thu, 22 Aug 2024 04:35:54 +0100
Message-ID: <2ef85c782997ad40e923e7640039e0c7795e19da.1724297388.git.asml.silence@gmail.com>
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

In preparation to further changes extract a helper function out of
blk_ioctl_discard() that validates if it's allowed to do a write-like
operation for the given range.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/ioctl.c | 47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e8e4a4190f18..8df0bc8002f5 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -92,38 +92,49 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
+static int blk_validate_write(struct block_device *bdev, blk_mode_t mode,
+			      uint64_t start, uint64_t len)
+{
+	unsigned int bs_mask;
+	uint64_t end;
+
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	bs_mask = bdev_logical_block_size(bdev) - 1;
+	if ((start | len) & bs_mask)
+		return -EINVAL;
+	if (!len)
+		return -EINVAL;
+
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
+	err = blk_validate_write(bdev, mode, start, len);
+	if (err)
+		return err;
 
 	filemap_invalidate_lock(bdev->bd_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
-- 
2.45.2



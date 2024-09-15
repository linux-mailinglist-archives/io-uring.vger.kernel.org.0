Return-Path: <io-uring+bounces-3189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C42979775
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 17:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 263BB1C20B04
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 15:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30C91BDCF;
	Sun, 15 Sep 2024 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vlx/FH+C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F8D18B04
	for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726413716; cv=none; b=rKkYN9Vpvsg1cLS0gJDgPUJIUwZeKpiiNBHyB6i9Mgy/tVuh0gL9xlmKE98II0Pyes0R2hwsNCUANoOPbogQ/Kyjq3siHKeaVMz5I7RoVqHNCUcOjEOYRUMXyxWW/6ZXMUubd/ySoWanKHSIIEtUIUxnN52BmCU7A1QIb+D1xag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726413716; c=relaxed/simple;
	bh=XkNE75XYr5tMQSlePTg+T9955AqUnvgAo5bM/nQLzTw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=n/KQePJST/TYLxR1cYshDqA4Eqj8FvHH3DNAgul4ffWmfZ2ordrnXgwJyy4CxvYBW6R26iizXUmP1njCIHEBlGqTDk5rG7RRmobg1StW2XCW27HTfhnOA3+2i6i/NhLTnTGeLYrhHkFLBJhJJZWRKIVDIRF12nE7ZhU69B2VMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vlx/FH+C; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2059204f448so32557085ad.0
        for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 08:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726413710; x=1727018510; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nLkZpWged2oqHpmUC2pcXLdF9khzGHKKrpX/HrIBkE=;
        b=vlx/FH+CRwSbv94qj6ol7gwWtqqu22A8D22PTKyd1RB/nhaET7PiwIg9Zi66e4ectx
         oHtxPx1yfkJyaNP5j9R4+j10vx5Y5in3cZiXvq5JFdPcH9FOfnOl/JbtJ4QZKMT+MBnz
         OBckK5CWVnhiZqBl2LvHLx8HXxHG7tSzdq93SBlwnLnwwKwKqVakG78PZYTxgwTqjA0J
         VkVQdFtrXiIpSWfSMq/9EAoXUHkw0GCG+boWi9Jo6W4cbzhqqkd/7laM99OQIBokZo3g
         qWVsLJtZ5IgYkLzbD23LvCOJWhvNFY8x+9ymifH3fOEzchRUO8aQbQrmrFi8rT2eWjrN
         2AfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726413710; x=1727018510;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7nLkZpWged2oqHpmUC2pcXLdF9khzGHKKrpX/HrIBkE=;
        b=AJ9ldobPscbwaulijb0um6N4+aWxAj/WEAFwt1pQ9fpA3F2Ptn8a3Ri1fuv7AIKsmc
         6wHsOPpzm9dPsoiORW+8pxT8/V8/JWMjbLvsDaTjNKcwK3vuuncI+eCGNvb8ppSYGpOJ
         UNvbN4Ch/GfEe54IZhKEszMPe7mLcXM3EIGNeG8gvXncjGp/CUXzIBglKG/98rnpU7O1
         YizmEA6GdPnxPkQzwbT2yK3p5XrpC2xTDnTB19YhqOxvb3kqTTzF51UvNWQoUsc2d3Hm
         JiQr32ff8/UmYnNA0gFe0M8d0ib3WjKPA2R8dp6HWQeCI+MAqzcCoSzfFyTf633Nx1U6
         CORA==
X-Gm-Message-State: AOJu0YyK4xDHeghwjhu6E7akNwTeYNxEZtBsOaor97qm9GaAeaaKM5sn
	Xba18hk6Y//KOBLojdcidwArtUgktspKjw7zY/YhoHjCRe/AwF1qrxNUHZzWpTQBCoQGgNMhdXS
	l
X-Google-Smtp-Source: AGHT+IHGGD9lwuPaDfv4ZGy5QsV8Ys5vPlGxQvDATrbo2Ahg4UksLDPjU8LQBStMvcM6CyePFImIWw==
X-Received: by 2002:a17:903:32c3:b0:206:a3a9:197e with SMTP id d9443c01a7336-2076e31b8afmr212944255ad.4.1726413709982;
        Sun, 15 Sep 2024 08:21:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946dec8bsm22536965ad.163.2024.09.15.08.21.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Sep 2024 08:21:49 -0700 (PDT)
Message-ID: <27e7258c-b6d0-439c-854f-e6441a82148b@kernel.dk>
Date: Sun, 15 Sep 2024 09:21:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: rename "copy buffers" to "clone buffers"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A recent commit added support for copying registered buffers from one
ring to another. But that term is a bit confusing, as no copying of
buffer data is done here. What is being done is simply cloning the
buffer registrations from one ring to another.

Rename it while we still can, so that it's more descriptive. No
functional changes in this patch.

Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9dc5bb428c8a..1fe79e750470 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -609,8 +609,8 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_CLOCK			= 29,
 
-	/* copy registered buffers from source ring to current ring */
-	IORING_REGISTER_COPY_BUFFERS		= 30,
+	/* clone registered buffers from source ring to current ring */
+	IORING_REGISTER_CLONE_BUFFERS		= 30,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
@@ -701,7 +701,7 @@ enum {
 	IORING_REGISTER_SRC_REGISTERED = 1,
 };
 
-struct io_uring_copy_buffers {
+struct io_uring_clone_buffers {
 	__u32	src_fd;
 	__u32	flags;
 	__u32	pad[6];
diff --git a/io_uring/register.c b/io_uring/register.c
index dab0f8024ddf..b8a48a6a89ee 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -542,11 +542,11 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clock(ctx, arg);
 		break;
-	case IORING_REGISTER_COPY_BUFFERS:
+	case IORING_REGISTER_CLONE_BUFFERS:
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_register_copy_buffers(ctx, arg);
+		ret = io_register_clone_buffers(ctx, arg);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 40696a395f0a..9264e555ae59 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1139,7 +1139,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
+static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
 {
 	struct io_mapped_ubuf **user_bufs;
 	struct io_rsrc_data *data;
@@ -1203,9 +1203,9 @@ static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
  *
  * Since the memory is already accounted once, don't account it again.
  */
-int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg)
+int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 {
-	struct io_uring_copy_buffers buf;
+	struct io_uring_clone_buffers buf;
 	bool registered_src;
 	struct file *file;
 	int ret;
@@ -1223,7 +1223,7 @@ int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	file = io_uring_register_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-	ret = io_copy_buffers(ctx, file->private_data);
+	ret = io_clone_buffers(ctx, file->private_data);
 	if (!registered_src)
 		fput(file);
 	return ret;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 93546ab337a6..eb4803e473b0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -68,7 +68,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len);
 
-int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg);
+int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,

-- 
Jens Axboe



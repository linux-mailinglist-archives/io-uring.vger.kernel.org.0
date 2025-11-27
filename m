Return-Path: <io-uring+bounces-10823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 876F5C9021F
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29FD63A9EE9
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23735313274;
	Thu, 27 Nov 2025 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLjFcnh6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C46A30DEBD
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276062; cv=none; b=lkrRQ4lzUpPp4sWqykv3xRzdKfXTg01NDS2juFal4nUXG0u3XZE7bCJ6FyiRtN4Nq4pTdhLi8X3n+jbrhMCdC0E1xNZF+3Y4kayhEY/QFAEGSmMpoOGQOlfo9oI3yeaH0Z4DezmVEfTaLWWgmO9c7TQtYuUX3KpAF5Qspk0PZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276062; c=relaxed/simple;
	bh=Mnn9wb9sRTkIJLXCShYMZgz7pZo/y5Y+Ja2/AUVncu4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rJO2CRs2mse+pzja9RHdTKBNwdzZeMirmmfsVB6MTT5Vrxx5taO4upyQdMsMDJg5HfiFogBREYtOk8zR9kRci7LbWtnHwlCV58W9NCqbcOn+xGu5SsJMJl2uWGjadVvqeNKVq8OfKQEvEmm6c10rL0dJr6GykVqamiqeoFbN6nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLjFcnh6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-429c82bf86bso796424f8f.1
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276058; x=1764880858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TZrDwUzk1jhJojipsQHKrfyEq2t/8kD+pLesRqPqbM4=;
        b=kLjFcnh65TVvNis9UzA5QyzAMXh9A9nOmmEnsGJirYIiQjtpOXnbKZP6PGAgiboaw4
         7YWspoKxfR1ICz6b0akDzUW0Awf/KZwH5r8+HKWt234Rm2YTMGsTMOxSIuROehWE2iqD
         f/fbVY1/d64W679sRX66AqfSE6iyeRnZm5T7Qzio/akBtgYTPhBEKfWyadXF/9E1mrXI
         ATDc2a9O3JQFa/0nFV1G0GVAVTYf2lXqLeicH3P1AqWFgxhkQbhZ7UtR1qM7otsQOftj
         uupoSZP/aOEhaVb7uBg8tLwO4LaMj8Uw+9+5yKxYufUkMJWPzMkOig8WgG4T0Exs7Kfc
         uXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276058; x=1764880858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZrDwUzk1jhJojipsQHKrfyEq2t/8kD+pLesRqPqbM4=;
        b=AxkR4PX/km3QNH2Kmb+G4thj4lBWKvGU99grMP3/BFmM2rX37bVBSRdqyUWH8W920F
         gafIvucyKkcXttk4IkNW88gjhpeL2IW2ZDaUy5EWKDL7Lgbxu4J1xwnwFaOV183LPE5Z
         yV1TBbasH1EHfx840+Jj+NAS8I3uwAgEMLSTLALy3EQC5aIvY1I2cq5s307XyBfFi9wL
         GJr7v/r3Wzd9wqXQ1aqxBeA2bH+EiopiykhL/pnkZ8Izq91ufQ2l+fqi1/nDQMigA+dA
         x3zunhO5mvit4/XtcQRixcj6BGRbeW1XBDWUmoysj/80ArXUG26vk9Vvf7tHwPwLCMR2
         eMSw==
X-Gm-Message-State: AOJu0YxhDJQfomojkKo/qdBr5jlp51dJLxiZ3bkcMx7VZFhliTO6we31
	DrGq0j7Ce9U1n5Ww+H5KHvfkWcZ+l3jTNOFxGfzbx2QrcquscV5VXuFckB7cnw==
X-Gm-Gg: ASbGncuFcOydIufMRMxowpsjszcdOPl8bkLb0xoyrUtZEpeb0vRi7aIxCeTqTAtwpDi
	dfSFqIJfoGvZ33lvK00GiZw6btPXhShbxJwntsITTJKj/eHXx/BnrSnoySN3EljKQSChT5XnYxd
	od8MZ2Q1cobXAMOg/VQbxNLHdEjJU2JA9jHsLMLjtNYAgP68CKk9gqqaVyTuq/MwFw6vLXO9nBv
	6AbUtipl3S2gaSPu3lA3xKZW+dtM7rBwcIkKQpF/N0ruCP5Y0G3Pb6jBUhwttw6nxLcpDdIeMGE
	1yUKBGnFXphGkbu0F5t1ZIT64F2HbX6jZgz1RQAydRkPpOtDdLog8/Jcr18Z4SR5Zot/qicugRx
	U9qBct1eq1WSxQMhL8eQSDAM5bcRqUnCORGEzeadPLSy6JGNzypBSRtCsot+R5G8I9KrOxHAldR
	fvaELfJq63sMGGqg==
X-Google-Smtp-Source: AGHT+IGBTqkssyUQXy37QRTA7vMYiUC3UhkdYS3Gn35v/sgqJjvtbjsODVx5dVN3kGxZDzZmup4B9w==
X-Received: by 2002:a05:6000:2084:b0:42b:3cc6:a4d7 with SMTP id ffacd0b85a97d-42cc1cf825bmr27330752f8f.37.1764276058065;
        Thu, 27 Nov 2025 12:40:58 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca1a2easm5757423f8f.23.2025.11.27.12.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:40:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only] io_uring/zcrx: implement large rx buffer support
Date: Thu, 27 Nov 2025 20:40:52 +0000
Message-ID: <7486ab32e99be1f614b3ef8d0e9bc77015b173f7.1764265323.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are network cards that support receive buffers larger than 4K, and
that can be vastly beneficial for performance, and benchmarks for this
patch showed up to 30% CPU util improvement for 32K vs 4K buffers.

Allows zcrx users to specify the size in struct
io_uring_zcrx_ifq_reg::rx_buf_len. If set to zero, zcrx will use a
default value. zcrx will check and fail if the memory backing the area
can't be split into physically contiguous chunks of the required size.
It's more restrictive as it only needs dma addresses to be contig, but
that's beyond this series.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Depends on networking patches

 include/uapi/linux/io_uring.h |  2 +-
 io_uring/zcrx.c               | 39 ++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..3184f7e7f1f2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1082,7 +1082,7 @@ struct io_uring_zcrx_ifq_reg {
 
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
-	__u32	__resv2;
+	__u32	rx_buf_len;
 	__u64	__resv[3];
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b99cf2c6670a..30dbdf1cff13 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -15,6 +15,7 @@
 #include <net/netlink.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
+#include <net/netdev_queues.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
@@ -55,6 +56,18 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->mem.pages[net_iov_idx(niov) << niov_pages_shift];
 }
 
+static int io_area_max_shift(struct io_zcrx_mem *mem)
+{
+	struct sg_table *sgt = mem->sgt;
+	struct scatterlist *sg;
+	unsigned shift = -1U;
+	unsigned i;
+
+	for_each_sgtable_dma_sg(sgt, sg, i)
+		shift = min(shift, __ffs(sg->length));
+	return shift;
+}
+
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
@@ -416,12 +429,21 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 }
 
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_uring_zcrx_area_reg *area_reg)
+			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_uring_zcrx_ifq_reg *reg)
 {
+	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
 	unsigned nr_iovs;
 	int i, ret;
 
+	if (reg->rx_buf_len) {
+		if (!is_power_of_2(reg->rx_buf_len) ||
+		     reg->rx_buf_len < PAGE_SIZE)
+			return -EINVAL;
+		buf_size_shift = ilog2(reg->rx_buf_len);
+	}
+
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
@@ -432,7 +454,12 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto err;
 
-	ifq->niov_shift = PAGE_SHIFT;
+	if (buf_size_shift > io_area_max_shift(&area->mem)) {
+		ret = -ERANGE;
+		goto err;
+	}
+
+	ifq->niov_shift = buf_size_shift;
 	nr_iovs = area->mem.size >> ifq->niov_shift;
 	area->nia.num_niovs = nr_iovs;
 
@@ -742,8 +769,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
-	    reg.__resv2 || reg.zcrx_id)
+	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.flags & ZCRX_REG_IMPORT)
 		return import_zcrx(ctx, arg, &reg);
@@ -800,10 +826,11 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	get_device(ifq->dev);
 
-	ret = io_zcrx_create_area(ifq, &area);
+	ret = io_zcrx_create_area(ifq, &area, &reg);
 	if (ret)
 		goto netdev_put_unlock;
 
+	mp_param.rx_buf_len = 1U << ifq->niov_shift;
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
 	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
@@ -821,6 +848,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			goto err;
 	}
 
+	reg.rx_buf_len = 1U << ifq->niov_shift;
+
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
 	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
 	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
-- 
2.52.0



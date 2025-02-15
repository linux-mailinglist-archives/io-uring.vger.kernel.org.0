Return-Path: <io-uring+bounces-6470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0E9A36BFC
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 05:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 778133AC79B
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 04:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C3EC8E0;
	Sat, 15 Feb 2025 04:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZyRxuAff"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FAC158D8B
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 04:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739593141; cv=none; b=dXmKZCGVlgI91Te3tt2sLaR0LSc1QCiPRnuO3QXHqUh22LXDUEknDi2k7QFUKngMScBnYU/L7drhzNLYGRi3lFu0NL/JvtSQEKc08MIlw/cawhFQ0ssHYNcK1jTPe9HmiNNPGxWBRwNC7ZBIUbWYmsXnAeQSiMlCT0uFK59sowI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739593141; c=relaxed/simple;
	bh=IHQqYdAnSubEo0UIJU5NPA3TiV9sCAcTnH1ntFce2J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW6hKOxOzHzq8OjHPOc1S5TLFpO6US9lgXCWqixJl+mYXHit6sQQmBGyxnVU4rXclfvweDhFrP0Ob995qcDCzZaQUwY6Me/vNO9+ZpaiVwX7BlS0udRIw3DZk/IPVLelmtY6rFl0ez9XhX7peQTyS2RbIlTgJZwwOjUxICA9hE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ZyRxuAff; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f441791e40so3977615a91.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 20:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739593139; x=1740197939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpsioLT1KhWBk/eG5I2Cw6O7k3TyPOA7reDLw/R9CC4=;
        b=ZyRxuAffrD8Pn5wTKCz5MZWO8nNt3ShRgDbvKbHIP0My6/w3hSeets1opsCeFWsN4l
         RNDksEFbk+hLFNgV/HvvjMKaZuT1iUABqBdRfcGQYUA6J7kSnUVDuTwDrMNILaIvCN+H
         w1xsZ2SvWwXA/S01LZBjjOs7eS7osnJ189Hgey9n0/5pChsOHKmSzAlBkFSafJ2fmMar
         JX8W+YMS7YQ4pCXu3/yNJTozKRj6l+p45UKNTOixWI9uVjz7ZSjtBW4Koh9RumS4XwBp
         8OdLZXAdJu5YoZ+kKNFtBi2ZWdYEkrqqDni71Tz31AbG10zwoiFVLzQvgNhZkDX50p3j
         l9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739593139; x=1740197939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpsioLT1KhWBk/eG5I2Cw6O7k3TyPOA7reDLw/R9CC4=;
        b=nvDx9+MawQGjNwVDscWyYUgqH9Q1yWE51mxKRfmGedROGWtbKvcQlq7ScHsVYCqB/t
         bVPzWykKRvqONy11KA/GmwppVs1Uv4Aur3S+wSNyLv+Z5cE9XB8gaSo1/DBq3vgojcf+
         44ZUPOcKjEy6oDhRtE4zI+iKzWjRGNUo6W1tmNYeS5Vk/BUPq5xvL+p59ZM+7fFc9/jZ
         I/5+dl5DPKrfQXZbmmdptXYFSb7XoRPFEYHPOdUHg8NV9sFOwr21Eb8P1OKJgmt0Y/gn
         6a/hoxICJMZPRVo4daJmqQM7Pnyk6faG6AzUUf1Dj+ZdhPjp/wfDzY2Ih/iPfL4qUmw2
         Gsrg==
X-Gm-Message-State: AOJu0YwkpNEeYB+oUwSXRMXG+5P4hBAHyBoxrmV4caTrp+wOa0VEhbMW
	Gbo2tz2YRqdHzSqKyzIfM8YtGla/k22qebA/R9GjO8xQGjwikXwPkCctJpTmo3w44QHJRnUeqQa
	C
X-Gm-Gg: ASbGncvgOW1LuOWReYMEGBamZ4BFpuUgHrvwQStWoonUt6a+FybtyWPb00E/U94yzmD
	V/6WRUo3Xn6K7Z5YhUj4Jk4XfvbC1yYMUw4llukvkDsdqHF32HAmCgK4U220SRKK9nltNm1alak
	7Vw5eQBtbkLcOZm3X4t0igltq4UrcezHqDaiXD+KNpxXTz6W9AJrh12UPCqE7q4h87GOHbeFA73
	qAaLnrSR5aftar7BbcUk9YHMXr6+9XZafha9fKR5+kpB677CV66Xb5hvfEY3LnAmpZ56Q3tlyw=
X-Google-Smtp-Source: AGHT+IGarh0D2jLR7MkTC2c5M1IRH7d9sVIR8GSH/e+1WRXLLh+E3wy6sRIgdWfpJeSToKEoW4tzpQ==
X-Received: by 2002:a17:90b:3d86:b0:2fa:e9b:33b8 with SMTP id 98e67ed59e1d1-2fc40f22d67mr3023608a91.18.1739593139537;
        Fri, 14 Feb 2025 20:18:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:e::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13bbeec8sm3912134a91.49.2025.02.14.20.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 20:18:59 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v1 1/3] zcrx: sync kernel headers
Date: Fri, 14 Feb 2025 20:18:55 -0800
Message-ID: <20250215041857.2108684-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215041857.2108684-1-dw@davidwei.uk>
References: <20250215041857.2108684-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sync linux/io_uring.h with zcrx changes.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/include/liburing/io_uring.h | 62 +++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 765919883cff..d2fcd1d22ea0 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -87,6 +87,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	zcrx_ifq_idx;
 		__u32	optlen;
 		struct {
 			__u16	addr_len;
@@ -262,6 +263,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -364,7 +366,7 @@ enum io_uring_op {
  *				result 	will be the number of buffers send, with
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
- *				will be contiguous from the starting buffer ID.
+ *				will be	contigious from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -424,7 +426,7 @@ enum io_uring_msg_ring_flags {
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	user_data;	/* sqe->user_data submission passed back */
+	__u64	user_data;	/* sqe->user_data value passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 
@@ -616,6 +618,13 @@ enum io_uring_register_op {
 	/* clone registered buffers from source ring to current ring */
 	IORING_REGISTER_CLONE_BUFFERS		= 30,
 
+	/* send MSG_RING without having a ring */
+	IORING_REGISTER_SEND_MSG_RING		= 31,
+
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 32,
+
+	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
 	IORING_REGISTER_MEM_REGION		= 34,
@@ -916,6 +925,55 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SETSOCKOPT,
 };
 
+/* Zero copy receive refill queue entry */
+struct io_uring_zcrx_rqe {
+	__u64	off;
+	__u32	len;
+	__u32	__pad;
+};
+
+struct io_uring_zcrx_cqe {
+	__u64	off;
+	__u64	__pad;
+};
+
+/* The bit from which area id is encoded into offsets */
+#define IORING_ZCRX_AREA_SHIFT	48
+#define IORING_ZCRX_AREA_MASK	(~(((__u64)1 << IORING_ZCRX_AREA_SHIFT) - 1))
+
+struct io_uring_zcrx_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u32	__resv2;
+	__u64	__resv[2];
+};
+
+struct io_uring_zcrx_area_reg {
+	__u64	addr;
+	__u64	len;
+	__u64	rq_area_token;
+	__u32	flags;
+	__u32	__resv1;
+	__u64	__resv2[2];
+};
+
+/*
+ * Argument for IORING_REGISTER_ZCRX_IFQ
+ */
+struct io_uring_zcrx_ifq_reg {
+	__u32	if_idx;
+	__u32	if_rxq;
+	__u32	rq_entries;
+	__u32	flags;
+
+	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64	region_ptr; /* struct io_uring_region_desc * */
+
+	struct io_uring_zcrx_offsets offsets;
+	__u64	__resv[4];
+};
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.43.5



Return-Path: <io-uring+bounces-3955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 051C89ACFE8
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0A81F228B9
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A15D1CB530;
	Wed, 23 Oct 2024 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jbyhWYkK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685B1CB31C
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700134; cv=none; b=aIIPac4LjfrKVRUQ/y3YneRjprh5YwxE4ZpQSZTKIKrgNBPP0j6iMfaxanGo0p97AvLjAl09RKnbjd0SCCy/90k8sBAPNBOBl2WYMShliygc8frRZzh+dcCYU9IC3W/1NkphtZYj9k2Dt522djcriz3h8yBULb9dvp+DUAmCZDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700134; c=relaxed/simple;
	bh=O7ILj4Waqkz06uXTxRShQ3wnBOigvCdfeeJ0N9Bhr78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQb/oFwvV4Ce3cTYKj5u97Vhr9JA4YHK/Tbt075tCvm3L6LZiMStrigdb7e54J9TNh7C54V8sWlJDWYe2vWOGdu7EfGaYFgNkKSJVcATKsmjCBMD6qS3oTgEnpPPJ5J3caLjnkFWXwLEPIGXdAi1yTv02iVmlTPO4f/wpmY8xeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jbyhWYkK; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8377fd760b0so278304039f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700131; x=1730304931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAVLaZMsYlaRm01XXXR+pTcArBexY2/Nbj1JvQNG4R4=;
        b=jbyhWYkKqHRCgu4RMwSVJPaTOkVxBoEo5w2exaTb9ivqnh8YUweJz7gG/ZikXr60O3
         QfsY+cN0GIZJHyHdiwxvnUNGVyHclBcwkSo4qqZhoQc8VT79mAALCpsHNM49MfiyVplV
         ZXCs6+B6fF5uBj3npxomF3j/7o3eCICsHJl12IHqLYCqp8ND+gpwb/PzEThjBYHoY0Jp
         JYkgoICX7E7t7W9QK/kUYFeeKXGJKWeQCXKVgYngLE/kWHN+dzSwlOoGvZxijmD5aIuX
         Cq5ZxM+aEGgllfO/vDbQfFOY6WwbdoLd9wy5SgQc7vct+DeQpRQYPmCccge/oBPvS6wy
         ANYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700131; x=1730304931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAVLaZMsYlaRm01XXXR+pTcArBexY2/Nbj1JvQNG4R4=;
        b=r0KctkIqNbBhtWlJb+uQJa//v6irbBJ2BTBRYyOEVYxCutU3atWINvDFcND9qqwxmm
         gKmB1Jfg+a65ztyl3fcc0TRFXlcsy5997fHz+MyXTTPUK2Dxi47QeqfUxaRsBGJp6xER
         EX9yATWRZYFtHFdp3E9Cpkv8jL1Wb0n36pL3f/dmSP381RUcntnXz1Q4DIzfGxu0t1cr
         DJ2apXZBqNirjq+Bvm90CLf6ieh2jMOQkTjOMGcglTDgd4a/9woDj5e1c68eir+mecAL
         N6aEk4J2m3Vj4uj9/Un6teas5y+/ycje7wteEDZf+y2psR93RFB4r1VUo3ES2PTfBzvy
         Kuzg==
X-Gm-Message-State: AOJu0Yx2WfxOsEdOby6E94rEwqM0626pbsHa4UEV9hT8ZUyysWmhJeDP
	dZwqDef5+ZXpoyPOUyMPn6xwvmFG3LtVz1hneyBnwI51D52VIQNIpLdBnwuL5tpXwRx+LR/wv0b
	y
X-Google-Smtp-Source: AGHT+IGpcof+4P2x6ot3Owb47UAToc10m33JHusxd38kxYnIrfs/U84HpvJFwXGWMqSc4ZdWiSxyvA==
X-Received: by 2002:a05:6602:6b82:b0:835:4d27:edf6 with SMTP id ca18e2360f4ac-83af6192858mr292528839f.7.1729700131270;
        Wed, 23 Oct 2024 09:15:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring: add ability for provided buffer to index registered buffers
Date: Wed, 23 Oct 2024 10:07:38 -0600
Message-ID: <20241023161522.1126423-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This just adds the necessary shifts that define what a provided buffer
that is merely an index into a registered buffer looks like. A provided
buffer looks like the following:

struct io_uring_buf {
	__u64	addr;
	__u32	len;
	__u16	bid;
	__u16	resv;
};

where 'addr' holds a userspace address, 'len' is the length of the
buffer, and 'bid' is the buffer ID identifying the buffer. This works
fine for a virtual address, but it cannot be used efficiently denote
a registered buffer. Registered buffers are pre-mapped into the kernel
for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
and are used for things like O_DIRECT on storage and zero copy send.

Particularly for the send case, it'd be useful to support a mix of
provided and registered buffers. This enables the use of using a
provided ring buffer to serialize sends, and also enables the use of
send bundles, where a send can pick multiple buffers and send them all
at once.

If provided buffers are used as an index into registered buffers, the
meaning of buf->addr changes. If registered buffer index 'regbuf_index'
is desired, with a length of 'len' and the offset 'regbuf_offset' from
the start of the buffer, then the application would fill out the entry
as follows:

buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
buf->len = len;

and otherwise add it to the buffer ring as usual. The kernel will then
first pick a buffer from the desired buffer group ID, and then decode
which registered buffer to use for the transfer.

This provides a way to use both registered and provided buffers at the
same time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 86cb385fe0b5..eef88d570cb4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -733,6 +733,14 @@ struct io_uring_buf_ring {
 	};
 };
 
+/*
+ * When provided buffers are used as indices into registered buffers, the
+ * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
+ * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
+ */
+#define IOU_BUF_REGBUF_BITS	(32ULL)
+#define IOU_BUF_OFFSET_BITS	(32ULL)
+
 /*
  * Flags for IORING_REGISTER_PBUF_RING.
  *
-- 
2.45.2



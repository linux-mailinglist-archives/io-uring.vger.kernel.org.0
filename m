Return-Path: <io-uring+bounces-10902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C188C9D694
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB1323A7B44
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201D422D7B5;
	Wed,  3 Dec 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNUyIKLg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2E6221271
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722202; cv=none; b=eVU+6yWYba4j5kk274ZTqr9lEiiHqi1q/7jAND4xrI+8/y307ADfh027DVxUl3VbL+/zSvVBHXPpvKyw794cv0ktJn6ciRwJHwdB4vtBFXuce6SzAGDYxu6TbbULTci0OTQyiKkJqW3/7u0mwPN40ESyRPlTDVWnjUvVdV5ejF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722202; c=relaxed/simple;
	bh=E6jomfHLw9morvScsSuIyrTbu5DzlZPGnn4Wj8xpqDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLUFuC7GqQ1SSi96s6kpAM7S6h1nphgET/xqiVSPZD2+Fp7jZUUbpcInOofGzt9YMpLsOs6dJCMuDJ6ur+REvlyhFPoU23bMSGsWh2na3v9XmBSMkb3WIZZyXoHsxpC/aGg2ecl2KbEFOdmxcWDogViTnn/wh/yHAYZknD6PVlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNUyIKLg; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29ba9249e9dso68311205ad.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722200; x=1765327000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Np1CdjIf50PdsiciPUKNgwYPBI9/m96qnZ9zxUVy38=;
        b=ZNUyIKLgBYeJh/KC09zagnammTZ3vkEaJLfzYTs3dkxX147tWQqpjYII/3+H2DU16Z
         1JdN0KBL6zYVZ4s/nerOoC/29DkutmNXBw9zKN9bcvSbEYlH6MZG1ZoAOOEIFwdrRhQS
         f0ln9f0OYMdGu9h1ASuOk9A7OlQCqe9ArEpMAvT2oJI5vIor/6+RtduTAWT2+2f+A6gl
         lMNf8P7tqCtwV5udcAY2qIjbQXRo2H5cE6y2U1B1yiY+gwUQ5dU1nLnpTzUbsgTsRxFQ
         NFkhOT6qVKW5Epsyom8+F9yYde6WrcAVvJaP6JPbZmDTmBj+4kjdwMtauX3H9sDLEOeI
         rekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722200; x=1765327000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Np1CdjIf50PdsiciPUKNgwYPBI9/m96qnZ9zxUVy38=;
        b=NSmLDeBeU1KIF3ujqAIXXHPB+MvX6aBnUSDDjfxY3y5R+19Mk01ZG9XMVjIRR6aaJe
         2V1/kVihcgpBh83dcqGYedy5oRkf3z8r0fpeE9lgHUK+1LgOYWAfrH0C1UH37gUT0DEa
         Gw0Om+rhY/lK0QXUomPaXIuPdDIIPKMcDbmEVHN7J5cKbYXSzizVm3j1VQdP3tk3RQsW
         +JpukWyTQf1Ihm/ETBbGSi9oZHkohQHCjvIrm4OYgj4TfEKiicAKy+EZI4KU0OmDsAhr
         jzzUug0FCGbqK6r/atOU+lfCyDYvYe/kdytNPbzyO9suSzNNTUhVG8M814oIv/wNw3DV
         xCgg==
X-Forwarded-Encrypted: i=1; AJvYcCVbMpIiSyglfqCxHayiZs9rXqR/Ko8+2qqLbagOeKOGXWKY7k/lw9nFNBl2uD2Ek/CY3QAbSsu7Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz49BUy8+K+zzCQLd1tvzHZqfUY9bQtsrZ9fZR3dV6fV/Ya2aAE
	Gp8+mYPvDawJPD05vLUgkDRDD4TK/rG8OVxTFzUz4Lep+E1S+i6TBN/7JWqFPw==
X-Gm-Gg: ASbGncvFYOODoeYwHQvtoInBpU0//bsx+2oDrAgxXA/8tlbhxKcJi0ag9kW086Q2kZu
	g0qn8WZzblBOBUDb9HY/MEmgZHnhwFSCMiThsqmgQU98v+ow50AkT91RZjZMSohVvKNHWc+EihU
	M7xSz9OAkKNgj0dnOdds3A4dsJhRS8iDcxOepy743A7FcvQmjQRQt09rS4ghpl5l5XHMeW0Q0W8
	VvB/lsVLprHRe77xSg4ED6tsDHK9k/3b3AIINxJJg98QODrh2h7OLytOL3x7unA5GA8orNQkaHG
	EzOv4GsVQsZui00bNr7Pz0KdaM9wPkUxlmsX4YuLuErb047oU8ohSBnM4vBOysDD6xBuOJBPsyO
	m2sd7Ev0QiUPEDnK1FrIqjAHt0BJwJLF6O3kPOtYf12H87APg90EXaRtAPnBws5wVHdlWcaH88a
	j868ay9QtjRRrxl0+UCQ==
X-Google-Smtp-Source: AGHT+IHf4a30l84Kdv854PDD70AXwIwyxjEjFGBmdz8uB7Y48USZ9bZGcRpKvmyqPBjCk6aifQLvdg==
X-Received: by 2002:a17:903:11c8:b0:269:4759:904b with SMTP id d9443c01a7336-29d6848df81mr5729795ad.58.1764722199657;
        Tue, 02 Dec 2025 16:36:39 -0800 (PST)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb27669sm168298015ad.63.2025.12.02.16.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:39 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
Date: Tue,  2 Dec 2025 16:35:02 -0800
Message-ID: <20251203003526.2889477-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kernel APIs to pin and unpin the buffer table for fixed buffers,
preventing userspace from unregistering or updating the fixed buffers
table while it is pinned by the kernel.

This has two advantages:
a) Eliminating the overhead of having to fetch and construct an iter for
a fixed buffer per every cmd. Instead, the caller can pin the buffer
table, fetch/construct the iter once, and use that across cmds for
however long it needs to until it is ready to unpin the buffer table.

b) Allowing a fixed buffer lookup at any index. The buffer table must be
pinned in order to allow this, otherwise we would have to keep track of
all the nodes that have been looked up by the io_kiocb so that we can
properly adjust the refcounts for those nodes. Ensuring that the buffer
table must first be pinned before being able to fetch a buffer at any
index makes things logistically a lot neater.

This is a preparatory patch for fuse io-uring's usage of fixed buffers.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h   | 13 +++++++++++
 include/linux/io_uring_types.h |  9 ++++++++
 io_uring/rsrc.c                | 42 ++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index 7a1cf197434d..c997c01c24c4 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -9,6 +9,9 @@ int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
 			  unsigned issue_flags, struct io_buffer_list **bl);
 int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
 			    unsigned issue_flags);
+
+int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_flags);
+int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_flags);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -23,6 +26,16 @@ static inline int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_buf_table_pin(struct io_ring_ctx *ctx,
+					 unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_buf_table_unpin(struct io_ring_ctx *ctx,
+					   unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 36fac08db636..e1a75cfe57d9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -57,8 +57,17 @@ struct io_wq_work {
 	int cancel_seq;
 };
 
+/*
+ * struct io_rsrc_data flag values:
+ *
+ * IO_RSRC_DATA_PINNED: data is pinned and cannot be unregistered by userspace
+ * until it has been unpinned. Currently this is only possible on buffer tables.
+ */
+#define IO_RSRC_DATA_PINNED		BIT(0)
+
 struct io_rsrc_data {
 	unsigned int			nr;
+	u8				flags;
 	struct io_rsrc_node		**nodes;
 };
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3765a50329a8..67331cae0a5a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -9,6 +9,7 @@
 #include <linux/hugetlb.h>
 #include <linux/compat.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 #include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
@@ -304,6 +305,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -ENXIO;
 	if (up->offset + nr_args > ctx->buf_table.nr)
 		return -EINVAL;
+	if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
+		return -EBUSY;
 
 	for (done = 0; done < nr_args; done++) {
 		struct io_rsrc_node *node;
@@ -615,6 +618,8 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->buf_table.nr)
 		return -ENXIO;
+	if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
+		return -EBUSY;
 	io_rsrc_data_free(ctx, &ctx->buf_table);
 	return 0;
 }
@@ -1580,3 +1585,40 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 	req->flags |= REQ_F_IMPORT_BUFFER;
 	return 0;
 }
+
+int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_flags)
+{
+	struct io_rsrc_data *data;
+	int err = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	data = &ctx->buf_table;
+	/* There was nothing registered. There is nothing to pin */
+	if (!data->nr)
+		err = -ENXIO;
+	else
+		data->flags |= IO_RSRC_DATA_PINNED;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_table_pin);
+
+int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_flags)
+{
+	struct io_rsrc_data *data;
+	int err = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	data = &ctx->buf_table;
+	if (WARN_ON_ONCE(!(data->flags & IO_RSRC_DATA_PINNED)))
+		err = -EINVAL;
+	else
+		data->flags &= ~IO_RSRC_DATA_PINNED;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_table_unpin);
-- 
2.47.3



Return-Path: <io-uring+bounces-10904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A19C9D6A3
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4B6B94E4D84
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C948A23EA8C;
	Wed,  3 Dec 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGUXdJyi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9D1238D42
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722206; cv=none; b=li66H0RsoGPuRXl4MX3gTuEdfrdSoM5gm94BK0bFJDQ8fWOou302/vwrivyT+W4DdPvbKRu5lfbvfQE7/Rr85ICbj+6DsSRomkInBUjvvrsmMcKeU1Wlg7BuFnH5QpMd21255tHHQMo6EmEq/VZ2KPsoFAoKq0Izx8PVStvYW+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722206; c=relaxed/simple;
	bh=l8OfGZ+ZuhyqJEg+pGHrAWYSbfp9jx2EVw3z0b+noWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwpOH0/OevyWG3I1t1l2mcY+xkDM4r8KHgHy/51PvY73gf5CdNURQK3bIbHmKOo9l6hmL2atGQPFia91ye1v0iwnfKi+qNsbye4n8zVRiHX5zsfbfHOooaCQkVdM8dXkmuRrU3OucwxJvRqNikTnJnTpzAvfgOx5zv6ZT6QQWWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGUXdJyi; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7ba55660769so5220831b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722203; x=1765327003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abgU8eXy2UGHu3I1rTvvJ2cLDoZHFsXc9Y3NuDMCzsQ=;
        b=dGUXdJyiAVjy8pkKras47Vt4bmYC/knhSrwt8Ica+bcnbkJmUFnFuz7UNBmNEYKuDU
         JRNsQwQXymPoUpXgn4eE4ELiifOVsaK6H9IIN3rdzJ8ntNaxm86OTCIgbQCMDZEdM/EX
         mEZYIfBrRNUT2E1AANKgDa3FG5krVDyLBXRQVgg1Y+6qjN2cTW4Noj0iK9TZTR6KmODS
         XdACee0iPOZT2A8OK8qUhokzG/Lp/ShVexjZp9JxPIsx7OEBPP3EFzuh9wJV4EMg0Tpb
         XO29QrDYeXJ4T7OU94bAOLHIBI+ipMoJvKsdnAEJv2zqGjNGNqOx6Y23jIiJmHh4Bwc0
         /Tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722204; x=1765327004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=abgU8eXy2UGHu3I1rTvvJ2cLDoZHFsXc9Y3NuDMCzsQ=;
        b=JxdoLmfj60VZ+VevziRcFL9Yrx/T1UJPzGAsyxBpVjZDQ4DYl+56S2TfvjHDMH8slN
         ctA0BPgzkkbJEKyOu4914ir+yBx+vnXEIaeQSIwrdEL+0fR4MAQUnrOD8bK+QAv5kyNx
         8frbOjgN3LZ1M9nsogolvd4MMQkUDkHd2ST4O2grJ8kUB/ZCltMVJ1GKDeW45zL5gpNo
         RQUX7kPHs4rizOduNxAp+HaYFJAfOLOq3ZBt9tiB0aEkaftlPVx/IInS7zLpV3yXLhOp
         U5dWhYugd7Fem+PVL8LhBvvomvAdjo7edWbJifrp4EUiafD1CFvtOAlZeXH2Kws7KDzR
         zqIg==
X-Forwarded-Encrypted: i=1; AJvYcCV6YLqpZLj4LIniG6MWjjQhHjKN6wgMspjb4kvLXF54z7PbDFfmYZmZB1jwlgm+GEoGlRtTZg5slQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFggs+78HdnAHGeXm3LoJoul9yPOb6MsCXeZ4zd+LPyF5ShhX5
	mmfsEbiOgvgxJYuGLOBcHi0GBIORlv1dp7hX0ydEd1YbDjIp+TTNX/1s
X-Gm-Gg: ASbGncuPEFWTzZ9cQdvj5d1UT4JUTEQnvGWXpn9dI/+XAlMJPmyRFsxD5FJGgBV1VPf
	orbunl1RUSlrlgc55CGHCp5JlpCL2HibT+/w3kx6Csy/dO/NDANcR+8gCGvbjWg8mf+JPzvHKyC
	3DeZIZB9csFq+ZYHXPMyYuWWZdMiiP4gcm5bVJ4myfq5lVPerOLhDSRfsf7cEsQfN9fpzAVpZV6
	HZzandABvBb+BDMc61V3WdwxquqixH8LR2H3VcMEEtQHDPZOCFlyPPFxCJa2GkDXZxKppPBep2c
	co0zUdcY/qSWwZ25tOfprZp2wtnHR7r9nUjBEOogea7QOHHibIQKCTGKGGd4EYLaqdVrmQKoXTa
	HqHSlggTXbBqoBRnQVRFDOPwqE6e6Odi/nvbT+301pcctSV+TxWpXyzkda7769VFOzUhQ3wQntE
	sTNIjHLLK58mhSraSRfQ==
X-Google-Smtp-Source: AGHT+IET1+7HqlrAt0XI+41UEiTuQnkd1mg2GkVbGorWDyZzRf32PjTJkSnkezsWod7FGGwyZ2PuSw==
X-Received: by 2002:a17:903:458d:b0:295:6e0:7b0d with SMTP id d9443c01a7336-29d683e9b80mr4872945ad.56.1764722203596;
        Tue, 02 Dec 2025 16:36:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb40281sm164966475ad.70.2025.12.02.16.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
Date: Tue,  2 Dec 2025 16:35:04 -0800
Message-ID: <20251203003526.2889477-10-joannelkoong@gmail.com>
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

Add a new helper, io_uring_cmd_import_fixed_index(). This takes in a
buffer index. This requires the buffer table to have been pinned
beforehand. The caller is responsible for ensuring it does not use the
returned iter after the buffer table has been unpinned.

This is a preparatory patch needed for fuse-over-io-uring support, as
the metadata for fuse requests will be stored at the last index, which
will be different from the sqe's buffer index.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 10 ++++++++++
 io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
 io_uring/rsrc.h              |  2 ++
 io_uring/uring_cmd.c         | 11 +++++++++++
 4 files changed, 54 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..a4b5eae2e5d1 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -44,6 +44,9 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16 buf_index,
+				    int ddir, struct iov_iter *iter,
+				    unsigned int issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -100,6 +103,13 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd,
+						  u16 buf_index, int ddir,
+						  struct iov_iter *iter,
+						  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 67331cae0a5a..b6dd62118311 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *iter,
+			    u16 buf_index, int ddir, unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	if (buf_index >= req->ctx->buf_table.nr ||
+	    !(ctx->buf_table.flags & IO_RSRC_DATA_PINNED)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return -EINVAL;
+	}
+
+	/*
+	 * We don't have to grab the reference on the node because the buffer
+	 * table is pinned. The caller is responsible for ensuring the iter
+	 * isn't used after the buffer table has been unpinned.
+	 */
+	node = io_rsrc_node_lookup(&ctx->buf_table, buf_index);
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	if (!node || !node->buf)
+		return -EFAULT;
+
+	imu = node->buf;
+
+	return io_import_fixed(ddir, iter, imu, imu->ubuf, imu->len);
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..658934f4d3ff 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -64,6 +64,8 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *iter,
+			    u16 buf_index, int ddir, unsigned issue_flags);
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..e077eba00efe 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -314,6 +314,17 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
 
+int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16 buf_index,
+				    int ddir, struct iov_iter *iter,
+				    unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_import_reg_buf_index(req, iter, buf_index, ddir,
+				       issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_index);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.47.3



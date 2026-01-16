Return-Path: <io-uring+bounces-11775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 63D90D38A1C
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6DFA0306FFD0
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6627F17993;
	Fri, 16 Jan 2026 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQtQKjrg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1230432693E
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606277; cv=none; b=c28wkYMHOQV7W3bc+WpzhNXHIz5Z8AoC7cxQ0OGPShHA5QWd5xyHu2LMMNirlCA4hw4JOnobTYVpgwi3/OaevsZerMRSY8ARDALQu2WHq6yiVgtK8ZZYjzIZHZobmyVWazSKvLxka6/t6aqH8Tc1XSLXxWzvJCshocxT57OX8Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606277; c=relaxed/simple;
	bh=7M06w9h1Aru1PxbddWt6im/L0nS80Z8NTcX3xZpYrCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1QcVty2DV5CxvJYdOiKRNJlznOmrwRAzMdMCP8T4PB9awA1XBlVyrf4me5uetb0z51h8hvvaN6o/iHcjclFmrqfLDD4U9MVA5EnW0dqeKe409FUbeZ471VC+ANBKxx0HgUPiaYgiK+mOVIaPPmORrmRgRbPRWStaLb+XPoCB90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQtQKjrg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a1022dda33so15563325ad.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606275; x=1769211075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgRAjJ4p5sCbg6PCZ4gl3K2X2O+Ug28+5jXe/8HqPtY=;
        b=nQtQKjrg67d090gC9Icq48ByuQ/DifwhQMMX0aCl5esgLHJYqGZwQEC6PS19TnqqgR
         UykniWODXb3mxnEarxCsAVI+HFHKxax8hn2F9Y5XHWAlVj2B9DJfNqNLbRz7WbhsLCw5
         IOYEeUFa0s8PiuevBknURjOzV6lvkwv1GD4rKnZ63U8QUWkKdu+WViXE5scNLldolcCq
         3CTryFP/UZ9DRHMHvjx4GGbzRHqahzUatLbKwmpLVlkkj6U6M3aEYaa1GPM7jX8LBP4i
         D5FzlVM71vFfuQx52pq+t4v4gpRcqsal4XI87QIKFGO71z1yXdviXdWiJBXB5PnTRKNS
         rVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606275; x=1769211075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fgRAjJ4p5sCbg6PCZ4gl3K2X2O+Ug28+5jXe/8HqPtY=;
        b=dGDMhIuDtUUdyJojEarHHp+oz06Jt6rTCg3ajfq94Ku620L3NLwzM0kiSqJgtfyOgw
         Gy+R1EaDp5Mn7tYkZb+P1VMvBWQF2HGCpRo7XC6vqVtJNQxYZWpWkXg2/ktJ+1MAtcVO
         c6qIT+IBzxmdIZQZ3c4OdDAyK5tulhsG1I6VGnkx903JduAf29P1aoHOBBPSboMrHkfv
         X/zxgp2/I8TeeWZ82L/qMlXP5gdFSOnrDNPVUGAwRHYQPuLQu92qEIzKNTpeKs/m5NCO
         arnGtK9qRSa+JaM/Bh0JqeZ0JZ6frjCWLSYyokZ6LEwekPq8QNNpwoisZzJE3WoMQh1V
         sCYw==
X-Forwarded-Encrypted: i=1; AJvYcCXve7IHgbaOsn+l2a/H7Yhc+dRVS3NOyCmByahTXaNdFknDX1VVMHRv9OTfozrXTqU4EyMu3iM4nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOogUmgtpUIPOCkIk7Ml/zvj4Bp2FvRFUkzwfcNifQrkxkZY8+
	YGaQjMZUfBcHo3dyXUZQRE2fHChSLf/gj8+lUCPnQOlLQxKeLFYluBWs
X-Gm-Gg: AY/fxX4nnBXbHN6woX3xkin+eIIsL+bsHLHTOGnmgx22nljSyMvM1TFLUqML2xr2ncg
	GRat/7BI1QUBd0Qxmu9Fx1jSqIoKWfmSBgOFhh78olD1lWPkyOzHF2QLkc0H753j0hOj92UVr5t
	Jf68Q+wVXSHoBEPhfuRa0dA0GEm6nrVDJ0yfKYtUssm8j737lgqXuGMFUXxJp6m1I9ecK3fTPkJ
	HVK4YdZob5k01yXfY9W7qW+TTT5dY5W4h07jJwmtE+FC9fyP7/qoHoTiCr9JBMuBTP9wl7CENeX
	Bd/A7s/ukdo0kfUEQqeD1+48kqyFihwLbjeiOrL4IDvCZXiwl+aZOAUruvheSSnJKzYLQ7oXU4X
	VbumlbDHUvBCkw35Ox1fVinCDUrUuL36kpbgIwqSraMKyGRrOjV651FmY7StIWYW2B+eqgEnKUz
	OuXygX4Q==
X-Received: by 2002:a17:902:d4cf:b0:2a0:c1ed:c8c2 with SMTP id d9443c01a7336-2a717805dd3mr43593305ad.55.1768606275411;
        Fri, 16 Jan 2026 15:31:15 -0800 (PST)
Received: from localhost ([2a03:2880:ff:56::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941c200sm25479635ad.95.2026.01.16.15.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:15 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 07/25] io_uring/kbuf: add recycling for kernel managed buffer rings
Date: Fri, 16 Jan 2026 15:30:26 -0800
Message-ID: <20260116233044.1532965-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an interface for buffers to be recycled back into a kernel-managed
buffer ring.

This is a preparatory patch for fuse over io-uring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 11 +++++++++
 io_uring/kbuf.c              | 44 ++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 702b1903e6ee..a488e945f883 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -88,6 +88,10 @@ int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
 			  unsigned issue_flags, struct io_buffer_list **bl);
 int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
 			    unsigned issue_flags);
+
+int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
+			   u64 addr, unsigned int len, unsigned int bid,
+			   unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -143,6 +147,13 @@ static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
+					 unsigned int buf_group, u64 addr,
+					 unsigned int len, unsigned int bid,
+					 unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 94ab23400721..a7d7d2c6b42c 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -102,6 +102,50 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
+int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
+			   u64 addr, unsigned int len, unsigned int bid,
+			   unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_buf_ring *br;
+	struct io_uring_buf *buf;
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
+		return ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+
+	if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
+	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
+		goto done;
+
+	br = bl->buf_ring;
+
+	if (WARN_ON_ONCE((br->tail - bl->head) >= bl->nr_entries))
+		goto done;
+
+	buf = &br->bufs[(br->tail) & bl->mask];
+
+	buf->addr = addr;
+	buf->len = len;
+	buf->bid = bid;
+
+	req->flags &= ~REQ_F_BUFFER_RING;
+
+	br->tail++;
+	ret = 0;
+
+done:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_kmbuf_recycle);
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.47.3



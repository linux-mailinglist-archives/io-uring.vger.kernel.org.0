Return-Path: <io-uring+bounces-11187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF762CCAEBE
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 824953015E2F
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5690326937;
	Thu, 18 Dec 2025 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDRt+RBb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F212147FB
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046887; cv=none; b=JNoAAzwmgtmAxgehxJcbKX1mnt9/mX+84/AJLeJiMiofEaOO11Jvx0EYygVJN20Vqst6GdZGulQBEMSlnWwP+QkSeo0Naz56zd6kTK0fjFX1oUV6sALwziylSqKRpD6GVGz/nTPtqRee/52Ey6QZsXxb60Fvdg0b5s2/Zyiz3IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046887; c=relaxed/simple;
	bh=GpGUafLBUm8GKz5DC07Mir9ylZp3MydsvMtbSOLpySA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW2qtYjtR/rUniqejjTdFJgjLbz6DhY5ZPlCupUTUu1nfF21RLGl9ieyxeCWAvxajaDL0AM4lVYFuBkL2tEKdzLee0l6lx3MiLTY0x0PMKJQPeRjW8JGhOVMfT2LtKXoEHRhO3j4KbvwHNnJ/EXyTlLIFH8QSTo3pWrZhDOW4Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDRt+RBb; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso375751b3a.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046885; x=1766651685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ERLpzI7XBTuNuqqGKmhy3jz90mZWWvNenbvXb4ecYY=;
        b=lDRt+RBb2e05nNjfw8bXJy7CrwLeV0j6JE6lVU5pKJyD9peS66XoHpnlSQT5ddFBlW
         DWgLWE75Q8IFdDB0F2Swl9F9I1rCPpe3jeMwrC65DhzGgUFwU5woGHWfiFVpbt9eN1xO
         JSP69tlCgxwNQQSTtpwNFY6HFHhYPjtnLo4rxImYID3MehghGkxe25bdAcAU1RoPaPQl
         /VvucK6UgVicMJ/2D9ZMRvPx+8npL8YBFcNTAfELGMCidsa00ZyRmL47EW/ZY0ycPzrm
         kKHm1Nt6blqH2JlkSBS8dXC7+RylRfOsvtRdjp9jvwqcRp9b2iQNxKk7lVfLm+YKMAPx
         bdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046885; x=1766651685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ERLpzI7XBTuNuqqGKmhy3jz90mZWWvNenbvXb4ecYY=;
        b=kwJFi6mEK0qXE1UMMRlP0Nd3/VDneId2u7FFnFEFp61F7ehoZxT5gzNBggtR4uFMGT
         NsjaX6zFH8EQchG026PBTSv0N6wggxCLrzqUdN4ofKzrhvxSuGCNdaqIOluQPSR2Fek5
         Ok8rljXgmRmzmKdLzjGA/G2LK4XRTGrOnZCgGGb1R5YWft6Mvhx6qZ02wcWenQSLHUSA
         eOGZ3oT09L8tc0eps2MP03rvlAYRlUD7KMMGk1xLbnwpMLlartffWBl+xJeiks37nanp
         PrNT/Qvtp7LcejYOOkXkSOJvJ7nYrNSWULVclAhQc4YyppnIDVPkKMcN6LqaJC3DxzuM
         Omuw==
X-Forwarded-Encrypted: i=1; AJvYcCWFHitVFa7qcO1SMx+tKHofG3VZTHEwkPSA6LTmlwuNJdhkLqJLfD474kvktQ9Q3cZCNc4Z1XXB0g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb872QAtPx7uoze5DQGVvCFKJntZcd9iy/LgildJyw2JhHcWRI
	/DVz3/Faj8cCnh1VcspCsWC4KysZPuWq/1IYuChTmGBO+JpxQahCDGtc
X-Gm-Gg: AY/fxX5TxMnpcx1YKLlIFIhHSLAdtYigGvyv/gb7iNNNDgyO97qTAmhkO02nd6SyOg5
	0D+ttYxZMwb5TJH4GaqqI/0qoz1vdBjkeVcGDP7PeMJwUkxf5KKhML0EDHmprRw5tUi5dTBdT+G
	s8IOgdWKfvS9OyqnpiHltvHJu+kJ4olDwNbG8cGLgPPdXniSQi3x97wG2NSeb7t3ytbb7OIHcm6
	FYFj+JZpY0UroQqlmPXjomff/qNtbPuxejdjx3WyZFk4Wd/S8OvZqRy/sLaXsDN22HDuSiGOb1V
	t+MnZwSXJfxQTPPTlwkefwI8w8KkBcVtyFCbrh68fXaR09dpNEt/4CB3ZQ6B8E2o84wxB9yV6su
	fUkeRTDHp7iL7XNaIHqSeqRkWIrfHLgN3/Kq9XoS/YtVKPgQYdaZGL6DuYxqSZxLf3c3iKdwe71
	OnTbx9P1VhrSzSfD36DEXjCT48cIrI
X-Google-Smtp-Source: AGHT+IEgIc5UqekCKUDpL+uIqJsUxb26MBRJSRhvx202TFh9xOYA1PjDnMaWOpeIPECmEf0wRetO2w==
X-Received: by 2002:a05:6a00:8c11:b0:7b9:7349:4f0f with SMTP id d2e1a72fcca58-7f664d0322dmr21146775b3a.0.1766046885285;
        Thu, 18 Dec 2025 00:34:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe14a5727fsm1807075b3a.69.2025.12.18.00.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 07/25] io_uring/kbuf: add recycling for kernel managed buffer rings
Date: Thu, 18 Dec 2025 00:33:01 -0800
Message-ID: <20251218083319.3485503-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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
 include/linux/io_uring/cmd.h | 13 +++++++++++
 io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              |  3 +++
 io_uring/uring_cmd.c         | 11 ++++++++++
 4 files changed, 69 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 424f071f42e5..7169a2a9a744 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 			      unsigned issue_flags, struct io_buffer_list **bl);
 int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 				unsigned issue_flags);
+
+int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
+				  unsigned int buf_group, u64 addr,
+				  unsigned int len, unsigned int bid,
+				  unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
+						unsigned int buf_group,
+						u64 addr, unsigned int len,
+						unsigned int bid,
+						unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 49dc75f24432..f494d896c17e 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
+int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
+		     unsigned int len, unsigned int bid,
+		     unsigned int issue_flags)
+{
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
+	bl = io_buffer_get_list(ctx, bgid);
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
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c4368f35cf11..4d8b7491628e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -146,4 +146,7 @@ int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
 		     unsigned issue_flags, struct io_buffer_list **bl);
 int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
 		       unsigned issue_flags);
+int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
+		     unsigned int len, unsigned int bid,
+		     unsigned int issue_flags);
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8ac79ead4158..b6b675010bfd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -416,3 +416,14 @@ int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 	return io_kbuf_ring_unpin(req, buf_group, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
+
+int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
+				  unsigned int buf_group, u64 addr,
+				  unsigned int len, unsigned int bid,
+				  unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);
-- 
2.47.3



Return-Path: <io-uring+bounces-11259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C678CD77FA
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CDD9B301C88D
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B311F8AC5;
	Tue, 23 Dec 2025 00:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eyj25nUx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C688B1FDE31
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450201; cv=none; b=NnjZtCmNfSa7iKhVBQ6uQoCuWIEUEiZmHK8lt6My9YCg8ivdhK3LV9yNszhEGhda223KYif/wisHZxi72ghoqmQvMw+AxfyGj98EIyDw7spz9nxkLRE8sxq1Jq6TX/Y42O5IIN3NcEhL8m4BmNaJ9siWXiQf68UpzNWvUi62HxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450201; c=relaxed/simple;
	bh=9kYMGOrHb3wl/0cEqDb01/TiX6ovIKjmJdmUpX+3jZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qfg5hSLkToNdbklUvmuK3nPND8L3ZXH7rfiYr/L2SnIWYAw30Fbt4sEijbDrtC82MYp8hiWE5AgQ+5o4UXZ8PeLwaiIZz9V+tMh5dii1ufBI0ocH/GnDmJlpMpKAcO3pbCQWGRXWBSyIqpHd7+v0jWTYIhuHWCAV0Z7aAjEtJgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eyj25nUx; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so2893367b3a.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450199; x=1767054999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck2Q1qPyrUc/Jo+wdlrTe48UP28F3NhBZmyq0UwZoeM=;
        b=Eyj25nUx52BJxrns8GKD1ynfWWaNTZsf/K5uQ4r9UidM8wIKRx6nRiA0+6Cep9wBde
         e7Or3bBcF+OqjC7Gu4OLj/B3rdXXOm8z6BcEcULgvPWHpNvS3ENgrfmzy8IgDmvryP7W
         gQ9vM3pDUwiUvLW2pTU9l3EhP7DXHo6///h5RYikv7X7/MKgJbKH7b17DYrtIFnGDSKO
         +dr720gGox2qVE6EHIjPQadmiScTiq01oa9ca8ceMwzMG9kKLuQ6akZHsViPmGctKRV1
         3aeF5JqH3VNJCvHqGnJWm4ByjHF/d4erujQbSd3iKenpTQhiZgNDzNa1wUibmmVT+wiI
         HD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450199; x=1767054999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ck2Q1qPyrUc/Jo+wdlrTe48UP28F3NhBZmyq0UwZoeM=;
        b=HkuxSj3lQEO0wVzG9BfXV5P3C7VawH3+OgfIEZtiSWa3vM9t+taK8U2HcFliHQZIkH
         c6G4f6UisMbHi6O4FBg5PcNJ1ag65SSoc5m2QkN3+Qf3ptbLGt+4pUBn7UW+Z7Sbqcba
         GyaRmKIl/GrIyoFgJmHvCpm2aAU6JnB/SEbXf/C6KWQEc+voKfBXVVJ9ks576hOUCHe2
         rr9JDjNfVLSpvq8FID6XISFugc6+eb7gkGJMhYsTPsqYuPwPmDwMttoHYKs3Xl05Hs0w
         fEEfIz0UD6HrrzsugwZr+18TDWPHqkiqmtjfcmylTOxiuhuaUvcWQuyIUr0N0mla3BqU
         N1ig==
X-Forwarded-Encrypted: i=1; AJvYcCURzIjf2GHIeF2IT7+9QOzwEfbCdIZX/xH9wL8muIKA3yiFqn+LuYODLlD74TGVhq9fVr+7k//qWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzeSz4gMWPITP6CJjVAJEvlgtmm1ae/aUSa45fPD8Gawh+4/CNz
	NFDljWuud1u++TeK3JGsea55XfArnndIh3ORSxTBb95RUicHRJznQ6l+
X-Gm-Gg: AY/fxX41jc6GXgcGPeNY6PmWF857BT6vWPMsJVxJaghGCgKnG9XpoU4YlNHMTtCNmBE
	os9cK7kN4RO6N0FbxqcsWDKRkhy2LlRWCCNqzXcHwP1HV508iqN3JjrnzSeqsLhUndPeWelL9aH
	yZzFWkdRVLh+GASDotzRdX52gluCsnso7pKf2pFgFmOBGumUb0vBvwO5J02cZhrJjdkt3HDXA/1
	pJt/5xhoqmwQWRvfzeA1UJl55cJXOTcGhkuCWQ6ao7sELZtnbeGt06B16gtboi3mnNXazktW0XK
	14qK0dRVKWlitZ4luY5FT8ZIK2jMPq3B1kGV8HtSPbHGWnjiSpURudhsUbcvqyxbpuV/BwvRYnl
	uMBJW7lHZ3NEm3TrMuYUcM/Soih2gBrwIJb/akICDY320/mpYhPkWcmLxdbtRI56/hLLJoIzNgn
	O1dK0lyftjRxZtF4gT
X-Google-Smtp-Source: AGHT+IFAVtigN7MKHO773AaRUhiCRsCfbmfFL6lRlBjR5abztZvo9rRlblje7J2mbsYKfqAbxM161Q==
X-Received: by 2002:a05:6a00:328f:b0:7e8:4587:e8cc with SMTP id d2e1a72fcca58-7ff66a6d95emr11334837b3a.63.1766450198981;
        Mon, 22 Dec 2025 16:36:38 -0800 (PST)
Received: from localhost ([2a03:2880:ff:a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b22536esm11526697b3a.23.2025.12.22.16.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:38 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 08/25] io_uring: add io_uring_cmd_fixed_index_get() and io_uring_cmd_fixed_index_put()
Date: Mon, 22 Dec 2025 16:35:05 -0800
Message-ID: <20251223003522.3055912-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two new helpers, io_uring_cmd_fixed_index_get() and
io_uring_cmd_fixed_index_put(). io_uring_cmd_fixed_index_get()
constructs an iter for a fixed buffer at a given index and acquires a
refcount on the underlying node. io_uring_cmd_fixed_index_put()
decrements this refcount. The caller is responsible for ensuring
io_uring_cmd_fixed_index_put() is properly called for releasing the
refcount after it is done using the iter it obtained through
io_uring_cmd_fixed_index_get().

This is a preparatory patch needed for fuse-over-io-uring support, as
the metadata for fuse requests will be stored at the last index, which
will be different from the buf index set on the sqe.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 20 +++++++++++
 io_uring/rsrc.c              | 65 ++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h              |  5 +++
 io_uring/uring_cmd.c         | 21 ++++++++++++
 4 files changed, 111 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7169a2a9a744..2988592e045c 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -44,6 +44,12 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int off, size_t len, int ddir,
+				 struct iov_iter *iter,
+				 unsigned int issue_flags);
+int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -109,6 +115,20 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd,
+					       u16 buf_index, unsigned int off,
+					       size_t len, int ddir,
+					       struct iov_iter *iter,
+					       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd,
+					       u16 buf_index,
+					       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..a141aaeb099d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1151,6 +1151,71 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
+			 u16 buf_index, unsigned int off, size_t len,
+			 int ddir, unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	u64 addr;
+	int err;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, buf_index);
+	if (!node) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return -EINVAL;
+	}
+
+	node->refs++;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	imu = node->buf;
+	if (!imu) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	if (check_add_overflow(imu->ubuf, off, &addr)) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	err = io_import_fixed(ddir, iter, imu, addr, len);
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	io_reg_buf_index_put(req, buf_index, issue_flags);
+	return err;
+}
+
+int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
+			 unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, buf_index);
+	if (WARN_ON_ONCE(!node)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return -EFAULT;
+	}
+
+	io_put_rsrc_node(ctx, node);
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return 0;
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..16f4bab9582b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -64,6 +64,11 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
+			 u16 buf_index, unsigned int off, size_t len,
+			 int ddir, unsigned issue_flags);
+int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
+			 unsigned issue_flags);
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b6b675010bfd..ee95d1102505 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -314,6 +314,27 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
 
+int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int off, size_t len, int ddir,
+				 struct iov_iter *iter,
+				 unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_reg_buf_index_get(req, iter, buf_index, off, len, ddir,
+				    issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_get);
+
+int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_reg_buf_index_put(req, buf_index, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_put);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.47.3



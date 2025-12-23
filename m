Return-Path: <io-uring+bounces-11272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F76CD7837
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A57FF30329C7
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C694C219313;
	Tue, 23 Dec 2025 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDVLN5cf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05401FE45D
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450220; cv=none; b=miGb/XYUxDb4GDQFC+Glt4dpTlLHPS3ZLSi/VspOaXyuEIQOeLv7pdbGzkk6TunlEDqlRWFf60jDbdvFqtacXqc4rV9ga20hUJaOGxVKcwdEfWunIP0jUhOyP7iv1SY1lbkSSNqsrF70U7B3lsgskDx1JFWjJVhVCrLJbpbYAI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450220; c=relaxed/simple;
	bh=Djbalr2Frb4P3YduJN/LxOvBtYvOFO9wivgEqEOHizc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnLZvP95J0uXVy3w0dL188xKWOtKunOafZyiUxbXQg03pm9EyhE692T3ySkln7bjqq9gWYsUpsHhvETPArUf+qs8QJBySz5WqNfqWGuGVQYtzpVrRkjgjoWIAyIh7oUxcn8c94TZxuAqY8M1zEGtibaUAoX26HT7DMAv3MQJThg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GDVLN5cf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a09757004cso56693325ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450218; x=1767055018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzjSvxSUtJBpqqYtsLr2cB2XQQS7W26sUHOwgwQlj9M=;
        b=GDVLN5cf8584yKutGRB2j4tR+rU+pEnC/FyKYSYyAiYB6Z+F4gWRlpjV4E1b69Br96
         BkLBdiCHKT2OVt2f3lyZdn7EuW/INexY21Z78eoe1IhI/iSZJIKaZaLqpBTpnfo9jLQk
         72kc0h75w5tDGLFzed3yXd8/4IeRarqxPTBmPdz8amE3soC5cnXMITF1lEFw+QGoI2HQ
         jJEYFUlHbZ4dLjmfSYGP3V34cl9lZ0/odis/tO0jY6PcdApGhCVCBYbYraoC42IVtS34
         yn5KxoJuYVc+crKdpyhN17JN9LNIBaUQwRbJRX20OsMqKRXttmb8cb4P3Imvg5sV0+tr
         qO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450218; x=1767055018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uzjSvxSUtJBpqqYtsLr2cB2XQQS7W26sUHOwgwQlj9M=;
        b=huMTFMGQDW/xwA9wecrdMGTmBh9a0s7SMCltm3DT10uWT4sj4gDe/XyIcaci2jmhw0
         AIqmK4sZz14jMC+tnbw6mp8uPpbnT3mzDtMlGLqdVqz7Yfe037HbqIbjgM7XPJm1wWbR
         32ix+Ka8P7tZvn7oHZUIYhFbk1JGX1h8Y5R4CeEsnJlHCyUoqQ4klD4NjRTC+v5U+HRZ
         eZDPnLHDXomA+g0tggWUlJ6RJBFhcI6ExHBlyxhSZZWj3dQrstrErSldMseROLvlP1G7
         8y00SR+SO+wksM703j7mapVyaQwRTEfZvInaOWT6w3CyUr0qZgN/p2fq61KkGD2hfipV
         kFPw==
X-Forwarded-Encrypted: i=1; AJvYcCWfQuBzomQwBVnh7MOKcLTmczWwdO9YnOh6fYH4DZZFVY5O24M5t7J1YTKa7a3b8ngUe4RGmxGTsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVKzBCFztmEaGVD/0i72FA77RrevCKB59bH5yjIotOyIaN280u
	n/cxWQHarakCzeHs3zL/y/i7UWAiI8xZlNPNRr2QprmeuslP0pQTErI5
X-Gm-Gg: AY/fxX6IGIKTThTAvTIDPbsHMh2WPIQBr8cNqu/oSPgi1fqzFqGoY8iF0pjPmzJZVKL
	VrzEJDYE7ewJnHdGz2QcI3xQOXwLDCmpSBVrmo4x4zJwbvNlf717l0RcAVPL8UlbY7UxlGEIPF3
	McccGxGH2rOvlg91Gxj5LO8SzETrIa+lt2enDt0BPPqXg11eGqMuR47TKtKABPt9sGk8iQcEtkl
	1omnAXhywpH5nZzKNGlu7xGdF12h48wj/VUZpJpvKQ6EbzCfzuTqU5UPD/a6vt6CkNXUb6BfhNx
	K0YtvsDzjXw1FYXwTzzjXxQsw515pDJSxmdGwVDp9D4G61XCgMdkTq9F02MFXaL1Y//AKlSsHlR
	2OHZJD+1Z2ZVzx+zGjLL+uuYSNQh5JvBPNH+J63aomU7BwDCahBO0ZHR+0s3iXYB0vRQSAnFDL2
	n/MdJKRuV4D4aTSuab+A==
X-Google-Smtp-Source: AGHT+IHkfizJQDmlA3JHizssrZowo1zqMhZhgEyte9qQ9Y18J3k4bGYvnb0H0hRNtgthiytLMIHPfQ==
X-Received: by 2002:a17:903:3b86:b0:2a0:8966:7c9a with SMTP id d9443c01a7336-2a2f2c5e17cmr111972695ad.58.1766450218174;
        Mon, 22 Dec 2025 16:36:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c9b52asm107739025ad.45.2025.12.22.16.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:57 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 21/25] io_uring/rsrc: split io_buffer_register_request() logic
Date: Mon, 22 Dec 2025 16:35:18 -0800
Message-ID: <20251223003522.3055912-22-joannelkoong@gmail.com>
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

Split the main initialization logic in io_buffer_register_request() into
a helper function.

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which will be reusing this logic.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rsrc.c | 89 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b25b418e5c11..5fe2695dafb6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -936,67 +936,86 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
-			       void (*release)(void *), unsigned int index,
-			       unsigned int issue_flags)
+static struct io_mapped_ubuf *io_kernel_buffer_init(struct io_ring_ctx *ctx,
+						    unsigned int nr_bvecs,
+						    unsigned int total_bytes,
+						    u8 dir,
+						    void (*release)(void *),
+						    void *priv,
+						    unsigned int index)
 {
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
-	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
-	struct bio_vec bv;
-	unsigned int nr_bvecs = 0;
-	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (index >= data->nr)
+		return ERR_PTR(-EINVAL);
 	index = array_index_nospec(index, data->nr);
 
-	if (data->nodes[index]) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	if (data->nodes[index])
+		return ERR_PTR(-EBUSY);
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
-	if (!node) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!node)
+		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
-	 * but avoids needing to iterate over the bvecs
-	 */
-	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
+	imu = io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
-		ret = -ENOMEM;
-		goto unlock;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	imu->ubuf = 0;
-	imu->len = blk_rq_bytes(rq);
+	imu->len = total_bytes;
 	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
+	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
-	imu->priv = rq;
+	imu->priv = priv;
 	imu->is_kbuf = true;
-	imu->dir = 1 << rq_data_dir(rq);
+	imu->dir = 1 << dir;
 
+	node->buf = imu;
+	data->nodes[index] = node;
+
+	return imu;
+}
+
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec bv;
+	unsigned int nr_bvecs;
+	unsigned int total_bytes;
+
+	/*
+	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
+	 * but avoids needing to iterate over the bvecs
+	 */
+	nr_bvecs = blk_rq_nr_phys_segments(rq);
+	total_bytes = blk_rq_bytes(rq);
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, rq_data_dir(rq),
+				    release, rq, index);
+	if (IS_ERR(imu)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return PTR_ERR(imu);
+	}
+
+	nr_bvecs = 0;
 	rq_for_each_bvec(bv, rq, rq_iter)
 		imu->bvec[nr_bvecs++] = bv;
 	imu->nr_bvecs = nr_bvecs;
 
-	node->buf = imu;
-	data->nodes[index] = node;
-unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
-- 
2.47.3



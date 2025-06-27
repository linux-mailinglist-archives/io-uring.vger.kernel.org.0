Return-Path: <io-uring+bounces-8509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16441AEBB4C
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D783A1C25F0F
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7812EA462;
	Fri, 27 Jun 2025 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYRCYaF4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC042E88A9;
	Fri, 27 Jun 2025 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036978; cv=none; b=kLqgDXRK1FWCc4hWM4ttEYZpoZHFOksj6T6kB00/hajGWArAUz683ABsUmQrGA6aL0yDsGwXmPQL9Neg/GxLHKbteuPozhUDnqUxG7eN6nPwJV0mhrsFZQ7qmVg3mgE+2InUKBytFjsubtGxXSJJMNDm1nbmd0wPTCxA7fjqwjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036978; c=relaxed/simple;
	bh=zu+8bYP83hF7bE2VJdbMDm+5TkoY8jr1SEN3GhyhS4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8/vPopukBpdx8jeUhEqPUgUW95rNcl5nUlY1FXonoijE4tb8OvWpnHezgSOr2qMCTYDL0nhJxhaONv1DQDp5gOSRiXG5CTyJU48psIL8GXcChYM6Xa+SUz/TXxnorQy0/UI3wLOe+avlsLLlgDHTpElHCxFIYXzzVl6GdNhdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYRCYaF4; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so3774971a12.3;
        Fri, 27 Jun 2025 08:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036975; x=1751641775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YZLXoFRkCSYAHsnqeTpTF+Exw6OagDw+OX2goqNMro=;
        b=AYRCYaF4FI4iWwcJ+Fv6aRcP/QidPEHtZsY3hherraTxosaFLhYrznlq9u2jqh4lDW
         JWvFqG8JgRmayAlNkda43KHaek3E9gcii8n0Vho/pu7YkjFksgbuL92i0SwxeqYelY/W
         QHbu8Q3fXDrrpTiqnmU2gG3EUewmXhbgJ/EL1r7kVrbCd4kE5gKNQS4Iayr4EU8nxoed
         rS+UmvxaV7yFFiuvqmza2wkhTdoiC4+TkRUMEl68Yc3dzH/P0R3/fypH97DopYtPqCF0
         w2qliqoRi3tQupm/DqrbZ1Eg+zV7xtDai5ksruu1XdtwZXN9lbYN0sdyku3GG3cSYhc6
         cokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036975; x=1751641775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YZLXoFRkCSYAHsnqeTpTF+Exw6OagDw+OX2goqNMro=;
        b=aJLfsGDx4o2xzBPyCmQIZTcjieLD4oswiy9A9sQENb15UeZ3CCIQBsIN8aEOScAfav
         cNM/srFgF6TELbC00e0/WJsb3GmgjXBg/TFpnzGD8tBtF6POR5To0LI816An7HFtk6U8
         3Z2sYXJXa8bPkzbl7rdzunPraiN+J504kQXkG4AAXxyOYyoXynhF8vu/lW8mcSS1hvLT
         Tsra3LodHYb+raXUYYt5zYKuSgzKJRtAkQWDld/QESH7M02UEefsQKOjjwe6vva10xki
         xtbf58ZhRQ5k/9MEsy+p33H49EC6JZ3+UO6OOXdwVPMJOzA82Ep6V2rqJIoc3ILFXRXv
         du2g==
X-Forwarded-Encrypted: i=1; AJvYcCVwiQo3bZlIAKKxnS7hzBJKydyshKQtkuUXIeAa5UojuuClUDFWZlbEyPZ7MN/xN9KeXYbsPFpL+Oj+3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxVuahiE/uJ1Fg83oJEi4AruEXoJTKsOnFAiped+S9Do6igs68
	RRIHKFI/JnckXGGBgp9BOSFVGWWknt6ATRFBXzBCWHd+gM+cgOui00YFIncWrg==
X-Gm-Gg: ASbGncuFnVaj4GWO5kZ79c+Una3Xi4e9wtNkzNzs0gpJuLuGY98cbaRCQtqeBXymtau
	zyG0ZcA59wwaZNhumki56p620VEKCOHtGItKINd5oaF86QJpDfTRHAoDQlzCJaTtD9Zheh2HPPY
	RHfOf37IN++naODFyDqyiogMCooRp5UwpRHR1sWbwJqQNZyUZr7al43QX501pi74JlIrn5SCAzJ
	JvHoTpp845oNlY2o9hQN2bpw8EJNKsnxYqh+9Z2Jyo0k61QRHkewWabdAiH8w7VZGrwDhN+xa7h
	mB8o9snqmkgkHTtJudObhyXdmqWcDKAeJR9Bf1dinDD9xYd/qC4EmK+yYuOzdB+NVNYalmVdGSu
	m
X-Google-Smtp-Source: AGHT+IEDMaNgf7WOM8kyYyBMcDOGvJFoGR6xcOA8m+tsgNKOHS/gPcLRefb2hkTva0eVXEwYG0sVlg==
X-Received: by 2002:a17:906:1446:b0:ad8:9997:aa76 with SMTP id a640c23a62f3a-ae3500e3d11mr293023866b.37.1751036974473;
        Fri, 27 Jun 2025 08:09:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 10/12] io_uring/rsrc: add dmabuf-backed buffer registeration
Date: Fri, 27 Jun 2025 16:10:37 +0100
Message-ID: <5c11f982536aa26bd03e8d8962919a140a08e473.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an ability to register a dmabuf backed io_uring buffer. It also
needs know which device to use for attachment, for that it takes
target_fd and extracts the device through the new file op. Unlike normal
buffers, it also retains the target file so that any imports from
ineligible requests can be rejected in next patches.

Suggested-by: Vishal Verma <vishal1.verma@intel.com>
Suggested-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h |   1 +
 2 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 274274b80b96..f44aa2670bc5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -10,6 +10,8 @@
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-buf.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -18,6 +20,7 @@
 #include "rsrc.h"
 #include "memmap.h"
 #include "register.h"
+#include "dmabuf.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -793,6 +796,117 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	return true;
 }
 
+struct io_regbuf_dma {
+	struct io_dmabuf		dmabuf;
+	struct dmavec 			*dmav;
+	struct file			*target_file;
+};
+
+static void io_release_reg_dmabuf(struct io_regbuf_dma *db)
+{
+	if (db->dmav)
+		kfree(db->dmav);
+	io_dmabuf_release(&db->dmabuf);
+	if (db->target_file)
+		fput(db->target_file);
+
+	kfree(db);
+}
+
+static void io_release_reg_dmabuf_cb(void *priv)
+{
+	io_release_reg_dmabuf(priv);
+}
+
+static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
+						struct io_uring_reg_buffer *rb,
+						struct iovec *iov)
+{
+	struct io_rsrc_node *node = NULL;
+	struct io_mapped_ubuf *imu = NULL;
+	struct io_regbuf_dma *regbuf;
+	struct file *target_file;
+	struct scatterlist *sg;
+	struct device *dev;
+	unsigned int segments;
+	int ret, i;
+
+	if (iov->iov_base || iov->iov_len)
+		return ERR_PTR(-EFAULT);
+
+	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
+	if (!regbuf) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	target_file = fget(rb->target_fd);
+	if (!target_file) {
+		ret = -EBADF;
+		goto err;
+	}
+	regbuf->target_file = target_file;
+
+	if (!target_file->f_op->get_dma_device) {
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+	dev = target_file->f_op->get_dma_device(target_file);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto err;
+	}
+
+	ret = io_dmabuf_import(&regbuf->dmabuf, rb->dmabuf_fd, dev,
+				DMA_BIDIRECTIONAL);
+	if (ret)
+		goto err;
+
+	segments = regbuf->dmabuf.sgt->nents;
+	regbuf->dmav = kmalloc_array(segments, sizeof(regbuf->dmav[0]),
+				     GFP_KERNEL_ACCOUNT);
+	if (!regbuf->dmav) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	for_each_sgtable_dma_sg(regbuf->dmabuf.sgt, sg, i) {
+		regbuf->dmav[i].addr = sg_dma_address(sg);
+		regbuf->dmav[i].len = sg_dma_len(sg);
+	}
+
+	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	if (!node) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	imu = io_alloc_imu(ctx, 0);
+	if (!imu) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	imu->nr_bvecs = segments;
+	imu->ubuf = 0;
+	imu->len = regbuf->dmabuf.len;
+	imu->folio_shift = 0;
+	imu->release = io_release_reg_dmabuf_cb;
+	imu->priv = regbuf;
+	imu->flags = IO_IMU_F_DMA;
+	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
+	refcount_set(&imu->refs, 1);
+	node->buf = imu;
+	return node;
+err:
+	if (regbuf)
+		io_release_reg_dmabuf(regbuf);
+	if (imu)
+		io_free_imu(ctx, imu);
+	if (node)
+		io_cache_free(&ctx->node_cache, node);
+	return ERR_PTR(ret);
+}
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_reg_buffer *rb,
 						   struct iovec *iov,
@@ -808,7 +922,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	bool coalesced = false;
 
 	if (rb->dmabuf_fd != -1 || rb->target_fd != -1)
-		return NULL;
+		return io_register_dmabuf(ctx, rb, iov);
 
 	if (!iov->iov_base)
 		return NULL;
@@ -1100,6 +1214,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
+	if (imu->flags & IO_IMU_F_DMA)
+		return -EOPNOTSUPP;
 	if (imu->flags & IO_IMU_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 15ad4a885ae5..f567ad82b76c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -30,6 +30,7 @@ enum {
 
 enum {
 	IO_IMU_F_KBUF			= 1,
+	IO_IMU_F_DMA			= 2,
 };
 
 struct io_mapped_ubuf {
-- 
2.49.0



Return-Path: <io-uring+bounces-8508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D02AEBB2D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E37364828F
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7A52EA160;
	Fri, 27 Jun 2025 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYBQhNg9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B952E88A7;
	Fri, 27 Jun 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036977; cv=none; b=p6uTniOq4ZPgf3hcUHrhM5heha6FqWuN/DbU4lWgOGir7bA2kFPjcLzUqC9wS6O+6UiKFRCUR1IbnOsT1mWxBu7S5bT9li1ZpYLeD4UY16wpKQEsbtB5NX2SUAeYQlFtbyMv3NR8fFVsPqqJwwHHHSwNW35qsvBdzzOu9RRsegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036977; c=relaxed/simple;
	bh=V96MEyDGe/GqtyDnHCAGzmsnDz+zXktDncy+t+5k1oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA2kMxoh392y9F1SvCFFvsRWPwTqngzpDI8/rD3NSmSoJHHyV2XoI3wMP4ZVs2C0P0szGsXfHMF4Mvfiuby/ptuu6Ol2qLzdMDBseHYhzbRhqG3h460CR0eahCFjlyHAN21WiUPnh6uXo1uRZSy046OFHTRB+8hxBOofkHF6jwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JYBQhNg9; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so3702858a12.2;
        Fri, 27 Jun 2025 08:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036973; x=1751641773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u26XwVa4Y9sa7m6bu4ldVW+GkLaumHhW61D3zghrsdY=;
        b=JYBQhNg9Xw01Sq7Q6J1vH24brIIG9bkX66+XJllUqEao2YsZCoDCLHpeEBdv86TxBs
         TIR7MZDvuf9idd4GA0EQiboRpNP8XhNdpmWABpPz1G7RGTfNgK0BWozB3m7OAWszzUi+
         eOPWAPSgjc26X8IcnAh9btqCx+8VD/QMZQNmz2cjopVYINeCwYCEgccMJbHPZ91P114R
         +SfxVoW0Oz5kcVKn2N78jqHHz3Nb9DHd1U72Ieb/NZhycggycoH2T5wGDpGn5CnFj3Bx
         wATD7yEoaYt1OSRtPXctV7nlrf6griQBUeCFailkexWGB7W0ehl2QBDwNUq3G1UksCfP
         tcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036973; x=1751641773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u26XwVa4Y9sa7m6bu4ldVW+GkLaumHhW61D3zghrsdY=;
        b=Y1B89A3uRxM1yBrYCpxKS26B8bOpvT7QQ/oreYOCOAAWDIUqOAVVcLbf/70QX6XDu+
         XkmHsHrSeUquparNkgw+Gzs46Fo3wCOVwvVKl02JZrG44/sIIatkbhqBPU1GmEFjs/cf
         aNSHLvZAi2n15YoYxTI1JLP8qHwu6eoL0A17YGDJxSHRsCynX3cyJpuolCtKhsvNkeh1
         twraDfKhJYRNLaX5WTPxuwZqlBWYIYmAIFXLxnsm5B4/fEGVKfORJRFOYAu9NdLlitcn
         N/C7pXcJ5Sjh3PRIHhXQr/wS4CzPgNOnnEoxu5t9fqomdf8j+XD1H8nkRw1sY5AyVEP0
         ywRg==
X-Forwarded-Encrypted: i=1; AJvYcCVb6Q0V0GH3m+6+41MULe9JHAZiaxuH+FlFE8onu0cFKv7evyRCeqFZpHNSE9isHjcZUC64eT8BCgZ52w==@vger.kernel.org
X-Gm-Message-State: AOJu0YznSz8p6IkLeMKt0I1X68UCw7m4Qb/ETPXQkVMy1AhD/2bsMXne
	CLixHCEcCJIdw9GUc11zPA4chh7Kl8xDVqur1HyFpjGGK0qe59AqAk0HwF4prQ==
X-Gm-Gg: ASbGncs+bz8edWkXKQuBmQN0R/vsgwkyf4oz4bGFEF0a2IbSdtx2tWHe1sCs5tsb/Bd
	xn+CZY+awX0G/YcAEtfHgSr0BpHOqo4c9dLu3hHbdkaPSAyNO1Ly7CEaHJqHEKKfi7t3Hh5IwXD
	uVr+tDKcZi9r+vhJRh6onDgMFuQBnGgizqGIV3UJbK/blrzDne7i52xpagPxkBE8Lg0s6nGm6W9
	9LKfBNS2pkBI8UfN4C1ojypABsmPCM+sUMsPql3O5LrYi0BqyExA+NgN9Z/zvnaC1Nplb+mSL/H
	I+TWWTJ9ZBdcsRxALDdOoPVuAENaKMy5nFoqpI/wx4UQ8D4/4W8B6IvVJUztpxl+kUSptZe9/Rb
	/
X-Google-Smtp-Source: AGHT+IFkXr9u8nDlNj9mlCHAPJP7fvPn3kwFSuk77qsB5ddM3lpGccW8aFFP0oRsAdnZ73s0dkmQow==
X-Received: by 2002:a17:907:78c:b0:ad8:a41a:3cc5 with SMTP id a640c23a62f3a-ae34fd18405mr332552866b.6.1751036972952;
        Fri, 27 Jun 2025 08:09:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 09/12] io_uring/rsrc: add imu flags
Date: Fri, 27 Jun 2025 16:10:36 +0100
Message-ID: <ff094ad30f783ad515e48474d66201e909070827.1751035820.git.asml.silence@gmail.com>
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

Replace is_kbuf with a flags field in io_mapped_ubuf. There will be new
flags shortly, and bit fields are often not as convenient to work with.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 12 ++++++------
 io_uring/rsrc.h |  6 +++++-
 io_uring/rw.c   |  3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 21f4932ecafa..274274b80b96 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -850,7 +850,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
-	imu->is_kbuf = false;
+	imu->flags = 0;
 	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
@@ -999,7 +999,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
 	imu->priv = rq;
-	imu->is_kbuf = true;
+	imu->flags = IO_IMU_F_KBUF;
 	imu->dir = 1 << rq_data_dir(rq);
 
 	bvec = imu->bvec;
@@ -1034,7 +1034,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 		ret = -EINVAL;
 		goto unlock;
 	}
-	if (!node->buf->is_kbuf) {
+	if (!(node->buf->flags & IO_IMU_F_KBUF)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
@@ -1100,7 +1100,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_IMU_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
 	/*
@@ -1509,7 +1509,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->is_kbuf) {
+	if (imu->flags & IO_IMU_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
@@ -1543,7 +1543,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_IMU_F_KBUF)
 		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0d2138f16322..15ad4a885ae5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -28,6 +28,10 @@ enum {
 	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
 };
 
+enum {
+	IO_IMU_F_KBUF			= 1,
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	unsigned int	len;
@@ -37,7 +41,7 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 	void		(*release)(void *);
 	void		*priv;
-	bool		is_kbuf;
+	u8		flags;
 	u8		dir;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 710d8cd53ebb..cfcd7d26d8dc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -696,7 +696,8 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
-	if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
+	if ((req->flags & REQ_F_BUF_NODE) &&
+	    (req->buf_node->buf->flags & IO_IMU_F_KBUF))
 		return -EFAULT;
 
 	ppos = io_kiocb_ppos(kiocb);
-- 
2.49.0



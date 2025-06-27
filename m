Return-Path: <io-uring+bounces-8510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB27EAEBB2F
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16DCA6441F0
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81282EA168;
	Fri, 27 Jun 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtFlMyIR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02F12E8DF4;
	Fri, 27 Jun 2025 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036980; cv=none; b=snkvctDYTvAdEFIEOZJideLUnv8NkVlVlzLADkHQHncUlrA0rCxqgF557CQOW1/P0BmvPMMeTyRser0GwSlnbHH98QOgJ9qbKrS7fim16MMvv1v4lEnTwzqnXsoS/6EqXqxuoMMb+XsP1GP3leiynJSi1P3rJgoA0WJ8GSDRBH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036980; c=relaxed/simple;
	bh=Q7znZj/FuMu4/FR36FrpVd8sTE8UM4+HMso8QSFl8qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKrIfBxcxs66jM7MczqSFAMZElLSOEqv5VSIZJA8arQkGCW0GWvvJXoUqm1F2Og14c+DLSHWFcZlwZ8FWgarXrtNQR4dmux10+y3R8gtLphMS+xyg9W6uwvu0e5hXzIjR0MOQ8wDLMtB01UBkyfusJ4YzsmFqcr8Qz7NpK/gtsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtFlMyIR; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0c571f137so491553766b.0;
        Fri, 27 Jun 2025 08:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036976; x=1751641776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQeoeraNZzYHF4/dvoiDZhB3qU1Zz7S1cqKpmMhIX0I=;
        b=QtFlMyIRTVYGjk2CJ3dnFe3KnGH98Co5hcKy63yQlxxkWSuOdScdr6HYwR3yvdmtng
         gJpFoMz4GMdvQLg8+zNF1sEx1+ncDDUENXX2ruEHt+FRCuvITU+xn2nVgAj80u18CG6/
         UxQr87FHVOKVuSDAeg8MFRlklH+ZtZvce2NklU3QN1AbQQnGBXRMdjMZZn0GURYh/0Nd
         uORgnj4w5uXVDHKvCTzABx4KFPPkc+1AGTxhUnM075LZ1BdDoCHdEzqGDxsUIoo6dqjy
         Ud7bkpyD4TQl5mtguRvn4OKqlHqEeq3JlHszo18rcQl69n1W+GftSkmaUNaS9j3JInlR
         JCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036976; x=1751641776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jQeoeraNZzYHF4/dvoiDZhB3qU1Zz7S1cqKpmMhIX0I=;
        b=c5zuLZVW3tmPcMe3pRYRxPEaSP5zrpA6dgj7/6URI/d77Fg4yAndl5RogMAEcc1kOJ
         zUjPAbCG3nBtNrOGWOpuK+4iGCDFoV8zIXaKET5mC8Ym+vK5xiZ09ImiVSlq9QcTjdls
         aWgEWwacdkYbxo2Vd27mcp2kyJi6r0BSNvCOqGGOJsuCIhqKmKAaXiFu8+Idik82UWWG
         hQy4aBBJ/dgckXEelPGxW0xlO7jHB4edtU5YHfaDFPFRMVQgbrEwfp8k2PmuSwb8zvEg
         91DFn13VxYAuO9I6eUPQtEZ6t8+k1FkLIjy602YJy5fTD13gGx9bOO6EQiQyQiFueYJf
         kCMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvZkr1Nl4Abn+5z9Ne8WiL2MRyJUIj1msbzl7GLlWeCvxjSiuw7rT/jJ2QTtlyKaVENvxAzidu6g7t+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5Rwot7gvuwWttMtGVnP0HXuDR1RdiYU+Sac/MPih6X/MEtX9I
	SKTsdv1r/3bQDi6if25kGPloiW/2gsFgraXeD8ZMPFhN54JsmF+WF0OcUw0yIg==
X-Gm-Gg: ASbGncsfwYQwSYQuqCR2k5TxiosHAYoBnbVaCAfXpal9kqrpepFK8y1rhIAXgr/SrU0
	lSEHHO+0aSqbMkaApQlrsA3t5INMtUFvIUnR1h8g4cehsinA0UQ9mXtTwxZ6ybwPkMH9rmSbf8V
	3roebFFgIE8EXCPvnEK60t4UoLCfK76AZc3yQ2/85zONgRmNtSM1SAbCIhsJhZIGIKSphW1JVok
	lK+0C6jgInriDE7WpKd9wffcMpv6Y6tHvxDfVxCOn5BN6MwsYCf1cxWlePlMmtO/M7cyHQYcmg8
	3LchLiSt1cG1CZ4R5b7nERjgZquqR9eF0bs1q1/X9YOAILuVo+9p5tppkmlaNciKZSGTDx5msIZ
	k
X-Google-Smtp-Source: AGHT+IFuo3ZrrB5abnV8yWLtvLJ/KG5Qo2VOtBJKDd4SnuvJbcZvVX2UpVDKWmCTN+ZxiULIBXyKyw==
X-Received: by 2002:a17:907:3c89:b0:adb:2e9d:bc27 with SMTP id a640c23a62f3a-ae3501a3fdfmr362472366b.54.1751036976053;
        Fri, 27 Jun 2025 08:09:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 11/12] io_uring/rsrc: implement dmabuf regbuf import
Date: Fri, 27 Jun 2025 16:10:38 +0100
Message-ID: <b7b48875623e2be55aff6ce5dbf02189d6feb44e.1751035820.git.asml.silence@gmail.com>
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

Allow importing dmabuf backed registered buffers. It's an opt-in feature
for requests and they need to pass a flag allowing it. Furthermore,
the import will fail if the request's file doesn't match the file for
which the buffer for registered. This way, it's also limited to files
that support the feature by implementing the corresponding file op.

Suggested-by: David Wei <dw@davidwei.uk>
Suggested-by: Vishal Verma <vishal1.verma@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 53 ++++++++++++++++++++++++++++++++++++++++++-------
 io_uring/rsrc.h | 16 ++++++++++++++-
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f44aa2670bc5..11107491145c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1196,9 +1196,44 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
+static int io_import_dmabuf(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+			   size_t len, size_t offset)
+{
+	struct io_regbuf_dma *db = imu->priv;
+	struct dmavec *dmavec = db->dmav;
+	int i = 0, start_idx, nr_segs;
+	ssize_t len_left;
+
+	if (req->file != db->target_file)
+		return -EBADF;
+	if (!len)
+		return -EFAULT;
+
+	while (offset >= dmavec[i].len) {
+		offset -= dmavec[i].len;
+		i++;
+	}
+	start_idx = i;
+
+	len_left = len;
+	while (len_left > 0) {
+		len_left -= dmavec[i].len;
+		i++;
+	}
+
+	nr_segs = i - start_idx;
+	iov_iter_dma(iter, ddir, dmavec + start_idx, nr_segs, len);
+	iter->iov_offset = offset;
+	return 0;
+}
+
+static int io_import_fixed(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len,
+			   unsigned import_flags)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1214,8 +1249,11 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
-	if (imu->flags & IO_IMU_F_DMA)
-		return -EOPNOTSUPP;
+	if (imu->flags & IO_IMU_F_DMA) {
+		if (!(import_flags & IO_REGBUF_IMPORT_ALLOW_DMA))
+			return -EFAULT;
+		return io_import_dmabuf(req, ddir, iter, imu, len, offset);
+	}
 	if (imu->flags & IO_IMU_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
@@ -1269,16 +1307,17 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
 	node = io_find_buf_node(req, issue_flags);
 	if (!node)
 		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+	return io_import_fixed(req, ddir, iter, node->buf, buf_addr, len,
+				import_flags);
 }
 
 /* Lock two rings at once. The rings must be different! */
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f567ad82b76c..64b7444b7899 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -33,6 +33,10 @@ enum {
 	IO_IMU_F_DMA			= 2,
 };
 
+enum {
+	IO_REGBUF_IMPORT_ALLOW_DMA		= 1,
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	unsigned int	len;
@@ -65,9 +69,19 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+			u64 buf_addr, size_t len, int ddir,
+			unsigned issue_flags, unsigned import_flags);
+
+static inline
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
+			unsigned issue_flags)
+{
+	return __io_import_reg_buf(req, iter, buf_addr, len, ddir,
+				   issue_flags, 0);
+}
+
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
-- 
2.49.0



Return-Path: <io-uring+bounces-10748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7345C7E91A
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C3D23A6F8D
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC662C08D4;
	Sun, 23 Nov 2025 22:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4NZQWfe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0492BEC26
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938328; cv=none; b=odX2qkPshPIUoFUT6+LmdNCRkSZi6oQ2r8SQeSWkMJuf2O7w45l54NoUNwWAZRZKLEGwbtOTIMfOe6KzEI05wuKVMDqBSZuF2Y6Ef3DDASUtSaDZpqx8Oli8esGde/yzQiby4sVE/Wp7xNxHRU26Ck7rcc/Cc2iiKRrlkwHfep4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938328; c=relaxed/simple;
	bh=EXYOheJb4cgW5yVlz0jhAvYk6zmI9HBqPvYTaeMxyhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WutuEjW/jx34kvs2MAxCtLFCLwr4X8kGurkPZmUgryAu7dyO+dw9wcQSNZYMB73E0y+Td6G41K+xzgckkecvIlANsziMwow2f8y3tQwLbF9c3kxZDZfQ14P4DeiyNY/4lNwwc9a/MxtSUQjuDq/ZYFPfxu6gxISpQyIFKy6YHOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4NZQWfe; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47778b23f64so19064385e9.0
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938325; x=1764543125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjKpkoDBMFXqwI53pRDJnxFi7xwhurS0a3ahU0JbCgI=;
        b=P4NZQWfeyO45qY/ul+V8nOpW0TduYosMmKvc9jP8E//7n1Kuz9XEHBR4MP35H2QEL5
         sQRRFXi6orkEra+c606COFw3gtGmyj+6yzk5qdWcWgLrcu7x0zgXa+NzdmCe1X5WBxd5
         2TQg4+n65KIoUGwQsJv1jNvtjWulO90MfvFO+JXnPVSvGvILHUjAwEhKzhHOkaVdbdeS
         e04WvpRe3TwvvPvNrTEMEhZNSNtaZR2OkwX3c5bhUE0WbdPku1toldN1q+KJgEb9N77S
         PJlAGJjHMosHvFnc+GocB72N9HRjxpKmslvSu2l9TXToP1nIWZQ2KQCLN8jmO+0NsQx4
         7bOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938325; x=1764543125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IjKpkoDBMFXqwI53pRDJnxFi7xwhurS0a3ahU0JbCgI=;
        b=uYn/3BPqibGktd2Sutb88ykRuTV3cJlzzo3tBs/9w9kflf5EHdLp8UjmNJQYYAyH3I
         TMrjKv6rhYAwGnEs9x/Neag/e4wsGcpVj7TTpWFELElg/F2q6lnEQodUzA6gBX05A4Yc
         lGt0MVuxDxty+/Akg/0On1vwY0skZpQehFdgZJDFrNPR2jVEwTDsWDLi78KRUBzTtunB
         JtgoA+s6tm7uXZ7jll+NO3eYezZjr3k/RBS0+oWpH5VPH2QWln2FYY2saeHd4STzW3ic
         /paL7y/8Taj4dgXoiY/Set2o57jClpBulxbm0lMuyUGisRfVeVf3FIlRefaXLqKeg1wF
         M2wA==
X-Forwarded-Encrypted: i=1; AJvYcCXzw9HaLB/LiGrmPHdUwi8woiujCnxD2lvqWcwvfrCf5ehcxNYSQeFn9lyzq+1+pk2akDmdwbPn6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLC6CiXcejcgqr/eQ6F2MZn4GbgsrFRNvgQJMZ1GYy0n3blPyK
	0CawvIi/TtG4bA3C2kR6fWTIRfmfftF+TI/76EfrHOqUu+MBDCozMtGE
X-Gm-Gg: ASbGnctK7xuUwjRy775Dyx3Qz5R14Rjp0swaq3381WOJgfN35/7AnmPPOo39+nDFv7M
	nPIHSN72cxLrd6/AqlFTNEL6FkL1vW1uQUap2vyvSukkQOTTr4ow5W6NSwm6Z7LTOW3BUasIbtf
	nNgwwBZbI/94z09gP5/EYz5IFqrr1Mm4dmTFl2V2AP1D1EIzDj76MCsBH/tqzu/6LtWYpgSsGhg
	3MCFLDZ6A7yh3x1fdMGBirsP3zUSZZhkGjv1rVwHfv82bSTStV9dCX2V84tdVhhraHb955LFg3C
	gH9s4WtaG42oVCT5ORnRIymHmnAzOR2ppg4I8VB0oSIsjSp//Nln/9lnDB3bOaApvo9TfHF2MZ/
	YX01BJ664odfRjv/g3RXulmjGU6yb4Oa8ICaO0CmVOfSkZ9jIyHhOK7VB10mYRyKKTG3MPO/aV8
	2tklJBPf17X7L+rQ==
X-Google-Smtp-Source: AGHT+IG0SGMWMdVe66Rksvn6v5FBe6opsohs/EM0p8y743GggDbgal5u09Oo75v6mEVGyS+Z85JlHQ==
X-Received: by 2002:a05:600c:8b35:b0:477:832c:86ae with SMTP id 5b1f17b1804b1-477c111b94fmr113406075e9.12.1763938324588;
        Sun, 23 Nov 2025 14:52:04 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:52:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	David Wei <dw@davidwei.uk>
Subject: [RFC v2 11/11] io_uring/rsrc: implement dmabuf regbuf import
Date: Sun, 23 Nov 2025 22:51:31 +0000
Message-ID: <44e4ad8c4bd72856379c368e4303090c44c9e98e.1763725388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
References: <cover.1763725387.git.asml.silence@gmail.com>
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
Enable it for read/write requests.

Suggested-by: David Wei <dw@davidwei.uk>
Suggested-by: Vishal Verma <vishal1.verma@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 36 +++++++++++++++++++++++++++++-------
 io_uring/rsrc.h | 16 +++++++++++++++-
 io_uring/rw.c   |  4 ++--
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7dfebf459dd0..a5d88dae536e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1201,9 +1201,27 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
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
+
+	if (!len)
+		return -EFAULT;
+	if (req->file != db->target_file)
+		return -EBADF;
+
+	iov_iter_dma_token(iter, ddir, db->token, offset, len);
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
@@ -1219,8 +1237,11 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
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
 
@@ -1274,16 +1295,17 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
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
index 280d3988abf3..e0eafce976f3 100644
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
@@ -66,9 +70,19 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
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
diff --git a/io_uring/rw.c b/io_uring/rw.c
index a3eb4e7bf992..0d9d99695801 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -374,8 +374,8 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	if (io->bytes_done)
 		return 0;
 
-	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-				issue_flags);
+	ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+				  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMA);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
-- 
2.52.0



Return-Path: <io-uring+bounces-10745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22937C7E8FF
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D0A3A73D5
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D522B2BD022;
	Sun, 23 Nov 2025 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzQjW9LC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844AB29BD89
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938323; cv=none; b=gDxybuyRhhYK3sIBXGGpS5IsxlCPtjCUPGi11PXgkiFx8e2tvKJY76jNK48t51SQoQpOQs6xOewbxrIw99JK7EipzASAvG0vMv894TJZFxGwxeJvme1JAzMZwRHnDncvKwtGCCzfdrG0L2GpM5rGgVI4mz9ymO2eyn1HmA1ozlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938323; c=relaxed/simple;
	bh=mm+6YwU1gOqG0s75Ml2JJlbE3SsFVnXZaGl2Nl7+2l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOok8cw/fvq8+BbnBgMS0hnzamOWMh2fA0PNPG77zoybv972bUThSsC8gmgP90mIbfFEQtuMBWCtKeZfsAmrHPr/Qj+E+wLOddd3gGZ3GMe5cW7yQ43E+3oqwIkuKaLClsaJd/4OWI1aF3FsyQErYGTuvRRvhMpp5KiFfnxygf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzQjW9LC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42bb288c219so3269650f8f.1
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938318; x=1764543118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cr1T3mHouFLI2INVVeu1NU8Ohycgb7ruAKm6sUveqNE=;
        b=IzQjW9LCSDhXQJlfox4jXG+GkY63YhHN88jNMB+XzG+H1qhx1pSDgvIoTqUNrGk6QM
         8nRVgqSC9uSjklve7fATB/SRCTvXE0VD4XnfHEXLjzKh9H0ZVDv3xZ+Fa6F5sIo3P7Sz
         SdXUEmnHXi/QPiFgx0GBEvP2+wr6f8feICOmVCu91WYN/Q5XCXY8zU7BoOjQpyw+bx75
         21wjbMcEO90dLjAqAsOVW/N0G25gmPPFzZ+e6xSa/Jf+zhKETP2AQsE2s0+nlGIWCA3n
         YSlOk8K8Y8ga28F/HnQExNZgqD+B9JI09Yg1bSNfcjaW6wk77bxzjUrsAhSEp1/DcYT+
         COug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938318; x=1764543118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cr1T3mHouFLI2INVVeu1NU8Ohycgb7ruAKm6sUveqNE=;
        b=TgAAjvVUFjuWPrHK17kcFsp5mrT7F7ij+VaG0OD6AeCQxTdPrGtsyIFh+ljft/EeG5
         PVMUxjLNUL55evcMu6qfjzrmMIkZLjmvi+hv4UMwAEx92StBBTrHtv6EcJYL+x4rWqjd
         5+NPrG6+6Hth4imq1aB8hRwEfL6ybPMdiItqyF9C4AO2gJYkCqMJUpLRHIM1DuKrQsNP
         xNHrIznjn3ZusSXjl7cl4o7YQ37FX6I2nFAUz/ecYhOtZMGwqOT95F9gozd4dmjV1t8w
         MKqUp9nYMBISN75FFDzIN0gh7DCQiTMEEExF4ACTuYunKwJPLvWozWL5c6bnnUxgyeAp
         se4A==
X-Forwarded-Encrypted: i=1; AJvYcCUrDYYk9IHZMalmar3/R6dhOGzZoLHfkfwuXs/ESExo8u7CYr/RZgrEGKjj0CsiUw7uej18zIhI6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbb76sUO71PyZetCGywFB5s2I9as304yqPCpxO+vh/BxBEYNPt
	NWfXOWTjIdvtZz7OLvLb4Jt7SNlx8/tUmcYnzQ0rjurk5+Cau9LITr7M
X-Gm-Gg: ASbGncs+vNxb/W2HtZT4qrl1lLwkj4qCRrdW2o+Pc9X8jOgUbG6PiGPQyj6o08wu65a
	Lz5CesvXn/ww5qdJ/3+KuhCg6wHDg4RjP7YLi64jTHHQWKOdo0KrKoc1/BNaO2bgeRqnX03IyA8
	RgB/wb5wCUsh18VcK+zCRYUV7duaDh9NRrGnGfr1TooWQsF3M/0Cb1ZtPT3JlI3rtipiaakLRdx
	9LibGf8Tr9kZwRvvHU6CjLleeoSu48zHoOpzbL+YYDN9WaImB1fdgMDlWuALjtU0UMmwjtnXEH1
	RZM+UdEYJxKKzkdX/H9Mbh6wyR+eq0oxQg/yVjk61OMpVIlcTRvpAep4kLs/hoB6/vHNXAfEtWp
	4wVCFjhL8YbklIFOAkhmVdQ6dKuDlZ8To+eg4xbTBkFrWGCAsI9g3c7+lCjtTFQS4yNjaCc5msh
	M98VCsnShSao3s5A==
X-Google-Smtp-Source: AGHT+IFWQMi7JjnPU4iNqrFrw/2a7As2OTjK90JEPF3SEC3P6oOl1QIY7pfuaXnoytjEpQNeSrnvkg==
X-Received: by 2002:a05:6000:200c:b0:42b:4139:579e with SMTP id ffacd0b85a97d-42cc1d1983fmr10129976f8f.43.1763938317609;
        Sun, 23 Nov 2025 14:51:57 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:51:56 -0800 (PST)
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
	linaro-mm-sig@lists.linaro.org
Subject: [RFC v2 08/11] io_uring/rsrc: add imu flags
Date: Sun, 23 Nov 2025 22:51:28 +0000
Message-ID: <25a416c7f2673d39ae31bfe8bddcfc7eef710e71.1763725388.git.asml.silence@gmail.com>
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

Replace is_kbuf with a flags field in io_mapped_ubuf. There will be new
flags shortly, and bit fields are often not as convenient to work with.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 12 ++++++------
 io_uring/rsrc.h |  6 +++++-
 io_uring/rw.c   |  3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3765a50329a8..21548942e80d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -828,7 +828,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
-	imu->is_kbuf = false;
+	imu->flags = 0;
 	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
@@ -985,7 +985,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
 	imu->priv = rq;
-	imu->is_kbuf = true;
+	imu->flags = IO_IMU_F_KBUF;
 	imu->dir = 1 << rq_data_dir(rq);
 
 	rq_for_each_bvec(bv, rq, rq_iter)
@@ -1020,7 +1020,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 		ret = -EINVAL;
 		goto unlock;
 	}
-	if (!node->buf->is_kbuf) {
+	if (!(node->buf->flags & IO_IMU_F_KBUF)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
@@ -1086,7 +1086,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_IMU_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
 	/*
@@ -1511,7 +1511,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->is_kbuf) {
+	if (imu->flags & IO_IMU_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
@@ -1549,7 +1549,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_IMU_F_KBUF)
 		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..7c1128a856ec 100644
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
index a7b568c3dfe8..a3eb4e7bf992 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -706,7 +706,8 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
-	if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
+	if ((req->flags & REQ_F_BUF_NODE) &&
+	    (req->buf_node->buf->flags & IO_IMU_F_KBUF))
 		return -EFAULT;
 
 	ppos = io_kiocb_ppos(kiocb);
-- 
2.52.0



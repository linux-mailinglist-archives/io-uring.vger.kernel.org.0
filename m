Return-Path: <io-uring+bounces-4815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C339D2565
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18BCBB22EA7
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7F91CC174;
	Tue, 19 Nov 2024 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3xt5/xff"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0E1CC15E;
	Tue, 19 Nov 2024 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018604; cv=none; b=k/BICN10ZADUFOPcwtVlyZ6JlUv3nM8JnQUkdR4rrGkBvs+NnNCAbrSQ7yFWSCaDQy3QET08hTOpdwMZiCKcJuO49kj/U537+BcfVTJSRVWVU5N7LmGy38KswqxsjjYeMKd9/G/hrFxt8251TO/JinZgozsIYehMg6Ab4bTqXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018604; c=relaxed/simple;
	bh=JQgqvEgFqb4IVq6envaifcExBhdZxCZYD2N+g+Q5dN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjXTyKtVvPpNxzy2MUzyvkQ4FLhkN24QkNFmS7D2orxwxJBNMYENuo9QOu/DU1AWM00u5S6vXBx7SsYWqMjHlx1dggc58LC7LtvlphFFD+bjJ82gHSJJEhi5syHkohQpOBOEsV7mEyUXC40eYS9HUXvKjmQXnMCPIlOUJm2QTb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3xt5/xff; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZCibf9nDXx/wBVyXnoXvLzPNlRRpMiBGQGPX4h8joGI=; b=3xt5/xffCEazLGpsgTvl0WpGPp
	b9MvHJMZZQffhmpzey3mme+2rlDzjLBSEc+Is8lvIVwaYMLFr+D2HvxfzyGe7fAgmaIpeI144hQ0h
	mtpXtJBS6d1nGdO2baaJ0WQEXT1sA/qPBs2m6vcEP5perA+/mL5lMkAeE0+yZVM1URnLmMs7jh0nK
	GdDUtF2n3Vej4CeRijdVuFfNVZRTkoeANqJ7QkPBkcZLnWEBMk5e+YfUGR0HRG4TT20bd5QnkMUPb
	3oVdRE+v0GL6+udey5zJXMFNqS1eAv8+BMTxO1Df3A38QuSdKKLRNrmZc8X7lC2TDTDAz637fZabf
	1K+jQQUw==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDN9r-0000000CIry-2H8D;
	Tue, 19 Nov 2024 12:16:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 01/15] fs: add write stream information to statx
Date: Tue, 19 Nov 2024 13:16:15 +0100
Message-ID: <20241119121632.1225556-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Keith Busch <kbusch@kernel.org>

Add new statx field to report the maximum number of write streams
supported and the granularity for them.

Signed-off-by: Keith Busch <kbusch@kernel.org>
[hch: s/write_hint/write_stream/g, add granularity]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c                 | 2 ++
 include/linux/stat.h      | 2 ++
 include/uapi/linux/stat.h | 7 +++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 41e598376d7e..aa2b7fa4a877 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -704,6 +704,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
 	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
 	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
+	tmp.stx_write_stream_granularity = stat->write_stream_granularity;
+	tmp.stx_write_stream_max = stat->write_stream_max;
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 3d900c86981c..36d4dfb291ab 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -57,6 +57,8 @@ struct kstat {
 	u32		atomic_write_unit_min;
 	u32		atomic_write_unit_max;
 	u32		atomic_write_segments_max;
+	u32		write_stream_granularity;
+	u16		write_stream_max;
 };
 
 /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 887a25286441..547c62a1a3a7 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -132,9 +132,11 @@ struct statx {
 	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
 	/* 0xb0 */
 	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
-	__u32   __spare1[1];
+	__u32   stx_write_stream_granularity;
 	/* 0xb8 */
-	__u64	__spare3[9];	/* Spare space for future expansion */
+	__u16   stx_write_stream_max;
+	__u16	__sparse2[3];
+	__u64	__spare3[8];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -164,6 +166,7 @@ struct statx {
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+#define STATX_WRITE_STREAM	0x00020000U	/* Want/got write_stream_* */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
-- 
2.45.2



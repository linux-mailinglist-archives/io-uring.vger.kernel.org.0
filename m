Return-Path: <io-uring+bounces-11580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CC56AD1151D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 09:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 913533060EDD
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 08:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54A1345CDF;
	Mon, 12 Jan 2026 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hSt/qdcu"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816083446B0;
	Mon, 12 Jan 2026 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207604; cv=none; b=JoRrRZ5vpShCjfY9Oi2ZlvbxYroVecUMyz5lnJWYD6PBagEj3TNfkY5bq7EwqQGoePJEjPeBDH1WJY8qSUzLDU/I1AAzOkY18jD0sh3qG73LHzZPbXYEZRAu2tjUk0yt7pompkS13d+Rj+YUJ1k8EHL7Dt2I1ntxVKGQ7CgLU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207604; c=relaxed/simple;
	bh=D2QVIQeD0lcXV0QTnD/aLO7Glteq5WDovn/TLwnuDJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EKxsjk+UkbI5NvT1fc8hffy+JtanQCtSLH9ezBg+L4McX3iU8GBZ4Kl2svIvvVRBVxWLSBQpjJELVmx4sTkmjb6XvMmI/9bDbFbuDAY2MlhPtyIBPuzTwTcTSqppv9PPeFSTLCvvTYo4p2bAqv+xFvsyDxQZ9pNAnThrjAc9pVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hSt/qdcu; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kW
	mPdffeUFUPbo+NAoF8PFDFF8YhL1Z3JStIQFLzL+Q=; b=hSt/qdcuk4fh2GifQL
	UUlCYEP6WJPi4gZaQ49O6QaDx1BhxAAppk1kY/TvRFVr/QmB1enkDxGiAid7Fcti
	DSgEpjxUXPWAFfaLOipmdUBiY5TnrCahkzK0agcg1FgbViw/Qi1C7sFuknzoB8Jf
	071YCMVzSXhNwVdfL0wAWd31s=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDX7+bQtGRpQ4BSMg--.12084S3;
	Mon, 12 Jan 2026 16:46:10 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Mon, 12 Jan 2026 16:46:04 +0800
Message-Id: <20260112084606.570887-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
References: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDX7+bQtGRpQ4BSMg--.12084S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJFy8Zr4rCr4rWr1xZrb_yoW8ZF1Upr
	Z5Kr4xXFWUWa1j9rWUZayjkayYvr1Fya17G3yUJwn09Fn8tFy8u3WjkF18A3y8Xr43Z340
	9r17XrWkCw1vqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j52-5UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhLUZWlktNJPOwAA3+

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

This structure is designed to work with 128-byte SQE (IO_URING_F_SQE128)
and provides a compact interface similar to sg_io_v4, but optimized
for io_uring's async I/O model. The structure is packed to fit within
the 80-byte cmd field of a 128-byte SQE, with 16 bytes reserved for
future extensions.

Key features:
- CDB address and length for SCSI command passthrough
- Protocol and subprotocol identifiers (BSG_PROTOCOL_SCSI)
- Data transfer parameters supporting both flat buffers and iovec arrays
- Sense data buffer information for error reporting
- Timeout and flags for command control

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..24b08fece509 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,23 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+struct bsg_uring_cmd {
+	__u64 cdb_addr;
+	__u8  cdb_len;
+	__u8  protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
+	__u8  subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
+	__u8  reserved1;
+	__u32 din_iovec_count;	/* [i] 0 -> flat din transfer else
+				 * din_xferp points to array of iovec
+				 */
+	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
+	__u64 din_xferp;	/* [i] data in buffer address or iovec array
+				 * address
+				 */
+	__u32 dout_iovec_count;	/* [i] 0 -> flat dout transfer else
+				 * dout_xferp points to array of iovec
+				 */
+	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u64 dout_xferp;	/* [i] data out buffer address or iovec array address */
+	__u32 sense_len;
+	__u64 sense_addr;
+	__u32 timeout_ms;
+	__u32 flags;		/* [i] bit mask (BSG_FLAG_*) - reserved for future use */
+	__u8  reserved[16];	/* reserved for future extension */
+} __packed;
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1



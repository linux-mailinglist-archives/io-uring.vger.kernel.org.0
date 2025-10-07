Return-Path: <io-uring+bounces-9907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D37E4BC0503
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 08:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0FAD4E45AC
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 06:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C123521CC58;
	Tue,  7 Oct 2025 06:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VWA8nezG"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B1813B58B;
	Tue,  7 Oct 2025 06:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759817934; cv=none; b=X+1IKQLXgcx5zZpIkg+hHeOb7g7XbC0c8wbuzDFbDOtdeNhqpAkSft5qUf7tS8YCBMMP8ytI27NamiMrB1TTDJLBCxhPEwapMEPfrimxQap9zdUg1FfQhSFCtbroGSKMhojRRANEjAeLc+AcepP7Mm53NEuXfGPi/+7Ph7IVjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759817934; c=relaxed/simple;
	bh=seyw/I17F3NVvscReTEfS4tLJ8c3ZmnsAv2aoY5/tN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JVPLSE2l9iYWBVS9Ib34rgEmGGfKK7PNqpyQjT9MbuzGmB6MLTXWEX5m3PgEd2dzOci4LpdAmHb8BpE08PLiNR2NZk7RaFlE3D7Gpvej8MEbG4wCs5uET5UQekc2f/LwLyVZ8hrO/QTLcInda38UPfsHGE1BoPm1iR9wBpwhleA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VWA8nezG; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=dp
	vHzbnJMaIUMnFYl4EXcF6QPg+1q8Pn7eTmpFN/TSU=; b=VWA8nezG9ZPVlmWDU9
	KczDGzmSanMAuCrkfni5m2npnu2j8vZRixMXqy+wDcrjSZVy7Yaoc1Ruy0m57Mgq
	JlmR1Poamumy9nzAQGRW5U4C82Rz3WKs+3NPiA0819+NxCFmdVOWd5X5rnwMxGgq
	wIFPBZn6Fi5SW6BfFZKlz9qCk=
Received: from haiyue-pc.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3H+i6sORoucGGBQ--.20358S2;
	Tue, 07 Oct 2025 14:18:34 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] io_uring: use tab indentation for IORING_SEND_VECTORIZED comment
Date: Tue,  7 Oct 2025 14:18:18 +0800
Message-ID: <20251007061822.21220-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3H+i6sORoucGGBQ--.20358S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFyxXF45Aw18uFyUXF4rAFb_yoW3CrgE93
	93Jr48Wr4SvF1Ivw4xAF1kXFyYgw1IkF109a4fJr1xZFnFvw4fG3s5GF9Fvrs8WF17Cryf
	tFnYgw1Sqw13WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_NBMPUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiER-fa2jkrZNI9AAAs0

Be consistent with tab style of "liburing/src/include/liburing/io_uring.h".

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a0cc1cc0dd01..263bed13473e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -404,7 +404,7 @@ enum io_uring_op {
  *				will be	contiguous from the starting buffer ID.
  *
  * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
- * 				to allow vectorized send operations.
+ *				to allow vectorized send operations.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
-- 
2.51.0



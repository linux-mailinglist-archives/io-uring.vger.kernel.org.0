Return-Path: <io-uring+bounces-7845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2E8AAC413
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32D043BDEEE
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0386C27FB1C;
	Tue,  6 May 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="p4an/w0Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2A27FD75
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534402; cv=none; b=XABhLxKL+Rj2BDxbtArW7p1pfayGKkaE4C9EPanANFk1ZIYTtX+p+6Cz9OhY053IazDPFvlkXG2Y9YVZCBBSKYcSnQUFjr3ZsHU+Wg7d6lkK4ZydD1JbAa5I2UIKJiSoG+s7Qhpd1JL9/vdmrnnFyUE+hfP12PMVQxBfoxv6PX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534402; c=relaxed/simple;
	bh=hDAgRjFMKpQ0l+HpYx3S8yneqg8NQ2zTn538Fj+lkno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=QZ5RO6XWVFFb6BFBAYUmQn6qEj0Wi5PMEVDD4fYbVicEGqp4kQ4Qy7wMBFdZrQtZC+L3AWNYDK6WpYSk6e8IMH/B5lri8NXxHwrN2q/AzaDxXHRLJm5QzkQyCQ1xWf8GepcAzaGk4BPdi75jkjmTjSvft7SPbrpqZ1G16ojmbvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=p4an/w0Z; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250506122638epoutp037449d473e43e35172939d0ac5ca2eb3f~878g4VCvD2443224432epoutp03g
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250506122638epoutp037449d473e43e35172939d0ac5ca2eb3f~878g4VCvD2443224432epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534398;
	bh=e1WF8Ob+GON5uG07kvRTf2t3e7hQoxPf1adrp1Dan5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4an/w0ZNiGdIDMAbe7CAKI2py+qwwgaFlG9mzPJDi4QxqEYwdu/6AIbTBUQ8oYG6
	 UvuEBoex0fqGWaLnesA1Id1e4w/2C56dRaIkWCTt4YLy8PC+GQXPqK5hOjAs4EaGOd
	 x/80mBSGr6mWWe6xpXpbeb2Pf0QO/HZuPy+WBMFY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122637epcas5p454fb550df70381e9b126fd575ddc09ac~878f6Rk8s0664406644epcas5p4m;
	Tue,  6 May 2025 12:26:37 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.177]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZsHgv6G1wz6B9m7; Tue,  6 May
	2025 12:26:35 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250506122635epcas5p145565666b3bfedf8da08075dd928d2ac~878drNAQa0911209112epcas5p1r;
	Tue,  6 May 2025 12:26:35 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250506122635epsmtrp21eaa58a53218f12e73a6c9a11ac112d3~878dqiBVO0521905219epsmtrp2H;
	Tue,  6 May 2025 12:26:35 +0000 (GMT)
X-AuditID: b6c32a28-46cef70000001e8a-d7-6819fffbeff9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.E5.07818.BFFF9186; Tue,  6 May 2025 21:26:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122633epsmtip26207664adaebf8511d3a5e2c81e07337~878cE_q031679416794epsmtip2Z;
	Tue,  6 May 2025 12:26:33 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 01/11] fs: add a write stream field to the kiocb
Date: Tue,  6 May 2025 17:47:22 +0530
Message-Id: <20250506121732.8211-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvO7v/5IZBi3XOCzmrNrGaLH6bj+b
	xZ5Fk5gsVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsWevSdZLOYve8puse33fGYHbo+ds+6y
	e1w+W+qxaVUnm8fmJfUeu282sHn0bVnF6LH5dLXH501yARxRXDYpqTmZZalF+nYJXBkNbw4x
	FXSyV0z9sIC5gfEhaxcjJ4eEgInE1D2P2LoYuTiEBHYzSvTOW8kGkRCXaL72gx3CFpZY+e85
	O0TRR0aJS3sesHQxcnCwCWhKXJhcClIjIhAg8XLxY2aQGmaBD4wSeybOZgRJCAu4SDycOwds
	KIuAqkT73/9MIDavgLnE4m87GCEWyEvMvPQdbBmngIXE8j2zwOJCQDUvjh5hh6gXlDg58wkL
	iM0MVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PTTYsMMxLLdcrTswtLs1L10vOz93ECI4K
	LY0djO++NekfYmTiYDzEKMHBrCTCe/++ZIYQb0piZVVqUX58UWlOavEhRmkOFiVx3pWGEelC
	AumJJanZqakFqUUwWSYOTqkGpor58925uoXuSkuou23fyPv7scWPfYdqP12yL6ma8qzY/ejR
	8/fy3siJnFP83X688dCmy1/OLL2fvkby4OS/Ktt0rq2a1r+uM3S6X9LZjnWz9mkzSe378zfD
	gbPbZ1uqOcdx4w2pQZlPz794avzTMEtUbOmFU8rfNhZdZzrXxlK4+6dOl2qR4NMFe1UvhMiJ
	Ldg6z0LR10bAcPKqr2q8YdFeJU7LOWNXaTz0m6Bz6p5LfOLDt2pnLfsFclu5ph+ot9y8+uY7
	l21TPOvc4le626g+DVj20K9h8l+/Tf8S1lTxPT6udMkwIvbnomVvmP1lZ15TLX9bs2jp7p3L
	pp5qjp5oIp39KuPvvHKGNecWVd1TYinOSDTUYi4qTgQASOsS3vkCAAA=
X-CMS-MailID: 20250506122635epcas5p145565666b3bfedf8da08075dd928d2ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122635epcas5p145565666b3bfedf8da08075dd928d2ac
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122635epcas5p145565666b3bfedf8da08075dd928d2ac@epcas5p1.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Prepare for io_uring passthrough of write streams. The write stream
field in the kiocb structure fits into an existing 2-byte hole, so its
size is not changed.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 016b0fe1536e..d5988867fe31 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -408,6 +408,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
+	u8			ki_write_stream;
 	union {
 		/*
 		 * Only used for async buffered reads, where it denotes the
-- 
2.25.1



Return-Path: <io-uring+bounces-1631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 746088B285B
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BC73281BDD
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34CC39AFD;
	Thu, 25 Apr 2024 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UIFbaquY"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA712C463
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070826; cv=none; b=ZSSfrflPIwWOwLE6+7+fEeDRWYExYz2AU2UoGk26v1y0lBe/YuIHrUAh8MtNBEbeI7ltZ4UblG6U+d0s6INMGW4dHwXHxWvTn6fpuJwOPu52irG1FvI3PkVTzdxURPDv7LGpHV1iose6GkJ4b2XYgG/pyqPSFDMB7j5TTnq5zvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070826; c=relaxed/simple;
	bh=oZigtMmHFc2xU6q3JTmVHi100BSKVm2meDvtnKse2JI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=vAQih9/0HY/a7OtwzYSXHp11txgB0zg0/ua2fhApkaB2/JL48i1PVSBSVvww2Ean5lszzxEIiOfh583SUVkdrISnoG1pylhWC8Xotb1nSrfPDDcBvs4Y+6q9vtKSII/tgNYnfHA/m00KZ9eAxUjCK1eImJk9zQDsB9n1rH21yFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UIFbaquY; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240425184703epoutp03449deb48f0c9cb0df1a4ad140e1f93c3~JmlUJsF5g2307023070epoutp03F
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240425184703epoutp03449deb48f0c9cb0df1a4ad140e1f93c3~JmlUJsF5g2307023070epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070823;
	bh=F00u05YI6eiHNm55/ntjfplIagvFXf11AolOIQtFnGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIFbaquYzDBut4jLHtkt+SGi9Lb4+8I5RCLF6atf2TSnanltN0ZiO+1YHJRfCHoqh
	 zmB5NKf8ekf7HqSNlm2K7THGN2eT2YS2V4InT8FyksvSSMKIZq0RnZBcUu0WWkIFdu
	 CQimUtSx2qb0pM8C+IjoJdwZYbZQ2zvshgf4HhFE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240425184702epcas5p2b41c1145228a485e2883078343720f64~JmlTWAB0j1620416204epcas5p2J;
	Thu, 25 Apr 2024 18:47:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VQPwN4g50z4x9Pt; Thu, 25 Apr
	2024 18:47:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	64.C1.09666.425AA266; Fri, 26 Apr 2024 03:47:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca~JmlRRXjxl1328213282epcas5p1M;
	Thu, 25 Apr 2024 18:47:00 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240425184700epsmtrp260d58501356653291e5003ddd22fb1f8~JmlRQnl8X0238902389epsmtrp2d;
	Thu, 25 Apr 2024 18:47:00 +0000 (GMT)
X-AuditID: b6c32a49-f53fa700000025c2-1f-662aa52491d9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6F.C2.19234.325AA266; Fri, 26 Apr 2024 03:47:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184658epsmtip1ffeb5676217af8158896c1660e49b425~JmlPcCPj-0041100411epsmtip1l;
	Thu, 25 Apr 2024 18:46:58 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH 05/10] block, nvme: modify rq_integrity_vec function
Date: Fri, 26 Apr 2024 00:09:38 +0530
Message-Id: <20240425183943.6319-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmhq7KUq00gz0v5C2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKOy
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
	KQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfM
	XdvHVvBcvGLJKYkGxr/CXYycHBICJhJvjhxj7WLk4hAS2M0o8aZrEguE84lRYsvxQ2xwzuut
	N1hhWiZfeMEIYgsJ7GSU2H8uDqLoM6PEiXNvgIo4ONgENCUuTC4FqRERSJF4te41I0gNs8BT
	Rok9X28ygSSEBVwknrzoBhvKIqAqcetNG1icV8Bc4uTijSwQy+QlZl76zg5icwpYSEy+eJod
	okZQ4uTMJ2A1zEA1zVtnM4MskBBYySFx7dwaJohmF4lvc9dBXS0s8er4FnYIW0ri87u9bBB2
	ssSlmeeg6kskHu85CGXbS7Se6mcGeYYZ6Jn1u/QhdvFJ9P5+wgQSlhDglehoE4KoVpS4N+kp
	1CZxiYczlkDZHhKv205AQ7SbUeLR1JvsExjlZyF5YRaSF2YhbFvAyLyKUTK1oDg3PbXYtMAw
	L7UcHq/J+bmbGMFpV8tzB+PdBx/0DjEycTAeYpTgYFYS4b35USNNiDclsbIqtSg/vqg0J7X4
	EKMpMIwnMkuJJucDE39eSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TByc
	Ug1MVduK72SdSn5tyrEz413esTsLj6dMk5gTpRSb9PZ47XExw4n3lBLeT9qxu3LHdzvD/dfM
	ZZNWr1DfOXGrxfIw76bsKaUzPi56fvZryfWzYnM02uXZbnDv5rgaXNK40r0rY/+qbZLH6h93
	8M9M///kZYfwQ+tNghF3kg6kJmuzRkyc5Si16vkZtQX3XtuvT155bRqH/S3R1s7L69Jntb7i
	taze71h6J2Xf9Ion605xnApuPSn1onHnjvencjXXV+fLCqydI5tW/ksy62LItgtnj8y+Y5h3
	kO9pTY7b/rTEx1pdqx5nFga5+fPt9W/8rjg7+O4KtZnZ3MxtoYVeiesdtQs2zAgI+D5hZdS7
	LI7iKiWW4oxEQy3mouJEALqwLQdEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWy7bCSnK7KUq00g9mtjBZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsXi6P+3bBaTDl1jtNh7S9ti/rKn7BbL
	j/9jcuD1uDZjIovHzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fnTXIBnFFc
	NimpOZllqUX6dglcGXPX9rEVPBevWHJKooHxr3AXIyeHhICJxOQLLxi7GLk4hAS2M0rsn3Ce
	ESIhLtF87Qc7hC0ssfLfczBbSOAjo8Tt1S5djBwcbAKaEhcml4KERQSyJPb2X2EHmcMs8JZR
	YtvSlWwgCWEBF4knL7pZQWwWAVWJW2/amEBsXgFziZOLN7JAzJeXmHnpO9h8TgELickXT0Pt
	MpeYumYRI0S9oMTJmU/A6pmB6pu3zmaewCgwC0lqFpLUAkamVYyiqQXFuem5yQWGesWJucWl
	eel6yfm5mxjBkaIVtINx2fq/eocYmTgYDzFKcDArifDe/KiRJsSbklhZlVqUH19UmpNafIhR
	moNFSZxXOaczRUggPbEkNTs1tSC1CCbLxMEp1cC0njty4ovvLUxfxB1dir6yPzjz6MbC7bvu
	nBJcenNq8Yl4g9yJjYkW1Srv8mX5rk3ZMdHSx9mgpmKy2pxDVudMVrm6WDvvUJ/WHT9h/eeZ
	ByZm2WRu6N7++fvc1M0djaoK+8Kv5rHUiW7LWf6es/bS1ttymQf71qpMd98b+pEp6ozyPzZH
	r4CyzaHCip8jXS7f2PdlxfQPjz77sa9Yk3T/2Mun/27q6rVVcnZsPSbaGykqW9nc8nb5zvjz
	e5Pd3r//vGeKm39ngsMt7jPpE5Xtnpnkznrm9URn28m929VnxnwxzWf58XDW9Ct5m49zWr9N
	T1zw59jZo/LcHLtaAmRvyLskRr7MlpJvfL+GpSufSYmlOCPRUIu5qDgRAFle4/MDAwAA
X-CMS-MailID: 20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184700epcas5p1687590f7e4a3f3c3620ac27af514f0ca@epcas5p1.samsung.com>

rq_integrity_vec always returns the first bio_vec, and does not take
bip_iter into consideration.
Modify it so that it does. This is similar to how req_bvec() works for
data buffers.

This is necessary for correct dma map/unmap of meta buffer when it was
split in the block layer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/pci.c       |  9 +++++----
 include/linux/blk-integrity.h | 13 +++++++------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8e0bb9692685..bc5177ea6330 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -825,9 +825,9 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = rq_integrity_vec(req);
 
-	iod->meta_dma = dma_map_bvec(dev->dev, rq_integrity_vec(req),
-			rq_dma_dir(req), 0);
+	iod->meta_dma = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
 	if (dma_mapping_error(dev->dev, iod->meta_dma))
 		return BLK_STS_IOERR;
 	cmnd->rw.metadata = cpu_to_le64(iod->meta_dma);
@@ -964,9 +964,10 @@ static __always_inline void nvme_pci_unmap_rq(struct request *req)
 
 	if (blk_integrity_rq(req)) {
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+		struct bio_vec bv = rq_integrity_vec(req);
 
-		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
+		dma_unmap_page(dev->dev, iod->meta_dma, bv.bv_len,
+			       rq_dma_dir(req));
 	}
 
 	if (blk_rq_nr_phys_segments(req))
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index e253e7bd0d17..9223050c0f75 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -109,11 +109,12 @@ static inline bool blk_integrity_rq(struct request *rq)
  * Return the first bvec that contains integrity data.  Only drivers that are
  * limited to a single integrity segment should use this helper.
  */
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
-		return NULL;
-	return rq->bio->bi_integrity->bip_vec;
+	WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1);
+
+	return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
+				 rq->bio->bi_integrity->bip_iter);
 }
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 static inline int blk_rq_count_integrity_sg(struct request_queue *q,
@@ -177,9 +178,9 @@ static inline int blk_integrity_rq(struct request *rq)
 	return 0;
 }
 
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	return NULL;
+	return (struct bio_vec){0};
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 #endif /* _LINUX_BLK_INTEGRITY_H */
-- 
2.25.1



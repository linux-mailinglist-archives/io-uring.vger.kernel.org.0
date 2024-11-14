Return-Path: <io-uring+bounces-4689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C9EC9C88C0
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B896D1F22644
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706191F8F0B;
	Thu, 14 Nov 2024 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OM6NmlR5"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C01F8F15
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583226; cv=none; b=e/Bathu13tIBFzdM3X8tiHas8ko5w5rxqwHxDrij9lD8HBaS40cACgW+oowpMWiPjCuub038GKaKsTIDYjtbeOPHEm8I3+4sqlmxSRJDVkNOdFWySh/v50ZV3LIgqJLknWMFKhp9WAzJ5t7VE+IEBd+dzk1SCQHsKyQe3EGZoPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583226; c=relaxed/simple;
	bh=z3oZCEUpNWP6ssVVNnvaEMGwTgZ5HxAO2xsIC7OVOu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=d+EZkrvGXUapkJj9dNtuXUHDjJJ+8HvVCD05WcEpHm6GMKlT2TbZ+xQVLg+Io69L1o4aS4Atc+1Plv1F+tCQMAASWaJDOzLZLi9ZiAzIoxnXYCGZ2TeM3RM97xtxeC3iB/E6wtHGWMsYJuzzt8GmpVR08h9jHkdXca59t/SFcD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OM6NmlR5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114112022epoutp015733850683e5f555da0a952ed7812a72~H0cRTag9t2499424994epoutp01B
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114112022epoutp015733850683e5f555da0a952ed7812a72~H0cRTag9t2499424994epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583222;
	bh=n6LNHR2UxOEOGCqUSfrJ4D/dcAXYHqklNM5hsVN/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM6NmlR52Cq2DMdAggMa8MQtckr72iZZ0CEu6K/p9h082lCqLnBe5ZijP0l5km1t3
	 r+Ye7UquJz5u61n5YE5ZjJGAi0AAoj9k25ScClzkPs4GaRwPz/fo72tk+KzqmDBarY
	 +4T+lN++ZTNZKERnehHiqOxnUH859FzkYPj/6me8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241114112022epcas5p4dd08b555c954d3b09f3284c37456fadd~H0cQfbZ250985409854epcas5p4c;
	Thu, 14 Nov 2024 11:20:22 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XpyPJ0wMlz4x9Q6; Thu, 14 Nov
	2024 11:20:20 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.4F.37975.43CD5376; Thu, 14 Nov 2024 20:17:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241114105352epcas5p109c1742fa8a6552296b9c104f2271308~H0FHthlII2293722937epcas5p1j;
	Thu, 14 Nov 2024 10:53:52 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105352epsmtrp1bd5dd694a5fd20726a4d1a142a50e997~H0FHsqFUZ1625716257epsmtrp1s;
	Thu, 14 Nov 2024 10:53:52 +0000 (GMT)
X-AuditID: b6c32a50-0e7f370000049457-80-6735dc3485ee
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	07.5A.07371.FB6D5376; Thu, 14 Nov 2024 19:53:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105349epsmtip2dea0f764454904e67d42a12e5e3f9985~H0FFVzS1y1405814058epsmtip2G;
	Thu, 14 Nov 2024 10:53:49 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 01/11] block: define set of integrity flags to be
 inherited by cloned bip
Date: Thu, 14 Nov 2024 16:15:07 +0530
Message-Id: <20241114104517.51726-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVRTZRzHe+69u9vojDMY6XN2jjFvGQeUl+W2Lm+ZwencSovTy6lTCi52
	Hcje2ktmp2xJUAxpDPGFQaEcMxkBneEIkoENAlkIBCSwoLfDNBIlJULSddq4WP73+f2e7+/1
	eR4OGjmBCzn5GiOt18hVBB6GtXbHxsQvTEmVSbbKKPL64i2MPFAeQMkaRysgG6atOHml+wYg
	J8+1I2R9wzcIea1oECOrjxYiZIXnIiDdvo1kh7sfI2tP+dlk6XgbTn7W9w9CDgX6WOSQvYb9
	WATVbp9mU6MXTJTTUYJTLSffpc5OmnHqut+HUR+dcQBq4HgPm1pw3k85Z64iWWGvFKTl0XIF
	rRfRmlytIl+jTCeefj4nI0cqSxLHi5PJRwiRRq6m04nMbVnxT+SrguMQojfkKlPQlSU3GIjE
	R9P0WpORFuVpDcZ0gtYpVDqJLsEgVxtMGmWChjamiJOSHpYGhbsK8qy+U0A3cu+bvVYnMINr
	XAvgciBfAkc6K0GII/kdADbPciwgLMg3APzy+zmEMf4CsP+nUrYFcFYifqnfyvjdAL5f0ogy
	xgKArg4XK5QK58fAnstFIHQQFUpbduJbLGSg/FkAP3XUYSGVgJ8NRy4dwkNpMf4GOD/1TsjN
	4yfDo1d9LKa/aFg1ssQOMZefAk+bXSijiYD9VTMradCgptBVjTL6MQ4c82oZzoRNAxM4wwL4
	e98ZNsNCOGstXmUlvDnqRxjWwcLeTsDwFljktaKh1lB+LGz+KpFxr4OHvU0IUzYclt2aWQ3l
	wbZP7jABP6ivWWUI3YPmVaZgwFaPM8sqC656eQArByL7XePY7xrH/n/p4wB1ACGtM6iVdK5U
	J47X0Hv/u+VcrdoJVp54XFYbaPgikOABCAd4AOSgRBTPm7FZGclTyPe9Reu1OXqTijZ4gDS4
	bxsqvC9XG/wjGmOOWJKcJJHJZJLkzTIxsZZ3pehjRSRfKTfSBTSto/V34hAOV2hGdlfU2XpO
	iH++h3uhu+Vibx6vK2VvxWnw2vYtD5UsC/ze5rGu24YPE0c32Rel0/Tnc/M1YcuJgoOys5zn
	rLuoiXD2XNzNY4FUSwad8mTxuF+wZuiBxqXXBRuxpfY03/genLdpsbAVLR1aF61+Rur6c9I8
	/953Ik/E1P4/KrJl1bGWI+cteybTdhSzjz24r/+l2vb8If/623gRGr5m7bBq96t1OY3UJS/7
	x5fH3BtSdS2tkhdiBk4e2dnwrM20NbOa5Voof3F/fpMwYbpqeIqaiqp7+7dfv378h1Sec2nQ
	KRsMxCT7dnRu//vQueyy4cB6QQFLUlt54KmqLtnOwZnF6Mve7PMEZsiTi+NQvUH+Lwp5Ag1r
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJXnf/NdN0g4t3TSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXRv+tZYwFl7grjvVvYmxg
	fMfZxcjBISFgIvFwpWMXIxeHkMBuRom/D+6wdDFyAsUlJE69XMYIYQtLrPz3nB2i6COjxJIv
	i8ESbALqEkeet4LZIgInGCXmT3QDKWIGKZrwZTYLyAZhgRiJb+/FQEwWAVWJ93dqQcp5BSwl
	pr+9xQoxX15i5qXv7CA2p4CVxIqGrcwg5UJANd/Xi0CUC0qcnPkE7DRmoPLmrbOZJzAKzEKS
	moUktYCRaRWjZGpBcW56brJhgWFearlecWJucWleul5yfu4mRnCEaWnsYLw3/5/eIUYmDsZD
	jBIczEoivKecjdOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi
	4JRqYFJY0qKXd+7a7WVX5r7c+8igeYuLZs6B5XoLtJmNOfKPiE4Rv5vVMs1ba1JFeP6NnhfN
	y5frTksPYEu4/qg4ceOfeotGSZPri+/WPhHu0XxioTJ/1dy9T4VWRpixqFX2T51n+1a/NOvj
	q0pd5Xc22QsUtv/dU1J/dcJX9cU7eitNTta27zQr9PAsiYlv3/39/Y23OYumyMccV12zQvKH
	fGd/9/7bGmGTFytG6Dg9vSXgqmJptufHfuNZPflKNvOi9RnOLF78rFPq7MtbMXvv7mdr3mWp
	6XFm/8vjzfOaizxFFp6sLz3k9FjI+eL9z6Ey3pc/ms5xCkz4Z2zRwFto9vzFRlvTON73j1wM
	1k3bzKfEUpyRaKjFXFScCABMjY5XHwMAAA==
X-CMS-MailID: 20241114105352epcas5p109c1742fa8a6552296b9c104f2271308
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105352epcas5p109c1742fa8a6552296b9c104f2271308
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105352epcas5p109c1742fa8a6552296b9c104f2271308@epcas5p1.samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2a4bd6611692..a448a25d13de 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -559,7 +559,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dbf0f74c1529..0f0cf10222e8 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,9 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 #define bip_for_each_vec(bvl, bip, iter)				\
-- 
2.25.1



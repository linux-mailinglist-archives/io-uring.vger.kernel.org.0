Return-Path: <io-uring+bounces-2350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE31918002
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E19781C2200B
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7934517F4FE;
	Wed, 26 Jun 2024 11:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TGUTI+ph"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E04417F4E8
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402165; cv=none; b=cJkYODkTbqGNi9m91t26600sURPps05nBbFQn6lhniDWYjnfQeip3CpQ5uV7E1Ck7SDfwtYLQh/gd/q6HpiBTE5qUxmAJYRKe9pMY1ozuj3GMajaEQGWlykO8r57NYV0dJOXitbe//CX2Ch7qRAkyY/x4KO5vgnvEq+8DddmxrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402165; c=relaxed/simple;
	bh=Ye60aMacrW6f9lG8I1I8yRoH+wWZJi7uruWP6l4rL6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kx0bLhI7YVwnmCB5nA9h0jDsCn2Gk9nVKVMuM0QKYoiQc/oOpi0lIeYoDgJqmqdJhxwi7FzNHwM4ABtir9HTZgFf4dwWRkIJt8JE/Ao4TTmeKDQzdY3HWLe0wD6NaNGDmc9iTjcxpAjX7uYoUh4JUBmTeveVF6SuMATSFkY8eNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TGUTI+ph; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240626114240epoutp0269ea51afbb9d292faa89b50013704255~ciye_LUDe3216632166epoutp02T
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:42:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240626114240epoutp0269ea51afbb9d292faa89b50013704255~ciye_LUDe3216632166epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402160;
	bh=5kTE0BFBF0NkwRuxNrhjo9kS5g5kwSIAlNctz7NPi7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGUTI+phcjZ1TYfhStHM/mQEDWWq8mcUG/ouaZgdlw2l0AMEECtrpVlROHMuxg0fH
	 V4NMiQaU4u6+iUCgHhYoJ5OBjpt8FYRJR52NyfCjh5f3VEk7w6fw/EpzyDBfLJ0h22
	 LHJXdj8ORAWpiSfYgxCzP+hPbDCoRtCnVM1hDkjk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240626114240epcas5p18ae0d2cffa9a01de8d3875c1abd5d0c2~ciyedy0ae2539325393epcas5p1g;
	Wed, 26 Jun 2024 11:42:40 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W8KZ55tlVz4x9Pq; Wed, 26 Jun
	2024 11:42:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.18.09989.CAEFB766; Wed, 26 Jun 2024 20:42:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240626101523epcas5p2616cf568575685bd251d28fc1398d4cd~chmRklWea2650826508epcas5p25;
	Wed, 26 Jun 2024 10:15:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240626101523epsmtrp26c71078e361bf1739cf506d2c5548f49~chmRj1d7j1237112371epsmtrp2S;
	Wed, 26 Jun 2024 10:15:23 +0000 (GMT)
X-AuditID: b6c32a4a-bffff70000002705-79-667bfeaca198
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8A.6A.19057.B3AEB766; Wed, 26 Jun 2024 19:15:23 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101521epsmtip19437341e5e71640b9f53f9f64293488b~chmQE0-LX0147101471epsmtip1U;
	Wed, 26 Jun 2024 10:15:21 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 07/10] block: define meta io descriptor
Date: Wed, 26 Jun 2024 15:36:57 +0530
Message-Id: <20240626100700.3629-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmpu6af9VpBrsmaVnMWbWN0WL13X42
	i5WrjzJZvGs9x2Jx9P9bNotJh64xWuy9pW0xf9lTdovlx/8xWUzsuMrkwOWxc9Zddo/LZ0s9
	Nq3qZPPYvKTeY/fNBjaPj09vsXi833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
	KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ9x8/4K9YCtrxfG25+wNjCtZ
	uhg5OSQETCTePHrJ2sXIxSEksJtRYurzb1DOJ0aJlke7mCCcb4wSD+fNYYVpubpiOVTVXkaJ
	zfefQzmfGSVmNt0CG8wmoC5x5HkrI4gtIlArsbJ1OjtIEbNAA6NE94Tv7CAJYQEriX2rz7KB
	2CwCqhLH/nSANfMKWEgcvbiOHWKdvMTMSxD1nAKWEnc2b2eEqBGUODnzCVg9M1BN89bZzCAL
	JARmckgserwM6lYXiVtLXkHZwhKvjm+BGiol8fndXjYIO13ix+WnTBB2gUTzsX2MELa9ROup
	fqChHEALNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdhKEu0r50DZEhJ7zzVA2R4Ss55P
	ZYSEVg+jxLGWVSwTGBVmIflnFpJ/ZiGsXsDIvIpRMrWgODc9tdi0wCgvtRwez8n5uZsYwYlX
	y2sH48MHH/QOMTJxMB5ilOBgVhLhDS2pShPiTUmsrEotyo8vKs1JLT7EaAoM8InMUqLJ+cDU
	n1cSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5OOtqH3tqlCxyKT
	mUNCah7p8UYtjFn903P+DcWbydu3Hd9bkvNc4/7resOr792nS3q9tn3Pv3TKFKVOz5WrLa+L
	hbv95Eg86mu1rSB138PTquuKdviYWGuxTAz7aLzwhXKabUaceJpBwre6fZWu5YdsViR4mIqo
	SPKeVTxaue57dZu/jdAKFvvp2bPi/xuc+vp0f+aRdBM5q1tn/uk0P1xlZbHc5O3ysgr/ggX5
	PpJTbzytrjt8+ol/uWdzjfraje+CvE9PelFx7oU9t8FbzdzFfW7NEm2nl1gU2PkytfMxa2ct
	eJDjuqGfM8M1f6NklviEWzxGhjUvNqX9b1v06NHsk1/O3fHL7ZpYxnQzU4mlOCPRUIu5qDgR
	AOu3e7tFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSnK71q+o0g0c/JCzmrNrGaLH6bj+b
	xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu8Xy4/+YLCZ2XGVy4PLYOesuu8fls6Ue
	m1Z1snlsXlLvsftmA5vHx6e3WDze77vK5tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZN9+/
	YC/YylpxvO05ewPjSpYuRk4OCQETiasrlrN2MXJxCAnsZpR40TCbFSIhIXHq5TJGCFtYYuW/
	5+wQRR8ZJWataATrZhNQlzjyvJURJCEi0MoocWBqC5jDLNDCKDG3tYUdpEpYwEpi3+qzbCA2
	i4CqxLE/HWDdvAIWEkcvrmOHWCEvMfPSdzCbU8BS4s7m7WCrhYBqHjxvZoWoF5Q4OfMJWC8z
	UH3z1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzg2tLR2
	MO5Z9UHvECMTB+MhRgkOZiUR3tCSqjQh3pTEyqrUovz4otKc1OJDjNIcLErivN9e96YICaQn
	lqRmp6YWpBbBZJk4OKUamEwbCiXftgctNahYVMLcIOVX8u7Z8ZU7JP7OU5wrudv3eb3OUo2F
	cyv2556QWJ/mbBqpdFUvtOXuvFp/l6VHSre0qsdNNM85XXH38I0SzflG03OnOKezaGqdLrS/
	tqJleZD8iXPtf29ZRT1dXXCZMYBBKrQx8cSGix/Oya8xqop7HRScc85c9mR62ZGqfZwJU1k4
	GFa/OnCD9ZS3l+Fl2aJfGxUftL803Xn/3abe2bxvY9azflzDoON04EnWRIsKuRnOzIt41T99
	0U07l8lkunqBSW3Rmjv2W9cGl54qrLgyV0hN59XUc7sf+i0pVHr8TTl//6b45Uc8+LI7lU9d
	/97t8uJrOOv8R/cNDly7XqTEUpyRaKjFXFScCADxPj0i/AIAAA==
X-CMS-MailID: 20240626101523epcas5p2616cf568575685bd251d28fc1398d4cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101523epcas5p2616cf568575685bd251d28fc1398d4cd
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101523epcas5p2616cf568575685bd251d28fc1398d4cd@epcas5p2.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

Introduces a new 'uio_meta' structure that upper layer can
use to pass the meta/integrity information. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/bio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index c90168274188..966e22a04996 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -332,6 +332,12 @@ enum bip_flags {
 	BIP_CLONED		= 1 << 7, /* Indicates that bip is cloned */
 };
 
+struct uio_meta {
+	u16 flags;
+	u16 apptag;
+	struct iov_iter iter;
+};
+
 /*
  * bio integrity payload
  */
-- 
2.25.1



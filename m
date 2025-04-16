Return-Path: <io-uring+bounces-7473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1393A8B1BB
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 360F31895C05
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 07:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF72C221FB8;
	Wed, 16 Apr 2025 07:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FPUx7vCm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84AD26296
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 07:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744787538; cv=none; b=tu1Cl1MYUnKiCXB4YTpFu94R6+d/5mfgAVOM0f7m8tNHTZhmNci93rj5PxVcylstmXeVGBdQ6EHZ4ka3rxs1aVd5TA5W75uFxQHVFHz1bEVKv0IZzMEz0QNVHHINPr1jMO5Hn1PNsWUiTa6ph1kpOx2B1lWTXS2Mi0bt6Tb/lC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744787538; c=relaxed/simple;
	bh=xDDcW/yh5WwRX8GowWgfey0TjKGVFHdjmfqP2jlNGLI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:References; b=B7OJslux0tg4u5Toq2pB1Pkld0rvmQtNJSElkWIweWV5QifvBVjMl4x4dBL1I3AbUISMqUhph1XjkGOaJCebE5NHuXeKoF2VdeY8KR0oEbZhRYajUOwIE3CvUvBf1DWPy5hF5FhAlGz3KoXhTScuMUuT/MMBl7ZoCOcVgLD0peE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FPUx7vCm; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250416071207epoutp01baf27cb6bb1cd1a823124fab6912c523~2uwMrSj6z2000320003epoutp01D
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 07:12:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250416071207epoutp01baf27cb6bb1cd1a823124fab6912c523~2uwMrSj6z2000320003epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744787527;
	bh=Sp/AfvFZrKUebiEPouVjGoI4C1RBrg4TQO9aRIbLLt8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=FPUx7vCmIlTqq69CDYyosT1XBjqtNaTjCl5XYtUmUjRBVUz18FGkUSoCfaOhCaT9L
	 Z4hV858n4ZDgDSf3tXFaVmm05vonR/9M/x9VC5CKjJT+iUT2TvEC3IH+pkrMUdDL+m
	 1h7jeTYeNs/MUd5MfwjTx+PdosKxJuDcGHKN7ZII=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250416071207epcas5p40b443a883f19d8eb8abef67d0ed949f9~2uwMW78p00736407364epcas5p4r;
	Wed, 16 Apr 2025 07:12:07 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZcsfF6pqPz6B9m7; Wed, 16 Apr
	2025 07:12:05 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2A.28.10173.5485FF76; Wed, 16 Apr 2025 16:12:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05~2tq9ii79B1170811708epcas5p2D;
	Wed, 16 Apr 2025 05:52:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250416055250epsmtrp1d98ab536639d9c9a1fd3e7e97f91e732~2tq9h3PhP0934409344epsmtrp1k;
	Wed, 16 Apr 2025 05:52:50 +0000 (GMT)
X-AuditID: b6c32a44-8b5fb700000027bd-76-67ff5845e610
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.91.07818.1B54FF76; Wed, 16 Apr 2025 14:52:49 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
	[107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250416055248epsmtip2c8f30a2c7162811596b655a2ee9db302~2tq8bhws52102421024epsmtip2d;
	Wed, 16 Apr 2025 05:52:48 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, Nitesh Shetty
	<nj.shetty@samsung.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
Date: Wed, 16 Apr 2025 11:14:12 +0530
Message-Id: <20250416054413.10431-1-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7bCmpq5rxP90gynnDC3mrNrGaLH6bj+b
	xc0DO5ks3rWeY7G4vGsOm8WOJ42MFtt+z2d2YPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITuja34b
	c8EpzoqWWT8ZGxgPsncxcnJICJhIfJx+nLmLkYtDSGA3o8SOP0vZIZxPjBKd3ZcZIZxvjBKH
	Hu5mhWn5taCPCSKxl1HiwtM1UC2tTBKfn2wEGsbBwSagLXH6PwdIg4iAp8S5WcvBGpgFpjBK
	HJ3YwwaSEBZwlri8ZAkTiM0ioCqxc3ofmM0rYCXxZ85xqAPlJVZvOAB2oITAMnaJm4tgznCR
	OLwa5gthiVfHt0DZUhIv+9ug7HKJlVNWsEHYJRLP//RC2fYSraf6wQ5lFtCUWL9LHyIsKzH1
	1DqwG5gF+CR6fz9hgojzSuyYB2MrS6xZvwBqjKTEte+NULaHxIrP/YwgtpBArMShiZ/ZJjDK
	zkLYsICRcRWjZGpBcW56arJpgWFeajk8ppLzczcxghOWlssOxhvz/+kdYmTiYDzEKMHBrCTC
	e878X7oQb0piZVVqUX58UWlOavEhRlNgmE1klhJNzgemzLySeEMTSwMTMzMzE0tjM0Mlcd7m
	nS3pQgLpiSWp2ampBalFMH1MHJxSDUz2UxTmBi6K6W25mXWyKKPz4bucNeWfynrjdHQ10zbn
	3AmoFduUtcPXc3dgyhHZf3WBiYFTWaZMnDzddHN6g87z6dJ3Vx3aarPl1I+81NPyk/eFbP+c
	bf+d/9+v50fy95iwJUm2L9Hk+/H5bvKDEGWGiymcpdMupypovmyr+1q/VPVpWprcTQuP4Dzz
	hw2O6uVyFyZE+qrnbvMwCp22qfZ3v/2NTcsy32YHW39W+/uem83fd4G92M9+IXbGbm5f68fz
	/IQF15t5PDnWG2aScaOe402bqr6N07fO/KcrnmcnVsqG6Z+4uOn86V0L1z/s4nW1F7TlV+Jw
	XegxOW/G3W6/Hwx/lnGZPy5RZ9ksrMRSnJFoqMVcVJwIAHqhccPhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsWy7bCSvO5G1//pBsuemlvMWbWN0WL13X42
	i5sHdjJZvGs9x2JxedccNosdTxoZLbb9ns/swO6xc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK6NrfhtzwSnOipZZPxkbGA+ydzFyckgImEj8WtDHBGILCexmlDg7XxQiLimx
	7O8RZghbWGLlv+dA9VxANc1MEpd6frB0MXJwsAloS5z+zwFSIyLgLfF+3yWwGmaBGYwS706d
	ZgFJCAs4S1xesgRsAYuAqsTO6RDLeAWsJP7MOQ51hLzE6g0HmCcw8ixgZFjFKJlaUJybnpts
	WGCYl1quV5yYW1yal66XnJ+7iREcOFoaOxjffWvSP8TIxMF4iFGCg1lJhPec+b90Id6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rwrDSPShQTSE0tSs1NTC1KLYLJMHJxSDUytHYqbmUXObtaUOJq9
	LKP72NEST0bFXQuOX92nek0ow/y3HpdEFluGweUz/JkfLs+axyTZ/uvC9i8zxFQfSXb9n/B9
	N0uGaImHymVVZ5/TKTefG+0NU2d8LOk5v+FZ3cPNn97Zcx9ZeIwxye5ASdrr+N86U7/8+N/G
	I3Yx8uLDkN/pQmtspsdvO73kT5Hvc8vU5THF1yJXz5h5JC/musBUHwab85nJpWmzvHZpbdKY
	oCx74olwUC+bhnTg9jSGCW/yTZ4cz7OY/yHombhKz9PrT5o+3mYLlTLc+Srklv55zdSvyjJ8
	pZNj6mqP3K/efuyE+gn7h2GXnnDnJQo9njmr/eoJ7/UHInkceCZNvf5QiaU4I9FQi7moOBEA
	/GT8v4sCAAA=
X-CMS-MailID: 20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Sending exact nr_segs, avoids bio split check and processing in
block layer, which takes around 5%[1] of overall CPU utilization.

In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
and 5% less CPU utilization.

[1]
     3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
     1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
     0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split

[2]
sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
-r4 /dev/nvme0n1 /dev/nvme1n1

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 io_uring/rsrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b36c8825550e..6fd3a4a85a9c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
 		}
 	}
+	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
+		iter->count + ((1UL << imu->folio_shift) - 1)) /
+		(1UL << imu->folio_shift);
 
 	return 0;
 }

base-commit: 834a4a689699090a406d1662b03affa8b155d025
-- 
2.43.0



Return-Path: <io-uring+bounces-5117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 874A59DB6CD
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB7B3163A3F
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE61519AD90;
	Thu, 28 Nov 2024 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uMtaylQL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D974419AD8D
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794369; cv=none; b=HOuSAurszF2hkLg+EAQIpSRm6O1DxCpMH2xDvpfULsuqcJKttjVJ+tTvLLmGbexqESLIyBX9K5SJgYod81e+CzuIys5SRI3VsNIOceD2LepVJcSOUDjN/ZoRi8dfxsR3wAYOj/Fy8qxNqLn/i5zIuvwEeTaS1d+tgcaezPJQweY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794369; c=relaxed/simple;
	bh=uDUb87C52DXoVA3KvOoAoNEyjHqrw30MJR/Iqxaidaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cJUZYsJOInXtbxX9fECr3FwprjKyx4FDPy51PEKLuYZ69a97ErhkgluvSiqE1hyHvCYHWYxml8nmzb3QhRcCpfOT63rxTnyRZedToysWKVQ+NXl/zLg8oas02aJbibsj97Sxqzd9SaGJneIkwgaeQ6vvdHn+DU3qBuo78WHTI6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uMtaylQL; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241128114606epoutp01ad40c1e9c1ad07cda3349c6e5155f718~MH0uYuvaY2980429804epoutp01S
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241128114606epoutp01ad40c1e9c1ad07cda3349c6e5155f718~MH0uYuvaY2980429804epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794366;
	bh=sPCiH7C8otAPeKBQxafGfpBc//4CVwTtOappMXTNYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMtaylQLnoirBb+DALUMMNs1Sq6fESXvIKCK1CfhBlWipmk573SecHhPh+FWPF4Mi
	 Q3qR+G9hFjKwCCsvxBX9xaiuvAO60ZJw/vP/bGrZ6qc5tjhQQwd+muNC2DRbpuHQAh
	 AUW3uuKGooTmrDIcg/N3O5D31I+c+VmKhoEiK3ys=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241128114605epcas5p1cec9fb18659d8b581ddfd082482705c0~MH0tcaPjF1146111461epcas5p1h;
	Thu, 28 Nov 2024 11:46:05 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XzZJW2JG3z4x9Pw; Thu, 28 Nov
	2024 11:46:03 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	23.29.29212.BF758476; Thu, 28 Nov 2024 20:46:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241128113104epcas5p4c4bd9f936403295e4cbac7c1f52d9b30~MHnmLIkgM1913419134epcas5p4B;
	Thu, 28 Nov 2024 11:31:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241128113103epsmtrp142fbee2b6480ba49bc6b2a5d7da9e078~MHnmIgq-70051900519epsmtrp1R;
	Thu, 28 Nov 2024 11:31:03 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-d0-674857fbb6d9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.5E.18949.77458476; Thu, 28 Nov 2024 20:31:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113101epsmtip2c8b97814a32da798b63cc7169b26c181~MHnjvILQO2660826608epsmtip2P;
	Thu, 28 Nov 2024 11:31:01 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v11 04/10] fs, iov_iter: define meta io descriptor
Date: Thu, 28 Nov 2024 16:52:34 +0530
Message-Id: <20241128112240.8867-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmpu7vcI90g99nuC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZyyZpltwhbdi8bWFbA2Ms7m7GDk4JARM
	JM73pncxcnEICexhlFh94ywLhPOJUaLn1V82COcbo8TfhZOBHE6wjnNrVzBDJPYySrzZ9Q7K
	+cwosf3SRXaQKjYBdYkjz1sZQRIiIIN7F54GG8wsMIFJon3iHLAqYQEnie6J3WA2i4CqxJZ7
	S1hBbF4BC4njN3YxQuyTl5h56TtYDaeApcTsa9+gagQlTs58wgJiMwPVNG+dDXaGhMANDolH
	b6axQbznItH6QB1ijrDEq+Nb2CFsKYmX/W1QdrrEj8tPmSDsAonmY/ug9tpLtJ7qZwYZwyyg
	KbF+lz5EWFZi6ql1TBBr+SR6fz+BauWV2DEPxlaSaF85B8qWkNh7rgHK9pCY2tjDBAmtHkaJ
	iXuns05gVJiF5J1ZSN6ZhbB6ASPzKkap1ILi3PTUZNMCQ9281HJ4NCfn525iBCd0rYAdjKs3
	/NU7xMjEwXiIUYKDWUmEt4DbPV2INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wNzSl5JvKGJ
	pYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUxtx7+t2Hy22NwxXHDOJhfd
	U8bxO2RnfnzBFCF1xutYgve0nSqNhfLxNmfClXmarHYY37WNjN5/h2lr/UHlSdPLuBIuRLhM
	dnCdUNveF8ohv9U56zmL9AFptgmRy3dxaLwV/rjnTF5Ibb/Ur40Kf1yUQ73jnE4mdWhMvf/o
	y95vfieXLD334tC8XQZah1Sk37vH9eUWX+G//bP+44HSK2ra/AyzAqfX6repyB8QPMS02W/e
	ypl6DXpldn8eG+SsLZ3IJtEz5VkNR+3PX2fPNh1SfO75OVLFynTmAeuprw7+P+V9siyiQXfp
	5xksX/xP/m8NarygebJuw5vwJwm7ChUWuC83+rbWPffKI6sU/hwlluKMREMt5qLiRAB/aUHq
	cQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvG55iEe6weeXphYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZS6bpFlzhrVh8
	bSFbA+Ns7i5GTg4JAROJc2tXMHcxcnEICexmlHjf+4AFIiEhcerlMkYIW1hi5b/n7BBFHxkl
	jr87zgSSYBNQlzjyvBWsSETgBKPE/IluIEXMAjOYJHp+rWADSQgLOEl0T+xmB7FZBFQlttxb
	wgpi8wpYSBy/sQtqg7zEzEvfwWo4BSwlZl/7BlYjBFRz+fF1qHpBiZMzn4BdxwxU37x1NvME
	RoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjjgtrR2Me1Z90DvE
	yMTBeIhRgoNZSYS3gNs9XYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWp
	RTBZJg5OqQamNZFn7//t/jK90Cxs9ULGr4uN2Z7pppZOtzo1f8PeRKatBz+9d/JbNmu5kO+L
	lcdfzil8Gv1C/dtKa1c5sfvtTpOP802MklJnm/jHNWI6y7YJ7Mtu3zw5Q+NZ/jLh/atnrS7/
	Kd2zws03yMy/ouvr1IMP5lUlMcyrfiifGS3pVOQnKb7ut/y21evWp18X1Llu8P5Z8YcFkv3O
	cyevKaiYGvlSoYlN3J5vbofSh9tnJjiXPt29v3BOX1J0DPsMxVh111lFwvsjRDp5JYou2X9I
	bf/Y6/K35PiiC/fvBG3s19/s8N80eW2R2Cfzq/82P/Lqd53wJ8BOXGzmC+ZcF533UcGCyQan
	mZl4HlibblT+osRSnJFoqMVcVJwIAApfE90nAwAA
X-CMS-MailID: 20241128113104epcas5p4c4bd9f936403295e4cbac7c1f52d9b30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113104epcas5p4c4bd9f936403295e4cbac7c1f52d9b30
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113104epcas5p4c4bd9f936403295e4cbac7c1f52d9b30@epcas5p4.samsung.com>

Add flags to describe checks for integrity meta buffer. Also, introduce
a  new 'uio_meta' structure that upper layer can use to pass the
meta/integrity information.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uio.h     | 9 +++++++++
 include/uapi/linux/fs.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 853f9de5aa05..8ada84e85447 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -82,6 +82,15 @@ struct iov_iter {
 	};
 };
 
+typedef __u16 uio_meta_flags_t;
+
+struct uio_meta {
+	uio_meta_flags_t	flags;
+	u16			app_tag;
+	u64			seed;
+	struct iov_iter		iter;
+};
+
 static inline const struct iovec *iter_iov(const struct iov_iter *iter)
 {
 	if (iter->iter_type == ITER_UBUF)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..9070ef19f0a3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-- 
2.25.1



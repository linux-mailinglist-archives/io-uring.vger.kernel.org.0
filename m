Return-Path: <io-uring+bounces-1871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E10378C2FD8
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 08:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E2B81F22FFA
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 06:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0A8A41;
	Sat, 11 May 2024 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="a612tyK/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA801C01
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715409058; cv=none; b=K4TGib3L2qscfW01mHz+40POb28DfNt1Dydve2MYtfWEoYUJrg70u02lVOvr1wt9gCWUvKNJ9oLwkSi/7SJLX9/JKdcwBLv8qXa7mzBbkC06lmP7WdTGzPO1YCghGeDnZSbpXXcnIkSEzH7M/FyT/RoiTF7oAq0/yKrAzkZUsxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715409058; c=relaxed/simple;
	bh=qQDVbo2zNhRgCypeLLC78vrJ0ywWDK++kIZPUGQTr1w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NtEC8NaN4GdZK0WdkR6OMBCp3X+T1Zw0v9wJnXJjWxsN3XiEavAUzlrGBDEWSEIIKgGJM/bG2P0mWm3TfEu6cTnot3TJmhk3vbgNG5uC8FwY6CvLL8OqpnoznUrlcUyGrYqKYooMEI8CNUHatX9pZILHFo4ceV2dP1Mzl/A2iCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=a612tyK/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240511063047epoutp042401555103319cabdeb26d2aedd32bdd~OW3C6OZ1v1078310783epoutp04y
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240511063047epoutp042401555103319cabdeb26d2aedd32bdd~OW3C6OZ1v1078310783epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715409047;
	bh=+bAmOvxlNrI4OUAx/tDTCXzBPY5PuA60g2e4gjWolnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a612tyK/cL7FG3sp4mWHJoWOLCB/8g/6TXWzCUadq89x7nkf8IrFkKqxGwqGb/5zg
	 OLGPwmOzszbvaGPkuiAMWClZTSIgmDVofLP8sCIl6qjOqyIR9GszlAQQdBWhvFK7tm
	 /obr3MwVpZRWSeL1OtzPIEaoPniUFM0JZE+NoQcM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240511063047epcas5p4569bbff7478877081d1c62d3c8ccad3d~OW3CmsrCG2475724757epcas5p4P;
	Sat, 11 May 2024 06:30:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VbwqT3GxQz4x9Pp; Sat, 11 May
	2024 06:30:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.F5.09666.5901F366; Sat, 11 May 2024 15:30:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240511055247epcas5p2a54e23b6dddd11dda962733d259a10af~OWV3BQgr93263732637epcas5p2x;
	Sat, 11 May 2024 05:52:47 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240511055247epsmtrp25b1a1dd968f2e16627343bfc0a013f60~OWV3Ajb_k2153021530epsmtrp2N;
	Sat, 11 May 2024 05:52:47 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-04-663f10956289
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.33.08390.FA70F366; Sat, 11 May 2024 14:52:47 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240511055246epsmtip1d8d50fa25572c791a6b8a2f42aaa28a5~OWV2Cl48I2084420844epsmtip1a;
	Sat, 11 May 2024 05:52:46 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v2 3/4] io_uring/rsrc: add init and account functions for
 coalesced imus
Date: Sat, 11 May 2024 13:52:28 +0800
Message-Id: <20240511055229.352481-4-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240511055229.352481-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmhu5UAfs0g607hS3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITtjyd5upoKXUhU9uy+wNTDOFO1i5OCQEDCRWHKApYuRi0NIYDejxIP7L9kh
	nE+MEh8PPmeFcL4xSqyefom5i5ETrOPqpx3sILaQwF5GiSmr+SGKfjFKHP4wgwUkwSagI/F7
	xS8wW0RAW+L146lgO5gFljBK7OpczgiSEBaIkvj5YgXYVBYBVYmjqzcxgdi8ArYSl/98ZYLY
	Ji+x/+BZsBpOATuJwy/b2SBqBCVOznwCtoAZqKZ562yo676yS7y76Qthu0gsuXmTFcIWlnh1
	fAs7hC0l8fndXjaI/4sllq2TA7lNQqCFUeL9uzmMEDXWEv+u7GEBqWEW0JRYv0sfIiwrMfXU
	OiaItXwSvb+fQJ3JK7FjHoytKnHh4DaoVdISaydshTrNQ2Ldse/MkICbyCjxtpt9AqPCLCTf
	zELyzSyEzQsYmVcxSqYWFOempxabFhjmpZbD4zg5P3cTIziBannuYLz74IPeIUYmDsZDjBIc
	zEoivFU11mlCvCmJlVWpRfnxRaU5qcWHGE2BwT2RWUo0OR+YwvNK4g1NLA1MzMzMTCyNzQyV
	xHlft85NERJITyxJzU5NLUgtgulj4uCUamBS39ZecyAj7Hncp8PuffXcJ9tEGC9NsJD5Hs8Z
	UPT/7DLL3qLF5qbmldyTqpn3Lj69V+ndY9VbK8wXHPi/0L2K4aOo2fyEit6JeVOy7yYmVoVZ
	Pc/3DnKYFTHx5LsbcULvN/m8dEy4cW9b4eKMNovlM8tT5apC2+r982sqvb6vq0q0PVLQv3Ja
	/HlJJ9Zjr2u7d+uabvtTNYdNSOb0w41n4t8/qItm3Py117j0zD99/aiW0CuHeLbNO8wS6izD
	ePrh8X9/3j5fr3cte+r0109NWFeuc31kss7kkPiZC9NfndJ6dzGSqXZR1+1Eccv3M/cm3mmx
	Vn8kcyBv4YbebYVFJhYzFvvIN5S/nmv35jy/EktxRqKhFnNRcSIAse5U3ykEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnO56dvs0g3ff2S3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlbFkbzdTwUupip7dF9gaGGeKdjFyckgImEhc/bSD
	vYuRi0NIYDejxJMn/1ggEtISHYda2SFsYYmV/55DFf1glHjwaxErSIJNQEfi94pfQA0cHCIC
	uhKNdxVAapgFVjFKXH3fDlYjLBAhsWZnH9hQFgFViaOrNzGB2LwCthKX/3xlglggL7H/4Flm
	EJtTwE7i8Mt2NhBbCKjm1NQzzBD1ghInZz4Bm8MMVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0o
	zk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5zLa0djHtWfdA7xMjEwXiIUYKDWUmEt6rGOk2I
	NyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJJanZqakFqUUwWSYOTqkGpuPJLhYtjj7/
	5s61j8h9+umYOePyy6U3OZrs7mVW7p3OUb7W8Ht4fMY3rdpVCbLMr/vbFDs0OGxZjujm34qf
	F2czd+Z2nTc5tTu5Y86f2/w2WYJzid0pm/+1s+RnnuF+JDvvvkx/T7HP+7sKsT0V/zbpF1Ye
	YTe0dXX83/D/b/yrz2HnS1csknJ1vXRBa6VT3UrmT7IT02vP8ot3tze8k2hvnvd40+pZ019N
	fhuiJRKr0JX5fU/idJZv6WdSZjVdeqYuWlp/0CEz4VPZn1VOzz8zuy5wbbp6NPRf4MfXxQaT
	KkJPT3yrcazywPpzjtvPXdjN8zP7woZy2U/Kwod/dSftZVZJeqmUrJS+7bTxbiWW4oxEQy3m
	ouJEAAN5tgziAgAA
X-CMS-MailID: 20240511055247epcas5p2a54e23b6dddd11dda962733d259a10af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240511055247epcas5p2a54e23b6dddd11dda962733d259a10af
References: <20240511055229.352481-1-cliang01.li@samsung.com>
	<CGME20240511055247epcas5p2a54e23b6dddd11dda962733d259a10af@epcas5p2.samsung.com>

This patch depends on patch 1 and 2.
Introduces two functions to separate the coalesced imu alloc and
accounting path from the original one. This helps to keep the original
code path clean.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 578d382ca9bc..7f95eba72f1c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,42 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static int io_coalesced_buffer_account_pin(struct io_ring_ctx *ctx,
+					   struct page **pages,
+					   struct io_mapped_ubuf *imu,
+					   struct page **last_hpage,
+					   struct io_imu_folio_data *data)
+{
+	int i, j, ret;
+
+	imu->acct_pages = 0;
+	j = 0;
+	for (i = 0; i < data->nr_folios; i++) {
+		struct page *hpage = pages[j];
+
+		if (hpage == *last_hpage)
+			continue;
+		*last_hpage = hpage;
+		/*
+		 * Already checked the page array in try coalesce,
+		 * so pass in nr_pages=0 here to waive that.
+		 */
+		if (headpage_already_acct(ctx, pages, 0, hpage))
+			continue;
+		imu->acct_pages += data->nr_pages_mid;
+		j += (i == 0) ?
+			data->nr_pages_head : data->nr_pages_mid;
+	}
+
+	if (!imu->acct_pages)
+		return 0;
+
+	ret = io_account_mem(ctx, imu->acct_pages);
+	if (ret)
+		imu->acct_pages = 0;
+	return ret;
+}
+
 static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
 					 struct io_imu_folio_data *data)
 {
@@ -949,6 +985,56 @@ static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
 	return true;
 }
 
+static int io_coalesced_imu_alloc(struct io_ring_ctx *ctx, struct iovec *iov,
+				  struct io_mapped_ubuf **pimu,
+				  struct page **last_hpage, struct page **pages,
+				  struct io_imu_folio_data *data)
+{
+	struct io_mapped_ubuf *imu = NULL;
+	unsigned long off;
+	size_t size, vec_len;
+	int ret, i, j;
+
+	ret = -ENOMEM;
+	imu = kvmalloc(struct_size(imu, bvec, data->nr_folios), GFP_KERNEL);
+	if (!imu)
+		return ret;
+
+	ret = io_coalesced_buffer_account_pin(ctx, pages, imu, last_hpage,
+						data);
+	if (ret) {
+		j = 0;
+		for (i = 0; i < data->nr_folios; i++) {
+			unpin_user_page(pages[j]);
+			j += (i == 0) ?
+				data->nr_pages_head : data->nr_pages_mid;
+		}
+		return ret;
+	}
+	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
+	size = iov->iov_len;
+	/* store original address for later verification */
+	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->ubuf_end = imu->ubuf + iov->iov_len;
+	imu->nr_bvecs = data->nr_folios;
+	imu->folio_shift = data->folio_shift;
+	imu->folio_mask = ~((1UL << data->folio_shift) - 1);
+	*pimu = imu;
+	ret = 0;
+
+	vec_len = min_t(size_t, size, PAGE_SIZE * data->nr_pages_head - off);
+	bvec_set_page(&imu->bvec[0], pages[0], vec_len, off);
+	size -= vec_len;
+	j = data->nr_pages_head;
+	for (i = 1; i < data->nr_folios; i++) {
+		vec_len = min_t(size_t, size, data->folio_size);
+		bvec_set_page(&imu->bvec[i], pages[j], vec_len, 0);
+		size -= vec_len;
+		j += data->nr_pages_mid;
+	}
+	return ret;
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
-- 
2.34.1



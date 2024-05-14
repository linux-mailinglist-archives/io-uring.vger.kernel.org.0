Return-Path: <io-uring+bounces-1903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A95B8C4D66
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 09:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F08AB2240B
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39ECD17577;
	Tue, 14 May 2024 07:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="faID5NVQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02863125A9
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673454; cv=none; b=dJSLxDjd96Y3LMtIoDu2MiYZtnN9MoDXpNpbwQHJfNI+Dp/htW+pE/+hTUJwxB+rnZayYZgj90AS4S/rg1IZKJd+/jDpSBCkkxIsVXcg6CHfrH3GbyWSsTDK/NSY2xqBlhF7B3xesprpLFe07QDOcojpQmdTu+AqWvtGcBACkjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673454; c=relaxed/simple;
	bh=GgB79gShNLQoKk+gewD6WVXUhfoRMFUqTI993fcouUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ZlGJX6R/heMdawzonxHQN+VKfXUatRY8xt+Dy+BQhc20fV9gPiGcF5ncgG7kz1FNplZDO6cjOD15YZkL6FWiDtPN8V920o/uOFSh39BYzcGA/GJ0xXQyC4GJ/op70zyVVJGxd6ny8ThuBdRh576N+IRA9M8gc80D2VILZjMYUMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=faID5NVQ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240514075728epoutp0114586bcf4ab64ad7c398ed08b3e68b08~PS_lb22y61756217562epoutp01p
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:57:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240514075728epoutp0114586bcf4ab64ad7c398ed08b3e68b08~PS_lb22y61756217562epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673448;
	bh=luky4jv5sJLLkurx2YzjEwBLcK+91Q/SXM6pUFX2CzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faID5NVQXC5L4sKV0XgFDVte5/tNCHCdAnXo0fFrQAiO6/9tNhyGdLLge20+ikYO2
	 JtI70+FRbpth5dQ3MzSsAZkGNBbzulY4LwFsCn+DpSaPrJTDP+nFU+FzlDsEH1uPDb
	 Nl6FXff4jOEEPCkP9Mb0H9+lc9h3YUnVHaByS2zw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240514075728epcas5p3c089ac80a41cadc715105eb9918be4f7~PS_k7Biw11959419594epcas5p3M;
	Tue, 14 May 2024 07:57:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vdpc624ytz4x9QF; Tue, 14 May
	2024 07:57:26 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	53.7E.09666.66913466; Tue, 14 May 2024 16:57:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240514075457epcas5p10f02f1746f957df91353724ec859664f~PS8YdLRbi2658726587epcas5p1v;
	Tue, 14 May 2024 07:54:57 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514075457epsmtrp1c0a35af7cd0ac40b6171404cf6b7e852~PS8YcZ3wx0538105381epsmtrp1D;
	Tue, 14 May 2024 07:54:57 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-b5-664319666521
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	61.D2.08390.1D813466; Tue, 14 May 2024 16:54:57 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075456epsmtip2012dda6b7119e958e40e1700be8db43f~PS8XYIV0j0412004120epsmtip2R;
	Tue, 14 May 2024 07:54:56 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v4 1/4] io_uring/rsrc: add hugepage buffer coalesce helpers
Date: Tue, 14 May 2024 15:54:41 +0800
Message-Id: <20240514075444.590910-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514075444.590910-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmlm6apHOawZPZPBZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsa86TtYC47KVVxdeY21gfGYRBcjJ4eEgInE6S0TmUFsIYHdjBJT
	Ztd2MXIB2Z8YJR48ucYG4XxjlPj27z07TMeH05NYIRJ7GSX+/F/KDuH8YpTY8PgbE0gVm4CO
	xO8Vv1hAbBEBbYnXj6eC2cwCuxglFp6TArGFBbwl5k+6wQZiswioSpz+dAhsA6+ArcTf7sVM
	ENvkJfYfPAt0HwcHp4CdxKkZLhAlghInZz6BGikv0bx1NjPIDRICP9klplw+BHWpi0Rz7x82
	CFtY4tXxLVBxKYmX/W3sIDMlBIollq2Tg+htYZR4/24OI0SNtcS/K3tYQGqYBTQl1u/ShwjL
	Skw9tY4JYi+fRO/vJ1Bn8krsmAdjq0pcOLgNapW0xNoJW5khbA+Jn/vvsEDCaiKjxL+Tz5kn
	MCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arFpgWFeajk8kpPzczcxgpOplucOxrsPPugdYmTi
	YDzEKMHBrCTC61BonybEm5JYWZValB9fVJqTWnyI0RQY3hOZpUST84HpPK8k3tDE0sDEzMzM
	xNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBibHmzeKjgecfHcgyOmMpfMME/UzK3cq
	sfX2/2+9lZFRdHXe42kCG30u/yxOvBc/67nWg1XXS7qLhbQ6limuzZtxPvTVjbfKEwM/Srzf
	2/Y0/XqxT8YHLh/J+SmT2G8mJbFN+sZm/q/z5BHNlwc3vF3FWHr9QNoq28MVRsleZXeuP3s5
	7WiCz5Nf9050MgRtu8tw1tj546313bkRddfNV/yW+H0r65jjD//UYj7nKUzNLmVOC/wPfLkm
	fnMql/HnfXefXbC95+WSeSw3dlb+5C3PAhcs1lQr3DHFiPHPSvc7eVuXz1rBYCPO8OjqM1HT
	9OebjMWW5x+5qnZ+n/6VLUc2TZPy4BdpPzQpYXe+T/uyy0osxRmJhlrMRcWJAMQobpEvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO5FCec0g2sveSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxrzpO1gLjspVXF15jbWB8ZhEFyMnh4SA
	icSH05NYQWwhgd2MEs0ThSHi0hIdh1rZIWxhiZX/ngPZXEA1PxglJrz5xgySYBPQkfi94hdL
	FyMHh4iArkTjXQWQGmaBQ0BzNjQzgtQIC3hLzJ90gw3EZhFQlTj96RDYUF4BW4m/3YuZIBbI
	S+w/eJYZZA6ngJ3EqRkuEPfYSmz+cxyqXFDi5MwnLCA2M1B589bZzBMYBWYhSc1CklrAyLSK
	UTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM42LW0djDuWfVB7xAjEwcj0M0czEoivA6F
	9mlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0REkhPLEnNTk0tSC2CyTJxcEo1MCk8P7vZ
	R7k25fPbzUdkZdQX8au/LFsykXv7J9ONgbKHrnw9Ok897r3EzROhj2PUhT1v+TR3OEQy+T48
	y3BJemVzl/IVnfoaU2ZdrTv1nOxSjnfl1n/976B6KZHv547m8/MEGF3ef2pd8cJdsONE/430
	hIInzz5uNJrS5hd/9KTk0y+vfpVE9OzivJTxMdv63PWLbhcXLg3SvxVf1yS6V8HlpNVuxR2T
	RTSkuLu2RS368dZrUdKXLzWbxXMXqj+Rb3tslu7L/kPtdNemwhseM5jFFr4pvinxp9v73C65
	lrhnWuJvn+5/uVTikdmlo6JCASYurbvqqpkMQyRCJBaq1zdcPqDeritc78vw4mFJlRJLcUai
	oRZzUXEiAOh6ta3lAgAA
X-CMS-MailID: 20240514075457epcas5p10f02f1746f957df91353724ec859664f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514075457epcas5p10f02f1746f957df91353724ec859664f
References: <20240514075444.590910-1-cliang01.li@samsung.com>
	<CGME20240514075457epcas5p10f02f1746f957df91353724ec859664f@epcas5p1.samsung.com>

Introduce helper functions to check whether a buffer can
be coalesced or not, and gather folio data for later use.

The coalescing optimizes time and space consumption caused
by mapping and storing multi-hugepage fixed buffers.

A coalescable multi-hugepage buffer should fully cover its folios
(except potentially the first and last one), and these folios should
have the same size. These requirements are for easier later process,
also we need same size'd chunks in io_import_fixed for fast iov_iter
adjust.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h | 10 +++++++
 2 files changed, 88 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 65417c9553b1..d08224c0c5b0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
+					 struct io_imu_folio_data *data)
+{
+	struct folio *folio = page_folio(pages[0]);
+	unsigned int count = 1;
+	int i;
+
+	data->nr_pages_mid = folio_nr_pages(folio);
+	if (data->nr_pages_mid == 1)
+		return false;
+
+	data->folio_shift = folio_shift(folio);
+	data->folio_size = folio_size(folio);
+	data->nr_folios = 1;
+	/*
+	 * Check if pages are contiguous inside a folio, and all folios have
+	 * the same page count except for the head and tail.
+	 */
+	for (i = 1; i < nr_pages; i++) {
+		if (page_folio(pages[i]) == folio &&
+			pages[i] == pages[i-1] + 1) {
+			count++;
+			continue;
+		}
+
+		if (data->nr_folios == 1)
+			data->nr_pages_head = count;
+		else if (count != data->nr_pages_mid)
+			return false;
+
+		folio = page_folio(pages[i]);
+		if (folio_size(folio) != data->folio_size)
+			return false;
+
+		count = 1;
+		data->nr_folios++;
+	}
+	if (data->nr_folios == 1)
+		data->nr_pages_head = count;
+
+	return true;
+}
+
+static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
+				       struct io_imu_folio_data *data)
+{
+	int i, j;
+
+	if (nr_pages <= 1 ||
+		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
+		return false;
+
+	/*
+	 * The pages are bound to the folio, it doesn't
+	 * actually unpin them but drops all but one reference,
+	 * which is usually put down by io_buffer_unmap().
+	 * Note, needs a better helper.
+	 */
+	if (data->nr_pages_head > 1)
+		unpin_user_pages(&pages[1], data->nr_pages_head - 1);
+
+	j = data->nr_pages_head;
+	nr_pages -= data->nr_pages_head;
+	for (i = 1; i < data->nr_folios; i++) {
+		unsigned int nr_unpin;
+
+		nr_unpin = min_t(unsigned int, nr_pages - 1,
+					data->nr_pages_mid - 1);
+		if (nr_unpin == 0)
+			break;
+		unpin_user_pages(&pages[j+1], nr_unpin);
+		j += data->nr_pages_mid;
+		nr_pages -= data->nr_pages_mid;
+	}
+
+	return true;
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..b2a9d66b76dd 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,6 +50,16 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_data {
+	/* Head folio can be partially included in the fixed buf */
+	unsigned int	nr_pages_head;
+	/* For non-head/tail folios, has to be fully included */
+	unsigned int	nr_pages_mid;
+	unsigned int	nr_folios;
+	unsigned int	folio_shift;
+	size_t		folio_size;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1



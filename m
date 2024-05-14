Return-Path: <io-uring+bounces-1901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEE38C4D5B
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 09:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57AC01F216CD
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF3B17BA6;
	Tue, 14 May 2024 07:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="plwAyrfs"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F917573
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673334; cv=none; b=BDQusGr7Ygf0nRiHVSvkbPif3lodm+64KQpBNGXq0dd/lBwHcJNx7PpbfHuYL0dfUs7TKoVRoyQGNiG7cgPG+iolN9CXfpEXyET73uCtKtBniagMaa2RNt7D4O0Zb0xrYj3dxT3S5CCTQYmMRnhkiuLEmqFvzUOc7Q8xidnf/Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673334; c=relaxed/simple;
	bh=L04S/T0HduAOk5jic8D4zPDYPUsOlWlq6z5J2Sfh0tI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EekQ/2+EpluMUMo3nzrTODW92Yk2UhgQ73WvzfGW8/GbldljthS5AQHn7Q+7oACJTYCBsjMt0J/o0PTwEwZfxIgRvLdoJZATFY5EsCOCETI3WosG/S5RV12dBDk61l/zrKrMqE0dDLaB0wI2shhMoUnKhS2c3psMt0CnvpT4osg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=plwAyrfs; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240514075528epoutp047337c9e057c5977de4488060663a1514~PS815ssjR0538505385epoutp04v
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240514075528epoutp047337c9e057c5977de4488060663a1514~PS815ssjR0538505385epoutp04v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673328;
	bh=oXAeKS3l9SfB9JAX17XgdEuqjbyD8WlhE++s0l1R6lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plwAyrfsKEEDwwJJ6JSbiVTUi/3oKlCf1RzVFIFqnJftTpWZhy/7uVEC4pz9ovXlQ
	 gTbjJctXTsTc7/q786WvplQLV8VybHeK3PUQ37Itn8T/4kHGooMBi2jRgZjwiq0aZt
	 U15MRoNp6dKLXKTPYFO3gkYW0qx7mP9x3oC9G8qg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240514075528epcas5p24d2be71090b67c4a5e9fb751d6e09afd~PS81eAVwv0343203432epcas5p2q;
	Tue, 14 May 2024 07:55:28 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VdpYp5LMfz4x9Q5; Tue, 14 May
	2024 07:55:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.89.08600.EE813466; Tue, 14 May 2024 16:55:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240514075500epcas5p1e638b1ae84727b3669ff6b780cd1cb23~PS8buNdDm3182431824epcas5p1U;
	Tue, 14 May 2024 07:55:00 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514075500epsmtrp16c874b7d5d0c1bce4dd02e1fc2ff1120~PS8bs6F5c0539705397epsmtrp1P;
	Tue, 14 May 2024 07:55:00 +0000 (GMT)
X-AuditID: b6c32a44-6c3ff70000002198-7d-664318ee5c16
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.98.09238.4D813466; Tue, 14 May 2024 16:55:00 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075459epsmtip2ec94584c30746edf7a971605fabf9618~PS8arXGLb0428404284epsmtip2G;
	Tue, 14 May 2024 07:54:59 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v4 3/4] io_uring/rsrc: add init and account functions for
 coalesced imus
Date: Tue, 14 May 2024 15:54:43 +0800
Message-Id: <20240514075444.590910-4-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514075444.590910-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmuu47Cec0gwddWhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsbphwvYCp5LVaz9spG9gXGOaBcjJ4eEgIlE4+d9zF2MXBxCArsZ
	Je5Om8cG4XxilNg8/wYThPONUWLdrh9sMC1rT85kgUjsZZS4PG0NK0hCSOAXo8SU7UwgNpuA
	jsTvFb9YQGwRAW2J14+ngtnMArsYJRaekwKxhQWiJPbc3snexcjBwSKgKjHtKB9ImFfAVuLM
	iwlMELvkJfYfPMsMUsIpYCdxaoYLRImgxMmZT6Amyks0b50N9oGEwF92iYs/XjJD9LpIzPk/
	hxXCFpZ4dXwLO4QtJfGyvw1srYRAscSydXIQvS2MEu/fzWGEqLGW+HdlDwtIDbOApsT6XfoQ
	YVmJqafWMUHs5ZPo/f0E6kxeiR3zYGxViQsHt0GtkpZYO2Er1DkeEl39jayQYJsIDLYV15gm
	MCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arJpgWFeajk8jpPzczcxglOplssOxhvz/+kdYmTi
	YDzEKMHBrCTC61BonybEm5JYWZValB9fVJqTWnyI0RQY3BOZpUST84HJPK8k3tDE0sDEzMzM
	xNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBqbcZRvDNBjt3hm/m9xw5JnLknSnq9fY
	vjFfjSmvM1eYx9p6LHPmDz6rldN7SqqFDG2WqKmcLlX2P3Aj8Tf3Z49nJssmfuNMDYjcO89E
	UOAX//NjZ8P8P5pzbO5ok9xdpLv81F9TzYSZmdJXGPn4VsQ/UL35f/J/Ju3vj3/0SwmyLM9l
	Pfbs+fE1D+1zv/3+bsf+7kf4Rd7wIxqJ3HPa1u+eq1invZ7n/oob6dNi4xkrjd40z7DOCf20
	2q1U7Un81pWi3NVsn7gddlr9b2Npf9KxzeVe7z4Xz5M3gqcHBU5d8bJJxKp97aWTXZN2hHwV
	/rfpinvALu4n6jPjtCsM657MLZjhKfFtXqVcWwnHFGclluKMREMt5qLiRABOqAyuLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSvO4VCec0gx0T9CyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxumHC9gKnktVrP2ykb2BcY5oFyMnh4SA
	icTakzNZuhi5OIQEdjNKXHl2gx0iIS3RcagVyhaWWPnvOZgtJPCDUeL2bX8Qm01AR+L3il9A
	zRwcIgK6Eo13FUDmMAscYpRo3tDMCFIjLBAh8eD3KkaQGhYBVYlpR/lAwrwCthJnXkxgghgv
	L7H/4FlmkBJOATuJUzNcIDbZSmz+c5wdolxQ4uTMJywgNjNQefPW2cwTGAVmIUnNQpJawMi0
	ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjONS1NHYw3pv/T+8QIxMHI9DJHMxKIrwO
	hfZpQrwpiZVVqUX58UWlOanFhxilOViUxHkNZ8xOERJITyxJzU5NLUgtgskycXBKNTA92rUy
	v36dZkDrd7lX/C9PTH4nJnnjhYFmMmO0L0shs5fitJvth15Wcnc1HXmYfWl+1+nyY4s9o3uf
	xz2/YLSrgV9u28bwVZ8+mLZ2M4f61PbNE7U/X/Zje9uxjCkiatM4TV4Jy1ltiOV7wnXs+xcR
	r88Cfm1ykWd3sL5Yc+j8lD125WLPph1eb7F4K5tubvLZv0YJh0Xm8zSd+2a5eUWeW9HE9IAj
	/p7rTexTFPdv/eRlcH7XvxfboozyGyYVmBkrvOV4YFckcve+JuuzP1dFuXIbmKLapr/gztaI
	WCvNoJaWcXrO5uJbq/etbtna2lFU3ZtR+XH5xI1b0ycuWH5X9cu8t4tj1JbX7KyvebBeiaU4
	I9FQi7moOBEAn+UGu+QCAAA=
X-CMS-MailID: 20240514075500epcas5p1e638b1ae84727b3669ff6b780cd1cb23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514075500epcas5p1e638b1ae84727b3669ff6b780cd1cb23
References: <20240514075444.590910-1-cliang01.li@samsung.com>
	<CGME20240514075500epcas5p1e638b1ae84727b3669ff6b780cd1cb23@epcas5p1.samsung.com>

Introduce two functions to separate the coalesced imu alloc and
accounting path from the original one. This helps to keep the original
code path clean.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 578d382ca9bc..53fac5f27bbf 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -871,6 +871,45 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
+		if (i)
+			j += data->nr_pages_mid;
+		else
+			j = data->nr_pages_head;
+	}
+
+	if (!imu->acct_pages)
+		return 0;
+
+	ret = io_account_mem(ctx, imu->acct_pages);
+	if (!ret)
+		return 0;
+	imu->acct_pages = 0;
+	return ret;
+}
+
 static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
 					 struct io_imu_folio_data *data)
 {
@@ -949,6 +988,56 @@ static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
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
+		unpin_user_page(pages[0]);
+		j = data->nr_pages_head;
+		for (i = 1; i < data->nr_folios; i++) {
+			unpin_user_page(pages[j]);
+			j += data->nr_pages_mid;
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



Return-Path: <io-uring+bounces-27-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709F77E19B6
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 06:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34980B20CD5
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 05:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65156946B;
	Mon,  6 Nov 2023 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lGU/Jfru"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D29463
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 05:48:15 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F456CC
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 21:48:13 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231106054808epoutp03e2794f975d41439da983851d9c54b668~U8pa9VVsr0686406864epoutp03o
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 05:48:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231106054808epoutp03e2794f975d41439da983851d9c54b668~U8pa9VVsr0686406864epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699249688;
	bh=G1I5/h3as3Zgjflvnpl7j5kSS4UnoRuSL1e3zT94Rxg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=lGU/JfruwXZWr0czeO3cIW1o8LajTzFGJfjn4BtYaJeylHgGEqvAcSaQFMijo5qg3
	 uNCmARdCpWxXv5n+Gqb+V9dRjz65oIfPeJYNDf/nihfcZt7R9Uwm53B7RZCRnSYaFQ
	 ivKluNEyoZEmE19t5yXgMSN/gEmvfqRegRur3SdY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231106054808epcas5p361f1803c6f6460da849c5b02cc9391fb~U8pawaNtr2040220402epcas5p39;
	Mon,  6 Nov 2023 05:48:08 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4SP0kZ4SyVz4x9Q1; Mon,  6 Nov
	2023 05:48:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	27.C9.08567.61E78456; Mon,  6 Nov 2023 14:48:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231106054805epcas5p23a2d645e7da22902172c9bb03c614d7c~U8pYUh1Ap3040530405epcas5p2u;
	Mon,  6 Nov 2023 05:48:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231106054805epsmtrp2c5aa10fe72b5c2a3b8b94de1cda4f926~U8pYTED221488914889epsmtrp2g;
	Mon,  6 Nov 2023 05:48:05 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-f2-65487e162391
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E5.67.08755.51E78456; Mon,  6 Nov 2023 14:48:05 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231106054804epsmtip1b3c3f71a9af090653eea195ad91e6d49~U8pXEHGQ_1185011850epsmtip1U;
	Mon,  6 Nov 2023 05:48:04 +0000 (GMT)
Message-ID: <40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>
Date: Mon, 6 Nov 2023 11:18:03 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, Keith Busch
	<kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20231027181929.2589937-2-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmhq5YnUeqwcdfihar7/azWaxcfZTJ
	4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyYHD4/LZUo9NqzrZPDYvqffYfbOBzePc
	xQqPj09vsXh83iQXwB6VbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
	q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9d
	Ly+1xMrQwMDIFKgwITtj3jHDgna+ivktvxgbGN9ydTFyckgImEhMmbmODcQWEtjNKHHjdkQX
	IxeQ/YlRYtrNE6wQzjdGiYdzzjLCdJxavgUqsZdR4tHrD0wQzltGia/7ljKDVPEK2EmsvL6Y
	BcRmEVCRuP9pJitEXFDi5MwnYHFRgSSJX1fngE0VFvCSuN34HayGWUBc4taT+UwgtohAlUTf
	tJ9sEPE4iaVHZgDN5+BgE9CUuDC5FCTMKWAu8eP0DqgSeYntb+cwQxw6lUNi+tkKCNtF4sXU
	Y2wQtrDEq+Nb2CFsKYnP7/ZCxZMlLs08xwRhl0g83nMQyraXaD3VD7aWGWjt+l36EKv4JHp/
	P2ECCUsI8Ep0tAlBVCtK3Jv0lBXCFpd4OGMJlO0h8fjhVTZISG1nlOg4PY15AqPCLKRAmYXk
	+VlIvpmFsHkBI8sqRsnUguLc9NRk0wLDvNRyeGwn5+duYgSnVi2XHYw35v/TO8TIxMF4iFGC
	g1lJhPevvUeqEG9KYmVValF+fFFpTmrxIUZTYOxMZJYSTc4HJve8knhDE0sDEzMzMxNLYzND
	JXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYinqfJW7P3xCu0az6KKVdRCZA6SfX+Sni7Rea
	gt1tfrEt3mI5Zc/9ny4ma4vCL4ZUt7CYhWty627uf1A2T01qb8ZPce6fS7RT7mnJCEnqvHXV
	6uHcbDIncfVij7zf4tcOCyd+/Pao/9DLGMOdbCtf3BBNktX/K1O7pfOAzCvlHO0jcuUX81tX
	28yp0BITiH/zb981pUSNnQbazRFrem0+e01/qHXW0EYgjlv8kOvFv9FSNrk6if+O1PYq3GOZ
	y5Jwb+vaP44fHPaw7dzOtoA9kWGx0sZQ32VO7+cYMBbcj/+ZkOFWfzX0SUb1r/Zlm4Trj4k+
	M9rcdGWi0voX72zD/dRO773/RKJOPeRk8EYlluKMREMt5qLiRABkHF+lNgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42LZdlhJTle0ziPV4O4qXYvVd/vZLFauPspk
	8a71HIvFpEPXGC3OXF3IYrH3lrbF/GVP2S2WH//H5MDhcflsqcemVZ1sHpuX1HvsvtnA5nHu
	YoXHx6e3WDw+b5ILYI/isklJzcksSy3St0vgyph3zLCgna9ifssvxgbGt1xdjJwcEgImEqeW
	b2EFsYUEdjNKzP1WBhEXl2i+9oMdwhaWWPnvOZDNBVTzmlHi8N5DjCAJXgE7iZXXF7OA2CwC
	KhL3P81khYgLSpyc+QQsLiqQJLHnfiMTiC0s4CVxu/E7WA0z0IJbT+aDxUUEqiT2/zjLBBGP
	k/h/CaQeZNl2RollF04AORwcbAKaEhcml4LUcAqYS/w4vYMNot5MomtrFyOELS+x/e0c5gmM
	QrOQnDELybpZSFpmIWlZwMiyilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOJK0NHcw
	bl/1Qe8QIxMH4yFGCQ5mJRHev/YeqUK8KYmVValF+fFFpTmpxYcYpTlYlMR5xV/0pggJpCeW
	pGanphakFsFkmTg4pRqYFNbeO/hJ+PY7FSd+VmfLxkOLUxqXrbj6Of6XUfe806fbPLw9SxQO
	l6SpPDn16GZoxgez3242m6f2fzn+4WqgF6/Dgan3ji9262xouhfjFJE8QyMgINjUU2lG5K6N
	W7p8DNreR+fFys52D9j77ttyE/NtKpclOQw/yfV3GIg9ZVSZvGK5vufFu6lbHdW21xkVBtzq
	bl46zbpq+975pe2mZ39MXrmlPHehyrG+t18eq03yMGBRfqQgH9FkI7g2dGeO++NrBncvMBqw
	vnl+LdLyX8DFm+auOTeY5XboGL7IP3Czea3kyo03uDezujVmhR10mLkj2OyC14a55yI2l4c8
	9QwPeJweEaFyK3657GMhJZbijERDLeai4kQA+bf61xMDAAA=
X-CMS-MailID: 20231106054805epcas5p23a2d645e7da22902172c9bb03c614d7c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6
References: <20231027181929.2589937-1-kbusch@meta.com>
	<CGME20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6@epcas5p3.samsung.com>
	<20231027181929.2589937-2-kbusch@meta.com>

On 10/27/2023 11:49 PM, Keith Busch wrote:
> +int bio_integrity_map_user(struct bio *bio, void __user *ubuf, unsigned int len,
> +			   u32 seed)
> +{
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +	unsigned long offs, align = q->dma_pad_mask | queue_dma_alignment(q);
> +	int ret, direction, nr_vecs, i, j, folios = 0;
> +	struct bio_vec stack_vec[UIO_FASTIOV];
> +	struct bio_vec bv, *bvec = stack_vec;
> +	struct page *stack_pages[UIO_FASTIOV];
> +	struct page **pages = stack_pages;
> +	struct bio_integrity_payload *bip;
> +	struct iov_iter iter;
> +	struct bvec_iter bi;
> +	u32 bytes;
> +
> +	if (bio_integrity(bio))
> +		return -EINVAL;
> +	if (len >> SECTOR_SHIFT > queue_max_hw_sectors(q))
> +		return -E2BIG;
> +
> +	if (bio_data_dir(bio) == READ)
> +		direction = ITER_DEST;
> +	else
> +		direction = ITER_SOURCE;
> +
> +	iov_iter_ubuf(&iter, direction, ubuf, len);
> +	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
> +	if (nr_vecs > BIO_MAX_VECS)
> +		return -E2BIG;
> +	if (nr_vecs > UIO_FASTIOV) {
> +		bvec = kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
> +		if (!bvec)
> +			return -ENOMEM;
> +		pages = NULL;
> +	}
> +
> +	bytes = iov_iter_extract_pages(&iter, &pages, len, nr_vecs, 0, &offs);
> +	if (unlikely(bytes < 0)) {
> +		ret =  bytes;
> +		goto free_bvec;
> +	}
> +
> +	for (i = 0; i < nr_vecs; i = j) {
> +		size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
> +		struct folio *folio = page_folio(pages[i]);
> +
> +		bytes -= size;
> +		for (j = i + 1; j < nr_vecs; j++) {
> +			size_t next = min_t(size_t, PAGE_SIZE, bytes);
> +
> +			if (page_folio(pages[j]) != folio ||
> +			    pages[j] != pages[j - 1] + 1)
> +				break;
> +			unpin_user_page(pages[j]);

Is this unpin correct here?


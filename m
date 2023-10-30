Return-Path: <io-uring+bounces-10-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2927DC17F
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 22:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCD3A1C20AC3
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 21:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329E51A730;
	Mon, 30 Oct 2023 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gR12XQmD"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCBA1A70F
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 21:03:00 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF45F9
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 14:02:58 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231030210254epoutp01d8424f777df417daecfb90a447b2746a~S-nHCZelE2385923859epoutp011
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 21:02:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231030210254epoutp01d8424f777df417daecfb90a447b2746a~S-nHCZelE2385923859epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1698699774;
	bh=8eCXBZsJBL9I/lOGkGe8XqFHXC8BSImI/VO6wmHTQBY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=gR12XQmD3gk+eMehtYEZ5sK43toqI8QwiQStiYbbWp/ghhfdGcuOHqT1quu/iHNei
	 4c/Xc+iUpmrQ7aRE8fL5oI3Ja1VFMoHykkBSDbzuCrHj5Dyzt239mfwYCSXV/EBQmO
	 9x/S8vHYxibvAnpwE13/M7zZ3vWU+Jf8N9ZTBj6g=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231030210253epcas5p1bd3269f4c24ca0d33a8074072c1e1242~S-nGubahH2211122111epcas5p1c;
	Mon, 30 Oct 2023 21:02:53 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4SK5MH6qYTz4x9Ps; Mon, 30 Oct
	2023 21:02:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	79.58.09672.BF910456; Tue, 31 Oct 2023 06:02:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231030210251epcas5p2bcf20c995a255486b31b6f629d921114~S-nEtKBK61658216582epcas5p22;
	Mon, 30 Oct 2023 21:02:51 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231030210251epsmtrp1ee74188dc1ae9b9f77d4aa2d890994b4~S-nEseWf30804108041epsmtrp18;
	Mon, 30 Oct 2023 21:02:51 +0000 (GMT)
X-AuditID: b6c32a4b-60bfd700000025c8-0e-654019fbeefb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	84.2F.07368.BF910456; Tue, 31 Oct 2023 06:02:51 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231030210249epsmtip20c158f4820578006aaf2a7c8f7b4e651~S-nC40Or_2706627066epsmtip20;
	Mon, 30 Oct 2023 21:02:49 +0000 (GMT)
Message-ID: <c3a946f4-b2f8-c800-1573-1f87c9d637d7@samsung.com>
Date: Tue, 31 Oct 2023 02:32:48 +0530
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmuu5vSYdUg9/PjSxW3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfkwOHx+WzpR6bVnWyeWxeUu+x+2YDm8e5
	ixUeH5/eYvH4vEkugD0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66
	Xl5qiZWhgYGRKVBhQnbG9219LAWXVCu2bN3C2sB4RLaLkZNDQsBEYvXcVtYuRi4OIYHdjBIn
	pq1lg3A+MUosv3EZKvONUWLC2svsMC2tN5sYIRJ7GSXOztwFVfWWUeLu9nbmLkYODl4BO4kj
	L3NATBYBVYm/TaIgvbwCghInZz5hAbFFBZIkfl2dwwhiCwt4Sdxu/M4KYjMLiEvcejKfCcQW
	EaiS6Jv2kw0iHiex9MgMsOlsApoSFyaXgoQ5BcwlfpzeAVUiL7H97RxmkGskBGZySHQ++sEE
	cbOLxKzDq6DuF5Z4dXwLlC0l8bK/DcpOlrg08xxUfYnE4z0HoWx7idZT/WB7mYH2rt+lD7GL
	T6L39xMmkLCEAK9ER5sQRLWixL1JT1khbHGJhzOWQNkeEq933IKG2nZGia9X3rBOYFSYhRQq
	s5B8PwvJO7MQNi9gZFnFKJlaUJybnlpsWmCcl1oOj+7k/NxNjODkquW9g/HRgw96hxiZOBgP
	MUpwMCuJ8DI72qQK8aYkVlalFuXHF5XmpBYfYjQFxs5EZinR5Hxges8riTc0sTQwMTMzM7E0
	NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoGpJb7AKrzL567w49fVqhPe3LsQ5PvneUSJ
	YfRk5j8lmXnWZzr/XKk5YCBXX6Iau9jXS/zfvErV0izbwywvRW3urS3f9bxvs+YJ997+nkUO
	tTXZZUt7K7ZfUExRfvTA1ePE3hsunzN+RHcv+bTkXWuPpPwv3Z+ZC5wjJu89tyYpKvfd6v0S
	93Qkq8PsNxyKu9Zj1x/EsGvSK4Wpz3kKkt+9/m78j8//UMqyOqnjs+1eclj8X3rzzcW1rz0u
	b9C/HpBz4Ze2aWRvYZmJvNmimII+1mgjxaMPPl8JLtnoUt4c9tn7Kl+mam6t6a2Lrz+VX3Yo
	T9i+JfjdfZOeKT1pizUN7ar3eKTVSh66OVuSx1qJpTgj0VCLuag4EQDPIm41NwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSvO5vSYdUgy/nJC1W3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfkwOHx+WzpR6bVnWyeWxeUu+x+2YDm8e5
	ixUeH5/eYvH4vEkugD2KyyYlNSezLLVI3y6BK+P7tj6WgkuqFVu2bmFtYDwi28XIySEhYCLR
	erOJsYuRi0NIYDejxPtNbSwQCXGJ5ms/2CFsYYmV/56D2UICrxklelrquhg5OHgF7CSOvMwB
	MVkEVCX+NomCVPAKCEqcnPkEbIqoQJLEnvuNTCC2sICXxO3G76wgNjPQ9FtP5oPFRQSqJPb/
	OMsEEY+T+H8JpB7knO2MEjvvLWMEmc8moClxYXIpSA2ngLnEj9M72CDqzSS6tnYxQtjyEtvf
	zmGewCg0C8kZs5Csm4WkZRaSlgWMLKsYJVMLinPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYLj
	SEtjB+O9+f/0DjEycTAeYpTgYFYS4WV2tEkV4k1JrKxKLcqPLyrNSS0+xCjNwaIkzms4Y3aK
	kEB6YklqdmpqQWoRTJaJg1OqgSkt/dBrw9Wtut+En83oUdz63eCRVgHXu68sZZ+bLKxYt0zx
	LTg/W/Xm5nT2tUX3GBy25rVuberZLbxGW8K0RmBRT4SSxUa3c5NUbWJ9HHYX/G7brp8QGiSu
	0uAsFXlQ/1JD6HunuYtyah6uLag3WqnvZ19sEv/m/cpNPfYx6TIic00dmwTWCdw7z3XVuC3f
	/etXH1Wn4LMSl9k13ieH3JOVv9Omz/rO+QPTZPkFBj7My/MDo7931TwX1t9mJyl6hrN53f/v
	kyftO/HqmM/HZyctWYqsleryIl6ItryaldKl8O/ouTXcswX2uCld/rbu7NyQFeHO35kkVq6c
	PWvqVH+7/E8TH1pm6/5O8HnipcRSnJFoqMVcVJwIAFbpAtwSAwAA
X-CMS-MailID: 20231030210251epcas5p2bcf20c995a255486b31b6f629d921114
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231027182017epcas5p1fb1f91bc876d9bc1b1229c012bcd1ea2
References: <20231027181929.2589937-1-kbusch@meta.com>
	<CGME20231027182017epcas5p1fb1f91bc876d9bc1b1229c012bcd1ea2@epcas5p1.samsung.com>
	<20231027181929.2589937-2-kbusch@meta.com>

On 10/27/2023 11:49 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Passthrough commands that utilize metadata currently need to bounce the
> user space buffer through the kernel. Add support for mapping user space
> directly so that we can avoid this costly overhead. This is similiar to
> how the normal bio data payload utilizes user addresses with
> bio_map_user_iov().
> 
> If the user address can't directly be used for reasons like too many
> segments or address unalignement, fallback to a copy of the user vec
> while keeping the user address pinned for the IO duration so that it
> can safely be copied on completion in any process context.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/bio-integrity.c | 195 ++++++++++++++++++++++++++++++++++++++++++
>   include/linux/bio.h   |   9 ++
>   2 files changed, 204 insertions(+)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index ec8ac8cf6e1b9..7f9d242ad79df 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -91,6 +91,37 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>   }
>   EXPORT_SYMBOL(bio_integrity_alloc);
>   
> +static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
> +{
> +	bool dirty = bio_data_dir(bip->bip_bio) == READ;
> +	struct bio_vec *copy = bip->copy_vec;
> +	struct bvec_iter iter;
> +	struct bio_vec bv;
> +
> +	if (copy) {
> +		unsigned short nr_vecs = bip->bip_max_vcnt;
> +		size_t bytes = bip->bip_iter.bi_size;
> +		void *buf = bvec_virt(bip->bip_vec);
> +
> +		if (dirty) {
> +			struct iov_iter iter;
> +
> +			iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
> +			WARN_ON(copy_to_iter(buf, bytes, &iter) != bytes);
> +		}
> +
> +		memcpy(bip->bip_vec, copy, nr_vecs * sizeof(*copy));
> +		kfree(copy);
> +		kfree(buf);
> +	}
> +
> +	bip_for_each_vec(bv, bip, iter) {
> +		if (dirty && !PageCompound(bv.bv_page))
> +			set_page_dirty_lock(bv.bv_page);
> +		unpin_user_page(bv.bv_page);
> +	}
> +}

Leak here, page-unpinning loop will not execute for the common (i.e., 
no-copy) case...


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
> +			size += next;
> +			bytes -= next;
> +		}
> +
> +		bvec_set_page(&bvec[folios], pages[i], size, offs);
> +		offs = 0;
> +		folios++;
> +	}
> +
> +	if (pages != stack_pages)
> +		kvfree(pages);
> +
> +	if (folios > queue_max_integrity_segments(q) ||
> +	    !iov_iter_is_aligned(&iter, align, align)) {
> +		ret = bio_integrity_copy_user(bio, bvec, folios, len,
> +					      direction, seed);
> +		if (ret)
> +			goto release_pages;
> +		return 0;
> +	}
> +
> +	bip = bio_integrity_alloc(bio, GFP_KERNEL, folios);
> +	if (IS_ERR(bip)) {
> +		ret = PTR_ERR(bip);
> +		goto release_pages;
> +	}
> +
> +	memcpy(bip->bip_vec, bvec, folios * sizeof(*bvec));

Because with this way of copying, bip->bip_iter.bi_size will remain zero.

Second, is it fine not to have those virt-alignment checks that are done 
by bvec_gap_to_prev() when the pages are added using 
bio_integrity_add_page()?


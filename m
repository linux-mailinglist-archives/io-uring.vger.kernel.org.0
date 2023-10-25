Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385957D6C64
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 14:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344203AbjJYMwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 08:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbjJYMwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 08:52:06 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEF186
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 05:52:03 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231025125200epoutp04f60bb26abce378daa0f1e4e1412b6d9b~RWsFLjdY43270132701epoutp04u
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 12:52:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231025125200epoutp04f60bb26abce378daa0f1e4e1412b6d9b~RWsFLjdY43270132701epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1698238320;
        bh=dTub3oTWudDlzEoogyV2V94bEWlOxJf5IsqYrHW8P8k=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=cuL41rWOQUBq0fyIryHwUzT7F9XiIXNPaIr9XYeQE7bdghxw45RVehDvW5Cwkzw1W
         pKoZsfsvfQh0QuEz2tBA4kYbcRLNOMgMic7cclsrcOsS7Na975YlaWNzBRMc8QBdjo
         +vK0Y5MGjIT+RSVg1zZ1Hz4RT556w9PPLyDk0i0M=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20231025125200epcas5p1407966a3e16db5924edb4fddd88501a6~RWsE2DKTx2164521645epcas5p1g;
        Wed, 25 Oct 2023 12:52:00 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4SFpjB3yNfz4x9Pt; Wed, 25 Oct
        2023 12:51:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.25.09672.E6F09356; Wed, 25 Oct 2023 21:51:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20231025125158epcas5p43e825130214ee03c4b05a6c8338919ab~RWsCyGcFc0535205352epcas5p4m;
        Wed, 25 Oct 2023 12:51:58 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20231025125158epsmtrp12b837ebea62430fa8ada3b3ba8468b42~RWsCxeSaA0709307093epsmtrp1h;
        Wed, 25 Oct 2023 12:51:58 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-66-65390f6e0482
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.A5.08817.D6F09356; Wed, 25 Oct 2023 21:51:58 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20231025125156epsmtip2734438c92e7b0c790825500ee7c11429~RWsBjO-SN2361023610epsmtip25;
        Wed, 25 Oct 2023 12:51:56 +0000 (GMT)
Message-ID: <1ca15dc4-6192-c557-2871-d2afbf19dd97@samsung.com>
Date:   Wed, 25 Oct 2023 18:21:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] block: bio-integrity: add support for user buffers
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
From:   Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20231018151843.3542335-2-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmlm4ev2WqwYKPshar7/azWaxcfZTJ
        4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyYHD4/LZUo9NqzrZPDYvqffYfbOBzePc
        xQqPj09vsXh83iQXwB6VbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
        q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9d
        Ly+1xMrQwMDIFKgwITujbc9P9oIn0hUbby1kb2BcKNbFyMkhIWAi0b/tFnMXIxeHkMBuRonW
        noVsEM4nRomnex5DZb4xSlw/+pARpmXKrTlMEIm9jBKrDp5lhHDeMkrc7VnMClLFK2AncX7e
        LDYQm0VAVeL86SUsEHFBiZMzn4DZogJJEr+uzgGbKizgLXHixXuwemYBcYlbT+YzgdgiAlUS
        fdN+QsXjJJYemQF0EgcHm4CmxIXJpSBhTgFzic6m18wQJfIS29/OAbtaQmAmh8T5S/+YIK52
        kdgzvYUdwhaWeHV8C5QtJfGyvw3KTpa4NPMcVH2JxOM9B6Fse4nWU/1ge5mB9q7fpQ+xi0+i
        9/cTJpCwhACvREebEES1osS9SU9ZIWxxiYczlkDZHhJfF66Dhtt2Rom2DXcYJzAqzEIKlVlI
        vp+F5J1ZCJsXMLKsYpRMLSjOTU8tNi0wzksth0d4cn7uJkZwgtXy3sH46MEHvUOMTByMhxgl
        OJiVRHgjfSxShXhTEiurUovy44tKc1KLDzGaAqNnIrOUaHI+MMXnlcQbmlgamJiZmZlYGpsZ
        Konzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAVHs3pmt+XHWDfpPNHrWPu22n3FaYUuqifDPk
        4R2NBV8ND51uvlF4/unpRe1G1SxHOrbtYPaT22djLqx0dUf50oIffVffup/2FGi+HrLl/+JP
        02Y+lZ+5Zonq7alFDQkPWnfoTbi25fV3lkMrpXcrz7N1fcl0aR2/Z4WG3UmPL2/WReQwL9m6
        8+/S9cs/qilnGYQfFDvLYXSLT15X4nzP9te7ujs+33WMOL7U85LonE/dzovqhXnKlQ9mP4jP
        aQgrPXB8A0eP7MFjjhLh14v+qX1Z9v/oT/NH2VHtYh9nF4ZEF51gZPyx+71lJYOG5zrPLwIC
        l18I37mjuFiqzXPTFZtOvp0WB9tYbyZcna37baISS3FGoqEWc1FxIgBVpw85OQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJXjeP3zLV4GEDk8Xqu/1sFitXH2Wy
        eNd6jsVi0qFrjBZnri5ksdh7S9ti/rKn7BbLj/9jcuDwuHy21GPTqk42j81L6j1232xg8zh3
        scLj49NbLB6fN8kFsEdx2aSk5mSWpRbp2yVwZbTt+cle8ES6YuOthewNjAvFuhg5OSQETCSm
        3JrD1MXIxSEksJtRYtfS/4wQCXGJ5ms/2CFsYYmV/56zQxS9ZpQ49rWBDSTBK2AncX7eLDCb
        RUBV4vzpJSwQcUGJkzOfgNmiAkkSe+43MoHYwgLeEidevAerZwZacOvJfLC4iECVxP4fZ5kg
        4nES/y81Ql20nVHi6ZUjzF2MHBxsApoSFyaXgtRwCphLdDa9ZoaoN5Po2trFCGHLS2x/O4d5
        AqPQLCRnzEKybhaSlllIWhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOJi2t
        HYx7Vn3QO8TIxMF4iFGCg1lJhDfSxyJViDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLp
        iSWp2ampBalFMFkmDk6pBiY1+/BDayYy3jFZPkHSWKIvUvfT1UtPcpNWr9T5umCt3N1vJ37u
        NTK7sEGZYWfs7P6uVYuuKta5fi9uc50vealks23IYwv+5Tvztv7/unX1xLv8ni7zQ4teS0ep
        /hfJ7n87ie2R44S+0D0yu07errO2YH+5XPLA3kq96Zx31ne+ZMvwnJPF+PjMAQ2Lq9cneDLl
        JehavL4n/znZctkUldU+3lINAk5Te37+Y9+r1TU9Q3X6rwUnfxZ+LeZ4u5lr9orsryFNPYUP
        ZmxZbPH8VfBityUJhytvsc47Z+NxZl2XRkHSrIc/2pZVcuwWTfCRknH3+7/Q+/v+5es3/l5y
        dYLs30npa6/euqPA5jAx7qbhaiWW4oxEQy3mouJEANPv4hMVAwAA
X-CMS-MailID: 20231025125158epcas5p43e825130214ee03c4b05a6c8338919ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231018152817epcas5p454a337b03087ccaf8935a022884b7cd2
References: <20231018151843.3542335-1-kbusch@meta.com>
        <CGME20231018152817epcas5p454a337b03087ccaf8935a022884b7cd2@epcas5p4.samsung.com>
        <20231018151843.3542335-2-kbusch@meta.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/2023 8:48 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> User space passthrough commands that utilize metadata currently need to
> bounce the "integrity" buffer through the kernel. This adds unnecessary
> overhead and memory pressure.
> 
> Add support for mapping user space directly so that we can avoid this
> costly copy. This is similiar to how the bio payload utilizes user
> addresses with bio_map_user_iov().
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/bio-integrity.c | 67 +++++++++++++++++++++++++++++++++++++++++++
>   include/linux/bio.h   |  8 ++++++
>   2 files changed, 75 insertions(+)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index ec8ac8cf6e1b9..08f70b837a29b 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -91,6 +91,19 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>   }
>   EXPORT_SYMBOL(bio_integrity_alloc);
>   
> +static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
> +{
> +	bool dirty = bio_data_dir(bip->bip_bio) == READ;
> +	struct bvec_iter iter;
> +	struct bio_vec bv;
> +
> +	bip_for_each_vec(bv, bip, iter) {
> +		if (dirty && !PageCompound(bv.bv_page))
> +			set_page_dirty_lock(bv.bv_page);
> +		unpin_user_page(bv.bv_page);
> +	}
> +}
> +
>   /**
>    * bio_integrity_free - Free bio integrity payload
>    * @bio:	bio containing bip to be freed
> @@ -105,6 +118,8 @@ void bio_integrity_free(struct bio *bio)
>   
>   	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
>   		kfree(bvec_virt(bip->bip_vec));
> +	else if (bip->bip_flags & BIP_INTEGRITY_USER)
> +		bio_integrity_unmap_user(bip);;
>   
>   	__bio_integrity_free(bs, bip);
>   	bio->bi_integrity = NULL;
> @@ -160,6 +175,58 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
>   }
>   EXPORT_SYMBOL(bio_integrity_add_page);
>   
> +int bio_integrity_map_user(struct bio *bio, void __user *ubuf, unsigned int len,
> +			   u32 seed, u32 maxvecs)
> +{
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
> +	struct page *stack_pages[UIO_FASTIOV];
> +	size_t offset = offset_in_page(ubuf);
> +	unsigned long ptr = (uintptr_t)ubuf;
> +	struct page **pages = stack_pages;
> +	struct bio_integrity_payload *bip;
> +	int npages, ret, i;
> +
> +	if (bio_integrity(bio) || ptr & align || maxvecs > UIO_FASTIOV)
> +		return -EINVAL;
> +
> +	bip = bio_integrity_alloc(bio, GFP_KERNEL, maxvecs);
> +	if (IS_ERR(bip))
> +		return PTR_ERR(bip);
> +
> +	ret = pin_user_pages_fast(ptr, UIO_FASTIOV, FOLL_WRITE, pages);

Why not pass maxvecs here? If you pass UIO_FASTIOV, it will map those 
many pages here. And will result into a leak (missed unpin) eventually 
(see below).

> +	if (unlikely(ret < 0))
> +		goto free_bip;
> +
> +	npages = ret;
> +	for (i = 0; i < npages; i++) {
> +		u32 bytes = min_t(u32, len, PAGE_SIZE - offset);

Nit: bytes can be declared outside.

> +		ret = bio_integrity_add_page(bio, pages[i], bytes, offset);
> +		if (ret != bytes) {
> +			ret = -EINVAL;
> +			goto release_pages;
> +		}
> +		len -= ret;

Take the case of single '4KB + 8b' io.
This len will become 0 in the first iteration.
But the loop continues for UIO_FASTIOV iterations. It will add only one 
page into bio_integrity_add_page.

And that is what it will unpin during bio_integrity_unmap_user(). 
Remaining pages will continue to remain pinned.

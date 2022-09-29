Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0475EF4B3
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiI2Lup (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 07:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbiI2Luh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 07:50:37 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A76C1138C6
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 04:50:25 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220929115022epoutp02743d910ef398e881c0901c09ce550752~ZUnow5YbZ1225412254epoutp02U
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 11:50:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220929115022epoutp02743d910ef398e881c0901c09ce550752~ZUnow5YbZ1225412254epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664452222;
        bh=yHHXjVmhu53RZGGPnWZBzcVqhwjpaS+BAXVeiy8+0+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lDqhQqcazY3rQF6Zk+vSto7dzzqicZmNkcJ+OU2+m8qFGD7Q7SMJ94mHdw4Hw6RGN
         qdaDpvQRGlVKM0dmwRsuPhfr7U1hnPiW0mnQW31hz8Yg+XYDUHkx6Jja2qzmxSxrgb
         e7pU8L+Hv41aglc/LsQRZNGcXFFgbiao57f5j1cY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220929115021epcas5p19e75726e3869e29d6f58edc2798fce2e~ZUnodMAGh0434904349epcas5p1y;
        Thu, 29 Sep 2022 11:50:21 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdWrW1VpFz4x9Pw; Thu, 29 Sep
        2022 11:50:19 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.C8.56352.B7685336; Thu, 29 Sep 2022 20:50:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929114335epcas5p4a44f6ddcc03f1d2c34ff572f03c10bbc~ZUht1NjzU2654926549epcas5p4s;
        Thu, 29 Sep 2022 11:43:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929114335epsmtrp2af60e3493a4bff4a040978f78c5a0f80~ZUht0ctgh3195931959epsmtrp2F;
        Thu, 29 Sep 2022 11:43:35 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-56-6335867b221b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.41.14392.6E485336; Thu, 29 Sep 2022 20:43:34 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220929114333epsmtip2719ee0f47f827744f5b90c0feeee95a8~ZUhsfXyoP0890408904epsmtip2d;
        Thu, 29 Sep 2022 11:43:33 +0000 (GMT)
Date:   Thu, 29 Sep 2022 17:03:45 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 6/7] block: extend functionality to map
 bvec iterator
Message-ID: <20220929113345.GC27633@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220928174039.GD17153@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpm51m2mywaV5bBar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZzz+u52p4J9qxe/7XSwNjLtluxg5OSQETCQuHl3J1MXIxSEksJtR4uqvd+wQ
        zidGicaVR6Ey3xgl+pvOssO0vL/9kgnEFhLYyygx42osRNEzRokfP1ezgSRYBFQlXjReA2tg
        E1CXOPK8lRHEFhFQknj66iwjSAOzwB5GifXXN7OCJIQFIiQmTHvBAmLzCuhKbDk6jxHCFpQ4
        OfMJWJxTQEdizunNYAtEBZQlDmw7DnaehEAnh8SGezsZIc5zkXh37gELhC0s8er4FqizpSQ+
        v9vLBmGnS/y4/JQJwi6QaD62D6rXXqL1VD8ziM0skCFxfxJMvazE1FPrmCDifBK9v59A9fJK
        7JgHYytJtK+cA2VLSOw91wBle0jc3/kXGqg3GSXOHX3LNoFRfhaS52Yh2Qdh60gs2P0JyOYA
        sqUllv/jgDA1Jdbv0l/AyLqKUTK1oDg3PbXYtMA4L7UcHuXJ+bmbGMHJVct7B+OjBx/0DjEy
        cTAeYpTgYFYS4RUvME0W4k1JrKxKLcqPLyrNSS0+xGgKjK2JzFKiyfnA9J5XEm9oYmlgYmZm
        ZmJpbGaoJM67eIZWspBAemJJanZqakFqEUwfEwenVAPTnj0pAXITfizoPvrsUsDhljePqyrW
        3l7bk7XG3HzTHb6psxPeCq8vup6kdSvRVGmL4ZoHG575h1vtW5HFLZYfPVdljb5AoaDMpR7X
        Gvskv8IG6yp21qiNC+Y32Wio9zgf+63FvXfnD8XNSydcmSxj1NPXOOX0mnJfdn/3z4wvCq3W
        xL86r70/0kOp6bqBdtnO6VvZS1kCtDes9zpuuvj+dHH55QFp19oObDB7+r/xygHnFdGG2c/S
        pnidbEnMN3dXfXM6QTKXTemvqrh/HVP4R+EjTvt+/PsmXc32WKh+1o000/yco6dPz93tp7J9
        n/7fJcmmu4tcDlgHh0RM0l0mefSPMdMHl+d2S1TcHB8rsRRnJBpqMRcVJwIAFxxFKjcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvO7zFtNkg+5Qi9V3+9ksbh7YyWSx
        cvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOFx+Wypx6ZVnWwem5fUe+y+2cDm0bdl
        FaPH501yAWxRXDYpqTmZZalF+nYJXBkPri1hK9inXNGy9DtzA+MU6S5GTg4JAROJ97dfMnUx
        cnEICexmlHi19iUzREJC4tTLZYwQtrDEyn/P2SGKnjBKXHw9nw0kwSKgKvGi8Ro7iM0moC5x
        5HkrWIOIgJLE01dnGUEamAX2MEqsv76ZFSQhLBAh8ejsJiYQm1dAV2LL0XmMEFNvM0p8a9/G
        ApEQlDg58wmYzSygJXHjH8h9HEC2tMTyfxwgYU4BHYk5pzeDHSEqoCxxYNtxpgmMgrOQdM9C
        0j0LoXsBI/MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgmNDS3MG4fdUHvUOMTByM
        hxglOJiVRHjFC0yThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamASr+LyOBa60bzyxrmYcy656wRXv1yw6dv1jVtPpOa9/KBvLKx/6uk8jmQdo4Q7vHvP
        +HI/2tF+5kaXiHmIqsXyef53/lh0Caqsutl1auojd+GkHz+ZalUWXVo1O2LxCe33s46tnaEz
        ZXVK+qmjn77O6mHfN0vrfsT3ey1WMeIyRSWuT9Umf/piHHteJX3dwua0nMhDmQsOi9qzB28u
        iAop/KGnMSG6/e3jCa8rXPYrCZ2RunJ/KucGtai5n7hqfDtnxWwRsTrEPf+1Uh9btccPw8KQ
        R901HxSy3baWMKw8sT+yVCxlzZR5m53Z5/nss7vMfaS2Stttwf1sQZveCpms1B/MDPMDiv+e
        MNc2UbBQYinOSDTUYi4qTgQAoifgA/gCAAA=
X-CMS-MailID: 20220929114335epcas5p4a44f6ddcc03f1d2c34ff572f03c10bbc
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----vvYgYHrBmeYkJOpSn.dge_kBrYmc10ewv9PqSf1ctZwbMX08=_22f9b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac@epcas5p2.samsung.com>
        <20220927173610.7794-7-joshi.k@samsung.com> <20220928174039.GD17153@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------vvYgYHrBmeYkJOpSn.dge_kBrYmc10ewv9PqSf1ctZwbMX08=_22f9b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Sep 28, 2022 at 07:40:39PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 27, 2022 at 11:06:09PM +0530, Kanchan Joshi wrote:
> > Extend blk_rq_map_user_iov so that it can handle bvec iterator.
> > It  maps the pages from bvec iterator into a bio and place the bio into
> > request.
> > 
> > This helper will be used by nvme for uring-passthrough path when IO is
> > done using pre-mapped buffers.
> 
> Can we avoid duplicating some of the checks?  Something like the below
> incremental patch.  Note that this now also allows the copy path for
> all kinds of iov_iters, but as the copy from/to iter code is safe
> and the sanity check was just or the map path that should be fine.
> It's best split into a prep patch, though.

Right, this one looks way better. Will fold this in a separate prep patch.

> 
> ---
> diff --git a/block/blk-map.c b/block/blk-map.c
> index a1aa8dacb02bc..c51de30767403 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -549,26 +549,16 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
>  EXPORT_SYMBOL(blk_rq_append_bio);
>  
>  /* Prepare bio for passthrough IO given ITER_BVEC iter */
> -static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
> -				bool *copy)
> +static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
>  {
>  	struct request_queue *q = rq->q;
> -	size_t nr_iter, nr_segs, i;
> -	struct bio *bio = NULL;
> -	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
> +	size_t nr_iter = iov_iter_count(iter);
> +	size_t nr_segs = iter->nr_segs;
> +	struct bio_vec *bvecs, *bvprvp = NULL;
>  	struct queue_limits *lim = &q->limits;
>  	unsigned int nsegs = 0, bytes = 0;
> -	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
> -
> -	/* see if we need to copy pages due to any weird situation */
> -	if (blk_queue_may_bounce(q))
> -		goto out_copy;
> -	else if (iov_iter_alignment(iter) & align)
> -		goto out_copy;
> -	/* virt-alignment gap is checked anyway down, so avoid extra loop here */
> -
> -	nr_iter = iov_iter_count(iter);
> -	nr_segs = iter->nr_segs;
> +	struct bio *bio;
> +	size_t i;
>  
>  	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
>  		return -EINVAL;
> @@ -586,14 +576,15 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
>  	/* loop to perform a bunch of sanity checks */
>  	bvecs = (struct bio_vec *)iter->bvec;
>  	for (i = 0; i < nr_segs; i++) {
> -		bv = &bvecs[i];
> +		struct bio_vec *bv = &bvecs[i];
> +
>  		/*
>  		 * If the queue doesn't support SG gaps and adding this
>  		 * offset would create a gap, fallback to copy.
>  		 */
>  		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
>  			bio_map_put(bio);
> -			goto out_copy;
> +			return -EREMOTEIO;
>  		}
>  		/* check full condition */
>  		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
> @@ -611,9 +602,6 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
>  put_bio:
>  	bio_map_put(bio);
>  	return -EINVAL;
> -out_copy:
> -	*copy = true;
> -	return 0;
>  }
>  
>  /**
> @@ -635,33 +623,35 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
>  			struct rq_map_data *map_data,
>  			const struct iov_iter *iter, gfp_t gfp_mask)
>  {
> -	bool copy = false;
> +	bool copy = false, map_bvec = false;
>  	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
>  	struct bio *bio = NULL;
>  	struct iov_iter i;
>  	int ret = -EINVAL;
>  
> -	if (iov_iter_is_bvec(iter)) {
> -		ret = blk_rq_map_user_bvec(rq, iter, &copy);
> -		if (ret != 0)
> -			goto fail;
> -		if (copy)
> -			goto do_copy;
> -		return ret;
> -	}
> -	if (!iter_is_iovec(iter))
> -		goto fail;
> -
>  	if (map_data)
>  		copy = true;
>  	else if (blk_queue_may_bounce(q))
>  		copy = true;
>  	else if (iov_iter_alignment(iter) & align)
>  		copy = true;
> +	else if (iov_iter_is_bvec(iter))
> +		map_bvec = true;
> +	else if (!iter_is_iovec(iter))
> +		copy = true;
>  	else if (queue_virt_boundary(q))
>  		copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
>  
> -do_copy:
> +	if (map_bvec) {
> +		ret = blk_rq_map_user_bvec(rq, iter);
> +		if (!ret)
> +			return 0;
> +		if (ret != -EREMOTEIO)
> +			goto fail;
> +		/* fall back to copying the data on limits mismatches */
> +		copy = true;
> +	}
> +
>  	i = *iter;
>  	do {
>  		if (copy)
> 

--
Anuj Gupta


------vvYgYHrBmeYkJOpSn.dge_kBrYmc10ewv9PqSf1ctZwbMX08=_22f9b_
Content-Type: text/plain; charset="utf-8"


------vvYgYHrBmeYkJOpSn.dge_kBrYmc10ewv9PqSf1ctZwbMX08=_22f9b_--

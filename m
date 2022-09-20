Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858EB5BE537
	for <lists+io-uring@lfdr.de>; Tue, 20 Sep 2022 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiITMIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Sep 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiITMIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Sep 2022 08:08:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF1166110;
        Tue, 20 Sep 2022 05:08:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 03DBD68AA6; Tue, 20 Sep 2022 14:08:02 +0200 (CEST)
Date:   Tue, 20 Sep 2022 14:08:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220920120802.GC2809@lst.de>
References: <20220909102136.3020-1-joshi.k@samsung.com> <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com> <20220909102136.3020-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220909102136.3020-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> -static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>  		gfp_t gfp_mask)

bio_map_get is a very confusing name.  And I also still think this is
the wrong way to go.  If plain slab allocations don't use proper
per-cpu caches we have a MM problem and need to talk to the slab
maintainers and not use the overkill bio_set here.

> +/* Prepare bio for passthrough IO given an existing bvec iter */
> +int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)

I'm a little confused about the interface we're trying to present from
the block layer to the driver here.

blk_rq_map_user_iov really should be able to detect that it is called
on a bvec iter and just do the right thing rather than needing different
helpers.

> +		/*
> +		 * If the queue doesn't support SG gaps and adding this
> +		 * offset would create a gap, disallow it.
> +		 */
> +		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset))
> +			goto out_err;

So now you limit the input that is accepted?  That's not really how
iov_iters are used.   We can either try to reshuffle the bvecs, or
just fall back to the copy data version as blk_rq_map_user_iov does
for 'weird' iters˙

> +
> +		/* check full condition */
> +		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
> +			goto out_err;
> +
> +		if (bytes + bv->bv_len <= nr_iter &&
> +				bv->bv_offset + bv->bv_len <= PAGE_SIZE) {
> +			nsegs++;
> +			bytes += bv->bv_len;
> +		} else
> +			goto out_err;

Nit: This would read much better as:

		if (bytes + bv->bv_len > nr_iter)
			goto out_err;
		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
			goto out_err;

		bytes += bv->bv_len;
		nsegs++;


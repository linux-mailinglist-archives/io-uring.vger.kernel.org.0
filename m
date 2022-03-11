Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCEE4D5BB3
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346768AbiCKGoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbiCKGo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:44:28 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2599519D61A;
        Thu, 10 Mar 2022 22:43:26 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BC9A568AFE; Fri, 11 Mar 2022 07:43:21 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:43:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
Message-ID: <20220311064321.GC17232@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com> <20220308152105.309618-9-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-9-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
> +		     u64 ubuf, unsigned long len, gfp_t gfp_mask,
> +		     struct io_uring_cmd *ioucmd)

Looking at this a bit more, I don't think this is a good interface or
works at all for that matter.

> +{
> +	struct iov_iter iter;
> +	size_t iter_count, nr_segs;
> +	struct bio *bio;
> +	int ret;
> +
> +	/*
> +	 * Talk to io_uring to obtain BVEC iterator for the buffer.
> +	 * And use that iterator to form bio/request.
> +	 */
> +	ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
> +			ioucmd);

Instead of pulling the io-uring dependency into blk-map.c we could just
pass the iter to a helper function and have that as the block layer
abstraction if we really want one.  But:

> +	if (unlikely(ret < 0))
> +		return ret;
> +	iter_count = iov_iter_count(&iter);
> +	nr_segs = iter.nr_segs;
> +
> +	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
> +		return -EINVAL;
> +	if (nr_segs > queue_max_segments(q))
> +		return -EINVAL;
> +	/* no iovecs to alloc, as we already have a BVEC iterator */
> +	bio = bio_alloc(gfp_mask, 0);
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	ret = bio_iov_iter_get_pages(bio, &iter);

I can't see how this works at all.   block drivers have a lot more
requirements than just total size and number of segments.  Very typical
is a limit on the size of each sector, and for nvme we also have the
weird virtual boundary for the PRPs.  None of that is being checked here.
You really need to use bio_add_pc_page or open code the equivalent checks
for passthrough I/O.

> +		if (likely(nvme_is_fixedb_passthru(ioucmd)))
> +			ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
> +					GFP_KERNEL, ioucmd);

And I'm also really worried about only supporting fixed buffers.  Fixed
buffers are a really nice benchmarketing feature, but without supporting
arbitrary buffers this is rather useless in real life.

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA2E5E7E8B
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiIWPiZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWPiY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:38:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF97145959;
        Fri, 23 Sep 2022 08:38:23 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A093767373; Fri, 23 Sep 2022 17:38:19 +0200 (CEST)
Date:   Fri, 23 Sep 2022 17:38:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v8 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220923153819.GC21275@lst.de>
References: <20220923092854.5116-1-joshi.k@samsung.com> <CGME20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67@epcas5p3.samsung.com> <20220923092854.5116-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923092854.5116-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> -static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
> -		unsigned len, u32 seed, bool write)
> +static void *nvme_add_user_metadata(struct request *req, void __user *ubuf,
> +		unsigned len, u32 seed)

Please split out a separate patch just for the changes to
nvme_add_user_metadata.

> -	if (ret == len)
> +	if (ret == len) {
> +		req->cmd_flags |= REQ_INTEGRITY;
>  		return buf;
> +	}
>  	ret = -ENOMEM;

Nit: Please keep the successful path in line and branch out for the
errors, i.e.


	if (ret != len) {
	 	ret = -ENOMEM;
		goto out_free_meta;
	}

	req->cmd_flags |= REQ_INTEGRITY;
	return buf;

We should have done this already with the old code, but now that more
is added to the success path it becomes even more important:.

> +	else {
> +		struct iovec fast_iov[UIO_FASTIOV];
> +		struct iovec *iov = fast_iov;
> +		struct iov_iter iter;
> +
> +		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
> +				UIO_FASTIOV, &iov, &iter);
> +		if (ret < 0)
>  			goto out;
> +		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
> +		kfree(iov);
> +	}

While you touch this:  I think thi block of code would also be a good
separate helper.  Maybe even in the block layer given the the scsi
ioctl code and sg duplicate it, and already missed the fast_iov
treatment due to the duplication.  Having this in a separate function
is also nice to keep the fast_iov stack footprint isolated.

> +	if (ret)
> +		goto out;
> +	bio = req->bio;

I think we can also do away with this bio local variable now.

> +	if (bdev)
> +		bio_set_dev(bio, bdev);

We don't need the bio_set_dev here as mentioned last time, so I think
we should remove it in a prep patch.

> +		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
> +			meta_len, meta_seed, &meta, vec);

Nit: Add an extra tab for indentation here please.

>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> +	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;

	if (d.timeout_ms)
		req->timeout = msecs_to_jiffies(d.timeout_ms);


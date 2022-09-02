Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11FF5ABB1C
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiIBXYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIBXYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:24:21 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529941CB07
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:14:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 199so3312116pfz.2
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=UFQxPx2xZ7SXz5if609vWhS7JAKW1EBJUBE4vqHgcYo=;
        b=3rE8sIFgVoYlIoaBXABmjU6tjq4EohsT0ycO+fLTxJFGNlX/oKMrXTP+6WR5tjZy8X
         /MF5F9Ju6ghbTffyPkolxge0v59URbVMmCjeJLIZ7HEbmUAdiDzDFi8wdrD973WJSEG0
         oOoRb9Qlonr8e92FvDSjK9Io2CxV3amzIuafFIyK2KCOfylff6DUDi2DzFmvnLJikMKe
         Oc8hRcmNjKR1LSOyH8Kt0o3TaRx+g50Y2chsi55QS4fBCZvUNCxEtDUw1vX07KDvzRg/
         SpYedok1hrGQmG6d0dBd8H9PvIBOUOPJqQUecofNgxIxD+2uohFyLQUGnEvvVBUVylcw
         FHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UFQxPx2xZ7SXz5if609vWhS7JAKW1EBJUBE4vqHgcYo=;
        b=wFs5OmWiatmvNMKhkK1llxmqokA/HnXVDIdfxKzmniSPnqkUGqyRGtGBwg/2EFSZ7i
         StZe8FKj38FIDsSV+SZvbQDe6RRNjKc5cqhZLVGHpAmQybUTM5DOwF4HpHefdAOhCD8o
         VlWHpKzupiokV7mQAIHPQlVFR3PBzprdRUKw1pogZ4pPt9VfMhLL67d69nN79BEgHxel
         w4K6fc0if7NZjZyKNbXJ2/FX3ii8pVqPhS9bfbIJlOq/nG+2Fog6Xi89LbgPsiUB6E+9
         tTWUfO+X4UnjYDnmB6shEucfKB0lV8NNfdFXkI+htOUyTtx+h6nzFHPfAJg7O7QeS7vC
         8TxQ==
X-Gm-Message-State: ACgBeo07uF/06vGC8jsXR3pDPtEQquQz43ZelNFUbosigv3LzJTg7qCv
        +ScTE33Fb50lGVka65vjaG3dXA==
X-Google-Smtp-Source: AA6agR6msLTQtYJkA01Mz762Y9DQHJpPHWp4VEazkW9MBddlGM8sf2+lRipwmx+LQoxu8fKprf1NXQ==
X-Received: by 2002:a63:e845:0:b0:42a:610a:77a9 with SMTP id a5-20020a63e845000000b0042a610a77a9mr33695479pgk.96.1662160482720;
        Fri, 02 Sep 2022 16:14:42 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d33-20020a634f21000000b004215af667cdsm1969982pgb.41.2022.09.02.16.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 16:14:42 -0700 (PDT)
Message-ID: <5dfa132d-de5a-effa-d1bd-a4f948e36cdf@kernel.dk>
Date:   Fri, 2 Sep 2022 17:14:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 3/4] block: add helper to map bvec iterator
 for passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220902151657.10766-1-joshi.k@samsung.com>
 <CGME20220902152712epcas5p2622e861ac4a5ae9820a9af9442d556b4@epcas5p2.samsung.com>
 <20220902151657.10766-4-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902151657.10766-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 9:16 AM, Kanchan Joshi wrote:
> Add blk_rq_map_user_bvec which maps the bvec iterator into a bio and
> places that into the request.
> This helper is to be used in nvme for uring-passthrough with
> fixed-buffer.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  block/blk-map.c        | 71 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blk-mq.h |  1 +
>  2 files changed, 72 insertions(+)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index f3768876d618..0f7dc568e34b 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -612,6 +612,77 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>  }
>  EXPORT_SYMBOL(blk_rq_map_user);
>  
> +/* Prepare bio for passthrough IO given an existing bvec iter */
> +int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
> +{
> +	struct request_queue *q = rq->q;
> +	size_t iter_count, nr_segs;
> +	struct bio *bio;
> +	struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
> +	struct queue_limits *lim = &q->limits;
> +	unsigned int nsegs = 0, bytes = 0;
> +	int ret, i;
> +
> +	iter_count = iov_iter_count(iter);
> +	nr_segs = iter->nr_segs;
> +
> +	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
> +		return -EINVAL;
> +	if (nr_segs > queue_max_segments(q))
> +		return -EINVAL;
> +	if (rq->cmd_flags & REQ_POLLED) {
> +		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
> +
> +		/* no iovecs to alloc, as we already have a BVEC iterator */
> +		bio = bio_alloc_bioset(NULL, 0, opf, GFP_KERNEL,
> +					&fs_bio_set);
> +		if (!bio)
> +			return -ENOMEM;
> +	} else {
> +		bio = bio_kmalloc(0, GFP_KERNEL);
> +		if (!bio)
> +			return -ENOMEM;
> +		bio_init(bio, NULL, bio->bi_inline_vecs, 0, req_op(rq));
> +	}

I think this should be a helper at this point, as it's the same
duplicated code we have in the normal map path.

-- 
Jens Axboe

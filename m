Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61025B1AC7
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 13:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIHLB7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 07:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIHLB5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 07:01:57 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C7E9FABD
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 04:01:55 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220908110149epoutp0282b67ee700dcbf931ae0191550d8cf63~S3aQy0TKp0867708677epoutp02P
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:01:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220908110149epoutp0282b67ee700dcbf931ae0191550d8cf63~S3aQy0TKp0867708677epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662634909;
        bh=mjGYSBVHS8Pul2E4h+ytoHjuUee9SpuJ0Kh6onobmHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BRXLomuZT0D9N3Jqu/I6+2P8IF7+Q6XvcTx3MknblNjMO9alL2GsxPZrFCDWp2sK9
         eJD4E795AP2q/+cD+LLQlj0za9XKyUh+fpXRuWfkGpZlh7Vnc7WhuvsnGElZ9UIek2
         GNvuN5I84C6OnJW4GaOYDFD+bN7Ue5Ef4AH8bWGk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220908110149epcas5p22f21433d49eba507f694fd5880205b82~S3aQS68552856728567epcas5p2t;
        Thu,  8 Sep 2022 11:01:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MNbmB3w3bz4x9Pw; Thu,  8 Sep
        2022 11:01:46 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.E5.59633.A9BC9136; Thu,  8 Sep 2022 20:01:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220908110146epcas5p17115045ae4bfee4e748e0bd811eb4343~S3aNUJpHi1157611576epcas5p1w;
        Thu,  8 Sep 2022 11:01:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220908110145epsmtrp2ea5806199c0eff81112b768b46e6c3d5~S3aNTQ2cs2289722897epsmtrp2l;
        Thu,  8 Sep 2022 11:01:45 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-0d-6319cb9ae6f9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.E0.14392.99BC9136; Thu,  8 Sep 2022 20:01:45 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220908110144epsmtip202afb007005316b104ddeefd360d3885~S3aL3oRVY0626406264epsmtip2K;
        Thu,  8 Sep 2022 11:01:44 +0000 (GMT)
Date:   Thu, 8 Sep 2022 16:22:00 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v5 3/4] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220908105200.GB15034@test-zns>
MIME-Version: 1.0
In-Reply-To: <81816f51-e720-4f9c-472f-17882f70b4f9@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmhu6s05LJBq1/ZSyaJvxltpizahuj
        xeq7/WwW7w8+ZrW4eWAnk8XK1UeZLN61nmOxmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tHb/M7No++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfHx2XXmgvUKFdOubGdpYHwu2cXIwSEh
        YCKx7KtcFyMXh5DAbkaJqSv7mbsYOYGcT4wS27pUIRLfGCVWTtjMCpIAafh36SIbRGIvo8Sc
        P/cZIZxnjBLLj21gAqliEVCRmLx3OwvICjYBTYkLk0tBwiICehJXb91gB6lnFtjMLDHt7nIW
        kISwQKzEpWf7wTbwCuhK9PS8ZIewBSVOznwCVsMpYCexdUUzWFxUQFniwLbjTCCDJARWckjs
        aZgOdZ6LxNlt+9kgbGGJV8e3sEPYUhKf3+2FiidLXJp5jgnCLpF4vOcglG0v0XoK4n9mgQyJ
        D8+vQdl8Er2/nzBBwotXoqNNCKJcUeLepKdQa8UlHs5YAmV7SMw+NpcJEijvGSWefmxnnsAo
        NwvJP7OQrICwrSQ6PzSxzgJawSwgLbH8HweEqSmxfpf+AkbWVYySqQXFuempxaYFhnmp5fA4
        Ts7P3cQITrNanjsY7z74oHeIkYmD8RCjBAezkgiv6FqJZCHelMTKqtSi/Pii0pzU4kOMpsD4
        mcgsJZqcD0z0eSXxhiaWBiZmZmYmlsZmhkrivFO0GZOFBNITS1KzU1MLUotg+pg4OKUamKyb
        ChtC+Tb/f1CuVWG37JxPw/J5og9nn/mcWDh5nZ+j4xMnyxTOn1p1SUyNTcm5zvO6jk5MVSg2
        3P8m+8KxG7VpK1ZmJsicqvDzec7y8VLo/hcRe+b0rvPa93+ajMKZxglvfH+pKJUJHy+ckFnZ
        9frtYv2ME6k39rjMitc3P3+dZc7S/8xZ3/fbOR+oq5mdq3n/UGlBnHCVwpSw+E9a+35suC3G
        ZiU65bqgrGFu8dQzvAYPVt/O216a+2Fp/Zc/+pH+/SnRXj9LHhuuCE/Yez5NgTP4Snv6K3XZ
        +ctnrOl6eWbiV4MDs1/Z2Ac4HxRVyriTvKpTI+XTzUqPiHvM/Tcu8zq5Wtw5VVsnPeH2dCWW
        4oxEQy3mouJEABbtIes8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvO7M05LJBr/2mls0TfjLbDFn1TZG
        i9V3+9ks3h98zGpx88BOJouVq48yWbxrPcdiMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaP3uZ3bB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVcWvGS/aCh7IV
        2882MTYwbhbvYuTkkBAwkfh36SJbFyMXh5DAbkaJ9WfWskIkxCWar/1gh7CFJVb+ew5mCwk8
        YZSY/tsRxGYRUJGYvHc7SxcjBwebgKbEhcmlIGERAT2Jq7dusIPMZBbYyizx/fcDFpCEsECs
        xKVn+8Hm8wroSvT0vGSHWPyeUaJ7w3kmiISgxMmZT8AamAXMJOZtfsgMsoBZQFpi+T8OkDCn
        gJ3E1hXNYPeICihLHNh2nGkCo+AsJN2zkHTPQuhewMi8ilEytaA4Nz232LDAMC+1XK84Mbe4
        NC9dLzk/dxMjOHK0NHcwbl/1Qe8QIxMH4yFGCQ5mJRFe0bUSyUK8KYmVValF+fFFpTmpxYcY
        pTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwKXSYdLqruspFWKQ37F/yNbWXP1Vf08Wu
        YiKDhZwpU6huf3isQ4qnwa2nJeyxSSKXzTxfsayeNvHPhny+zQIuHxhutGoJv+M8Gb41e15b
        ynqNMsU7b0M2RLhlMuSmFQdxBie8jH5nn5Dk8dLq45ubu7dzCD6v1Vr6q2lfe73W5T4N/rVs
        9w49Xqui9bF3sYO8pNX6gzffyB++zHJo47JD/X9jPb+LS+uV/Jpf77tN/dep4M7t76bdLy+N
        zjuv7hft3WfRdXfGuuqH7fFLfrH9zr/3NaEtgWtH38LP/aYrmc14TW+GHwjYeP98hajImZ5z
        v4/ZXrr0Yn+Mjof+15QXi54pLa1g5300mTnJf6kSS3FGoqEWc1FxIgBbHsh+CwMAAA==
X-CMS-MailID: 20220908110146epcas5p17115045ae4bfee4e748e0bd811eb4343
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_f0a20_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9@epcas5p1.samsung.com>
        <20220906062721.62630-4-joshi.k@samsung.com>
        <81816f51-e720-4f9c-472f-17882f70b4f9@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_f0a20_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Sep 07, 2022 at 03:32:26PM +0000, Chaitanya Kulkarni wrote:
>On 9/5/22 23:27, Kanchan Joshi wrote:
>> Add blk_rq_map_user_bvec which maps the bvec iterator into a bio and
>> places that into the request. This helper will be used in nvme for
>> uring-passthrough with fixed-buffer.
>> While at it, create another helper bio_map_get to reduce the code
>> duplication.
>>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   block/blk-map.c        | 94 +++++++++++++++++++++++++++++++++++++-----
>>   include/linux/blk-mq.h |  1 +
>>   2 files changed, 85 insertions(+), 10 deletions(-)
>>
>> diff --git a/block/blk-map.c b/block/blk-map.c
>> index f3768876d618..e2f268167342 100644
>> --- a/block/blk-map.c
>> +++ b/block/blk-map.c
>> @@ -241,17 +241,10 @@ static void bio_map_put(struct bio *bio)
>>   	}
>>   }
>>
>> -static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>>   		gfp_t gfp_mask)
>>   {
>> -	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
>> -	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
>>   	struct bio *bio;
>> -	int ret;
>> -	int j;
>> -
>> -	if (!iov_iter_count(iter))
>> -		return -EINVAL;
>>
>>   	if (rq->cmd_flags & REQ_POLLED) {
>>   		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
>> @@ -259,13 +252,31 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>>   		bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,
>>   					&fs_bio_set);
>>   		if (!bio)
>> -			return -ENOMEM;
>> +			return NULL;
>>   	} else {
>>   		bio = bio_kmalloc(nr_vecs, gfp_mask);
>>   		if (!bio)
>> -			return -ENOMEM;
>> +			return NULL;
>>   		bio_init(bio, NULL, bio->bi_inline_vecs, nr_vecs, req_op(rq));
>>   	}
>> +	return bio;
>> +}
>> +
>> +static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>> +		gfp_t gfp_mask)
>> +{
>> +	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
>> +	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
>> +	struct bio *bio;
>> +	int ret;
>> +	int j;
>> +
>> +	if (!iov_iter_count(iter))
>> +		return -EINVAL;
>> +
>> +	bio = bio_map_get(rq, nr_vecs, gfp_mask);
>> +	if (bio == NULL)
>> +		return -ENOMEM;
>>
>>   	while (iov_iter_count(iter)) {
>>   		struct page **pages, *stack_pages[UIO_FASTIOV];
>> @@ -612,6 +623,69 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>>   }
>>   EXPORT_SYMBOL(blk_rq_map_user);
>>
>> +/* Prepare bio for passthrough IO given an existing bvec iter */
>> +int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
>> +{
>> +	struct request_queue *q = rq->q;
>> +	size_t iter_count, nr_segs;
>> +	struct bio *bio;
>> +	struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
>> +	struct queue_limits *lim = &q->limits;
>> +	unsigned int nsegs = 0, bytes = 0;
>> +	int ret, i;
>> +
>
>consider this (untested), it also sets the variable i data type same
>as it comparison variable in nr_segs the loop i.e. size_t :-
>
>+       struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
>+       struct request_queue *q = rq->q;
>+       struct queue_limits *lim = &q->limits;
>+       unsigned int nsegs = 0, bytes = 0;
>+       size_t iter_count, nr_segs, i;
>+       struct bio *bio;
>+       int ret;
>
>
>> +	iter_count = iov_iter_count(iter);
>> +	nr_segs = iter->nr_segs;
>> +
>> +	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
>> +		return -EINVAL;
>
>can we remove braces for iter_count >> 9 without impacting the intended
>functionality?

I think removing that make it hard to read.
I will fold all other changes you mentioned in v6.


------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_f0a20_
Content-Type: text/plain; charset="utf-8"


------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_f0a20_--

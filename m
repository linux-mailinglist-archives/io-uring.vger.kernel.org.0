Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0095B211A
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiIHOrU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 10:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiIHOrA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 10:47:00 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B6B1223B0
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 07:46:49 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g1so8542865iob.13
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 07:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=eeIoDIdI2MvXvI2TC9JGJLL/O+kcb8qvz/17unZ7Ig8=;
        b=kYwGkuEn2GEcHBJoQCTLhF3KAE4/UyLj2YgnRN/RU1YwtO3XeXbsdjsVG2x5AdpNRG
         FFF4HHdrcPldrYYc6VQHpYtHjK6ITDuDoW1N05Hxievx+F60QwFkTuk4KmSXs15rRPil
         Y6Oo07wLtMnhx5/m58K9lBoVBPg2t2YMrQem4jY6CdcYHAvV3kHOSviBnSKTjUhAEO1M
         wrKuNUdia5TmrgvgxJFsbGrK4hxcHirsYbwYuwsih9WqOHenoM8Oq6y/mCO0Lb8b0+g4
         f0vw213OKGZQCSWusFDlwbIPNpLA9IDNDO61GSMojuUUGUqCwTcb9DPpdjelakAkftT4
         WMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eeIoDIdI2MvXvI2TC9JGJLL/O+kcb8qvz/17unZ7Ig8=;
        b=KiHDW3XnerwxWxZ2dzri9H0lK5etf0v7sYOjyJXFGb66nyz+SqF7bk+xSD7VGLEhYG
         2bJH439c85hDXRQExsNUweD3PdklGWsBb3yGG3B5JZUjvs+xEWvtlCRLfJSj+2CTqF7A
         pcTp0ZWnnmIgUe4Efrs7ZP/WL2ZSwXxaX/GgM8juUkUmXou3BdXk0zZS0nEiCvN5rfpi
         ooW60m226Jy8BJdkzx+V7Xqk1zVWCMZgOG7oHvlRNl1wD16M7cQP7g3UthYdx/J+wmaC
         6lj5kPOxLJjPY6c6/AXmmCw+G/zMDqRP4KSWbc+z6KnVQxk2EXT5yfpWtYQ3ByTfw09U
         WRww==
X-Gm-Message-State: ACgBeo3k8yI+mgLbkFAduy4o0WIpIEG1uuAFdhjsMh246YI8pQyM+G2s
        AYYPcS2VDTzySGO+eTRnMUSrMQ==
X-Google-Smtp-Source: AA6agR4ZOEvaC1A6TbVZt917oBCLnnNKOZJ+ozZlUmQo/r0Et4a0Q9I2+0j+vUtVv6Pk95uDI4xftA==
X-Received: by 2002:a05:6638:3291:b0:350:bfe1:c724 with SMTP id f17-20020a056638329100b00350bfe1c724mr4826298jav.73.1662648407498;
        Thu, 08 Sep 2022 07:46:47 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h11-20020a056e020d4b00b002eb1c60db6csm937439ilj.63.2022.09.08.07.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 07:46:47 -0700 (PDT)
Message-ID: <5634d8c6-b4d3-1443-59d2-176fd7c258a5@kernel.dk>
Date:   Thu, 8 Sep 2022 08:46:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH for-next v5 3/4] block: add helper to map bvec iterator
 for passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220906062721.62630-1-joshi.k@samsung.com>
 <CGME20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9@epcas5p1.samsung.com>
 <20220906062721.62630-4-joshi.k@samsung.com>
 <81816f51-e720-4f9c-472f-17882f70b4f9@nvidia.com>
 <20220908105200.GB15034@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220908105200.GB15034@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/22 4:52 AM, Kanchan Joshi wrote:
> On Wed, Sep 07, 2022 at 03:32:26PM +0000, Chaitanya Kulkarni wrote:
>> On 9/5/22 23:27, Kanchan Joshi wrote:
>>> Add blk_rq_map_user_bvec which maps the bvec iterator into a bio and
>>> places that into the request. This helper will be used in nvme for
>>> uring-passthrough with fixed-buffer.
>>> While at it, create another helper bio_map_get to reduce the code
>>> duplication.
>>>
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>> ---
>>>   block/blk-map.c        | 94 +++++++++++++++++++++++++++++++++++++-----
>>>   include/linux/blk-mq.h |  1 +
>>>   2 files changed, 85 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/block/blk-map.c b/block/blk-map.c
>>> index f3768876d618..e2f268167342 100644
>>> --- a/block/blk-map.c
>>> +++ b/block/blk-map.c
>>> @@ -241,17 +241,10 @@ static void bio_map_put(struct bio *bio)
>>>       }
>>>   }
>>>
>>> -static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>>> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>>>           gfp_t gfp_mask)
>>>   {
>>> -    unsigned int max_sectors = queue_max_hw_sectors(rq->q);
>>> -    unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
>>>       struct bio *bio;
>>> -    int ret;
>>> -    int j;
>>> -
>>> -    if (!iov_iter_count(iter))
>>> -        return -EINVAL;
>>>
>>>       if (rq->cmd_flags & REQ_POLLED) {
>>>           blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
>>> @@ -259,13 +252,31 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>>>           bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,
>>>                       &fs_bio_set);
>>>           if (!bio)
>>> -            return -ENOMEM;
>>> +            return NULL;
>>>       } else {
>>>           bio = bio_kmalloc(nr_vecs, gfp_mask);
>>>           if (!bio)
>>> -            return -ENOMEM;
>>> +            return NULL;
>>>           bio_init(bio, NULL, bio->bi_inline_vecs, nr_vecs, req_op(rq));
>>>       }
>>> +    return bio;
>>> +}
>>> +
>>> +static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>>> +        gfp_t gfp_mask)
>>> +{
>>> +    unsigned int max_sectors = queue_max_hw_sectors(rq->q);
>>> +    unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
>>> +    struct bio *bio;
>>> +    int ret;
>>> +    int j;
>>> +
>>> +    if (!iov_iter_count(iter))
>>> +        return -EINVAL;
>>> +
>>> +    bio = bio_map_get(rq, nr_vecs, gfp_mask);
>>> +    if (bio == NULL)
>>> +        return -ENOMEM;
>>>
>>>       while (iov_iter_count(iter)) {
>>>           struct page **pages, *stack_pages[UIO_FASTIOV];
>>> @@ -612,6 +623,69 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>>>   }
>>>   EXPORT_SYMBOL(blk_rq_map_user);
>>>
>>> +/* Prepare bio for passthrough IO given an existing bvec iter */
>>> +int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
>>> +{
>>> +    struct request_queue *q = rq->q;
>>> +    size_t iter_count, nr_segs;
>>> +    struct bio *bio;
>>> +    struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
>>> +    struct queue_limits *lim = &q->limits;
>>> +    unsigned int nsegs = 0, bytes = 0;
>>> +    int ret, i;
>>> +
>>
>> consider this (untested), it also sets the variable i data type same
>> as it comparison variable in nr_segs the loop i.e. size_t :-
>>
>> +       struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
>> +       struct request_queue *q = rq->q;
>> +       struct queue_limits *lim = &q->limits;
>> +       unsigned int nsegs = 0, bytes = 0;
>> +       size_t iter_count, nr_segs, i;
>> +       struct bio *bio;
>> +       int ret;
>>
>>
>>> +    iter_count = iov_iter_count(iter);
>>> +    nr_segs = iter->nr_segs;
>>> +
>>> +    if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
>>> +        return -EINVAL;
>>
>> can we remove braces for iter_count >> 9 without impacting the intended
>> functionality?
> 
> I think removing that make it hard to read.
> I will fold all other changes you mentioned in v6.

Agree - if you have to think about operator precedence, then that's a
sign that the code is less readable and more fragile.

-- 
Jens Axboe



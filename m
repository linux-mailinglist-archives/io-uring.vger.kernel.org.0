Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91985B21B1
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiIHPL0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiIHPLZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:11:25 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F5C122395
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:11:23 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220908151111euoutp02d505d1a2309472cedbef461fd6a8c447~S6z-Jn3kv1908419084euoutp02c
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 15:11:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220908151111euoutp02d505d1a2309472cedbef461fd6a8c447~S6z-Jn3kv1908419084euoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662649871;
        bh=wgDMP/QxKwOT52bHzOXfySbWM1Byhho5o70CW445N+w=;
        h=Date:Subject:To:CC:From:In-Reply-To:References:From;
        b=vdtKu0COJ27OuEKASd4JsFmNeiMZCyZtzQZTUrYyYrWK/z9e8hYCRPMq3hJ9q6CrE
         2xpCuNCFnOUmNT8SJOXmRjp+MabjqJi9I6fwRDOnB+tSIPT/cH78vonafh9quvcEVq
         IBdFVgsjSrbzdExQwXF/jWJTha4J2+HiIlmeeJvs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220908151111eucas1p107bffed808398472d9e0c68cb63225a9~S6z_zDCRQ2775927759eucas1p1m;
        Thu,  8 Sep 2022 15:11:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AD.72.29727.F060A136; Thu,  8
        Sep 2022 16:11:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220908151110eucas1p29fdb37dd124f793b96fb0de08c4c5243~S6z_WwX2I0769007690eucas1p2L;
        Thu,  8 Sep 2022 15:11:10 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220908151110eusmtrp2953f4c31d9efd1b196f7a24a26dd5dea~S6z_V3Ufp0287502875eusmtrp2d;
        Thu,  8 Sep 2022 15:11:10 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-34-631a060ffe09
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7A.D7.10862.E060A136; Thu,  8
        Sep 2022 16:11:10 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908151110eusmtip2152097d7ffe9f3471cfeac7aacae90f4~S6z_M1hew1299812998eusmtip2p;
        Thu,  8 Sep 2022 15:11:10 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.191) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 8 Sep 2022 16:11:09 +0100
Message-ID: <068a418d-31ba-05ef-7cb7-186f45cce08f@samsung.com>
Date:   Thu, 8 Sep 2022 17:11:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
        Thunderbird/91.11.0
Subject: Re: [PATCH for-next v5 3/4] block: add helper to map bvec iterator
 for passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
From:   Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220908105200.GB15034@test-zns>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [106.210.248.191]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7djPc7r8bFLJBtvf8lrMWbWN0WL13X42
        i/cHH7NarFx9lMniXes5FotJh64xWuy9pW0xf9lTdgcOj52z7rJ7XD5b6rFpVSebx+Yl9R67
        bzawefQ2v2Pz+LxJLoA9issmJTUnsyy1SN8ugStj1pXNrAWX2SumtPE0MM5k62Lk4JAQMJF4
        skC2i5GLQ0hgBaNEX8d6oDgnkPOFUWLXb0OIxGdGiVcT7zKBJEAati7/zQ6RWM4o8fHBbxa4
        qlvNcxghnF2MEhOPrgVr4RWwk3h98R7YXBYBFYnHS9ezQsQFJU7OfMICYosKREqs2X2WHcQW
        FoiVuPRsP1gNs4C4xK0n85lAbhURCJX4viYaZD6zwGZmif6d29hB4mwCWhKNnWCtnAJ6EtNX
        fGGCaNWUaN3+mx3Clpdo3jqbGeIDZYnJk/+zQdi1EmuPnQH7RkKgn1Ni69VfrBAJF4ndOz+z
        Q9jCEq+Ob4GyZST+75wPDYpqiac3fjNDNLcwAh20Hhqo1hJ9Z3IgahwlLt7cDhXmk7jxVhDi
        Hj6JSdumM09gVJ2FFBKzkHw8C8kLs5C8sICRZRWjeGppcW56arFhXmq5XnFibnFpXrpecn7u
        JkZgajr97/inHYxzX33UO8TIxMF4iFGCg1lJhFd0rUSyEG9KYmVValF+fFFpTmrxIUZpDhYl
        cd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiajnpaji3bMKNyw4ioH76mXHzwr/zqKvHj7/NZP
        BS1hqz3Xmvyv3Lj4UGnxtNVPWGR/tcyfKLbn/Or+BNHbUuITlP00hM6pRax5Eb3w6m8rGfsC
        n78zT3yuel2pLFj0Ojyj/vS7nIxv1+u7Xd+UvQrgm7Omv1Rj1a2FMa4XDQvN/P8/yLtawS9+
        8MR54cQfwlFnj7Wq/+nv3pezyGHicr+Vrt+fneJtXVLjPutCiZr71cubmyc/3BmzT6zg7ue7
        mgeelsyyl6xN2P2nx41Lf37YbY9P+jySG39nii/eW7zjz/fpK6bqB84U4hMTfM2rwHnW9KtC
        zcVYgcBr6TE7j93nrLRJ6b1h/G3XxlemLL27lViKMxINtZiLihMBpJ6XvLwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t/xe7p8bFLJBmv+6FjMWbWN0WL13X42
        i/cHH7NarFx9lMniXes5FotJh64xWuy9pW0xf9lTdgcOj52z7rJ7XD5b6rFpVSebx+Yl9R67
        bzawefQ2v2Pz+LxJLoA9Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384m
        JTUnsyy1SN8uQS9j1pXNrAWX2SumtPE0MM5k62Lk5JAQMJHYuvw3excjF4eQwFJGie1LJjFD
        JGQkPl35yA5hC0v8udYF1iAk8JFR4uDuCIiGXUANmzeAFfEK2Em8vngPrIhFQEXi8dL1rBBx
        QYmTM5+wgNiiApESD5c1MYHYwgKxEpee7QerYRYQl7j1ZD5QnINDRCBU4vuaaJD5zAKbmSX6
        d26Dum4yk8TjLd/ZQYrYBLQkGjvB9nIK6ElMX/GFCWKOpkTr9t/sELa8RPPW2VDPKEtMnvwf
        6uNaiVf3dzNOYBSdheS8WUjOmIVk1CwkoxYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQI
        jOltx35u2cG48tVHvUOMTByMhxglOJiVRHhF10okC/GmJFZWpRblxxeV5qQWH2I0BYbRRGYp
        0eR8YFLJK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpgyp89SUZC
        7pyLQoRftOmOGRtl1nScUuxm7t8/x1dMVYntaors+5JqqR1m1qe5nn0NsN64NSMiqHj2VN9T
        fodyTY/LcMccyUzb6fY8ZLNV7cm/TYv/LzJu+tz394FzouAu11C2jnplo0vdbRVzZ+VlTYo/
        f+TZ+/UO92dNbFqU9MbdJa/ZyW/Rvzb9lviEh9qHfrptPlrS9umn/tZ6tYI9c+8vPt9S2qr5
        Xp6ZP1Vd5krI7rksl75Gvplmm/baJiLA5GW5qh/XrOj/L4oiBeS6LnHq6807f0XYNsFTgklw
        5sfrDfz2yU9PL1im5/xWIOq0r1BmxFmRGMYpTXeiNM4p10VeY4wI128Xv+qa8UKJpTgj0VCL
        uag4EQD42uIncgMAAA==
X-CMS-MailID: 20220908151110eucas1p29fdb37dd124f793b96fb0de08c4c5243
X-Msg-Generator: CA
X-RootMTR: 20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9@epcas5p1.samsung.com>
        <20220906062721.62630-4-joshi.k@samsung.com>
        <81816f51-e720-4f9c-472f-17882f70b4f9@nvidia.com>
        <20220908105200.GB15034@test-zns>
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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
You can also use the SECTOR_SHIFT macro instead of hard-coding 9.

> I think removing that make it hard to read.
> I will fold all other changes you mentioned in v6.
> 
> 

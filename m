Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D35C6DF756
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 15:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjDLNg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjDLNgX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 09:36:23 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638DD6183
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 06:36:14 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230412132707epoutp036a0b48c4248d929a31742f8c59031fbf~VMuybVn_n1533515335epoutp03I
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 13:27:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230412132707epoutp036a0b48c4248d929a31742f8c59031fbf~VMuybVn_n1533515335epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1681306027;
        bh=FrRIN0hez/j0k4F3I2pqboYN8/OalO/l43vVDokKZGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XCEs7l2uf6G7PmRvfZl06DE5FnKFBo6sPQ3CCv8vax3arQB9VcWdhPKexdbojbORM
         suOfuJVgNkr/p4EinMdIxFTI7CuMmIVLfnzzgVHlm1n+lnHngMaCEFCXtUEC9iMekc
         3/16LZuXP0EPGLOdtxUnjnR7oRrdDxsHB8rQ8zTk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230412132707epcas5p196913c254eb3e3f044f38a52094a0424~VMuyCforp0661306613epcas5p1P;
        Wed, 12 Apr 2023 13:27:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4PxNm94zKvz4x9Pv; Wed, 12 Apr
        2023 13:27:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.B5.09961.9A1B6346; Wed, 12 Apr 2023 22:27:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230412132705epcas5p200e7adf30a3fb51fc2cf851d5e2e5235~VMuwPbaX41164911649epcas5p2W;
        Wed, 12 Apr 2023 13:27:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230412132705epsmtrp2f78d9cb673d2e5ac2b4b95cdbbfee9aa~VMuwNc3Q52662026620epsmtrp2k;
        Wed, 12 Apr 2023 13:27:05 +0000 (GMT)
X-AuditID: b6c32a49-52dfd700000026e9-fd-6436b1a9c735
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.E6.08279.9A1B6346; Wed, 12 Apr 2023 22:27:05 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230412132703epsmtip19fb507f004fbe302857a005e7a4b1f7f~VMuutz8J91695616956epsmtip1c;
        Wed, 12 Apr 2023 13:27:03 +0000 (GMT)
Date:   Wed, 12 Apr 2023 18:56:15 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        hch@lst.de, kbusch@kernel.org
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Message-ID: <20230412132615.GA5049@green5>
MIME-Version: 1.0
In-Reply-To: <ZDYYhE1h1qvCvVmt@ovpn-8-26.pek2.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmlu7KjWYpBu83KlusvtvPZrFy9VEm
        i3et51gszr89zGQx6dA1Rou9t7Qt5i97ym6x7/VeZotDk5uZHDg9ds66y+5x+Wypx6ZVnWwe
        m5fUe0y+sZzRY/fNBjaP9/uusnl83iQXwBGVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
        qGtoaWGupJCXmJtqq+TiE6DrlpkDdJySQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAl
        p8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj3uXDrAWLBCv+7bzA0sA4ha+LkZNDQsBE4veu
        HpYuRi4OIYHdjBJbfy5hAkkICXxilDj8XQQi8Y1RYsXSV4wwHQu/9LFBJPYySvycf4YVwnnC
        KLF+1R1mkCoWAVWJVRNAqjg42AQ0JS5MLgUJiwgoSdy9u5odpJ4ZpH7RozUsIAlhAXuJE7fn
        g23gFdCSuNf6kxXCFpQ4OfMJWA2ngKXE1s/PwOKiAsoSB7YdZwIZJCEwl0Ni63qY81wkrjzu
        YoGwhSVeHd/CDmFLSXx+t5cNwk6WuDTzHBOEXSLxeM9BKNteovVUP9gDzALpEp0PfrBB2HwS
        vb+fMIE8IyHAK9HRJgRRrihxb9JTVghbXOLhjCVQtofEy70PoCG0jUmi4flr9gmMcrOQ/DML
        yQoI20qi80MT6yygFcwC0hLL/3FAmJoS63fpL2BkXcUomVpQnJueWmxaYJiXWg6P5OT83E2M
        4PSq5bmD8e6DD3qHGJk4GA8xSnAwK4nw/nAxTRHiTUmsrEotyo8vKs1JLT7EaAqMn4nMUqLJ
        +cAEn1cSb2hiaWBiZmZmYmlsZqgkzqtuezJZSCA9sSQ1OzW1ILUIpo+Jg1OqgWn+8sLJs467
        lX2sW/njZHZHeRuDyOUJz57uD79lsqjkzT2T9tYNTz8/u7Ztb+v9JZUz6swFfLW5fDIXXrha
        vv/F7T9tXzRObdvIcuU/70LZkH+Pj2j92P95Hxfjev4m0Yf3SrojvjcaVTnu2m50aE/0dkm5
        XVam9pd9Pp6J3X+p0iJ5/8mVpSrctaKLZR1y2A++sPmXed+/U5R/Xf5+zTe871Yph/7LmGJz
        f52Y93e/tCUn6u5/F0xz9Pm+ajf3CeOkQytZpH+Z+sttkmOYwct1MtOyNyrG8kr+h585svbM
        7DMSJKV9785KSp5cOP9f0uvDT0zcb0nxdkyvEP59eCv7ubi6GOUHHjslD8zzqzNTYinOSDTU
        Yi4qTgQAyDCqczgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnO7KjWYpBjs7eSxW3+1ns1i5+iiT
        xbvWcywW598eZrKYdOgao8XeW9oW85c9ZbfY93ovs8Whyc1MDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPSbfWM7osftmA5vH+31X2Tw+b5IL4IjisklJzcksSy3St0vgyti/3bTgOl/FkRs7WRsY
        H3N3MXJySAiYSCz80sfWxcjFISSwm1HiwplfTBAJcYnmaz/YIWxhiZX/nrNDFD1ilJjx4TsL
        SIJFQFVi1QSQbg4ONgFNiQuTS0HCIgJKEnfvrgarZxZ4wihxt+kTG0hCWMBe4sTt+YwgNq+A
        lsS91p+sILaQwDYmiZU7KiDighInZz4Bm88sYCYxb/NDZpD5zALSEsv/cYCEOQUsJbZ+fgbW
        KiqgLHFg23GmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxN
        jOBo0dLcwbh91Qe9Q4xMHIyHGCU4mJVEeH+4mKYI8aYkVlalFuXHF5XmpBYfYpTmYFES573Q
        dTJeSCA9sSQ1OzW1ILUIJsvEwSnVwLTi2y7msPKIU2k7TGaeKYhkT2jSkl+g6zGRxVuRy+yJ
        gb7X7/nm7167StYWfNsme8b+9RHGg+lGqsv2/Jm5J//yJ6ar1vvmFzZkhrftYmq0qbld+MNU
        olvrhK7SEuubjSHVcSFZCgGHlr2RuTvlyGmLFxOWXZipdnt57vbdl5gT57D8L10c8UROozPG
        SchoUcCN+d8ZnR8USZ+OOpO5QFAkcj5D6ZEE1RUfPvRm3EhlfX8w7uNhXsUaOU4FFi1ut5u1
        H94stOb++LPgsvVh/kcLv+S7OU1m2rLBMHXHcr0k8a2uIsc4Sn8I9174vzrCKz/jy5kym1ec
        HfZzt5fO9Aq/UH78ZUu40FTdq273rZVYijMSDbWYi4oTAfH6DscFAwAA
X-CMS-MailID: 20230412132705epcas5p200e7adf30a3fb51fc2cf851d5e2e5235
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----oW8IgUNFNIFSxD7XOdDcjcvigBkmAw5-sdGI5qmS7_HEDRAp=_ff6c_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
        <20230210180033.321377-1-joshi.k@samsung.com>
        <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
        <CA+1E3rLLu2ZzBHp30gwXBWzkCvOA4KD7PS70mLuGE8tYFpNEmA@mail.gmail.com>
        <ZDYYhE1h1qvCvVmt@ovpn-8-26.pek2.redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------oW8IgUNFNIFSxD7XOdDcjcvigBkmAw5-sdGI5qmS7_HEDRAp=_ff6c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Apr 12, 2023 at 10:33:40AM +0800, Ming Lei wrote:
>On Wed, Apr 12, 2023 at 04:18:16AM +0530, Kanchan Joshi wrote:
>> > > 4. Direct NVMe queues - will there be interest in having io_uring
>> > > managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
>> > > io_uring SQE to NVMe SQE without having to go through intermediate
>> > > constructs (i.e., bio/request). Hopefully,that can further amp up the
>> > > efficiency of IO.
>> >
>> > This is interesting, and I've pondered something like that before too. I
>> > think it's worth investigating and hacking up a prototype. I recently
>> > had one user of IOPOLL assume that setting up a ring with IOPOLL would
>> > automatically create a polled queue on the driver side and that is what
>> > would be used for IO. And while that's not how it currently works, it
>> > definitely does make sense and we could make some things faster like
>> > that. It would also potentially easier enable cancelation referenced in
>> > #1 above, if it's restricted to the queue(s) that the ring "owns".
>>
>> So I am looking at prototyping it, exclusively for the polled-io case.
>> And for that, is there already a way to ensure that there are no
>> concurrent submissions to this ring (set with IORING_SETUP_IOPOLL
>> flag)?
>> That will be the case generally (and submissions happen under
>> uring_lock mutex), but submission may still get punted to io-wq
>> worker(s) which do not take that mutex.
>> So the original task and worker may get into doing concurrent submissions.
>
>It seems one defect for uring command support, since io_ring_ctx and
>io_ring_submit_lock() can't be exported for driver.

Sorry, did not follow the defect part.
io-wq not acquring uring_lock in case of uring-cmd - is a defect? 
The same happens for direct block-io too.
Or do you mean anything else here?

------oW8IgUNFNIFSxD7XOdDcjcvigBkmAw5-sdGI5qmS7_HEDRAp=_ff6c_
Content-Type: text/plain; charset="utf-8"


------oW8IgUNFNIFSxD7XOdDcjcvigBkmAw5-sdGI5qmS7_HEDRAp=_ff6c_--

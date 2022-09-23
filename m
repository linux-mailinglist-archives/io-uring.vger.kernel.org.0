Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D65E821F
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiIWSxy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 14:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiIWSxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 14:53:53 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F66121641
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 11:53:49 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220923185343epoutp010381a1f8e3e035fa6440365c141db593~Xkhj0sTvU2762327623epoutp01p
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 18:53:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220923185343epoutp010381a1f8e3e035fa6440365c141db593~Xkhj0sTvU2762327623epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663959223;
        bh=uM84Skvb/lRIMqt2ZdoRJ2okqVHu0nNFPbVFptCjlSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iwBLYFPbD2Iw0ZPTiKPRXx+KFiX4WVkr48cmE2awcLxiwhb2i98H4xOnDGKkV1X2s
         ds02KRnUswNA7KGbLBcgLVv/S8PH4Xh1/7K0vUauExZIJae4DWAAS6SLqr54XQNpMc
         cKxhu2ICRjjqhNxuKQStNynTABDTgOC2qhg3Cgdc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220923185341epcas5p28f5a293ae8acbf001b9a7e930f504036~XkhifnNj41621916219epcas5p2U;
        Fri, 23 Sep 2022 18:53:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MZ1Wl0Ydjz4x9Pv; Fri, 23 Sep
        2022 18:53:39 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.D1.39477.2B00E236; Sat, 24 Sep 2022 03:53:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220923185338epcas5p1766084406eb5fd62187d63e05c4f33d5~XkhfehYkm2437624376epcas5p1I;
        Fri, 23 Sep 2022 18:53:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220923185338epsmtrp18ea8edcf19d5cabef34a41c6b5338fde~XkhfdB4To1275312753epsmtrp1l;
        Fri, 23 Sep 2022 18:53:38 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-91-632e00b2d9cd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.7B.18644.2B00E236; Sat, 24 Sep 2022 03:53:38 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220923185336epsmtip2002cf5076170b5e8da216385c2231ae1~XkheBDJdV0241902419epsmtip2Q;
        Fri, 23 Sep 2022 18:53:36 +0000 (GMT)
Date:   Sat, 24 Sep 2022 00:13:49 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220923184349.GA3394@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220923152941.GA21275@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmlu4mBr1kg1uNZhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMv2f2shXMl6s4N7GVqYHxtngXIyeHhICJxJTzU5i7GLk4
        hAR2M0rcu7GEEcL5xCjR2nUWyvnMKLH9zXZmmJZnX96xQyR2MUo82baWESQhJPCMUeLY21gQ
        m0VAVWL/9WUsXYwcHGwCmhIXJpeChEUElCSevoIYyixwBai3ax0TSEJYIFZi45HfYAt4BXQk
        lj37wwhhC0qcnPmEBcTmBIo//XALzBYVUJY4sO04E8ggCYGZHBIneq4yQlznIvH2+E8mCFtY
        4tXxLewQtpTEy/42KDtZ4tLMc1A1JRKP9xyEsu0lWk/1M4MczSyQLvHnVB1ImFmAT6L39xMm
        kLCEAK9ER5sQRLWixL1JT1khbHGJhzOWQNkeEmvmXIEG3BwmibVXrzNOYJSbheSdWQgbZoFt
        sJLo/NDEChGWllj+jwPC1JRYv0t/ASPrKkbJ1ILi3PTUYtMCo7zUcngUJ+fnbmIEJ1Qtrx2M
        Dx980DvEyMTBeIhRgoNZSYQ35aJushBvSmJlVWpRfnxRaU5q8SFGU2DsTGSWEk3OB6b0vJJ4
        QxNLAxMzMzMTS2MzQyVx3sUztJKFBNITS1KzU1MLUotg+pg4OKUamDapnXr78UWU6gqLKJsI
        tYSn5yVCPvudXSn+6ezyJJfItGM7dX/63md4Gcv/+9zZH/L/6tkPHNzZOfdHc5erg2qQ96bF
        jzI+Fb4Nqmhk31YabsylIikfedmsePPMr+yTwmcb3bmUHHnslcXNQ3y7gnMLpzvP8MhIauUN
        iQ9vfLvhf/nGrIC2L99MvAuO5789Zr2G/Urp3Lj4aQqmxlqecqzzi11LOf78/HzoBperd4Y5
        78yfhtn7vp5bc3Ti1/lHGTbb5ZqVVcp3Ry2yYNgQkBjsc7+FYZoSe/np17uWTzgz8a+jXqp+
        xZqnz2+r6QUfSjzmxPbao92uVf8Ri9EqQUXfivYzGzRT+E5syGy1VmIpzkg01GIuKk4EAFuT
        ad8xBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSvO4mBr1kgy+7JC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsErowJHw8zF1yRrti3dDNrA+Mq0S5G
        Tg4JAROJZ1/esXcxcnEICexglFh3ahMzREJcovnaD3YIW1hi5b/nUEVPGCU6ftxhBEmwCKhK
        7L++jKWLkYODTUBT4sLkUpCwiICSxNNXZxlB6pkFrjBK/Nm/hBUkISwQK7HxyG+wBbwCOhLL
        nv1hhBi6gEni2ObHjBAJQYmTM5+wgNjMAmYS8zY/ZAZZwCwgLbH8HwdImBOo9+mHW2AlogLK
        Ege2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4T
        La0djHtWfdA7xMjEwXiIUYKDWUmEN+WibrIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OF
        BNITS1KzU1MLUotgskwcnFINTCv2tk/acPfPgzlJR1TOr1uW4ZqaqtL92azGbAfjLDnbJKlV
        j8J0NG/4SDvN6bWcV9iy+C3D1jXTEnwYz8qqxclcZYrRW9O+IzP53/ZSzZ03Du5dUFVx/jnn
        x6uHU7fL3OQ8EcfdrZ2waLaXXotB4vUN+oarzWSD1347reU+aWeI5kkZY6uyrSGPVi+KO7lE
        Iz74zVTnKnaeCu7ctWJZzfmyGslfl1ZsvWTTnC/VM3nLV9tNDLs+n4yZ+3rhupmJhwpvy6sV
        +Zj/fHSg0aGqoHOK6UdpZpFl2jILdp8KObuEMWj3m698V9T/VSakLIpLXxUUaSOxf0lF0NzF
        2v2mC9O4t6ziq5La7DHdoMY7SomlOCPRUIu5qDgRAA+qbd0CAwAA
X-CMS-MailID: 20220923185338epcas5p1766084406eb5fd62187d63e05c4f33d5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_6b63_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com>
        <20220909102136.3020-5-joshi.k@samsung.com> <20220920120802.GC2809@lst.de>
        <20220922152331.GA24701@test-zns> <20220923152941.GA21275@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_6b63_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Sep 23, 2022 at 05:29:41PM +0200, Christoph Hellwig wrote:
>On Thu, Sep 22, 2022 at 08:53:31PM +0530, Kanchan Joshi wrote:
>>> blk_rq_map_user_iov really should be able to detect that it is called
>>> on a bvec iter and just do the right thing rather than needing different
>>> helpers.
>>
>> I too explored that possibility, but found that it does not. It maps the
>> user-pages into bio either directly or by doing that copy (in certain odd
>> conditions) but does not know how to deal with existing bvec.
>
>What do you mean with existing bvec?  We allocate a brand new bio here
>that we want to map the next chunk of the iov_iter to, and that
>is exactly what blk_rq_map_user_iov does.  What blk_rq_map_user_iov
>currently does not do is to implement this mapping efficiently
>for ITER_BVEC iters

It is clear that it was not written for ITER_BVEC iters.
Otherwise that WARN_ON would not have hit.

And efficency is the concern as we are moving to more heavyweight
helper that 'handles' weird conditions rather than just 'bails out'.
These alignment checks end up adding a loop that traverses
the entire ITER_BVEC.
Also blk_rq_map_user_iov uses bio_iter_advance which also seems
cycle-consuming given below code-comment in io_import_fixed():

if (offset) {
        /*
         * Don't use iov_iter_advance() here, as it's really slow for
         * using the latter parts of a big fixed buffer - it iterates
         * over each segment manually. We can cheat a bit here, because
         * we know that:

So if at all I could move the code inside blk_rq_map_user_iov, I will
need to see that I skip doing iov_iter_advance.

I still think it would be better to take this route only when there are
other usecases/callers of this. And that is a future thing. For the current
requirement, it seems better to prioritze efficency.

>, but that is something that could and should
>be fixed.
>
>> And it really felt cleaner to me write a new function rather than
>> overloading the blk_rq_map_user_iov with multiple if/else canals.
>
>No.  The whole point of the iov_iter is to support this "overload".

Even if I try taking that route, WARN_ON is a blocker that  prevents 
me to put this code inside blk_rq_map_user_iov.

>> But iov_iter_gap_alignment does not work on bvec iters. Line #1274 below
>
>So we'll need to fix it.

Do you see good way to trigger this virt-alignment condition? I have
not seen this hitting (the SG gap checks) when running with fixebufs.

>> 1264 unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
>> 1265 {
>> 1266         unsigned long res = 0;
>> 1267         unsigned long v = 0;
>> 1268         size_t size = i->count;
>> 1269         unsigned k;
>> 1270
>> 1271         if (iter_is_ubuf(i))
>> 1272                 return 0;
>> 1273
>> 1274         if (WARN_ON(!iter_is_iovec(i)))
>> 1275                 return ~0U;
>>
>> Do you see a way to overcome this. Or maybe this can be revisted as we
>> are not missing a lot?
>
>We just need to implement the equivalent functionality for bvecs.  It
>isn't really hard, it just wasn't required so far.

Can the virt-boundary alignment gap exist for ITER_BVEC iter in first
place? Two reasons to ask this question:

1. Commit description of this code (from Al viro) says -

"iov_iter_gap_alignment(): get rid of iterate_all_kinds()

For one thing, it's only used for iovec (and makes sense only for
those)."

2. I did not hit it so far as I mentioned above.

------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_6b63_
Content-Type: text/plain; charset="utf-8"


------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_6b63_--

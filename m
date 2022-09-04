Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99665AC597
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 19:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiIDRLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 13:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIDRLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 13:11:19 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1248632AA8
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 10:11:18 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220904171113epoutp03f2d210e26d2d8936a0cf64ece52b8c67~Rt3pUBKuV1185511855epoutp03W
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 17:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220904171113epoutp03f2d210e26d2d8936a0cf64ece52b8c67~Rt3pUBKuV1185511855epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662311473;
        bh=tsEmhgItPqXvRj7zrNCpSgjcLUOilwhKixm5RIY8Qp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lZrfaWVc8A2qGORD5tjB4ck3TCW6mH8e0Tr1oTaRc1SkknCqz5uLF0eSCuuyQHmwS
         AZqhL4q1Cy1+pMaHhggwxBTu2Y+JCSbSdpJ/QWMSs0ammfjurbgDxvACQvhBfBkGSo
         xjt7xMK0n1cj8i4Hip6Z7Iag5WkNlrp6wUcJ2K78=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220904171111epcas5p3f1bd57a4222ec35ef2aab29834c1937d~Rt3n1RXNm0778507785epcas5p3Z;
        Sun,  4 Sep 2022 17:11:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MLJ8F3Kcyz4x9Pp; Sun,  4 Sep
        2022 17:11:09 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.BB.54060.D2CD4136; Mon,  5 Sep 2022 02:11:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220904171108epcas5p24669be049be6fc1f1aedf84c2117e878~Rt3k6CxVy2324323243epcas5p2a;
        Sun,  4 Sep 2022 17:11:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220904171108epsmtrp22a16f3bbc02e786f73ab68e4b242c4fc~Rt3k5VZ6t1030310303epsmtrp2g;
        Sun,  4 Sep 2022 17:11:08 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-76-6314dc2d91be
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.DF.14392.C2CD4136; Mon,  5 Sep 2022 02:11:08 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220904171107epsmtip235d661ffe30d0acce520a98d725d9759~Rt3jv4zJE1560915609epsmtip2r;
        Sun,  4 Sep 2022 17:11:07 +0000 (GMT)
Date:   Sun, 4 Sep 2022 22:31:24 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Message-ID: <20220904170124.GC10536@test-zns>
MIME-Version: 1.0
In-Reply-To: <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmpq7uHZFkg03vRC3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpuwOHx85Zd9k9Lp8t9di0qpPNY/OSeo/d
        NxvYPPq2rGL0+LxJLoA9KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
        1VbJxSdA1y0zB+gkJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BSYFecWJucWle
        ul5eaomVoYGBkSlQYUJ2xrxNp1kKZolUHHzWz9zA+Eugi5GTQ0LAROLh9m1sXYxcHEICuxkl
        7v7cAOV8YpR4s/IYE4TzjVFi45/l7DAtk7c9Z4VI7GWU6HlzFKrqGaNE07rFTCBVLAIqEjd/
        /2TuYuTgYBPQlLgwuRQkLCKgINHzeyUbiM0ssIpRYsovaRBbWMBboqnvATOIzSugK/H64xN2
        CFtQ4uTMJywgNqeArcTVzvNgNaICyhIHth1ngjiok0Ni5UwXCNtF4uC3+8wQtrDEq+NboI6W
        kvj8bi8bhJ0scWnmOajeEonHew5C2fYSraf6mSFuy5DYdW0uC4TNJ9H7+wkTyCsSArwSHW1C
        EOWKEvcmPWWFsMUlHs5YAmV7SBzpn8UCCZJ1zBJ3bsxhnsAoNwvJO7OQrICwrSQ6PzSxzgJa
        wSwgLbH8HweEqSmxfpf+AkbWVYySqQXFuempxaYFxnmp5fA4Ts7P3cQITqRa3jsYHz34oHeI
        kYmD8RCjBAezkghvyg6RZCHelMTKqtSi/Pii0pzU4kOMpsDYmcgsJZqcD0zleSXxhiaWBiZm
        ZmYmlsZmhkrivFO0GZOFBNITS1KzU1MLUotg+pg4OKUamCwXl53PqVjzXnAm6/kmvdRcpi97
        LQo36u2JmrG/L+eeOOPK7OQHDKH/HXpNfpvFftzQ+M4vYuatIjOHx0opU71EyuuurJLtnJIR
        8ihDiaVarH+R+vlntVs6vHh3XUq3NxLd66U9tcpl5t7kfx/uzW5Z5ecjxl11bOl2jbozE/00
        8uxDkvmFVE92CEcYffad0Dn1k/7JPx6iG7f0Jxw8fc9+4rsbZqXHpqbGan2wSLjAenhdppOU
        esbh1bevO/GLannuupPze6M812zDZs99ri/ntGX3XjscKs2z9+8D1sTT2l/Y/yn+di90Udl/
        TuvX7d9Tcs9EftWdW79xw9HMUI1p9oZRq7k8vsvf2rp4ixJLcUaioRZzUXEiAFwV680tBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSvK7OHZFkg77NWhZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3YHDY+esu+wel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXx6OJ8toIzghUbe8wbGI/xdTFyckgImEhM
        3vacFcQWEtjNKHH/lwZEXFyi+doPdghbWGLlv+dANhdQzRNGiX99B5lBEiwCKhI3f/8Esjk4
        2AQ0JS5MLgUJiwgoSPT8XskGYjMLrGKUmPJLGsQWFvCWaOp7ANbKK6Ar8frjE6iZ65glHnz+
        xAiREJQ4OfMJC0SzmcS8zQ/B5jMLSEss/8cBEuYUsJW42nkebI6ogLLEgW3HmSYwCs5C0j0L
        SfcshO4FjMyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGC40JLcwfj9lUf9A4xMnEw
        HmKU4GBWEuFN2SGSLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgs
        EwenVANT6crIlKb/C57lft9cypr84otHX94C+0vqJ44a3asRe37MsznGkzFUawLvl2N1K+J2
        H1Z59VpDO6tK4efcL83upWY8G9zuzvEu7bKYkc58xKDh3Pf5mnlbRA8w1pU+fhsrv27V6o3b
        98kunr1V9K10r94DXkaTNTHX4qfo3GKQ/+K/afUW1l+fVBZ/3e/0z6Am7U/gNL33ry7Iu2lE
        XRINOBlwoNDRZ83GxSVTm71uzLo6QVrlj4XYubNhPOdan9jc/Lp0z5TJa65+MD3rwC+m+iv9
        /bFMmaWpz5qYL3X0de2R/yTE9m/+Dn7RXy2FG85fXsaWJ3Kz9+n139MO86Sf9Zpg0LX+tadq
        R8r5+5x5bUosxRmJhlrMRcWJAJupLT36AgAA
X-CMS-MailID: 20220904171108epcas5p24669be049be6fc1f1aedf84c2117e878
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_daa78_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
        <20220902151657.10766-1-joshi.k@samsung.com>
        <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
        <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
        <20220902184608.GA6902@test-zns>
        <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
        <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
        <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_daa78_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Sep 03, 2022 at 11:00:43AM -0600, Jens Axboe wrote:
>On 9/2/22 3:25 PM, Jens Axboe wrote:
>> On 9/2/22 1:32 PM, Jens Axboe wrote:
>>> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>>>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>>>> nvme passthrough to work with it.
>>>>>>>
>>>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>>>> in my setup.
>>>>>>>
>>>>>>> Without fixedbufs
>>>>>>> *****************
>>>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>>>> ^CExiting on signal
>>>>>>> Maximum IOPS=1.85M
>>>>>>
>>>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>>>
>>>>>> bdev (non pt)??? 122M IOPS
>>>>>> irq driven??? 51-52M IOPS
>>>>>> polled??????? 71M IOPS
>>>>>> polled+fixed??? 78M IOPS
>
>Followup on this, since t/io_uring didn't correctly detect NUMA nodes
>for passthrough.
>
>With the current tree and the patchset I just sent for iopoll and the
>caching fix that's in the block tree, here's the final score:
>
>polled+fixed passthrough	105M IOPS
>
>which is getting pretty close to the bdev polled fixed path as well.
>I think that is starting to look pretty good!
Great! In my setup (single disk/numa-node), current kernel shows-

Block MIOPS
***********
command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -P1 -n1 /dev/nvme0n1
plain: 1.52
plain+fb: 1.77
plain+poll: 2.23
plain+fb+poll: 2.61

Passthru MIOPS
**************
command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -P1 -u1 -n1 /dev/ng0n1
plain: 1.78
plain+fb: 2.08
plain+poll: 2.21
plain+fb+poll: 2.69


------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_daa78_
Content-Type: text/plain; charset="utf-8"


------STjx0DdB5XWzR39.p0qqcVQtF-toHyOxq53rKg1ScZo20x2r=_daa78_--

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C44A50DE11
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 12:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiDYKmY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 06:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240052AbiDYKmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 06:42:18 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95AE2DD1
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 03:39:10 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220425103905epoutp0430b1b09660b23f2fae97660e6a10603a~pHXlGdtq91032810328epoutp04j
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 10:39:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220425103905epoutp0430b1b09660b23f2fae97660e6a10603a~pHXlGdtq91032810328epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650883145;
        bh=12Zp/jvtLYYeYO9M6Rz4jawLcnXD3s03VlYLBLXv8hc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iFmEbH3fetm5NZ1QdvYRaKB9G4Sno5h8zf+KDvhXX9GAvDxScoc87agwmJrtgyAUf
         2vrBNpC4xYFHGsVmhb7R/0+KT9goDsjXU3yVFtn3gvEeGG3t8j4Xgqp/jWxpe01tPR
         5pljwlxMwoT/rRi+XE+v7XyU0c7ct0YqiV3IxlRs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220425103904epcas5p3d1d9f07db592948be8fc06ffbb9c84ba~pHXk5Vz6-3221632216epcas5p3B;
        Mon, 25 Apr 2022 10:39:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Kn1hj1kMTz4x9Q9; Mon, 25 Apr
        2022 10:39:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.2D.10063.14A76626; Mon, 25 Apr 2022 19:38:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220425103622epcas5p1c4a9ecf5980551d8ca9875eaf38b02ba~pHVNknXUv0671506715epcas5p1r;
        Mon, 25 Apr 2022 10:36:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220425103622epsmtrp11c33882b8317bcf95df0116b7a8c653a~pHVNj6D562521025210epsmtrp1b;
        Mon, 25 Apr 2022 10:36:22 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-8d-62667a412f04
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.A7.08924.6A976626; Mon, 25 Apr 2022 19:36:22 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220425103621epsmtip1879f8fec2faa0a02e23a283bde3b15ef~pHVMsTr2U2790427904epsmtip1c;
        Mon, 25 Apr 2022 10:36:21 +0000 (GMT)
Date:   Mon, 25 Apr 2022 16:01:13 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 08/12] io_uring: overflow processing for CQE32
Message-ID: <20220425103113.GA10070@test-zns>
MIME-Version: 1.0
In-Reply-To: <697c47a4-aa6c-a4e9-c2b5-5759399b9546@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTXdexKi3JoGmXrsXqu/1sFu9az7FY
        nH97mMniWN97VourLw+wO7B6TGx+x+6xc9Zddo/LZ0s9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/J
        zEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqrpFCWmFMKFApILC5W0rezKcov
        LUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOePZmIVvBYs6KDTtvMDYw
        TmXvYuTkkBAwkdhxehdbFyMXh5DAbkaJ3W1rmCGcT4wSa+/vhMp8ZpS4sfsIK0zLv8M/WSES
        uxglbr7aC1X1jFFi2t8dYINZBFQljt4+DGRzcLAJaEpcmFwKEhYRkJOYtXQ/G0iYWaBUYtYK
        NZCwsICrROf0qWwgNq+ArsSEZw+ZIWxBiZMzn7CA2JwCVhLbjj4Cmy4qoCxxYNtxJpC1EgKP
        2CVuXmhmhjjOReLUyruMELawxKvjW6D+lJJ42d8GZSdLtG6/DHaahECJxJIF6hBhe4mLe/4y
        gdjMAukSb952sUHEZSWmnloHFeeT6P39hAkiziuxYx6MrShxb9JTaPiISzycsQTK9pCYPnc3
        OyR4ljBJHDh6h20Co/wsJL/NQrIPwraS6PzQxDoLHETSEsv/cUCYmhLrd+kvYGRdxSiZWlCc
        m55abFpgmJdaDo/v5PzcTYzgRKnluYPx7oMPeocYmTgYDzFKcDArifBOVU1LEuJNSaysSi3K
        jy8qzUktPsRoCoypicxSosn5wFSdVxJvaGJpYGJmZmZiaWxmqCTOezp9Q6KQQHpiSWp2ampB
        ahFMHxMHp1QDk7728oXiej46L347xYbvZOFOlhU8MOforXv3pEte/Z80cauZSo2s076CLSFd
        poe3RfT+Lri721H3xdnvV0L+RUwpWuY68UXDgg+K/jnzFcO/P/PuEnUWXlDItvNJS9/Ojycs
        5N9NLTmik9OWdOXb+gCnab1xfNe+HNt/9yH7le4dV4/tMFRnmvzkX1mmfMO3z0dWtZw+l9R5
        VHFiK9Pds1d/iS2bcqknlffVpP3TNGdMNX59Z3H4mtAitcfHGNWPS7txrixVky3fcyD81ezi
        LqPMm2XZD4Nn3BaacfYO02Xm0ytipp++KcH69GpRcJW799ZtLAsLvv6ITn38J/xKXPmlf852
        k9cILqywSjvOv9hAiaU4I9FQi7moOBEAqTEISx0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnO6yyrQkg75twhar7/azWbxrPcdi
        cf7tYSaLY33vWS2uvjzA7sDqMbH5HbvHzll32T0uny31+LxJLoAlissmJTUnsyy1SN8ugSvj
        5Ly9bAU32CpmXpjO2MD4hKWLkZNDQsBE4t/hn6xdjFwcQgI7GCVu3d3PDpEQl2i+9gPKFpZY
        +e85O0TRE0aJF/emMoEkWARUJY7ePgyU4OBgE9CUuDC5FCQsIiAnMWvpfjaQMLNAqcSsFWog
        YWEBV4nO6VPZQGxeAV2JCc8eMkOMXMIk8b5tC1RCUOLkTIjjmAXMJOZtBikCmSMtsfwfB0iY
        U8BKYtvRR2CniQooSxzYdpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwCgvtVyvODG3
        uDQvXS85P3cTIzjAtbR2MO5Z9UHvECMTB+MhRgkOZiUR3qmqaUlCvCmJlVWpRfnxRaU5qcWH
        GKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MPVtU1zItVqzNtdg5W2ZiLtHE695e5TJ
        7loSns29jdnhcVZm/KSNNRM+hYqXafxa1xPwUtb6dMiUJavkXN3up/J8tVl9ad7D+Ktflm3V
        DhWZkXVAyS97VkuDTY+0vH/8vDevnfNPu3QY/TfgKBOurJx4ZoLPLobf7nnKWy2OL9i9It+s
        b6rFybcFx38+3yg0T6ZmpwrrzB9zeLZ/cPxjFOJhbcJuXTfvs9KBnyxrLoTHzIz4Krl/8meO
        PVHfXu9oiQh9Vf5HdF6P3gLpGZMuvdX7urh6X4/8BeNV1yQ5Wq3dTNQaIh7f3NYYdGz+XJn2
        67clQicd57u2Lmp9beMXzwyWmo4Yl4PVzzUPtDRYT1FiKc5INNRiLipOBACFYrlV3wIAAA==
X-CMS-MailID: 20220425103622epcas5p1c4a9ecf5980551d8ca9875eaf38b02ba
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_89a7_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220422223240epcas5p2e2839efa16792537d4dd9ae1fd4939e0
References: <20220420191451.2904439-1-shr@fb.com>
        <20220420191451.2904439-9-shr@fb.com>
        <CA+1E3rJVJKEjmhLzdKYjKB3UgLs334hWXaDNUN2xp92E+XR=ag@mail.gmail.com>
        <CGME20220422223240epcas5p2e2839efa16792537d4dd9ae1fd4939e0@epcas5p2.samsung.com>
        <697c47a4-aa6c-a4e9-c2b5-5759399b9546@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_89a7_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 22, 2022 at 02:27:01PM -0700, Stefan Roesch wrote:
>
>
>On 4/21/22 7:15 PM, Kanchan Joshi wrote:
>> On Thu, Apr 21, 2022 at 1:37 PM Stefan Roesch <shr@fb.com> wrote:
<snip>
>>>  static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
>>> -                                    s32 res, u32 cflags)
>>> +                                    s32 res, u32 cflags, u64 extra1, u64 extra2)
>>>  {
>>>         struct io_overflow_cqe *ocqe;
>>> +       size_t ocq_size = sizeof(struct io_overflow_cqe);
>>>
>>> -       ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
>>> +       if (ctx->flags & IORING_SETUP_CQE32)
>>
>> This can go inside in a bool variable, as this check is repeated in
>> this function.
>
>V3 will have this change.
While you are at it, good to have this changed in patch 10 too.

------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_89a7_
Content-Type: text/plain; charset="utf-8"


------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_89a7_--

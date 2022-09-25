Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD825E95BC
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 21:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiIYTxy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 15:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiIYTxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 15:53:53 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C528C2A428
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 12:53:50 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220925195347epoutp033427b55d763e6c03edfb2017ef1c225c~YMolgzbC11655116551epoutp03X
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 19:53:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220925195347epoutp033427b55d763e6c03edfb2017ef1c225c~YMolgzbC11655116551epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664135627;
        bh=LvVpg8OJnifP5V/i7FU19yQOFrvVHUcpQV/7+NtWfAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X8hOxCOPFNHms0JKKVSLqnm/J4VCUnmse1hvB7mJrktPEpMoXpG1fWvnwH7LnhDUl
         PjrPV9KQyGSCMD00QLxOrizJeWiuZLqT49bpF3MiBLwYAR7IGaE9QwaRjoydZ2UNeJ
         Ke2WsowuAHF5wJ6mbYBbx5AuuOhMVRKb6mlpnLvE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220925195347epcas5p4e52cc05f85c7e80dea1c9ae0bf7f0439~YMok5TZVI1384513845epcas5p4o;
        Sun, 25 Sep 2022 19:53:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MbGm84TDNz4x9Pt; Sun, 25 Sep
        2022 19:53:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.FC.26992.8C1B0336; Mon, 26 Sep 2022 04:53:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220925195343epcas5p2fde852fc0500fd8c1a0bf299e8cc32e5~YMohOcNxa1880518805epcas5p2r;
        Sun, 25 Sep 2022 19:53:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220925195343epsmtrp2c504ff38dc4deed1cefc7bf6eb61f9da~YMohNrc_f2554825548epsmtrp2U;
        Sun, 25 Sep 2022 19:53:43 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-ae-6330b1c8b1f1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.A0.14392.7C1B0336; Mon, 26 Sep 2022 04:53:43 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220925195342epsmtip11037673ba386e69ec989d733cb376585~YMof-n2Bj0770607706epsmtip1e;
        Sun, 25 Sep 2022 19:53:41 +0000 (GMT)
Date:   Mon, 26 Sep 2022 01:13:54 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v8 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220925194354.GA29911@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220923153819.GC21275@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmuu6JjQbJBpceKVmsvtvPZnHzwE4m
        i5WrjzJZvGs9x2Ix6dA1Rou9t7Qt5i97yu7A7nH5bKnHplWdbB6bl9R77L7ZwObRt2UVo8fn
        TXIBbFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
        hygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxM
        gQoTsjMWfdjBVLCareLIlhNsDYxLWbsYOTkkBEwkTq29B2YLCexmlPgzWb+LkQvI/sQoMaf/
        BjOE841RomvyLHaYjlXLT7NBJPYySqw/+gWq/RmjxL1FbiA2i4CqxM+VS4CKODjYBDQlLkwu
        BQmLCChJPH11lhGkl1lgOqPE3td7mEASwgLeEnPmbQFbwCugK/HtyG5WCFtQ4uTMJywgNqeA
        jsS3Nw/AakQFlCUObDvOBDJIQqCRQ+Lo2YUsENe5SFxaMB/qUmGJV8e3QNlSEp/f7WWDsJMl
        Ls08xwRhl0g83nMQyraXaD3VzwxiMwukS1w+2csKYfNJ9P5+wgTyjIQAr0RHmxBEuaLEvUlP
        ocEoLvFwxhIo20Pi3uo3rJAAuskosfT+VtYJjHKzkPwzC8kKCNtKovNDE5DNAWRLSyz/xwFh
        akqs36W/gJF1FaNkakFxbnpqsWmBYV5qOTyOk/NzNzGCk6aW5w7Guw8+6B1iZOJgPMQowcGs
        JMKbclE3WYg3JbGyKrUoP76oNCe1+BCjKTB+JjJLiSbnA9N2Xkm8oYmlgYmZmZmJpbGZoZI4
        7+IZWslCAumJJanZqakFqUUwfUwcnFINTAUhM0L2y4ow7z4UVzR3+tozV0vmnfcV6Lnzcd6l
        LadY+43iFuTF5E94cPSzXsShHRtZDzy4Z8s2zaltdYLshK8/j05qiOr7usZJ1FolbUGvkg+f
        gUfhFJ30LQcSrsl/2L5ZX2uNucgT0Qj+nCs/nCelnk5ISplyYIplxHaG4/sf3fO9evWrhPer
        YC9b3aDc9zIVL3qO7HdvzmD1/Ltmq7OJmG9U7QVN48pL4q4zHRfeKhBj1Lq+M/vgMsbe0jc7
        739LU4/esuV2UoRy3Rb+xaKfhX9MS+XgXee8h8NPS/FZnebc2LuXJ8+OO7dC+Z56icSBN7w5
        c1pXzrwceDLv7K2sDzMNspbyb97NeNd85SwlluKMREMt5qLiRAAWITf5IwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnO7xjQbJBssvcFmsvtvPZnHzwE4m
        i5WrjzJZvGs9x2Ix6dA1Rou9t7Qt5i97yu7A7nH5bKnHplWdbB6bl9R77L7ZwObRt2UVo8fn
        TXIBbFFcNimpOZllqUX6dglcGftvuRQ8YK5Ydm47SwPjF6YuRk4OCQETiVXLT7N1MXJxCAns
        ZpSYtPoUVEJcovnaD3YIW1hi5b/n7BBFTxglju1/zAySYBFQlfi5cglQNwcHm4CmxIXJpSBh
        EQEliaevzjKC1DMLTGeU2Pt6D9hQYQFviTnztoAN5RXQlfh2ZDcrxNDbjBJnvs5ihkgISpyc
        +YQFxGYWMJOYt/khM8gCZgFpieX/OEDCnAI6Et/ePACbIyqgLHFg23GmCYyCs5B0z0LSPQuh
        ewEj8ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOA40NLcwbh91Qe9Q4xMHIyHGCU4
        mJVEeFMu6iYL8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnV
        wFT0JO92w/b0TpnnHpl39D9zBafWPfSY3x24SVHhldPHhPLub14XmF3/CW1vUja4cCik8sb7
        ltn3/4m4FSVscJiWVTentthOxveySDPbmsO5YpyfZ/DMzW4JYzXRvv/sR/GSsI2fG3dO+iu/
        ZsoK93v1UosmTFnWPHPJ+htxFwXuqizJVjwid+vngdoTuYXrXQo1Vma/mhzIpBF5NOb/5wsv
        Llk+erMo64ZJwx9zB22RFdX9nX5h3Ws3R8lODvUVdX0op3dcWNW/5tiipecC2PgmZ04t7FsY
        GF/S5e/fauv/8ZvstZYbT5t2d+7xdDg7c51p/L1yWX9fRueKFJOb+lc1j53f6+VXXay1I3FL
        vRJLcUaioRZzUXEiAAK3YtHyAgAA
X-CMS-MailID: 20220925195343epcas5p2fde852fc0500fd8c1a0bf299e8cc32e5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_b8f9_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67@epcas5p3.samsung.com>
        <20220923092854.5116-4-joshi.k@samsung.com> <20220923153819.GC21275@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_b8f9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

>> +	if (ret)
>> +		goto out;
>> +	bio = req->bio;
>
>I think we can also do away with this bio local variable now.
>
>> +	if (bdev)
>> +		bio_set_dev(bio, bdev);
>
>We don't need the bio_set_dev here as mentioned last time, so I think
>we should remove it in a prep patch.

we miss completing polled io with this change.
bdev needs to be put in bio to complete polled passthrough IO.
nvme_ns_chr_uring_cmd_iopoll uses bio_poll and that in turn makes use of
this.

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_b8f9_
Content-Type: text/plain; charset="utf-8"


------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_b8f9_--

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB4A1FFA9E
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 19:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFRRzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 13:55:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21366 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgFRRzU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 13:55:20 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200618175517epoutp013e1515b3958f9c6cdb1ebb0b71f58c1d~ZtPdbP0KT2324423244epoutp01O
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 17:55:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200618175517epoutp013e1515b3958f9c6cdb1ebb0b71f58c1d~ZtPdbP0KT2324423244epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592502917;
        bh=23380seXF4LQQ6pQBR9gN9kzZCCfOnSZsPuBF4BqYIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gecGjsWKapgNOP5W6RKHoWm0KuqUCPvAu4vJz7EE+yXv6ztQLazhz5cXFwRp/jWYg
         lZH3LfZB7ndMK75aieRx9KVAGeEfCsjedmdIFHIRW737FF+1SlxOWEnlfKnaaZQajI
         acBo7DHJ2pGSpzy6wFONvzHyE8ZTq9hsBmVrPsU0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200618175516epcas5p29a72b748dda5977b80e4b76f42236c97~ZtPcrk5t40357303573epcas5p2P;
        Thu, 18 Jun 2020 17:55:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.A6.09475.48AABEE5; Fri, 19 Jun 2020 02:55:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200618175516epcas5p33a2df3fbdcfb8a78096b326fd271c292~ZtPb9BCGO0053400534epcas5p3r;
        Thu, 18 Jun 2020 17:55:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200618175516epsmtrp232287ce5a7ac7cbd3eb16c82afc8a5b3~ZtPb8KiBt2407124071epsmtrp2G;
        Thu, 18 Jun 2020 17:55:16 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-c1-5eebaa84f84f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.AC.08382.38AABEE5; Fri, 19 Jun 2020 02:55:15 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200618175514epsmtip142e1ee19f7bc182d89f085a5e6f3cff8~ZtPaGLzbt1202912029epsmtip1W;
        Thu, 18 Jun 2020 17:55:14 +0000 (GMT)
Date:   Thu, 18 Jun 2020 23:22:58 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200618175258.GA4141152@test-zns>
MIME-Version: 1.0
In-Reply-To: <20200618065634.GB24943@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7bCmhm7LqtdxBm0zTS1W3+1ns+j6t4XF
        4vSERUwW71rPsVg8vvOZ3WLKtCZGi723tC327D3JYnF51xw2i22/5zNbXJmyiNni9Y+TbBbn
        /x5ndeD12LxCy+Py2VKPTZ8msXv0bVnF6PF5k5zHpidvmQLYorhsUlJzMstSi/TtErgyVu/f
        yVRwUqDi+uyrrA2MP3i7GDk5JARMJBredrN1MXJxCAnsZpTYvPMdO4TziVHiyfduZgjnG6PE
        4ukTWGFaZj2+AFW1l1HiW+taJgjnGaNEz681TCBVLAKqEgffdwG1c3CwCWhKXJhcChIWATJv
        LW8Hm8osMJVJ4uW+p+wgCWEBB4kb82cygti8AvoSm369ZYGwBSVOznwCZnMKGEucubwKzBYV
        UJY4sO042GIJgaUcEjcvvmKCOM9F4tuepWwQtrDEq+Nb2CFsKYnP7/ZCxYslft05ygzR3MEo
        cb1hJgtEwl7i4p6/TCBXMwtkSJw9GwASZhbgk+j9/QQsLCHAK9HRJgRRrShxb9JTaKiISzyc
        sQTK9pCY1NPGCAmU/YwSdxftYZ7AKDcLyT+zEDbMAttgJdH5oYkVIiwtsfwfB4SpKbF+l/4C
        RtZVjJKpBcW56anFpgXGeanlesWJucWleel6yfm5mxjBCUvLewfjowcf9A4xMnEwHmKU4GBW
        EuF1/v0iTog3JbGyKrUoP76oNCe1+BCjNAeLkjiv0o8zcUIC6YklqdmpqQWpRTBZJg5OqQYm
        QwvJQ4kLph23Fdn6QuvWwrVz02a1nZQ1/v6mlr/P8aDWjqnycqKloQvsdRSjDY6v77TfabXd
        8Nuhbw3/Zy0+a84+5++e7rx1Olv294uVJV5cckSn3fHclCcB5pt3qi283PVNak7CjC8Hjusf
        upwddDXxzHyrEw/8Zk9f3nTxy88YLaOLpZmPMmYuXDTl61Zrj6lvVl/MjFpuIRx77foFr5B1
        P3R2f5zUbHb8vFlfsajJIW3TLqYpPgdmvWF1/y4289ATkVrTc9Ks99kW7mO6zXXrR2X8infr
        DhRmaRxTOWXv6pwddCJQYVYYD39ty6TVLabGl5ry2Zc+lm8zi5/aK64/KeS545bmiwws6c81
        XJVYijMSDbWYi4oTAfNj+SXHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnG7LqtdxBtdlLVbf7Wez6Pq3hcXi
        9IRFTBbvWs+xWDy+85ndYsq0JkaLvbe0LfbsPclicXnXHDaLbb/nM1tcmbKI2eL1j5NsFuf/
        Hmd14PXYvELL4/LZUo9Nnyaxe/RtWcXo8XmTnMemJ2+ZAtiiuGxSUnMyy1KL9O0SuDLmXprC
        VvCbt2L21kbmBsYj3F2MnBwSAiYSsx5fYO9i5OIQEtjNKHFqzipmiIS4RPO1H+wQtrDEyn/P
        oYqeMEpMeb4OLMEioCpx8H0XUAMHB5uApsSFyaUgYREg89bydrA5zALTmSQObdEHsYUFHCRu
        zJ/JCGLzCuhLbPr1lgVi5n5GieNHV7FAJAQlTs58wgLRbCYxb/NDsPnMAtISy/9xgIQ5BYwl
        zlyGKBcVUJY4sO040wRGwVlIumch6Z6F0L2AkXkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpe
        cn7uJkZwBGlp7mDcvuqD3iFGJg7GQ4wSHMxKIrzOv1/ECfGmJFZWpRblxxeV5qQWH2KU5mBR
        Eue9UbgwTkggPbEkNTs1tSC1CCbLxMEp1cC05N3jiux7uz+Fmu9l/yxll5W7Ru5nX3ir9rLm
        h9Pdoh71Gv145RIpp8zOGz519ucvBQlt4a+v+l99ofhZ9L6OwOxbLJ/6L+lZTS9JMetQMly3
        6DxPzLnlyxbf+/xonvbO5VNvxXBdKfnnl9YmYyF1a4kb65Ny/2iLZSe3LUo7v8k1wLcu4EdL
        9R4HjTKRHRpGvic3T3WJn7HBr19V/5Waj05AwAMfzrPr3Y7Mcr3AJiKwcr36nquhfhuvtq1X
        T/W5EdeTbPfwktuB/Oqfev9vh065/LPCSEpg64V/KazVjWGsx352eOnNkGqzmd9saezEFua2
        a4ltef0bGQnrvYeu+Z7YvmTyLMXCWxdXu9QqsRRnJBpqMRcVJwIAcHiaqA8DAAA=
X-CMS-MailID: 20200618175516epcas5p33a2df3fbdcfb8a78096b326fd271c292
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_77fd7_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172653epcas5p488de50090415eb802e62acc0e23d8812
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
        <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <20200618065634.GB24943@infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_77fd7_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Jun 17, 2020 at 11:56:34PM -0700, Christoph Hellwig wrote:
>On Wed, Jun 17, 2020 at 10:53:36PM +0530, Kanchan Joshi wrote:
>> This patchset enables issuing zone-append using aio and io-uring direct-io interface.
>>
>> For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses start LBA
>> of the zone to issue append. On completion 'res2' field is used to return
>> zone-relative offset.
>>
>> For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
>> Since io_uring does not have aio-like res2, cqe->flags are repurposed to return zone-relative offset
>
>And what exactly are the semantics supposed to be?  Remember the
>unix file abstractions does not know about zones at all.
>
>I really don't think squeezing low-level not quite block storage
>protocol details into the Linux read/write path is a good idea.

I was thinking of raw block-access to zone device rather than pristine file
abstraction. And in that context, semantics, at this point, are unchanged
(i.e. same as direct writes) while flexibility of async-interface gets
added.
Synchronous-writes on single-zone sound fine, but synchronous-appends on
single-zone do not sound that fine.

>What could be a useful addition is a way for O_APPEND/RWF_APPEND writes
>to report where they actually wrote, as that comes close to Zone Append
>while still making sense at our usual abstraction level for file I/O.

Thanks for suggesting this. O and RWF_APPEND may not go well with block
access as end-of-file will be picked from dev inode. But perhaps a new
flag like RWF_ZONE_APPEND can help to transform writes (aio or uring)
into append without introducing new opcodes.
And, I think, this can fit fine on file-abstraction of ZoneFS as well.

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_77fd7_
Content-Type: text/plain; charset="utf-8"


------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_77fd7_--

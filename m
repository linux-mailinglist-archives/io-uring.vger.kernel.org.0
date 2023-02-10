Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFFA692677
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjBJTfk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJTfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:35:39 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CC879B23
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:35:35 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230210193532epoutp03da307e212355b53707da45c286a37702~CjaCkcofq1617116171epoutp033
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:35:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230210193532epoutp03da307e212355b53707da45c286a37702~CjaCkcofq1617116171epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676057732;
        bh=QRJipme6J3lSlFJV65VND4e1UK2pqN97VDu9bCfwHaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hs32x2QAHfLRSFjzAbZhvpG1wVQbxZYfknOsfnZU2V3td9t6lz+SrU8e1vPn5WHf4
         yxogVVIKFuIedRhgNYX4658VuBJQ8l/Sz0W4dHwq0mo0vdOVx22nlfNZrh6IeGXb8O
         SG3EPSttkSttBYHreV0fDvIj+cJmmJ6NoCtIjKuQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230210193531epcas5p4feeb8942232dd2e18b0153648e32303f~CjaCH18Wr1842618426epcas5p4K;
        Fri, 10 Feb 2023 19:35:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4PD3qQ1p3tz4x9Pp; Fri, 10 Feb
        2023 19:35:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.7D.10528.28C96E36; Sat, 11 Feb 2023 04:35:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230210193529epcas5p29956db1ace003a9a8cce0f192139797d~CjZ-5vK2-2892928929epcas5p2C;
        Fri, 10 Feb 2023 19:35:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230210193529epsmtrp10bb6c2a5a204de883ce398c7203ace86~CjZ-5AnXY0414904149epsmtrp1w;
        Fri, 10 Feb 2023 19:35:29 +0000 (GMT)
X-AuditID: b6c32a49-c17ff70000012920-65-63e69c8230e9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.37.17995.18C96E36; Sat, 11 Feb 2023 04:35:29 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230210193527epsmtip291a6ffd0fa6cef23f4a44ad4dcc62cc6~CjZ_PeVcI3022730227epsmtip2O;
        Fri, 10 Feb 2023 19:35:27 +0000 (GMT)
Date:   Sat, 11 Feb 2023 01:04:59 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Message-ID: <20230210193459.GA9184@green5>
MIME-Version: 1.0
In-Reply-To: <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmum7TnGfJBj92cVisvtvPZjHtw09m
        i5WrjzJZvGs9x2Ix6dA1Rou9t7Qt5i97ym6x7/VeZotDk5uZHDg9Ll/x9rh8ttRj06pONo/N
        S+o9Jt9Yzuix+2YDm8f7fVfZPD5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
        NbS0MFdSyEvMTbVVcvEJ0HXLzAG6TUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJT
        YFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnTFp8xe2gldcFXNnP2ZuYJzC2cXIySEhYCJxovkN
        axcjF4eQwG5GiZ4p3SwgCSGBT4wSD28pQdifGSXe3TeHaXh87R4TRMMuRol1WxZCOU8YJfoW
        nGYDqWIRUJVYd20zYxcjBwebgKbEhcmlIGERAQ2Jbw+Ws4DUMwscZZTY8/4tWL2wgL3Eidvz
        GUFsXgEtiedHTzFD2IISJ2c+AbuIU8BaYuvEW+wgtqiAssSBbceZIC7awiFxbaYzhO0i8XfN
        ZEYIW1ji1fEt7BC2lMTL/jYoO1ni0sxzUL0lEo/3HISy7SVaT/WD7WUWyJDYt/w0E4TNJ9H7
        +wkTyC8SArwSHW1CEOWKEvcmPWWFsMUlHs5YAmV7SLzc+4ANEib7GCUm3nzJPoFRbhaSd2Yh
        WQFhW0l0fmhihbDlJZq3zmaeBbSOWUBaYvk/DghTU2L9Lv0FjGyrGCVTC4pz01OLTQsM81LL
        4dGdnJ+7iRGccLU8dzDeffBB7xAjEwfjIUYJDmYlEd5Km2fJQrwpiZVVqUX58UWlOanFhxhN
        gVE1kVlKNDkfmPLzSuINTSwNTMzMzEwsjc0MlcR51W1PJgsJpCeWpGanphakFsH0MXFwSjUw
        lbi0cl3fdknjzW/HQsaC+UsrFnT0P7l87eOTFzc/iGXEv7KxqXXN2dw5OXGZul++o/YM5pyf
        k+dHyCWGZR38167I8qZjx9sPbYtmNEX/YOi+fG7vunb9JLUixY+hwfMPfy9lni48O8Kw0e0Z
        g73PUZY+zbuiD8xC21Zv+sHM7d125NDKh5V95zKnZ857O8voRljT5/xtul756RZnvjL4Tfa+
        4fr9aY64QW1jxoKetrOhN+WKV2so9xhU+Kte9Nl3Rn/+DnHGoCrJa3MTn1x8sLMywVOuKWJb
        UMaGCNGuol1OzJrujC92bPZhmrk4YofP17wLOYt+Red8YOx6FKqvYXqz4N7hxrfHopcf5GFT
        YinOSDTUYi4qTgQAEjM62UEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXrdxzrNkg+2nZC1W3+1ns5j24Sez
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZbfY93ovs8Whyc1MDpwel694e1w+W+qxaVUnm8fm
        JfUek28sZ/TYfbOBzeP9vqtsHp83yQVwRHHZpKTmZJalFunbJXBlfLx7iq3gN3vF1zc9TA2M
        h9i6GDk5JARMJB5fu8cEYgsJ7GCU+N/hBBEXl2i+9oMdwhaWWPnvOZDNBVTziFFixr5msASL
        gKrEumubGbsYOTjYBDQlLkwuBQmLCGhIfHuwnAWknlngKKNE14dLzCAJYQF7iRO35zOC2LwC
        WhLPj55ihhi6j1Hiy42rzBAJQYmTM5+wgNjMAmYS8zY/ZAZZwCwgLbH8HwdEWF6ieetssHJO
        AWuJrRNvgd0jKqAscWDbcaYJjEKzkEyahWTSLIRJs5BMWsDIsopRMrWgODc9t9iwwCgvtVyv
        ODG3uDQvXS85P3cTIzi6tLR2MO5Z9UHvECMTB+MhRgkOZiUR3kqbZ8lCvCmJlVWpRfnxRaU5
        qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MNWkf/z98/nG409VT0d9d3afPuno
        g1/cn+4cT0xbsefstNpj2lbrbx+eudiRuffa17llfQf3VjYmr1j57tfWnfvs1H+UVOaKCJ0x
        KUu6fM7OxjJocUzy4dQ5BvMW527IyTp0QkdlRePP1A0bz8Xp70pLX1U7e6oQi47s1UsnL945
        uWfz/N9nSqKs+HOnqVf9kGX23q76QnxS3CXxk3+/mZm1nf9W5rNGin/vybg9AosnlUxLNlsr
        /PaGxeEDP6Jsv1Xt15P+NsnicH0a57cnf1Q6V//8Y/OB+9uJ3V0fuj98LZ6U7d54IeXFKc4V
        t8vP7fB8csms8XKWuG6qsEyvXX1Ez8fTTacvnDHST+l7wS5rpMRSnJFoqMVcVJwIAPwYw7Ed
        AwAA
X-CMS-MailID: 20230210193529epcas5p29956db1ace003a9a8cce0f192139797d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_54827_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
        <20230210180033.321377-1-joshi.k@samsung.com>
        <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_54827_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Fri, Feb 10, 2023 at 10:18:08AM -0800, Bart Van Assche wrote:
>On 2/10/23 10:00, Kanchan Joshi wrote:
>>3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
>>with block IO path, last year. I imagine plumbing to get a bit simpler
>>with passthrough-only support. But what are the other things that must
>>be sorted out to have progress on moving DMA cost out of the fast path?
>
>Are performance numbers available?

Around 55% decline when I checked last (6.1-rcX kernel).
512b randread IOPS with optane, on AMD ryzen 9 box -
when iommu is set to lazy (default config)= 3.1M
when iommmu is disabled or in passthrough mode = 4.9M

>Isn't IOMMU cost something that has already been solved? From https://www.usenix.org/system/files/conference/atc15/atc15-paper-peleg.pdf: 
>"Evaluation of our designs under Linux shows that (1)
>they achieve 88.5%–100% of the performance obtained
>without an IOMMU".

Since above numbers are more recent than the paper, this is yet to be
solved.

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_54827_
Content-Type: text/plain; charset="utf-8"


------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_54827_--

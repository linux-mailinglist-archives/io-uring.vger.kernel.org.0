Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92956EF5F1
	for <lists+io-uring@lfdr.de>; Wed, 26 Apr 2023 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbjDZOCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 10:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbjDZOCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 10:02:44 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA126585
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 07:02:42 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230426140240epoutp03ab69c8430555355fe0e03c185ccbfec0~ZgP0MxrwA1490014900epoutp03Q
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 14:02:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230426140240epoutp03ab69c8430555355fe0e03c185ccbfec0~ZgP0MxrwA1490014900epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682517760;
        bh=7H9YCbjd9MhlvEbMlqXNKGqVo3fBsOUktQtVoNzUtxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iL8zMzMf7RA49Y4KsvuUipBTBOXHLSOAUWUkC7zBZo085ZsKBUUJD7m31PwiSQIQC
         Nkv1RNBzfGqcqIY/ahOZvrEOi73QzbFl5QgVFVo5PEDHM1chsh3k+a6cuBbtgr82Fn
         5Tp4crB3vSznn2BpayyM+vIPQnYWgoSAS+1XTJ2w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230426140239epcas5p35f07a50744a929e999809adc3dba8e93~ZgP0Clbqv2589225892epcas5p3J;
        Wed, 26 Apr 2023 14:02:39 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Q60tj61vhz4x9Pr; Wed, 26 Apr
        2023 14:02:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.B6.54880.DFE29446; Wed, 26 Apr 2023 23:02:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230426140236epcas5p1a26c92fbcf03bc6df9eb64307524b27c~ZgPxL_DL02071820718epcas5p1I;
        Wed, 26 Apr 2023 14:02:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230426140236epsmtrp13224275b3a8f3a8dd1beeae345716b5c~ZgPxLOfrp3248432484epsmtrp1M;
        Wed, 26 Apr 2023 14:02:36 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-07-64492efdec66
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.10.28392.CFE29446; Wed, 26 Apr 2023 23:02:36 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230426140235epsmtip22ff2ea3d4831b6e4a237e7afaeb8953b~ZgPwT47Z51069410694epsmtip2q;
        Wed, 26 Apr 2023 14:02:35 +0000 (GMT)
Date:   Wed, 26 Apr 2023 19:29:37 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: another nvme pssthrough design based on nvme hardware queue
 file abstraction
Message-ID: <20230426135937.GA27829@green245>
MIME-Version: 1.0
In-Reply-To: <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmpu5fPc8Ug7f9Khar7/azWaxcfZTJ
        4l3rORaLvbe0LTb9PcnkwOpx+Wypx86Hlh67bzaweXzeJBfAEpVtk5GamJJapJCal5yfkpmX
        bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0VEmhLDGnFCgUkFhcrKRvZ1OUX1qS
        qpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQndH26hpjwUPWip7t0xkbGP+w
        dDFyckgImEi0vDvK3MXIxSEksJtR4sKzPrCEkMAnRokXn2IgEp8ZJX4++8cK07H8fh8bRGIX
        o8Tb/q9Q7c8YJc60HGAGqWIRUJX4OHEj0CgODjYBTYkLk0tBwiICphLNc6YygtjMApUSc750
        MoHYwgLREgvndoC18groSmxuXc8GYQtKnJz5BOwiTgFXiSXTZoMdISqgLHFg23EmkL0SAo/Y
        JW6/mMwGcZ2LxK8pW6BsYYlXx7ewQ9hSEi/726DsZIlLM88xQdglEo/3HISy7SVaT/UzQxyX
        IbHlQy87hM0n0fv7CRPILxICvBIdbUIQ5YoS9yY9hQaKuMTDGUtYIUo8JN7vl4QEyQxGifO/
        TjJPYJSbheSdWUg2QNhWEp0fmlhnAbUzC0hLLP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFh
        Xmo5PIqT83M3MYJToZbnDsa7Dz7oHWJk4mA8xCjBwawkwstb6Z4ixJuSWFmVWpQfX1Sak1p8
        iNEUGDsTmaVEk/OByTivJN7QxNLAxMzMzMTS2MxQSZxX3fZkspBAemJJanZqakFqEUwfEwen
        VAPTplcH7j4rurV26neG8h1bmw1UK0OOJe/xSIkrn+N9MIRd3O9ASMaTU2l+5y80zphss/CP
        aW2P50XrvIcrp+3kWHP1znLrOd/KF84z4gtylJvEKDjDszhZ+/TD9HtZHFa34nR39NV9fHd8
        weQblwRyarien7cs+maZJ/fVpz6ggXWmn/6lzGlhzW8abWa8TPuzJe3jp4RzF+RnmhYphZq9
        sdN7s0M7RYKn71LQtt8vt8elJdn3T5NVNzx2m9G/8bab9tQnSlfP3LlbKu1tkcFxRe1p/OId
        xwK1OZczeyjZnN5fKzwr8a9zRjNr+nLHY51/Ji7u4g8+eptj7ZTpG3+8upZd5KaSzil15NTX
        H1sLlViKMxINtZiLihMBvx+b8Q4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvO4fPc8Ugw0/9SxW3+1ns1i5+iiT
        xbvWcywWe29pW2z6e5LJgdXj8tlSj50PLT1232xg8/i8SS6AJYrLJiU1J7MstUjfLoEr48/V
        bYwFk5kr7vz7ztzAeIKpi5GTQ0LARGL5/T62LkYuDiGBHYwSZ3vvskIkxCWar/1gh7CFJVb+
        e84OUfSEUeJy2yNGkASLgKrEx4kbWboYOTjYBDQlLkwuBQmLCJhKNM+ZClbCLFApMW36XzYQ
        W1ggWuLB5j9gcV4BXYnNreuhFs9glJiz+wIrREJQ4uTMJywQzWYS8zY/ZAaZzywgLbH8HwdI
        mFPAVWLJtNlg5aICyhIHth1nmsAoOAtJ9ywk3bMQuhcwMq9ilEwtKM5Nzy02LDDKSy3XK07M
        LS7NS9dLzs/dxAgOby2tHYx7Vn3QO8TIxMF4iFGCg1lJhJe30j1FiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqaDbtcLjJwfFU1/rON3o/Y9W7H51GnM
        6exs3jN3JN8+8mfHR/861o4LDxMKowrzivvb9b5y/z/09vNe8bce09XDLvqZZx5kuscWoym4
        5+jvmrmeaa/LK33CJP5dvPK0/GzmirO+l+fKPdt3S3bh3+nhIQf8ev3DJvNH7rou9UOJ08F2
        kaaams/XOD/5wJ1PtGY5Oi3blPd8wZbzM53sL/SzikySCV2QGZXVtK/y88tPZ7Rv2n6YuCL4
        4Jrb6cJpR5RFnryTmHL8O+MKgY71e6TC01S3pTZ+FmxL2X5cLHHr//vzt8UYpE3bFSZ+XfH5
        jjnfimXUtq+vXrnuxVPZWUvS9q8tuKV46ZOCklTycadqJZbijERDLeai4kQAKDQ91d4CAAA=
X-CMS-MailID: 20230426140236epcas5p1a26c92fbcf03bc6df9eb64307524b27c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----fzg6GfPKCulTz7v5vTU-rVtg6j3uQrp2-IaGXZnwsLp_SU4m=_49f7d_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230426132010epcas5p4ad551f7bdebd6841e2004ba47ab468b3
References: <CGME20230426132010epcas5p4ad551f7bdebd6841e2004ba47ab468b3@epcas5p4.samsung.com>
        <24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------fzg6GfPKCulTz7v5vTU-rVtg6j3uQrp2-IaGXZnwsLp_SU4m=_49f7d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Apr 26, 2023 at 09:19:57PM +0800, Xiaoguang Wang wrote:

Good to see this.
So I have a prototype that tries to address some of the overheads you
mentioned. This was briefly discussed here [1], as a precursor to LSFMM.

PoC is nearly in shape. I should be able to post in this week.

[1] fourth point at
https://lore.kernel.org/linux-nvme/20230210180033.321377-1-joshi.k@samsung.com/


------fzg6GfPKCulTz7v5vTU-rVtg6j3uQrp2-IaGXZnwsLp_SU4m=_49f7d_
Content-Type: text/plain; charset="utf-8"


------fzg6GfPKCulTz7v5vTU-rVtg6j3uQrp2-IaGXZnwsLp_SU4m=_49f7d_--

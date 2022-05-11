Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E3052323B
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 13:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiEKLzc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 07:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbiEKLza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 07:55:30 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9F02438E4
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 04:55:26 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220511115523epoutp04b78f805f0106f2247e51e46fa05e4d69~uCuxYV-GC2151421514epoutp04L
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 11:55:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220511115523epoutp04b78f805f0106f2247e51e46fa05e4d69~uCuxYV-GC2151421514epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652270123;
        bh=2iyrq5sIsranNJ02bVz6Y7KtTldZpomoP9ARwhiQXQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MXZ+aqEFNeX0c/d61WVDMAQvjQdsBQSTu7NJcP3kD5umx5F8Lwj7lL3TtI/zlB46L
         fgRy7WTzHTmuxc3h4QXOcIJ/ds6nNvTUK3MyQ82aIIajm94Jv+XrbjCYJNbHhAsQUu
         zc0kJteaWiG08lfa/1T7jFFwtz9quG4vf8Yh9d/c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511115522epcas5p1befe8b4196378da1ce921cbb26c0bc3e~uCuw0o2Rd0579805798epcas5p1f;
        Wed, 11 May 2022 11:55:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KytdK6H4Lz4x9Q1; Wed, 11 May
        2022 11:55:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.BA.09762.224AB726; Wed, 11 May 2022 20:55:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220511111033epcas5p142bf1a2af129b0af4d1af5c1587fa82c~uCHoeB_ME3135431354epcas5p1C;
        Wed, 11 May 2022 11:10:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511111033epsmtrp10e302b626217457979ce730f747e5008~uCHobGBah2788427884epsmtrp1p;
        Wed, 11 May 2022 11:10:33 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-89-627ba42220fd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.C5.08924.9A99B726; Wed, 11 May 2022 20:10:33 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220511111032epsmtip10fa011b5caa3371c43f253e33b7160b1~uCHm0dm812452724527epsmtip1H;
        Wed, 11 May 2022 11:10:31 +0000 (GMT)
Date:   Wed, 11 May 2022 16:35:21 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 6/6] io_uring: finish IOPOLL/ioprio prep handler
 removal
Message-ID: <20220511110521.GA22243@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220511065423.GA814@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmuq7Skuokg6d3VSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRmXbZKQmpqQWKaTm
        JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
        synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzui818pSsJm1YsHl
        q2wNjOdZuhg5OSQETCSuTFvA3sXIxSEksJtRYsquv8wQzidGiafbdjNBOJ8ZJebOaIVr6Zly
        Byqxi1Hi4L7fbBDOM6D+I6sZQapYBFQl2re2AA3m4GAT0JS4MLkUJCwioCTx9NVZRpB6ZoEH
        jBKPmvewgySEBQIlXn1tZAap5xXQldjxnBckzCsgKHFy5hOwxZwCWhLbHr1lA7FFBZQlDmw7
        DnaEhMAODolFq6YzQ1znInFsyhsmCFtY4tXxLewQtpTEy/42KDtZonX7ZbDbJARKJJYsUIcI
        20tc3PMXrJVZIEPiyqpbUGNkJaaeWgcV55Po/f0EKs4rsWMejK0ocW/SU1YIW1zi4YwlULaH
        xNU5qxgh4XOTUWLLs+2sExjlZyH5bRaSfRC2lUTnhybWWUDnMQtISyz/xwFhakqs36W/gJF1
        FaNkakFxbnpqsWmBcV5qOTzCk/NzNzGC07KW9w7GRw8+6B1iZOJgPMQowcGsJMK7v68iSYg3
        JbGyKrUoP76oNCe1+BCjKTCqJjJLiSbnAzNDXkm8oYmlgYmZmZmJpbGZoZI476n0DYlCAumJ
        JanZqakFqUUwfUwcnFINTH5yE90jeNyF7rW1zrklcFT/7oLn7U+7p+rM+WeyQePUxa5TiRu/
        zJJZEPOkLqG2ZG5wn0jvdtWfvVL7Gm4kCW1leG1o+nXu8k9OijPYjeyPMtxsm7tm48t1X/s7
        N2+wOH2L9/aUnl8fNjInnfnyi22yWfv9/y1XIraVJP8P/LX59l1m0dKCjR0Hl/3byr6VR1wt
        a91Ppzec38w//p9nmJpoHb4vYKeIfJ97z49GVXcLd8u/Tx48LWq4opjcPKdq7Zk2ngWSoerv
        XVbEr7LzElplvkmvlG9O4hs/xjN3QuJrJd8pRluu9G/c/WdPJduq7d+D911s8s9eHjrD0Dos
        KObdw3iFOT/jypfujdUVYFNiKc5INNRiLipOBAA1aRTSVAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTnflzOokg77POhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyPr/VLHjKVDH3wSK2BsbZTF2MnBwSAiYSPVPuANlcHEICOxglXm94yAqREJdovvaDHcIW
        llj57zk7RNETRomjJ+eygSRYBFQl2re2ACU4ONgENCUuTC4FCYsIKEk8fXWWEaSeWeABo0Tn
        xV1g24QFAiVefW1kBqnnFdCV2PGcF2LmbUaJS18ngy3mFRCUODnzCQuIzSxgJjFv80OwemYB
        aYnl/zhAwpwCWhLbHr0FO0FUQFniwLbjTBMYBWch6Z6FpHsWQvcCRuZVjJKpBcW56bnFhgVG
        eanlesWJucWleel6yfm5mxjB0aSltYNxz6oPeocYmTgYDzFKcDArifDu76tIEuJNSaysSi3K
        jy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFJt2eG3suOcgu27HkJn+5r
        MT87VC6nGb5qecyL+yrT5izij3OwkzHWvbl7h1y777/Zu2JuBae4O/2aHCQ87/zfZftT7x8q
        PHVu6a3tCp0PT5nqHda8dOde+yK1vLUabp9Wx54T3xl54FZN+roIoSs+zVNz7L84P7O7I7rL
        aXVQp0V+Q7/cliVbNzsslSkOE/hw/qVpU0Qtr7zr/IMVMz2ey8griV9TahU40lO6I/fvR2cj
        Xb/kX0/fSIpvOLTnwPqXAeW3DytNVmPbmrzI8ETYgcaO3D9nmr69c1qjsPbgKqPMJRcC/kw+
        tFK3o+bDsWRfvmOO09o6lRif3n+09Fp27+J5f+XXXjJ0/Ch9zu5ijRJLcUaioRZzUXEiAHwR
        ylMVAwAA
X-CMS-MailID: 20220511111033epcas5p142bf1a2af129b0af4d1af5c1587fa82c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_6171a_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9@epcas5p2.samsung.com>
        <20220511054750.20432-7-joshi.k@samsung.com> <20220511065423.GA814@lst.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_6171a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, May 11, 2022 at 08:54:23AM +0200, Christoph Hellwig wrote:
>I think this should go first, and the uring_cmd bits need to do the
>right thing from the beginning.

so this patch should do what it does but only for xattr/socket.
And then it should move down to the point before uring-cmd.
Jens - let me know if you want me to iterate with that.

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_6171a_
Content-Type: text/plain; charset="utf-8"


------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_6171a_--

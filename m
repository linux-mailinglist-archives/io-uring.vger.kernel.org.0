Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4550EFBB
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 06:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiDZEXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 00:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243422AbiDZEXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 00:23:46 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C09AE4F
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 21:20:35 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220426042029epoutp04a1c958618bfb4f853e569d3c4040db4b~pV2Tf141e0735607356epoutp04C
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 04:20:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220426042029epoutp04a1c958618bfb4f853e569d3c4040db4b~pV2Tf141e0735607356epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650946829;
        bh=XS8nGwe0hJ+bjZHzU4NMlblUvq2K9HT6fzLFBjwvvS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S9p4IBe6gu7ZalONGDdvc7q5CvDZBJQV4sVpEOYB7y1OHSBSrMVXX7uEl05MeEPU8
         YE7R16Y4bVi6Ix5Xu8MO26fs4iZLSdys1ertVEOexiJRQ1eeF/EpCrTL8/aY8AFPR7
         yGzVUxUPAXmJydcz6uAetPaivrrT1sbCONtb1FIQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220426042028epcas5p26d912b97d06a7be67ce964d95080ee07~pV2SmfAG52381123811epcas5p2I;
        Tue, 26 Apr 2022 04:20:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KnTFP3dXhz4x9Px; Tue, 26 Apr
        2022 04:20:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.59.10063.90377626; Tue, 26 Apr 2022 13:20:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220425174312epcas5p48b4400537f5672f3c12d2902701d2979~pNJ5BY_ks0038500385epcas5p4x;
        Mon, 25 Apr 2022 17:43:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220425174312epsmtrp10d8899a35ce7fbae1169de299920cfc0~pNJ5ArZXD1652516525epsmtrp1U;
        Mon, 25 Apr 2022 17:43:12 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-3c-62677309d736
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.36.08853.0BDD6626; Tue, 26 Apr 2022 02:43:12 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220425174311epsmtip265a32f96054e01ed323faaa884d8c63d~pNJ3blbRr1243312433epsmtip2H;
        Mon, 25 Apr 2022 17:43:10 +0000 (GMT)
Date:   Mon, 25 Apr 2022 23:08:03 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220425173803.GA2454@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220423175309.GC29219@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmhi5ncXqSwcmZ/BZNE/4yW8xZtY3R
        YvXdfjaLlauPMlm8az3HYtF5+gKTxfm3h5ks5i97ym5xY8JTRotDk5uZLNbcfMriwO2xc9Zd
        do/mBXdYPC6fLfXYtKqTzWPzknqP3Tcb2Dze77vK5tG3ZRWjx+dNcgGcUdk2GamJKalFCql5
        yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDHKimUJeaUAoUCEouLlfTt
        bIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM1ZveMVacJO3onvr
        euYGxjncXYycHBICJhI7Huxl72Lk4hAS2M0oceTeM1YI5xOjxJnVM1lAqoQEvjFKrLrmANMx
        88wTRoiivYwS09cuYINwnjFK3O36zQRSxSKgKrF3+yGgKg4ONgFNiQuTS0HCIgJKEk9fnQVr
        Zhb4xiSx9f1esHphgUCJrl8rGUFsXgEdiW0LrkPZghInZz4Bu4ITKD7nzGlWEFtUQFniwLbj
        TCCDJAR2cEgcWNHECHGei8T7GSegbGGJV8e3sEPYUhIv+9ug7GSJ1u2X2UGOkxAokViyQB0i
        bC9xcc9fsHuYBdIl3r96A1UuKzH11DqoOJ9E7+8nTBBxXokd82BsRYl7k56yQtjiEg9nLIGy
        PSROL58ADa0vzBKdxycxT2CUn4Xkt1lI9kHYVhKdH5pYZwGdxywgLbH8HweEqSmxfpf+AkbW
        VYySqQXFuempxaYFhnmp5fAIT87P3cQITstanjsY7z74oHeIkYmD8RCjBAezkgjvVNW0JCHe
        lMTKqtSi/Pii0pzU4kOMpsC4msgsJZqcD8wMeSXxhiaWBiZmZmYmlsZmhkrivKfTNyQKCaQn
        lqRmp6YWpBbB9DFxcEo1MIVO6FDoeuJk8EL01vGTMXMXvFw25VLMevnX3Rt1BO6ldFTlzhMz
        PcK5UWh90Lui8qm7Hj9VvX+Ro/iG0HyDvYe/HV89v91dx35nxpG8jj0Lgs9edQt8tqln8/FP
        uS8bdx26+qr2qaZN/WpvjdnaTGFGX1eG71qaodHQ2yeQIaccznLZ5peg/OL2rFlRau1nHng5
        WeQLyy5j0tHWzhfe/fmm3Xq5+ipGicSf92x2aX80qZL6vu/8s5Mn3xvV5taet9oi12TEkn1w
        iY/f7iuBYvqdJdmvT1RN1VO33qfC+fVzdta7qIN/HvdGs618fojRIMNG0mrVa+5T705YrDcz
        9j0SsCBLzHh7YsHalvJdr5VYijMSDbWYi4oTAXAHmt5UBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXnfD3bQkg4V71SyaJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyXh3fylrQx13x7utdpgbG1xxdjJwcEgImEjPPPGHsYuTiEBLYzSjx68MtFoiEuETztR/s
        ELawxMp/z9khip4wSqxftBCsiEVAVWLv9kNA3RwcbAKaEhcml4KERQSUJJ6+Ogs2lFngF5PE
        xsNn2EASwgKBEl2/VjKC2LwCOhLbFlyH2vyNWeLGu1usEAlBiZMzn4AtYBYwk5i3+SEzyAJm
        AWmJ5f/AruYE6p1z5jRYuaiAssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVMLinPTc4sNCwzz
        Usv1ihNzi0vz0vWS83M3MYIjSktzB+P2VR/0DjEycTAeYpTgYFYS4Z2qmpYkxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9O+C+93/nnrYHuDP/PfwhMT
        DopeeMbzLDl12sFXB2Yl3xH6KXv/jltSyM9I9tDVzM+PZP0tPdUU8vp8/9FTynxhvZy+2rde
        zXC8X/Bjs+0xpd68hxusjV/fvMDp9JPHWXRFoP53ifdP13AyzVnJ6he29vY344KuTrsg2RLu
        c4sTVuqcDL1cUWJ8cHrnNxPDqNffkto1ts/8WPfKeeLkd3qscfoHzvM6stbnmv2NnXh/SrDl
        TzZpzvuiU2+Xn1z+2S6q7/ab/15HDBaq6NyTbI06PCl5WZKckNnJU2HS/NnCzs+ffTDteHKi
        ev9Pu+MnV/9oeKf5WVaZjy1BUuTcUp/wK1VGHWrP8yKm9WhvZ7ykxFKckWioxVxUnAgAemvW
        +hcDAAA=
X-CMS-MailID: 20220425174312epcas5p48b4400537f5672f3c12d2902701d2979
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_a2bc_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
        <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de>
        <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
        <20220405060224.GE23698@lst.de>
        <CA+1E3rJXrUnmc08Zy3yO=0mGJv1q0CaJez4eUDnTpaJcSh_1FQ@mail.gmail.com>
        <CA+1E3rK3EzyNVwPEuR3tJfRGvScwwrDhxAc9zs=a5XMc9trpmg@mail.gmail.com>
        <20220423175309.GC29219@lst.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_a2bc_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Apr 23, 2022 at 07:53:09PM +0200, Christoph Hellwig wrote:
>On Wed, Apr 06, 2022 at 10:50:14AM +0530, Kanchan Joshi wrote:
>> > In that case we will base the newer version on its top.
>> But if it saves some cycles for you, and also the travel from nvme to
>> linux-block tree - I can carry that refactoring as a prep patch in
>> this series. Your call.
>
>FYI, this is what I have so far:
>
>http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/nvme-passthrough-refactor
>
>the idea would be to use these lower level helpers for uring, and
>not really share the higher level function at all.  This does create
>a little extra code, but I think it'll be more modular and better
>maintainable.  Feel free to pull this in if it helps you, otherwise
>I'll try to find some time to do more than just light testing and
>will post it.

Thanks for sharing.
So I had picked your previous version, and this one streamlines meta
handling further. But the problem is bip gets freed before we reach to
this point -

+static int nvme_free_user_metadata(struct bio *bio, void __user *ubuf, int ret)
+{
+       struct bio_integrity_payload *bip = bio_integrity(bio);
+       void *buf = bvec_virt(bip->bip_vec);
+
+       if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
+           copy_to_user(ubuf, buf, bip->bip_vec->bv_len))

Without bip, we cannot kill current meta/meta_len fields.


------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_a2bc_
Content-Type: text/plain; charset="utf-8"


------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_a2bc_--

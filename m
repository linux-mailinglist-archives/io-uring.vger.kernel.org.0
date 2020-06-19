Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53085200589
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 11:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgFSJl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 05:41:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47992 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731699AbgFSJlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 05:41:55 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200619094150euoutp01c521b98ef2450c976e93504ed137d4a7~Z6J5801eC0472704727euoutp01V
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 09:41:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200619094150euoutp01c521b98ef2450c976e93504ed137d4a7~Z6J5801eC0472704727euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592559710;
        bh=PLuLOAyQS6GaPUTrSfpe9L/E6wCKGkltfo+WP36l8Fg=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=JsHM7gpQTOjafbK5l5y/6Ej3hCMrsDWuJMujPbX44Oxt+VdunkT3DSMKtxPtMTxPG
         971oASn/if2//u5asEU4r/J5bxfQfbG7ow8J69Fo7PJdfiUNvxCBSCmbhmd6YBUN4G
         yYDS+wiF5T1dOQDTJp90lQUWidGNYiFD5VHdzFVI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200619094150eucas1p146321d7bf58830d23c3a47dd759b277e~Z6J50BBcd2327423274eucas1p1L;
        Fri, 19 Jun 2020 09:41:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 52.06.05997.E588CEE5; Fri, 19
        Jun 2020 10:41:50 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200619094150eucas1p1858cf1aec415333241db3783fa605307~Z6J5Z2F2q2312223122eucas1p1e;
        Fri, 19 Jun 2020 09:41:50 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200619094150eusmtrp12170cdfaeae5375f92933590b74e9873~Z6J5ZMBjB0475004750eusmtrp1R;
        Fri, 19 Jun 2020 09:41:50 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-ac-5eec885e81d6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 12.43.06017.D588CEE5; Fri, 19
        Jun 2020 10:41:49 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200619094149eusmtip15ea23c5fbad9d9f120ee82735e9198bc~Z6J5QuY721898318983eusmtip1r;
        Fri, 19 Jun 2020 09:41:49 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) by
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
        Server (TLS) id 15.0.1320.4; Fri, 19 Jun 2020 10:41:49 +0100
Received: from localhost (106.110.32.47) by CAMSVWEXC01.scsc.local
        (106.1.227.71) with Microsoft SMTP Server (TLS) id 15.0.1320.4 via Frontend
        Transport; Fri, 19 Jun 2020 10:41:49 +0100
Date:   Fri, 19 Jun 2020 11:41:49 +0200
From:   "javier.gonz@samsung.com" <javier@javigon.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Message-ID: <20200619094149.uaorbger326s6yzz@mpHalley.local>
MIME-Version: 1.0
In-Reply-To: <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7djP87pxHW/iDBoWyVisvtvPZtH1bwuL
        RWv7NyaLd63nWCymTGtitNh7S9tiz96TLBaXd81hszj/9zirA6fH5bOlHps+TWL3+LxJzqP9
        QDeTx6Ynb5kCWKO4bFJSczLLUov07RK4Mp49b2EpmCpRseNXE3MD4ySRLkZODgkBE4mn3dsZ
        uxi5OIQEVjBKbDxyCsr5wihx//A9NgjnM6NE0+tN7DAt214eZ4ZILGeUeHD7AStc1d09P6D6
        zzBK9PycCZXZC+QsW8EE0s8ioCrRvvw82Cw2oFl/T05gBbFFBLQklu17B9bALLCXRWLmqgcs
        XYwcHMICdhL3vtuCmLwCNhLvJ+qDlPMKCEqcnPkErIJTwFbi8iFjkE4JgUPsEj1XF7OCxCUE
        XCSmXPeEuFpY4tXxLVAfyEicntzDAmIzC2RIPLv5ixUi7igx+/kTqFY+iRtvBSFK+CQmbZvO
        DBHmlehoE4KoVpPY0bSVESIsI/F0jQJE2EPi6tur7BB/32aWuLVmBesERrlZSG6ehWQxhG0l
        0fmhCcjmALKlJZb/44AwNSXW79JfwMi6ilE8tbQ4Nz212CgvtVyvODG3uDQvXS85P3cTIzDx
        nP53/MsOxl1/kg4xCnAwKvHwvgh5HSfEmlhWXJl7iFGCg1lJhNfp7Ok4Id6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rzGi17GCgmkJ5akZqemFqQWwWSZODilGhh1F8oGrJETXrU9awZjg/xJyf6J
        qq6bJtowvWZ5lHlcYdOWu213ZHoCri53eqb7scLJc6nxoiu5KmH3e4MVODhs/lwxktm5ufDL
        zR9pH72OL70rsaXTl4fvWf/CRtEp+ccN5ks9u3pebenXQyH2N7fVNshOnu0m9HhN7vat17ve
        Nb75l/H/wnVPJZbijERDLeai4kQAS+iUdDgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t/xu7qxHW/iDGY32lqsvtvPZtH1bwuL
        RWv7NyaLd63nWCymTGtitNh7S9tiz96TLBaXd81hszj/9zirA6fH5bOlHps+TWL3+LxJzqP9
        QDeTx6Ynb5kCWKP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0Mq5tXMpccFy0YvXbJtYGxnuCXYycHBICJhLbXh5n7mLk4hASWMoo0dO9nwkiISPx
        6cpHdghbWOLPtS42iKKPjBLTvx9jgXDOMEp82rOfDaRKSGAvo0TLVz0Qm0VAVaJ9+Xmwbjag
        FX9PTmAFsUUEtCSW7XvHCtLMLLCXRWLBhadADgeHsICdxL3vtiAmr4CNxPuJ+hDzbzNLnLq9
        GuwiXgFBiZMzn7CA2MwCFhIz559nBKlnFpCWWP6PA8TkFLCVuHzIeAKj0CwkDbOQNMxCaFjA
        yLyKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMNK2Hfu5ZQdj17vgQ4wCHIxKPLwvQl7HCbEm
        lhVX5h5ilOBgVhLhdTp7Ok6INyWxsiq1KD++qDQntfgQoynQ9xOZpUST84FJIK8k3tDU0NzC
        0tDc2NzYzEJJnLdD4GCMkEB6YklqdmpqQWoRTB8TB6dUA6P08SR1FQWf6tvXd6maupxmsYj9
        teSA3P3uMk+v8K9rL8r86VLJffzxYHjclUmr1T78//lru9ajma8K5k01DIp13xLMd1Rt2xTb
        OCapEGHzrQ8sFnPOcT6trcT2vHZJ5j0rzq0RByPebcjtu2lze/nM8MQZovdffNAxWbmQ03ha
        p/f1piUn5txXYinOSDTUYi4qTgQAhvhDhcoCAAA=
X-CMS-MailID: 20200619094150eucas1p1858cf1aec415333241db3783fa605307
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_d8758_"
X-RootMTR: 20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
        <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
        <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
        <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
        <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_d8758_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

Jens,

Would you have time to answer a question below in this thread?

On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>On 18.06.2020 08:47, Damien Le Moal wrote:
>>On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>
>>>>>Introduce three new opcodes for zone-append -
>>>>>
>>>>>   IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>>>>>   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>
>>>>>Repurpose cqe->flags to return zone-relative offset.
>>>>>
>>>>>Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>---
>>>>> fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>
>>>>>diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>index 155f3d8..c14c873 100644
>>>>>--- a/fs/io_uring.c
>>>>>+++ b/fs/io_uring.c
>>>>>@@ -649,6 +649,10 @@ struct io_kiocb {
>>>>> 	unsigned long		fsize;
>>>>> 	u64			user_data;
>>>>> 	u32			result;
>>>>>+#ifdef CONFIG_BLK_DEV_ZONED
>>>>>+	/* zone-relative offset for append, in bytes */
>>>>>+	u32			append_offset;
>>>>
>>>>this can overflow. u64 is needed.
>>>
>>>We chose to do it this way to start with because struct io_uring_cqe
>>>only has space for u32 when we reuse the flags.
>>>
>>>We can of course create a new cqe structure, but that will come with
>>>larger changes to io_uring for supporting append.
>>>
>>>Do you believe this is a better approach?
>>
>>The problem is that zone size are 32 bits in the kernel, as a number of sectors.
>>So any device that has a zone size smaller or equal to 2^31 512B sectors can be
>>accepted. Using a zone relative offset in bytes for returning zone append result
>>is OK-ish, but to match the kernel supported range of possible zone size, you
>>need 31+9 bits... 32 does not cut it.
>
>Agree. Our initial assumption was that u32 would cover current zone size
>requirements, but if this is a no-go, we will take the longer path.

Converting to u64 will require a new version of io_uring_cqe, where we
extend at least 32 bits. I believe this will need a whole new allocation
and probably ioctl().

Is this an acceptable change for you? We will of course add support for
liburing when we agree on the right way to do this.

Thanks,
Javier

------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_d8758_
Content-Type: text/plain; charset="utf-8"


------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_d8758_--

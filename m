Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D0020BB40
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 23:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFZVSR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 17:18:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44099 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZVSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 17:18:17 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200626211814epoutp04b9d02fb87ac631f8c2182a545eba9d74~cNK7_07g41726217262epoutp04R
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 21:18:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200626211814epoutp04b9d02fb87ac631f8c2182a545eba9d74~cNK7_07g41726217262epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593206294;
        bh=SZTI3b2MpeXCFJcN29/uKoXauk27veSOn9r9Lck5MGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M0xqz8l/JqsO8zpxEKsAjI+XmEk2ALQloQWWNmYdX3NhYKk/HEhNB3yekT1oHC562
         h/6KxOk7DFROwmVAPRnS4tPYRFHxmNOt4bvWz6dpRdP1pjQbMrgIr+FLd2TIBSMFhr
         9enh9jHSH4c29Ome+0x9+G8udpizz8nekb68jaGM=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200626211813epcas5p4d1fb4de9488e3a8a82fdbc44edf341f6~cNK6tn31a2499124991epcas5p4t;
        Fri, 26 Jun 2020 21:18:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.AA.09467.41666FE5; Sat, 27 Jun 2020 06:18:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200626211812epcas5p37e1748b113b3cccd4ce512bb5d772d17~cNK5xqFVU1921319213epcas5p3D;
        Fri, 26 Jun 2020 21:18:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626211811epsmtrp1eaa3529ab746d616963554d9e83bc917~cNK5wbGYj1468814688epsmtrp1x;
        Fri, 26 Jun 2020 21:18:11 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-83-5ef666143a4c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.F5.08382.31666FE5; Sat, 27 Jun 2020 06:18:11 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200626211809epsmtip20bf4db3e61e6a6ba5bd72cd1609895c3~cNK3W04j92794627946epsmtip2a;
        Fri, 26 Jun 2020 21:18:09 +0000 (GMT)
Date:   Sat, 27 Jun 2020 02:45:14 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        asml.silence@gmail.com, Damien.LeMoal@wdc.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Message-ID: <20200626211514.GA24762@test-zns>
MIME-Version: 1.0
In-Reply-To: <20200626085846.GA24962@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7bCmuq5I2rc4g0+LTC1+b3vEYvF7+hRW
        izmrtjFarL7bz2bR9W8Li0Vr+zcmi9MTFjFZvGs9x2Lx+M5ndosp05oYLfbe0rbYs/cki8Xl
        XXPYLFZsP8Jise33fGaLK1MWMVu8/nGSzeL83+OsDkIeO2fdZffYvELL4/LZUo9Nnyaxe3Rf
        /cHo0bdlFaPH501yHu0Hupk8Nj15yxTAGcVlk5Kak1mWWqRvl8CV0fJ0B1vBW5GKe+0nmRoY
        Twh0MXJySAiYSCxZ1M7excjFISSwm1Fi7domJgjnE6NE4/ljUJlvjBJn+38zwrQs2ncRqmov
        o8TRnVOYIZxnjBL/Nh1lB6liEVCVmNz6C6iKg4NNQFPiwuRSkLAIkHlreTtYPbPATyaJ199/
        sYPUCAskSKz97AlSwyugKzHpzgkWCFtQ4uTMJ2A2p4CxRP/EF8wgtqiAssSBbcfBjpAQeMMh
        sejONajrXCQu/9vGCmELS7w6voUdwpaSeNnfBmUXS/y6c5QZormDUeJ6w0wWiIS9xMU9f8GO
        ZhbIkDi4TgckzCzAJ9H7+wlYWEKAV6KjTQiiWlHi3qSnUKvEJR7OWAJle0gc29/PBgmTX4wS
        sz6uZJvAKDcLyT+zEDbMAttgJdH5oYkVIiwtsfwfB4SpKbF+l/4CRtZVjJKpBcW56anFpgWG
        eanlesWJucWleel6yfm5mxjB6U/Lcwfj3Qcf9A4xMnEwHmKU4GBWEuH9bP0tTog3JbGyKrUo
        P76oNCe1+BCjNAeLkjiv0o8zcUIC6YklqdmpqQWpRTBZJg5OqQam8G+vXnpOE5rTO68xk7tl
        6vaJj6VD5b6/F5LR/dUY37FyCrc20xUmS2uT8IBXMr67pL3/Ma9ZfrpAI4O5Ryt6dVD1ZKu1
        7B1L5Dmj47Q1psTdKpw4zfFdzS7Vqdu2GGjs9qh59+V8D1tOSc+Jd+3S7750s3Cu+rTd9fRU
        l+ag1u2BbQ0af5/cc2XfufnwGzfh1tIPnj7Nx2+f//r4j7vMdZ7q+NYe4aMvJsZ+zy29VXhZ
        +1VkQ8Ced0KHGXzmuTxJNeNr++7pbJW5fg7fTf7aoxnv3i5u+K1d4a4itKGu13/+1p5Hgfpx
        vlF3Fp2/VCWgfdy4YLq2entauHpv8g37Tee2Fr8v/jxF7PzbB5eUWIozEg21mIuKEwEon/gt
        7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvK5w2rc4g8/XzCx+b3vEYvF7+hRW
        izmrtjFarL7bz2bR9W8Li0Vr+zcmi9MTFjFZvGs9x2Lx+M5ndosp05oYLfbe0rbYs/cki8Xl
        XXPYLFZsP8Jise33fGaLK1MWMVu8/nGSzeL83+OsDkIeO2fdZffYvELL4/LZUo9Nnyaxe3Rf
        /cHo0bdlFaPH501yHu0Hupk8Nj15yxTAGcVlk5Kak1mWWqRvl8CVsfLnBpaC+UIVUzs6WRsY
        p/B1MXJySAiYSCzad5Gpi5GLQ0hgN6PEioZT7BAJcYnmaz+gbGGJlf+es0MUPWGUOPL4HxtI
        gkVAVWJy6y+gbg4ONgFNiQuTS0HCIkDmreXtzCD1zAK/mSQeXJnPClIjLJAgsfazJ0gNr4Cu
        xKQ7J1ggZv5ilFj96DU7REJQ4uTMJywgNrOAmcS8zQ+ZQXqZBaQllv/jAAlzChhL9E98wQxi
        iwooSxzYdpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cT
        IzgmtTR3MG5f9UHvECMTB+MhRgkOZiUR3s/W3+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ894o
        XBgnJJCeWJKanZpakFoEk2Xi4JRqYArPkCz+I3j7qOPEbbcruw1/5L3b01n+WH/ZS6anTgb/
        N/S7Rz1guKh+PUOO89vRpd43r26p+3J0N4tvve6rIp6z13/Pdd9XGpGu9LR951vJayu9pngp
        z9V8Y+8QcuVq6h57/fePd6U7BL5VmPm6JvRAsdKy0q9Kl34cd0zoVp6/wm9uqKv7p5/HhBzb
        9nJ/vHD564HL8l8+Xyh/EB7UGWLstOeKfeW8cucXdr/Pv6jZemFqSxZL8/lncosd3zzL3lXK
        7WWbuj7kvFlPy8JTYdKH26b6e80Kinjb8dC4OOSgmUnW1urdVwNt7q/sXbDFf0uTon7kLuXb
        syKXP85o9a+OZtv8cV2n6MywOp5lp7cosRRnJBpqMRcVJwIAwZRrwTgDAAA=
X-CMS-MailID: 20200626211812epcas5p37e1748b113b3cccd4ce512bb5d772d17
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_9f048_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
        <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
        <20200626085846.GA24962@infradead.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_9f048_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 09:58:46AM +0100, Christoph Hellwig wrote:
>To restate my previous NAK:
>
>A low-level protocol detail like RWF_ZONE_APPEND has absolutely no
>business being exposed in the Linux file system interface.
>
>And as mentioned before I think the idea of returning the actual
>position written for O_APPEND writes totally makes sense, and actually
>is generalizable to all files.  Together with zonefs that gives you a
>perfect interface for zone append.
>
>On Thu, Jun 25, 2020 at 10:45:48PM +0530, Kanchan Joshi wrote:
>> Introduce RWF_ZONE_APPEND flag to represent zone-append.
>
>And no one but us select few even know what zone append is, nevermind
>what the detailed semantics are.  If you add a userspace API you need
>to very clearly document the semantics inluding errors and corner cases.

For block IO path (which is the scope of this patchset) there is no
probelm in using RWF_APPEND for zone-append, because it does not do
anything for block device. We can use that, avoiding introduction of
RWF_ZONE_APPEND in user-space.

In kernel, will it be fine to keep IOCB_ZONE_APPEND apart from
IOCB_APPEND? Reason being, this can help to isolate the code meant only
for zone-append from the one that is already present for conventional
append.

Snippet from quick reference -

static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
        ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
        if (flags & RWF_APPEND)
                ki->ki_flags |= IOCB_APPEND;
+       if (flags & RWF_ZONE_APPEND) {
+               /* currently support block device only */
+               umode_t mode = file_inode(ki->ki_filp)->i_mode;
+
+               if (!(S_ISBLK(mode)))
+                       return -EOPNOTSUPP;
+               ki->ki_flags |= IOCB_ZONE_APPEND;
+       }


As for file I/O in future, I see a potential problem with RWF_APPEND.
In io_uring, zone-append requires bit of pre/post processing, which
ideally should be done only for zone-append case. A ZoneFS file using
RWF_APPEND as a mean to invoke zone-append vs a regular file (hosted on
some other FS) requiring conventional RWF_APPEND - both will execute
that processing.
Is there a good way to differentiate ZoneFS file from another file which
only wants use conventional file-append?

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_9f048_
Content-Type: text/plain; charset="utf-8"


------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_9f048_--

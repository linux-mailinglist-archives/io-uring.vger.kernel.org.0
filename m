Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1361A20AC67
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFZGhW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 02:37:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49374 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbgFZGhV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 02:37:21 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200626063718euoutp025bdd9ad8faf643e7d1c9dded86eaf99e~cBJyVGnCs2023420234euoutp02i
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 06:37:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200626063718euoutp025bdd9ad8faf643e7d1c9dded86eaf99e~cBJyVGnCs2023420234euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593153438;
        bh=DnZOg1QeKK+sJhQGxvuZAvm5j0AMbgRSaX4I7sGDGTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uXSuWRwkZc1FAkdAffl68KGNWoOYnh0gdLbalwLbGP0MY93c5B/JGodeexQF40QI+
         8qqvJ6Xo4eqsbbIgx89OkSGQvyoi/W4P1NXS4/HIgyjiuP9LaFBNh2cRwr1/EnHjs2
         zqBSFB+sZLGjIT6aVHJbVl+0qVpZA0KutxvaQBY4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200626063718eucas1p2a84fa9bbca86171bcbd8de1083067ebc~cBJyCn_ix1479414794eucas1p2t;
        Fri, 26 Jun 2020 06:37:18 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F4.0D.06318.E9795FE5; Fri, 26
        Jun 2020 07:37:18 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200626063718eucas1p1748b6bfd48ebf2ed3ef42a2bea39572e~cBJxvLHOk2881428814eucas1p1l;
        Fri, 26 Jun 2020 06:37:18 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626063718eusmtrp15400fa0e3ac6e179d02120ef7bc31ee6~cBJxpa0H72146421464eusmtrp1U;
        Fri, 26 Jun 2020 06:37:18 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-37-5ef5979e13ff
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 10.B8.06314.D9795FE5; Fri, 26
        Jun 2020 07:37:17 +0100 (BST)
Received: from localhost (unknown [106.210.248.142]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200626063717eusmtip10454345fafa276d58565a934f8d16afa~cBJxdPiAB2513525135eusmtip1W;
        Fri, 26 Jun 2020 06:37:17 +0000 (GMT)
Date:   Fri, 26 Jun 2020 08:37:17 +0200
From:   "javier.gonz@samsung.com" <javier.gonz@samsung.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Message-ID: <20200626063717.4dhsydpcnezjhj3o@mpHalley.localdomain>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTURiAObsfu7NW11n4lpEwCcrIsiKvpX1H90dB4D9Ba+ZtSk7H1iwT
        QSy11KazyFrObFiOOcymWInaGjab00VYYoEgWJHWLD8WM221eQ3897wfz3vOezgUJhkj1lOZ
        2Rc4VbYsS0qG4O2OOfe2uhpv6o6f9nCm1tyOmKaRSpIp87fhTHHpLwHjqjIKmMliN868+ush
        mVu3ixDT9XEr09nlxJnBjlqSMT3twZn2+fsY883nJJk3f3qJg6vZ5/oRIdtqimYHBzSsdbpa
        yJa/9yFW22ZG7Ix1I1tqKxew1k8ewSlRckhCOpeVmcuptu8/E5Ixaj6rrN98qefOQ1SIvkWW
        IREF9G4YvTKJl6EQSkKbEHQ6dGSwIKFnEUz9OMcXZhD0236j/0bJE4uQLzQiaBqeFfDBOIJC
        c/GijtObwNJQKgwySceD7+NbLMhr6Gh41D1JBAWMthFQMja02BRGH4GBaRceZDF9GO7pvSTP
        oeC8+2kxL6JT4MVLw6IM9JQQ5vs+CPk7HQXtvHWJw2Cit22JN4DrZgXOC1cCS1jeYXxQgWCh
        2hTYiAoE+0DbnxUUMDoTjAavgJcPQZv/O8m3rIJhTyjfsgqq22swPi2GayUSHjdBnXcFL0ZA
        d2EnyTMLQzrd0vtOIHDcMKAqFKlftpp+2cE874XrP4sIfWAsFpjV6Kd43AKPO7bXI8KMwjmN
        WiHn1LuyuYsxaplCrcmWx5zNUVhR4Ou5/L3eZ6h7Ic2OaApJV4ptutlUCSHLVecp7AgoTLpG
        fHjAlSoRp8vyLnOqnNMqTRantqMICpeGi3cZx1MktFx2gTvPcUpO9b8qoETrC5Hu5LovcsEJ
        wwG9LP6mxtbs5zyxBRbj8PjxDy19daVf4ojjUY0NP24rE42ZGBU35MgXpQw/S3q41qv9erXr
        c6vTfqhVuYd7vS55LjQp78iZyoRqTfH3irX4bkMi0dNScKxCO0hJPjco3b4Jf/4D9+yl5r4Z
        MmpMkbzT6pxMU0lxdYYsNhpTqWX/AE+ZHjR2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xu7pzp3+NM2juM7eYs2obo8Xqu/1s
        Fl3/trBYtLZ/Y7I4PWERk8W71nMsFkf/v2WzmDKtidFi7y1tiz17T7JYXN41h81ixfYjLBbb
        fs9ntnj94ySbxfm/x1kd+D12zrrL7rF5hZbH5bOlHps+TWL36L76g9Gjb8sqRo/Pm+Q82g90
        M3lsevKWKYAzSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1
        SN8uQS/j7eb5TAXnVStev9vN1sC4RbaLkZNDQsBEom3jGvYuRi4OIYGljBLz13UBORxACWmJ
        y19UIWqEJf5c62KDqHnOKPHt9xlGkASLgKrEmiXt7CA2m4ClxI9bF5lBbBEBLYll+96xgjQw
        CxxjlZhyZhJYQljAWeLsp9MsIDavgJPE7Flfoaa+YpR48HsiVEJQ4uTMJ2A2s4CZxLzND5lB
        LmIGumj5Pw6QMKdArMT+g3NZJzAKzELSMQtJxyyEjgWMzKsYRVJLi3PTc4sN9YoTc4tL89L1
        kvNzNzECo3PbsZ+bdzBe2hh8iFGAg1GJh/fAxC9xQqyJZcWVuYcYJTiYlUR4nc6ejhPiTUms
        rEotyo8vKs1JLT7EaAoMgInMUqLJ+cDEkVcSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1
        OzW1ILUIpo+Jg1OqgTFb+JvUQvurfxXk5t3+IbY+RKLX9pVuk3j8ld/dV9yn1U6//SetIi0x
        vF946a7vh2efi2L5q71NjFnyB4+61OUj0mk2dvNUN9pp/qv7+G3Tx/SSluWGfc82Rt5O09rW
        327ybvXEczP+dpSVfAr4INeekKisVf5ZouudUVb33uhDuqUT1N6yPFBiKc5INNRiLipOBADx
        VMTW5AIAAA==
X-CMS-MailID: 20200626063718eucas1p1748b6bfd48ebf2ed3ef42a2bea39572e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_11cc87_"
X-RootMTR: 20200625171829epcas5p268486a0780571edb4999fc7b3caab602
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200625171829epcas5p268486a0780571edb4999fc7b3caab602
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
        <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_11cc87_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 26.06.2020 03:11, Damien Le Moal wrote:
>On 2020/06/26 2:18, Kanchan Joshi wrote:
>> [Revised as per feedback from Damien, Pavel, Jens, Christoph, Matias, Wilcox]
>>
>> This patchset enables zone-append using io-uring/linux-aio, on block IO path.
>> Purpose is to provide zone-append consumption ability to applications which are
>> using zoned-block-device directly.
>>
>> The application may specify RWF_ZONE_APPEND flag with write when it wants to
>> send zone-append. RWF_* flags work with a certain subset of APIs e.g. uring,
>> aio, and pwritev2. An error is reported if zone-append is requested using
>> pwritev2. It is not in the scope of this patchset to support pwritev2 or any
>> other sync write API for reasons described later.
>>
>> Zone-append completion result --->
>> With zone-append, where write took place can only be known after completion.
>> So apart from usual return value of write, additional mean is needed to obtain
>> the actual written location.
>>
>> In aio, this is returned to application using res2 field of io_event -
>>
>> struct io_event {
>>         __u64           data;           /* the data field from the iocb */
>>         __u64           obj;            /* what iocb this event came from */
>>         __s64           res;            /* result code for this event */
>>         __s64           res2;           /* secondary result */
>> };
>>
>> In io-uring, cqe->flags is repurposed for zone-append result.
>>
>> struct io_uring_cqe {
>>         __u64   user_data;      /* sqe->data submission passed back */
>>         __s32   res;            /* result code for this event */
>>         __u32   flags;
>> };
>>
>> Since 32 bit flags is not sufficient, we choose to return zone-relative offset
>> in sector/512b units. This can cover zone-size represented by chunk_sectors.
>> Applications will have the trouble to combine this with zone start to know
>> disk-relative offset. But if more bits are obtained by pulling from res field
>> that too would compel application to interpret res field differently, and it
>> seems more painstaking than the former option.
>> To keep uniformity, even with aio, zone-relative offset is returned.
>
>I am really not a fan of this, to say the least. The input is byte offset, the
>output is 512B relative sector count... Arg... We really cannot do better than
>that ?
>
>At the very least, byte relative offset ? The main reason is that this is
>_somewhat_ acceptable for raw block device accesses since the "sector"
>abstraction has a clear meaning, but once we add iomap/zonefs async zone append
>support, we really will want to have byte unit as the interface is regular
>files, not block device file. We could argue that 512B sector unit is still
>around even for files (e.g. block counts in file stat). Bu the different unit
>for input and output of one operation is really ugly. This is not nice for the user.
>

You can refer to the discussion with Jens, Pavel and Alex on the uring
interface. With the bits we have and considering the maximun zone size
supported, there is no space for a byte relative offset. We can take
some bits from cqe->res, but we were afraid this is not very
future-proof. Do you have a better idea?


>>
>> Append using io_uring fixed-buffer --->
>> This is flagged as not-supported at the moment. Reason being, for fixed-buffer
>> io-uring sends iov_iter of bvec type. But current append-infra in block-layer
>> does not support such iov_iter.
>>
>> Block IO vs File IO --->
>> For now, the user zone-append interface is supported only for zoned-block-device.
>> Regular files/block-devices are not supported. Regular file-system (e.g. F2FS)
>> will not need this anyway, because zone peculiarities are abstracted within FS.
>> At this point, ZoneFS also likes to use append implicitly rather than explicitly.
>> But if/when ZoneFS starts supporting explicit/on-demand zone-append, the check
>> allowing-only-block-device should be changed.
>
>Sure, but I think the interface is still a problem. I am not super happy about
>the 512B sector unit. Zonefs will be the only file system that will be impacted
>since other normal POSIX file system will not have zone append interface for
>users. So this is a limited problem. Still, even for raw block device files
>accesses, POSIX system calls use Byte unit everywhere. Let's try to use that.
>
>For aio, it is easy since res2 is unsigned long long. For io_uring, as discussed
>already, we can still 8 bits from the cqe res. All  you need is to add a small
>helper function in userspace iouring.h to simplify the work of the application
>to get that result.

Ok. See above. We can do this.

Jens: Do you see this as a problem in the future?

[...]

Javier

------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_11cc87_
Content-Type: text/plain; charset="utf-8"


------S-rmtJXel8VGy5BRhJETGRpDn59uh3J63auyVoMdzEU6LuX2=_11cc87_--

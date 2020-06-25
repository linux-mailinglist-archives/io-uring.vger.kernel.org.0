Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5020A3D5
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 19:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406699AbgFYRSh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 13:18:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38720 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404404AbgFYRSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 13:18:36 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200625171832epoutp0143c480e86f41b801ac25b7478a963464~b2QXOr8lD1996019960epoutp01Z
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 17:18:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200625171832epoutp0143c480e86f41b801ac25b7478a963464~b2QXOr8lD1996019960epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593105512;
        bh=e1UqTC42OgOEeURf7nmkwWqj9cfZtAkWqrw5aq0Mhtw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=MTbK/UqfwnrIintISo0Qq9F5oWQw/2ViUmpbYJmx9zb2/uOmtjc90l7/Zz726eHkL
         fDrqAwndH0PGjEMHlrYYWUbbsK8iqdVueRYug+9qMXuqgA/OuABeDHki8+atmxM7pB
         pySPpxmm5Yyk/VM9w+jOC3o/q6YTlF7IVzY5tkoE=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200625171830epcas5p193baf1ccde11b9d8242203f667294d34~b2QV5xku11015710157epcas5p1z;
        Thu, 25 Jun 2020 17:18:30 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.33.09467.66CD4FE5; Fri, 26 Jun 2020 02:18:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200625171829epcas5p268486a0780571edb4999fc7b3caab602~b2QUuXNpR2484524845epcas5p2K;
        Thu, 25 Jun 2020 17:18:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200625171829epsmtrp18d779d7491e2a3427a39cd2050bf1022~b2QUtjpYj1577615776epsmtrp1G;
        Thu, 25 Jun 2020 17:18:29 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-3e-5ef4dc66819a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.77.08382.56CD4FE5; Fri, 26 Jun 2020 02:18:29 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200625171826epsmtip20eb790a1bfe3be2f7ce238420f3475ec~b2QSSxx4q1929119291epsmtip2c;
        Thu, 25 Jun 2020 17:18:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     asml.silence@gmail.com, Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 0/2] zone-append support in io-uring and aio
Date:   Thu, 25 Jun 2020 22:45:47 +0530
Message-Id: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWy7bCmlm7anS9xBlOPqVn8nj6F1WLOqm2M
        Fqvv9rNZdP3bwmLR2v6NyeL0hEVMFu9az7FYPL7zmd3i6P+3bBZTpjUxWuy9pW2xZ+9JFovL
        u+awWazYfoTFYtvv+cwWV6YsYrZ4/eMkm8X5v8dZHYQ8ds66y+6xeYWWx+WzpR6bPk1i9+i+
        +oPRo2/LKkaPz5vkPNoPdDN5bHrylimAM4rLJiU1J7MstUjfLoEr40vrB9aC58oVv2/uYG5g
        XCDTxcjJISFgIrFsxnzmLkYuDiGB3YwSt54th3I+MUose7qCFcL5xigxc+4iFpiWIzefM0Ik
        9gIlWpayQTifGSW2XmoEauHgYBPQlLgwuRTEFBGwkdi5RAWkhFngCpPE8xmzWUEGCQvYS/y7
        d40NpIZFQFXi/GQ2kDCvgLNE85/JULvkJG6e6wS7SEJgLofE8bbFTBAJF4kFRy5B2cISr45v
        YYewpSRe9rdB2cUSv+4chWruYJS43jATaqq9xMU9f5lAFjMD3bl+lz5ImFmAT6L39xOwsIQA
        r0RHmxBEtaLEvUlPWSFscYmHM5ZA2R4S1yZOBJsoJBArsexQE/sERplZCEMXMDKuYpRMLSjO
        TU8tNi0wzEst1ytOzC0uzUvXS87P3cQITjdanjsY7z74oHeIkYmD8RCjBAezkghviNunOCHe
        lMTKqtSi/Pii0pzU4kOM0hwsSuK8Sj/OxAkJpCeWpGanphakFsFkmTg4pRqYqkzeCHtnfpy5
        +qrGJ19Dbcdu3ryN5nIbzqr1qE2foFhT1ntmuSxDRcd0fW9miRu2KstnMRzwfCPEfkQoZ/Xl
        OsaekweSvf1uHSh9Zsa15FN/2z313Yc2qjxW61C+v1dd4XBRkYBymdL0xj/bt6y/0cVZa3jS
        6NDlGUe45wiaW382X2quqKndM3VrTciD/fuXPnDWvBh5JvxamlC9Bc/2SVtFryW+SVxho/Bu
        lotf7c8XKvsmuFS7aoRNial8oP6h7YVJkV9hqZrsskL36e9OdSxZo/8g6QrL+3v+t3Iq1cKu
        ZJ1QsHn60VYv3aRSXdeFcX76q6n3ln35sFKh+vLclPhQ9Yf3rj6Qj/l0/0mlEktxRqKhFnNR
        cSIAlrSUF6YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvG7qnS9xBpcvi1v8nj6F1WLOqm2M
        Fqvv9rNZdP3bwmLR2v6NyeL0hEVMFu9az7FYPL7zmd3i6P+3bBZTpjUxWuy9pW2xZ+9JFovL
        u+awWazYfoTFYtvv+cwWV6YsYrZ4/eMkm8X5v8dZHYQ8ds66y+6xeYWWx+WzpR6bPk1i9+i+
        +oPRo2/LKkaPz5vkPNoPdDN5bHrylimAM4rLJiU1J7MstUjfLoEr40vrB9aC58oVv2/uYG5g
        XCDTxcjJISFgInHk5nPGLkYuDiGB3YwSnTd/sEMkxCWar8HYwhIr/z1nhyj6yChx/fEBli5G
        Dg42AU2JC5NLQWpEBBwkuo4/ZgKpYRZ4wiTR+W0jI0hCWMBe4t+9a2wg9SwCqhLnJ7OBhHkF
        nCWa/0xmgZgvJ3HzXCfzBEaeBYwMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgoNa
        S3MH4/ZVH/QOMTJxMB5ilOBgVhLhDXH7FCfEm5JYWZValB9fVJqTWnyIUZqDRUmc90bhwjgh
        gfTEktTs1NSC1CKYLBMHp1QDU/sBh6LDARe/XHAz2ris3Znx3cS8xX/9NsxJ2aFabpt/eLbV
        S/bF/i9WVtcd+ZXUX/7/ZdXhDFXnpZuXv2vq/PRnJ8cyJ9O4ldznY75MX1sn+FvOPn3BLP/n
        m2+t9m403FnE6SI/KeLdrt/Cikm7WXMO/vo237dNSst3XvHtBx6BOqkXnUMTHtlEPLMq2vx+
        0a6VG+6UuzT+vjNvEY/O/NNG5zbmzThr3HU+rWOqIq9BgfoL9cOrik6snbUzbHfbg3ufTGZc
        Wej37/ohYfnYQp37l3YxTtZaJBYrmqQ8N+Coe9VKRduUvZs4T+24Gv/jg8DePJ2NTbcnPdtf
        sv/wFD+xol0RB9d0H9H8WNsiabRJiaU4I9FQi7moOBEAsInSN9kCAAA=
X-CMS-MailID: 20200625171829epcas5p268486a0780571edb4999fc7b3caab602
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171829epcas5p268486a0780571edb4999fc7b3caab602
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[Revised as per feedback from Damien, Pavel, Jens, Christoph, Matias, Wilcox]

This patchset enables zone-append using io-uring/linux-aio, on block IO path.
Purpose is to provide zone-append consumption ability to applications which are
using zoned-block-device directly.

The application may specify RWF_ZONE_APPEND flag with write when it wants to
send zone-append. RWF_* flags work with a certain subset of APIs e.g. uring,
aio, and pwritev2. An error is reported if zone-append is requested using
pwritev2. It is not in the scope of this patchset to support pwritev2 or any
other sync write API for reasons described later.

Zone-append completion result --->
With zone-append, where write took place can only be known after completion.
So apart from usual return value of write, additional mean is needed to obtain
the actual written location.

In aio, this is returned to application using res2 field of io_event -

struct io_event {
        __u64           data;           /* the data field from the iocb */
        __u64           obj;            /* what iocb this event came from */
        __s64           res;            /* result code for this event */
        __s64           res2;           /* secondary result */
};

In io-uring, cqe->flags is repurposed for zone-append result.

struct io_uring_cqe {
        __u64   user_data;      /* sqe->data submission passed back */
        __s32   res;            /* result code for this event */
        __u32   flags;
};

Since 32 bit flags is not sufficient, we choose to return zone-relative offset
in sector/512b units. This can cover zone-size represented by chunk_sectors.
Applications will have the trouble to combine this with zone start to know
disk-relative offset. But if more bits are obtained by pulling from res field
that too would compel application to interpret res field differently, and it
seems more painstaking than the former option.
To keep uniformity, even with aio, zone-relative offset is returned.

Append using io_uring fixed-buffer --->
This is flagged as not-supported at the moment. Reason being, for fixed-buffer
io-uring sends iov_iter of bvec type. But current append-infra in block-layer
does not support such iov_iter.

Block IO vs File IO --->
For now, the user zone-append interface is supported only for zoned-block-device.
Regular files/block-devices are not supported. Regular file-system (e.g. F2FS)
will not need this anyway, because zone peculiarities are abstracted within FS.
At this point, ZoneFS also likes to use append implicitly rather than explicitly.
But if/when ZoneFS starts supporting explicit/on-demand zone-append, the check
allowing-only-block-device should be changed.

Semantics --->
Zone-append, by its nature, may perform write on a different location than what
was specified. It does not fit into POSIX, and trying to fit may just undermine
its benefit. It may be better to keep semantics as close to zone-append as
possible i.e. specify zone-start location, and obtain the actual-write location
post completion. Towards that goal, existing async APIs seem to fit fine.
Async APIs (uring, linux aio) do not work on implicit write-pointer and demand
explicit write offset (which is what we need for append). Neither write-pointer
is taken as input, nor it is updated on completion. And there is a clear way to
get zone-append result. Zone-aware applications while using these async APIs
can be fine with, for the lack of better word, zone-append semantics itself.

Sync APIs work with implicit write-pointer (at least few of those), and there is
no way to obtain zone-append result, making it hard for user-space zone-append.

Tests --->
Using new interface in fio (uring and libaio engine) by extending zbd tests
for zone-append: https://github.com/axboe/fio/pull/1026

Changes since v1:
- No new opcodes in uring or aio. Use RWF_ZONE_APPEND flag instead.
- linux-aio changes vanish because of no new opcode
- Fixed the overflow and other issues mentioned by Damien
- Simplified uring support code, fixed the issues mentioned by Pavel
- Added error checks

Kanchan Joshi (1):
  fs,block: Introduce RWF_ZONE_APPEND and handling in direct IO path

Selvakumar S (1):
  io_uring: add support for zone-append

 fs/block_dev.c          | 28 ++++++++++++++++++++++++----
 fs/io_uring.c           | 32 ++++++++++++++++++++++++++++++--
 include/linux/fs.h      |  9 +++++++++
 include/uapi/linux/fs.h |  5 ++++-
 4 files changed, 67 insertions(+), 7 deletions(-)

-- 
2.7.4


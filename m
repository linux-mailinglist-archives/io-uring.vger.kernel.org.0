Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD02214EA3
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgGESwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:52:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31458 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgGESwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 14:52:11 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200705185206epoutp04a178485092545844f82a266f51bd7614~e7_6yPUyQ1096410964epoutp04U
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 18:52:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200705185206epoutp04a178485092545844f82a266f51bd7614~e7_6yPUyQ1096410964epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593975126;
        bh=hQPezt3s8OlsiuExPu77NlEiYYJbDQhcCBCIducGDuk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Vfn1H4BtPwXy4+Mu8sDvEt25ifHaqhB+ADZdkO4NXeKu28djW+Gq4Bo+XlS87QVa7
         DFGjNKNI8ZViRr1hq5hUwh59cboTVe7Gl2aoImIuXKWvPAo5WvwHewZeaRQsCFaC85
         Oq1QSctTxs+2IvU2M9RdYDf3XNvDlwyPHDSP62Cs=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200705185205epcas5p180e3a8deef1fcacdb76d934a7fef28e7~e7_6C_L5Y0734507345epcas5p1U;
        Sun,  5 Jul 2020 18:52:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.B7.09703.551220F5; Mon,  6 Jul 2020 03:52:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200705185204epcas5p3adeb4fc3473c5fc0472a7396783c5267~e7_5JGHy90482204822epcas5p3n;
        Sun,  5 Jul 2020 18:52:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200705185204epsmtrp2f0e02848992e9a6786497f596d97f99f~e7_5IS-JF1855618556epsmtrp2w;
        Sun,  5 Jul 2020 18:52:04 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-2a-5f022155462e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.37.08303.451220F5; Mon,  6 Jul 2020 03:52:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185202epsmtip2da00bd83855b850f39e7db1e956e44a9~e7_3DMwUB3251332513epsmtip2u;
        Sun,  5 Jul 2020 18:52:02 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 0/4] zone-append support in io-uring and aio
Date:   Mon,  6 Jul 2020 00:17:46 +0530
Message-Id: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSZ0wTYRjmux7ttUnlrEQ/qqJUTKQoKGI4FcWI0QtGozGg4oBGLoiy2hNQ
        ooQIZZQUCZQpGEPE1PoDrCejFMSW4UCw4ohGVgTFAZpWkbDU0qL/nu9Z7/Pjw1iCdEchFhV7
        jpLFSqJFbB5aa/QQrwt2Q8LW11k8ialilSNRrqkFxO3eK2xCMcughDxzHCGe5FUixJi8CyXa
        fo+yCVXRZUA0vfUk9E2PUKJHV84m1HWtKPFCVckiumc6HHc4kQ1lvRzyrlpM9jxNILXmfA6Z
        83ICkLmMBpAWrSuZ2ZKDkNqhUeQAN5TnH0FFRyVSMu/t4bzTg51VaHyn63lT/xd2KlBBBeBi
        EPeFv6s/AgXgYQK8EcCX12ZQ28MM4HjLbbtiAfBm62POfKT5oZZjE3R/Bcss55+reliFKACG
        sXEP+KwgwQqdcX/YcMPdamHhWQicvcUAK78ID4C6EqG1E8VXw+zRCcSK+XggrK2ZZNtuucI3
        XdksaxbicgxeVlbbR+yC9a8y7aZF8HMHY+eF0DLWZOdpOPmuzR7OAvB1ailqEwKgST8zt5P1
        d2e1zttKs/AFUDk1NEdDnA+zMgQ2txvsyx92tOElcLDkhh2T8EGPaa5RgJ+A6UoG5IFlZf9L
        rwOgAS5UPB0TSdGb4n1iqSQvWhJDJ8RGep2Ki9GCuY8iDqoHgwPfvQwAwYABQIwlcuYrPUGY
        gB8huZBMyeLCZAnRFG0ASzFUtIQvmug8KcAjJeeosxQVT8nmVQTjClMRkeJTtMJdNdJ4fGtI
        wzI6Qu8V3OC+y2l2+fRARss184qK8JTncYVRNVJRJnHgeZG4fcSwB6vadnfzk4vCLa4rjT9G
        u1OD8yfWJkv18uKR4o4Lx5uD1D0h+8LLy893/pQKjfr9Lcd+Lb9zSL5zfwWjWV23hZOd6MQp
        ZdRnC/qTVOPfUmo2Xu0+Oj3+tH23j480L2a4CRH4nTjJVKYZ90nDx9bcCjxyqbWQCn39QMc9
        86HYr+Jrn3pwYVdir9bZN7dtb8fw/fQNh0fe378nC1N+8i9AGMzoZ5IMFJhdKImDyFc21YwY
        tNykXIM5oMth1czBRhN/MU+68IzmR5rbTU6VCKVPSzaIWTJa8geHwFSrlwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSvG6IIlO8waH92ha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWR/+/ZbOYMq2J0WLvLW2LPXtPslhc3jWHzWLF
        9iMsFlemLGK2OP/3OKsDv8fOWXfZPTav0PK4fLbUY9OnSewe3Vd/MHr0bVnF6PF5k5xH+4Fu
        Jo9NT94yBXBGcdmkpOZklqUW6dslcGU8PLOUpeCMXMXF+6/ZGhinSHQxcnJICJhI7Duxib2L
        kYtDSGAHo8SRvidsEAlxieZrP9ghbGGJlf+eQxV9ZJS4NmcXSxcjBwebgKbEhcmlIDUiAg4S
        XccfM4HUMAtMYZJ4emo+M0iNsIC9xK4ZUiA1LAKqEp1vfzCB2LwCzhLbNvyC2iUncfNcJ/ME
        Rp4FjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCw1ZLawfjnlUf9A4xMnEwHmKU
        4GBWEuHt1WaMF+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB9MSS1OzU1ILUIpgsEwen
        VAPTubkV7x5OZbyulNne23vFza//vP9NV3lPjb8P1zxiSpvu1TInkXuXpvkH+8rbRyOjNgaW
        yp7pV+qeu3Gb52f12VL9dku417FcENA13RRyPUru0z5j525Omc1c82L4o1ZO4uy32nunpvP+
        f6VTVzguf5ybzyGmrrnh+KZJN+6pPHz3SOT8drOm1/sOG3Zz3f24oeRyZ/E5k3DT/7N1DXUU
        niz8v2DdGqb1LwOD6uwPa+94z2gtf69ZmWOn9LniiVEvDHae3+UmNfVp/ostv01M182/wFGt
        c3NHWpfbx7b/C/r4XFtuLbBMK6rnPvHQ7mZ8IIu5uFDGUxVz20edqcZz1jyauCDrokPKK0MN
        jwO6SizFGYmGWsxFxYkAwPqMfMoCAAA=
X-CMS-MailID: 20200705185204epcas5p3adeb4fc3473c5fc0472a7396783c5267
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185204epcas5p3adeb4fc3473c5fc0472a7396783c5267
References: <CGME20200705185204epcas5p3adeb4fc3473c5fc0472a7396783c5267@epcas5p3.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Changes since v2:
- Use file append infra (O_APPEND/RWF_APPEND) to trigger zone-append
(Christoph, Wilcox)
- Added Block I/O path changes (Damien). Avoided append split into multi-bio.
- Added patch to extend zone-append in block-layer to support bvec iov_iter.
Append using io-uring fixed-buffer is enabled with this.
- Made io-uring support code more concise, added changes mentioned by Pavel.

v2: https://lore.kernel.org/io-uring/1593105349-19270-1-git-send-email-joshi.k@samsung.com/

Changes since v1:
- No new opcodes in uring or aio. Use RWF_ZONE_APPEND flag instead.
- linux-aio changes vanish because of no new opcode
- Fixed the overflow and other issues mentioned by Damien
- Simplified uring support code, fixed the issues mentioned by Pavel
- Added error checks for io-uring fixed-buffer and sync kiocb

v1: https://lore.kernel.org/io-uring/1592414619-5646-1-git-send-email-joshi.k@samsung.com/

Cover letter (updated):

This patchset enables zone-append using io-uring/linux-aio, on block IO path.
Purpose is to provide zone-append consumption ability to applications which are
using zoned-block-device directly.
Application can send write with existing O/RWF_APPEND;On a zoned-block-device
this will trigger zone-append. On regular block device existing behavior is
retained. However, infra allows zone-append to be triggered on any file if
FMODE_ZONE_APPEND (new kernel-only fmode) is set during open.

With zone-append, written-location within zone is known only after completion.
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

32 bit flags is not sufficient, to cover zone-size represented by chunk_sectors.
Discussions in the LKML led to following ways to go about it -
Option 1: Return zone-relative offset in sector/512b unit
Option 2: Return zone-relative offset in bytes

With option #1, io-uring changes remain minimal, relatively clean, and extra
checks and conversions are avoided in I/O path. Also ki_complete interface change
is avoided (last parameter ret2 is of long type, which cannot store return value
in bytes). Bad part of the choice is - return value is in 512b units and not in
bytes. To hide that, a wrapper needs to be written in user-space that converts
cqe->flags value to bytes and combines with zone-start.

Option #2 requires pulling some bits from cqe->res and combine those with
cqe->flags to store result in bytes. This bitwise scattering needs to be done
by kernel in I/O path, and application still needs to have a relatively
heavyweight wrapper to assemble the pieces so that both cqe->res and append
location are derived correctly.

Patchset picks option #1.

Kanchan Joshi (2):
  fs: introduce FMODE_ZONE_APPEND and IOCB_ZONE_APPEND
  block: enable zone-append for iov_iter of bvec type

Selvakumar S (2):
  block: add zone append handling for direct I/O path
  io_uring: add support for zone-append

 block/bio.c        | 31 ++++++++++++++++++++++++++++---
 fs/block_dev.c     | 49 ++++++++++++++++++++++++++++++++++++++++---------
 fs/io_uring.c      | 21 +++++++++++++++++++--
 include/linux/fs.h | 14 ++++++++++++--
 4 files changed, 99 insertions(+), 16 deletions(-)

-- 
2.7.4


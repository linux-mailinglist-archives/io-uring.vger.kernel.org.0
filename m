Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14C122CAD9
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGXQWh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:22:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10950 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGXQWh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:22:37 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724162233epoutp03a4947f522df01e538703e979d73d47e3~kvMxV-fJa0314403144epoutp03G
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:22:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724162233epoutp03a4947f522df01e538703e979d73d47e3~kvMxV-fJa0314403144epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607753;
        bh=NpX7UIFijjINqb3RWh4VijxgxpUkaoRam/J9yuwq45w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=iMyLrAais4clOXdyCr14MKC66+MzicmVz0j1aPLQqbMecHdRR6JcA2C8DhQacApyZ
         oxS3sgvoUC+8J/WyAqphqb9sV6hjMTwlrj9VL8ysjN+g7Uh1Zzud3qZmxVR+ADG8Kj
         Hoyl4aKiivcPhPrrIeoSctcyXEZZrtdoTLzC+GmE=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200724162233epcas5p25a3465dd26c4fee9658f3b92f13833eb~kvMwnEXZj2133721337epcas5p2v;
        Fri, 24 Jul 2020 16:22:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.BE.40333.8CA0B1F5; Sat, 25 Jul 2020 01:22:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200724155244epcas5p2902f57e36e490ee8772da19aa9408cdc~kuyu_vaUD1470214702epcas5p2W;
        Fri, 24 Jul 2020 15:52:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200724155244epsmtrp1b58587ff618d981a15758dd145d2b24b~kuyu96uhd3045430454epsmtrp1R;
        Fri, 24 Jul 2020 15:52:44 +0000 (GMT)
X-AuditID: b6c32a4a-9a7ff70000019d8d-20-5f1b0ac88328
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.02.08382.CC30B1F5; Sat, 25 Jul 2020 00:52:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155242epsmtip185a0b33a5d3780b627934a3288559d7f~kuysrDUXM0434604346epsmtip14;
        Fri, 24 Jul 2020 15:52:41 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 0/6] zone-append support in io-uring and aio
Date:   Fri, 24 Jul 2020 21:19:16 +0530
Message-Id: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSWUwTURiFc2em07GxOhah1yI1VI2CsahxuZpGUTFOfHGJD2CiUGUCRqi1
        QxXFGFyQWrUiqwJxCyRSE8BSBVnUVIkgWlCMpGxCBCMQt6KFQAtapsS37/zn/v85D5fCJdcF
        MuqwJonVadQJClJEPH4RsnR5gygwesVXD0LjedkCVGh+DNCDrmskMk5YCZSW7sJQU8Y9DH1P
        sxOofvIbibJzzwFUMWIgUV37MlRb10ig1upCEn3IvoejZs8rARofLSTDaeZJfpeQqbgfyrS+
        1TMWZ6aQMVnNgBm2yJn055cxxtL3DdtF7ROpYtmEw8dZXdjGGFF85Uu3UOtZkOz6UyVMBW6p
        EcygIL0amkvfk0YgoiR0DYAVmc2AF04Ae85+9wkXgB3dpWB6pakkB+eNOgAvDHYSvBgGsL7Y
        8U9QFEmHwJYsvRfn0ir4pGiR9wlOmzH4u+0C4T3kR2+CfQVlU0zQi+G44+pUgJjeCpsmPb4w
        OXTYL02FQTqNgoPlFgFvRMDerIckz35w8JVVyLMMDly76GMOjnXW+5YNALal3iR4YxN8V+vB
        vO3wf0XLqsP4cRDMeV2KeRmnZ8Gr430YPxfDqlvTHAy7M/t9HaSw90aRwHsG0gwc6tzmHUvo
        /dCd1STIAEH5/wPuAGAG81gtlxjHcmu0qzTsCSWnTuT0mjjloaOJFjD1a0J3VIHenp9KG8Ao
        YAOQwhVzxfddsmiJOFZ98hSrOxqt0yewnA0EUoRCKlaMvjkgoePUSewRltWyumkXo2bIUjEi
        WGk10D+OCd50xKyTx+RXT0jD5O1nZp23O01nx25X7Zv4cz2lZ4l8bOMeUYdGgSv78nI16f7F
        +mO9EbNXjJYowpNHKpuNAZWNKSNf9g5EFvxKmL17w+bTFf7Lc/tBGvusv//RM1P7HWJwKGrn
        FX9VY15nsGqrLjiFvbt9UXFGQGly68+a4trYofnxjoZHpqxD2+zHtc6F52Xu7KIc6+nyIreJ
        Dgl4WaMowW2upJgA45boj3Mc6sKvBS2qp4kLdkz6tRyI0NVFxckMUWR45bD0U9tawYbVIWKw
        /v38zM93bweOGiLNK+1z9jpnUmWRv209OVwDddEmOiiSlA8FDSgILl69MhTXceq/Avp+86QD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSnO4ZZul4g54jEha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWR/+/ZbOYMq2J0WLz9w42i723tC327D3JYnF5
        1xw2iytTFjFbnP97nNXi9485bA4CHjtn3WX32LxCy+Py2VKPTZ8msXv0bVnF6PF5k5xH+4Fu
        Jo9NT94yBXBEcdmkpOZklqUW6dslcGVsP/KHveCvfMW3rzvYGxj/iHcxcnJICJhInF45lbmL
        kYtDSGA3o0RTw2cWiIS4RPO1H+wQtrDEyn/PwWwhgY+MEn3vDboYOTjYBDQlLkwuBQmLCDhI
        dB1/zAQyh1lgG5PE08Z2sHphAXuJJ7PXg81kEVCV+H2zlxHE5hVwljj9/y8jxHw5iZvnOpkn
        MPIsYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHLZamjsYt6/6oHeIkYmD8RCj
        BAezkgjvim9S8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5bxQujBMSSE8sSc1OTS1ILYLJMnFw
        SjUw6U+cEHRS0q15YrWZTE9q8+aYUzUXdx3dn/hpXnVokML7h59Nkt4yyR1W23P+pV7DZ1/d
        Upsdcg1L+NZZsyXxTFnHbXKfsWSW28NunxU3Ix3l+EXWbbx168/rdf/ubPOY2lHr6hk0/4Op
        jt/WYMFjZ09ucsw22FozQ/9wxDyegH9PK7Z/9sk1tvsktFx7/vYu4bCL17OEIs7vkfdI+rrZ
        0IKzWDikQcX3q1NTzr6D5+xObgxWyXj4ki+7Z1Hm+um31m1eUNq7JGfqQ2buu38OOTTwhh/8
        OcNUVOvSVfb3p1hi94SdOLwjS0JzS8KGc2qvhDJ6djWtEVn1vuRBEldG1sdJ6/W0/t6ZE+P3
        WtOvWYmlOCPRUIu5qDgRAHQYDHzKAgAA
X-CMS-MailID: 20200724155244epcas5p2902f57e36e490ee8772da19aa9408cdc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155244epcas5p2902f57e36e490ee8772da19aa9408cdc
References: <CGME20200724155244epcas5p2902f57e36e490ee8772da19aa9408cdc@epcas5p2.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Changes since v3:
- Return absolute append offset in bytes, in both io_uring and aio
- Repurpose cqe's res/flags and introduce res64 to send 64bit append-offset
- Change iov_iter_truncate to report whether it actually truncated
- Prevent short write and return failure if zone-append is spanning
beyond end-of-device
- Change ki_complete(...,long ret2) interface to support 64bit ret2

v3: https://lore.kernel.org/lkml/1593974870-18919-1-git-send-email-joshi.k@samsung.com/

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
this will trigger zone-append. On regular block device, existing file-append
behavior is retained. However, infra allows zone-append to be triggered on
any file if FMODE_ZONE_APPEND (new kernel-only fmode) is set during open.

With zone-append, written-location within zone is known only after completion.
So apart from the usual return value of write, additional means are
needed to obtain the actual written-location.

In aio, 64bit append-offset is returned to application using res2
field of io_event -

struct io_event {
        __u64           data;           /* the data field from the iocb */
        __u64           obj;            /* what iocb this event came from */
        __s64           res;            /* result code for this event */
        __s64           res2;           /* secondary result */
};

In io-uring, [cqe->res, cqq->flags] repurposed into res64 to return
64bit append-offset to user-space.

struct io_uring_cqe {
        __u64   user_data;      /* sqe->data submission passed back */
        union {
                struct {
                        __s32   res;    /* result code for this event */
                        __u32   flags;
                };
                __s64   res64;  /* appending offset for zone append */
        };
};
Zone-append write is ensured not to be a short-write.

Kanchan Joshi (3):
  fs: introduce FMODE_ZONE_APPEND and IOCB_ZONE_APPEND
  block: add zone append handling for direct I/O path
  block: enable zone-append for iov_iter of bvec type

SelvaKumar S (3):
  fs: change ki_complete interface to support 64bit ret2
  uio: return status with iov truncation
  io_uring: add support for zone-append

 block/bio.c                       | 31 ++++++++++++++++++++---
 drivers/block/loop.c              |  2 +-
 drivers/nvme/target/io-cmd-file.c |  2 +-
 drivers/target/target_core_file.c |  2 +-
 fs/aio.c                          |  2 +-
 fs/block_dev.c                    | 51 +++++++++++++++++++++++++++++--------
 fs/io_uring.c                     | 53 +++++++++++++++++++++++++++++++--------
 fs/overlayfs/file.c               |  2 +-
 include/linux/fs.h                | 16 +++++++++---
 include/linux/uio.h               |  7 ++++--
 include/uapi/linux/io_uring.h     |  9 +++++--
 11 files changed, 142 insertions(+), 35 deletions(-)

-- 
2.7.4


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A95732B545
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344213AbhCCGbj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:31:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24432 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383262AbhCBQLP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 11:11:15 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210302160909epoutp01fdde3e93c8002c3e3240f5dcf3bbcd9f~oklKVDMck2679826798epoutp01K
        for <io-uring@vger.kernel.org>; Tue,  2 Mar 2021 16:09:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210302160909epoutp01fdde3e93c8002c3e3240f5dcf3bbcd9f~oklKVDMck2679826798epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614701349;
        bh=3tnGCBfAzSBkz895gpsgmOb+G6Ul5L/3wpYOQthjl60=;
        h=From:To:Cc:Subject:Date:References:From;
        b=k+S8RrJQq73JEihDAV1AakS/6+atIVCiUDOcJcg+VbtBCRLGEKjxjyMENlS/Gifqs
         FMcvsR/Y3ZPqIWYQCfVrUHGKzIJOhx1Oi3GQSjAbbUuhBztldS3v1q6U4Rrpkatm9u
         uSIR56wpZa55E+euvQ5U+PA0BJbnziQIvH+FCr0I=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210302160908epcas5p405d3dbc6b96aa077ac642137792318b9~oklI8yIyB1776717767epcas5p4x;
        Tue,  2 Mar 2021 16:09:08 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.70.33964.4236E306; Wed,  3 Mar 2021 01:09:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210302160907epcas5p4d04ab7c4ef4d467302498f06ed656b24~oklIC1EFz1776717767epcas5p4w;
        Tue,  2 Mar 2021 16:09:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210302160907epsmtrp23e107cf12a30774866a37760f9cf966e~oklICJPSo0331303313epsmtrp2R;
        Tue,  2 Mar 2021 16:09:07 +0000 (GMT)
X-AuditID: b6c32a4b-ea1ff700000184ac-e4-603e6324fb7d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.5D.08745.3236E306; Wed,  3 Mar 2021 01:09:07 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210302160905epsmtip18ab5351536e30f4483cec9ceea6b00e5~oklGg9O2m1329213292epsmtip1v;
        Tue,  2 Mar 2021 16:09:05 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC 0/3] Async nvme passthrough
Date:   Tue,  2 Mar 2021 21:37:31 +0530
Message-Id: <20210302160734.99610-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42LZdlhTU1cl2S7BYGknj0XThL/MFqvv9rNZ
        rFx9lMniXes5FovHdz6zWxz9/5bNYtKha4wW85c9Zbe4MmURswOnx+WzpR6bVnWyeWxeUu+x
        +2YDm0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBl/P1xi7lgOnvFh6ctbA2Mn1i7GDk4JARM
        JPYdF+xi5OIQEtjNKHH72EwmCOcTo8TKc58YIZzPjBJ7ps1m72LkBOt42bOIBSKxi1Hi56br
        zHBV0+Y/YQGZyyagKXFhcilIg4iAkcT+TydZQWqYBaYwSpy7eJgJJCEMVHP7+UFmkHoWAVWJ
        E3c8QMK8AhYSjzo6oJbJS8y89J0dIi4ocXImyHhOoDnyEs1bZzND1Nxjl/i3iRPCdpHovncJ
        Ki4s8er4Fqg5UhKf3+1lg7CLJX7dOQp2s4RAB6PE9YaZLBAJe4mLe/4ygdzDDHTb+l36ELv4
        JHp/P2GCBBevREebEES1osS9SU9ZIWxxiYczlkDZHhJNjR1sIOVCArEST1rSJzDKzULywCwk
        D8xC2LWAkXkVo2RqQXFuemqxaYFxXmq5XnFibnFpXrpecn7uJkZwUtHy3sH46MEHvUOMTByM
        hxglOJiVRHjFX9omCPGmJFZWpRblxxeV5qQWH2KU5mBREufdYfAgXkggPbEkNTs1tSC1CCbL
        xMEp1cD0osT3ftghpUP/OFWf7Q3eKv0qNePb28sb+Kease3QeZN2al654Im324XOf7OdtP3B
        +cylEZ0lWkevKMTlrzf8PulP6SbJlYrbvX31Y72z/luGX0hOX7/x8YTo56Hr3zBOOvucnW++
        u+mjg3XnlEINAzwMpCqCtW4ofRX7x3914724qNpEhSqdp/NOb/tmYRretWnmND6XNxcyyqZW
        RvcHlsoyOTOYn1FUYeR3ZZ9cyaB3ie/fgzbHpq8K3o4rJ8jzM/mcvTPdRvZtROE8531Xp6yc
        qPjjoRKHrPFaM/fuNUEc9w42a/Ev8tS7ebpN6tMh7vdP88yvHJZ9Yp1umbj7FquSw8KJ3xea
        BH9qvdGtxFKckWioxVxUnAgAdEnPSZkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnK5ysl2Cwb3X3BZNE/4yW6y+289m
        sXL1USaLd63nWCwe3/nMbnH0/1s2i0mHrjFazF/2lN3iypRFzA6cHpfPlnpsWtXJ5rF5Sb3H
        7psNbB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8ffHLeaC6ewVH562sDUwfmLtYuTkkBAw
        kXjZs4ili5GLQ0hgB6PEzCub2SES4hLN135A2cISK/89Z4co+sgocXPhO6BuDg42AU2JC5NL
        QWpEBMwklh5ewwJiMwvMYJTYsCwdxBYGKrn9/CAzSDmLgKrEiTseIGFeAQuJRx0dUOPlJWZe
        +s4OEReUODnzCdQYeYnmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWle
        ul5yfu4mRnDwamntYNyz6oPeIUYmDsZDjBIczEoivOIvbROEeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYGKbP/XjDOsHwafM5n72ks1IF/WJ5HrKy7Rp
        yYEZx8/bL1x6QScrat10dxkmCXdpFfVbK0skf06d/8lI8dE+pUmrLvQXuzvIbMhZcz3n+IbQ
        QpfAds7GXUm3y47UL/igtiF43t9rsiGzM0J7wpfPbph3JGzryX8WFc8t3+j9mcj5fkOWJNNB
        Af9Ab4090v7rg5Nmntd6+z9AZe0iq+s/DprfCjO5OG323AcX7q2NPb5DmVVd/vDm2uOF3M8W
        6VhHvjxQ7/jQSaTi5UQxl0dfjKZP7Z/8xe1CJMP9bcpKTNELdl77vlJ45bQNmkp3Zn1S+Kh+
        aq/5Gpk3H52lH57P094Ymv027NbdBMnkr7LculcClViKMxINtZiLihMBNDxYhc0CAAA=
X-CMS-MailID: 20210302160907epcas5p4d04ab7c4ef4d467302498f06ed656b24
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210302160907epcas5p4d04ab7c4ef4d467302498f06ed656b24
References: <CGME20210302160907epcas5p4d04ab7c4ef4d467302498f06ed656b24@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds async passthrough capability for nvme block-dev over
iouring_cmd. The patches are on top of Jens uring-cmd branch:
https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3

Application is expected to allocate passthrough command structure, set
it up traditionally, and pass its address via "block_uring_cmd->addr".
On completion, CQE is posted with completion-status preceding any
ioctl specific buffer/field update.

Kanchan Joshi (3):
  io_uring: add helper for uring_cmd completion in submitter-task
  nvme: passthrough helper with callback
  nvme: wire up support for async passthrough

 drivers/nvme/host/core.c | 225 ++++++++++++++++++++++++++++++++-------
 drivers/nvme/host/nvme.h |   3 +
 drivers/nvme/host/pci.c  |   1 +
 fs/io_uring.c            |  37 ++++++-
 include/linux/io_uring.h |   8 ++
 5 files changed, 232 insertions(+), 42 deletions(-)

-- 
2.25.1


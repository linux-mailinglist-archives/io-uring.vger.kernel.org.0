Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DCF5E95E4
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiIYUd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIYUdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:25 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971C32BE35
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:23 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220925203320epoutp03b3f06f97f680d7f7dc54b9e34a54f065~YNLGy0eDN0848708487epoutp03a
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220925203320epoutp03b3f06f97f680d7f7dc54b9e34a54f065~YNLGy0eDN0848708487epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138000;
        bh=i1x5/16vERyV9B+Qa5JO2XwnVEudUG9CRVgYMQHnaiM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=uplTNAaINzCOxhc0rGA0O1cnbP5aMGu23GiM2fNISIbbGokVdUsjTFave3jYfC97O
         oAgWK7MOEr0IY3rx7Xx4LxO0xcUkd6zys757VZ5AN5Np8byneTxFnoEsoqKTwCcKTo
         YQHxKpL9AKJ2IQmRoVkHk9GtolkIJ/E5zi5yUap4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220925203318epcas5p439edf20fc33884b4be4ef83b0531438f~YNLFnExqg2831828318epcas5p4v;
        Sun, 25 Sep 2022 20:33:18 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MbHdm1D2Jz4x9Pt; Sun, 25 Sep
        2022 20:33:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.9F.26992.C0BB0336; Mon, 26 Sep 2022 05:33:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220925203314epcas5p2a075d1026db3a46df09a4b67108109b4~YNLB_M_L00635906359epcas5p2L;
        Sun, 25 Sep 2022 20:33:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220925203314epsmtrp15d85f148375096393914f9c3dbff2696~YNLB6jHeI1867318673epsmtrp1S;
        Sun, 25 Sep 2022 20:33:14 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-12-6330bb0c690e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.01.14392.A0BB0336; Mon, 26 Sep 2022 05:33:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203312epsmtip1cc0b26348eff6180701f5e423079ad0e~YNK-_lZv-3161131611epsmtip1V;
        Sun, 25 Sep 2022 20:33:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 0/7] fixed-buffer for uring-cmd/passthru
Date:   Mon, 26 Sep 2022 01:52:57 +0530
Message-Id: <20220925202304.28097-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmui7PboNkg3nT2SxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
        6Lpl5gBdo6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2x
        MjQwMDIFKkzIztiw6CZ7wUKBiudL3BsY3/N0MXJySAiYSPz+s4q5i5GLQ0hgN6PEgSfzmCCc
        T4wS/54/ZYRwvjFKTNl7nB2mpWX3fqjEXkaJlbP2s0I4nxklpp/sZ+ti5OBgE9CUuDC5FKRB
        RMBIYv+nk2A1zAIzGCVWd7wGmyQs4CJx4+9dNhCbRUBVYtvTH6wgNq+AhcTHhY+ZILbJS8y8
        9J0dIi4ocXLmExYQmxko3rx1NtjhEgK32CUWHdvLCNHgItG09z/UqcISr45vgbKlJF72t0HZ
        yRKXZp6DWlAi8XjPQSjbXqL1VD8zyAPMQA+s36UPsYtPovf3EyaQsIQAr0RHmxBEtaLEvUlP
        WSFscYmHM5ZA2R4Sc6Y1MIPYQgKxEpeWXmGawCg3C8kHs5B8MAth2QJG5lWMkqkFxbnpqcWm
        BYZ5qeXwuEzOz93ECE6HWp47GO8++KB3iJGJg/EQowQHs5IIb8pF3WQh3pTEyqrUovz4otKc
        1OJDjKbAYJ3ILCWanA9MyHkl8YYmlgYmZmZmJpbGZoZK4ryLZ2glCwmkJ5akZqemFqQWwfQx
        cXBKNTBJXMnI4Uzz4VkYdl/wueymbfXt3h/N+z5Vfj9h7577W4Cl6FZBxNYKsYuf5m9vnNwx
        L6ElNsb19B1LvmovBZUrv9Z5xgZYO+zXLHwokfPJ89DcRQ58D17WTEr4dXixlIlp8yeOV9c1
        jFfdmJ1ywPLEvKU31iTbHCnWZuRf0BW4Sm+eVUWUnyL/t0SryZ2qMz78szng0H9eWPnPD27b
        D66a5m+LTD/b+hf5B+4QV/k/QWnvixk7wnadjnc3fciXrnDGekNmj/2TJIfL6ZJ1f5aLOt+s
        4eBjuLfi3oTiGq6jCb/aWRuylxvX/pSPM/i/oe2x3oLtO28yek/Jmcx4/1N31s6za2tXbjj/
        JlQlqFWJpTgj0VCLuag4EQAi0UQ6EAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnC7XboNkgzf3DCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlbFh0k71goUDF8yXuDYzveboYOTkkBEwkWnbvZ+xi
        5OIQEtjNKHF+xidmiIS4RPO1H+wQtrDEyn/P2SGKPjJKPGufB1TEwcEmoClxYXIpSI2IgJnE
        0sNrWEBqmAXmMEpcvrwHrFlYwEXixt+7bCA2i4CqxLanP1hBbF4BC4mPCx8zQSyQl5h56Ts7
        RFxQ4uTMJywgNjNQvHnrbOYJjHyzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeu
        l5yfu4kRHLJamjsYt6/6oHeIkYmD8RCjBAezkghvykXdZCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYLCuv6XO95Xr4/ce0o8J30vTv/n7BuOWjAevX
        qJiMk0WeUrPM2Kc8y9H9+O7AcyYDdo6f7yuWNpmfLUwJ8PQ/8fnT1G11wke2Mm0znep9S6rp
        Cm/0vrs/fOIlWlWfOQrwbXjKUfnqXdoq3VRTLVX/unV9RRtPyGa/PpRtK+Qle8f38IpLU149
        3hekYM2f9OWlrcEL0U12Ft15HOorqlccmqd6clPvhdnvFJ/Jfljns0ZMra3d7fPSpWsa2Rq3
        T255sEbgfdjKywerP/o53blfdfmx0otKphUxSoouxnunStY6Rx678zsj5p6D1puGze7zYmdd
        ySs0ap71/GajVoEbQ7ZVeg531J3iBddvLa/KUGIpzkg01GIuKk4EAIipyCzIAgAA
X-CMS-MailID: 20220925203314epcas5p2a075d1026db3a46df09a4b67108109b4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203314epcas5p2a075d1026db3a46df09a4b67108109b4
References: <CGME20220925203314epcas5p2a075d1026db3a46df09a4b67108109b4@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

uring-cmd lacks the ability to leverage the pre-registered buffers.
This series adds that support in uring-cmd, and plumbs nvme passthrough
to work with it.

Patch 3 and 4 contains a bunch of general nvme cleanups, which got added
along the iterations.

Using registered-buffers showed 22-26% hike in peak IOPS (v8,in Jens setup).

Changes since v8:
- Split some patches further; now 7 patches rather than 5 (Christoph)
- Applied a bunch of other suggested cleanups (Christoph)

Changes since v7:
- Patch 3: added many cleanups/refactoring suggested by Christoph
- Patch 4: added copying-pages fallback for bounce-buffer/dma-alignment case
  (Christoph)

Changes since v6:
- Patch 1: fix warning for io_uring_cmd_import_fixed (robot)
-
Changes since v5:
- Patch 4: newly addd, to split a nvme function into two
- Patch 3: folded cleanups in bio_map_user_iov (Chaitanya, Pankaj)
- Rebase to latest for-next

Changes since v4:
- Patch 1, 2: folded all review comments of Jens

Changes since v3:
- uring_cmd_flags, change from u16 to u32 (Jens)
- patch 3, add another helper to reduce code-duplication (Jens)

Changes since v2:
- Kill the new opcode, add a flag instead (Pavel)
- Fix standalone build issue with patch 1 (Pavel)

Changes since v1:
- Fix a naming issue for an exported helper


Anuj Gupta (2):
  io_uring: add io_uring_cmd_import_fixed
  io_uring: introduce fixed buffer support for io_uring_cmd

Kanchan Joshi (5):
  nvme: refactor nvme_add_user_metadata
  nvme: refactor nvme_alloc_request
  block: factor out bio_map_get helper
  block: introduce helper to map bvec iterator
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 111 ++++++++++++++++++++---
 drivers/nvme/host/ioctl.c     | 160 ++++++++++++++++++++--------------
 include/linux/blk-mq.h        |   1 +
 include/linux/io_uring.h      |  10 ++-
 include/uapi/linux/io_uring.h |   9 ++
 io_uring/uring_cmd.c          |  26 +++++-
 6 files changed, 241 insertions(+), 76 deletions(-)

-- 
2.25.1


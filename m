Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBC55F0502
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiI3Gm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiI3Gm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:42:57 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94273161CFB
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:42:49 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220930064244epoutp03bf8f9c2f1a49c9bfd082e21a0824b457~ZkEVHySbr2448124481epoutp03N
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:42:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220930064244epoutp03bf8f9c2f1a49c9bfd082e21a0824b457~ZkEVHySbr2448124481epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520164;
        bh=VstqhIrrgX286iLYAsYhu2ZReM84L2F8o5Tr3pi+nAU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fDM1OCFfRl7+f8/Uq42xtFE0VLAS2rxOvzxxTnyB81/pPhoNPvN3MNp6MrlgHrSUm
         4je6vuoGWFPU6tyijpAZOoYQBtY5ForFEEauiZO0K21cDr8b54mFmbvnAefgeiIi2L
         YN3ZLNyEhdddf5ooNX7K5u9dYaQtPDAn/uY/dPkw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220930064243epcas5p259ddca7e6fd7446077f3841ec3aa556e~ZkEUlFU-q1404314043epcas5p2R;
        Fri, 30 Sep 2022 06:42:43 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mf0z45329z4x9QK; Fri, 30 Sep
        2022 06:42:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.FC.39477.0EF86336; Fri, 30 Sep 2022 15:42:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063754epcas5p2aff33c952032713a39604388eacda910~ZkAHCXkiq0421904219epcas5p2y;
        Fri, 30 Sep 2022 06:37:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063754epsmtrp190bd83a8797456f91803831ca17e293e~ZkAHBlC9-2581925819epsmtrp1e;
        Fri, 30 Sep 2022 06:37:54 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-70-63368fe0899c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.32.18644.2CE86336; Fri, 30 Sep 2022 15:37:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063753epsmtip298b8ee2cb8389dc05ad6cac79c8af413~ZkAFrQYCw1318013180epsmtip2k;
        Fri, 30 Sep 2022 06:37:52 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 00/12] Fixed-buffer for uring-cmd/passthru
Date:   Fri, 30 Sep 2022 11:57:37 +0530
Message-Id: <20220930062749.152261-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTXfdBv1myweGN6hZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbtF9fQebA6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOWPCLvWCRasWcebMZGxhXyHUxcnBICJhIrHto18XIxSEksJtR4uWC
        RlYI5xOjxKHfV6Gcz4wSMy4uZu9i5ATrWPN0FSNEYhejxMTnD1jgqh7f/sgKUsUmoC5x5Hkr
        I4gtImAksf/TSbBRzAKbGCV+XT/GBLJcWMBdortFFsRkEVCVuLdTDqScV8BKYsLd01DL5CVm
        XvrODhEXlDg58wkLiM0MFG/eOpsZZKSEwC12icWbmlkhGlwk1jXfZ4SwhSVeHd8CNUhK4mV/
        G5SdLvHj8lMmCLtAovnYPqh6e4nWU/3MIPcwC2hKrN+lDxGWlZh6ah0TxF4+id7fT6BaeSV2
        zIOxlSTaV86BsiUk9p5rgLI9JP5vBxnJCQyfWIm9O16zT2CUn4XknVlI3pmFsHkBI/MqRsnU
        guLc9NRi0wKjvNRyeLQm5+duYgSnSy2vHYwPH3zQO8TIxMF4iFGCg1lJhFe8wDRZiDclsbIq
        tSg/vqg0J7X4EKMpMIgnMkuJJucDE3ZeSbyhiaWBiZmZmYmlsZmhkjjv4hlayUIC6Yklqdmp
        qQWpRTB9TBycUg1Mbks/PLlzMfH1wkzuf15K62rtlih//MvfeiNrq9SnH0+O5Nk+b36+6sYF
        x2UT9JJqLevu5ZZ6v3v6PeyyueH0rwafnr0/mrNedZqzTHRub9tORT9Z+UWLjtdvlgwPkWD8
        VGVXKts07VvXxrOFnVEzDvWkbdz00X3P/i1HMh1Zk8Lvy3XLPhNVfH05Z/YyLu7U9aINL25N
        vL6U69cv40Juu8SMTdqulnypHDtubXEt1tn3Qyfw9OSbPTKLd8u/3ZT0S0Lv+rX+WyYnBO8d
        D/G/9P7Lp8pLMbcya2ef3xF6VnZ+56v9Qc+nzKqOkBKw6EpcNE8kduZdNc2pj5uvzI0/7iig
        7HDhzKfC/36X5i1S/6HEUpyRaKjFXFScCACPNAcXIAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSvO6hPrNkg+9XpCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpY8Iu9YJFqxZx5sxkbGFfIdTFyckgImEis
        ebqKsYuRi0NIYAejxNNt5xghEhISp14ug7KFJVb+e84OUfSRUeLm6jmsIAk2AXWJI89bwYpE
        BMwklh5ewwJSxAwyad2zxUAJDg5hAXeJ7hZZEJNFQFXi3k6wxbwCVhIT7p5mh5gvLzHz0nd2
        iLigxMmZT1hAbGagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9d
        Lzk/dxMjOHS1tHYw7ln1Qe8QIxMH4yFGCQ5mJRFe8QLTZCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYRIKeS8zdzuGwYIL6vxuudZbaG0xja7aXvW23
        tj8XEcS56F7+iqmzD/QXMRhFMqd/FSgW+zDts+5sq842+Qqv6I6f3ptsa1bkr6szmfFc+OzX
        Kx2fOuK2qIqzR6pl2n7q3DrfIWi90ctX+/byLv/L3GI5dVelxt2nDGZ9t4X/X2NNU+1Si0/4
        ozO959Wx4C6taXfUdqxvEbki9f2Nb8f+Os63nf0lest2XmB9+OB2iGXEupjV5/Y/P2end83s
        xEGv6epN7FPWPPquu1HYfqeMtblZDteXa77v1ynvCIs60bXwjch/Ha2jvWtcFZdmq4vfPNx/
        UmjnJwe5S+YV4rMn+R163FYRX3ico981ftVkJZbijERDLeai4kQACRHJm8wCAAA=
X-CMS-MailID: 20220930063754epcas5p2aff33c952032713a39604388eacda910
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063754epcas5p2aff33c952032713a39604388eacda910
References: <CGME20220930063754epcas5p2aff33c952032713a39604388eacda910@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

uring-cmd lacks the ability to leverage the pre-registered buffers.
This series adds that support in uring-cmd, and plumbs nvme passthrough
to work with it.
Patches 3 - 5 carve out a block helper and scsi, nvme then use it to
avoid duplication of code.
Patch 6 and 7 contains a bunch of general nvme cleanups, which got added
along the iterations.


Using registered-buffers showed ~20% IOPS hike from 2.62M to 3.17M in my setup
Without fixedbufs
*****************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=3623, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=0/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=2.62M, BW=1281MiB/s, IOS/call=32/31
IOPS=2.62M, BW=1277MiB/s, IOS/call=32/32
IOPS=2.62M, BW=1277MiB/s, IOS/call=32/32
IOPS=2.61M, BW=1276MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=2.62M


With fixedbufs
**************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=3627, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=3.17M, BW=1546MiB/s, IOS/call=32/31
IOPS=3.17M, BW=1546MiB/s, IOS/call=32/31
IOPS=3.17M, BW=1546MiB/s, IOS/call=32/32
IOPS=3.16M, BW=1544MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=3.17M


Changes since v11:

Patch 2 - Add a check for flags (Jens)
Patch 3 - Moved the refactoring patches to start, before the nvme-refactoring
patches (Christoph)
Patch 3 - Initialize ret to 0, to prevent uninitialized variable warning
(kernel test robot)
Patch 4 - Added the onstack advantage part in the commit description (Christoph)
Patch 7 - Move blk_rq_free_request into nvme_map_user_request to handle error
scenarios, instead of doing it using goto in it's callers, helps in getting
rid of a uninitialized variable warning (kernel test robot)
Patch 10 - Folded it in with the next patch to avoid compiler warning for
unused static functions(Christoph)

Changes since v10:
- Patch 3: Fix overly long line (Christoph)
- Patch 4: create a helper in block-map for vectored and non-vectored-io, to be used by scsi and nvme (Christoph)
- Patch 5: Rename bio_map_get to blk_rq_map_bio_alloc and bio_map_put to blk_mq_map_bio_put (Christoph)
- Patch 6: Split it into a prep patch and avoid duplicate checks (Christoph)
- Patch 7: Put changes to pass ubuffer as a integer in a separate prep patch and simplify condition checks in nvme (Christoph)

Changes since v9:
- Patch 6: Make blk_rq_map_user_iov() to operate on bvec iterator
  (Christoph)
- Patch 7: Change nvme to use the above

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


Anuj Gupta (6):
  io_uring: add io_uring_cmd_import_fixed
  io_uring: introduce fixed buffer support for io_uring_cmd
  block: add blk_rq_map_user_io
  scsi: Use blk_rq_map_user_io helper
  nvme: Use blk_rq_map_user_io helper
  block: rename bio_map_put to blk_mq_map_bio_put

Kanchan Joshi (6):
  nvme: refactor nvme_add_user_metadata
  nvme: refactor nvme_alloc_request
  block: factor out blk_rq_map_bio_alloc helper
  block: extend functionality to map bvec iterator
  nvme: pass ubuffer as an integer
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 150 ++++++++++++++++++++++++++++++----
 drivers/nvme/host/ioctl.c     | 144 ++++++++++++++++++--------------
 drivers/scsi/scsi_ioctl.c     |  22 +----
 drivers/scsi/sg.c             |  22 +----
 include/linux/blk-mq.h        |   2 +
 include/linux/io_uring.h      |  10 ++-
 include/uapi/linux/io_uring.h |   9 ++
 io_uring/uring_cmd.c          |  28 ++++++-
 8 files changed, 266 insertions(+), 121 deletions(-)

-- 
2.25.1


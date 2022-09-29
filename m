Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1383F5EF525
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiI2MVM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiI2MVL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:21:11 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26E147F1C
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:21:06 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220929122103epoutp045a07eac133b57a04fb3a63c5883283b4~ZVCbasMvI0826508265epoutp04t
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:21:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220929122103epoutp045a07eac133b57a04fb3a63c5883283b4~ZVCbasMvI0826508265epoutp04t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454063;
        bh=i0AFMJFcEuYnlB54UdNImzvTltuMF2YIjbxxITwUqM8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=nQPhNDkh5MHdmUg/yb9mQSPv/MrO0HXvRm7kFOGX3vr5dsWP58Cr8iW6kzF5H1QBM
         XaQWt6rW8eNWYDh2+Q3CexfOtWF0Jhp+VgcGuUX8qOXSWvduOw+UMYEd29jy+UiI/P
         nhooV/zMva7tQLNcE9q1R6bkQEsCI0Uuhh7oY5mQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220929122102epcas5p468237bb7598ea6424dbb9296f79c9867~ZVCaerURE2098020980epcas5p4q;
        Thu, 29 Sep 2022 12:21:02 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MdXWw2cJDz4x9Pp; Thu, 29 Sep
        2022 12:21:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.1F.56352.AAD85336; Thu, 29 Sep 2022 21:20:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220929121630epcas5p3e1ed2c5251276d557f8f921e8186620f~ZU_dxPjrv1999119991epcas5p3X;
        Thu, 29 Sep 2022 12:16:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121630epsmtrp2e1cc60849e0a8ec04d34d6263cc4a2dc~ZU_dwMOF01811218112epsmtrp28;
        Thu, 29 Sep 2022 12:16:30 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-7e-63358daa9efe
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.43.14392.E9C85336; Thu, 29 Sep 2022 21:16:30 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121629epsmtip1080d55c3461921441f42a38b1e59d6a6~ZU_cOodn83027830278epsmtip1t;
        Thu, 29 Sep 2022 12:16:29 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 00/13] Fixed-buffer for uring-cmd/passthru
Date:   Thu, 29 Sep 2022 17:36:19 +0530
Message-Id: <20220929120632.64749-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmhu6qXtNkgzMvhCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdseZRO2vBTIWKnlMzWBsYZ0l1MXJySAiYSMztesbUxcjFISSwm1Hi
        xoF/zBDOJ0aJf3dXQmW+MUrs7J7MBtNyt/ENVNVeRok/D14wQjifgVruzQerYhNQlzjyvJUR
        xBYRMJLY/+kkK0gRs8AmRolf148xgSSEBdwlVn08zgJiswioSvxYMgvM5hWwlLg8+ygrxDp5
        iZmXvrNDxAUlTs58AlbDDBRv3jqbGaLmEbvEpY0VELaLxMM576FOFZZ4dXwLO4QtJfH53V6o
        eLrEj8tPmSDsAonmY/sYIWx7idZT/UAzOYDma0qs36UPEZaVmHpqHRPEWj6J3t9PoFp5JXbM
        g7GVJNpXzoGyJST2nmuAsj0k1l2dA3aykECsRPfyJ2wTGOVnIflmFpJvZiFsXsDIvIpRMrWg
        ODc9tdi0wDgvtRwes8n5uZsYwUlTy3sH46MHH/QOMTJxMB5ilOBgVhLhFS8wTRbiTUmsrEot
        yo8vKs1JLT7EaAoM4onMUqLJ+cC0nVcSb2hiaWBiZmZmYmlsZqgkzrt4hlaykEB6Yklqdmpq
        QWoRTB8TB6dUA5OXVZNiMNdU0U3P7/UsSn0rWdLzf6f70eoI9u98Ll4nDH/MmhQZ2LBtSmOs
        KVteV+LtgkdLGCQnOqTvDdi6elKrhIym9pQtaipbQparLMqzK1a+prSx//Z6he2h3wr+X67U
        4Cwx91l7ZMn/8jkSd9/zrXeP6vN2Cqre8ld5lf4cC3aNyXdeL14ddubyxBkPy3XduXcd2Bkf
        4NneueSSrtzK6A0aH3ukn6fdU7Jcx31900ejWV0/ouRs1LK4OhWiS6YGRakpL9M7y/hj8j6D
        48f+zznDJLR5r3+r0YrmqjfZNcVbAn09qpXPqGg8v6Mp7xmek17v/FHVuWbS9QkafZH8N1Y3
        T3U8fv6KfuQkeSWW4oxEQy3mouJEAKsH+rsjBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSnO68HtNkgzsb1SyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpY86idtWCmQkXPqRmsDYyzpLoYOTkkBEwk
        7ja+Ye5i5OIQEtjNKLGy+wgbREJC4tTLZYwQtrDEyn/P2UFsIYGPjBKzngeD2GwC6hJHnreC
        1YgImEksPbyGBWQQs8AORol1zxaDJYQF3CVWfTzOAmKzCKhK/FgyC8zmFbCUuDz7KCvEAnmJ
        mZe+s0PEBSVOznwCVsMMFG/eOpt5AiPfLCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YW
        l+al6yXn525iBIevluYOxu2rPugdYmTiYDzEKMHBrCTCK15gmizEm5JYWZValB9fVJqTWnyI
        UZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD0wZzJeuVcfle+Xonl939+aP2Z7Xam1+J
        55xNTh/YkGqw1VAtly9/zfk/2o7G96dInpgY/3ntiQWp3a+zVt+/f1bTcsvTCL3j1Z7b9v47
        E3GgWP8YS2SP3u2KwIsTm3dc7s1QbzLr7a4Umr4z8JPPquhfJQ7KZvmCK5O5TxsflT4x/0by
        dBn5tyva/nR92m7KEB/AfSfs9r5dvXbmyi8mBt1M3pf8LS4um7kzNO/ajsTsS83J/OUXbu/Y
        XuHbv2n1tmfHjk7LuLaNPe3TvGmf1tv+cPvaUrb3NNc+JYfGh55R887OfxH0tiW3eM174Xuh
        cY0pTHs22m14+ilnb8flXs6mysLmy4Ed7qzbJLy3XlViKc5INNRiLipOBABP0alBzgIAAA==
X-CMS-MailID: 20220929121630epcas5p3e1ed2c5251276d557f8f921e8186620f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121630epcas5p3e1ed2c5251276d557f8f921e8186620f
References: <CGME20220929121630epcas5p3e1ed2c5251276d557f8f921e8186620f@epcas5p3.samsung.com>
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
Patches 11, 12 and 13 carve out a block helper and scsi/nvme then use it to
avoid duplication of code.

Using registered-buffers showed IOPS hike from 1.65M to 2.04M.
Without fixedbufs
*****************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=2481, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=0/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=2.60M, BW=1271MiB/s, IOS/call=32/31
IOPS=2.60M, BW=1271MiB/s, IOS/call=32/32
IOPS=2.61M, BW=1272MiB/s, IOS/call=32/32
IOPS=2.59M, BW=1266MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=2.61M

With fixedbufs
**************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=2487, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=3.15M, BW=1540MiB/s, IOS/call=32/31
IOPS=3.15M, BW=1538MiB/s, IOS/call=32/32
IOPS=3.15M, BW=1536MiB/s, IOS/call=32/32
IOPS=3.15M, BW=1537MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=3.15M

Changes since v10:
- Patch 3: Fix overly long line (Christoph)
- Patch 4: create a helper in block-map for vectored and non-vectored-io,
to be used by scsi and nvme (Christoph)
- Patch 5: Rename bio_map_get to blk_rq_map_bio_alloc and bio_map_put to
blk_mq_map_bio_put (Christoph)
- Patch 6: Split it into a prep patch and avoid duplicate checks (Christoph)
- Patch 7: Put changes to pass ubuffer as a integer in a separate prep patch and
simplify condition checks in nvme (Christoph)

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
  block: rename bio_map_put to blk_mq_map_bio_put
  block: add blk_rq_map_user_io
  scsi: Use blk_rq_map_user_io helper
  nvme: Use blk_rq_map_user_io helper

Kanchan Joshi (7):
  nvme: refactor nvme_add_user_metadata
  nvme: refactor nvme_alloc_request
  block: factor out blk_rq_map_bio_alloc helper
  block: add blk_rq_map_user_bvec
  block: extend functionality to map bvec iterator
  nvme: pass ubuffer as an integer
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 150 ++++++++++++++++++++++++++++++----
 drivers/nvme/host/ioctl.c     | 149 +++++++++++++++++++--------------
 drivers/scsi/scsi_ioctl.c     |  22 +----
 drivers/scsi/sg.c             |  22 +----
 include/linux/blk-mq.h        |   2 +
 include/linux/io_uring.h      |  10 ++-
 include/uapi/linux/io_uring.h |   9 ++
 io_uring/uring_cmd.c          |  26 +++++-
 8 files changed, 268 insertions(+), 122 deletions(-)

-- 
2.25.1


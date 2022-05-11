Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0DD522C51
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiEKGb0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiEKGb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:26 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7D13AA4B
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:23 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220511063118epoutp02ce2787808c765a6297dce04d5256d0da~t_Tzl8wqV1638016380epoutp020
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220511063118epoutp02ce2787808c765a6297dce04d5256d0da~t_Tzl8wqV1638016380epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250678;
        bh=OJArXs8DUZ3fGPlSsLcW8djg2eKp45BgYCklDNqxcu0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=tFH70/p6u8tW25DCV8odmK+RfzRgyG9lb0dFOTwWigYnn8XGsZZYE0yWS/Sla/1Vh
         PogKT2yfI3nOKym5U+69TxLIDValnzNNf0/vf8p21PYVM7MsL1E9Z1SIDXkDs7Gdbj
         vPx2nguiQg7/UA0q4a4LTyjckVQh/OeFFubYnLGc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220511063117epcas5p22f88786c2563784873ce401f5e302a72~t_Ty-DSrk1839618396epcas5p2q;
        Wed, 11 May 2022 06:31:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KylRN0FYhz4x9QK; Wed, 11 May
        2022 06:31:12 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.90.09762.8285B726; Wed, 11 May 2022 15:31:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da~t9ydZBOrM0985109851epcas5p3y;
        Wed, 11 May 2022 05:53:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511055306epsmtrp11fe8867ac6439a2a229d1a9e181b26fe~t9ydXYnl40124601246epsmtrp1-;
        Wed, 11 May 2022 05:53:06 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-ea-627b58281623
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.C2.08924.24F4B726; Wed, 11 May 2022 14:53:06 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055304epsmtip1c0649092c191d2700c460faa251122a9~t9ybqhrcE2613026130epsmtip1r;
        Wed, 11 May 2022 05:53:04 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 0/6] io_uring passthrough for nvme
Date:   Wed, 11 May 2022 11:17:44 +0530
Message-Id: <20220511054750.20432-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmlq5GRHWSwe4FhhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzRt+sRWcESu4uOX
        rywNjM2SXYwcHBICJhKzL+Z1MXJyCAnsZpTYPB3I5gKyPzFKLG9exgLhfGaUmPjmGgtIFUjD
        k47tjBCJXYwSrTfussFV/dg9kRFkLJuApsSFyaUgDSIC8hJfbq8Fm8QscJZRYtqtQ6wgCWEB
        U4lVr2aD2SwCqhIddzcwgdi8AhYSn442MEFsk5eYeek7O0RcUOLkzCdgVzADxZu3zmYGGSoh
        0MkhsePNF2aIBheJJ0eesUHYwhKvjm9hh7ClJF72t0HZyRKt2y+zQ/xfIrFkgTpE2F7i4p6/
        TCBhZqD71+/ShwjLSkw9tY4JYi2fRO/vJ1Cn8UrsmAdjK0rcm/SUFcIWl3g4YwmU7SGxddZF
        Fkjwxkp0/1/GOoFRfhaSb2Yh+WYWwuYFjMyrGCVTC4pz01OLTQuM81LL4dGanJ+7iRGcYrW8
        dzA+evBB7xAjEwfjIUYJDmYlEd79fRVJQrwpiZVVqUX58UWlOanFhxhNgUE8kVlKNDkfmOTz
        SuINTSwNTMzMzEwsjc0MlcR5T6VvSBQSSE8sSc1OTS1ILYLpY+LglGpgmiGsvlmjYrmsmJnY
        j6eLv5R+kv/Et1D1pa7Io75TrxkZkvWC5opzT35rPrM05PNtff2QXW/FmHfeW19vk+mlG3ep
        q3LKzxjDLZpWX02DmbWLk/if/r2or3oorf69wMbP2UVmjpebOvRUvM8++NWw9sHMmRcbfQKX
        Vmhsvu/ClnRsGZfjqw6HMr8XW8J39An9jPzsWl91xzRexPT5DAvnvYxP/k7a9jC8QdlA402Q
        ocQss4DdB/cU15yfnKqVx7Tm7ELZlWtFYxi4gp7fCkqpfrorNXNfcFLVE+YF/2caZp9MWTA5
        Oql3x2LuqQe89bkrXTd1LOxTUDZcKbX/M4/Dkmt9nFo5WX5862dNueCuxFKckWioxVxUnAgA
        7PY2IzoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSnK6Tf3WSwa+HchZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgymjZ9Yis4Ilfx8ctXlgbGZskuRk4OCQETiScd2xm7GLk4hAR2MErMuvuOHSIhLtF87QeU
        LSyx8t9zdoiij4wSZ5ZuAXI4ONgENCUuTC4FqRERUJTY+LEJbBCzwE1Gicet15hBEsICphKr
        Xs1mBbFZBFQlOu5uYAKxeQUsJD4dbWCCWCAvMfPSd3aIuKDEyZlPWEBsZqB489bZzBMY+WYh
        Sc1CklrAyLSKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM45LW0djDuWfVB7xAjEwfj
        IUYJDmYlEd79fRVJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgsky
        cXBKNTBt9zxitOraR6ufKnuVAjnuNwZntHN+Ey21d9rZOW31Ff/iXRH8hrFP2dcrHbm6p+P+
        cS3tw/n31vzP4VyyV+VG5/aJ+6ZF/zfiaLlz5ZxSTFiZkcjBKeocT88X6L1TyH22lT+z7EvF
        /hrZVcYTec5GvhaQyRPJ+nFXT231r+k980Krj0tGBMm6H3svbOXeWc984NnmRr/W9s++LDwO
        5h1fXRaxeITrLZ/xjt+im3P2t9KkxkKNe5H6X+adz/Fc3F7xLSvp1jTjyQW9d+Y+juedLaGz
        Osy7QsTbxcbW/ZvG3y8r3yw5fUa4b/eczeKriz4cuvfQcW7U29iSx+nFC4V5/3C6bJKL7P9X
        ZrrhxxclluKMREMt5qLiRACrwIeD6AIAAA==
X-CMS-MailID: 20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da
References: <CGME20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series is against "for-5.19/io_uring-passthrough" branch (linux-block).
Patches to be refreshed on top of 2bb04df7c ("io_uring: support CQE32").

uring-cmd is the facility to enable io_uring capabilities (async is one
of those) for any arbitrary command (ioctl, fsctl or whatever else)
exposed by the command-providers (driver, fs etc.). The series
introduces uring-cmd, and connects nvme passthrough (over generic device
/dev/ngXnY) to it.

uring-cmd is specified by IORING_OP_URING_CMD. The storage for the
command is provided in the SQE itself. On a regular ring, 16 bytes of
space is available, which can be accessed using "sqe->cmd".
Alternatively, application can setup the ring with the flag
IORING_SETUP_SQE128. In that case, each SQE of the ring is 128b in size,
and provides 80b of storage space for placing the command.

nvme io-passthrough is specified by new operation NVME_URING_CMD_IO.
This operates on a new structure nvme_uring_cmd which is 72b in size.
nvme passthrough requires two results to be returned to user-space.
Therefore ring needs to be setup with the flag IORING_SETUP_CQE32.
When this flag is specified, each CQE of the ring is 32b in size.
The uring-cmd infrastructure exports helpers so that additional result
is collected from the provider and placed into the CQE.

Testing is done using this custom fio branch:
https://github.com/joshkan/fio/tree/big-cqe-pt.v4
regular io_uring io (read/write) is turned into passthrough io on
supplying "-uring_cmd=1" option.

Example command line:
fio -iodepth=1 -rw=randread -ioengine=io_uring -bs=4k -numjobs=1 -size=4k -group_reporting -filename=/dev/ng0n1 -name=io_uring_1 -uring_cmd=1

Changes since v4:
https://lore.kernel.org/linux-nvme/20220505060616.803816-1-joshi.k@samsung.com/
- Allow uring-cmd to operate on regular ring too
- Move big-sqe/big-cqe requirement to nvme
- Add support for cases when uring-cmd needs deferral
- Redone Patch 3
- In nvme, use READ_ONCE while reading cmd fields from SQE
- Refactoring in Patch 4 based on the feedback of Christoph

Changes since v3:
https://lore.kernel.org/linux-nvme/20220503184831.78705-1-p.raghav@samsung.com/
- Cleaned up placements of new fields in sqe and io_uring_cmd
- Removed packed-attribute from nvme_uring_cmd struct
- Applied all other Christoph's feedback too
- Applied Jens feedback
- Collected reviewed-by

Changes since v2:
https://lore.kernel.org/linux-nvme/20220401110310.611869-1-joshi.k@samsung.com/
- Rewire uring-cmd infrastructure on top of new big CQE
- Prep patch (refactored) and feedback from Christoph
- Add new opcode and structure in nvme for uring-cmd
- Enable vectored-io

Changes since v1:
https://lore.kernel.org/linux-nvme/20220308152105.309618-1-joshi.k@samsung.com/
- Trim down by removing patches for polling, fixed-buffer and bio-cache
- Add big CQE and move uring-cmd to use that
- Remove indirect (pointer) submission

Anuj Gupta (1):
  nvme: add vectored-io support for uring-cmd

Christoph Hellwig (1):
  nvme: refactor nvme_submit_user_cmd()

Jens Axboe (3):
  fs,io_uring: add infrastructure for uring-cmd
  block: wire-up support for passthrough plugging
  io_uring: finish IOPOLL/ioprio prep handler removal

Kanchan Joshi (1):
  nvme: wire-up uring-cmd support for io-passthru on char-device.

 block/blk-mq.c                  |  73 +++++-----
 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 247 ++++++++++++++++++++++++++++++--
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   4 +
 fs/io_uring.c                   | 135 ++++++++++++++---
 include/linux/fs.h              |   2 +
 include/linux/io_uring.h        |  33 +++++
 include/uapi/linux/io_uring.h   |  21 +--
 include/uapi/linux/nvme_ioctl.h |  26 ++++
 10 files changed, 471 insertions(+), 72 deletions(-)

-- 
2.25.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0551B7CF
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 08:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiEEGRs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 02:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiEEGRr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 02:17:47 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154B546650
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 23:14:02 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220505061356epoutp025d8416f7cc5001e9d1e9d54c2d644384~sIM8IYPfK0134501345epoutp02j
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:13:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220505061356epoutp025d8416f7cc5001e9d1e9d54c2d644384~sIM8IYPfK0134501345epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651731236;
        bh=SirteYaixZFl2PphIfvNyLz3McWwjsJgELdIevDt99c=;
        h=From:To:Cc:Subject:Date:References:From;
        b=o0/oZP5IwwDgZB1XUy1qZ3wOmU5ycfVqj7MVKwHi+uOMLh2SlmfheNqnIBV04iyIq
         YrJwls81BLrE+VITGsarTs5zvf2PM3ceP3nRbwajJ41jS4poZCWUrlk4I8LAuQLRwO
         h5FJiFfzToOTOTnLab8vGcRe5KNez5n2td014Xbo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220505061356epcas5p324b82b7ed2fd4a85a111e2dcf163d560~sIM7k6HEJ1373913739epcas5p3Z;
        Thu,  5 May 2022 06:13:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Kv3L906XVz4x9Q1; Thu,  5 May
        2022 06:13:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.DC.09827.F1B63726; Thu,  5 May 2022 15:13:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c~sIK-JWNb51752117521epcas5p24;
        Thu,  5 May 2022 06:11:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505061142epsmtrp106ca4abe395f69ff90ca5adb02ef07ae~sIK-IYT4G1114811148epsmtrp1z;
        Thu,  5 May 2022 06:11:42 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-b1-62736b1fb07a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.1A.08853.E9A63726; Thu,  5 May 2022 15:11:42 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061140epsmtip20e2c91c012893fd2f63ef2afc8db532b~sIK9fdCoM0662506625epsmtip2c;
        Thu,  5 May 2022 06:11:40 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v4 0/5] io_uring passthrough for nvme
Date:   Thu,  5 May 2022 11:36:11 +0530
Message-Id: <20220505060616.803816-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmpq58dnGSwaI5BhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ2yZdZKtYD5/xZWX
        r5kbGOfwdDFyckgImEhs+zKNvYuRi0NIYDejxLy2y1DOJ0aJqw+mMINUCQl8Y5TovO8M03F1
        3mxGiKK9jBJ7unpYIZzPjBI73v9n62Lk4GAT0JS4MLkUpEFEQF7iy+21LCA1zAJnGSWm3TrE
        CpIQFjCVuNO+gAnEZhFQldjXsxAszitgKfHzcDMrxDZ5iZmXvrNDxAUlTs58wgJiMwPFm7fO
        ZgYZKiHQyyExt7eHDaLBReLj2jtQtrDEq+Nb2CFsKYmX/W1QdrJE63aQPzmA7BKJJQvUIcL2
        Ehf3/GUCCTMD3b9+lz5EWFZi6ql1TBBr+SR6fz9hgojzSuyYB2MrStyb9BTqZHGJhzOWQNke
        EidaW8E2CQnESix6kzSBUX4WkmdmIXlmFsLiBYzMqxglUwuKc9NTi00LjPJSy+HRmpyfu4kR
        nGK1vHYwPnzwQe8QIxMH4yFGCQ5mJRFe56UFSUK8KYmVValF+fFFpTmpxYcYTYEhPJFZSjQ5
        H5jk80riDU0sDUzMzMxMLI3NDJXEeU+nb0gUEkhPLEnNTk0tSC2C6WPi4JRqYIpZtO13ICsb
        y9QLMnyi7d+nXxcybxL3udgrknntzLt1zNfUGma1WzB7/LqtM1lOltlNk5/hUIJareeriEUT
        vvBt2/Ru21W9Xb3Xbsxb52ufkG1Xn22+YGZDa6mq3qUl2m6G79rXmRrFKWpbJj3jYPy0e9oZ
        a44S7TuLlqz8LZfp+2cDfzInG5+htGr2nOZIr1k23l9416w7GLHjQ8Idee+GIL1HS+VcjcUY
        Qt9mnyxwddW+32KwcNaBidH/11sKsMtYPeKsKjD6kSegy21XxrHvQbvJdqfPH4UVz7/fHqOy
        18n4zopNGt3vEqYdiPqe62oUW1LOxfM7LMHNvWbFbeFQ/nwH0bcXEm5+fPRTiaU4I9FQi7mo
        OBEAiU8MZDoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSvO68rOIkg0XLlSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBlbJl1kq1gPn/FlZevmRsY5/B0MXJySAiYSFydN5uxi5GLQ0hgN6PE/beXGCES4hLN136w
        Q9jCEiv/PWeHKPrIKPHt1A22LkYODjYBTYkLk0tBakQEFCU2fmwCG8QscJNR4nHrNWaQhLCA
        qcSd9gVMIDaLgKrEvp6FrCA2r4ClxM/DzawQC+QlZl76zg4RF5Q4OfMJC4jNDBRv3jqbeQIj
        3ywkqVlIUgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgSHvJbmDsbtqz7oHWJk
        4mA8xCjBwawkwuu8tCBJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalF
        MFkmDk6pBqbs/1svVrNetZd5HbYz+PnEU296pbsO7L174E7r0vC/LUVvDnNM6f33xulscWPw
        ve3uga8fcewWktYvELqv+DxjlZFQeNSUea+nyB58E3KZI1980lHDk8cX7q7Viyrq8cr7/mSB
        ahDj+XV7prVFJy+Z17N1keVaoQdCc9zd2Ji4jrjNSK375rT/QsDfk9v59M+vj5bwUtB0ZmD7
        fGtj28v3BvfdG05P/cQSMUVSb3FM8/zGtbqWq5quVcmxfdEsS2Tl7Og5N3fTb/0DV/xWMZx8
        OtdC9PCqUuM9hRnSlrq6HmoWvLdZb2+arSfu5aixIXqGzQ8dMbP9DWU/zU74q/eey0v0DbT6
        yR/h4G69fLsSS3FGoqEWc1FxIgDYhBcG6AIAAA==
X-CMS-MailID: 20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This iteration is against io_uring-big-sqe brach (linux-block).
On top of a739b2354 ("io_uring: enable CQE32").

fio testing branch:
https://github.com/joshkan/fio/tree/big-cqe-pt.v4

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

Jens Axboe (2):
  fs,io_uring: add infrastructure for uring-cmd
  block: wire-up support for passthrough plugging

Kanchan Joshi (1):
  nvme: wire-up uring-cmd support for io-passthru on char-device.

 block/blk-mq.c                  |  73 ++++++-----
 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 215 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   5 +
 fs/io_uring.c                   |  82 ++++++++++--
 include/linux/fs.h              |   2 +
 include/linux/io_uring.h        |  27 ++++
 include/uapi/linux/io_uring.h   |  21 ++--
 include/uapi/linux/nvme_ioctl.h |  26 ++++
 10 files changed, 398 insertions(+), 55 deletions(-)

-- 
2.25.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE105B2615
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiIHSpl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiIHSpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:40 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C54760CA
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:32 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220908184529epoutp04dfde1a841b951801fdda8710923ede51~S9vGJbx9-0954109541epoutp04a
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220908184529epoutp04dfde1a841b951801fdda8710923ede51~S9vGJbx9-0954109541epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662729;
        bh=etID3tAPfm1+JvOZ3BYza6dohn9MxI+tzX18nZ3boSI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UawL5kRSgxYlX3FpR4GpKogkWVXyb+Sc/SyZ27cXvmZnTH3KaO3eZO/k2mdjQdbYj
         5PQmDliRrAPVDIc+/CRoMI1+Z5YhWqqE9UR6BFr9yOQW6AW/7NJ1JFyhaH9TUhgXHV
         4GEzJBWWOBPxaIQkIefn46PXMdbHpdKA5wp2ihos=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220908184528epcas5p17ef96cc743cd7d71770211b5a6599b09~S9vE4WCel0840908409epcas5p1r;
        Thu,  8 Sep 2022 18:45:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MNp3968tBz4x9Pp; Thu,  8 Sep
        2022 18:45:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.FE.59633.5483A136; Fri,  9 Sep 2022 03:45:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220908184525epcas5p4cec88afa56beb0e5222e23c2344dbc8a~S9vCCXzVF0530505305epcas5p4Y;
        Thu,  8 Sep 2022 18:45:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184525epsmtrp11b511f9c926f6f2c22c31b76253a0350~S9vCBnaVe2970229702epsmtrp1e;
        Thu,  8 Sep 2022 18:45:25 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-2b-631a3845e924
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.DD.14392.5483A136; Fri,  9 Sep 2022 03:45:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184523epsmtip2921bf26f848457db6323b6fe0aa52e80~S9vAuXv492343623436epsmtip2v;
        Thu,  8 Sep 2022 18:45:23 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v6 0/5] fixed-buffer for uring-cmd/passthru
Date:   Fri,  9 Sep 2022 00:05:06 +0530
Message-Id: <20220908183511.2253-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTS9fVQirZ4OIEfYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMsw8eMBZ84KnY+X4RcwNjL1cXIyeHhICJxPoTjWxdjFwc
        QgK7GSXezpnJDuF8YpRY8uAHaxcjB5DzjVGirxqm4dCu5YwgtpDAXkaJ9j2+EPWfGSX2HbvA
        DFLPJqApcWFyKUiNiICXxP3b71lBapgFZjBKrO54zQ5SIyzgItH/NBCkhkVAVeL5ta/sIDav
        gLnE/vUrWSB2yUvMvPQdKi4ocXLmE7A4M1C8eetsZoial+wS3zf5Q9guEqfPvGOHsIUlXh3f
        AmVLSbzsb4OykyUuzTzHBGGXSDzecxDKtpdoPdUPdj4z0Pnrd+lDrOKT6P39hAkkLCHAK9HR
        JgRRrShxb9JTVghbXOLhjCVQtofEywVfmSChEytx7OdxpgmMcrOQPDALyQOzEJYtYGRexSiZ
        WlCcm55abFpgmJdaDo/H5PzcTYzg1KjluYPx7oMPeocYmTgYDzFKcDArifCKrpVIFuJNSays
        Si3Kjy8qzUktPsRoCgzVicxSosn5wOScVxJvaGJpYGJmZmZiaWxmqCTOO0WbMVlIID2xJDU7
        NbUgtQimj4mDU6qByeX96c48t5d1S7IT1rh+XSLfo1KUHnFLrVWdoefuFNYLLY67yiK+Fk2f
        xvdTbdfbb48e7RO8ZZHmmlHr80X6W1X9bN/q9fc38Eqvz1vXdlj2jR1HaqzMel6fJmPR04/F
        Z4mLphvaxk5yLq2w7JisJFSorr419m+DpseXaaZnuT+UJO6/+UstZPMdtfcX/u++VPT90EUj
        w5PV97pj5Xuv7wnb5e1msiiGTZ7j9cF9CYaTL3UEnJ4359y0zas9TqmqKur8zL+0j6vowKVN
        em68iRX7uxTK5/smxfn/X3D47uvXW+V/7t+9wenXX8/vdSs+O00vO3lb6ujBaK/T/UzdoZHm
        lQZa5Qkqf7qFCn81K7EUZyQaajEXFScCAKQ2h7gWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsWy7bCSvK6rhVSywd3zPBZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsEroyzDx4wFnzgqdj5fhFzA2MvVxcj
        J4eEgInEoV3LGbsYuTiEBHYzSqxdf48ZIiEu0XztBzuELSyx8t9zdoiij4wS7c9Os3QxcnCw
        CWhKXJhcClIjIhAgcbDxMlgNs8AcRonLl/ewg9QIC7hI9D8NBKlhEVCVeH7tK9hMXgFzif3r
        V7JAzJeXmHnpO1RcUOLkzCdgcWagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1
        XK84Mbe4NC9dLzk/dxMjOIy1NHcwbl/1Qe8QIxMH4yFGCQ5mJRFe0bUSyUK8KYmVValF+fFF
        pTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwbUlturF+swf3ut3SAu6eW1U7
        t6nlrjp4t/xrMaMy7++2p5UrF4ps2BGy2E3fYc3Oc2tifpmcTvN2W97VItrjM0HJadWMH972
        Z0/ZudR4JeiYWuh5Ngfaqp3zeLhFvm2qFEdwhrO5fBrPh9kv1JU8kv5MzmZwux1xaqlXz1TJ
        wtTNNk6ballmKl2pzpD5nqKoOeu17dTaONXPKRw+S/6k3lo6PW3ijp+WtbeNb82Uz/i08Ncq
        4y+PTpm/j8vP5zdd9MZxbqxxrJpkc23f54ZzvMsfrruprZP03lfTfltg/9tljV3PtI9mLApW
        knnUvFd0QsN53v032KtexDxayPigQJW/cY+V0pliqdKzn4uVWIozEg21mIuKEwHN/4Ts0gIA
        AA==
X-CMS-MailID: 20220908184525epcas5p4cec88afa56beb0e5222e23c2344dbc8a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184525epcas5p4cec88afa56beb0e5222e23c2344dbc8a
References: <CGME20220908184525epcas5p4cec88afa56beb0e5222e23c2344dbc8a@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently uring-cmd lacks the ability to leverage the pre-registered
buffers. This series adds that support in uring-cmd, and plumbs
nvme passthrough to work with it.

Using registered-buffers showed IOPS hike from 1.9M to 2.2M in my tests.

Patch 1, 3, 4 = prep
Patch 2 = expand io_uring command to use registered-buffers
Patch 5 = expand nvme passthrough to use registered-buffers

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

Kanchan Joshi (3):
  nvme: refactor nvme_alloc_user_request
  block: add helper to map bvec iterator for passthrough
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               |  87 ++++++++++++++++++++---
 drivers/nvme/host/ioctl.c     | 126 +++++++++++++++++++++-------------
 include/linux/blk-mq.h        |   1 +
 include/linux/io_uring.h      |  10 ++-
 include/uapi/linux/io_uring.h |   9 +++
 io_uring/uring_cmd.c          |  26 ++++++-
 6 files changed, 199 insertions(+), 60 deletions(-)

-- 
2.25.1


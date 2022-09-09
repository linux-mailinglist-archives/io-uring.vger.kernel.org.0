Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1A45B354B
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIIKbt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIIKbs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:31:48 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56431EAF4
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:31:43 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220909103137epoutp03b16ef2d28d9b16384366282bfc4a9c65~TKpLWy6xJ1779417794epoutp034
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:31:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220909103137epoutp03b16ef2d28d9b16384366282bfc4a9c65~TKpLWy6xJ1779417794epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719497;
        bh=wqdABHPFBzRsEMMaFgsQlw4r6ifA2U4eAcpnTIF1quQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=WRlbDt64qEXs+0StnzCxPn0bNgUsnyzwTKjaepdXrlJ1bOAD5aV+/M2DbubYERONu
         2eB1CIJGFOJEePFxpQCOyi8ZxLiOhUk3RR9j9CCDpmV9vzZHJiueIYwlUrzREB0QRT
         OGSa0i6CLjpRg5gss1ZdBavZYqUTXZ0CRDXanfiA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220909103136epcas5p1e2a8de193207d3f383240c48a5fc2115~TKpKMYGWL0763207632epcas5p12;
        Fri,  9 Sep 2022 10:31:36 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MPC2r4D1Bz4x9Px; Fri,  9 Sep
        2022 10:31:32 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.AA.53458.4061B136; Fri,  9 Sep 2022 19:31:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220909103131epcas5p23d146916eccedf30d498e0ea23e54052~TKpF-9TIC0262302623epcas5p2x;
        Fri,  9 Sep 2022 10:31:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220909103131epsmtrp27d7bf030e05a44b7c2404566052bcd99~TKpF-Hvax1218912189epsmtrp2H;
        Fri,  9 Sep 2022 10:31:31 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-5d-631b1604bb84
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.B1.18644.3061B136; Fri,  9 Sep 2022 19:31:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103130epsmtip12143dc570e2cc7db659d46d998831ff7~TKpEi9ZMe1206712067epsmtip1Y;
        Fri,  9 Sep 2022 10:31:30 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v7 0/5] fixed-buffer for uring-cmd/passthru
Date:   Fri,  9 Sep 2022 15:51:31 +0530
Message-Id: <20220909102136.3020-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdlhTQ5dFTDrZ4NpERYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMx1e9C47xVky/+oW1gfESVxcjJ4eEgInE/O0vmboYuTiE
        BHYzShw4PZ0VJCEk8IlR4sbOIIjEZ0aJz90XmWA6Nk3/yQhRtItR4uolf7iiiZevsXUxcnCw
        CWhKXJhcClIjIuAlcf/2e1aQGmaBGYwSqztes4MkhAVcJLbeeQS2jUVAVeLvpVZmEJtXwFzi
        612QOSDL5CVmXvrODhEXlDg58wkLiM0MFG/eOpsZZKiEwFt2iWN7tzBDNLhI7Py/AOpSYYlX
        x7ewQ9hSEp/f7YUamixxaeY5qJoSicd7DkLZ9hKtp/qZQR5gBnpg/S59iF18Er2/nzCBhCUE
        eCU62oQgqhUl7k16ygphi0s8nLEEyvaQWNGymQ0SPrESO1qWsE1glJuF5INZSD6YhbBsASPz
        KkbJ1ILi3PTUYtMCo7zUcnhMJufnbmIEp0ctrx2MDx980DvEyMTBeIhRgoNZSYRXdK1EshBv
        SmJlVWpRfnxRaU5q8SFGU2CwTmSWEk3OBybovJJ4QxNLAxMzMzMTS2MzQyVx3inajMlCAumJ
        JanZqakFqUUwfUwcnFINTKp3S4oPBv3YNDtIzNphWlFpfO6PLfMNnXzzE+1fyBqdYzJeOi3k
        1VdvlrQ5v6y4zXYdOGKwTHNDqvexnbM/8mse315vKsByLkKruUtnhW7mwxaGFZpyrQ+S3UT8
        Ffuv7ZiTu37ahAs2+98aqhzkn+/4R2H2O82OZxurf09lZPm3XfnHsZzefnnfs1d+ywuxOkUl
        CSV3m/26OjM8ukSm7YHa78oP9W/9pZ571Bz4W/vsx4b1jwuiinkP7ymcKJNrLOae7/qH63bU
        Of1XrFE7hP5dcNm2RfWhWMHuzow7nYJbEqqyA9/dWSG/oYPB7/BDWX+jA7OFihev2hjWt962
        acIUH8FbM9dxRh7OM+XwUGIpzkg01GIuKk4EAK9ckm4YBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnC6zmHSyweGDmhZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsErozHV70LjvFWTL/6hbWB8RJXFyMn
        h4SAicSm6T8Zuxi5OIQEdjBKLD93hhUiIS7RfO0HO4QtLLHy33MwW0jgI6PEnWsaXYwcHGwC
        mhIXJpeChEUEAiQONl5mB5nDLDCHUeLy5T1g9cICLhJb7zwCm8kioCrx91IrM4jNK2Au8fXu
        NTaI+fISMy99Z4eIC0qcnPmEBcRmBoo3b53NPIGRbxaS1CwkqQWMTKsYJVMLinPTc4sNC4zy
        Usv1ihNzi0vz0vWS83M3MYKDWEtrB+OeVR/0DjEycTAeYpTgYFYS4RVdK5EsxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA1PDl32bZ7IInskN2/1g0cyw
        ZbtP9MeLmohqVCfafJXS4Gzn25jfkdHa6jbRZZvP2Y8utYnczx8sC5RslkzedMvX+YLW8V3W
        4oqMvwz8/qsppsWLet6WecgsvojbRqy44/KidMm7hybNOsCR3Blq8XVLHdeJyXnXysM6JBq2
        2j2RSn+Qsnz1mgSes7XbFV893/vW2ULAclJnvqDLwXkfv8saHzB5vdKj7FvYJSev/aIN0Y89
        chIyPn9mXOXrKRB26oHD84n7v4jKXDjxfbL6i/q1ilpxjGrTFucI/nNd9sVcWiEjM5Y76LzY
        IYflDxa+NVz5okb5wvvXqZPW192ekTGl8FbmuWPrCu59u21ue1uJpTgj0VCLuag4EQBgbpws
        0QIAAA==
X-CMS-MailID: 20220909103131epcas5p23d146916eccedf30d498e0ea23e54052
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103131epcas5p23d146916eccedf30d498e0ea23e54052
References: <CGME20220909103131epcas5p23d146916eccedf30d498e0ea23e54052@epcas5p2.samsung.com>
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


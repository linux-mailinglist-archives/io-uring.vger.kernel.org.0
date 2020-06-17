Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305701FD367
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 19:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQR06 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 13:26:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57085 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFQR05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 13:26:57 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200617172654epoutp010a756d97c2bda5a9bc354a5650b2d5ed~ZZNZRER321947919479epoutp01O
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 17:26:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200617172654epoutp010a756d97c2bda5a9bc354a5650b2d5ed~ZZNZRER321947919479epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592414814;
        bh=quPbHKvd3t/tKAk2Vd44HQREZ4TCnzbl9br8Bua5p/U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=c8R3jE9qpFiVNWBul/7uKvYg46FVpVZZfnzr/9TKEgYFbwHlPoWzdd2HPftrmgFlX
         QtEhqHWeNsQoQbhY3EjNUruGJsSvSvypePgNs3TJiQekAQf0B84Zx2hGOp05W9TwBE
         OfLYeYUNYgOBubIBAW/YkV8ATNw6tE7wB0s87uEA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200617172654epcas5p29bf502ec3f75e53e630e5ced45725658~ZZNYscZFV2352223522epcas5p2U;
        Wed, 17 Jun 2020 17:26:54 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.66.09475.E525AEE5; Thu, 18 Jun 2020 02:26:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200617172653epcas5p488de50090415eb802e62acc0e23d8812~ZZNYDZtWv0132401324epcas5p4Y;
        Wed, 17 Jun 2020 17:26:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200617172653epsmtrp19806cab50c6c159c2b00e4bbf421e4d9~ZZNYAp-BX1872618726epsmtrp1-;
        Wed, 17 Jun 2020 17:26:53 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-21-5eea525e12d2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.7E.08303.D525AEE5; Thu, 18 Jun 2020 02:26:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200617172651epsmtip1c8390df6b20117c9b29b6c11e6f54825~ZZNWEdhr61054210542epsmtip1D;
        Wed, 17 Jun 2020 17:26:51 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 0/3] zone-append support in aio and io-uring
Date:   Wed, 17 Jun 2020 22:53:36 +0530
Message-Id: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWy7bCmum5c0Ks4gxcbuSxW3+1ns+j6t4XF
        4l3rORaLx3c+s1sc/f+WzWLhxmVMFlOmNTFa7L2lbbFn70kWi8u75rBZbPs9n9niypRFzBav
        f5xkszj/9zirA5/H5bOlHps+TWL36NuyitHj8yY5j01P3jIFsEZx2aSk5mSWpRbp2yVwZdyb
        /IW54Ct7xdL//UwNjBPYuhg5OSQETCS+PtrECmILCexmlLhxqbiLkQvI/sQo8WfvCSYI5zOj
        xOeDU1hhOi5suMcOkdjFKHHk0glGuKrmLTOB5nJwsAloSlyYXApiigjYSOxcogLSyyzQwCTx
        /7sOiC0MFD7dvJQFpIRFQFVi6VsrkDCvgJPEl3/zmCFWyUncPNfJDDJdQuAeu0TvgcVQN7hI
        LPq7CqpIWOLV8S3sELaUxMv+Nii7WOLXnaNQzR2MEtcbZrJAJOwlLu75ywSymBnozPW79CFu
        45Po/f0ELCwhwCvR0SYEUa0ocW/SU6i14hIPZyyBsj0kJvW0MUICLlbiy7G57BMYZWYhDF3A
        yLiKUTK1oDg3PbXYtMA4L7Vcrzgxt7g0L10vOT93EyM4OWh572B89OCD3iFGJg7GQ4wSHMxK
        IrzOv1/ECfGmJFZWpRblxxeV5qQWH2KU5mBREudV+nEmTkggPbEkNTs1tSC1CCbLxMEp1cC0
        UiJh2vxjEwVeePcYzLSUYjJeqvag+g7P3ulRc01L/OcmHrO0z1ivvkHug05FxMvcizJHpC9F
        v/3O1r/Mp+mJ+bmT9lrZ5d7Xk9IXVn8JMnxv9ktR4UbWPTeWSUmL2RTeMM3okD/5J6N5Pm9w
        0/kzttJPwjv9dH0aJizb8EB00kIJ3Xd8UxVO2ukYlK+aHiS1ZUct3+RTMhUH3f9OPdjUcI1x
        XmKRKV9viNtrTt8ANf/puYnPXs7ZzPy62dXiykybJdt+73b/wFX9MGAKkx9HjEjTuRu+OlJ9
        B7jsj9//E2p8X+Z1moZIz7t/ir28c5szxJi8jyl/VzVVvHKj6yvvC90La4NVVj3pv9zxw1SJ
        pTgj0VCLuag4EQCZtNXMfQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsWy7bCSnG5s0Ks4g6cXZSxW3+1ns+j6t4XF
        4l3rORaLx3c+s1sc/f+WzWLhxmVMFlOmNTFa7L2lbbFn70kWi8u75rBZbPs9n9niypRFzBav
        f5xkszj/9zirA5/H5bOlHps+TWL36NuyitHj8yY5j01P3jIFsEZx2aSk5mSWpRbp2yVwZdyb
        /IW54Ct7xdL//UwNjBPYuhg5OSQETCQubLjHDmILCexglFjXGwYRF5dovvaDHcIWllj57zmQ
        zQVU85FRoufXIqYuRg4ONgFNiQuTS0FqRAQcJLqOP2YCqWEW6GKSOHFzFxNIQljARuJ081IW
        kHoWAVWJpW+tQMK8Ak4SX/7NY4aYLydx81wn8wRGngWMDKsYJVMLinPTc4sNC4zyUsv1ihNz
        i0vz0vWS83M3MYKDUEtrB+OeVR/0DjEycTAeYpTgYFYS4XX+/SJOiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO/XWQvjhATSE0tSs1NTC1KLYLJMHJxSDUyBX/V6+Riuvjygsub21p12rE9arr6/
        Jslx8bzj7Zl93eIFz2fW8+/b8Ovni+aCokI/X6aP/bnqbmf9i1fdOR6zV+Wm/SXu+NsdRsUx
        nCe4LvVmTXkQu7JTUtQlJXCaTn0xJ/eirY9VzOskrC7/mXYzk7tFzbmgQjeaq93wQFqssqNk
        zal/0bzdJYyZRy3NPFV7ldZkbz9TL6QXpbJclLnon/BD4fun5ojHzZvBKH112pmVu/mW3bw3
        /5ga80+L1Yof+cqMu/UmhNxi2+euK1SQtsr0M9/O6C5Ji4mPFl5ydCuQXyt5luVNYvzMzvW3
        o1QesV84933lrHlR2W3nItYFNU18curnVsZkh9LodiWW4oxEQy3mouJEADL6srGxAgAA
X-CMS-MailID: 20200617172653epcas5p488de50090415eb802e62acc0e23d8812
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172653epcas5p488de50090415eb802e62acc0e23d8812
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset enables issuing zone-append using aio and io-uring direct-io interface.

For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses start LBA
of the zone to issue append. On completion 'res2' field is used to return
zone-relative offset.

For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
Since io_uring does not have aio-like res2, cqe->flags are repurposed to return zone-relative offset

Kanchan Joshi (1):
  aio: add support for zone-append

Selvakumar S (2):
  fs,block: Introduce IOCB_ZONE_APPEND and direct-io handling
  io_uring: add support for zone-append

 fs/aio.c                      |  8 +++++
 fs/block_dev.c                | 19 +++++++++++-
 fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h            |  1 +
 include/uapi/linux/aio_abi.h  |  1 +
 include/uapi/linux/io_uring.h |  8 ++++-
 6 files changed, 105 insertions(+), 4 deletions(-)

-- 
2.7.4


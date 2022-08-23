Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED47659EA9F
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiHWSND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiHWSMo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:12:44 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14829C2D4
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:25:11 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220823162509epoutp0325e6b5105d5b0691ab7ac37faf4159da~OBf-rMY121743717437epoutp03i
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:25:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220823162509epoutp0325e6b5105d5b0691ab7ac37faf4159da~OBf-rMY121743717437epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661271909;
        bh=+JwdLX3LDqZdHqZc5/wYvF53cEqFvSfkwVSMM1ilrK0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=K3y/aqqH246qkuZeh/4pSlwCDSC5cUxcTGDFMZZWv8Yx7x+e8j073uouKz552ImKJ
         haSRbx65iIDBu5QPcX7WKR10ndVqRjirFVy7GzGd0p10mTmGS5k+YDbXyJKWQrkYom
         TG2vitR2iRpFBjprC05FcsnUUdDWLg2apiNbMSSs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220823162507epcas5p3320657493a977d83c9d78325172576a4~OBf_eJJ191818618186epcas5p32;
        Tue, 23 Aug 2022 16:25:07 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MBvhd5bvyz4x9Pr; Tue, 23 Aug
        2022 16:25:05 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        80.9A.15517.16FF4036; Wed, 24 Aug 2022 01:25:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162504epcas5p22a67e394c0fe1f563432b2f411b2fad3~OBf7libCn2988329883epcas5p2Y;
        Tue, 23 Aug 2022 16:25:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823162504epsmtrp1d9a6b66c567d1469dcb438e15782ebb5~OBf7kpsm02268222682epsmtrp1H;
        Tue, 23 Aug 2022 16:25:04 +0000 (GMT)
X-AuditID: b6c32a4b-e21ff70000003c9d-92-6304ff61bc4e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.02.14392.06FF4036; Wed, 24 Aug 2022 01:25:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162503epsmtip2989978bba8d963febc1896ec9ab46b61~OBf6JlUi43113231132epsmtip2L;
        Tue, 23 Aug 2022 16:25:03 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 0/4] iopoll support for io_uring/nvme
Date:   Tue, 23 Aug 2022 21:44:39 +0530
Message-Id: <20220823161443.49436-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTUzfxP0uyQdMKDYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i0OTm5kcuDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnTFtw0uWgqVcFYs3nGFqYLzB3sXIySEh
        YCJxe/MWJhBbSGA3o8Tq04EQ9idGicfPZSDsb4wS/3cXwdTP2H6CpYuRCyi+l1Fiz411jBDO
        Z0aJjdenMHcxcnCwCWhKXJhcCtIgIuAlcf/2e1aQGmaBtYwSp/d+AdsmLOAocXzFXBYQm0VA
        VeLE4XZ2kF5eAQuJf8f9IJbJS8y89B3sUF4BQYmTM5+AlTMDxZu3zmaGqPnLLnFygxOE7SLx
        40IXC4QtLPHq+BaoJ6UkXva3QdnJEpdmnmOCsEskHu85CGXbS7Se6gc7nxno/PW79CFW8Un0
        /n7CBBKWEOCV6GgTgqhWlLg36SkrhC0u8XDGEijbQ2L2iR2MkGCLlVi7dw3rBEa5WUgemIXk
        gVkIyxYwMq9ilEwtKM5NTy02LTDOSy2Hx2Nyfu4mRnC61PLewfjowQe9Q4xMHIyHGCU4mJVE
        eK2OsSQL8aYkVlalFuXHF5XmpBYfYjQFBupEZinR5Hxgws4riTc0sTQwMTMzM7E0NjNUEued
        os2YLCSQnliSmp2aWpBaBNPHxMEp1cC03i3e469Cj1+GYH29nGDU51mxax44JKXd/Pl1wo0b
        YaUzJeey3310ljM7J2u1vkhRwG8lawvNAhf/GqZUr2W9HoKbcq8tZd9xtf+N4COljT+fsF3Y
        7Tuv4b2HaGB+w8frJ7t0lr5/rf5kbt+0PbcjQydI5uYVOjpr+n/537zQWpVvX+annZVuvJ/i
        Xr+851Dw50D7jeOqods32NUesRLsr+qaoLyW0/N8nH3V5t+dCw7uMvV//0a+8vRRJ1sd3huZ
        qcGPAtjO7pzL9HynXK7Xhs5O2b0GTzbP82XJediyuVfmhWKN8NuKRNsDh0tdvastHoW27J7I
        aiAilLjw3RMh2b7cqDuTBarfObxW/6vEUpyRaKjFXFScCAAup+Q6IAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSvG7Cf5ZkgzVf9C3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5vH+31X2Tz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY9qGlywFS7kq
        Fm84w9TAeIO9i5GTQ0LARGLG9hMsXYxcHEICuxkl3hy6xgaREJdovvYDqkhYYuW/5+wQRR8Z
        JSa+ecPaxcjBwSagKXFhcilIjYhAgMTBxstgNcwCmxklPp0+xgySEBZwlDi+Yi4LiM0ioCpx
        4nA7O0gvr4CFxL/jfhDz5SVmXvoOtotXQFDi5MwnYOXMQPHmrbOZJzDyzUKSmoUktYCRaRWj
        ZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnBoa2nuYNy+6oPeIUYmDsZDjBIczEoivFbH
        WJKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYFr0ZWte
        9mrnGp5AjpWVVoZR59l3cxfefbCeYZtSSE7k3Ni4bZvXXVeT4IjUyFln/GLRiovdPVtnReWX
        a4jnXFbfeuPDtJuMK2uWV1w/ocA5bXPGfb+GYH92c5l36+a6r27zYa+8mKShcsKaNe2brmvg
        8e1fn1QmMHYEpEy4dlyAr4/n2d67W7ZPWXFI3jDoW/PzcreuU7s9n7488nW5RcoUWavHR2JP
        T+vg8H/EaHrkucxMDVPPyoW6R1f2rziXwut1tOh5jMsXBt6trAo//a5a73D+Pj895GSeU8KB
        1Kwfm2V5v7Nw9FRtmKc8n/1yzLTpLv8OfvrfNFFLSYmT5bRzXm7NqtA9N1XZK8Vm+yixFGck
        GmoxFxUnAgCvA68s3AIAAA==
X-CMS-MailID: 20220823162504epcas5p22a67e394c0fe1f563432b2f411b2fad3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823162504epcas5p22a67e394c0fe1f563432b2f411b2fad3
References: <CGME20220823162504epcas5p22a67e394c0fe1f563432b2f411b2fad3@epcas5p2.samsung.com>
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

Series enables async polling on io_uring command, and nvme passthrough
(for io-commands) is wired up to leverage that.
This gives nice IOPS hike (even 100% at times) particularly on lower
queue-depths.

Changes since v2:
- rebase against for-next (which now has bio-cache that can operate on
  polled passthrough IO)
- bit of rewording in commit description

Changes since v1:
- corrected variable name (Jens)
- fix for a warning (test-robot)

Kanchan Joshi (4):
  fs: add file_operations->uring_cmd_iopoll
  io_uring: add iopoll infrastructure for io_uring_cmd
  block: export blk_rq_is_poll
  nvme: wire up async polling for io passthrough commands

 block/blk-mq.c                |  3 +-
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/ioctl.c     | 73 ++++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c |  1 +
 drivers/nvme/host/nvme.h      |  2 +
 include/linux/blk-mq.h        |  1 +
 include/linux/fs.h            |  1 +
 include/linux/io_uring.h      |  8 +++-
 io_uring/io_uring.c           |  6 +++
 io_uring/opdef.c              |  1 +
 io_uring/rw.c                 |  8 +++-
 io_uring/uring_cmd.c          | 11 +++++-
 12 files changed, 105 insertions(+), 11 deletions(-)


base-commit: 15e543410e9ba86d36a0410bdaf0c02f59fb8936
-- 
2.25.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5197658ADB6
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbiHEPzL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 11:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiHEPyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 11:54:51 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4547539F
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 08:53:20 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220805155302epoutp02499d7f7fecb8673a130001cff9f6b653~Ifc0zrH2i1590815908epoutp029
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 15:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220805155302epoutp02499d7f7fecb8673a130001cff9f6b653~Ifc0zrH2i1590815908epoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659714783;
        bh=lVh3MRQWInchqFd9gbvHencVUc4hQ2iwy25Ef8ubq44=;
        h=From:To:Cc:Subject:Date:References:From;
        b=JtJoiMXqv/0PzUWjr+XI74zA8TmICWs0Oc6i0deXHqlydIQ9E05GwDbqRcFtz1mHo
         D4hP9itOm340a+Oe9ae/+Q7+msTeWDIbLm/xuaU6krtChcMZShQT1ECivNE5V+NCAE
         VKuijL9P7Ygqlr5uoSDii2ur4ks7SLuL/9UcTkwM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220805155302epcas5p46165492d2c0691f862f1b0e220e999bb~Ifc0JOsHe2142821428epcas5p4D;
        Fri,  5 Aug 2022 15:53:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lzqqw3lYtz4x9Pq; Fri,  5 Aug
        2022 15:53:00 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.4A.09662.CDC3DE26; Sat,  6 Aug 2022 00:53:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220805155300epcas5p1b98722e20990d0095238964e2be9db34~IfcyNoFxP2221822218epcas5p1i;
        Fri,  5 Aug 2022 15:53:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220805155300epsmtrp2fccc82510b2b2ec3bd9879b9cbb86fcb~IfcyMxIIE2288122881epsmtrp2v;
        Fri,  5 Aug 2022 15:53:00 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-4f-62ed3cdcec20
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.B9.08905.CDC3DE26; Sat,  6 Aug 2022 00:53:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155258epsmtip240eb84dafda4d21247400ad62ff313e0~Ifcw3OxUL1210312103epsmtip2Y;
        Fri,  5 Aug 2022 15:52:58 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Date:   Fri,  5 Aug 2022 21:12:22 +0530
Message-Id: <20220805154226.155008-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTU/eOzdskg45bMhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzeL828NMFntvaVvMX/aU3eLQ5GYmB06PnbPusntcPlvqsXlJvcfu
        mw1sHu/3XWXz6NuyitHj8ya5APaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZp3deYCk4KVKxd8Ee9gbG+/xdjJwcEgImEpufbmMDsYUE
        djNKbJkR3MXIBWR/YpRov/aCBcL5xijRs3s6M0zHinfnoBJ7GSXeHG9gg3A+M0ocmNMC5HBw
        sAloSlyYXArSICIgL/Hl9lqwBmaBQ4wSz5e8ApskLOAoMWv/KTCbRUBVYtvf/SwgNq+ApcTm
        xbPZILbJS8y89J0dIi4ocXLmE7AaZqB489bZzCBDJQTesktMurOCEaLBRWJV9wdWCFtY4tXx
        LewQtpTE53d7oYYmS1yaeY4Jwi6ReLznIJRtL9F6qp8Z5AFmoAfW79KH2MUn0fv7CRNIWEKA
        V6KjTQiiWlHi3qSnUJvEJR7OWAJle0jcW9vEDgnSWInJ73+xT2CUm4Xkg1lIPpiFsGwBI/Mq
        RsnUguLc9NRi0wLDvNRyeFwm5+duYgSnSC3PHYx3H3zQO8TIxMEIDE4OZiUR3p87XicJ8aYk
        VlalFuXHF5XmpBYfYjQFButEZinR5Hxgks4riTc0sTQwMTMzM7E0NjNUEuf1uropSUggPbEk
        NTs1tSC1CKaPiYNTqoGJb2GD70+hrRMDL9lEXmm8IbJ9aewdMVG+XT6NHQ2KQtUv2+SYy6Je
        ZikcCli9d+eC8lLrNyeqN/7tMpOWeCGzO0d/yoOu9Jfb8lMaT02MdOXMfO3If4+fK8pPezNv
        btntLTwbv0/7p686c1LzaTaTv8uvOG5Mfuyqc15tyUf5LvtXPQfV3NYuXefkxvmFzfH5zwCX
        fr2Jx9TFzJsVJ+t/Szx942x9/oY9FYbh147mtP3Uyl6yO1nnkYW12GW1xAqTB5+Nrwt0lts/
        ePFE/G/m+4stZyu2znrfaPVOq2kWX0Kautb6KXmLrT+2e18PfXP80sk962rLW78dZ14s91jV
        8MdO5Rnnzm6IqnkW9T9TiaU4I9FQi7moOBEAWWhcdBoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWy7bCSvO4dm7dJBg1trBar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzeL828NMFntvaVvMX/aU3eLQ5GYmB06PnbPusntcPlvqsXlJvcfu
        mw1sHu/3XWXz6NuyitHj8ya5APYoLpuU1JzMstQifbsErozTOy+wFJwUqdi7YA97A+N9/i5G
        Tg4JAROJFe/OsXQxcnEICexmlFj+dBUrREJcovnaD3YIW1hi5b/n7BBFHxkl1kz4wtjFyMHB
        JqApcWFyKUiNiICixMaPTYwgNcwCpxgl3h99wwKSEBZwlJi1/xQziM0ioCqx7e9+sDivgKXE
        5sWz2SAWyEvMvPSdHSIuKHFy5hOwGmagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDA
        MC+1XK84Mbe4NC9dLzk/dxMjOJC1NHcwbl/1Qe8QIxMH4yFGCQ5mJRHenzteJwnxpiRWVqUW
        5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA1K97t2TrtISe/O0rJnZ+
        0A7ZE7M1Ypvrvta9jRPKf+uYTulQS5ptYOPC9URqz6mFJ22nGEb0iZitu/JM9fgyLf0UG4un
        07rOTVvf8vMRu6X3iYUtEw5fm/ikWbJB88iUxAT36R+dnqhre++739ITyz67M3txa97FF1N3
        c9e+2Pxt4bLfojY3/fZ1RC1zrndS3Sy3i1Vs7kKO0Jop1/9Fx+SpHqm4pnl1b6QSX8LPdC/N
        FxtjNqs2zXfLFlv6mUf+WvKTj/3eL/19JWf87f8j9mhupeqtkgU151uZZxzesT/5senb0w+v
        tj8qfm/bVMbJ3q/zdZaoJVtmANvFcycTfJR4rNxqa4X87z+3Tb2poMRSnJFoqMVcVJwIAO52
        zfHTAgAA
X-CMS-MailID: 20220805155300epcas5p1b98722e20990d0095238964e2be9db34
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155300epcas5p1b98722e20990d0095238964e2be9db34
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Series enables async polling on io_uring command, and nvme passthrough
(for io-commands) is wired up to leverage that.

512b randread performance (KIOP) below:

QD_batch    block    passthru    passthru-poll   block-poll
1_1          80        81          158            157
8_2         406       470          680            700
16_4        620       656          931            920
128_32      879       1056        1120            1132

Polling is giving the clear win here.
Upstream fio is used for testing.

passthru command line:
fio -iodepth=64 -rw=randread -ioengine=io_uring_cmd -bs=512 -numjobs=1
-runtime=60 -group_reporting -iodepth_batch_submit=16
-iodepth_batch_complete_min=1 -iodepth_batch_complete_max=16
-cmd_type=nvme -hipri=0 -filename=/dev/ng1n1 -name=io_uring_cmd_64

block command line:
fio -direct=1 -iodepth=64 -rw=randread -ioengine=io_uring -bs=512
-numjobs=1 -runtime=60 -group_reporting -iodepth_batch_submit=16
-iodepth_batch_complete_min=1 -iodepth_batch_complete_max=16
-hipri=0 -filename=/dev/nvme1n1 name=io_uring_64

Bit of code  went into non-passthrough path for io_uring (patch 2) but I
do not see that causing any performance regression.
peak-perf test showed 2.3M IOPS with or without this series for
block-io.

io_uring: Running taskset -c 0,12 t/io_uring -b512 -d128 -c32 -s32 -p1
-F1 -B1 -n2  /dev/nvme0n1
submitter=0, tid=3089, file=/dev/nvme0n1, node=-1
submitter=1, tid=3090, file=/dev/nvme0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=2.31M, BW=1126MiB/s, IOS/call=31/31
IOPS=2.30M, BW=1124MiB/s, IOS/call=32/31
IOPS=2.30M, BW=1123MiB/s, IOS/call=32/32 

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

-- 
2.25.1


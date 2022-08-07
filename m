Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5AE58BC7E
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbiHGSps (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHGSpr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:45:47 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C02BD4
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:45:46 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220807184544epoutp01ea26760955ddcac2e1c56e0004af275d~JJGLP82Ee0485904859epoutp01Q
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 18:45:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220807184544epoutp01ea26760955ddcac2e1c56e0004af275d~JJGLP82Ee0485904859epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659897944;
        bh=dNDGoNtSy82gQ5DZRnxvo9DsOvTaJLP3HC+k2aL1q5E=;
        h=From:To:Cc:Subject:Date:References:From;
        b=KlmnJdW+cqSylKH+eCRluepmJukzJ7pU6vuq/j/Bjf4rWjowtNVkRLeI5Xwx6g0n5
         OyFeBwyQUHidmo2OcidvTmqjX0+KL4bDKkpI6UMjbIsOynAew87xXtb+aygT0gWFwy
         yz2Vl9MPQGxvMuxNfL0DL2xOpwhNE5qeWJ7Oa3As=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220807184544epcas5p186e13e1335048706de0c10b2cc344fd8~JJGK-RbGe0979209792epcas5p17;
        Sun,  7 Aug 2022 18:45:44 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4M17ZF5yRvz4x9Pp; Sun,  7 Aug
        2022 18:45:41 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.4F.09662.55800F26; Mon,  8 Aug 2022 03:45:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220807184540epcas5p41f496a87fe65cff524740ddde071b4bb~JJGH4PONI2500925009epcas5p48;
        Sun,  7 Aug 2022 18:45:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220807184540epsmtrp19136506506469e80ef0c5b56e13c865f~JJGH3g5ux3253032530epsmtrp1K;
        Sun,  7 Aug 2022 18:45:40 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-c9-62f008553017
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.79.08802.45800F26; Mon,  8 Aug 2022 03:45:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220807184539epsmtip293184cfaeb93d5abd27f140208ad23ef~JJGGaXGGM2084620846epsmtip2g;
        Sun,  7 Aug 2022 18:45:39 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v2 0/4] iopoll support for io_uring/nvme
Date:   Mon,  8 Aug 2022 00:06:03 +0530
Message-Id: <20220807183607.352351-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhm4ox4ckg2cbdSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8XeW9oW85c9Zbc4NLmZyYHD4/LZUo/NS+o9dt9sYPN4v+8qm0ff
        llWMHp83yQWwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
        6Lpl5gBdo6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2x
        MjQwMDIFKkzIztjV3cdU0CVWsWPOYpYGxn8CXYycHBICJhLzp11n72Lk4hAS2M0o0XztDytI
        QkjgE6PE+t92EInPjBK3lu1hhel4ve88G0RiF6PEtndb2OCqNr97BlTFwcEmoClxYXIpSIOI
        gLzEl9trWUBqmAXWMkqc3vuFCaRGWMBRYssefRCTRUBVYudFDZByXgFLiZZzD9ghdslLzLz0
        nR0iLihxcuYTFhCbGSjevHU2M8hICYF77BITL01nhmhwkThw7AmULSzx6vgWqEFSEi/726Ds
        ZIlLM88xQdglEo/3HISy7SVaT/Uzg9zDDHT++l36ELv4JHp/PwG7WEKAV6KjTQiiWlHi3qSn
        0CARl3g4YwmU7SFx6vVDdpByIYFYiZ4bKRMY5WYheWAWkgdmIexawMi8ilEytaA4Nz212LTA
        MC+1HB6Ryfm5mxjBiVDLcwfj3Qcf9A4xMnEwHmKU4GBWEuE9svZ9khBvSmJlVWpRfnxRaU5q
        8SFGU2CgTmSWEk3OB6bivJJ4QxNLAxMzMzMTS2MzQyVxXq+rm5KEBNITS1KzU1MLUotg+pg4
        OKUamGZN4BFhW9vz2f5XaDp/VTGn3FLPSVeb/wn4nLt14dvrfzx617aZcIX+9XZ6m77DTFlu
        +eXahC2lLydYHPWfrN96TCBPfQsv14O3cQoRZwWCFKdm2c5mtNzyYr3E502WilJqWRcjei6V
        Tn0kP9PyhIx7S5Zh4KL4HTKTH+uc6/7BlzvLbIJBh4fd4ucnBJabvi28tmfHk1qH7x1SO8rn
        pZsvLzTYaNyx6VyufnaiZXFr6qd5FidUHyb/iEuM+dN9udVjx2VzpRczX/dc8T0iKe2e6Gy2
        NHCjvMjtpjvscl9urDkrLp5zztSBJ8zA1CPs9rPLT47ZTymMOuFwxTb/qMsCDmbLqENfdvcr
        rTe8osRSnJFoqMVcVJwIAO7fZXcNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvG4Ix4ckg65JWhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLvLW2L+cueslscmtzM5MDhcflsqcfmJfUeu282sHm833eVzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgydnX3MRV0iVXsmLOYpYHxn0AXIyeHhICJxOt959m6
        GLk4hAR2MEpcntvPDJEQl2i+9oMdwhaWWPnvOTtE0UdGiV99DaxdjBwcbAKaEhcml4LUiAgo
        Smz82MQIUsMssJlR4tPpY8wgNcICjhJb9uiDmCwCqhI7L2qAlPMKWEq0nHsANV5eYual7+wQ
        cUGJkzOfsIDYzEDx5q2zmScw8s1CkpqFJLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpe
        cn7uJkZwwGpp7WDcs+qD3iFGJg7GQ4wSHMxKIrxH1r5PEuJNSaysSi3Kjy8qzUktPsQozcGi
        JM57oetkvJBAemJJanZqakFqEUyWiYNTqoFpXefu9VNC46LYFV/enPTsxJFjmQtcc3N83mfF
        NM3bV57MtPLxPfWN5wr0m3VkDTi4tx14yv5UKq6th7X0r8LbiMJLvTaTmiovrwg75bbHO/nw
        g9s+DKw6d3aJa3H4fppf8lbDaffu43sbT+2/+v00+5p/Jl+Ef50+MfWE0jXV2oOb08RiLS5V
        zCyeq3p53b2uvWdn/r70LflrEb9ZvUzm2k8ZjP68S/Pe3wxuP8Bn6dWj/1nlP9es9yIbdy7f
        Udyn03j425ZrZ102tL7qPqu1+PTyF/XTnlTsm9GxYeU/b6PKaYHTXyz8pssdvslC6Cl3lpTN
        eo5XntffTFg49e2HFtGLGffOzU2c/O+tkkVk53QlluKMREMt5qLiRABtKK7PxwIAAA==
X-CMS-MailID: 20220807184540epcas5p41f496a87fe65cff524740ddde071b4bb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220807184540epcas5p41f496a87fe65cff524740ddde071b4bb
References: <CGME20220807184540epcas5p41f496a87fe65cff524740ddde071b4bb@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Series enables async polling on io_uring command, and nvme passthrough
(for io-commands) is wired up to leverage that.

Changes since v1:
- corrected variable name (Jens)
- fix for a warning (test-robot)

Performance impact:
Pre TLDR: polling gives clear win.

512b randread performance (KIOPS):

QD_batch    block    passthru    passthru-poll   block-poll
1_1          80        81          158            157
8_2         406       470          680            700
16_4        620       656          931            920
128_32      879       1056        1120            1132

Upstream fio is used for testing. Polled queues set to 1 in nvme.

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


base-commit: ece775e9aa8232963cc1bddf5cc91285db6233af
-- 
2.25.1


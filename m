Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1FC6F23E9
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjD2Jmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjD2Jmi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:38 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CEAE44
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:35 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230429094231epoutp029a24e7be624f37817b76b3e598f78a5b~aXoiUVxVF2139121391epoutp02b
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230429094231epoutp029a24e7be624f37817b76b3e598f78a5b~aXoiUVxVF2139121391epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761351;
        bh=YxwACbZc3acoW93iarLp/yCHgcxhbnSfSzPoEiENwcI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Jif3jk76NeUlpI7u2/UQAr/eSA4rDOVra064q4/oKVgNVc/qmEGfdQD33TBc+8frV
         NJNLICp1SfCCefBwYuWWgdcelsUdxe/UkBud6e9LCm7I9AYad/Pl3LjbffYra4kct4
         iMxG7qLqqjoD3I4yKRr7RzrRdqh1NpWNh94soLlQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230429094230epcas5p4b1f5220d008f548770f5612347e9d124~aXohNmJIq1668816688epcas5p4f;
        Sat, 29 Apr 2023 09:42:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q7kz91FV7z4x9Pt; Sat, 29 Apr
        2023 09:42:29 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.6C.54880.586EC446; Sat, 29 Apr 2023 18:42:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b~aXofyqWLe1633616336epcas5p4b;
        Sat, 29 Apr 2023 09:42:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094228epsmtrp2dddd16e16877fdef356b7f69b2138da1~aXofx4ngL0329503295epsmtrp2O;
        Sat, 29 Apr 2023 09:42:28 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-6b-644ce68551fc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.29.28392.486EC446; Sat, 29 Apr 2023 18:42:28 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094226epsmtip2286babfebe2d1f3cae993781eccbbee5~aXoeAerfK0920909209epsmtip2H;
        Sat, 29 Apr 2023 09:42:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 00/12] io_uring attached nvme queue
Date:   Sat, 29 Apr 2023 15:09:13 +0530
Message-Id: <20230429093925.133327-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmlm7rM58Ug4ldbBYfv/5msVh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFutev2ex2PT3JJMDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHjsfWnpsXlLvsftmA5tH35ZVjB6fN8kFcEZl22SkJqakFimk5iXn
        p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaqkUJaYUwoUCkgsLlbSt7Mp
        yi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM64c/Yve8Ehk4oJW48x
        NzB+0Opi5OSQEDCR2N82jRnEFhLYzShxf0lGFyMXkP2JUWL/7I1MEM5nRomnF16zwnS8+9EO
        ldjFKLGn6zs7XNX+pZcYuxg5ONgENCUuTC4FaRARcJFoWjuVDaSGWeAio0TPp0MsIAlhAXOJ
        vu3LmUBsFgFViT+ffoHdwStgKbHw2Bo2iG3yEjMvgSwAiQtKnJz5BKyXGSjevHU2M8hQCYFO
        Dom/V2DOc5G4/2AZVLOwxKvjW9ghbCmJz+/2QsWTJS7NPMcEYZdIPN5zEMq2l2g91c8M8gAz
        0APrd+lD7OKT6P39hAkkLCHAK9HRJgRRrShxb9JTqK3iEg9nLIGyPSTef9jIDgnSWInnT06z
        TGCUm4Xkg1lIPpiFsGwBI/MqRsnUguLc9NRi0wLDvNRyeFwm5+duYgQnUi3PHYx3H3zQO8TI
        xMF4iFGCg1lJhJe30j1FiDclsbIqtSg/vqg0J7X4EKMpMFgnMkuJJucDU3leSbyhiaWBiZmZ
        mYmlsZmhkjivuu3JZCGB9MSS1OzU1ILUIpg+Jg5OqQYmh+Nnfog8l1GdMCl+7s51ZpMf1P/e
        tSTWTovx6Axl403beZetE9vPmPY41KzyzdvZrydk1sycZcljKVhwdFbgxdZJ12xk7VQSRWfJ
        e//57fHnvxZLJK+XgZmvYd+5n9xB89+n3fLZFPK//4/vdNu9ys9XCN3eHbH2SL2a7Ca9ffre
        zAqH31V7GtZf55t+ROKMpa3EjTbWn/dXViwtbGfsjlrTvfDw/wMFT9hZrD68aFK7rJBo72ey
        7PCHSA6jqVsrJC31S9x09jbOaVRqCpoT1NZy5Zc9Y35vHbNTacnShRW7XsZzG65JOKo87eTP
        7D83Ihrby5ZMSgw8Y8VsuMnndG/eu4CKaIb3p0RMDp1QYinOSDTUYi4qTgQAagjqgC0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSvG7LM58Ug21LNCw+fv3NYrH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLda9fs9isenvSSYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPHY+tPTYvKTeY/fNBjaPvi2rGD0+b5IL4IzisklJzcksSy3St0vg
        yrhz9i97wSGTiglbjzE3MH7Q6mLk5JAQMJF496OdqYuRi0NIYAejRO/0PYwQCXGJ5ms/2CFs
        YYmV/56zQxR9ZJRoWbeKpYuRg4NNQFPiwuRSkBoRAS+J9rez2EBqmAVuMkrs270XrFlYwFyi
        b/tyJhCbRUBV4s+nX8wgNq+ApcTCY2vYIBbIS8y89J0dIi4ocXLmExYQmxko3rx1NvMERr5Z
        SFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDnctrR2Me1Z90DvEyMTB
        eIhRgoNZSYSXt9I9RYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZ
        Jg5OqQYm4R1cb3PlJPeuna5zI6W4zCMpRK229tde052WCTH5EqpKK1qV1mSqMlvW/fmrOWeD
        m9SMC4umRHj+rc28oj55ie7ulo4mZRkne3WzKCOL2ojtdd3qlgp3F4vF9pvaOB1avvzqh/jp
        O5XjVsb+t5JsLGc8ej7+35zoSQejSkp0CudmbdTV7g3+0mKf+kFoce3n2XqLD31zv3EsY9Kx
        +16bme4oPJhtlviBb00S47p9x+P9Ge5b6HZflpKf+/C2uOf3ucLTthQf3uty6vR/pRlvtmjw
        PJ6jrTrJoZDVeAL7BktDsSUidrlTVirLPLk2n8dCfqnAOtNle0JUrrz1/8FleajiAas68+SW
        iyGf5biUWIozEg21mIuKEwGwLlC/5gIAAA==
X-CMS-MailID: 20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b
References: <CGME20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series shows one way to do what the title says.
This puts up a more direct/lean path that enables
 - submission from io_uring SQE to NVMe SQE
 - completion from NVMe CQE to io_uring CQE
Essentially cutting the hoops (involving request/bio) for nvme io path.

Also, io_uring ring is not to be shared among application threads.
Application is responsible for building the sharing (if it feels the
need). This means ring-associated exclusive queue can do away with some
synchronization costs that occur for shared queue.

Primary objective is to amp up of efficiency of kernel io path further
(towards PCIe gen N, N+1 hardware).
And we are seeing some asks too [1].

Building-blocks
===============
At high level, series can be divided into following parts -

1. nvme driver starts exposing some queue-pairs (SQ+CQ) that can
be attached to other in-kernel user (not just to block-layer, which is
the case at the moment) on demand.

Example:
insmod nvme.ko poll_queus=1 raw_queues=2

nvme0: 24/0/1/2 default/read/poll queues/raw queues

While driver registers other queues with block-layer, raw-queues are
rather reserved for exclusive attachment with other in-kernel users.
At this point, each raw-queue is interrupt-disabled (similar to
poll_queues). Maybe we need a better name for these (e.g. app/user queues).
[Refer: patch 2]

2. register/unregister queue interface
(a) one for io_uring application to ask for device-queue and register
with the ring. [Refer: patch 4]
(b) another at nvme so that other in-kernel users (io_uring for now) can
ask for a raw-queue. [Refer: patch 3, 5, 6]

The latter returns a qid, that io_uring stores internally (not exposed
to user-space) in the ring ctx. At max one queue per ring is enabled.
Ring has no other special properties except the fact that it stores a
qid that it can use exclusively. So application can very well use the
ring to do other things than nvme io.

3. user-interface to send commands down this way
(a) uring-cmd is extended to support a new flag "IORING_URING_CMD_DIRECT"
that application passes in the SQE. That is all.
(b) the flag goes down to provider of ->uring_cmd which may choose to do
  things differently based on it (or ignore it).
[Refer: patch 7]

4. nvme uring-cmd understands the above flag. It submits the command
into the known pre-registered queue, and completes (polled-completion)
from it. Transformation from "struct io_uring_cmd" to "nvme command" is
done directly without building other intermediate constructs.
[Refer: patch 8, 10, 12]

Testing and Performance
=======================
fio and t/io_uring is modified to exercise this path.
- fio: new "registerqueues" option
- t/io_uring: new "k" option

Good part:
2.96M -> 5.02M

nvme io (without this):
# t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k0 /dev/ng0n1
submitter=0, tid=2922, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=0 QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=2.89M, BW=1412MiB/s, IOS/call=2/1
IOPS=2.92M, BW=1426MiB/s, IOS/call=2/2
IOPS=2.96M, BW=1444MiB/s, IOS/call=2/1
Exiting on timeout
Maximum IOPS=2.96M

nvme io (with this):
# t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
submitter=0, tid=2927, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=4.99M, BW=2.43GiB/s, IOS/call=2/1
IOPS=5.02M, BW=2.45GiB/s, IOS/call=2/1
IOPS=5.02M, BW=2.45GiB/s, IOS/call=2/1
Exiting on timeout
Maximum IOPS=5.02M

Not so good part:
While single IO is fast this way, we do not have batching abilities for
multi-io scenario. Plugging, submission and completion batching are tied to
block-layer constructs. Things should look better if we could do something
about that.
Particularly something is off with the completion-batching.

With -s32 and -c32, the numbers decline:

# t/io_uring -b512 -d64 -c32 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
submitter=0, tid=3674, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=3.70M, BW=1806MiB/s, IOS/call=32/31
IOPS=3.71M, BW=1812MiB/s, IOS/call=32/31
IOPS=3.71M, BW=1812MiB/s, IOS/call=32/32
Exiting on timeout
Maximum IOPS=3.71M

And perf gets restored if we go back to -c2

# t/io_uring -b512 -d64 -c2 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
submitter=0, tid=3677, file=/dev/ng0n1, node=-1
polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=4.99M, BW=2.44GiB/s, IOS/call=5/5
IOPS=5.02M, BW=2.45GiB/s, IOS/call=5/5
IOPS=5.02M, BW=2.45GiB/s, IOS/call=5/5
Exiting on timeout
Maximum IOPS=5.02M

Source
======
Kernel: https://github.com/OpenMPDK/linux/tree/feat/directq-v1
fio: https://github.com/OpenMPDK/fio/commits/feat/rawq-v2

Please take a look.

[1]
https://lore.kernel.org/io-uring/24179a47-ab37-fa32-d177-1086668fbd3d@linux.alibaba.com/

Anuj Gupta (5):
  fs, block: interface to register/unregister the raw-queue
  io_uring, fs: plumb support to register/unregister raw-queue
  nvme: wire-up register/unregister queue f_op callback
  block: add mq_ops to submit and complete commands from raw-queue
  pci: modify nvme_setup_prp_simple parameters

Kanchan Joshi (7):
  nvme: refactor nvme_alloc_io_tag_set
  pci: enable "raw_queues = N" module parameter
  pci: implement register/unregister functionality
  io_uring: support for using registered queue in uring-cmd
  nvme: carve out a helper to prepare nvme_command from ioucmd->cmd
  nvme: submisssion/completion of uring_cmd to/from the registered queue
  pci: implement submission/completion for rawq commands

 drivers/nvme/host/core.c       |  31 ++-
 drivers/nvme/host/fc.c         |   3 +-
 drivers/nvme/host/ioctl.c      | 234 +++++++++++++++----
 drivers/nvme/host/multipath.c  |   2 +
 drivers/nvme/host/nvme.h       |  19 +-
 drivers/nvme/host/pci.c        | 409 +++++++++++++++++++++++++++++++--
 drivers/nvme/host/rdma.c       |   2 +-
 drivers/nvme/host/tcp.c        |   3 +-
 drivers/nvme/target/loop.c     |   3 +-
 fs/file.c                      |  14 ++
 include/linux/blk-mq.h         |   5 +
 include/linux/fs.h             |   4 +
 include/linux/io_uring.h       |   6 +
 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |   6 +
 io_uring/io_uring.c            |  60 +++++
 io_uring/uring_cmd.c           |  14 +-
 17 files changed, 739 insertions(+), 79 deletions(-)

-- 
2.25.1


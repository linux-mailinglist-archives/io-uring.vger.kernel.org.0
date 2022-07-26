Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0D581878
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbiGZRiY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 13:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbiGZRiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 13:38:23 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002B2B279
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:22 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QEw3MB020156
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=TQ4x8cQWq9MYenRRcsAzpxkvl0fQnbZVQyviX3DQONI=;
 b=dEcb/ru4htwPplD7PFRDUk/nfCfhXVED4nYTkHnqJf7jq7KMS1XpQpQclO+vcwqIgC0q
 14IdIMlxNCY8TzTBgV/Pp+KA31Y5YYnbBrY6j5Oy26aAEeolNMeaMFkiPiQIO/fZfpie
 8m/i6UUydVSSL8Yhlo0URLa5doc7lHZNqfI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hgett2574-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:21 -0700
Received: from twshared6324.05.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 10:38:20 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 4492F698E4A6; Tue, 26 Jul 2022 10:38:15 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 0/5] dma mapping optimisations
Date:   Tue, 26 Jul 2022 10:38:09 -0700
Message-ID: <20220726173814.2264573-1-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vCj0nHg52ttI6PiBb_SIkJUyWPtdc2VL
X-Proofpoint-GUID: vCj0nHg52ttI6PiBb_SIkJUyWPtdc2VL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_05,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

The typical journey a user address takes for a read or write to a block
device undergoes various represenations for every IO. Each consumes
memory and CPU cycles. When the backing storage is NVMe, the sequence
looks something like the following:

  __user void *
  struct iov_iter
  struct pages[]
  struct bio_vec[]
  struct scatterlist[]
  __le64[]

Applications will often use the same buffer for many IO, though, so
these per-IO transformations to reach the exact same hardware descriptor
is unnecessary.

The io_uring interface already provides a way for users to register
buffers to get to the 'struct bio_vec[]'. That still leaves the
scatterlist needed for the repeated dma_map_sg(), then transform to
nvme's PRP list format.

This series takes the registered buffers a step further. A block driver
can implement a new .dma_map() callback to complete the to the
hardware's DMA mapped address representation, and return a cookie so a
user can reference it later for any given IO. When used, the block stack
can skip significant amounts of code, improving CPU utilization, and, if
not bandwidth limited, IOPs. The larger the IO, the more signficant the
improvement.

The implementation is currently limited to mapping a registered buffer
to a single block device.

Here's some perf profiling 128k random read tests demonstrating the CPU
savings:

With premapped bvec:

  --46.84%--blk_mq_submit_bio
            |
            |--31.67%--blk_mq_try_issue_directly
                       |
                        --31.57%--__blk_mq_try_issue_directly
                                  |
                                   --31.39%--nvme_queue_rq
                                             |
                                             |--25.35%--nvme_prep_rq.part=
.68

With premapped DMA:

  --25.86%--blk_mq_submit_bio
            |
            |--12.95%--blk_mq_try_issue_directly
                       |
                        --12.84%--__blk_mq_try_issue_directly
                                  |
                                   --12.53%--nvme_queue_rq
                                             |
                                             |--5.01%--nvme_prep_rq.part.=
68

Keith Busch (5):
  blk-mq: add ops to dma map bvec
  iov_iter: introduce type for preregistered dma tags
  block: add dma tag bio type
  io_uring: add support for dma pre-mapping
  nvme-pci: implement dma_map support

 block/bdev.c                  |  20 +++
 block/bio.c                   |  25 ++-
 block/blk-merge.c             |  18 +++
 drivers/nvme/host/pci.c       | 291 +++++++++++++++++++++++++++++++++-
 include/linux/bio.h           |  21 +--
 include/linux/blk-mq.h        |  25 +++
 include/linux/blk_types.h     |   6 +-
 include/linux/blkdev.h        |  16 ++
 include/linux/uio.h           |   9 ++
 include/uapi/linux/io_uring.h |  12 ++
 io_uring/io_uring.c           | 129 +++++++++++++++
 io_uring/net.c                |   2 +-
 io_uring/rsrc.c               |  13 +-
 io_uring/rsrc.h               |  16 +-
 io_uring/rw.c                 |   2 +-
 lib/iov_iter.c                |  25 ++-
 16 files changed, 600 insertions(+), 30 deletions(-)

--=20
2.30.2


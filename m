Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34F25882A4
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 21:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiHBThC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 15:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiHBTgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 15:36:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002C152DDB
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 12:36:50 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272I2R0N021293
        for <io-uring@vger.kernel.org>; Tue, 2 Aug 2022 12:36:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=X5KiHuWoXgBIuVrSx8XOIR6Xe13KImAdENsTHExt4b8=;
 b=dZNeS2rZxfKFzjoiJ5QzQy+5TfRcsljXZxq5nl2LF4Twy+iUSMPEFixcPu4xPPkvctJs
 vbm4QxskFmlHXhaS2LsrW4Nhyn9Shk0Cf91VY+CZds6ti4CMoDYSe4OfC/hbT8LXIO/B
 5DuLW7dvkFQGsWildKLdh6kUaBgyFaGz1jw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hq477k7a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 12:36:50 -0700
Received: from twshared6324.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 12:36:49 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id BF99F6E59EF7; Tue,  2 Aug 2022 12:36:37 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/7] dma mapping optimisations
Date:   Tue, 2 Aug 2022 12:36:26 -0700
Message-ID: <20220802193633.289796-1-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KG76vrztsrB0fPsuDFtEDKQiscj2Pa9I
X-Proofpoint-ORIG-GUID: KG76vrztsrB0fPsuDFtEDKQiscj2Pa9I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Changes since v1:

  Mapping/unmapping goes through file ops instead of block device ops.
  This abstracts io_uring from knowing about specific block devices. For
  this series, the only "file system" implementing the ops is the raw
  block device, but should be easy enough to add more filesystems if
  needed.

  Mapping register requires io_uring fixed files. This ties the
  registered buffer's lifetime to no more than the file it was
  registered with.

Summary:

A typical journey a user address takes for a read or write to a block
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
these potentially costly per-IO transformations to reach the exact same
hardware descriptor can be skipped.

The io_uring interface already provides a way for users to register
buffers to get to the 'struct bio_vec[]'. That still leaves the
scatterlist needed for the repeated dma_map_sg(), then transform to
nvme's PRP list format.

This series takes the registered buffers a step further. A block driver
can implement a new .dma_map() callback to complete the representation
to the hardware's DMA mapped address, and return a cookie so a user can
reference it later for any given IO. When used, the block stack can skip
significant amounts of code, improving CPU utilization, and, if not
bandwidth limited, IOPs.

The implementation is currently limited to mapping a registered buffer
to a single file.

Keith Busch (7):
  blk-mq: add ops to dma map bvec
  file: add ops to dma map bvec
  iov_iter: introduce type for preregistered dma tags
  block: add dma tag bio type
  io_uring: introduce file slot release helper
  io_uring: add support for dma pre-mapping
  nvme-pci: implement dma_map support

 block/bdev.c                   |  20 +++
 block/bio.c                    |  25 ++-
 block/blk-merge.c              |  19 +++
 block/fops.c                   |  20 +++
 drivers/nvme/host/pci.c        | 302 +++++++++++++++++++++++++++++++--
 fs/file.c                      |  15 ++
 include/linux/bio.h            |  21 ++-
 include/linux/blk-mq.h         |  24 +++
 include/linux/blk_types.h      |   6 +-
 include/linux/blkdev.h         |  16 ++
 include/linux/fs.h             |  20 +++
 include/linux/io_uring_types.h |   2 +
 include/linux/uio.h            |   9 +
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/filetable.c           |  34 ++--
 io_uring/filetable.h           |  10 +-
 io_uring/io_uring.c            | 137 +++++++++++++++
 io_uring/net.c                 |   2 +-
 io_uring/rsrc.c                |  26 +--
 io_uring/rsrc.h                |  10 +-
 io_uring/rw.c                  |   2 +-
 lib/iov_iter.c                 |  24 ++-
 22 files changed, 704 insertions(+), 52 deletions(-)

--=20
2.30.2


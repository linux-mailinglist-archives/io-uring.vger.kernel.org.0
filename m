Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF2B6208BA
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKHFFc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiKHFF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:28 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428BCAE44
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:27 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80V0Hb007321
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:26 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqcmqse54-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:26 -0800
Received: from twshared13940.35.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:24 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D469323B26005; Mon,  7 Nov 2022 21:05:21 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 00/15] zero-copy RX for io_uring
Date:   Mon, 7 Nov 2022 21:05:06 -0800
Message-ID: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: j_O56MMS54ha0x2X6PTTb602y_dRFa5-
X-Proofpoint-ORIG-GUID: j_O56MMS54ha0x2X6PTTb602y_dRFa5-
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        SPOOFED_FREEMAIL,SPOOF_GMAIL_MID autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series introduces network RX zerocopy for io_uring.

This is an evolution of the earlier zctap work, re-targeted to use
io_uring as the userspace API.  The code is intends to provide a 
ZC RX path for upper-level networking protocols (aka TCP and UDP),
with a focus on focuses on host-provided memory (not GPU memory).

This patch contains the upper-level core code required for operation,
but does not not contain the network driver side changes required for
true zero-copy operation.  The io_uring RECV_ZC opcode will work 
without hardware support, albeit in copy mode.

The intent is to use a network driver which provides header/data
splitting, so the frame header which is processed by the networking
stack is not placed in user memory.

The code is successfully receiving a zero-copy TCP stream from a
remote sender.

There is a liburing fork providing the needed wrappers:

    https://github.com/jlemon/liburing/tree/zctap

Which contains an examples/io_uring-net test application exercising
these features.  A sample run:

  # ./io_uring-net -i eth1 -q 20 -p 9999 -r 3000
   copy bytes: 1938872
     ZC bytes: 996683008
  Total bytes: 998621880, nsec:1025219375
         Rate: 7.79 Gb/s

If no queue is specified, then non-zc mode is used:

  # ./io_uring-net -p 9999
   copy bytes: 998621880
     ZC bytes: 0
  Total bytes: 998621880, nsec:1051515726
         Rate: 7.60 Gb/s

There is also an iperf3 fork as well:

   https://github.com/jlemon/iperf/tree/io_uring

This allows running single tests with either:
   * select (normal iperf3)
   * io_uring READ
   * io_uring RECV_ZC copy mode
   * io_uring RECV_ZC hardware mode

Current testing shows similar BW between RECV_ZC and READ modes
(running at 22Gbit/sec), but a reduction of ~50% of MemBW.

High level description:

The application allocates a frame backing store, and provides this
to the kernel for use.  An interface queue is requested from the
networking device, and incoming frames are deposited into the provided
memory region.  The NIC should provide a header splitting feature, so
only the frame payload is placed in the user space area.

Responsibility for correctly steering incoming frames to the queue
is outside the scope of this work - it is assumed that the user 
has set steering rules up separately.

Incoming frames are sent up the stack as skb's and eventually
land in the application's socket receive queue.  This differs
from AF_XDP, which receives raw frames directly to userspace,
without protocol processing.

The RECV_ZC opcode then returns an iov[] style vector which points
to the data in userspace memory.  When the application has completed
processing of the data, the buffers are returned back to the kernel
through a fill ring for reuse.

Jonathan Lemon (15):
  io_uring: add zctap ifq definition
  netdevice: add SETUP_ZCTAP to the netdev_bpf structure
  io_uring: add register ifq opcode
  io_uring: create a zctap region for a mapped buffer
  io_uring: mark pages in ifq region with zctap information.
  io_uring: Provide driver API for zctap packet buffers.
  io_uring: Allocate zctap device buffers and dma map them.
  io_uring: Add zctap buffer get/put functions and refcounting.
  skbuff: Introduce SKBFL_FIXED_FRAG and skb_fixed()
  io_uring: Allocate a uarg for use by the ifq RX
  io_uring: Define the zctap iov[] returned to the user.
  io_uring: add OP_RECV_ZC command.
  io_uring: Make remove_ifq_region a delayed work call
  io_uring: Add a buffer caching mechanism for zctap.
  io_uring: Notify the application as the fillq is drained.

 include/linux/io_uring.h       |   47 ++
 include/linux/io_uring_types.h |   12 +
 include/linux/netdevice.h      |    6 +
 include/linux/skbuff.h         |   10 +-
 include/uapi/linux/io_uring.h  |   24 +
 io_uring/Makefile              |    3 +-
 io_uring/io_uring.c            |    8 +
 io_uring/kbuf.c                |   13 +
 io_uring/kbuf.h                |    2 +
 io_uring/net.c                 |  123 ++++
 io_uring/opdef.c               |   15 +
 io_uring/zctap.c               | 1001 ++++++++++++++++++++++++++++++++
 io_uring/zctap.h               |   31 +
 13 files changed, 1293 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

-- 
2.30.2


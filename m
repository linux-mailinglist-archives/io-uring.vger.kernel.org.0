Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91546172D2
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiKBXkL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKBXjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AD8E093
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:32:52 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVrCs026647
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:32:51 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kkshcwd1v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:32:51 -0700
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:32:50 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 675AC235B616C; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 00/15] zero-copy RX for io_uring
Date:   Wed, 2 Nov 2022 16:32:29 -0700
Message-ID: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Hmkg7a2DVzNjVBJlaSTVARaYl_zXL2bI
X-Proofpoint-GUID: Hmkg7a2DVzNjVBJlaSTVARaYl_zXL2bI
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
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

This series is a RFC for io_uring/zctap.  This is an evolution of
the earlier zctap work, re-targeted to use io_uring as the userspace
API.  The current code is intended to provide a zero-copy RX path for
upper-level networking protocols (aka TCP and UDP).  The current draft
focuses on host-provided memory (not GPU memory).

This RFC contains the upper-level core code required for operation,
with the intent of soliciting feedback on the general API.  This does
not contain the network driver side changes required for complete
operation.  Also please note that as an RFC, there are some things
which are incomplete or in need of rework.

The intent is to use a network driver which provides header/data
splitting, so the frame header (which is processed by the networking
stack) does not reside in user memory.

The code is successfully receiving a zero-copy TCP stream from a
remote sender.  An RFC, the intent is to solicit feedback on the
API and overall design.  The current code will also work with
system pages, copying the data out to the application - this is
intended as a fallback/testing path.

There is an liburing fork: https://github.com/jlemon/liburing/tree/zctap

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

High level description:

The application allocates a frame backing store, and provides this
to the kernel for use.  An interface queue is requested from the
networking device, and incoming frames are deposited into the provided
memory region.

Responsibility for correctly steering incoming frames to the queue
is outside the scope of this work - it is assumed that the user 
has set steering rules up separately.

Incoming frames are sent up the stack as skb's and eventually
land in the application's socket receive queue.  This differs
from AF_XDP, which receives raw frames directly to userspace,
without protocol processing.

The RECV_ZC opcode then returns an iov[] style vector which points
to the data in userspace memory.  When the application has completed
processing of the data, the buffer is returned back to the kernel
through a fill ring for reuse.

Changelog:
 v1: initial version
 v2: Remove separate PROVIDE_REGION opcode, fold this functionality
     into REGISTER_IFQ.  Remove page_pool hooks, as it appears the 
     page pool is currently incompatible with user-mapped memory.
     Add io_zctap_buffers and network driver API.
 v3: Change freelist so it holds a zctap buffer index, instead of
     a pointer.  Add caching mechanism for better performance. Add
     notify mechanism which informs the app of fillq buffers removed.
     Clean up some refcount issues.

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

 include/linux/io_uring.h       |  47 ++
 include/linux/io_uring_types.h |  12 +
 include/linux/netdevice.h      |   6 +
 include/linux/skbuff.h         |  10 +-
 include/uapi/linux/io_uring.h  |  24 +
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            |   8 +
 io_uring/kbuf.c                |  13 +
 io_uring/kbuf.h                |   2 +
 io_uring/net.c                 | 121 ++++
 io_uring/opdef.c               |  15 +
 io_uring/zctap.c               | 976 +++++++++++++++++++++++++++++++++
 io_uring/zctap.h               |  31 ++
 13 files changed, 1266 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

-- 
2.30.2


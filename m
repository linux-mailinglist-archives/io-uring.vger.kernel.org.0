Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C09603328
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJRTQM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJRTQL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3569B580B9
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:10 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 29IDgBx3004361
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3k9abe6w65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:09 -0700
Received: from twshared9384.24.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:08 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 44055227F0509; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 00/13] zero-copy RX for io_uring
Date:   Tue, 18 Oct 2022 12:15:49 -0700
Message-ID: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: SWWtPse7TSz1M-rLW8WO7jCWm2PjCGNO
X-Proofpoint-ORIG-GUID: SWWtPse7TSz1M-rLW8WO7jCWm2PjCGNO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
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

Performance numbers are coming soon!

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
.

Jonathan Lemon (13):
  io_uring: add zctap ifq definition
  netdevice: add SETUP_ZCTAP to the netdev_bpf structure
  io_uring: add register ifq opcode
  io_uring: create a zctap region for a mapped buffer
  io_uring: create page freelist for the ifq region
  io_uring: Provide driver API for zctap packet buffers.
  io_uring: Allocate the zctap buffers for the device
  io_uring: Add zctap buffer get/put functions and refcounting.
  skbuff: Introduce SKBFL_FIXED_FRAG and skb_fixed()
  io_uring: Allocate a uarg for use by the ifq RX
  io_uring: Define the zctap iov[] returned to the user.
  io_uring: add OP_RECV_ZC command.
  io_uring: Make remove_ifq_region a delayed work call

 include/linux/io_uring.h       |  35 ++
 include/linux/io_uring_types.h |  11 +
 include/linux/netdevice.h      |   6 +
 include/linux/skbuff.h         |  10 +-
 include/uapi/linux/io_uring.h  |  24 +
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            |   8 +
 io_uring/kbuf.c                |  13 +
 io_uring/kbuf.h                |   2 +
 io_uring/net.c                 | 123 +++++
 io_uring/opdef.c               |  15 +
 io_uring/zctap.c               | 842 +++++++++++++++++++++++++++++++++
 io_uring/zctap.h               |  16 +
 13 files changed, 1106 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

-- 
2.30.2


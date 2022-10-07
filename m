Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6E45F7F9A
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJGVRb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJGVR3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:29 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A41A57570
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:17 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I56ZP032203
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:17 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k1tp75k7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:17 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:15 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 48CA721DAFD96; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 0/9] zero-copy RX for io_uring
Date:   Fri, 7 Oct 2022 14:17:04 -0700
Message-ID: <20221007211713.170714-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: SORUnzw8-myapETdCwGJ7JczWXQbeu1h
X-Proofpoint-ORIG-GUID: SORUnzw8-myapETdCwGJ7JczWXQbeu1h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
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

The code is roughly working (in that it has successfully received
a TCP stream from a remote sender), but as an RFC, the intent is
to solicit feedback on the API and overall design.  The current code
will also work with system pages, copying the data out to the
application - this is intended as a fallback/testing path.

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

Jonathan Lemon (9):
  io_uring: add zctap ifq definition
  netdevice: add SETUP_ZCTAP to the netdev_bpf structure
  io_uring: add register ifq opcode
  io_uring: add provide_ifq_region opcode
  io_uring: Add io_uring zctap iov structure and helpers
  io_uring: introduce reference tracking for user pages.
  page_pool: add page allocation and free hooks.
  io_uring: provide functions for the page_pool.
  io_uring: add OP_RECV_ZC command.

 include/linux/io_uring.h       |  24 ++
 include/linux/io_uring_types.h |  10 +
 include/linux/netdevice.h      |   6 +
 include/net/page_pool.h        |   6 +
 include/uapi/linux/io_uring.h  |  26 ++
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            |  10 +
 io_uring/kbuf.c                |  13 +
 io_uring/kbuf.h                |   2 +
 io_uring/net.c                 | 123 ++++++
 io_uring/opdef.c               |  23 +
 io_uring/zctap.c               | 749 +++++++++++++++++++++++++++++++++
 io_uring/zctap.h               |  20 +
 net/core/page_pool.c           |  41 +-
 14 files changed, 1048 insertions(+), 8 deletions(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

-- 
2.30.2


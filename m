Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6009369828C
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 18:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBORp0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 12:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBORpX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 12:45:23 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A133C2B6
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 09:45:14 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 2253971625AE; Wed, 15 Feb 2023 09:45:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v9 0/5] io_uring: add napi busy polling support 
Date:   Wed, 15 Feb 2023 09:44:47 -0800
Message-Id: <20230215174452.3373598-1-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. This list is
used to determine which napi id's enabled busy polling. For faster
access it also adds a hash table.

When a new napi id is added, the hash table is used to locate if
the napi id has already been added. When processing the busy poll
loop the list is used to process the individual elements.

io-uring allows specifying two parameters:
- busy poll timeout and
- prefer busy poll to call of io_napi_busy_loop()
This sets the above parameters for the ring. The settings are passed
with a new structure io_uring_napi.

There is also a corresponding liburing patch series, which enables this
feature. The name of the series is "liburing: add add api for napi busy
poll timeout". It also contains two programs to test the this.

Testing has shown that the round-trip times are reduced to 38us from
55us by enabling napi busy polling with a busy poll timeout of 100us.
More detailled results are part of the commit message of the first
patch.

Changes:
- V9:
  - refreshed to io-uring/for-6.3
  - folded patch 2 and 3 into patch 4
  - fixed commit description for last 2 patches
  - fixed some whitespace issues
  - removed io_napi_busy_loop_on helper
  - removed io_napi_setup_busy helper
  - renamed io_napi_end_busy_loop to io_napi_busy_loop
  - removed NAPI_LIST_HEAD macro
  - split io_napi_blocking_busy_loop into two functions
  - added io_napi function
  - comment for sqpoll check
- V8:
  - added new file napi.c and add napi functions to this file
  - added NAPI_LIST_HEAD function so no ifdef is necessary
  - added io_napi_init and io_napi_free function
  - added io_napi_setup_busy loop helper function
  - added io_napi_adjust_busy_loop helper function
  - added io_napi_end_busy_loop helper function
  - added io_napi_sqpoll_busy_poll helper function
  - some of the definitions in napi.h are macros to avoid ifdef
    definitions in io_uring.c, poll.c and sqpoll.c
  - changed signature of io_napi_add function
  - changed size of hashtable to 16. The number of entries is limited
    by the number of nic queues.
  - Removed ternary in io_napi_blocking_busy_loop
  - Rewrote io_napi_blocking_busy_loop to make it more readable
  - Split off 3 more patches
- V7:
  - allow unregister with NULL value for arg parameter
  - return -EOPNOTSUPP if CONFIG_NET_RX_BUSY_POLL is not enabled
- V6:
  - Add a hash table on top of the list for faster access during the
    add operation. The linked list and the hash table use the same
    data structure
- V5:
  - Refreshed to 6.1-rc6
  - Use copy_from_user instead of memdup/kfree
  - Removed the moving of napi_busy_poll_to
  - Return -EINVAL if any of the reserved or padded fields are not 0.
- V4:
  - Pass structure for napi config, instead of individual parameters
- V3:
  - Refreshed to 6.1-rc5
  - Added a new io-uring api for the prefer napi busy poll api and wire
    it to io_napi_busy_loop().
  - Removed the unregister (implemented as register)
  - Added more performance results to the first commit message.
- V2:
  - Add missing defines if CONFIG_NET_RX_BUSY_POLL is not defined
  - Changes signature of function io_napi_add_list to static inline
    if CONFIG_NET_RX_BUSY_POLL is not defined
  - define some functions as static



Stefan Roesch (5):
  io-uring: move io_wait_queue definition to header file
  io-uring: add napi busy poll support
  io-uring: add sqpoll support for napi busy poll
  io_uring: add register/unregister napi function
  io_uring: add prefer busy poll to register and unregister napi api

 include/linux/io_uring_types.h |  10 +
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |  60 +++---
 io_uring/io_uring.h            |  26 +++
 io_uring/napi.c                | 322 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  81 +++++++++
 io_uring/poll.c                |   2 +
 io_uring/sqpoll.c              |   4 +
 9 files changed, 492 insertions(+), 26 deletions(-)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h


base-commit: 2f2bb1ffc9983e227424d0787289da5483b0c74f
--=20
2.30.2


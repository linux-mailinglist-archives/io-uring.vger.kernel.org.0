Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E254F68B13F
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 19:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjBESwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Feb 2023 13:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBESwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Feb 2023 13:52:06 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F280F1BAF3
        for <io-uring@vger.kernel.org>; Sun,  5 Feb 2023 10:51:41 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 5375D658CF42; Sun,  5 Feb 2023 10:51:28 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v8 0/4] liburing: add api for napi busy poll
Date:   Sun,  5 Feb 2023 10:51:18 -0800
Message-Id: <20230205185122.2096480-1-shr@devkernel.io>
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

This adds two new api's to set/clear the napi busy poll settings. The two
new functions are called:
- io_uring_register_napi
- io_uring_unregister_napi

The patch series also contains the documentation for the two new function=
s
and two example programs. The client program is called napi-busy-poll-cli=
ent
and the server program napi-busy-poll-server. The client measures the
roundtrip times of requests.

There is also a kernel patch "io-uring: support napi busy poll" to enable
this feature on the kernel side.

Changes:
- V8:
  - Use tab in liburing-ffi.map file
  - Small fix to io_uring_register_napi man page
- V7:
  - Add new functions to liburing-ffi.map file.
  - Fix some whitespace issues.
  - Address the compile errors from CI in the two files
    napi-busy-poll-client.c and napi-busy-poll-server.c
- V6:
  - Check return value of unregister napi call and verify that busy poll
    timeout and prefer busy poll return the expected values.
- V5:
  - Fixes to documentation.
  - Correct opcode for unregister call
  - Initialize napi structure in example programs
  - Address tab issues in recordRTT()
- V4:
  - Modify functions to use a structure to pass the napi busy poll settin=
gs
    to the kernel.
  - Return previous values when returning from the above functions.
  - Rename the functions and remove one function (no longer needed as the
    data is passed as a structure)
- V3:
  - Updated liburing.map file
  - Moved example programs from the test directory to the example directo=
ry.
    The two example programs don't fit well in the test category and need=
 to
    be run from separate hosts.
  - Added the io_uring_register_napi_prefer_busy_poll API.
  - Added the call to io_uring_register_napi_prefer_busy_poll to the exam=
ple
    programs
  - Updated the documentation
- V2:
  - Updated the liburing.map file for the two new functions.
    (added a 2.4 section)
  - Added a description of the new feature to the changelog file
  - Fixed the indentation of the longopts structure
  - Used defined exit constants
  - Fixed encodeUserData to support 32 bit builds


Stefan Roesch (4):
  liburing: add api to set napi busy poll settings
  liburing: add documentation for new napi busy polling
  liburing: add example programs for napi busy poll
  liburing: update changelog with new feature

 .gitignore                       |   2 +
 CHANGELOG                        |   1 +
 examples/Makefile                |   2 +
 examples/napi-busy-poll-client.c | 451 +++++++++++++++++++++++++++++++
 examples/napi-busy-poll-server.c | 386 ++++++++++++++++++++++++++
 man/io_uring_register_napi.3     |  40 +++
 man/io_uring_unregister_napi.3   |  27 ++
 src/include/liburing.h           |   3 +
 src/include/liburing/io_uring.h  |  12 +
 src/liburing-ffi.map             |   2 +
 src/liburing.map                 |   3 +
 src/register.c                   |  12 +
 12 files changed, 941 insertions(+)
 create mode 100644 examples/napi-busy-poll-client.c
 create mode 100644 examples/napi-busy-poll-server.c
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3


base-commit: d32d53b65377d846635387ce6c1cd2ed0d700f92
--=20
2.30.2


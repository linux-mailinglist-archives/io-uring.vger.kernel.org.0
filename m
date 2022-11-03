Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73E6189B3
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 21:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiKCUkb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 16:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiKCUka (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 16:40:30 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DB9E09F
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 13:40:29 -0700 (PDT)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 4D78EC4F6B3; Thu,  3 Nov 2022 13:40:23 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v1 0/3] liburing: add api for napi busy poll timeout 
Date:   Thu,  3 Nov 2022 13:40:14 -0700
Message-Id: <20221103204017.670757-1-shr@devkernel.io>
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

This adds two new api's to set and clear the napi busy poll timeout. The
two new functions are called:
- io_uring_register_busy_poll_timeout and
- io_uring_unregister_busy_poll_timeout.

The patch series also contains the documentation for the two new function=
s
and two test programs. The client program is called napi-busy-poll-client
and the server program napi-busy-poll-server. The client measures the
roundtrip times of requests.

There is also a kernel patch "io-uring: support napi busy poll" to enable
this feature on the kernel side.

Signed-off-by: Stefan Roesch <shr@devkernel.io>

Stefan Roesch (3):
  liburing: add api to set napi busy poll timeout
  liburing: add documentation for new napi busy polling
  liburing: add test programs for napi busy poll

 man/io_uring_register_napi.3    |  35 +++
 man/io_uring_unregister_napi.3  |  26 ++
 src/include/liburing.h          |   3 +
 src/include/liburing/io_uring.h |   4 +
 src/register.c                  |  12 +
 test/Makefile                   |   2 +
 test/napi-busy-poll-client.c    | 419 ++++++++++++++++++++++++++++++++
 test/napi-busy-poll-server.c    | 371 ++++++++++++++++++++++++++++
 8 files changed, 872 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3
 create mode 100644 test/napi-busy-poll-client.c
 create mode 100644 test/napi-busy-poll-server.c


base-commit: 4915f2af869876d892a1f591ee2c21be21c6fc5c
--=20
2.30.2


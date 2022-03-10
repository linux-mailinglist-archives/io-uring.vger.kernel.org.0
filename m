Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2544D4567
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbiCJLOK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241147AbiCJLOJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:14:09 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E013B03C
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:13:08 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 07DC77E2A8;
        Thu, 10 Mar 2022 11:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646910787;
        bh=MNR2F2zlEivi6RJ7zj6e4CkA+duyleSsE+T2l50dW5U=;
        h=From:To:Cc:Subject:Date:From;
        b=LVo02g/355/B08hHglrJsaqlADPOorz71oP3QfQCvtZlVYQHiMk3NrhvOxtqsIk3l
         sywA2D0FCERSAX8d47I/bWLQ9GQdXcuDHdTWFUuCJVXZBoxzPS6up2Dq4uc8XrmTvr
         E4FufrRmgrhTJg9V/fVRKqvnqbMGjiuUFkb6pzbUWOSWThD5XLZKm6pXpbtmQnO7Ps
         kS2P05DTmuDQjwKSupuijZTarFFjXiUGgUW2A+Yjk3PaLaUQ32FfXNHiaWl+72RHxK
         9d4f3N5QamuosKD2609q0igLnV+XTiK/HywikIpbuAOiyR6g2pHdeFofaBME+wTnA9
         jx5wgoExqckyg==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 0/4] Changes for Makefile
Date:   Thu, 10 Mar 2022 11:12:27 +0000
Message-Id: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello sir,

This patchset (v3) changes Makefile. 4 patches here:

1. Remove -fomit-frame-pointer flag, because it's already covered
   by the -O2 optimization flag.

2. When the header files are modified, the compiled objects are
   not going to be recompiled because the header files are not
   marked as a dependency for the objects.

  - Instruct the compiler to generate dependency files.

  - Include those files from src/Makefile. Ensure if any changes are
    made, files that depend on the changes are recompiled.

3. The test binaries statically link liburing using liburing.a file.
   When liburing.a is recompiled, make sure the tests are also
   recompiled to ensure changes are applied to the test binary. It
   makes "make clean" command optional when making changes.

4. Same as no. 3, but for examples.

please review,
thx

link v2: https://lore.kernel.org/io-uring/20220310103224.1675123-1-alviro.iskandar@gnuweeb.org/
v2 -> v3: 
  - Add dependency files to .gitignore.
  - Remove dependency files when running "make clean".

link v1: https://lore.kernel.org/io-uring/20220308224002.3814225-1-alviro.iskandar@gnuweeb.org/
v1 -> v2:
  - Instruct the compiler to generate dependency files instead
    of hard code it in the Makefile.
  - Add liburing.a to dependency for test (patch 3).
  - Add liburing.a to dependency for examples (patch 4).

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---

Alviro Iskandar Setiawan (4):
  src/Makefile: Remove `-fomit-frame-pointer` from default build
  src/Makefile: Add header files as dependency
  test/Makefile: Add liburing.a as a dependency
  examples/Makefile: Add liburing.a as a dependency

 .gitignore        |  1 +
 examples/Makefile |  2 +-
 src/Makefile      | 15 +++++++--------
 test/Makefile     |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)


base-commit: 6231f56da7881bde6fb011e1b54d672f8fe5a224
-- 
2.25.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FFB606152
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 15:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiJTNRK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 09:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiJTNRJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 09:17:09 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0501AFAB3
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 06:16:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id 26A9B804D1;
        Thu, 20 Oct 2022 13:15:08 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666271711;
        bh=MK6vAehZf3C8CESqzSLeGTXoZmmM9yA21ScJRSbm75Q=;
        h=From:To:Cc:Subject:Date:From;
        b=lVzAN0MAIPBlm02EmXl1uw9slLXPgmYUNzum3vfKDWyfqs3/3JUr68NTWpoomHKBq
         vSmjx+ffAvDT2f6+HRAw+KjGjnfuvaUzhGKwlmA2FFHJODtjS+fvAFwiRas4FZTDZH
         Qs3M8ssJAvioDe27VtKUA4RYoriLeWoQ/34ykEt2hU58sYEeiC4BbUs9YlIaJfkxYk
         2YNorrQ78Gi2j3LmnfbNqS62Xs3rCCICc2RTRPmythArcUWJA0O0DBkEI8hpHTwxzp
         RKKrLHiMJGglbwfcC+LuhRuSo4Tfgp5jwsxnUOshhHIMUfJfU7LGKvBUSV4JPhE68l
         oUnybxRfE1QXg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
Subject: [PATCH liburing v2 0/3] Clean up clang `-Wshorten-64-to-32` warnings
Date:   Thu, 20 Oct 2022 20:14:52 +0700
Message-Id: <20221020131118.13828-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This is a v2.

v2:
  - Fix Signed-off-by tag.
  - Make the cast in patch #1 consistent.

Please consider this small cleanup series before the release.

This series is a follow up of the clean up `-Wshorten-64-to-32`
warnings that I discussed with Dylan previously. It only addresses
the warnings in the src/ dir (main library). We ignore the tests
for now.

`-Wshorten-64-to-32` is a clang-specific flag, it currently doesn't
exist in GCC.

There are 3 patches in this series:

- Patch 1 is to clean up the warnings in the main library
  (this is based on a patch from Dylan).

  Taken from: https://github.com/DylanZA/liburing/commit/cdd6dfbb9019.patch

- Patch 2 is to introduce LIBURING_CFLAGS variable in the Makefile. We
  need this varaible to apply specific compiler flags to the main
  library only. Currently, this flag is only used by the GitHub bot.

- Patch 3 is to integrate `-Wshorten-64-to-32` flag to the GitHub bot.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  Makefile: Introduce `LIBURING_CFLAGS` variable
  github: Append `-Wshorten-64-to-32` flag for clang build

Dylan Yudaken (1):
  liburing: Clean up `-Wshorten-64-to-32` warnings from clang

 .github/workflows/build.yml |  4 ++++
 src/Makefile                |  5 ++++-
 src/arch/syscall-defs.h     |  4 ++--
 src/register.c              |  5 ++++-
 src/setup.c                 | 12 ++++++------
 src/syscall.h               |  4 ++--
 6 files changed, 22 insertions(+), 12 deletions(-)


base-commit: 3049530665ba6464f3c5f6f80b28e965719ca602
-- 
Ammar Faizi


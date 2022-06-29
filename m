Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1584155F25D
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiF2A2P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF2A2O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF421272
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:12 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 6B6557F9DB;
        Wed, 29 Jun 2022 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462492;
        bh=kiw2EKLazaesecgUZc+A3um9rmZMTvE7pJpmr8/yeEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oaAc4KIs7Pec6DHcTbV9zXrWAntTytoMjXZ8lfjPc/Cic9xThCjM3wHExhAWRjahZ
         om1bHgoAu1Era1ltV1wkD6G9AG2UeCvRbRegbYyf0uPXiTQtOo9zN3/cxtYbMEmKKX
         8LKH3YjOLmUzUeVyw5w/Z95Cu0viDcp80Lkz/HXj1eN1shgUXGtW+UpujZV1C9is+s
         cH5K6W/3bCViszMPuGjFrqXt3Ch4b5E5yGVupwqpZmSURvtxH9nXjvICxWlSPmPIEg
         piptLsa2/kCfTiBTMa8qOVdr26DAOIWumrg3iwgyzVA7qCkm4d6GwZZFNWIxU8O4MW
         iVKDzugjED3rA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 0/9] aarch64 nolibc support
Date:   Wed, 29 Jun 2022 07:27:44 +0700
Message-Id: <20220629002028.1232579-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This series contains nolibc support for aarch64 and one extra irrelevant
cleanup (patch #1). The missing bit from aarch64 is get_page_size()
which is a bit complicated to implement without libc.

aarch64 supports three values of page size: 4K, 16K, and 64K which are
selected at kernel compilation time. Therefore, we can't hard code the
page size for this arch. In this series we utilize open(), read() and
close() syscall to find the page size from /proc/self/auxv.

The auxiliary vector contains information about the page size, it is
located at `AT_PAGESZ` keyval pair.

For more details about the auxv data structure, check the link below.

Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260
Link: https://lwn.net/Articles/631631/

There are 9 patches in this series.

- Patch 1 is just a trivial changelog fix.
- Patch 2 is to handle get_page_size() error that may happen in the
  later patches.
- Patch 3 and 4 are to add open() and read() syscall. We will need them
  to get the page size on aarch64.
- Patch 5 is to rename aarch64 directory to arm64.
- Patch 6 is to remove __INTERNAL__LIBURING_SYSCALL_H checks.
- Patch 7 is to add get_page_size() function.
- Patch 8 is to enable the nolibc support for aarch64.
- Patch 9 is for GitHub bot build.

I have built it with GitHub bot and it compiles just fine. But I don't
have an aarch64 machine to run the tests. Since you are using aarch64,
I can rely on you to test it.

How to test this?

  make clean;
  ./configure --nolibc;
  make -j8;
  make runtests;

Please give it a test...

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (9):
  CHANGELOG: Fixup missing space
  setup: Handle `get_page_size()` failure (for aarch64 nolibc support)
  arch: syscall: Add `__sys_open()` syscall
  arch: syscall: Add `__sys_read()` syscall
  arch/arm64: Rename aarch64 directory to arm64
  arch: syscall: Remove `__INTERNAL__LIBURING_SYSCALL_H` checks
  arch/arm64: Add `get_page_size()` function
  arch: Enable nolibc support for arm64
  .github: Enable aarch64 nolibc build for GitHub bot

 .github/workflows/build.yml           |  2 +-
 CHANGELOG                             |  2 +-
 src/arch/arm64/lib.h                  | 44 +++++++++++++++++++++++++++
 src/arch/{aarch64 => arm64}/syscall.h | 14 ++++-----
 src/arch/generic/lib.h                |  4 ---
 src/arch/generic/syscall.h            | 20 +++++++++---
 src/arch/syscall-defs.h               | 12 ++++++++
 src/arch/x86/lib.h                    |  4 ---
 src/arch/x86/syscall.h                |  4 ---
 src/lib.h                             | 21 +++++++------
 src/setup.c                           |  3 ++
 src/syscall.h                         |  4 +--
 12 files changed, 97 insertions(+), 37 deletions(-)
 create mode 100644 src/arch/arm64/lib.h
 rename src/arch/{aarch64 => arm64}/syscall.h (91%)


base-commit: 68103b731c34a9f83c181cb33eb424f46f3dcb94
-- 
Ammar Faizi


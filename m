Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7785E501E83
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 00:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347113AbiDNWoc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 18:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbiDNWob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 18:44:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817B52A8
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 15:42:05 -0700 (PDT)
Received: from integral2.. (unknown [36.80.217.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 48C257E3A0;
        Thu, 14 Apr 2022 22:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649976124;
        bh=dCOaCVvWEjQlJXPCoU3zNs2nKLPZ+MZ2Wm0yhWkWIus=;
        h=From:To:Cc:Subject:Date:From;
        b=b0kWsYk+KP/yjVk7rc6ks/TkiFqO1hXJaT0N8fQP+loapv0xQupuHTNk7nkQo77AR
         qq3jyYrInY3+8ImaLcb86HYZTIJbrk5JbejG8aYjKsiLtLV4JcWNvfEX6iBJKD+dOu
         kzuy4pBr1or7t4AnszsVv8JC31azyVTbSMdyTxJ4iHOkI4l08+E6U+Ks2ddZuB8jo1
         sN3vdavdbLIJa2zqtI46ausC3XlABvnY1a2nCxkHhoKe0BTWRFK/tSDkoIFYASF+HO
         2tmqcFF0AvdCJxyOzDMFhKdDovK/6G1YeIfAVftr7HYc+zCTVHw3C9EvVT6ZRcM67n
         X3u9K5O1hAhFg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing 0/3] Add x86 32-bit support for the nolibc build
Date:   Fri, 15 Apr 2022 05:41:37 +0700
Message-Id: <20220414224001.187778-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
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

Hi,

This series adds nolibc support for x86 32-bit. There are 3 patches in
this series:

1) Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit.
2) Provide `get_page_size()` function for x86 32-bit.
3) Add x86 32-bit native syscall support.

The most noticeable changes is the patch 3. Unlike x86-64, only
use native syscall from the __do_syscall macros when CONFIG_NOLIBC is
enabled for 32-bit build. The reason is because the libc syscall
wrapper can do better in 32-bit. The libc syscall wrapper can dispatch
the best syscall instruction that the environment is supported, there
are at least two variants syscall instruction for x86 32-bit, they are:
`int $0x80` and `sysenter`. The `int $0x80` instruction is always
available, but `sysenter` is not, it relies on VDSO. liburing always
uses `int $0x80` for syscall if it's compiled with CONFIG_NOLIBC,
otherwise it uses whatever the libc provides.

Extra notes for __do_syscall6() macro:
On i386, the 6th argument of syscall goes in %ebp. However, both Clang
and GCC cannot use %ebp in the clobber list and in the "r" constraint
without using -fomit-frame-pointer. To make it always available for
any kind of compilation, the below workaround is implemented:

  1) Push the 6-th argument.
  2) Push %ebp.
  3) Load the 6-th argument from 4(%esp) to %ebp.
  4) Do the syscall (int $0x80).
  5) Pop %ebp (restore the old value of %ebp).
  6) Add %esp by 4 (undo the stack pointer).

WARNING:
  Don't use register variables for __do_syscall6(), there is a known
  GCC bug that results in an endless loop.

BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032


===== How is this tested? =====

This has been tested on x86-64 Linux (compiled with 32-bit bin support)
with the following commands:

  sudo apt-get install gcc-i686-linux-gnu g++-i686-linux-gnu -y;
  ./configure --cc=i686-linux-gnu-gcc --cxx=i686-linux-gnu-g++ --nolibc;
  sudo make -j8 runtests;


Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  arch/syscall-defs: Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit
  arch/x86/lib: Provide `get_page_size()` function for x86 32-bit
  arch/x86/syscall: Add x86 32-bit native syscall support

 src/arch/syscall-defs.h |  11 ++-
 src/arch/x86/lib.h      |  17 -----
 src/arch/x86/syscall.h  | 150 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 157 insertions(+), 21 deletions(-)


base-commit: c47b44afb686d794f8ed62feb77e9c42431c8444
-- 
Ammar Faizi


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE264B297F
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 16:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349635AbiBKP63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 10:58:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349624AbiBKP63 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 10:58:29 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A5A1A8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 07:58:27 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 09D197E25B;
        Fri, 11 Feb 2022 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644595107;
        bh=4Xya1vrnRhw0C+sHWxkukBSXwDSk33+U4715kgS62Oc=;
        h=From:To:Cc:Subject:Date:From;
        b=KtmUEhpCTRaBLaxXuGzWMRQIkvWfQMZUrWn/bEliiQLe0/J3VMHFHhtUB9DO1NF5s
         KEp7Y23pluzeT3XmUeKhAPOs0kQI9gxfEPNyh24+UJhiVbeBgTejXkfvOlZYknjy7A
         tEDjx1GY9Kq4DtAx/dKnPkc+YJvMxGG6eIKkpy4qaGIPwtYcnveDlm8uXCSOAJw7zS
         Wro3r8FzWG98BoQffIqk7jPO9U7wloZyhbi1pdxX91xMhp1EK1FlNrgadB/vDteYEh
         siQHhRk9u31aiv0QxPOFwXUtT6K6CHalEJIOuMTKBC6tY2GYZC+ShKavUDZ/LG+5dv
         9lkeOzfmbcGWg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nugra <richiisei@gmail.com>
Subject: [PATCH liburing v1 0/4] Refactor arch dependent code and x86-64 improvement
Date:   Fri, 11 Feb 2022 22:57:49 +0700
Message-Id: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We have many #ifdef/#endif in syscall.h since nolibc support is added.
This series tries to clean them up, separate the definitions into
smaller more manageable pieces.

Also, optimize function call for x86-64. Avoid libc function call for
syscall even if CONFIG_NOLIBC is disabled. If this patchset is applied,
CONFIG_NOLIBC is still meaningful, we may still use libc for malloc(),
free() and memset().


New directory structure for arch 
==================================

1) src/arch/generic
   This contains wrappers based on libc that can be used for all archs.

2) src/arch/x86
   This contains x86 specific code.

In the future, more architecture specific code can be added. Currently,
architectures other than x86-64 will use code from src/arch/generic.


Technical Explanation
======================

There are 4 patches in this series.

Patch 1
#########
This is a preparation for refactoring the syscall wrappers.

This creates a new file src/arch/generic/syscall.h. This file contains
libc syscall wrappers for architectures that don't have arch specific
code. In the next patches, we will include this file from src/syscall.h.

It aims to reduce the usage of #ifdef/#endif that occurs in every
function in src/syscall.h file. Also, it will make the arch specific
code structure cleaner and easier to manage.

Patch 2
#########

There are 3 things in this patch (a, b, c):

a) Remove all ____sys* and uring_* functions from src/syscall.h. We
   will define them in the src/arch/* files, so we can avoid many
   #ifdef/#endif.

b) Rename all __arch_impl_* functions in src/arch/x86/syscall.h with
   ____sys* and uring_* to support point (1).

c) Always use arch specific code for x86-64 syscalls, even with
   CONFIG_NOLIBC disabled. For other archs, currently, will still
   use the libc wrappers (we provided it in src/arch/generic*).

Major changes happen in point (c). We will always use inline assembly
for invoking syscall for x86-64. Reasoning:

1. It reduces function calls.
------------------------------
If we use libc, we need to call syscall(2) function and deal with a
global state via errno macro (errno macro will expand to a
function call too).

If we use inline Assembly, we eliminate many functions calls, we
don't need to use errno or any global state anymore as it will
just directly return error code that we can check with a simple
comparison.

2. Allow the compiler to reuse caller clobbered registers.
-----------------------------------------------------------
By the rule of System V ABI x86-64, a function call clobbers %rax,
%rdi, %rsi, %rdx, %rcx, %r8, %r9, %r10 and %r11. On Linux, syscall
only clobbers %rax, %rcx and %r11. But since libc syscall(2) wrapper
is a function call, the compiler will always miss the opportunity
to reuse those clobbered registers. That means it has to preserve
the life values on the stack if they happen to be in the clobbered
registers (that's also extra memory access).

By inlining the syscall instruction, the compiler has an opportunity
to reuse all registers after invoking syscall, except %rax, %rcx and
%r11.

3. Smaller binary size.
------------------------
Point (1) and (2) will also reduce the data movement, hence smaller
Assembly code, smaller binary size.

4. Reduce %rip round trip to libc.so.
--------------------------------------
Call to a libc function will make the %rip jump to libc.so memory
area. This can have extra overhead and extra icache misses in some
scenario. If we inline the syscall instruction, this overhead can
be removed.

Patch 3
#########
This takes care of lib.h header file, split it into generic and arch
specific.

Patch 4
#########
Change all syscall function name prefix to __sys.

Instead of using uring_mmap, uring_close, uring_madvise, etc. Let's
use __sys_mmap, __sys_close, __sys_madvise, etc. That looks better
convention for syscall function name like what we do with
__sys_io_uring* functions.


Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Alviro Iskandar Setiawan (2):
  arch/generic: Create arch generic syscall wrappers
  arch/x86, syscall: Refactor arch specific and generic syscall wrappers

Ammar Faizi (2):
  lib.h: Split off lib header for arch specific and generic
  Change all syscall function name prefix to __sys

 src/arch/generic/lib.h     |  21 +++++
 src/arch/generic/syscall.h |  87 +++++++++++++++++++++
 src/arch/x86/lib.h         |  20 +++--
 src/arch/x86/syscall.h     |  57 ++++++++------
 src/lib.h                  |  45 +++++------
 src/nolibc.c               |   4 +-
 src/register.c             |   4 +-
 src/setup.c                |  22 +++---
 src/syscall.h              | 155 ++++++-------------------------------
 9 files changed, 214 insertions(+), 201 deletions(-)
 create mode 100644 src/arch/generic/lib.h
 create mode 100644 src/arch/generic/syscall.h


base-commit: 90a4da4d51f137229a2ef39b25880d81adfcb487
-- 
2.32.0


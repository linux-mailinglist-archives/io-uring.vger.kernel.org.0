Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166D2424D4E
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 08:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhJGGeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 02:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhJGGeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 02:34:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B04C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 23:32:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s16so4522289pfk.0
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 23:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FqLmD7djBICYGqV3n/jpU004G7AYp5j8j1FmghOQO+Y=;
        b=Dl4hgpnsM7Lmj5YOWjnp0graItU3jiaK1Glj77S95vAeW8wKn2/ProUDtelM+yWJo2
         tuCQPaHEpmKzNsQjBBcGi80Klzl1MzPXRiIovHt+OP6Unh4hKAzbhlfT/tdlBPjQyfY5
         i/EGpeABia+VqnZT7vgYmIZu8Et48bG9G6sVVJ/lEcxBtpDvFFqrsYz9UAmwv3abwEGu
         X0eLfSRGhk03xSkaoCWjdhyIqqyr3pVc+57hIBZvUO4MshIQktbRPpG6GAlbfGFSwatt
         2EF0kVipVgqLuX7kMrwtzYTPPdYJzUAffcYsvGI9IcrCoEyrIIN+9Sysf5DHtq09lkLu
         3HXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FqLmD7djBICYGqV3n/jpU004G7AYp5j8j1FmghOQO+Y=;
        b=A89jVADpKy2O5gDwgcDoZ5sqNHYx6A4pNY8MN8VElmLJaPMgnZ7zqM57q5oCr6DtsQ
         CKKV+y4Dq95siiXGw5poglfo4lREKu/K/c8n0HD6sLitC0IMPRV16FEEhy23v8tAqKUq
         VIaQ6II++a+kcOGg3aeh29O8ppZ155qQ5jkgQFAAoN03ROhFnpcVqjZig0NMFvoxGK5h
         sTOVTMNDgTdcXF+awna27Gi0qFlpJ7NbZ52qb9q2OFwJtOYgaBIJon5gAkNwQSvmnqao
         g1QjFkZyFH/fn1eMbmT+5llzccKITiDXWyVp9AZmDvfs1fB77Q1y+9L3fOAsBhqKnVr+
         QugQ==
X-Gm-Message-State: AOAM533A5Zz96F3KFpO+KGWjVkIAUlymOsnbjjQTS4iLcavbiM5BEJN2
        jBYW21pZWj2Axhz5u5OUBvhRWA==
X-Google-Smtp-Source: ABdhPJxbcedmdwxYbzcTacd4F7k+TsxgeZt4ncOkL/WLLVS9oNf+ypjiSH0fZ1xVNY0bxlFFUlUuSw==
X-Received: by 2002:a63:e24b:: with SMTP id y11mr2003566pgj.452.1633588337025;
        Wed, 06 Oct 2021 23:32:17 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id k35sm7103919pjc.53.2021.10.06.23.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:32:16 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v2 RFC liburing 0/5] Add no libc support for x86-64 arch
Date:   Thu,  7 Oct 2021 13:31:52 +0700
Message-Id: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

This is the v2 of RFC to support build liburing without libc.

In this RFC, I introduce no libc support for x86-64 arch. Hopefully,
one day we can get support for other architectures as well.

Motivation:
Currently liburing depends on libc. We want to make liburing can be
built without libc.

This idea firstly posted as an issue on the liburing GitHub
repository here: https://github.com/axboe/liburing/issues/443

The subject of the issue is: "An option to use liburing without libc?".

On Mon, Sep 27, 2021 at 4:18 PM Mahdi Rakhshandehroo <notifications@github.com> wrote:
> There are a couple of issues with liburing's libc dependency:
> 
>  1) libc implementations of errno, malloc, pthread etc. tend to
>     pollute the binary with unwanted global/thread-local state.
>     This makes reentrancy impossible and relocations expensive.
>  2) libc doesn't play nice with non-POSIX threading models, like
>     green threads with small stack sizes, or direct use of the
>     clone() system call. This makes interop with other
>     languages/runtimes difficult.
> 
> One could use the raw syscall interface to io_uring to address these
> concerns, but that would be somewhat painful, so it would be nice
> for liburing to support this use case out of the box. Perhaps
> something like a NOLIBC macro could be added which, if defined,
> would patch out libc constructs and replace them with non-libc
> wrappers where applicable. A few API changes might be necessary for
> the non-libc case (e.g. io_uring_get_probe/io_uring_free_probe), but
> it shouldn't break existing applications as long as it's opt-in.

----------------------------------------------------------------

Explanation about the changes:

- New directory for arch dependent files. We create a new directory
  `src/arch`. This is where the arch dependent sources live. Currently
  we only have single arch support `src/arch/x86`. This directory
  contains crafted syscalls written in inline Assembly and get page
  size function.

- Currently, liburing uses 4 libc functions, they are:
   1) `malloc`
   2) `free`
   3) `memset`
   4) `sysconf` (to get the page size).
  
  To support no libc build, we wrap all libc functions used by
  liburing as `static inline` functions. They are all defined in
  `src/lib.h`.

  If we build liburing with libc, it will still use the functions from
  libc. If we build liburing without libc, it will use the functions
  in `src/no_libc.c` or arch dependent function from `src/arch` if
  required.

- Procedure to free the return value of `io_uring_get_probe_{,ring}`.
  Currently, several tests use `free()` to free the return value of
  this *probe* functions. But since these changes we should always
  use `io_uring_free_probe()`. Don't use `free()`.

- Don't use `errno` to check error from liburing functions on tests.
  We want the tests still work properly with liburing no libc.

----------------------------------------------------------------

How to build liburing without libc?

You can just simply add `export LIBURING_NOLIBC=y` before run the
build. Be sure to run `make clean` if you have dirty build, just to
ensure consistency.

  ammarfaizi2@integral:~/project/now/liburing$ export LIBURING_NOLIBC=y
  ammarfaizi2@integral:~/project/now/liburing$ ./configure
  prefix                        /usr
  includedir                    /usr/include
  libdir                        /usr/lib
  libdevdir                     /usr/lib
  relativelibdir                
  mandir                        /usr/man
  datadir                       /usr/share
  stringop_overflow             yes
  array_bounds                  yes
  __kernel_rwf_t                yes
  __kernel_timespec             yes
  open_how                      no
  statx                         yes
  C++                           yes
  has_ucontext                  yes
  has_memfd_create              yes
  LIBURING_NOLIBC               yes
  CC                            gcc
  CXX                           g++
  ammarfaizi2@integral:~/project/now/liburing$ taskset -c 0,1,2,3 make -j4

Make sure you see the `LIBURING_NOLIBC` with `yes`.

----------------------------------------------------------------

Extra improvements of using liburing build without libc:

1) The file size of liburing.so is reduced.

  With libc:
    116984 src/liburing.so.2.1.0

  Without libc:
    104656 src/liburing.so.2.1.0

2) Efficient function call. We inline all `syscall` instructions with
   inline Assembly. This greatly reduces the data movement, as syscall
   only clobbers %rax, %rcx and %r11. Plus it is compatible with the
   kernel style return value, so no need a branch to catch error from
   `errno` variable anymore.

   With libc, we may spend more extra time to save caller saved
   registers just to perform a syscall, because if we use libc, every
   syscall is wrapped with a function call.

   Another extra thing is when we need to check `errno` variable, that
   will cost more extra call to `__errno_location` and extra branches
   (as per we implement the kernel style return value).

   Without libc, the generated Assembly code is also smaller. For
   example, we can take a look at this generated Assembly code of
   `__io_uring_sqring_wait` function.

  With libc:

    0000000000003340 <__io_uring_sqring_wait>:
      3340: f3 0f 1e fa           endbr64 
      3344: 48 83 ec 10           sub    $0x10,%rsp
      3348: 8b b7 c4 00 00 00     mov    0xc4(%rdi),%esi
      334e: 31 c9                 xor    %ecx,%ecx
      3350: 31 d2                 xor    %edx,%edx
      3352: 6a 08                 push   $0x8
      3354: 41 b8 04 00 00 00     mov    $0x4,%r8d
      335a: 45 31 c9              xor    %r9d,%r9d
      335d: bf aa 01 00 00        mov    $0x1aa,%edi
      3362: 31 c0                 xor    %eax,%eax
      3364: e8 17 ef ff ff        call   2280 <syscall@plt>
      3369: 5a                    pop    %rdx
      336a: 59                    pop    %rcx
      336b: 41 89 c0              mov    %eax,%r8d
      336e: 85 c0                 test   %eax,%eax
      3370: 79 0b                 jns    337d <__io_uring_sqring_wait+0x3d>
      3372: e8 49 ee ff ff        call   21c0 <__errno_location@plt>
      3377: 44 8b 00              mov    (%rax),%r8d
      337a: 41 f7 d8              neg    %r8d
      337d: 44 89 c0              mov    %r8d,%eax
      3380: 48 83 c4 08           add    $0x8,%rsp
      3384: c3                    ret
      3385: 66 2e 0f 1f 84 00 00  cs nopw 0x0(%rax,%rax,1)
      338c: 00 00 00 
      338f: 90                    nop


  Without libc:

    0000000000001e20 <__io_uring_sqring_wait>:
      1e20: f3 0f 1e fa           endbr64 
      1e24: 31 d2                 xor    %edx,%edx
      1e26: 8b bf c4 00 00 00     mov    0xc4(%rdi),%edi
      1e2c: 45 31 c0              xor    %r8d,%r8d
      1e2f: b8 aa 01 00 00        mov    $0x1aa,%eax
      1e34: 41 ba 04 00 00 00     mov    $0x4,%r10d
      1e3a: 41 b9 08 00 00 00     mov    $0x8,%r9d
      1e40: 89 d6                 mov    %edx,%esi
      1e42: 0f 05                 syscall
      1e44: c3                    ret

3) More portable shared library. Sometimes we meet a case where libc
   version is not compatible with other versions of libc.

   Now, as we do not depend on libc, it's easier to distribute the
   liburing.so without worrying about libc version anymore. As long as
   the architecture is the same and the kernel version is compatible,
   that should not be a problem.
----------------------------------------------------------------
v2:
  - Rebase the work based on commit 326ed975d49e8c7b ("configure: add
    openat2.h for open_how and RESOLVE_* flags").

  - Fix the patches order, make sure fix up the tests first, add
    nolibc sources, and then add a variable build to enable it.

  - Fix incorrect data type for `__arch_impl_mmap()` offset. It was
    `int` (that's not right). The proper data type is `off_t`.

  - Always use `long` or `void *` to contain the return value of
    syscall in `__arch_impl_*` functions.

  - Rename `src/no_libc.` to `src/nolibc.c`.

  - Reduce the number of patches to 5, it was 6.

Link: [v1] https://lore.kernel.org/io-uring/20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id/T/
----------------------------------------------------------------

How to apply and test?

This work is based on Jens Axboe's liburing repo on master branch, commit
326ed975d49e8c7bff071abe8e7ac5e0c0196622 ("configure: add openat2.h for
open_how and RESOLVE_* flags").

If you want a Git repository you can pull from

The following changes since commit 326ed975d49e8c7bff071abe8e7ac5e0c0196622:

  configure: add openat2.h for open_how and RESOLVE_* flags (2021-10-06 12:08:45 -0600)

are available in the Git repository at:

  https://github.com/ammarfaizi2/liburing tags/nolibc-x86-64-v2

for you to fetch changes up to ebe8926cef4149cd6427607fab0d86537c5a2ba8:

  Add LIBURING_NOLIBC variable and edit src/Makefile (2021-10-07 13:07:35 +0700)

Please review and comment!
----------------------------------------------------------------
Ammar Faizi (5):
      test/{iopoll,read-write}: Use `io_uring_free_probe()` instead of `free()`
      test/cq-size: Don't use `errno` to check liburing's functions
      Add arch dependent directory and files
      Add no libc build support
      Add LIBURING_NOLIBC variable and edit src/Makefile

 configure              |   7 ++
 src/Makefile           |  13 +++-
 src/arch/x86/lib.h     |  26 +++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/lib.h              |  77 +++++++++++++++++++
 src/nolibc.c           |  48 ++++++++++++
 src/queue.c            |  14 +---
 src/register.c         |  12 +--
 src/setup.c            |  30 +++-----
 src/syscall.c          |  11 ++-
 src/syscall.h          |  71 ++++++++++++++----
 test/Makefile          |  19 ++++-
 test/cq-size.c         |  10 ++-
 test/iopoll.c          |   2 +-
 test/read-write.c      |   2 +-
 15 files changed, 477 insertions(+), 65 deletions(-)
 create mode 100644 src/arch/x86/lib.h
 create mode 100644 src/arch/x86/syscall.h
 create mode 100644 src/lib.h
 create mode 100644 src/nolibc.c

-- 
Ammar Faizi



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E33D428197
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhJJNzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 09:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhJJNzr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 09:55:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578AFC061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x130so3526275pfd.6
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jKxcLh8F7ZX9q73sRkHR0nUn0CrgBx91S0ZJgfGE0dk=;
        b=eyIHXI8UBGanqTB42DGNJcUtiWqtpyEMkYgM+frdu4Rh5Vi9fquBCID7iww66bM1tq
         LhFw4nxBS2hfjGXbvOXa62WFAjois4L3rP8njLnwBH+5HK5jVYaT3RzyVvq8r5Z2I2HS
         Bu82/8L/wPzw+Shq+kx9MS5QWOZcfGbPmyLyM2Ut+1C4lRZfJpvBlGSwPc4dxnRTUczS
         6gSu3FuE+X6iIjIgM70cU63o1i1aCNcEbACuNjHOisbg6oYnyH53cbtQbxST3xHIR5FF
         qd2fshUxaYEnUeqNOWAgGcH1BjGdpdV7MMf3QJ4XxJuR/pPzoZ4TMxget0dLo1plxecr
         UfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jKxcLh8F7ZX9q73sRkHR0nUn0CrgBx91S0ZJgfGE0dk=;
        b=aUZpGkJrgH2pTd8sY4K4mlNin6+o5Mp0XFi1CBB4SSw4FVVs1+TTEJXngJ0wTZHA/o
         QBXSuI0Ss9JO1sKahwc+sDSJtSFWAAVz29gwm0rW6ERu1hzSf36See4fa5pA0SX/+MPH
         XeyzefJn+RdEYTuEvrBQ9JGfXswL4Gf4J6SZfvzkh84wFqm17OXAUlsha55k+RPepq0V
         VhFFyjovO8ASfg25BlndKnmR4LBhtRQrZjmLtSmLRQfRyGjlVQx2cD/JOFSGhUtaKcc5
         QHREF3gUUCfIutmY1EPLbZIaD6Ww9t8OEFWVwc6ofzeKn1Z/j8hGsi+SQnyP0cvtsxt4
         VVbQ==
X-Gm-Message-State: AOAM531Rbj8HmYRktvcGGxvDK8Iwni06vQN9Cp4qLT4JROBg3TxXJWP2
        HFXb7cZVxjJ3D045oUCQpF0FaQ==
X-Google-Smtp-Source: ABdhPJyWDFi946bTkad/3K2DkI71kQwJ2EeLqBLW1L0CE7aAciqIFWF6sCnwVYCnQ1z29CE+1tcmag==
X-Received: by 2002:a63:1d53:: with SMTP id d19mr13653536pgm.85.1633874027681;
        Sun, 10 Oct 2021 06:53:47 -0700 (PDT)
Received: from integral.. ([182.2.41.40])
        by smtp.gmail.com with ESMTPSA id p4sm4557249pjo.0.2021.10.10.06.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 06:53:46 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v3 liburing 0/3] Add nolibc support for x86-64 arch 
Date:   Sun, 10 Oct 2021 20:53:35 +0700
Message-Id: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is the patchset v3 to add support liburing nolibc x86-64. If you
think there is more to be fixed, please let me know, I will be happy
to address it.

In this patchset, I introduce nolibc support for x86-64 arch.
Hopefully, one day we can get support for other architectures as well.

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
  
  To support nolibc build, we provide our own version of them. It is
  defined in `src/nolibc.c`.

- Procedure to free the return value of `io_uring_get_probe_{,ring}`.
  Currently, several tests use `free()` to free the return value of
  this *probe* functions. But since these changes we should always
  use `io_uring_free_probe()`. Don't use `free()`.

- Don't use `errno` to check error from liburing functions on tests.
  We want the tests still work properly with liburing no libc.

- New config variable and macro for conditional build. To support
  nolibc build we add `CONFIG_NOLIBC` in the config.

- New configure option `--nolibc`. This is to build liburing without
  libc.

----------------------------------------------------------------

How to build liburing without libc?

Execute `./configure --nolibc`, then run the `make`. Be sure to run
`make clean` if you have dirty build, just to ensure consistency.

  ammarfaizi2@integral:~/project/now/liburing$ ./configure --nolibc
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
  open_how                      yes
  statx                         yes
  C++                           yes
  has_ucontext                  yes
  has_memfd_create              yes
  liburing_nolibc               yes
  CC                            gcc
  CXX                           g++
  ammarfaizi2@integral:~/project/now/liburing$ taskset -c 0,1,2,3 make -j4

Make sure you see the `liburing_nolibc` with `yes`.

----------------------------------------------------------------

Extra improvements of using liburing build without libc (x86-64):

1) File size is reduced.

  With libc:
    116136 src/liburing.so.2.1.0

  Without libc:
    104136 src/liburing.so.2.1.0

2) Efficient function call.

   We inline all `syscall` instructions with inline Assembly. This
   greatly reduces the data movement, as `syscall` only clobbers %rax,
   %rcx and %r11. Plus it is compatible with the kernel style return
   value, so no need a branch to catch error from `errno` variable
   anymore.

   With libc, we may spend more extra time to save caller saved
   registers just to perform a syscall, because if we use libc, every
   syscall is wrapped with a function call.

   Another extra cost from libc is when we take the error branch, we
   have to perform a call to `__errno_location` function just to get
   the error code. With nolibc build, this is completely avoided and
   we still have the thread-safe behavior.

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
v3 (this patchset):
  - Fix clang warning. The -nolibc flag is not necessary, remove it.

  - Clean up error message language for not supported arch.

  - When we run `make clean`, make sure nolibc objects are also removed.

  - Drop one patch (fix UAF bug) as it has been applied in patchset v2.
    Now we have 3 patches in this series.

v2:
  - Change `LIBURING_NOLIBC` to `CONFIG_NOLIBC` for consistency.

  - To build liburing without libc, use `./configure --nolibc` instead
    of `export LIBURING_NOLIBC=y`.

  - Fix `test/thread-exit`, change the global variable to static as
    we don't use it in other translation units.

  - Add missing register comment in `src/arch/x86/syscall.h`

v1:
  - Drop extra wrappers for `malloc()`, `free()` and `memset()`.

  - Fix UAF bug in test/thread-exit. I found this after I changed the
    function name `uring_free()` to `free()` for nolibc build.

  - 2 patches have been applied in RFC v2, drop them. Add one extra
    patch to fix the UAF bug. So we have 4 patches here.

RFC v2:
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

Link: [RFC v1] https://lore.kernel.org/io-uring/20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id/T/
Link: [RFC v2] https://lore.kernel.org/io-uring/20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id/
Link: [PATCHSET v1] https://lore.kernel.org/io-uring/20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id/T/#m91e5cf60a0813155104d5e676df903c1ffa1b62b
Link: [PATCHSET v2] https://lore.kernel.org/io-uring/20211010063906.341014-1-ammar.faizi@students.amikom.ac.id/T/
----------------------------------------------------------------

If you want to view a git repository, you can take a look at:
  
  https://github.com/ammarfaizi2/liburing nolibc-x86-64

Top commit is e78a436eb7d7f590af3bc7847c388156a224d43a:

  configure: Add `CONFIG_NOLIBC` variable and macro (2021-10-10 20:45:11 +0700)

----------------------------------------------------------------
Ammar Faizi (3):
      Add arch dependent directory and files
      Add no libc build support
      configure: Add `CONFIG_NOLIBC` variable and macro

 configure              |   9 +++
 src/Makefile           |  17 ++++-
 src/arch/x86/lib.h     |  26 +++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/lib.h              |  44 +++++++++++
 src/nolibc.c           |  48 ++++++++++++
 src/queue.c            |  14 +---
 src/register.c         |  12 +--
 src/setup.c            |  17 +----
 src/syscall.c          |  11 ++-
 src/syscall.h          |  71 ++++++++++++++----
 test/Makefile          |  19 ++++-
 12 files changed, 434 insertions(+), 54 deletions(-)
 create mode 100644 src/arch/x86/lib.h
 create mode 100644 src/arch/x86/syscall.h
 create mode 100644 src/lib.h
 create mode 100644 src/nolibc.c

-- 
Ammar Faizi



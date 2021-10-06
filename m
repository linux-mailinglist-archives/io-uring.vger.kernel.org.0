Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44BE424072
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhJFOwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhJFOwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:52:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC94C061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:50:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so2484555pjb.4
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmUphfmiGkpH1nk2MCgwffKZo7gYsNkb4bmtxuDpwfo=;
        b=FMBg7n6rIlHwcxOY7THIEp52IpUCOJkIybPq7gcGQtkRwXQg5KqcrupxYe7BEVc2z0
         fNHH6gK9P5njMVfyobT3DmdtBGV96JkyymgpCPVWXir4EOBqf+NSSpaEO8XPI4MLw5AU
         yZYViLyY1xeO4GKYuqcmnB1NvTrGVChq20ZFnOsgZG7XPejnyWUTD4hEMds2V8Oo7v+W
         24W5HQHvEy1zJ5aHmQMVMR/u3ssU8pWgsawI6qtXolp+DC2+E0IrqxmCnUbPTXqyYfIg
         VekZvyWBxVCg2atPqkkD2k3KZ2UMaIAUDvGg3hNZgLBJ6QPfPMg8FZcMQfVCp1SlJAYX
         Hc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmUphfmiGkpH1nk2MCgwffKZo7gYsNkb4bmtxuDpwfo=;
        b=IBhu8QyBFaHv1OZ0c/YtMysZgWjeWTsUyXfybL8a2iu/0jxlT6QAxpLMWg3G4wyeUm
         dpH/9WM6hkRKi0L24ef/vdoYzP3RACmRMjVBxh5WI8jyIdR38WsEDkeXTMRMhPJO+USL
         6Axht0YOsxxhhkc8AZD2sRHtaYRchqby2bBFVV+ge9z4YCg/Usb4TBsKzS+u8ssLQ+zn
         MQ/fUzWEnxU2o0Bs/WrT2vg8rWAHWilJENiUsue3fo73Kd6l8uCzgwZrGrNlxRYMwar6
         dRtzWrNZ6oz/CNxaQR0kLPgP68RhYFFdADfLCScbN9TUc2wyBz4bubmUDxYu6WWgvK82
         2nCQ==
X-Gm-Message-State: AOAM532zoojjUtZLsThwcmq37SM6orxf9SPucVbvjUXapTymZCaj6X78
        jsh/5svepY3l2CIrskc4Ii1AwQ==
X-Google-Smtp-Source: ABdhPJzVixonYeFGJ+Uv9TiCblNQI6sx4pQbeicQ4+udHQPWEvJGiJs4DXZf5E6NhGNXIOmvxheu4A==
X-Received: by 2002:a17:90a:760a:: with SMTP id s10mr4338927pjk.135.1633531847069;
        Wed, 06 Oct 2021 07:50:47 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:50:46 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v1 RFC liburing 0/6] Add no libc support for x86-64 arch
Date:   Wed,  6 Oct 2021 21:49:06 +0700
Message-Id: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

This is the v1 of RFC to support build liburing without libc.

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

How to apply and test?

This work is based on Jens Axboe's liburing repo on master branch, commit
a9895111798af2003f5298abb1d5bdaf11ca549e ("Fix typo "timout" -> "timeout"").

If you want a Git repository you can pull from

The following changes since commit a9895111798af2003f5298abb1d5bdaf11ca549e:

  Fix typo "timout" -> "timeout" (2021-10-05 16:42:02 -0600)

are available in the Git repository at:

  https://github.com/ammarfaizi2/liburing tags/nolibc-x86-64

for you to fetch changes up to 73ea5bf2b08c8ea100f16b4494353107ba5fe6d4:

  src/{queue,register,setup}: Clean up unused includes (2021-10-06 18:33:20 +0700)

Please review and comment!
----------------------------------------------------------------
Ammar Faizi (6):
      configure: Add LIBURING_NOLIBC variable
      Add no libc support
      Add x86-64 no libc build support
      test/cq-size: Don't use `errno` to check liburing's functions
      test/{iopoll,read-write}: Use `io_uring_free_probe()` instead of `free()`
      src/{queue,register,setup}: Clean up unused includes

 configure              |   7 ++
 src/Makefile           |  13 ++-
 src/arch/x86/lib.h     |  26 ++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++++
 src/lib.h              |  77 +++++++++++++++++
 src/no_libc.c          |  48 +++++++++++
 src/queue.c            |  14 +--
 src/register.c         |  12 +--
 src/setup.c            |  28 ++----
 src/syscall.c          |  11 ++-
 src/syscall.h          |  71 +++++++++++----
 test/Makefile          |  23 ++++-
 test/cq-size.c         |  10 ++-
 test/iopoll.c          |   2 +-
 test/read-write.c      |   2 +-
 15 files changed, 480 insertions(+), 64 deletions(-)
 create mode 100644 src/arch/x86/lib.h
 create mode 100644 src/arch/x86/syscall.h
 create mode 100644 src/lib.h
 create mode 100644 src/no_libc.c

-- 
Ammar Faizi


Return-Path: <io-uring+bounces-5482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED8B9F13D4
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D2B18815CB
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FFE1E47B3;
	Fri, 13 Dec 2024 17:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZzHr0Ys"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB11E411D;
	Fri, 13 Dec 2024 17:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734111373; cv=none; b=TEtgdvCVR9Vkq/5BbQ6VVpam0vVL9nhVlM946O/fggZZAYc0uxa/VwR1LVarcGYZTlv4cxLs0+jQAei4KMmUP2dX4pkgA+n5AMdGEaYjpfgtSngftMauSuAeK6TLGGXNVq4DF/0aSQTip5y1KRPLgyVpY3HQMnxgJnICYGB5Qpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734111373; c=relaxed/simple;
	bh=O9y0sHWha5rcaeWMYkWRQM68CYFY2lXzN1XMmpmXZXs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Be7gGnaYRSU3mM2g/E+9dDbYrs7ArGduahBR2GrBXBvVuiPi43My1ppxxuNiFLqiHE0rKBgc8qn3qEeMSkTvMDKrzD1DR4n+MvY8sCP9Hm6kUvfynQmH3WOsRRxhN3temACzPH9S/mqVGVTKMs622c32Mht2niMVxA1xViEV+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZzHr0Ys; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e387ad7abdaso1505341276.0;
        Fri, 13 Dec 2024 09:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734111370; x=1734716170; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AP52KQB3QouC9iRllWQhVcvogl1qKrRKRnQ2Rg3dNjY=;
        b=SZzHr0YskyBcUo4ytqYjLtfpwA5d8z204dIr4NDolcTiLdmo6+rIYFXjBULgYj1C5n
         rOBpgeXns3JzhldbDNxM7QtF+skbeKv5OejdUlOeKGT8W/358ueI1EaxjzJEFgEChMPj
         9EfhQyHGxoUiq9mANil7FiaOC1RpKJUk0T2jd69FH6G2SeM2/QLfZkKbyDTlSZ2UO55W
         mpdAjvuBGpv4DTbl8/d1szGh8mqS/5hgSfkbOxt/XpKtzDdm4GaPHlRHG4UAbzBfrhu/
         dGYI2rLbHvPlM3SriPb1tqWwHEH6VPMpxerfGp4WSkTR/HHNNxbTz6mDRXiUKN4dt2BD
         pyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734111370; x=1734716170;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AP52KQB3QouC9iRllWQhVcvogl1qKrRKRnQ2Rg3dNjY=;
        b=nFanTzUnQ+DUr5aioBAdkA1h02R9Rv4fjbAKvDQX4OtcaSngKeAvi/BMJxDi0v0BA5
         YYw02Fwo3vN2AMdTd6jy+RhiecqD6k5GT/cSBBO7VhajeOGnOV4i5lek38Tm8YE81cbt
         g93hQG36kR3peTSPTlu0agve3X9JEIreLFcD6TbRQ4Xm77hgYwTMnpPLIqQNZ31z67to
         vhMRTAreLoI+I3lsiofvQNWqXHmRj57P1QpxSc2eCmXx4BXl43mfAbOqwVPDZsbDG7GC
         YuBrIcV7vUEjYyETgbE3jAFZcxErK/zf2Xa6Lc0yeg+AzMoxcCJ8fMKiMvNMfYvcCrs0
         vCiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFwNI5lHPFT7pEZ46vWGKuUw9EieHuZ6Wo4m73hcYXVUhLC9UaQejz+mhChfMxWMofL6UcKMzKpA==@vger.kernel.org, AJvYcCXV9uaLfL1CwFEHVTrNGPteE3AKxR5tz4QbB4Le2OP0MSTWCZJQbqosY8TTTxBLl68GMnX5dcfAzgMlk8YC@vger.kernel.org
X-Gm-Message-State: AOJu0YyobcPRoqitvijcavha+LLBnWFYW2DDR741CKmK4hkUiXXfO+1c
	A2dZ6K0jqj/DqUy/9Y9V7+S+H+8AOOJdHtZzm5Yx9q6XNPJgpPRftqT+qQ5fhL3dPkclC4tmbaf
	eGbgQS3dhNAodgCXhIclRpiiw66M=
X-Gm-Gg: ASbGncuynZOIyHD3jXuI/J0zLco1RqlMRPDGLiQS2cnc2LlAr+BC3OTv1FwtFlA5nDH
	Gt4O+Q2S0KlgWIdpwmjE7PLmT8rQDlAHW4JQCDprogwmFcfZlMuq8aBeBGRiw6aD6U9g+/q62
X-Google-Smtp-Source: AGHT+IH5mxLC1u/jBVINe9ogDpUPAcqOOqV9UgfLHq9TdVKfAoQhS4PEHD0qL2CaF+mopMJKB1e3/30GwpZGejyiYYg=
X-Received: by 2002:a05:6902:150a:b0:e39:8ff9:4f47 with SMTP id
 3f1490d57ef6-e434abfea29mr2735154276.27.1734111370161; Fri, 13 Dec 2024
 09:36:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chase xd <sl1589472800@gmail.com>
Date: Fri, 13 Dec 2024 18:35:59 +0100
Message-ID: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
Subject: WARNING in get_pat_info
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, when I tested io-uring on lts 5.15 I found this bug, do you think
this is a bug from io-uring or mm subsystem?

Syzkaller hit 'WARNING in get_pat_info' bug.

R10: 0000000004000053 R11: 0000000000000246 R12: 0000000000000004
R13: 00007fff4f16cfc8 R14: 00007f78cf8b04b0 R15: 0000000000000001
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 6 PID: 6779 at arch/x86/mm/pat/memtype.c:1020
get_pat_info+0x1a9/0x210 arch/x86/mm/pat/memtype.c:1020
Modules linked in:
CPU: 6 PID: 6779 Comm: syz-executor224 Not tainted 5.15.173-dirty #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:get_pat_info+0x1a9/0x210 arch/x86/mm/pat/memtype.c:1020
Code: ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 75 64 49 89
5d 00 eb a6 90 0f 0b 90 e9 e2 fe ff ff b8 ea ff ff ff eb 96 90 <0f> 0b
90 b8 ea ff ff ff eb 8b 4c 89 f7 e8 f5 3e 7b 00 e9 b9 fe ff
RSP: 0018:ffffc900017df788 EFLAGS: 00010202
RAX: 0000000000000028 RBX: ffff88806d12fad0 RCX: 000ffffffffff000
RDX: 1ffff1100da25f64 RSI: 0000000020fff000 RDI: ffffc900017df618
RBP: ffffc900017df850 R08: 0000000000000000 R09: ffffc900017df710
R10: 0000000000000001 R11: 0000000000000001 R12: 1ffff920002fbef2
R13: 0000000000000000 R14: ffff88806d12fb20 R15: ffff88806d12fb70
FS:  000055555f38c480(0000) GS:ffff8880b9d80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000104 CR3: 000000001bf80000 CR4: 0000000000750ee0
PKRU: 55555554
Call Trace:
 <TASK>
 untrack_pfn+0xa4/0x1d0 arch/x86/mm/pat/memtype.c:1122
 unmap_single_vma+0x14b/0x2d0 mm/memory.c:1600
 zap_page_range_single+0x290/0x3d0 mm/memory.c:1704
 remap_pfn_range_notrack+0x6f6/0x970 mm/memory.c:2464
 remap_pfn_range+0xa5/0x110 mm/memory.c:2489
 io_uring_mmap+0x330/0x430 io_uring/io_uring.c:9994
 call_mmap include/linux/fs.h:2179 [inline]
 mmap_region+0x9eb/0x12b0 mm/mmap.c:1791
 do_mmap+0x635/0xe50 mm/mmap.c:1575
 vm_mmap_pgoff+0x167/0x210 mm/util.c:551
 ksys_mmap_pgoff+0x3b6/0x5f0 mm/mmap.c:1624
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x36/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x6c/0xd6
RIP: 0033:0x7f78cf8327dd
Code: 28 c3 e8 66 21 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4f16ccf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f78cf8327dd
RDX: 0000000003000009 RSI: 0000000000001000 RDI: 0000000020fff000
RBP: 00007fff4f16cdb0 R08: 0000000000000003 R09: 0000000008000000
R10: 0000000004000053 R11: 0000000000000246 R12: 0000000000000004
R13: 00007fff4f16cfc8 R14: 00007f78cf8b04b0 R15: 0000000000000001
 </TASK>


Syzkaller reproducer:
# {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1
Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
HandleSegv:true Trace:false LegacyOptions:{Collide:false Fault:false
FaultCall:0 FaultNth:0}}
r0 = io_uring_setup(0x9b0, &(0x7f0000000100)={0x0, 0xa91a, 0x40, 0x0, 0x33c})
mmap$IORING_OFF_CQ_RING(&(0x7f0000fff000/0x1000)=nil, 0x1000,
0x3000009, 0x4000053, r0, 0x8000000) (fail_nth: 4)


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef __NR_io_uring_setup
#define __NR_io_uring_setup 425
#endif

static __thread int clone_ongoing;
static __thread int skip_segv;
static __thread jmp_buf segv_env;

static void segv_handler(int sig, siginfo_t* info, void* ctx)
{
  if (__atomic_load_n(&clone_ongoing, __ATOMIC_RELAXED) != 0) {
    exit(sig);
  }
  uintptr_t addr = (uintptr_t)info->si_addr;
  const uintptr_t prog_start = 1 << 20;
  const uintptr_t prog_end = 100 << 20;
  int skip = __atomic_load_n(&skip_segv, __ATOMIC_RELAXED) != 0;
  int valid = addr < prog_start || addr > prog_end;
  if (skip && valid) {
    _longjmp(segv_env, 1);
  }
  exit(sig);
}

static void install_segv_handler(void)
{
  struct sigaction sa;
  memset(&sa, 0, sizeof(sa));
  sa.sa_handler = SIG_IGN;
  syscall(SYS_rt_sigaction, 0x20, &sa, NULL, 8);
  syscall(SYS_rt_sigaction, 0x21, &sa, NULL, 8);
  memset(&sa, 0, sizeof(sa));
  sa.sa_sigaction = segv_handler;
  sa.sa_flags = SA_NODEFER | SA_SIGINFO;
  sigaction(SIGSEGV, &sa, NULL);
  sigaction(SIGBUS, &sa, NULL);
}

#define NONFAILING(...)                                                        \
  ({                                                                           \
    int ok = 1;                                                                \
    __atomic_fetch_add(&skip_segv, 1, __ATOMIC_SEQ_CST);                       \
    if (_setjmp(segv_env) == 0) {                                              \
      __VA_ARGS__;                                                             \
    } else                                                                     \
      ok = 0;                                                                  \
    __atomic_fetch_sub(&skip_segv, 1, __ATOMIC_SEQ_CST);                       \
    ok;                                                                        \
  })

static bool write_file(const char* file, const char* what, ...)
{
  char buf[1024];
  va_list args;
  va_start(args, what);
  vsnprintf(buf, sizeof(buf), what, args);
  va_end(args);
  buf[sizeof(buf) - 1] = 0;
  int len = strlen(buf);
  int fd = open(file, O_WRONLY | O_CLOEXEC);
  if (fd == -1)
    return false;
  if (write(fd, buf, len) != len) {
    int err = errno;
    close(fd);
    errno = err;
    return false;
  }
  close(fd);
  return true;
}

static int inject_fault(int nth)
{
  int fd;
  fd = open("/proc/thread-self/fail-nth", O_RDWR);
  if (fd == -1)
    exit(1);
  char buf[16];
  sprintf(buf, "%d", nth);
  if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf))
    exit(1);
  return fd;
}

static const char* setup_fault()
{
  int fd = open("/proc/self/make-it-fail", O_WRONLY);
  if (fd == -1)
    return "CONFIG_FAULT_INJECTION is not enabled";
  close(fd);
  fd = open("/proc/thread-self/fail-nth", O_WRONLY);
  if (fd == -1)
    return "kernel does not have systematic fault injection support";
  close(fd);
  static struct {
    const char* file;
    const char* val;
    bool fatal;
  } files[] = {
      {"/sys/kernel/debug/failslab/ignore-gfp-wait", "N", true},
      {"/sys/kernel/debug/fail_futex/ignore-private", "N", false},
      {"/sys/kernel/debug/fail_page_alloc/ignore-gfp-highmem", "N", false},
      {"/sys/kernel/debug/fail_page_alloc/ignore-gfp-wait", "N", false},
      {"/sys/kernel/debug/fail_page_alloc/min-order", "0", false},
  };
  unsigned i;
  for (i = 0; i < sizeof(files) / sizeof(files[0]); i++) {
    if (!write_file(files[i].file, files[i].val)) {
      if (files[i].fatal)
        return "failed to write fault injection file";
    }
  }
  return NULL;
}

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
  syscall(__NR_mmap, /*addr=*/0x1ffff000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=*/-1,
          /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x20000000ul, /*len=*/0x1000000ul,
          /*prot=PROT_WRITE|PROT_READ|PROT_EXEC*/ 7ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=*/-1,
          /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x21000000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=*/-1,
          /*offset=*/0ul);
  const char* reason;
  (void)reason;
  if ((reason = setup_fault()))
    printf("the reproducer may not work as expected: fault injection setup "
           "failed: %s\n",
           reason);
  install_segv_handler();
  intptr_t res = 0;
  if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {
  }
  NONFAILING(*(uint32_t*)0x20000104 = 0xa91a);
  NONFAILING(*(uint32_t*)0x20000108 = 0x40);
  NONFAILING(*(uint32_t*)0x2000010c = 0);
  NONFAILING(*(uint32_t*)0x20000110 = 0x33c);
  NONFAILING(*(uint32_t*)0x20000118 = -1);
  NONFAILING(memset((void*)0x2000011c, 0, 12));
  res =
      syscall(__NR_io_uring_setup, /*entries=*/0x9b0, /*params=*/0x20000100ul);
  if (res != -1)
    r[0] = res;
  inject_fault(4);
  syscall(__NR_mmap, /*addr=*/0x20fff000ul, /*len=*/0x1000ul,
          /*prot=PROT_GROWSUP|PROT_GROWSDOWN|PROT_SEM|PROT_READ*/ 0x3000009ul,
          /*flags=MAP_SHARED_VALIDATE|MAP_UNINITIALIZED|MAP_FIXED|MAP_32BIT*/
          0x4000053ul, /*fd=*/r[0], /*offset=*/0x8000000ul);
  return 0;
}


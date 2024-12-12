Return-Path: <io-uring+bounces-5458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53AA9EE3C5
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 11:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE63F162271
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 10:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B76421018A;
	Thu, 12 Dec 2024 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGm8rt5j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E5A20FA8A;
	Thu, 12 Dec 2024 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733998149; cv=none; b=Q0+OjemfTMbD4/fU8m80Q3Hn5NoJPw6uqhXCaQo6T/sdYv3B6Zhje1svn8xXiS5/QHxBISzi69IxaMeDbAAxBWlarq5Zm7KHSE1OK0v219a03UXoNW8s7iagRj69cU4Wf7BJOEOHBaOMolnliSWIuIL2x6sPZH8BMH2C5xC+WFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733998149; c=relaxed/simple;
	bh=l+hCqTFgoN+CE5aZeX3/THUoVHXbSX9RvtvYT2Su/JU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=edqprHwXIT4TgzWM5EXWMTYQ3uXtiaPfNAMg69ST/HO2PSYcdE1jeH3TZNy3gzLC8+KBmRuZX6MzrV7NSpU8UcUNZfEnom+OAGp46YfZjyzzh9O2NTSAfT73CliWRv3uVG+wLtvXlwlQ44xiXPfFl/i7j0aVt0n0m4Ed30lpk+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QGm8rt5j; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e3a0d2d15adso252747276.0;
        Thu, 12 Dec 2024 02:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733998145; x=1734602945; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vX3o353pHHVF10YMeVcO8TLfEv/PU4xfol8kyUFcYbs=;
        b=QGm8rt5jhb/SlSc46SDv6SFpgJ5YFicI8J+C/oUUF6Yo6bugXAongaGZ0TX6Mgkt5w
         C3HL0MSykesP4YncUz1xOU7bYxWZvPS6cGi6C10xIu08TPcpglrcODTOguvEFi5K7+9V
         fjs9zEZ8Ayf02mJCm6iaVU+TOk0dnCj5+5UulTAjsZzRc6zI7eNzRn8UKrhBuBewhZx7
         r7Nr7qFc0IpQwhkCrfKg+EF09OgIkZcj8RuSVDOeaeefDlproqRNWOsX/vRi0TbPIRKd
         JQtPpM9yg4Psf9l5gZCx6FnyxuwZOLLkX8NwwU0q46XZb7FCuk0DMGdj909dvDJKEzhS
         woLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733998145; x=1734602945;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vX3o353pHHVF10YMeVcO8TLfEv/PU4xfol8kyUFcYbs=;
        b=aKq8Krjvdz/+weVz7WEVFJxX3nWP8VZHTGeNOPG1bnzf2ciOfVXTValig6YHpwamnN
         GeMG4rWYXe0iLR300NIbZWFxXooaWy6C2/5blul+P3xh4EtdCU/T6rFlk1/df7CR4a/j
         lAKxyn5XtHT6dqLpIR8so4edTpQiJ4EREYml72UVVQwJ2913YWc4/xjJ/sAp2PjlZTkg
         YwivJre1jArQhvALHo3tJhk4tIyUsleeH8wPKYRJujNH7PlB6DsQbEiOwbBAIPfiiM6O
         Tm1zfiVduePW+NmlxDYUyjenmSk1XPOYKxylf2qGXR4pPDt3ruKUr5r/v50pz/0eDre3
         WfFA==
X-Forwarded-Encrypted: i=1; AJvYcCUC5TsUhSSAU2b8eUZEZmsxmWtgJeodXh9Fwh/QKj1L9/EjoYucfN+nuG+FHBJGHEy8YG7tHK1C/bme9VcM@vger.kernel.org, AJvYcCUkE64l/W5sLrgeY0MVfUmAuBKBGh41JlWSl+P9O9WAtykwqdZZJm17hcI9kXiOR/RHPb701mlddg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhSW6Pc08LGKV+XGfmLBNMvLubgmO95x9l6CSboqIAFYB5xcTH
	GZPKbGhGN2E2RZTw/Qz3R+p8TA7RnLvwx5cvmiP751M/PYOcqlgt7309bQD+lU7EB7aM+JV9NJ3
	LIkos1GnIpMfr6te2WQ9OcspZ6Zu37qpWVBo=
X-Gm-Gg: ASbGnctD9wLxxnOF9VL1C5Kr1aoLwJjDWQnylFO5F440zwaxOhq/xyfDNGGPs3Q4CgG
	tNPRQ59xN5IVj+E6zgdUcHUsKRl0r2Bf+aZp/PEuA3U0yNrXmC20Kg/USksrhnkAMd+l/dRAv
X-Google-Smtp-Source: AGHT+IEobaHepGlZ0Jvxg9SlLJuzB1vjs2vZWXMQ9Pmyu4UfOquNBJOf52MmmRFpyOdp0H/vsImn8DWjh/uUZ7fZzxw=
X-Received: by 2002:a05:6902:1b86:b0:e38:1310:6da9 with SMTP id
 3f1490d57ef6-e3da324c3f2mr1978469276.36.1733998145383; Thu, 12 Dec 2024
 02:09:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chase xd <sl1589472800@gmail.com>
Date: Thu, 12 Dec 2024 11:08:55 +0100
Message-ID: <CADZouDQ7TcKn8gz8_efnyAEp1JvU1ktRk8PWz-tO0FXUoh8VGQ@mail.gmail.com>
Subject: [io-uring] use-after-free in io_cqring_wait
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Syzkaller hit 'KASAN: use-after-free Read in io_cqring_wait' bug.

==================================================================
BUG: KASAN: use-after-free in io_cqring_wait+0x16bc/0x1780
io_uring/io_uring.c:2630
Read of size 4 at addr ffff88807d128008 by task syz-executor994/8389

CPU: 3 UID: 0 PID: 8389 Comm: syz-executor994 Not tainted
6.12.0-rc4-00089-g7eb75ce75271-dirty #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x82/0xd0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0xc0/0x5e0 mm/kasan/report.c:488
 kasan_report+0xbd/0xf0 mm/kasan/report.c:601
 io_cqring_wait+0x16bc/0x1780 io_uring/io_uring.c:2630
 __do_sys_io_uring_enter+0xf37/0x15d0 io_uring/io_uring.c:3434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1112ee1eed
Code: c3 e8 d7 1e 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1112e87198 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f1112f7c208 RCX: 00007f1112ee1eed
RDX: 0000000000001737 RSI: 0000000000002751 RDI: 0000000000000003
RBP: 00007f1112f7c200 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000005 R11: 0000000000000246 R12: 000000000000481a
R13: 0000000000000003 R14: 00007f1112eab0e0 R15: 00007f1112e67000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000
index:0xffff88807d12e000 pfn:0x7d128
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0000b56708 ffffea0001f44b08 0000000000000000
raw: ffff88807d12e000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 2, migratetype Unmovable, gfp_mask
0x442dc0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_COMP|__GFP_ZERO), pid
8389, tgid 8388 (syz-executor994), ts 35530280269, free_ts 35581689370
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x2e7/0x350 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0xdf6/0x2800 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x219/0x21e0 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x1cc/0x510 mm/mempolicy.c:2265
 io_mem_alloc_compound io_uring/memmap.c:29 [inline]
 io_pages_map+0xe5/0x500 io_uring/memmap.c:73
 io_register_resize_rings+0x377/0x14b0 io_uring/register.c:442
 __io_uring_register+0x1821/0x2290 io_uring/register.c:810
 __do_sys_io_uring_register io_uring/register.c:907 [inline]
 __se_sys_io_uring_register io_uring/register.c:884 [inline]
 __x64_sys_io_uring_register+0x178/0x2b0 io_uring/register.c:884
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 8391 tgid 8388 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0x63f/0xdd0 mm/page_alloc.c:2638
 __folio_put+0x23f/0x2f0 mm/swap.c:126
 folio_put include/linux/mm.h:1478 [inline]
 put_page+0x21b/0x280 include/linux/mm.h:1550
 io_pages_unmap+0x1aa/0x3c0 io_uring/memmap.c:114
 io_register_free_rings.isra.0+0x67/0x1b0 io_uring/register.c:382
 io_register_resize_rings+0x101c/0x14b0 io_uring/register.c:565
 __io_uring_register+0x1821/0x2290 io_uring/register.c:810
 __do_sys_io_uring_register io_uring/register.c:907 [inline]
 __se_sys_io_uring_register io_uring/register.c:884 [inline]
 __x64_sys_io_uring_register+0x178/0x2b0 io_uring/register.c:884
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88807d127f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807d127f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807d128000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff88807d128080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88807d128100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


Syzkaller reproducer:
# {Threaded:true Repeat:false RepeatTimes:0 Procs:1 Slowdown:1
Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false
Fault:false FaultCall:0 FaultNth:0}}
r0 = syz_io_uring_setup(0x481a, &(0x7f0000003ac0)={0x0, 0x0, 0x2},
&(0x7f0000003b40), &(0x7f0000003b80))
io_uring_register$IORING_REGISTER_IOWQ_AFF(r0, 0x21,
&(0x7f00000025c0)="fc", 0x1)
io_uring_enter(r0, 0x2751, 0x1737, 0x5, 0x0, 0x0)
io_uring_register$IORING_REGISTER_IOWQ_AFF(r0, 0x21,
&(0x7f00000025c0)="fc", 0x1)


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <errno.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include <linux/futex.h>

#ifndef __NR_io_uring_enter
#define __NR_io_uring_enter 426
#endif
#ifndef __NR_io_uring_register
#define __NR_io_uring_register 427
#endif
#ifndef __NR_io_uring_setup
#define __NR_io_uring_setup 425
#endif

static void sleep_ms(uint64_t ms)
{
  usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC, &ts))
    exit(1);
  return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void thread_start(void* (*fn)(void*), void* arg)
{
  pthread_t th;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setstacksize(&attr, 128 << 10);
  int i = 0;
  for (; i < 100; i++) {
    if (pthread_create(&th, &attr, fn, arg) == 0) {
      pthread_attr_destroy(&attr);
      return;
    }
    if (errno == EAGAIN) {
      usleep(50);
      continue;
    }
    break;
  }
  exit(1);
}

typedef struct {
  int state;
} event_t;

static void event_init(event_t* ev)
{
  ev->state = 0;
}

static void event_reset(event_t* ev)
{
  ev->state = 0;
}

static void event_set(event_t* ev)
{
  if (ev->state)
    exit(1);
  __atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
  syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG, 1000000);
}

static void event_wait(event_t* ev)
{
  while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
}

static int event_isset(event_t* ev)
{
  return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
  uint64_t start = current_time_ms();
  uint64_t now = start;
  for (;;) {
    uint64_t remain = timeout - (now - start);
    struct timespec ts;
    ts.tv_sec = remain / 1000;
    ts.tv_nsec = (remain % 1000) * 1000 * 1000;
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
    if (__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
      return 1;
    now = current_time_ms();
    if (now - start > timeout)
      return 0;
  }
}

#define SIZEOF_IO_URING_SQE 64
#define SIZEOF_IO_URING_CQE 16
#define SQ_HEAD_OFFSET 0
#define SQ_TAIL_OFFSET 64
#define SQ_RING_MASK_OFFSET 256
#define SQ_RING_ENTRIES_OFFSET 264
#define SQ_FLAGS_OFFSET 276
#define SQ_DROPPED_OFFSET 272
#define CQ_HEAD_OFFSET 128
#define CQ_TAIL_OFFSET 192
#define CQ_RING_MASK_OFFSET 260
#define CQ_RING_ENTRIES_OFFSET 268
#define CQ_RING_OVERFLOW_OFFSET 284
#define CQ_FLAGS_OFFSET 280
#define CQ_CQES_OFFSET 320

struct io_sqring_offsets {
  uint32_t head;
  uint32_t tail;
  uint32_t ring_mask;
  uint32_t ring_entries;
  uint32_t flags;
  uint32_t dropped;
  uint32_t array;
  uint32_t resv1;
  uint64_t resv2;
};

struct io_cqring_offsets {
  uint32_t head;
  uint32_t tail;
  uint32_t ring_mask;
  uint32_t ring_entries;
  uint32_t overflow;
  uint32_t cqes;
  uint64_t resv[2];
};

struct io_uring_params {
  uint32_t sq_entries;
  uint32_t cq_entries;
  uint32_t flags;
  uint32_t sq_thread_cpu;
  uint32_t sq_thread_idle;
  uint32_t features;
  uint32_t resv[4];
  struct io_sqring_offsets sq_off;
  struct io_cqring_offsets cq_off;
};

#define IORING_OFF_SQ_RING 0
#define IORING_OFF_SQES 0x10000000ULL
#define IORING_SETUP_SQE128 (1U << 10)
#define IORING_SETUP_CQE32 (1U << 11)

static long syz_io_uring_setup(volatile long a0, volatile long a1,
                               volatile long a2, volatile long a3)
{
  uint32_t entries = (uint32_t)a0;
  struct io_uring_params* setup_params = (struct io_uring_params*)a1;
  void** ring_ptr_out = (void**)a2;
  void** sqes_ptr_out = (void**)a3;
  setup_params->flags &= ~(IORING_SETUP_CQE32 | IORING_SETUP_SQE128);
  uint32_t fd_io_uring = syscall(__NR_io_uring_setup, entries, setup_params);
  uint32_t sq_ring_sz =
      setup_params->sq_off.array + setup_params->sq_entries * sizeof(uint32_t);
  uint32_t cq_ring_sz = setup_params->cq_off.cqes +
                        setup_params->cq_entries * SIZEOF_IO_URING_CQE;
  uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
  *ring_ptr_out =
      mmap(0, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
           fd_io_uring, IORING_OFF_SQ_RING);
  uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
  *sqes_ptr_out = mmap(0, sqes_sz, PROT_READ | PROT_WRITE,
                       MAP_SHARED | MAP_POPULATE, fd_io_uring, IORING_OFF_SQES);
  uint32_t* array =
      (uint32_t*)((uintptr_t)*ring_ptr_out + setup_params->sq_off.array);
  for (uint32_t index = 0; index < entries; index++)
    array[index] = index;
  return fd_io_uring;
}

struct thread_t {
  int created, call;
  event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
  struct thread_t* th = (struct thread_t*)arg;
  for (;;) {
    event_wait(&th->ready);
    event_reset(&th->ready);
    execute_call(th->call);
    __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
    event_set(&th->done);
  }
  return 0;
}

static void loop(void)
{
  int i, call, thread;
  for (call = 0; call < 4; call++) {
    for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
         thread++) {
      struct thread_t* th = &threads[thread];
      if (!th->created) {
        th->created = 1;
        event_init(&th->ready);
        event_init(&th->done);
        event_set(&th->done);
        thread_start(thr, th);
      }
      if (!event_isset(&th->done))
        continue;
      event_reset(&th->done);
      th->call = call;
      __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
      event_set(&th->ready);
      event_timedwait(&th->done, 50);
      break;
    }
  }
  for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
    sleep_ms(1);
}

uint64_t r[1] = {0xffffffffffffffff};

void execute_call(int call)
{
  intptr_t res = 0;
  switch (call) {
  case 0:
    *(uint32_t*)0x20003ac4 = 0;
    *(uint32_t*)0x20003ac8 = 2;
    *(uint32_t*)0x20003acc = 0;
    *(uint32_t*)0x20003ad0 = 0;
    *(uint32_t*)0x20003ad8 = -1;
    memset((void*)0x20003adc, 0, 12);
    res = -1;
    res = syz_io_uring_setup(/*entries=*/0x481a, /*params=*/0x20003ac0,
                             /*ring_ptr=*/0x20003b40, /*sqes_ptr=*/0x20003b80);
    if (res != -1)
      r[0] = res;
    break;
  case 1:
    memset((void*)0x200025c0, 252, 1);
    syscall(__NR_io_uring_register, /*fd=*/r[0], /*opcode=*/0x21ul,
            /*arg=*/0x200025c0ul, /*size=*/1ul);
    break;
  case 2:
    syscall(__NR_io_uring_enter, /*fd=*/r[0], /*to_submit=*/0x2751,
            /*min_complete=*/0x1737,
            /*flags=IORING_ENTER_SQ_WAIT|IORING_ENTER_GETEVENTS*/ 5ul,
            /*sigmask=*/0ul, /*size=*/0ul);
    break;
  case 3:
    memset((void*)0x200025c0, 252, 1);
    syscall(__NR_io_uring_register, /*fd=*/r[0], /*opcode=*/0x21ul,
            /*arg=*/0x200025c0ul, /*size=*/1ul);
    break;
  }
}
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
  loop();
  return 0;
}


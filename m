Return-Path: <io-uring+bounces-5314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FFF09E933D
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120FA160745
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 12:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276A419882F;
	Mon,  9 Dec 2024 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMRHNK/L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185CA22C6F7;
	Mon,  9 Dec 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733745830; cv=none; b=HYEH2yZbYpX44SvcNI/UImxT/HEW6Wp0kdLTD0fJKacvqnVaMhwq8PeFVVY/C51s7I23BKKTuAnD23gC0UUvibgeGzvhqdF3d8D5fJMzFLFjlij3BlCgStH0TitMdewPqS5bb9n4OPuOElFfMvzYBBJycbg9P2DY1UTWBb/J3m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733745830; c=relaxed/simple;
	bh=wRRO6+P7uyeSxqb4z+B3QHCj2c3fiiWgUdVD7UiJcIw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=uaOx/+mrSC0lppmYJMR76dUzkScN9E/jPBBC28TKwr8Y2jqx9YegrH6mc3sOXXsQX3jdqu3bo2nozot7+wwdGSNNYPbP3VhnkeFzmXl9QWn0mEZ1fNVe9O5XDLsWYPLc+duC86cJ2kRgVNOAAqaiWzlvOiWl7IvF9YIUiijh18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMRHNK/L; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e3983fe3aadso4149617276.2;
        Mon, 09 Dec 2024 04:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733745826; x=1734350626; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WIYJjwauVTJGbhqWii4XI0J2u4dUNtRFNKiNzf6uG5Q=;
        b=eMRHNK/LJ4vKG8DEleW1piLDv5ifbhcx76b/+7li7YzdA6xeMwlj7JeI5kxh0RMebL
         snHmSwGOYnDU9jEbsT85F5sKbMr63PcevF0macBEkuK52TtY8cV0XEElMHanRNTevIQ6
         fcgdFE3WlbZwdm477BjgypvI3Op3W8i71n+c5TCZHkyVH2NbNPQvfewYjy/W2WzX9Vbp
         NskFq6pl3LXEv7e0X8s5XwHRSlFCQ3OvN2SUpvYQKwDOd7pn6M8TJlOKBLBpcGdMmLXJ
         jnQbOMe5YK4eolA5WtuLRjPAk3Sj+HbexlnkOZE0afgpHSqahXVzx5NaJPZZfK6L2KMw
         2rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733745826; x=1734350626;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WIYJjwauVTJGbhqWii4XI0J2u4dUNtRFNKiNzf6uG5Q=;
        b=dIMRcwh6nCCbmWqa6aGOJXUPiyDaNiuq/CuJjUjkCBRoWV7KmniRLyK16g9YjuRu0v
         ipPJntLBmWTOzmioUgloeOUnMuf6Lvo2jLjOd0gkwP5yWjYvJnNQVfLzTBKQ07hUOmAh
         sz9KseS6zaHYONx0I8jEsl2iFGngiCQLdfCnV0S4VGKoQSWitcM4VC1nTeG2QDNwj9lQ
         aiSlmdwYgLlXXXmnJYv8dcxaBQOWXyyat47vP/VCMdCraESleYVRc0sgAYLh7e/of7Nb
         xl8a95XBG4l9+jhMEeMSta8og9zbWAofaXAXr0oYFBGK+3qKmxXkAsmwU3RovlaN5a79
         AGhw==
X-Forwarded-Encrypted: i=1; AJvYcCU7aPjyMinu28AZ1ptpS5U1kPRJGZUtevdKZ+nREXC4LhVQJw65vUCyAkprCYgmh35BXQSYhBXYeA==@vger.kernel.org, AJvYcCWvVTIIkWrDHUubDsXtb1irKoAHIdeQh9kiqzLqDfH5i74e8sHQZ2grxxuNyWtOt8xqEW+xpomw4IICjUP3@vger.kernel.org
X-Gm-Message-State: AOJu0YxrK9IXp6bhbcIK8RpepXifiF91ugejJkAXnmv9sQvqyRN/3a4h
	eBqz5Hb5LPVdQ3kvRCo/Yebt57/gcpKY0549ReTR1UE5MrVBaZK+lleioPZJrKaOMHBSjzNlxUM
	lB/kLzJDJAqAhStkiJyX1j0wGuiQFMtov
X-Gm-Gg: ASbGnctoiA/2OVEJMoQXhTQWzTp3U7ZFJ/qsAQ9WIYXul6qrWBT/XjduWKgg/TOY0du
	sZANmO6s99JRfztEpPyGKe+wr4Jx6Slliy9b6GwEzg2ybYaai34UqDYtWvOIbakrebuWUcA==
X-Google-Smtp-Source: AGHT+IFXqpAel2wTG0YN9R0ezT4qw8q8RVZZXpDvEjH+3dDKdtT78JQheo5ASP2e04elyoJS7cpdaj4hNFCkdAm7Lok=
X-Received: by 2002:a05:6902:2787:b0:e39:7347:6d76 with SMTP id
 3f1490d57ef6-e3a0b0caf31mr10297745276.19.1733745826040; Mon, 09 Dec 2024
 04:03:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chase xd <sl1589472800@gmail.com>
Date: Mon, 9 Dec 2024 13:03:35 +0100
Message-ID: <CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com>
Subject: possible deadlock in __wake_up_common_lock
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, Syzkaller reports this on lts 6.1.119, looks like a new bug:

Syzkaller hit 'possible deadlock in __wake_up_common_lock' bug.

============================================
WARNING: possible recursive locking detected
6.1.119-dirty #3 Not tainted
--------------------------------------------
syz-executor199/6820 is trying to acquire lock:
ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
__wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137

but task is already holding lock:
ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
__wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ctx->cq_wait);
  lock(&ctx->cq_wait);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor199/6820:
 #0: ffff88807c3860a8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__do_sys_io_uring_enter+0x8fc/0x2130 io_uring/io_uring.c:3313
 #1: ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
__wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137

stack backtrace:
CPU: 7 PID: 6820 Comm: syz-executor199 Not tainted 6.1.119-dirty #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x5b/0x85 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2983 [inline]
 check_deadlock kernel/locking/lockdep.c:3026 [inline]
 validate_chain kernel/locking/lockdep.c:3812 [inline]
 __lock_acquire.cold+0x219/0x3bd kernel/locking/lockdep.c:5049
 lock_acquire kernel/locking/lockdep.c:5662 [inline]
 lock_acquire+0x1e3/0x5e0 kernel/locking/lockdep.c:5627
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
 __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
 __io_cqring_wake io_uring/io_uring.h:224 [inline]
 __io_cqring_wake io_uring/io_uring.h:211 [inline]
 io_req_local_work_add io_uring/io_uring.c:1135 [inline]
 __io_req_task_work_add+0x4a4/0xd60 io_uring/io_uring.c:1146
 io_poll_wake+0x3cb/0x550 io_uring/poll.c:465
 __wake_up_common+0x14c/0x650 kernel/sched/wait.c:107
 __wake_up_common_lock+0xd4/0x140 kernel/sched/wait.c:138
 __io_cqring_wake io_uring/io_uring.h:224 [inline]
 __io_cqring_wake io_uring/io_uring.h:211 [inline]
 io_cqring_wake io_uring/io_uring.h:231 [inline]
 io_cqring_ev_posted io_uring/io_uring.c:578 [inline]
 __io_cq_unlock_post io_uring/io_uring.c:586 [inline]
 __io_submit_flush_completions+0x778/0xba0 io_uring/io_uring.c:1346
 io_submit_flush_completions io_uring/io_uring.c:159 [inline]
 io_submit_state_end io_uring/io_uring.c:2203 [inline]
 io_submit_sqes+0xa78/0x1ce0 io_uring/io_uring.c:2317
 __do_sys_io_uring_enter+0x907/0x2130 io_uring/io_uring.c:3314
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
RIP: 0033:0x7fa54e70640d
Code: 28 c3 e8 46 1e 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd0ad80be8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007ffd0ad80df8 RCX: 00007fa54e70640d
RDX: 0000000000000000 RSI: 000000000000331b RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffd0ad80de8 R14: 00007fa54e783530 R15: 0000000000000001
 </TASK>


Syzkaller reproducer:
# {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1
Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false
Fault:false FaultCall:0 FaultNth:0}}
r0 = syz_io_uring_setup(0x100, &(0x7f0000000000)={0x0, 0x0, 0x3a40},
&(0x7f0000000180)=<r1=>0x0, &(0x7f00000001c0)=<r2=>0x0)
syz_io_uring_setup(0x255d, &(0x7f00000001c0)={0x0, 0x0, 0x40, 0x0,
0x3, 0x0, r0}, &(0x7f0000000140), &(0x7f00000024c0)=<r3=>0x0)
syz_io_uring_submit(r1, r3, &(0x7f00000000c0)=@IORING_OP_SEND={0x1a,
0x0, 0x0, 0xffffffffffffffff, 0x0, 0x0})
io_uring_register$IORING_REGISTER_ENABLE_RINGS(r0, 0xc, 0x0, 0x0)
syz_io_uring_submit(r1, r2,
&(0x7f0000000100)=@IORING_OP_READV=@use_registered_buffer={0x1, 0x0,
0x0, @fd=r0})
syz_io_uring_submit(r1, r2,
&(0x7f0000000100)=@IORING_OP_READV=@use_registered_buffer={0x1, 0x0,
0x0, @fd=r0})
io_uring_enter(r0, 0x331b, 0x0, 0x0, 0x0, 0x0)


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef __NR_io_uring_enter
#define __NR_io_uring_enter 426
#endif
#ifndef __NR_io_uring_register
#define __NR_io_uring_register 427
#endif
#ifndef __NR_io_uring_setup
#define __NR_io_uring_setup 425
#endif

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

static long syz_io_uring_submit(volatile long a0, volatile long a1,
                                volatile long a2)
{
  char* ring_ptr = (char*)a0;
  char* sqes_ptr = (char*)a1;
  char* sqe = (char*)a2;
  uint32_t sq_ring_mask = *(uint32_t*)(ring_ptr + SQ_RING_MASK_OFFSET);
  uint32_t* sq_tail_ptr = (uint32_t*)(ring_ptr + SQ_TAIL_OFFSET);
  uint32_t sq_tail = *sq_tail_ptr & sq_ring_mask;
  char* sqe_dest = sqes_ptr + sq_tail * SIZEOF_IO_URING_SQE;
  memcpy(sqe_dest, sqe, SIZEOF_IO_URING_SQE);
  uint32_t sq_tail_next = *sq_tail_ptr + 1;
  __atomic_store_n(sq_tail_ptr, sq_tail_next, __ATOMIC_RELEASE);
  return 0;
}

uint64_t r[4] = {0xffffffffffffffff, 0x0, 0x0, 0x0};

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
  intptr_t res = 0;
  *(uint32_t*)0x20000004 = 0;
  *(uint32_t*)0x20000008 = 0x3a40;
  *(uint32_t*)0x2000000c = 0;
  *(uint32_t*)0x20000010 = 0;
  *(uint32_t*)0x20000018 = -1;
  memset((void*)0x2000001c, 0, 12);
  res = -1;
  res = syz_io_uring_setup(/*entries=*/0x100, /*params=*/0x20000000,
                           /*ring_ptr=*/0x20000180, /*sqes_ptr=*/0x200001c0);
  if (res != -1) {
    r[0] = res;
    r[1] = *(uint64_t*)0x20000180;
    r[2] = *(uint64_t*)0x200001c0;
  }
  *(uint32_t*)0x200001c4 = 0;
  *(uint32_t*)0x200001c8 = 0x40;
  *(uint32_t*)0x200001cc = 0;
  *(uint32_t*)0x200001d0 = 3;
  *(uint32_t*)0x200001d8 = r[0];
  memset((void*)0x200001dc, 0, 12);
  res = -1;
  res = syz_io_uring_setup(/*entries=*/0x255d, /*params=*/0x200001c0,
                           /*ring_ptr=*/0x20000140, /*sqes_ptr=*/0x200024c0);
  if (res != -1)
    r[3] = *(uint64_t*)0x200024c0;
  *(uint8_t*)0x200000c0 = 0x1a;
  *(uint8_t*)0x200000c1 = 0;
  *(uint16_t*)0x200000c2 = 0;
  *(uint32_t*)0x200000c4 = -1;
  *(uint64_t*)0x200000c8 = 0;
  *(uint64_t*)0x200000d0 = 0;
  *(uint32_t*)0x200000d8 = 0;
  *(uint32_t*)0x200000dc = 0;
  *(uint64_t*)0x200000e0 = 0;
  *(uint16_t*)0x200000e8 = 0;
  *(uint16_t*)0x200000ea = 0;
  memset((void*)0x200000ec, 0, 20);
  syz_io_uring_submit(/*ring_ptr=*/r[1], /*sqes_ptr=*/r[3], /*sqe=*/0x200000c0);
  syscall(__NR_io_uring_register, /*fd=*/r[0], /*opcode=*/0xcul, /*arg=*/0ul,
          /*nr_args=*/0ul);
  *(uint8_t*)0x20000100 = 1;
  *(uint8_t*)0x20000101 = 0;
  *(uint16_t*)0x20000102 = 0;
  *(uint32_t*)0x20000104 = r[0];
  *(uint64_t*)0x20000108 = 0;
  *(uint64_t*)0x20000110 = 0;
  *(uint32_t*)0x20000118 = 0;
  *(uint32_t*)0x2000011c = 0;
  *(uint64_t*)0x20000120 = 0;
  *(uint16_t*)0x20000128 = 0;
  *(uint16_t*)0x2000012a = 0;
  memset((void*)0x2000012c, 0, 20);
  syz_io_uring_submit(/*ring_ptr=*/r[1], /*sqes_ptr=*/r[2], /*sqe=*/0x20000100);
  *(uint8_t*)0x20000100 = 1;
  *(uint8_t*)0x20000101 = 0;
  *(uint16_t*)0x20000102 = 0;
  *(uint32_t*)0x20000104 = r[0];
  *(uint64_t*)0x20000108 = 0;
  *(uint64_t*)0x20000110 = 0;
  *(uint32_t*)0x20000118 = 0;
  *(uint32_t*)0x2000011c = 0;
  *(uint64_t*)0x20000120 = 0;
  *(uint16_t*)0x20000128 = 0;
  *(uint16_t*)0x2000012a = 0;
  memset((void*)0x2000012c, 0, 20);
  syz_io_uring_submit(/*ring_ptr=*/r[1], /*sqes_ptr=*/r[2], /*sqe=*/0x20000100);
  syscall(__NR_io_uring_enter, /*fd=*/r[0], /*to_submit=*/0x331b,
          /*min_complete=*/0, /*flags=*/0ul, /*sigmask=*/0ul, /*size=*/0ul);
  return 0;
}


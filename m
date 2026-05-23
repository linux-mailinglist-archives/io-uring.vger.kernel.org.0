Return-Path: <io-uring+bounces-13483-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NsbaFQKXEWoIoAYAu9opvQ
	(envelope-from <io-uring+bounces-13483-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:01:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E56A5BECD6
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5104130015BF
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 12:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6EC388E57;
	Sat, 23 May 2026 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jg2WMX5a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7B3803F1
	for <io-uring@vger.kernel.org>; Sat, 23 May 2026 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779537660; cv=pass; b=W6Bm+kP/7FvPlfDGWhgVgrgMteOyHB+NJncwEmdRFnGBGMLYOHW+Yb0wPK6SYtBx+0/dG01T7+cUL5IssWdXGUkSDjia/TkPVuaAtD2kEpmyiTeUZJtWkwgdr2XJJ7+RTreh+OJZrb1WEIiTMa8AxGmRVC313+5bRNDVhYt4nKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779537660; c=relaxed/simple;
	bh=oI58T8+0y049M0YCV9rRi1+FsH1R7GKiU3Qjyl7HBMg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=No1qRv2He0+B/N35X3sIVppG3kTtSRBNVvMIBhBbfTuvx0d0Sb6EsOy8ZZ1ype2RsNaQWjKNmHcplCRXTdX+FZ3E1WqwOEkVzKWC8mxcQmAkB1E0tjCyEG8dN/hh1rucFzzzfgEFP7yldDbDX3VjAfUhBTgPTi+TMByoi3XDbj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jg2WMX5a; arc=pass smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-57513ac61f0so2601768e0c.3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2026 05:00:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779537657; cv=none;
        d=google.com; s=arc-20240605;
        b=cnxq84OpQjHIb7pvqQtig2yA8a5/4BZUCNv7oU8KNFrxkma19MimfYLYjlcXds9+nL
         OeUcxzmL7V3JbvRdhRgwyTvaQzyQOr829juIZJy7Hxyx1+9Wt2byu6zgVDTpvLs0BZWm
         hZt4eWgIkhW6YHSBiwuPHtuzqIvinnJHeu92HAlwqFTeb+P2sYHScqUXJQhaVUl6AE2p
         PpWc9wCACmgPVNf242WT+5AV68nW+PyODCQOy3MoVUSe0EzsdkAAIb0JMn5Hn3On296o
         gFAM5yjSnh6k+JTpauQk4LakupMjU8XbpYQftTlY5H3l4xsZlCN8nO9BYQtvp12BdxmT
         mSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=r5leke5fx6/WWwNzEYKwN0iuJUGvP6oy0002qUmBQPA=;
        fh=idzk5Dr+ApQ8TEH6aUIB3iEAqiPcZ35vqDuKckUKuB8=;
        b=OEPMSxBcQo7GyEjnFX/vIdqjP3T+MUYcru+Y32RKNvrrzATeyPPF58uNdvw/LHk5PJ
         uRqj9Dc18KqPxcAMPtxJQfVO1MsSbH0kMK5L9nN4U0X0D2gxNOwh4K+Z+/Pg83XlVTUs
         l1zMk38hUNVwY62YIZVeUdc5dRs8ejeucz0Ia8vwrTiDv3vjd2HFKUdqChZu2bYLq9+j
         fyF1LUfyuldx2v1J+FeE6+kECAgllD9Tucx68Arh5E5caoFskDj+Ghfx5Vdwza+AZL/p
         Ub4V3toqm/Lz/qZfpPaL5Y93UZAkQ1B/ag8kOOTa6QKbKI9T7F0OZ8vhc4lzd/doLdJ0
         KNug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779537657; x=1780142457; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r5leke5fx6/WWwNzEYKwN0iuJUGvP6oy0002qUmBQPA=;
        b=Jg2WMX5aMQ7uR9pGF14r3y+V3meKEqyPHUykXqp4f9/T1JVzyrarMokh5kJ/vPGw9G
         mvZl0SECELoqNd+BSGw9WBPRUWp6AeTW5gwoWSGHY5x5kFDuIWpYyoYX5J4kRqUSmhOJ
         Y8RzJE+PeG01V4ydTAWD7hJ5btz8ESubd2ozPt8l/wGOBI9tfISRwj6IbkPlkz4+epdI
         SEkHoMPg8hqykXHauYOnEqFKXKGuLQHSVTggA4ao8mr056hnH29kEomEiL03Ec4oULg7
         urYClSUZj+AlL+yPGRnRUFpBE9m57YjncUnkvOShlrvqACFxAGtPWe131EDUSpSCF3eW
         osfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779537657; x=1780142457;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5leke5fx6/WWwNzEYKwN0iuJUGvP6oy0002qUmBQPA=;
        b=Ca6goomcNu0cx82FBo7uMvMR3bSa39EhQv1AR7t0BB0XsWCagJJpDBkSd7Z916QuUf
         Bf5Z73NsZvqo6ORpFZ0wSA/S/J+U4qqyQrHDAhU0eZtKGfJQVGN5lW12CxO+HrriprX+
         xrYdn76OdtFfD/pOLBLJuEP+mmdeVMym/gGXBlGLrYhRpJ3FGfEszgx5A5NMutGl7qSu
         03m7jqXpWzfcPKooxuUS6X2fZp+pUBkyy93wwHCHs8nMH16++v95fI4G7akXx3aaMfTP
         gqBlezNMNg9Hpg1PqYE90/c2xjadhYZkEW1B3KF8fpb+Tj7hCXLiO26vbjbgh9BnTgsN
         GOkA==
X-Gm-Message-State: AOJu0YwWjxAvRyb/kHCg0nozXOit1gq3Ibp8XjBBhPZk/smAafDACtpd
	T+huIHRiwnm1x2kL6VhmpBlJU1xWtXAVlVyL0wEylbWnDBoqCRnduNOd3skyfr5UqTQLl98TRgO
	4JvWzSiNE782kznwSTJp+SpCch++Xj2w6+Cuz
X-Gm-Gg: Acq92OFhKAJXH26zNWe06I+JcZaEzmeGQRY4D34NiBuCWAikC56EtOzlFBDu3d9rqzI
	FuCCKdQa2Axr26Uq4n8nZKBF+AVle3F+T9YuknwZbdLjrOWtaLD6e4wJ6x4xCaLlJLEpyl6S+ld
	MqnKvBUw0XJH2FT/7oRHTbY+GfogdrNlliaP+7EHVYbVlpI1f/u+sMx+EepbTt51ZtN92Hw11iW
	iATNbR0pgJFtNKJsvQb0DcdyJDkX1fIJRaM4KK6ximIeNIFl7dYFLHMQBVJ++FfpSvEaoG8lC32
	gfuWrDqZlli32zpm
X-Received: by 2002:a05:6102:32d5:b0:631:3740:7d61 with SMTP id
 ada2fe7eead31-67c8a07640emr3789743137.17.1779537656764; Sat, 23 May 2026
 05:00:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?7Iuc66as7Ja8?= <shja0831@gmail.com>
Date: Sat, 23 May 2026 21:00:45 +0900
X-Gm-Features: AVHnY4L8DK3c-dpIQCBjDlOZyeOo2pBT32BXhI81aqyELT7LzMp7lYt74TqbrJQ
Message-ID: <CACR30Wj7yEweYqJg4Ovrbr4s9a8EZRYD8FMAWhjWUv3XunrMFQ@mail.gmail.com>
Subject: [bug] io_uring : NULL pointer deref in io_register_iowq_max_workers()
To: io-uring@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13483-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shja0831@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3E56A5BECD6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Frist I'm not good at English, so my grammar might be weird.
and i use translator so It may not look natural.

I found NULL-pointer dereference (general protection fault under
KASAN) in io_register_iowq_max_workers() on 7.1.0-rc1. It is a race
between the IORING_REGISTER_IOWQ_MAX_WORKERS propagation loop and a
task installing its first io_uring task context (tctx) node on a
shared ring. A small multithreaded reproducer triggers it reliably.

syzkaller log:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000003: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 230570 Comm: syz.1.42039 Not tainted 7.1.0-rc1 #1
PREEMPT(full)
Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
RIP: 0010:io_register_iowq_max_workers io_uring/register.c:423 [inline]
RIP: 0010:__io_uring_register io_uring/register.c:865 [inline]
RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c:1=
029
Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005ea81000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xff/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff8543b85fd
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff8525edff8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007ff854645fa0 RCX: 00007ff8543b85fd
RDX: 0000200000000040 RSI: 0000000000000013 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdb063f3d0 R14: 00007ff8525eece4 R15: 00007ffdb063f4c7
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:io_register_iowq_max_workers io_uring/register.c:423 [inline]
RIP: 0010:__io_uring_register io_uring/register.c:865 [inline]
RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c:1=
029
Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1280e130b0 CR3: 000000005ea81000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0: bd 68 09 00 00       mov    $0x968,%ebp
   5: 48 89 fa             mov    %rdi,%rdx
   8: 48 c1 ea 03           shr    $0x3,%rdx
   c: 42 80 3c 2a 00       cmpb   $0x0,(%rdx,%r13,1)
  11: 74 05                 je     0x18
  13: e8 06 3a 40 01       call   0x1403a1e
  18: 48 8b ad 68 09 00 00 mov    0x968(%rbp),%rbp
  1f: 48 8d 7d 18           lea    0x18(%rbp),%rdi
  23: 48 89 fa             mov    %rdi,%rdx
  26: 48 c1 ea 03           shr    $0x3,%rdx
* 2a: 42 80 3c 2a 00       cmpb   $0x0,(%rdx,%r13,1) <-- trapping instructi=
on
  2f: 74 05                 je     0x36
  31: e8 e8 39 40 01       call   0x1403a1e
  36: 48 8b 6d 18           mov    0x18(%rbp),%rbp
  3a: 48 85 ed             test   %rbp,%rbp
  3d: 0f                   .byte 0xf
  3e: 85 ec                 test   %ebp,%esp


<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

This bug is in io_register_iowq_max_workers()

mutex_lock(&ctx->tctx_lock);
list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
    tctx =3D node->task->io_uring;
    if (WARN_ON_ONCE(!tctx->io_wq)) // derefs tctx without NULL check
        continue;
    // skip
}

propagates the limit to all registered users (non-SQPOLL path)

The node is published into ctx->tctx_list before node->task->io_uring
is set (io_uring/tctx.c):

io_tctx_install_node():
    node->task =3D current;
    mutex_lock(&ctx->tctx_lock);
    list_add(&node->ctx_node, &ctx->tctx_list);   // node visible
    mutex_unlock(&ctx->tctx_lock); // lock dropped

__io_uring_add_tctx_node():
    ret =3D io_tctx_install_node(ctx, tctx);
    if (!ret)
        current->io_uring =3D tctx;   // set AFTER, outside lock

There is a window where a node is on ctx->tctx_list while
node->task->io_uring is still NULL (the task is doing its first
io_uring op, tctx freshly allocated, not yet published). A concurrent
IORING_REGISTER_IOWQ_MAX_WORKERS on the same ring takes
ctx->tctx_lock, iterates, reads node->task->io_uring =3D=3D NULL, and
dereferences tctx->io_wq =E2=86=92 GPF.

The other two ctx->tctx_list consumers already guard this =E2=80=94 cancel.=
c
io_async_cancel_one() and io_uring_try_cancel_iowq() both do if (!tctx
|| !tctx->io_wq). io_register_iowq_max_workers() is the only consumer
that omits the !tctx check, so this is simply a missing guard.

Reproducer

Plain (non-SQPOLL) ring shared across threads. A stream of fresh
threads each do their first io_uring_enter() (hits the window) while
two threads spam IORING_REGISTER_IOWQ_MAX_WORKERS. GPFs within
seconds-to-minutes on SMP+KASAN.

#define _GNU_SOURCE
#include <pthread.h>
#include <string.h>
#include <sys/syscall.h>
#include <linux/io_uring.h>
static int ring_fd;
static long setup(unsigned e, struct io_uring_params *p){ return
syscall(__NR_io_uring_setup, e, p); }
static long enter(int fd, unsigned ts){ return
syscall(__NR_io_uring_enter, fd, ts, 0, 0, (void*)0, (size_t)0); }
static long reg(int fd, unsigned op, void *a, unsigned n){ return
syscall(__NR_io_uring_register, fd, op, a, n); }
static void *fresh(void *x){ enter(ring_fd, 1); return 0; }   // first
op -> window
static void *spam(void *x){ unsigned c[2]=3D{1,1}; for(;;) reg(ring_fd,
IORING_REGISTER_IOWQ_MAX_WORKERS, c, 2); return 0; }
int main(void){
    struct io_uring_params p; memset(&p,0,sizeof(p));
    ring_fd =3D setup(8, &p);
    pthread_t s; pthread_create(&s,0,spam,0); pthread_create(&s,0,spam,0);
    for(;;){ pthread_t t[64];
        for(int i=3D0;i<64;i++) pthread_create(&t[i],0,fresh,0);
        for(int i=3D0;i<64;i++) pthread_join(t[i],0); }
}

Reproduced on 7.1.0-rc1 with KASAN; the racy ordering predates the
2024 shadow-variable cleanup that last touched register.c:422.

Suggested fix

Either make io_register_iowq_max_workers() match its siblings:

before:

mutex_lock(&ctx->tctx_lock);
list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
    tctx =3D node->task->io_uring;
    if (WARN_ON_ONCE(!tctx->io_wq)) // derefs tctx without NULL check
        continue;
    // skip
}

to:

mutex_lock(&ctx->tctx_lock);
list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
    tctx =3D node->task->io_uring;
    if (!tctx || !tctx->io_wq)
        continue;
    // skip
}

or close the window in __io_uring_add_tctx_node() by publishing
current->io_uring =3D tctx before the node is added to ctx->tctx_list,
so a listed node always has a valid task->io_uring.


LimHyeonJun


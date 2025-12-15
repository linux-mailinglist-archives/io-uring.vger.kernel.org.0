Return-Path: <io-uring+bounces-11045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E34CBF3DE
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 18:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40FCA30054B9
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 17:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E00632F74A;
	Mon, 15 Dec 2025 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dCcDgO1m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2816231AAA6
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819662; cv=none; b=SyFAmIWLHNnd5Ocxjesvp7MqzkgT3vf88jhpk0rwpTVWCUg2HM73q6hShjFEjWUcD6JaUaczDJnGJ1yFIQU6QiglJn13+HWViH3s69IA6P9nyqUvThMY2nxB4yIkJsq4JUJqRhVDhDoQi/gw7vE+feC1P+nXFdN3xvPwZOFJKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819662; c=relaxed/simple;
	bh=oshMnrgZLF2L/OdQ4r/3GgVbWK+AK1/YD0RFlUOOJBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwix5ehTujlbBQ8hKVjpUifMOn2VkIdJwT2vHfadseAslk1ejCzLRovVxj/ebAkpwBmPTf3IWdacJfAU2pLY0qwxBhVkSPch0m/lkhXtb+C58NHS7/SxrxO98x4uiHPbfa60Ch7TfQzO4//0cFx7fjA4g1e7Tf+whjJhMEWJ6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dCcDgO1m; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7f6bc8a4787so201211b3a.3
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 09:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765819659; x=1766424459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VO5EohEvqtgfnYmUR6NyASsJ49iK3hRAkxUWOA9dRII=;
        b=dCcDgO1mYAxNyFGbujjR83iyX6aZ0fhq41K1qq1vi+ZNRb+ufNi9c+IGshu8GB2lJZ
         l1ibRfJDqwTVjvC0Cp5r0Gc7x9ILkVUtVVuXsVNL4C2vY92jOVbYE2JraEUqYBl/HcQl
         YsWm+865FnBZweVzMGHLJI2M6uaeINMPENpU3rR1xFnlPGb0W87VzhPZrXTnqloRA7tU
         8kY1fltz+/VDyXKk5AKFgxbJDE9CwG0vnsbYjRmK8OCyFJNxmCSeJ0eGNCqfcnYWmg0Z
         x9fefwyUsxAyBLCGrb+GiFBYhEpyhdDRlT0FWjfM09ACBoLlDzQAp2UkIDyu9Y37Zmda
         b0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765819659; x=1766424459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VO5EohEvqtgfnYmUR6NyASsJ49iK3hRAkxUWOA9dRII=;
        b=sWdg0/S52DPISCZOXBuH9rC2vmTneyVKZZU08MjmOLV9bf2H+ydygnMsS4c0jbEuZX
         eypaFcFWriHPmo1CFDcR7SUKW1/MVMc3+gzTrrhL3Pxwo3hReTc9U1+PpCCSj7TBF8Rd
         57yTZjep1eWk+DpAKkJa0JhuSygqzTWhMPJIlCOzNslT+llR7p1bnIGsM5E/KWLI2iWF
         qSAMVpaQnXEqSXqarJw8hJRUM3izasNPIIaf9dSorQA3wvna9mwh6PMWV0Yci9LyudN2
         +uRYm6fkNtUAFiBdInDqAKWtvIurE/rd/AHIUKdbUdFlAVpOpHtoEMuh2nN2MhP+NeJe
         t2IA==
X-Forwarded-Encrypted: i=1; AJvYcCWOiG3uyR49q+Ed++fK1So1yfy7a+DGcm9LxMrKAeNv+a1UHVB8lAZcluTqFhRmkpFj/hwMw+3NUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSr1Tg3tuEC8dTu4m6LwfT2iDuVc0y9VXjGGHy1ysWOWjSNmG/
	EWznEUj5emQMfhDCKihnvoJDUIXGnWlL8Acv43CyGUiozwoBfVoK1TmV8aJTnc4JOXfxltv4mgt
	jpQCkaaqLJnit6SgF4+wB8Rh5BzX73Vnwe5/nbUW4/g==
X-Gm-Gg: AY/fxX79TQ/CjJUrQh0Q3Yu1rwY6ZPE+PKIfGasJZUmA+5CgdDMmRseS7RUHDMTctV+
	+mWHFfzKBsNbwIXxmAoO/AdzcbvGTzBcsPo4WhX6w3DCc2Soy041oalUu03DeMkbViuDbCqXCVb
	Hkgb3LNlGTuJASyGmfUJaofkDLvAQ4awGEhixzMpHz4+w3oTX59FnYKUbkaNj57Zaa+wRfJ0yz/
	+I/7f7qm3EgNEp2bWE4CqKb0m53EMIB13atoZzMySN95w+J636hmyLbfaLITDqDkIGeW3NL
X-Google-Smtp-Source: AGHT+IGEaCQ0e0CWGCeWLtXq4GVLuEW/zgvfhclhJXq5sdRG/K+7JomgM7U0hIfgGqNioD9mu18JXhtGa/tuXyfoPfU=
X-Received: by 2002:a05:7022:698f:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-11f34c07146mr5230449c88.4.1765819659096; Mon, 15 Dec 2025
 09:27:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202164121.3612929-6-csander@purestorage.com> <202512101405.a7a2bdb2-lkp@intel.com>
In-Reply-To: <202512101405.a7a2bdb2-lkp@intel.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 09:27:27 -0800
X-Gm-Features: AQt7F2pP-cpxblAzGWfuipdbIBoGPEKpMttcrg1d0C8miC6pev-2BhkllFi7YKI
Message-ID: <CADUfDZqfUbK0=cbVh5TOWkoXTR8uXMxLUoh5O-B8Xbq-VbVw=g@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 10:20=E2=80=AFPM kernel test robot <oliver.sang@inte=
l.com> wrote:
>
>
>
> Hello,
>
> kernel test robot noticed "Oops:general_protection_fault,probably_for_non=
-canonical_address#:#[##]KASAN" on:
>
> commit: a924e7ffd1b0b2e015ed1174662d52053a2339c4 ("[PATCH v4 5/5] io_urin=
g: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER")
> url: https://github.com/intel-lab-lkp/linux/commits/Caleb-Sander-Mateos/i=
o_uring-use-release-acquire-ordering-for-IORING_SETUP_R_DISABLED/20251203-0=
04502
> base: https://git.kernel.org/cgit/linux/kernel/git/axboe/linux.git for-ne=
xt
> patch link: https://lore.kernel.org/all/20251202164121.3612929-6-csander@=
purestorage.com/
> patch subject: [PATCH v4 5/5] io_uring: avoid uring_lock for IORING_SETUP=
_SINGLE_ISSUER
>
> in testcase: trinity
> version:
> with following parameters:
>
>         runtime: 300s
>         group: group-00
>         nr_groups: 5
>
>
>
> config: x86_64-randconfig-015-20251205
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 3=
2G
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202512101405.a7a2bdb2-lkp@intel.=
com
>
>
> [  617.261968][ T3783] Oops: general protection fault, probably for non-c=
anonical address 0xdffffc00000000f3: 0000 [#1] KASAN
> [  617.267361][ T3783] KASAN: null-ptr-deref in range [0x0000000000000798=
-0x000000000000079f]
> [  617.268334][ T3783] CPU: 0 UID: 65534 PID: 3783 Comm: trinity-c0 Not t=
ainted 6.18.0-rc6-00312-ga924e7ffd1b0 #1 PREEMPT(lazy)  f22e3d733e0666690a0=
6b271bf82578b56b40aa3
> [  617.269927][ T3783] Hardware name: QEMU Standard PC (i440FX + PIIX, 19=
96), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [  617.271108][ T3783] RIP: 0010:task_work_add (kbuild/src/consumer/kerne=
l/task_work.c:68 (discriminator 2))
> [  617.271772][ T3783] Code: 39 25 df fe 67 03 0f 85 8c 01 00 00 e8 1c bd=
 24 00 4d 8d ac 24 98 07 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1=
 ea 03 <80> 3c 02 00 0f 85 2f 02 00 00 49 89 df 48 8d 44 24 38 4d 8b b4 24
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:   39 25 df fe 67 03       cmp    %esp,0x367fedf(%rip)        # 0x36=
7fee5
>    6:   0f 85 8c 01 00 00       jne    0x198
>    c:   e8 1c bd 24 00          call   0x24bd2d
>   11:   4d 8d ac 24 98 07 00    lea    0x798(%r12),%r13
>   18:   00
>   19:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   20:   fc ff df
>   23:   4c 89 ea                mov    %r13,%rdx
>   26:   48 c1 ea 03             shr    $0x3,%rdx
>   2a:*  80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)               <=
-- trapping instruction
>   2e:   0f 85 2f 02 00 00       jne    0x263
>   34:   49 89 df                mov    %rbx,%r15
>   37:   48 8d 44 24 38          lea    0x38(%rsp),%rax
>   3c:   4d                      rex.WRB
>   3d:   8b                      .byte 0x8b
>   3e:   b4 24                   mov    $0x24,%ah
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)
>    4:   0f 85 2f 02 00 00       jne    0x239
>    a:   49 89 df                mov    %rbx,%r15
>    d:   48 8d 44 24 38          lea    0x38(%rsp),%rax
>   12:   4d                      rex.WRB
>   13:   8b                      .byte 0x8b
>   14:   b4 24                   mov    $0x24,%ah
> [  617.273774][ T3783] RSP: 0018:ffff88816ac9fb10 EFLAGS: 00010206
> [  617.274486][ T3783] RAX: dffffc0000000000 RBX: ffff88816ac9fbe0 RCX: 0=
000000000000000
> [  617.275413][ T3783] RDX: 00000000000000f3 RSI: 0000000000000000 RDI: 0=
000000000000000
> [  617.276336][ T3783] RBP: 0000000000000002 R08: 0000000000000000 R09: 0=
000000000000000
> [  617.277257][ T3783] R10: 0000000000000000 R11: 0000000000000000 R12: 0=
000000000000000
> [  617.278178][ T3783] R13: 0000000000000798 R14: 1ffff1102d593f65 R15: f=
fff88816ac9fcf0
> [  617.279075][ T3783] FS:  00000000010a2880(0000) GS:0000000000000000(00=
00) knlGS:0000000000000000
> [  617.280114][ T3783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  617.280856][ T3783] CR2: 00000000d684d000 CR3: 000000015f35b000 CR4: 0=
0000000000406f0
> [  617.281749][ T3783] Call Trace:
> [  617.282202][ T3783]  <TASK>
> [  617.282613][ T3783]  ? lockdep_init_map_type (kbuild/src/consumer/kern=
el/locking/lockdep.c:4973 (discriminator 1))
> [  617.283274][ T3783]  ? task_work_set_notify_irq (kbuild/src/consumer/k=
ernel/task_work.c:56)
> [  617.283904][ T3783]  ? lockdep_init_map_type (kbuild/src/consumer/kern=
el/locking/lockdep.c:4973 (discriminator 1))
> [  617.284515][ T3783]  ? __init_swait_queue_head (kbuild/src/consumer/in=
clude/linux/list.h:45 (discriminator 2) kbuild/src/consumer/kernel/sched/sw=
ait.c:12 (discriminator 2))
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251210/202512101405.a7a2bdb2-lk=
p@intel.com

The full Call Trace is more useful:
[  617.261968][ T3783] Oops: general protection fault, probably for
non-canonical address 0xdffffc00000000f3: 0000 [#1] KASAN
[  617.267361][ T3783] KASAN: null-ptr-deref in range
[0x0000000000000798-0x000000000000079f]
[  617.268334][ T3783] CPU: 0 UID: 65534 PID: 3783 Comm: trinity-c0
Not tainted 6.18.0-rc6-00312-ga924e7ffd1b0 #1 PREEMPT(lazy)
f22e3d733e0666690a06b271bf82578b56b40aa3
[  617.269927][ T3783] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  617.271108][ T3783] RIP: 0010:task_work_add+0xbd/0x330
[  617.271772][ T3783] Code: 39 25 df fe 67 03 0f 85 8c 01 00 00 e8 1c
bd 24 00 4d 8d ac 24 98 07 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89
ea 48 c1 ea 03 <80> 3c 02 00 0f 85 2f 02 00 00 49 89 df 48 8d 44 24 38
4d 8b b4 24
[  617.273774][ T3783] RSP: 0018:ffff88816ac9fb10 EFLAGS: 00010206
[  617.274486][ T3783] RAX: dffffc0000000000 RBX: ffff88816ac9fbe0
RCX: 0000000000000000
[  617.275413][ T3783] RDX: 00000000000000f3 RSI: 0000000000000000
RDI: 0000000000000000
[  617.276336][ T3783] RBP: 0000000000000002 R08: 0000000000000000
R09: 0000000000000000
[  617.277257][ T3783] R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000000
[  617.278178][ T3783] R13: 0000000000000798 R14: 1ffff1102d593f65
R15: ffff88816ac9fcf0
[  617.279075][ T3783] FS:  00000000010a2880(0000)
GS:0000000000000000(0000) knlGS:0000000000000000
[  617.280114][ T3783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  617.280856][ T3783] CR2: 00000000d684d000 CR3: 000000015f35b000
CR4: 00000000000406f0
[  617.281749][ T3783] Call Trace:
[  617.282202][ T3783]  <TASK>
[  617.282613][ T3783]  ? lockdep_init_map_type+0x5c/0x240
[  617.283274][ T3783]  ? task_work_set_notify_irq+0x60/0x60
[  617.283904][ T3783]  ? lockdep_init_map_type+0x5c/0x240
[  617.284515][ T3783]  ? __init_swait_queue_head+0xca/0x160
[  617.285149][ T3783]  io_ring_ctx_lock_nested+0x295/0x340
[  617.285859][ T3783]  ? io_cqring_timer_wakeup+0xb0/0xb0
[  617.286469][ T3783]  ? perf_trace_io_uring_submit_req+0x20/0x20
[  617.287193][ T3783]  ? nohz_balancer_kick+0x140/0x7a0
[  617.294458][ T3783]  ? io_rings_free+0x7b/0xe0
[  617.295099][ T3783]  io_ring_ctx_wait_and_kill+0x6e/0x220
[  617.295749][ T3783]  ? percpu_counter_add+0x90/0x90
[  617.296356][ T3783]  ? security_capset+0xa0/0xc0
[  617.296941][ T3783]  io_uring_create+0xa0f/0xa52
[  617.297537][ T3783]  ? io_uring_poll.cold+0x1a/0x1a
[  617.298159][ T3783]  io_uring_setup.cold+0x1a/0x2e
[  617.298772][ T3783]  ? io_prepare_config+0xb10/0xb10
[  617.299469][ T3783]  __x64_sys_io_uring_setup+0xc4/0x170
[  617.300135][ T3783]  do_syscall_64+0x72/0xe40
[  617.300725][ T3783]  entry_SYSCALL_64_after_hwframe+0x4b/0x53

So we're calling io_ring_ctx_wait_and_kill() from io_uring_create(),
meaning the io_uring creation errored out early. Looks like there are
several "goto err;" paths before ctx->submitter_task is assigned. If
those error paths are taken, io_ring_ctx_lock_nested() can be called
in the IORING_SETUP_SINGLE_ISSUER && !IORING_SETUP_R_DISABLED case
with a NULL submitter_task. I think this can be fixed by just
initializing submitter_task earlier.

Thanks,
Caleb


>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>


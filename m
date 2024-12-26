Return-Path: <io-uring+bounces-5603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 563249FC7DE
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 04:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09141628C5
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 03:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1040B1494CF;
	Thu, 26 Dec 2024 03:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="upXTc1e0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C910E0;
	Thu, 26 Dec 2024 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735184698; cv=none; b=OJ1m1SyazdSdV1W5i0pdR+pYu/cZsPp0VN2DPnvaTwWfZh2Q59E6ftHnMqC+Sm48Xj70PaLzI//nEIw0VqQ1yWp+Zoh1bNYt++NM4oMjXwdl7ji9wDSts6UM3djym/uiLjY1cka5EFcChD6v21J3R13/57X1TWC68q195GXbS+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735184698; c=relaxed/simple;
	bh=Sbhiw4IYHUuGo1lMiZZ1TirqrnyXbgOeh6vS14IHVb4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qxlM6c1KLsaIeIuDMdusIj+LznwiHyGz21fdL/LovEsPyZk0Rk2nX0alRg4NLjmp6Y+BOQANKnvfPQ2b9jzlgdXMpSO1nRTGtP1nQBHeMD+0Q2GyAF0Oe29LpFS6FSMKYp8Etu3eUeChGJO6GxdwFUCIUaIESH3JXyOZk2W5YPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=upXTc1e0; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1735184602;
	bh=Sbhiw4IYHUuGo1lMiZZ1TirqrnyXbgOeh6vS14IHVb4=;
	h=Mime-Version:Subject:From:Date:Message-Id:To;
	b=upXTc1e0wKMVMEMLRrLVf7r0uf61kIoTlGIqnpfq5+97HlxxzlKFVghwaQ71vm5Tp
	 wi3ZoqYeSsBoG600zysvLX52KiSOaV5SyxWgh2a+m0dWh1xYIGCZHY3LuEjmAxNzCR
	 z6u3gyvieAIgtbKAEb9n50LyLGdl+q6suqyFWIYw=
X-QQ-mid: bizesmtpip2t1735184595twppjdz
X-QQ-Originating-IP: ZoOWnm7W86xrvrqB2YhOvQcm9SVvss6MXRk9yG7GgKg=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 26 Dec 2024 11:43:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16894880564566822789
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
From: Kun Hu <huk23@m.fudan.edu.cn>
In-Reply-To: <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
Date: Thu, 26 Dec 2024 11:43:03 +0800
Cc: peterz@infradead.org,
 mingo@redhat.com,
 will@kernel.org,
 boqun.feng@gmail.com,
 linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7556DAC6-20C1-4FCA-A9C8-633E36281341@m.fudan.edu.cn>
References: <1CF89E16-3A37-494F-831C-5CA24BCEEE50@m.fudan.edu.cn>
 <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
To: Waiman Long <llong@redhat.com>,
 asml.silence@gmail.com,
 axboe@kernel.dk
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: N7iI3zU3U7HlZrCmm0sOAxF2+FtxocBU19E18tUaBmxcEfD9ftZqdSA+
	z/rmjSWRHgYKvdIhsWU6NfDbRt1LqaAVYOlYo+rAr/pTKooPK0r7RA1pDQ1Crq+uuGVCHo8
	qrgrztky1gkn58dwUbAnd1wfOpDI0mOdOz9teLWrejuMiqMdArKecuzrFpynehtEBdAJ/u9
	BPr9Q+h6as7DcfAl0Hlx+wfyqPXOl0M/3SfV3WODGn5Zet4VgzofykpyrWl/7rbDz/aUcdA
	6YCtbd35lYIBqOvxysyBO6kSl5fA44LCXuSTz/DQDbENFjjMmBbq6EW2LJQe++zmotuRNdt
	6Inpm6v4F4h51pMf9C8c2p6BZ4u4N0QZ2IIQWcdeQtcFe3tvdhKvF9d/7ir6ChXkYynwtrb
	F6BfBxG9GrCjRudV0RqMHvuLocylD8QQyO0xkFJceLWp2VWWY7ZObOKPNqA/vgTnC7H9mK/
	wuwJC6AUU+6A8GQWnD7ZzymXIq3c9iIKOaLtteddHG4OVGOcfOy0Mx+4OIsX9k3ShLn1tNM
	PqFCvOPJ1Xz2pCUE17+yl3hrOSbz0+4/FIE1fG8tRamZd6GbeHd2i6kuErPLdDbBkun381n
	Y1SSlP9+7zGEQsvno8/LlynMS3ZL5VtW/LO5gA1kMVWBDAoP60PIPgtzVfqHxdTKFafb6Yf
	IAM2DlenIaj0Xzq6ZzHCuPoA4gh+ENK19lDVyAyUQaLhaRpJg2aCFEYM//d+jl3TyclpcfB
	Gu5km2sDXG+Oi1sdD6apeAFGb0aepVthLs2p1LupNu0CzjQ+kVXafnYmwwtDqfpy+X1SqVt
	2d/07Dng/glIDFBuLvBG/+SXohSgQGybwSXZ2auKhxNdCpeV3tsiTs+EY+BJn3uaX3i95ov
	qTALVnb/QGhOfgCihIAd8tYmXeC6EeLLIwS9tJd8TrfOUkxoPknWGhVEwnPk9EqsMLM3EDh
	J1NfoxCo76yzgbF7XNUGxxI2N
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

> This is not caused by a locking bug. The freed structure is a =
task_struct which is passed by io_sq_thread() to try_to_wake_up(). So =
the culprit is probably in the io_uring code. cc'ing the io_uring =
developers for further review.

Thanks. This also seems to involve sqpoll.c and io_uring.c. I'm sending =
an email to both Pavel Begunkov and Jens Axboe, with a cc to io_uring.

Thanks,
Kun Hu

> 2024=E5=B9=B412=E6=9C=8826=E6=97=A5 05:11=EF=BC=8CWaiman Long =
<llong@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 12/24/24 7:28 AM, Kun Hu wrote:
>> Hello,
>>=20
>> When using fuzzer tool to fuzz the latest Linux kernel, the following =
crash
>> was triggered.
>>=20
>> HEAD commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
>> git tree: upstream
>> Console =
output:https://drive.google.com/file/d/11IXj9a4uRbOaqIK90F2px6nLiHhJ04rw/v=
iew?usp=3Dsharing
>> Kernel config: =
https://drive.google.com/file/d/1RhT5dFTs6Vx1U71PbpenN7TPtnPoa3NI/view?usp=
=3Dsharing
>> C reproducer: =
https://drive.google.com/file/d/1BP2d5rfb4XBuq0njxKnS6d3AoysIiT61/view?usp=
=3Dsharing
>> Syzlang reproducer: =
https://drive.google.com/file/d/1lTQrXRQfndtigBiKBxelQeHszr2dzbLp/view?usp=
=3Dsharing
>> Similar report: =
https://lore.kernel.org/lkml/CALcu4rZOs3sbXBWARhjM6d8UngPUF3bU1CPmSZBugUpg=
aP_0WA@mail.gmail.com/T/
>>=20
>>=20
>> This bug seems to have been reported and fixed in the old kernel, =
which seems to be a regression issue? If you fix this issue, please add =
the following tag to the commit:
>> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
>>=20
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 =
kernel/locking/lockdep.c:5089
>> Read of size 8 at addr ff1100000289acb8 by task syz.6.1904/11159
>>=20
>> CPU: 1 UID: 0 PID: 11159 Comm: syz.6.1904 Not tainted 6.13.0-rc3 #3
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>> <TASK>
>> __dump_stack lib/dump_stack.c:94 [inline]
>> dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
>> print_address_description mm/kasan/report.c:378 [inline]
>> print_report+0xcf/0x5f0 mm/kasan/report.c:489
>> kasan_report+0x93/0xc0 mm/kasan/report.c:602
>> __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
>> lock_acquire kernel/locking/lockdep.c:5849 [inline]
>> lock_acquire+0x1b1/0x580 kernel/locking/lockdep.c:5814
>> __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>> _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
>> class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 =
[inline]
>> try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
>> io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
>> io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
>> io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
>> io_uring_create io_uring/io_uring.c:3724 [inline]
>> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
>> __do_sys_io_uring_setup io_uring/io_uring.c:3833 [inline]
>> __se_sys_io_uring_setup io_uring/io_uring.c:3827 [inline]
>> __x64_sys_io_uring_setup+0x94/0x140 io_uring/io_uring.c:3827
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fa4396a071d
>> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fa4382f3ba8 EFLAGS: 00000246 ORIG_RAX: =
00000000000001a9
>> RAX: ffffffffffffffda RBX: 00007fa439862f80 RCX: 00007fa4396a071d
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000002616
>> RBP: 00007fa4382f3c00 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000015
>> R13: 00007fa439862f8c R14: 00007fa439863018 R15: 00007fa4382f3d40
>> </TASK>
>=20
> This is not caused by a locking bug. The freed structure is a =
task_struct which is passed by io_sq_thread() to try_to_wake_up(). So =
the culprit is probably in the io_uring code. cc'ing the io_uring =
developers for further review.
>=20
> Cheers,
> Longman
>=20
>> Allocated by task 11159:
>> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
>> kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>> unpoison_slab_object mm/kasan/common.c:319 [inline]
>> __kasan_slab_alloc+0x87/0x90 mm/kasan/common.c:345
>> kasan_slab_alloc include/linux/kasan.h:250 [inline]
>> slab_post_alloc_hook mm/slub.c:4119 [inline]
>> slab_alloc_node mm/slub.c:4168 [inline]
>> kmem_cache_alloc_node_noprof+0x14a/0x430 mm/slub.c:4220
>> alloc_task_struct_node kernel/fork.c:180 [inline]
>> dup_task_struct kernel/fork.c:1113 [inline]
>> copy_process+0x487/0x7500 kernel/fork.c:2225
>> create_io_thread+0xac/0xf0 kernel/fork.c:2755
>> io_sq_offload_create+0xc62/0x11d0 io_uring/sqpoll.c:476
>> io_uring_create io_uring/io_uring.c:3724 [inline]
>> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
>> __do_sys_io_uring_setup io_uring/io_uring.c:3833 [inline]
>> __se_sys_io_uring_setup io_uring/io_uring.c:3827 [inline]
>> __x64_sys_io_uring_setup+0x94/0x140 io_uring/io_uring.c:3827
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>=20
>> Freed by task 24:
>> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
>> kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>> kasan_save_free_info+0x3a/0x60 mm/kasan/generic.c:582
>> poison_slab_object mm/kasan/common.c:247 [inline]
>> __kasan_slab_free+0x54/0x70 mm/kasan/common.c:264
>> kasan_slab_free include/linux/kasan.h:233 [inline]
>> slab_free_hook mm/slub.c:2353 [inline]
>> slab_free mm/slub.c:4613 [inline]
>> kmem_cache_free+0x126/0x4d0 mm/slub.c:4715
>> put_task_struct include/linux/sched/task.h:144 [inline]
>> put_task_struct include/linux/sched/task.h:131 [inline]
>> delayed_put_task_struct+0x229/0x300 kernel/exit.c:227
>> rcu_do_batch kernel/rcu/tree.c:2567 [inline]
>> rcu_core+0x7cb/0x16c0 kernel/rcu/tree.c:2823
>> handle_softirqs+0x1ad/0x870 kernel/softirq.c:561
>> run_ksoftirqd kernel/softirq.c:950 [inline]
>> run_ksoftirqd+0x3a/0x60 kernel/softirq.c:942
>> smpboot_thread_fn+0x669/0xa80 kernel/smpboot.c:164
>> kthread+0x345/0x450 kernel/kthread.c:389
>> ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
>> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>=20
>> Last potentially related work creation:
>> kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
>> __kasan_record_aux_stack+0xa6/0xc0 mm/kasan/generic.c:544
>> __call_rcu_common.constprop.0+0x99/0x790 kernel/rcu/tree.c:3086
>> put_task_struct_rcu_user+0x75/0xc0 kernel/exit.c:233
>> finish_task_switch+0x4d2/0x720 kernel/sched/core.c:5278
>> context_switch kernel/sched/core.c:5372 [inline]
>> __schedule+0xe68/0x4120 kernel/sched/core.c:6756
>> __schedule_loop kernel/sched/core.c:6833 [inline]
>> schedule+0xd4/0x210 kernel/sched/core.c:6848
>> do_nanosleep+0x20e/0x4e0 kernel/time/hrtimer.c:2079
>> hrtimer_nanosleep+0x122/0x330 kernel/time/hrtimer.c:2126
>> common_nsleep+0xaa/0xd0 kernel/time/posix-timers.c:1356
>> __do_sys_clock_nanosleep kernel/time/posix-timers.c:1402 [inline]
>> __se_sys_clock_nanosleep kernel/time/posix-timers.c:1379 [inline]
>> __x64_sys_clock_nanosleep+0x33c/0x490 kernel/time/posix-timers.c:1379
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>=20
>> The buggy address belongs to the object at ff1100000289a340
>> which belongs to the cache task_struct of size 8712
>> The buggy address is located 2424 bytes inside of
>> freed 8712-byte region [ff1100000289a340, ff1100000289c548)
>>=20
>> The buggy address belongs to the physical page:
>> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 =
pfn:0x2898
>> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 =
pincount:0
>> flags: 0x100000000000040(head|node=3D0|zone=3D1)
>> page_type: f5(slab)
>> raw: 0100000000000040 ff110000014cb040 ffd4000000549800 =
dead000000000004
>> raw: 0000000000000000 0000000080030003 00000001f5000000 =
0000000000000000
>> head: 0100000000000040 ff110000014cb040 ffd4000000549800 =
dead000000000004
>> head: 0000000000000000 0000000080030003 00000001f5000000 =
0000000000000000
>> head: 0100000000000003 ffd40000000a2601 ffffffffffffffff =
0000000000000000
>> head: ff11000000000008 0000000000000000 00000000ffffffff =
0000000000000000
>> page dumped because: kasan: bad access detected
>>=20
>> Memory state around the buggy address:
>> ff1100000289ab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ff1100000289ac00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>> ff1100000289ac80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ^
>> ff1100000289ad00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ff1100000289ad80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>>=20
>> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
>> Thanks,
>> Kun Hu
>>=20
>=20
>=20



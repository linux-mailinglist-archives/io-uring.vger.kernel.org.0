Return-Path: <io-uring+bounces-8783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB31DB0F4EF
	for <lists+io-uring@lfdr.de>; Wed, 23 Jul 2025 16:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D042AAA4C68
	for <lists+io-uring@lfdr.de>; Wed, 23 Jul 2025 14:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD2728D8C4;
	Wed, 23 Jul 2025 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TD0esAmw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606722F5310
	for <io-uring@vger.kernel.org>; Wed, 23 Jul 2025 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753279730; cv=none; b=a+9cw7kn7tXTJo1I+fMJXKJgmp7Jn9nCn+rxzyd+FSoobR3ePnU41H0WFvojrlGBSoVShJQIqOw9Rl0VsgTk0zOsFMsFTp+gRW7ql1cxrjIf2tSiRk9MsLkZcAOtkMebWJV+s28P5lRIovA6G8W0iZ2G9fxS6vBeBWMkUnGIk3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753279730; c=relaxed/simple;
	bh=ydclLCaGSmNkeuVXez2CYGfXDVtHqZ0XMHB7iwtfteI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQVqQjIrvas31PVl+OcdSGAxkW9IUXxYwYrYWKHG/6MCfjTpo0cq2+ZJMU41mzs+y4qpgsiXNqNYUZHcBW6FUN+Gd1i+2GX4FFhGSeWd/cmpHl2juO2y1ZYVm6ev4E1gBtRLBjz9Js86KtsA3BnNGwQBqGNiB7Ewn+sgrjTuyp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TD0esAmw; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236192f8770so7722845ad.0
        for <io-uring@vger.kernel.org>; Wed, 23 Jul 2025 07:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753279727; x=1753884527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZYHF8dEvCBs5P2/4YixNScJ4EMSwZSRI7lnKT6lnKU=;
        b=TD0esAmw9hf0Gqwr4ybcDUpv7N9lzmldvj9Ug04xhdPN81easEoU+87o3CtUB9xEpP
         5FYSU3kVMC1bLC510FudhokEguuhmkLB3g5iGwd4ug7FhynN2Mz1Wwvf7wyg0cLdWwHg
         CCI0Stpok4Aa+sucOvKCz5ZgDym+ojudpAwcEaA70MJblJst/cts7b0XnWaSd2W4keOs
         EMzHl1DxgDryASv8R1rXMOLL36SRP2+bINrKCfG/7V4I2ZOxX6/fHh+bYbiOjBqQ7OiN
         3LSiIO39QW5f1nF91yurc6scErIMB9hVEsYMj4o6rnvnmb8ErRrCBgt3DAiXuTAQ3qgV
         MxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279727; x=1753884527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZYHF8dEvCBs5P2/4YixNScJ4EMSwZSRI7lnKT6lnKU=;
        b=fqbnsIe5dDUO02nzhpVlD3II0OhYhlvVON9y6VT3nn+xJJRgllbeFrVO2Udcoc2Ej5
         I/JDoRTq2kmGWkNw5INOGmFem9QbKOmYI1xrx/clBP/apCrvKsTBbAZr2htfHpk4qQ2u
         hGTVAknr5ubBBHC+OIiZnZ2viK/lmr0z6tZoR3b7Fy1wUP58BFBhuV3DR4tJJ197tuyQ
         1kizaDbe3cVPHTMJLjfGbVWdAXbFikWAF6Z+B1UYoNek5hJlXzLHPcPaV2WZVYOZkh1S
         2oFO9dR+cNKAEvh8Ky4PxC4191FdhhtHEFwp38mr9KVZ3GY0GaGM5JM7d+f7wUAXaI2+
         Buhw==
X-Forwarded-Encrypted: i=1; AJvYcCVGf/721v+bXUaFM/OYdP/0YytzeMzlHST4E0Ubd360DU+vKnAl/8LBjVSHZTlHSOKOfEV88h4Ayg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1jairQjS24+oFMCDcpc0vO4Jm6vEv3oMtY41yQFduK8sswmRx
	REyCRNoScAxXleewMIoJbRyqsRanHFVd0zX9H9yFiXo3lFi+/klGbOsRrZlv03rEPEMiXgq0Ci9
	jcPp4+NvDV9q9HPA72vLjRWxzXz5r7hl1kos+eeKA
X-Gm-Gg: ASbGncs17pJaEUUUPhBgNkjDIq8OtQI1se8YTIQLozTwkQrXSuvYsM/5ohvlvtvd67/
	oDlccnWOJorSXS3yJ0oUAzyXPaTJVphpaiW+PKLKJAwfgd4h/bxih36UFVAyv4fLiwCaNVPiKvi
	jVhSkiBxj2c9Rw0+K4Pm6Z43qnv+wWEwcVnxicGIe7Ttvpx9SNZn2iofyI34PqQPXw09qDsjlB7
	8cs8TaEgs7SN4wmspIrXwH3JJ1NsC0fMNQ=
X-Google-Smtp-Source: AGHT+IHtN6u2lKCHJzkcV0H0rD9pbklTmhJEymw6TdX51stK0L0459k4B8/sxAU7uMTZuxiDg8mVOy+I2NYwD+eroAQ=
X-Received: by 2002:a17:903:988:b0:234:9fe1:8fc6 with SMTP id
 d9443c01a7336-23f8accce8amr110357055ad.18.1753279726373; Wed, 23 Jul 2025
 07:08:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com> <9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
 <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
In-Reply-To: <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 23 Jul 2025 16:08:34 +0200
X-Gm-Features: Ac12FXwGZKKVQK2n5_1WVsl19jqwqnUR1CUMp5DpEg3RIbtNMZC0IYtKGK64P7w
Message-ID: <CANp29Y4PHQh8Hm-13k_rybECR=+9LvwSiuPPOoJsiv2ZU2EcTw@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_poll_remove_entries
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 20, 2025 at 8:49=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/20/25 12:24 PM, Jens Axboe wrote:
> > On 7/19/25 11:29 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    4871b7cb27f4 Merge tag 'v6.16-rc6-smb3-client-fixes' o=
f gi..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1288c38c58=
0000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dfa738a4418=
f051ee
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3D01523a0ae560=
0aef5895
> >> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils fo=
r Debian) 2.40
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1688c38c=
580000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D166ed7d458=
0000
> >>
> >> Downloadable assets:
> >> disk image (non-bootable): https://storage.googleapis.com/syzbot-asset=
s/d900f083ada3/non_bootable_disk-4871b7cb.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/4a9dea51d821/vml=
inux-4871b7cb.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/f96c723cdfe=
6/bzImage-4871b7cb.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
> >> Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/s=
pinlock_api_smp.h:119 [inline]
> >> BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x36/0x50 kernel=
/locking/spinlock.c:170
> >> Read of size 1 at addr ffff88803c6f42b0 by task kworker/2:2/1339
> >>
> >> CPU: 2 UID: 0 PID: 1339 Comm: kworker/2:2 Not tainted 6.16.0-rc6-syzka=
ller-00253-g4871b7cb27f4 #0 PREEMPT(full)
> >> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian=
-1.16.3-2~bpo12+1 04/01/2014
> >> Workqueue: events io_fallback_req_func
> >> Call Trace:
> >>  <TASK>
> >>  __dump_stack lib/dump_stack.c:94 [inline]
> >>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> >>  print_address_description mm/kasan/report.c:378 [inline]
> >>  print_report+0xcd/0x610 mm/kasan/report.c:480
> >>  kasan_report+0xe0/0x110 mm/kasan/report.c:593
> >>  __kasan_check_byte+0x36/0x50 mm/kasan/common.c:557
> >>  kasan_check_byte include/linux/kasan.h:399 [inline]
> >>  lock_acquire kernel/locking/lockdep.c:5845 [inline]
> >>  lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5828
> >>  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
> >>  _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
> >>  spin_lock_irq include/linux/spinlock.h:376 [inline]
> >>  io_poll_remove_entry io_uring/poll.c:146 [inline]
> >>  io_poll_remove_entries.part.0+0x14e/0x7e0 io_uring/poll.c:179
> >>  io_poll_remove_entries io_uring/poll.c:159 [inline]
> >>  io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:326
> >>  io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
> >>  process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
> >>  process_scheduled_works kernel/workqueue.c:3321 [inline]
> >>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
> >>  kthread+0x3c5/0x780 kernel/kthread.c:464
> >>  ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
> >>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >>  </TASK>
> >>
> >> Allocated by task 6154:
> >>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
> >>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
> >>  kmalloc_noprof include/linux/slab.h:905 [inline]
> >>  kzalloc_noprof include/linux/slab.h:1039 [inline]
> >>  __comedi_device_postconfig_async drivers/comedi/drivers.c:664 [inline=
]
> >>  __comedi_device_postconfig drivers/comedi/drivers.c:721 [inline]
> >>  comedi_device_postconfig+0x2cb/0xc80 drivers/comedi/drivers.c:756
> >>  comedi_device_attach+0x3cf/0x900 drivers/comedi/drivers.c:998
> >>  do_devconfig_ioctl+0x1a7/0x580 drivers/comedi/comedi_fops.c:855
> >>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
> >>  vfs_ioctl fs/ioctl.c:51 [inline]
> >>  __do_sys_ioctl fs/ioctl.c:907 [inline]
> >>  __se_sys_ioctl fs/ioctl.c:893 [inline]
> >>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
> >>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >>
> >> Freed by task 6156:
> >>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >>  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
> >>  poison_slab_object mm/kasan/common.c:247 [inline]
> >>  __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
> >>  kasan_slab_free include/linux/kasan.h:233 [inline]
> >>  slab_free_hook mm/slub.c:2381 [inline]
> >>  slab_free mm/slub.c:4643 [inline]
> >>  kfree+0x2b4/0x4d0 mm/slub.c:4842
> >>  comedi_device_detach_cleanup drivers/comedi/drivers.c:171 [inline]
> >>  comedi_device_detach+0x2a4/0x9e0 drivers/comedi/drivers.c:208
> >>  do_devconfig_ioctl+0x46c/0x580 drivers/comedi/comedi_fops.c:833
> >>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
> >>  vfs_ioctl fs/ioctl.c:51 [inline]
> >>  __do_sys_ioctl fs/ioctl.c:907 [inline]
> >>  __se_sys_ioctl fs/ioctl.c:893 [inline]
> >>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
> >>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > I took a quick look at this, and surely looks like a comedi bug. If you
> > call the ioctl part (do_devconfig_ioctl()) with a NULL arg, it just doe=
s
> > a detach and frees the device, regardless of whether anyone has it
> > opened or not?! It's got some odd notion of checking whether it's busy
> > or not. For this case, someone has a poll active on the device, yet it
> > still happily frees it.
> >
> > CC'ing some folks, as this looks utterly broken.
>
> Case in point, I added:
>
> diff --git a/drivers/comedi/drivers.c b/drivers/comedi/drivers.c
> index 376130bfba8a..4d5fde012558 100644
> --- a/drivers/comedi/drivers.c
> +++ b/drivers/comedi/drivers.c
> @@ -167,6 +167,7 @@ static void comedi_device_detach_cleanup(struct comed=
i_device *dev)
>                                 kfree(s->private);
>                         comedi_free_subdevice_minor(s);
>                         if (s->async) {
> +                               WARN_ON_ONCE(waitqueue_active(&s->async->=
wait_head));
>                                 comedi_buf_alloc(dev, s, 0);
>                                 kfree(s->async);
>                         }
>
> and this is the first thing that triggers:
>
> WARNING: CPU: 1 PID: 807 at drivers/comedi/drivers.c:170 comedi_device_de=
tach+0x510/0x720
> Modules linked in:
> CPU: 1 UID: 0 PID: 807 Comm: comedi Not tainted 6.16.0-rc6-00281-gf4a40a4=
282f4-dirty #1438 NONE
> Hardware name: linux,dummy-virt (DT)
> pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=3D--)
> pc : comedi_device_detach+0x510/0x720
> lr : comedi_device_detach+0x1dc/0x720
> sp : ffff80008aeb7880
> x29: ffff80008aeb7880 x28: 1fffe00020251205 x27: ffff000101289028
> x26: ffff00010578a000 x25: ffff000101289000 x24: 0000000000000007
> x23: 1fffe00020af1437 x22: 1fffe00020af1438 x21: 0000000000000000
> x20: 0000000000000000 x19: dfff800000000000 x18: ffff0000db102ec0
> x17: ffff80008208e6dc x16: ffff80008362e120 x15: ffff800080a47c1c
> x14: ffff8000826f5aec x13: ffff8000836a0cc4 x12: ffff700010adcd15
> x11: 1ffff00010adcd14 x10: ffff700010adcd14 x9 : ffff8000836a105c
> x8 : ffff800085bc0cc0 x7 : ffff00000b035b50 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : ffff800080960e08 x3 : 0000000000000001
> x2 : ffff00000b4bf930 x1 : 0000000000000000 x0 : ffff0000d7e2b0d8
> Call trace:
>  comedi_device_detach+0x510/0x720 (P)
>  do_devconfig_ioctl+0x37c/0x4b8
>  comedi_unlocked_ioctl+0x33c/0x2bd8
>  __arm64_sys_ioctl+0x124/0x1a0
>  invoke_syscall.constprop.0+0x60/0x2a0
>  el0_svc_common.constprop.0+0x148/0x240
>  do_el0_svc+0x40/0x60
>  el0_svc+0x44/0xe0
>  el0t_64_sync_handler+0x104/0x130
>  el0t_64_sync+0x170/0x178
>
> Not sure what the right fix for comedi is here, it'd probably be at
> least somewhat saner if it only allowed removal of the device when the
> ref count would be 1 (for the ioctl itself). Just ignoring the file ref
> and allowing blanket removal seems highly suspicious / broken.
>
> As there's no comedi subsystem in syzbot, moving it to kernel:
>
> #syz set subsystems: kernel

FTR now there's, so:

#syz set subsystems: comedi

>
> --
> Jens Axboe


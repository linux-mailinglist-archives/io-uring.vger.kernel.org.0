Return-Path: <io-uring+bounces-8746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B80B0B0B7D5
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 21:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1992178A4B
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 19:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1891DF990;
	Sun, 20 Jul 2025 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n6JSzOiL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8EC8F6C
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 19:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753038065; cv=none; b=Mvk1qlD0uLNRhpjZnyxDBgM1Y4+aMYyGWn1OC/S/AUOdGI/O2H2j8cP2ZkOt0sug8EvC3AgL70nTeccKhD1nIe0oX2UsrTiP849C4ol+h633GSfKqROjxlVwApwOgehol+4g075y7JauJJsHWm1P26eA7Lch1FzOpRMEMiHOK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753038065; c=relaxed/simple;
	bh=0mS1ug5jO2aEKMpln36VCoQHVyMHlzbrwP4CqPz5fvY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qz+G7U2uPCnx56nlnvcJrTntGD4LQqI8eckfqQfmvovsHW7Fex3rnzcKSp816n6HxHAPIM52ZGOeuO+C9Zqf+x+uL1zEx9bV2V/j4GgalZBxZYH/JmlNLKiWFFqnzka2imzovMnESE1/Y/JI/z+jpWXtLjug/n9AxITKcclLamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n6JSzOiL; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235a3dd4f0dso21674365ad.0
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 12:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753038061; x=1753642861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0VcuzHsVpFd1pJThnmo8ltGCjgRYM30zloF0h6AJhY=;
        b=n6JSzOiLPG698coINUodV6PcoXCnKh70uWaDe2Lbiee/d5sgEPLHfbNX7UYJeYcbVd
         Us1XwZM8RmAvv5KtXB0mfbkzK6zrO3ln1e7MSW9KHsAToJLZIwej39M2oBwmVHiQtdR8
         xAXlLrlFElqhUxR5tzHgBkeQyuSyjmGK24Nshcx5MQRDrYHV7Q2abpWa7Xb69aaG60Tx
         SxFCeIzri+4bMNzD5CelWq3X73ALNu3FRxJ8ichvIW0RKibnRzgNk/PIi90L0qVXln04
         ZSQzFJtkGBYfvD3fXQ+z+CMTtrtbXMxd7mN1XblYhb4oEUmlCXdcNNKRup0vnWybzoYb
         OphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753038061; x=1753642861;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0VcuzHsVpFd1pJThnmo8ltGCjgRYM30zloF0h6AJhY=;
        b=b/lwsxjwMlJGfyycYBwrDM59UsLgQHaqTriWSrS/39RHjR02KSVcc5R+18c+ODQ5tq
         YrWcU4XxhTLCPY3aj3Sqbr76BmvCUuCxn/YDJjbEUXckE7g3AzAOMHl3U9WKhDPI92fi
         7XTBTB89m7yQQZzCIz2w3EbuPHFPB9enUDVDwiBIfM/vC1NACEEOOWfVOcvALn3mHrX2
         KQYhjgtJsEZI6/vpASajBL2nGNNVyiHJt2zcAHNWLsP9irGZlunRIvGG8EnHnLvjTpUS
         M8MhssMl6HuLj/z8SyE97CRckd/b+N7O2wswFx7nLhN5nDPWgKmnQ5Y4brsJhsCjXjop
         8hWA==
X-Forwarded-Encrypted: i=1; AJvYcCW5wtyskQ8954uqMAFnSmhcga73Fnh10B83yzbAVOBOU6oUDPYARvuUOJwUb4Cil430yPt7UZh8ZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9OT1Dhz93y+2nwUVILQOH0E5+iMSUntsfHjuOV3L2sE6AApa6
	EvluXqhksj5assDyLBWTHle0exKMZddG0f3S9/1dk8duxY2ShZqGzSJID3IR9ZGCVR0Kk8hRuX0
	fXdTN
X-Gm-Gg: ASbGncsebbmz60J2aVyjdrPflgrweEYX/pK1f8EwL2i78zsEmoRvII628u87g2u4369
	bP1xdxr9yM2QFuEa+Q20Gn5oYjP278dWenpeBKwxbd88bdIz5Dp32UkJqbT+BeCdH1DrMXZPcp7
	6hx9XDuwAl60tBLaaRHXwKzMMyNjp+HwcUJGjDCAqzGL5Olxex1bdzvty8oJesWuyAY+UEm7Oy7
	WW7KZZf9opK/nJ6QmWMgzBFCsxUCJG6/lBk3q1jrHRSYLDUm7VU5vHvKRSaoSr+u3JXbacWZpAa
	AjP2YBXQwPazZU/mG5vVlC6nrieEAU0mEAGF0y5JQy4c5ohgo8VDa1/mSc/2j8PLDFu5t0ajp7E
	oZdVR/7pOsIiJnQlmqJmxyp4Lqc3qqHP6qg==
X-Google-Smtp-Source: AGHT+IFzOKspwboXoOK4V7ADha2ZoUMC2ec10BhIvkdPzxROexeZUZSKH006rrchLbTfOu8wpRi+aQ==
X-Received: by 2002:a17:903:1a84:b0:234:8a4a:ada5 with SMTP id d9443c01a7336-23e24f59832mr243164615ad.37.1753038061000;
        Sun, 20 Jul 2025 12:01:01 -0700 (PDT)
Received: from [100.74.100.100] ([12.129.159.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b60f2b7sm44665445ad.79.2025.07.20.12.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jul 2025 12:00:59 -0700 (PDT)
Message-ID: <d407c9f1-e625-4153-930f-6e44d82b32b5@kernel.dk>
Date: Sun, 20 Jul 2025 13:00:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, abbotti@mev.co.uk,
 hsweeten@visionengravers.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
 <9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
 <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
Content-Language: en-US
In-Reply-To: <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/20/25 12:49 PM, Jens Axboe wrote:
> On 7/20/25 12:24 PM, Jens Axboe wrote:
>> On 7/19/25 11:29 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    4871b7cb27f4 Merge tag 'v6.16-rc6-smb3-client-fixes' of gi..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1288c38c580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
>>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1688c38c580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166ed7d4580000
>>>
>>> Downloadable assets:
>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4871b7cb.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/4a9dea51d821/vmlinux-4871b7cb.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/f96c723cdfe6/bzImage-4871b7cb.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
>>>
>>> ==================================================================
>>> BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
>>> BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
>>> Read of size 1 at addr ffff88803c6f42b0 by task kworker/2:2/1339
>>>
>>> CPU: 2 UID: 0 PID: 1339 Comm: kworker/2:2 Not tainted 6.16.0-rc6-syzkaller-00253-g4871b7cb27f4 #0 PREEMPT(full) 
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>>> Workqueue: events io_fallback_req_func
>>> Call Trace:
>>>  <TASK>
>>>  __dump_stack lib/dump_stack.c:94 [inline]
>>>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>>>  print_address_description mm/kasan/report.c:378 [inline]
>>>  print_report+0xcd/0x610 mm/kasan/report.c:480
>>>  kasan_report+0xe0/0x110 mm/kasan/report.c:593
>>>  __kasan_check_byte+0x36/0x50 mm/kasan/common.c:557
>>>  kasan_check_byte include/linux/kasan.h:399 [inline]
>>>  lock_acquire kernel/locking/lockdep.c:5845 [inline]
>>>  lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5828
>>>  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
>>>  _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
>>>  spin_lock_irq include/linux/spinlock.h:376 [inline]
>>>  io_poll_remove_entry io_uring/poll.c:146 [inline]
>>>  io_poll_remove_entries.part.0+0x14e/0x7e0 io_uring/poll.c:179
>>>  io_poll_remove_entries io_uring/poll.c:159 [inline]
>>>  io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:326
>>>  io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
>>>  process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
>>>  process_scheduled_works kernel/workqueue.c:3321 [inline]
>>>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
>>>  kthread+0x3c5/0x780 kernel/kthread.c:464
>>>  ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
>>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>  </TASK>
>>>
>>> Allocated by task 6154:
>>>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>>>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>>>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>>>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
>>>  kmalloc_noprof include/linux/slab.h:905 [inline]
>>>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>>>  __comedi_device_postconfig_async drivers/comedi/drivers.c:664 [inline]
>>>  __comedi_device_postconfig drivers/comedi/drivers.c:721 [inline]
>>>  comedi_device_postconfig+0x2cb/0xc80 drivers/comedi/drivers.c:756
>>>  comedi_device_attach+0x3cf/0x900 drivers/comedi/drivers.c:998
>>>  do_devconfig_ioctl+0x1a7/0x580 drivers/comedi/comedi_fops.c:855
>>>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
>>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>>>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>>>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>
>>> Freed by task 6156:
>>>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>>>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>>>  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
>>>  poison_slab_object mm/kasan/common.c:247 [inline]
>>>  __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
>>>  kasan_slab_free include/linux/kasan.h:233 [inline]
>>>  slab_free_hook mm/slub.c:2381 [inline]
>>>  slab_free mm/slub.c:4643 [inline]
>>>  kfree+0x2b4/0x4d0 mm/slub.c:4842
>>>  comedi_device_detach_cleanup drivers/comedi/drivers.c:171 [inline]
>>>  comedi_device_detach+0x2a4/0x9e0 drivers/comedi/drivers.c:208
>>>  do_devconfig_ioctl+0x46c/0x580 drivers/comedi/comedi_fops.c:833
>>>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
>>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>>>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>>>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> I took a quick look at this, and surely looks like a comedi bug. If you
>> call the ioctl part (do_devconfig_ioctl()) with a NULL arg, it just does
>> a detach and frees the device, regardless of whether anyone has it
>> opened or not?! It's got some odd notion of checking whether it's busy
>> or not. For this case, someone has a poll active on the device, yet it
>> still happily frees it.
>>
>> CC'ing some folks, as this looks utterly broken.
> 
> Case in point, I added:
> 
> diff --git a/drivers/comedi/drivers.c b/drivers/comedi/drivers.c
> index 376130bfba8a..4d5fde012558 100644
> --- a/drivers/comedi/drivers.c
> +++ b/drivers/comedi/drivers.c
> @@ -167,6 +167,7 @@ static void comedi_device_detach_cleanup(struct comedi_device *dev)
>  				kfree(s->private);
>  			comedi_free_subdevice_minor(s);
>  			if (s->async) {
> +				WARN_ON_ONCE(waitqueue_active(&s->async->wait_head));
>  				comedi_buf_alloc(dev, s, 0);
>  				kfree(s->async);
>  			}
> 
> and this is the first thing that triggers:
> 
> WARNING: CPU: 1 PID: 807 at drivers/comedi/drivers.c:170 comedi_device_detach+0x510/0x720
> Modules linked in:
> CPU: 1 UID: 0 PID: 807 Comm: comedi Not tainted 6.16.0-rc6-00281-gf4a40a4282f4-dirty #1438 NONE 
> Hardware name: linux,dummy-virt (DT)
> pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
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

Something like the below may help, at least it'll tell us the device is
busy if there's a poll active on it.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master


diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index 3383a7ce27ff..ea96bc4b818e 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -785,21 +785,31 @@ void comedi_device_cancel_all(struct comedi_device *dev)
 static int is_device_busy(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
-	int i;
+	int i, is_busy = 0;
 
 	lockdep_assert_held(&dev->mutex);
 	if (!dev->attached)
 		return 0;
 
+	/* prevent new polls */
+	down_write(&dev->attach_lock);
+
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = &dev->subdevices[i];
-		if (s->busy)
-			return 1;
-		if (s->async && comedi_buf_is_mmapped(s))
-			return 1;
+		if (s->busy) {
+			is_busy = 1;
+			break;
+		}
+		if (!s->async)
+			continue;
+		if (comedi_buf_is_mmapped(s) ||
+		    waitqueue_active(&s->async->wait_head)) {
+			is_busy = 1;
+			break;
+		}
 	}
-
-	return 0;
+	up_write(&dev->attach_lock);
+	return is_busy;
 }
 
 /*

-- 
Jens Axboe


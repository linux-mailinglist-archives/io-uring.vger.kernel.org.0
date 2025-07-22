Return-Path: <io-uring+bounces-8777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0BAB0DD32
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 16:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D72F7188210A
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 14:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7833E19CCEC;
	Tue, 22 Jul 2025 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mev.co.uk header.i=@mev.co.uk header.b="ubVU+Vpg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp85.iad3a.emailsrvr.com (smtp85.iad3a.emailsrvr.com [173.203.187.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412822094
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 14:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.203.187.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193209; cv=none; b=LeisW5KNN6YryfRbx2gR9y7O0MKA9Rr33FUds5zVErlEx7ooFCAASoWuFSWVTgWQRhBIFXtX12NevF7/M44GzMMdeMs7JWc+DUcCJA6ymG/QUMe63jIY5rcVdciHpzQQdQHAVHla/dXq84WBj7zj6GiVPXVgGISBq6NvEyh5IdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193209; c=relaxed/simple;
	bh=xJvVPh4cH8Nafcxzhm9chhfvNMo9PBjn6+J5Pi21N1M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHH38LqhrMbyhuwjq+7S7nlBDMygQcX0CcqjXZTVTY5hXa9joyWw3WsIGUWYb/VpB1bdyJBbIdnz9kHfRXyNTWeBWQ4i4FOXjLy2nzQNYp2ZF6QIAc1p2NuAK7gtjGAhkH3zmEMSdWBcNKc96hVyfHxYU8nZd9zYriOfny1u99g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mev.co.uk; spf=pass smtp.mailfrom=mev.co.uk; dkim=pass (1024-bit key) header.d=mev.co.uk header.i=@mev.co.uk header.b=ubVU+Vpg; arc=none smtp.client-ip=173.203.187.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mev.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
	s=20221208-6x11dpa4; t=1753191091;
	bh=xJvVPh4cH8Nafcxzhm9chhfvNMo9PBjn6+J5Pi21N1M=;
	h=Date:From:To:Subject:From;
	b=ubVU+VpgdvwzDI+ra3eu+Zvq3qAZgGsgwpf8vaOfyXfSvY+8yM7s5Hxx1riCCL/A0
	 EcTYUYfFeHzUa85kX9ayWAOExbV9lHmcfuKDB26Vhwo6pFp8T+pJPXhmqbxlh+Wkrq
	 AQI10bMTbCqu5s1sQFWjPn/Nwapo5tDJnXX+UhsM=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp27.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id BC6EE24BF2;
	Tue, 22 Jul 2025 09:31:30 -0400 (EDT)
Date: Tue, 22 Jul 2025 14:31:28 +0100
From: Ian Abbott <abbotti@mev.co.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, hsweeten@visionengravers.com, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
Message-ID: <20250722143128.339d4462@ian-deb>
In-Reply-To: <d92489ea-a517-4a8f-a84b-33575379c885@mev.co.uk>
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
	<9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
	<ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
	<d407c9f1-e625-4153-930f-6e44d82b32b5@kernel.dk>
	<20250722134724.6671e45b@ian-deb>
	<e029eef8-2c2b-4dfe-a01f-9903f309e39e@kernel.dk>
	<d92489ea-a517-4a8f-a84b-33575379c885@mev.co.uk>
Organization: MEV Ltd.
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Classification-ID: 7da06794-59a0-4ec4-9116-d23041a476f8-1-1

On Tue, 22 Jul 2025 14:07:45 +0100
Ian Abbott <abbotti@mev.co.uk> wrote:

> On 22/07/2025 14:00, Jens Axboe wrote:
> > On 7/22/25 6:47 AM, Ian Abbott wrote:  
> >> On Sun, 20 Jul 2025 13:00:59 -0600
> >> Jens Axboe <axboe@kernel.dk> wrote:
> >>  
> >>> On 7/20/25 12:49 PM, Jens Axboe wrote:  
> >>>> On 7/20/25 12:24 PM, Jens Axboe wrote:  
> >>>>> On 7/19/25 11:29 AM, syzbot wrote:  
> >>>>>> Hello,
> >>>>>>
> >>>>>> syzbot found the following issue on:
> >>>>>>
> >>>>>> HEAD commit:    4871b7cb27f4 Merge tag
> >>>>>> 'v6.16-rc6-smb3-client-fixes' of gi.. git tree:       upstream
> >>>>>> console output:
> >>>>>> https://syzkaller.appspot.com/x/log.txt?x=1288c38c580000 kernel
> >>>>>> config:
> >>>>>> https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
> >>>>>> dashboard link:
> >>>>>> https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
> >>>>>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU
> >>>>>> Binutils for Debian) 2.40 syz repro:
> >>>>>> https://syzkaller.appspot.com/x/repro.syz?x=1688c38c580000 C
> >>>>>> reproducer:
> >>>>>> https://syzkaller.appspot.com/x/repro.c?x=166ed7d4580000
> >>>>>>
> >>>>>> Downloadable assets:
> >>>>>> disk image (non-bootable):
> >>>>>> https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4871b7cb.raw.xz
> >>>>>> vmlinux:
> >>>>>> https://storage.googleapis.com/syzbot-assets/4a9dea51d821/vmlinux-4871b7cb.xz
> >>>>>> kernel image:
> >>>>>> https://storage.googleapis.com/syzbot-assets/f96c723cdfe6/bzImage-4871b7cb.xz
> >>>>>>
> >>>>>> IMPORTANT: if you fix the issue, please add the following tag
> >>>>>> to the commit: Reported-by:
> >>>>>> syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
> >>>>>>
> >>>>>> ==================================================================
> >>>>>> BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq
> >>>>>> include/linux/spinlock_api_smp.h:119 [inline] BUG: KASAN:
> >>>>>> slab-use-after-free in _raw_spin_lock_irq+0x36/0x50
> >>>>>> kernel/locking/spinlock.c:170 Read of size 1 at addr
> >>>>>> ffff88803c6f42b0 by task kworker/2:2/1339
> >>>>>>
> >>>>>> CPU: 2 UID: 0 PID: 1339 Comm: kworker/2:2 Not tainted
> >>>>>> 6.16.0-rc6-syzkaller-00253-g4871b7cb27f4 #0 PREEMPT(full)
> >>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> >>>>>> 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014 Workqueue: events
> >>>>>> io_fallback_req_func Call Trace: <TASK>
> >>>>>>   __dump_stack lib/dump_stack.c:94 [inline]
> >>>>>>   dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> >>>>>>   print_address_description mm/kasan/report.c:378 [inline]
> >>>>>>   print_report+0xcd/0x610 mm/kasan/report.c:480
> >>>>>>   kasan_report+0xe0/0x110 mm/kasan/report.c:593
> >>>>>>   __kasan_check_byte+0x36/0x50 mm/kasan/common.c:557
> >>>>>>   kasan_check_byte include/linux/kasan.h:399 [inline]
> >>>>>>   lock_acquire kernel/locking/lockdep.c:5845 [inline]
> >>>>>>   lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5828
> >>>>>>   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119
> >>>>>> [inline] _raw_spin_lock_irq+0x36/0x50
> >>>>>> kernel/locking/spinlock.c:170 spin_lock_irq
> >>>>>> include/linux/spinlock.h:376 [inline] io_poll_remove_entry
> >>>>>> io_uring/poll.c:146 [inline]
> >>>>>> io_poll_remove_entries.part.0+0x14e/0x7e0 io_uring/poll.c:179
> >>>>>> io_poll_remove_entries io_uring/poll.c:159 [inline]
> >>>>>> io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:326
> >>>>>> io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
> >>>>>> process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
> >>>>>> process_scheduled_works kernel/workqueue.c:3321 [inline]
> >>>>>> worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
> >>>>>> kthread+0x3c5/0x780 kernel/kthread.c:464
> >>>>>> ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
> >>>>>> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >>>>>> </TASK>
> >>>>>>
> >>>>>> Allocated by task 6154:
> >>>>>>   kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >>>>>>   kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >>>>>>   poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
> >>>>>>   __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
> >>>>>>   kmalloc_noprof include/linux/slab.h:905 [inline]
> >>>>>>   kzalloc_noprof include/linux/slab.h:1039 [inline]
> >>>>>>   __comedi_device_postconfig_async drivers/comedi/drivers.c:664
> >>>>>> [inline] __comedi_device_postconfig
> >>>>>> drivers/comedi/drivers.c:721 [inline]
> >>>>>> comedi_device_postconfig+0x2cb/0xc80
> >>>>>> drivers/comedi/drivers.c:756 comedi_device_attach+0x3cf/0x900
> >>>>>> drivers/comedi/drivers.c:998 do_devconfig_ioctl+0x1a7/0x580
> >>>>>> drivers/comedi/comedi_fops.c:855
> >>>>>> comedi_unlocked_ioctl+0x15bb/0x2e90
> >>>>>> drivers/comedi/comedi_fops.c:2136 vfs_ioctl fs/ioctl.c:51
> >>>>>> [inline] __do_sys_ioctl fs/ioctl.c:907 [inline] __se_sys_ioctl
> >>>>>> fs/ioctl.c:893 [inline] __x64_sys_ioctl+0x18e/0x210
> >>>>>> fs/ioctl.c:893 do_syscall_x64 arch/x86/entry/syscall_64.c:63
> >>>>>> [inline] do_syscall_64+0xcd/0x4c0
> >>>>>> arch/x86/entry/syscall_64.c:94
> >>>>>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >>>>>>
> >>>>>> Freed by task 6156:
> >>>>>>   kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >>>>>>   kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >>>>>>   kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
> >>>>>>   poison_slab_object mm/kasan/common.c:247 [inline]
> >>>>>>   __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
> >>>>>>   kasan_slab_free include/linux/kasan.h:233 [inline]
> >>>>>>   slab_free_hook mm/slub.c:2381 [inline]
> >>>>>>   slab_free mm/slub.c:4643 [inline]
> >>>>>>   kfree+0x2b4/0x4d0 mm/slub.c:4842
> >>>>>>   comedi_device_detach_cleanup drivers/comedi/drivers.c:171
> >>>>>> [inline] comedi_device_detach+0x2a4/0x9e0
> >>>>>> drivers/comedi/drivers.c:208 do_devconfig_ioctl+0x46c/0x580
> >>>>>> drivers/comedi/comedi_fops.c:833
> >>>>>> comedi_unlocked_ioctl+0x15bb/0x2e90
> >>>>>> drivers/comedi/comedi_fops.c:2136 vfs_ioctl fs/ioctl.c:51
> >>>>>> [inline] __do_sys_ioctl fs/ioctl.c:907 [inline] __se_sys_ioctl
> >>>>>> fs/ioctl.c:893 [inline] __x64_sys_ioctl+0x18e/0x210
> >>>>>> fs/ioctl.c:893 do_syscall_x64 arch/x86/entry/syscall_64.c:63
> >>>>>> [inline] do_syscall_64+0xcd/0x4c0
> >>>>>> arch/x86/entry/syscall_64.c:94
> >>>>>> entry_SYSCALL_64_after_hwframe+0x77/0x7f  
> >>>>>
> >>>>> I took a quick look at this, and surely looks like a comedi bug.
> >>>>> If you call the ioctl part (do_devconfig_ioctl()) with a NULL
> >>>>> arg, it just does a detach and frees the device, regardless of
> >>>>> whether anyone has it opened or not?! It's got some odd notion
> >>>>> of checking whether it's busy or not. For this case, someone
> >>>>> has a poll active on the device, yet it still happily frees it.
> >>>>>
> >>>>> CC'ing some folks, as this looks utterly broken.  
> >>>>
> >>>> Case in point, I added:
> >>>>
> >>>> diff --git a/drivers/comedi/drivers.c b/drivers/comedi/drivers.c
> >>>> index 376130bfba8a..4d5fde012558 100644
> >>>> --- a/drivers/comedi/drivers.c
> >>>> +++ b/drivers/comedi/drivers.c
> >>>> @@ -167,6 +167,7 @@ static void
> >>>> comedi_device_detach_cleanup(struct comedi_device *dev)
> >>>> kfree(s->private); comedi_free_subdevice_minor(s);
> >>>>   			if (s->async) {
> >>>> +
> >>>> WARN_ON_ONCE(waitqueue_active(&s->async->wait_head));
> >>>> comedi_buf_alloc(dev, s, 0); kfree(s->async);
> >>>>   			}
> >>>>
> >>>> and this is the first thing that triggers:
> >>>>
> >>>> WARNING: CPU: 1 PID: 807 at drivers/comedi/drivers.c:170
> >>>> comedi_device_detach+0x510/0x720 Modules linked in:
> >>>> CPU: 1 UID: 0 PID: 807 Comm: comedi Not tainted
> >>>> 6.16.0-rc6-00281-gf4a40a4282f4-dirty #1438 NONE Hardware name:
> >>>> linux,dummy-virt (DT) pstate: 21400005 (nzCv daif +PAN -UAO -TCO
> >>>> +DIT -SSBS BTYPE=--) pc : comedi_device_detach+0x510/0x720
> >>>> lr : comedi_device_detach+0x1dc/0x720
> >>>> sp : ffff80008aeb7880
> >>>> x29: ffff80008aeb7880 x28: 1fffe00020251205 x27: ffff000101289028
> >>>> x26: ffff00010578a000 x25: ffff000101289000 x24: 0000000000000007
> >>>> x23: 1fffe00020af1437 x22: 1fffe00020af1438 x21: 0000000000000000
> >>>> x20: 0000000000000000 x19: dfff800000000000 x18: ffff0000db102ec0
> >>>> x17: ffff80008208e6dc x16: ffff80008362e120 x15: ffff800080a47c1c
> >>>> x14: ffff8000826f5aec x13: ffff8000836a0cc4 x12: ffff700010adcd15
> >>>> x11: 1ffff00010adcd14 x10: ffff700010adcd14 x9 : ffff8000836a105c
> >>>> x8 : ffff800085bc0cc0 x7 : ffff00000b035b50 x6 : 0000000000000000
> >>>> x5 : 0000000000000000 x4 : ffff800080960e08 x3 : 0000000000000001
> >>>> x2 : ffff00000b4bf930 x1 : 0000000000000000 x0 : ffff0000d7e2b0d8
> >>>> Call trace:
> >>>>   comedi_device_detach+0x510/0x720 (P)
> >>>>   do_devconfig_ioctl+0x37c/0x4b8
> >>>>   comedi_unlocked_ioctl+0x33c/0x2bd8
> >>>>   __arm64_sys_ioctl+0x124/0x1a0
> >>>>   invoke_syscall.constprop.0+0x60/0x2a0
> >>>>   el0_svc_common.constprop.0+0x148/0x240
> >>>>   do_el0_svc+0x40/0x60
> >>>>   el0_svc+0x44/0xe0
> >>>>   el0t_64_sync_handler+0x104/0x130
> >>>>   el0t_64_sync+0x170/0x178
> >>>>
> >>>> Not sure what the right fix for comedi is here, it'd probably be
> >>>> at least somewhat saner if it only allowed removal of the device
> >>>> when the ref count would be 1 (for the ioctl itself). Just
> >>>> ignoring the file ref and allowing blanket removal seems highly
> >>>> suspicious / broken.
> >>>>
> >>>> As there's no comedi subsystem in syzbot, moving it to kernel:
> >>>>
> >>>> #syz set subsystems: kernel  
> >>>
> >>> Something like the below may help, at least it'll tell us the
> >>> device is busy if there's a poll active on it.
> >>>
> >>> #syz test:
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >>> master
> >>>
> >>>
> >>> diff --git a/drivers/comedi/comedi_fops.c
> >>> b/drivers/comedi/comedi_fops.c index 3383a7ce27ff..ea96bc4b818e
> >>> 100644 --- a/drivers/comedi/comedi_fops.c
> >>> +++ b/drivers/comedi/comedi_fops.c
> >>> @@ -785,21 +785,31 @@ void comedi_device_cancel_all(struct
> >>> comedi_device *dev) static int is_device_busy(struct comedi_device
> >>> *dev) {
> >>>   	struct comedi_subdevice *s;
> >>> -	int i;
> >>> +	int i, is_busy = 0;
> >>>   
> >>>   	lockdep_assert_held(&dev->mutex);
> >>>   	if (!dev->attached)
> >>>   		return 0;
> >>>   
> >>> +	/* prevent new polls */
> >>> +	down_write(&dev->attach_lock);
> >>> +
> >>>   	for (i = 0; i < dev->n_subdevices; i++) {
> >>>   		s = &dev->subdevices[i];
> >>> -		if (s->busy)
> >>> -			return 1;
> >>> -		if (s->async && comedi_buf_is_mmapped(s))
> >>> -			return 1;
> >>> +		if (s->busy) {
> >>> +			is_busy = 1;
> >>> +			break;
> >>> +		}
> >>> +		if (!s->async)
> >>> +			continue;
> >>> +		if (comedi_buf_is_mmapped(s) ||
> >>> +		    waitqueue_active(&s->async->wait_head)) {
> >>> +			is_busy = 1;
> >>> +			break;
> >>> +		}
> >>>   	}
> >>> -
> >>> -	return 0;
> >>> +	up_write(&dev->attach_lock);
> >>> +	return is_busy;
> >>>   }
> >>>   
> >>>   /*
> >>>  
> >>
> >> Thanks for your investigation and initial fix. I think
> >> dev->attach_lock needs to be write-locked before calling
> >> is_device_busy() and released after comedi_device_detach()
> >> (although that also write-locks it, so we need to refactor that).
> >> Otherwise, someone could get added to the wait_head after
> >> is_device_busy() returns.  
> > 
> > That's fine too, this is what my v2 addressed as well. I don't know
> > comedi well enough so I was worried about having ->attach_lock held
> > over comedi_device_cancel_all() -> do_cancel() -> s->cancel() as
> > that appears to be a new pattern. If you know this is fine, then
> > yes by all means, we should just hold ->attach_lock over the whole
> > thing and not need a detaching state.  
> 
> I think it's fine. do_cancel() (and s->cancel()) do not use
> attach_lock.
> 
> Actually, I was thinking it might be safer just to move the 
> `wait_queue_head_t wait_head;` member out of `struct comedi_async`
> and into `struct comedi_subdevice`, then it should not matter if
> there are any transient poll_wait() callers waiting on it.
> 

Moving wait_head out of struct comedi_async:

diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index 3383a7ce27ff..f55666ef5d93 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -745,7 +745,7 @@ static void do_become_nonbusy(struct comedi_device *dev,
 		kfree(async->cmd.chanlist);
 		async->cmd.chanlist = NULL;
 		s->busy = NULL;
-		wake_up_interruptible_all(&async->wait_head);
+		wake_up_interruptible_all(&s->async_wait_head);
 	} else {
 		dev_err(dev->class_dev,
 			"BUG: (?) %s called with async=NULL\n", __func__);
@@ -2464,7 +2464,7 @@ static __poll_t comedi_poll(struct file *file, poll_table *wait)
 	s = comedi_file_read_subdevice(file);
 	s_read = s;
 	if (s && s->async) {
-		poll_wait(file, &s->async->wait_head, wait);
+		poll_wait(file, &s->async_wait_head, wait);
 		if (s->busy != file || !comedi_is_subdevice_running(s) ||
 		    (s->async->cmd.flags & CMDF_WRITE) ||
 		    comedi_buf_read_n_available(s) > 0)
@@ -2476,7 +2476,7 @@ static __poll_t comedi_poll(struct file *file, poll_table *wait)
 		unsigned int bps = comedi_bytes_per_sample(s);
 
 		if (s != s_read)
-			poll_wait(file, &s->async->wait_head, wait);
+			poll_wait(file, &s->async_wait_head, wait);
 		if (s->busy != file || !comedi_is_subdevice_running(s) ||
 		    !(s->async->cmd.flags & CMDF_WRITE) ||
 		    comedi_buf_write_n_available(s) >= bps)
@@ -2582,7 +2582,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	add_wait_queue(&async->wait_head, &wait);
+	add_wait_queue(&s->async_wait_head, &wait);
 	while (count == 0 && !retval) {
 		unsigned int runflags;
 
@@ -2635,7 +2635,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 
 		buf += n;
 	}
-	remove_wait_queue(&async->wait_head, &wait);
+	remove_wait_queue(&s->async_wait_head, &wait);
 	set_current_state(TASK_RUNNING);
 	if (become_nonbusy && count == 0) {
 		struct comedi_subdevice *new_s;
@@ -2710,7 +2710,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		goto out;
 	}
 
-	add_wait_queue(&async->wait_head, &wait);
+	add_wait_queue(&s->async_wait_head, &wait);
 	while (count == 0 && !retval) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -2762,7 +2762,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 
 		buf += n;
 	}
-	remove_wait_queue(&async->wait_head, &wait);
+	remove_wait_queue(&s->async_wait_head, &wait);
 	set_current_state(TASK_RUNNING);
 	if (become_nonbusy && count == 0) {
 		struct comedi_subdevice *new_s;
@@ -3289,7 +3289,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 		__comedi_set_subdevice_runflags(s, COMEDI_SRF_ERROR);
 
 	if (async->cb_mask & events) {
-		wake_up_interruptible(&async->wait_head);
+		wake_up_interruptible(&s->async_wait_head);
 		si_code = async->cmd.flags & CMDF_WRITE ? POLL_OUT : POLL_IN;
 	}
 
diff --git a/drivers/comedi/drivers.c b/drivers/comedi/drivers.c
index 376130bfba8a..612e8cc8fedb 100644
--- a/drivers/comedi/drivers.c
+++ b/drivers/comedi/drivers.c
@@ -113,6 +113,7 @@ int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 		s->index = i;
 		s->async_dma_dir = DMA_NONE;
 		spin_lock_init(&s->spin_lock);
+		init_waitqueue_head(&s->async_wait_head);
 		s->minor = -1;
 	}
 	return 0;
@@ -665,7 +666,6 @@ static int __comedi_device_postconfig_async(struct comedi_device *dev,
 	if (!async)
 		return -ENOMEM;
 
-	init_waitqueue_head(&async->wait_head);
 	s->async = async;
 
 	async->max_bufsize = comedi_default_buf_maxsize_kb * 1024;
diff --git a/include/linux/comedi/comedidev.h b/include/linux/comedi/comedidev.h
index 4cb0400ad616..74f0e7027264 100644
--- a/include/linux/comedi/comedidev.h
+++ b/include/linux/comedi/comedidev.h
@@ -48,6 +48,7 @@
  * @async: Pointer to &struct comedi_async id the subdevice supports
  *	asynchronous acquisition commands.  (Allocated and initialized during
  *	post-configuration if needed.)
+ * @async_wait_head: Task wait queue for file reader or writer.
  * @lock: Pointer to a file object that performed a %COMEDI_LOCK ioctl on the
  *	subdevice.  (Initially NULL.)
  * @busy: Pointer to a file object that is performing an asynchronous
@@ -160,6 +161,7 @@ struct comedi_subdevice {
 	void *private;
 
 	struct comedi_async *async;
+	wait_queue_head_t async_wait_head;
 
 	void *lock;
 	void *busy;
@@ -271,7 +273,6 @@ struct comedi_buf_map {
  * @munge_ptr: Buffer position for "munging".
  * @events: Bit-vector of events that have occurred.
  * @cmd: Details of comedi command in progress.
- * @wait_head: Task wait queue for file reader or writer.
  * @cb_mask: Bit-vector of events that should wake waiting tasks.
  * @inttrig: Software trigger function for command, or NULL.
  *
@@ -356,7 +357,6 @@ struct comedi_async {
 	unsigned int munge_ptr;
 	unsigned int events;
 	struct comedi_cmd cmd;
-	wait_queue_head_t wait_head;
 	unsigned int cb_mask;
 	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
 		       unsigned int x);



-- 
-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-


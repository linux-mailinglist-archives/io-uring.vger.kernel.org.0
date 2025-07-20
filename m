Return-Path: <io-uring+bounces-8743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 166BBB0B79E
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 20:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ABAF3B4A3B
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8E81F4622;
	Sun, 20 Jul 2025 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sMJtuKPI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DC78F4F
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753035887; cv=none; b=EJvLKIhukcLhTAA+G2rSZvPrCMEomICuIOnvQuB3ix/OlNmcwc0TDf3QXmZDR2Iij2EY9mUqeLV0KIuM/AKIQaTwnx4Z+mEjDfHUXpZlwZVNh1Q19fvGbNizTT/lqEvDd9BbPSgQbfmFYWbdlwXtaRMzFnJ+08525wbNrj1A/Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753035887; c=relaxed/simple;
	bh=ydpW8Njp3KSqwOIoOimXi6XR1dAniUYkHWCgNvJxom4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LykjnX0eeJ+sPWmZnL+7uW6UJZwO798DGZX021ztdOmg3PeEWN/ufNx2FVcNVLMPrBsE7EGMN9r7LhzIh5QVb1r33vxgjC3uGo4AOgDxsxtgyTCFdVEgxA6uOXEvfgxLLLKs9T9/BaSir/fC6NszM4NMYsufibuWqYDxwv3PRiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sMJtuKPI; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3135f3511bcso3054484a91.0
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 11:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753035884; x=1753640684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lEI6cO57sMy6BOcIlKL2Py4ZX+kLnCSrWclSXITen7c=;
        b=sMJtuKPI9xvdBLBAYCl7Jxa8z/F3k2wNDsbRNnIe69hhtD0SBIr0rGGtQSsyqVNMeM
         civhiedLx7IXeM+gYTLuX+Ug14e4U/fpK3g5WRB8V3cG0XjoRbtnf1r+SnctMfX6j8rD
         Y4DSgAI0pZTbJl0ubWw6nGGPEYyZQYeY2yZbp3Wl5oWAUU6oibc6PHGGGqUPY+mhZkoK
         NJnMIMyX1FfOMpJqw890BLPPD7ECT4Qgwqf5K8lT8Ei31YfN7VUNPLMyuGNv3rLyCcLs
         lwVt/CgsXforiHNeFiF0KWVd0fqTsXVBODf7Z4Jv7EP4g63KPKI0IeEFglD8YBKGK95S
         Te0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753035884; x=1753640684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lEI6cO57sMy6BOcIlKL2Py4ZX+kLnCSrWclSXITen7c=;
        b=d0ognsxywJv+QKFfZN3wHA2LOAjsD27rrSogkrrqu/SAunkv+nyl3Twbhy+FgLS+YV
         wsMS7xtcBJGASx0tKR28gMFJoLi2actkL+QvDmqERih/lKCMozjnZeIa49eXHzk6hVHY
         bOmj7TzedpYc7aYGwjz8Jl5kqKM8Ir9H89ILQq8afJKbzaVn1AGnyGnW/RglxW8Ca12v
         aYMDq+BwJcP6gm763P3bKVSzIqZ7zD3BIXB5+V8/1MghvpviWQk8jmw8fLpejr4eKxIo
         rxvoK7mmNoJgGlWqP/jBmDM24okK0l7f83wu3VnUUaRcBbrcbEwxF0JaPWFQLo7D60Jz
         CNWw==
X-Forwarded-Encrypted: i=1; AJvYcCXHEBnCkjKasXG0oaNYKbdHoWPpKcT0OsSFLjOAYeODD+1b/MWkkfokQJw7uN2WU7WWWpv7FNXwCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0lTxNj+Ii+W6eQu0Fi51O+bLKGz7KWm4Rdlex9V4fOsk/Z0FK
	E8IDrG7GYrmWbj/pelaAQjDRMFKDCqBhXofqJwjCaSZRzCeLA5MFVaOE1YRW7YENzQA=
X-Gm-Gg: ASbGncuEsheKc6FPyQ8hoz63IBv3aj4XaMUANX1JHXe44S0ZM4hR1OqyIrEOxaWPvgD
	Zc7Oomfr4a9583/0XZPhfniakgqE/fxfG5e70FflYMvPezlT0fJsdf26Eim2/4OTt+OHNmyREbg
	zqsbyGq2EzGKhJtQRqnzdW5ZecvZGkNSBaCBsOisj1jq+7E5W6IAHmGrw1fhBDxCXI9XLd5zbcU
	jVhQQR6HAjcUioggq7qX6TmbpEPLA652a9rIAzz0zl4SPYNQ7tJc+2Z0fA8MZrqR6uA5PElldXX
	ej5JELUOn/prllepTKFKdqNRKMKW+426cYNp6xEg6+RZU1HVcvf2C21Z1SJS94o6zwH+RNP+QIn
	8rng/ZE5wc4/mrrDQocFRwI0=
X-Google-Smtp-Source: AGHT+IGvTom24Sq+7H1/82K08q2edQFzllo1kw0+BcYsYK3dhApPuYn4X2Oi5MruuLyYT37lLTS58w==
X-Received: by 2002:a17:90b:4985:b0:312:25dd:1c99 with SMTP id 98e67ed59e1d1-31c9f45e1d0mr25108701a91.19.1753035883625;
        Sun, 20 Jul 2025 11:24:43 -0700 (PDT)
Received: from [100.74.100.100] ([12.129.159.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f29e44dsm8505407a91.39.2025.07.20.11.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jul 2025 11:24:42 -0700 (PDT)
Message-ID: <9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
Date: Sun, 20 Jul 2025 12:24:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
To: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, abbotti@mev.co.uk,
 hsweeten@visionengravers.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/19/25 11:29 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4871b7cb27f4 Merge tag 'v6.16-rc6-smb3-client-fixes' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1288c38c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
> dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1688c38c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166ed7d4580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4871b7cb.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4a9dea51d821/vmlinux-4871b7cb.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f96c723cdfe6/bzImage-4871b7cb.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
> BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
> Read of size 1 at addr ffff88803c6f42b0 by task kworker/2:2/1339
> 
> CPU: 2 UID: 0 PID: 1339 Comm: kworker/2:2 Not tainted 6.16.0-rc6-syzkaller-00253-g4871b7cb27f4 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: events io_fallback_req_func
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xcd/0x610 mm/kasan/report.c:480
>  kasan_report+0xe0/0x110 mm/kasan/report.c:593
>  __kasan_check_byte+0x36/0x50 mm/kasan/common.c:557
>  kasan_check_byte include/linux/kasan.h:399 [inline]
>  lock_acquire kernel/locking/lockdep.c:5845 [inline]
>  lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5828
>  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
>  _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
>  spin_lock_irq include/linux/spinlock.h:376 [inline]
>  io_poll_remove_entry io_uring/poll.c:146 [inline]
>  io_poll_remove_entries.part.0+0x14e/0x7e0 io_uring/poll.c:179
>  io_poll_remove_entries io_uring/poll.c:159 [inline]
>  io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:326
>  io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
>  process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
>  process_scheduled_works kernel/workqueue.c:3321 [inline]
>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
>  kthread+0x3c5/0x780 kernel/kthread.c:464
>  ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> Allocated by task 6154:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
>  kmalloc_noprof include/linux/slab.h:905 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  __comedi_device_postconfig_async drivers/comedi/drivers.c:664 [inline]
>  __comedi_device_postconfig drivers/comedi/drivers.c:721 [inline]
>  comedi_device_postconfig+0x2cb/0xc80 drivers/comedi/drivers.c:756
>  comedi_device_attach+0x3cf/0x900 drivers/comedi/drivers.c:998
>  do_devconfig_ioctl+0x1a7/0x580 drivers/comedi/comedi_fops.c:855
>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Freed by task 6156:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
>  poison_slab_object mm/kasan/common.c:247 [inline]
>  __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2381 [inline]
>  slab_free mm/slub.c:4643 [inline]
>  kfree+0x2b4/0x4d0 mm/slub.c:4842
>  comedi_device_detach_cleanup drivers/comedi/drivers.c:171 [inline]
>  comedi_device_detach+0x2a4/0x9e0 drivers/comedi/drivers.c:208
>  do_devconfig_ioctl+0x46c/0x580 drivers/comedi/comedi_fops.c:833
>  comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

I took a quick look at this, and surely looks like a comedi bug. If you
call the ioctl part (do_devconfig_ioctl()) with a NULL arg, it just does
a detach and frees the device, regardless of whether anyone has it
opened or not?! It's got some odd notion of checking whether it's busy
or not. For this case, someone has a poll active on the device, yet it
still happily frees it.

CC'ing some folks, as this looks utterly broken.

-- 
Jens Axboe


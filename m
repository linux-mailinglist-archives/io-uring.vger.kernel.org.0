Return-Path: <io-uring+bounces-2655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F0F947CC3
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 16:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57963281852
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 14:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C796F30C;
	Mon,  5 Aug 2024 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZW/fpKhc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E753EA64
	for <io-uring@vger.kernel.org>; Mon,  5 Aug 2024 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722867815; cv=none; b=BRVMK7u1JUS+j5NcA+57HSJ3pZ8cMzr6ppZMD2jS0Ph/8OQ7MYsTELGPFP4Vp55NsbYSWy5xdaVoOTxeBXsTvbtL0uaOAGWbiYaboFZbeZPLCknP96uOb4dzq0UNeLbsyC96Jlnku5t0IRjPr7+26syYuQ7gZpdJVUw6nA0v1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722867815; c=relaxed/simple;
	bh=KdVhrG1yhzfFka0WAbYQdaoGgL7/HphbDVd6HaODjC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KoKx8KiNWT/iOZd1qoFnFx8/xWYYPmWgGaD2HhLEo5N6MvErQvYYWCB2GufdJOV7cr3mxON3PkThx6v41N9EdHqK8Dgt899eUhI7xPR/1uADj4/cwIEHL9FbEWKNIFBW1ASvGniQwdbvHPvtfxvhCBMKTfCIArd87Lgx35gP+ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZW/fpKhc; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-39b3a9f9f4fso695435ab.0
        for <io-uring@vger.kernel.org>; Mon, 05 Aug 2024 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722867810; x=1723472610; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YxtbtashM6Y9E4aHS+7gfwHPz5pXOEDbseueiZ9oWYQ=;
        b=ZW/fpKhczZZy3NFmK7ZxPVjQl3d+Ug8ITiUS9fqtvtW6jhJx5wXrnIkzws/mgIQDM1
         ACx3Vu99JYBkgulx5XP4boSOsnybWBER04YUV83bCXcT36WNitBTWPX56JBo2x9HxZqf
         ONYcjaoXjtDZQHLztJTgE8asLqW6UQ7zWF1/5RqwGvuT0p/mY/fNlQCC2/6e66TT71rW
         Gd9d2bquDzUY7+ZhcrfnkkSAXWYmgqHHAVew6ibHs8p+Wn0SAMwagQkVKc331cce+I32
         sWoF4zN6YkZ6dy+66nv1xOrAn2N6QZv/nAfECkyxOKagHY1Tb6XgyVN4yCd+h+jFh6K7
         39vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722867810; x=1723472610;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YxtbtashM6Y9E4aHS+7gfwHPz5pXOEDbseueiZ9oWYQ=;
        b=IY3shlSpFV/1Z7C/sX/C11GxO0f+mRRF1Pg4DdPhyderEB846e19dJKXy2wtIIIJAZ
         nJljJp8HrKaQ4jkSWLOVH/0mUKb+a9s2FXocURk+fG6AeHZxkccSsRAJSIKBQ3D8zunY
         BXy/iHWh8/z+JbtbLr0KR3vh7TPnEstiaVr1do6Q8Hi92q9jN4a3e408D0MHwNZhW1A7
         1ioFhypAUtzIAaeBHjSRoiC1UGeNF1So/PWxY8YqXd9S/fTZorJPTMj77y31Rx6cqVjK
         kPJ9r4xEaUlBbWTB9aKacZcOwiRMFg5vV5e8hugcEVjLYHnxjgoIxuPHw94ZksMXT5CS
         g4MA==
X-Forwarded-Encrypted: i=1; AJvYcCVVa1QxSmjh9FjsVKOW+cLvk/S3ijzxZDGP2G4sQXcKfEE+BKOybzNEoSr+cWiOmZdSdEl/ud/eBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKvH/zteEXgy9TvirnN4sal0ahANI2JiKMzQS7yzB2PhU9868
	SYynou5PYn4iKK/tbBlkANUMrKKEgoEh/ckIfI0DyFafGIu3UbVtAJKiDUfm8IE=
X-Google-Smtp-Source: AGHT+IFGBkf+TJMvM0hCvFP0uWIjg/KNCDC10P36fweGRPb9q98AOo2W8opglBDWuYzSSRuMHYEy2w==
X-Received: by 2002:a05:6602:208c:b0:81f:ae26:690d with SMTP id ca18e2360f4ac-81fd42a77f2mr783547439f.0.1722867810226;
        Mon, 05 Aug 2024 07:23:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d6a5c319sm1722356173.166.2024.08.05.07.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Aug 2024 07:23:29 -0700 (PDT)
Message-ID: <8ada52ac-48e9-48cd-afa0-c738cf25fe4f@kernel.dk>
Date: Mon, 5 Aug 2024 08:23:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in __flush_work /
 __flush_work (2)
To: syzbot <syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
References: <000000000000ae429e061eea2157@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000ae429e061eea2157@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/5/24 12:53 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a5dbd76a8942 Merge tag 'x86-urgent-2024-08-04' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d5a373980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d16924117a4f7e9
> dashboard link: https://syzkaller.appspot.com/bug?extid=b3e4f2f51ed645fd5df2
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ba663ad5dbf5/disk-a5dbd76a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/226a427d6581/vmlinux-a5dbd76a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9f982777516a/bzImage-a5dbd76a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in __flush_work / __flush_work
> 
> write to 0xffff8881223aa3e8 of 8 bytes by task 3998 on cpu 0:
>  instrument_write include/linux/instrumented.h:41 [inline]
>  ___set_bit include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
>  insert_wq_barrier kernel/workqueue.c:3790 [inline]
>  start_flush_work kernel/workqueue.c:4142 [inline]
>  __flush_work+0x30b/0x570 kernel/workqueue.c:4178
>  flush_work kernel/workqueue.c:4229 [inline]
>  flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
>  io_fallback_tw+0x24b/0x320 io_uring/io_uring.c:1087
>  tctx_task_work_run+0xd1/0x1b0 io_uring/io_uring.c:1099
>  tctx_task_work+0x40/0x80 io_uring/io_uring.c:1124
>  task_work_run+0x13a/0x1a0 kernel/task_work.c:228
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x5dd/0x1720 kernel/exit.c:882
>  do_group_exit+0x102/0x150 kernel/exit.c:1031
>  get_signal+0xf2f/0x1080 kernel/signal.c:2917
>  arch_do_signal_or_restart+0x95/0x4b0 arch/x86/kernel/signal.c:310
>  exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x59/0x130 kernel/entry/common.c:218
>  do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff8881223aa3e8 of 8 bytes by task 50 on cpu 1:
>  __flush_work+0x42a/0x570 kernel/workqueue.c:4188
>  flush_work kernel/workqueue.c:4229 [inline]
>  flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
>  io_uring_try_cancel_requests+0x35b/0x370 io_uring/io_uring.c:3000
>  io_ring_exit_work+0x148/0x500 io_uring/io_uring.c:2779
>  process_one_work kernel/workqueue.c:3231 [inline]
>  process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
>  worker_thread+0x526/0x700 kernel/workqueue.c:3390
>  kthread+0x1d1/0x210 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> value changed: 0x0000000000400000 -> 0xffff88810006c00d
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 UID: 0 PID: 50 Comm: kworker/u8:3 Not tainted 6.11.0-rc1-syzkaller-00334-ga5dbd76a8942 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
> Workqueue: iou_exit io_ring_exit_work
> ==================================================================

This looks like workqueue, CC'ing maintainers. Unsure if this is benign
or not.

#syz set subsystems: kernel

-- 
Jens Axboe



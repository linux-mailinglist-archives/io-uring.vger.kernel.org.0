Return-Path: <io-uring+bounces-8383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D6DADCBD5
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1203B3B22EC
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7956C2C032B;
	Tue, 17 Jun 2025 12:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Aw/V4pYk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6427FB26
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164485; cv=none; b=Ow2KaaiQDJaOzwSHkkE5doNBw2LH9hydkHu8qa1wW2A5EZqwmbUs7AMt8MVFFbiOS1A49yAK92QFCthrjRVHgVBU7YQj6AwZLuPKb4pqpKa79PxnySndRjazr1XiQRmdNdTKgPWDO0cr0zlI5JOpfBc5ycv3DTWiDiJxIIaYmx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164485; c=relaxed/simple;
	bh=U0+A1lOtSox6LNSrWEe69AlsxRTU/WjvnlKjyZjOruA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sO8wsZjSRL38ntiSU9SQknp5QkNH++X/fuy9Qu1l9YoJM4ESWH5p3BhcxCcfHFF5KNKD4Ysyz3xhpzizsHJbKM7FJjRvvp3yiQ2GhLaDB/jPt1G1CruJYtZFlxA+KOnbuIfJb3fut+RQpV816SrkKUAS3R5zK3QYhU2RRbOBrD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Aw/V4pYk; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3de18fde9cfso7951265ab.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750164481; x=1750769281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+NvbUmM4Qyku01Y5V+HBwrpgHLhxJzThOfuu9er8Zc=;
        b=Aw/V4pYk7cF8CBvXwey+ZIUD0xVGMXxJek4O2+m5f6CmsaNiLMqJWXtmHX2TOytdIY
         nNj6VvSDe9NVERT27IpflHtH+85LA9gsQTSFiqpqZu7pcgojryetGH3iu0+RnknRzykM
         S5RiC5/E/32FJ2A8ceUZeXz8GOUs2t3TAhku/CNNsho2CdfkbDLzF//nPy3+b/3E2sGy
         IMU95vvys2w95CbGoTMM30NUHW/KmYM3GYKY4FYUt/DflrXqRPflhuCX5nGMpTdg0M8d
         0TgDhfLLD46iU2T9esLPZopBnJfWf7JQb8G1GJvlcM+y+N16XuAhdjaosGHnxvRGouMg
         wY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164481; x=1750769281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+NvbUmM4Qyku01Y5V+HBwrpgHLhxJzThOfuu9er8Zc=;
        b=p8JmSL0MZavCL5J2dJ+RSZLTFKxWzOrK78VgpIcy5HwT5/xcZh9wRVSWT6faG45Yr2
         j4m8rYlLfhCAakrL8eG3b4U4/rIeRjF28jWx96CIbZ9LGQyWXAkYV1p8eopPkDEc/w89
         MtJlT2rdWLkLd+JORgYGhYpWg+J0rFympFRUO0LXhPc/I2/BqPDDZkKp3EuJHmM5vPqR
         D2oj5XYEaubYcx0SzSZl87Nj/Yi07uS7m+HEAsUodeZ+GcC/zq3qph+lNrMHVxMPkIj4
         LM+C1ntvQ06T0YkkeW4yv5GYlNWocGM1cA9+UNBnaKBtnYrDyuTprdsc/KXV3girA1og
         xzrw==
X-Forwarded-Encrypted: i=1; AJvYcCUl6qeKdWdFQREDf3sIWnmYtkFFMWJVHCfuEw3KPILyMd+cmrMuifglFvIFgfCmdmTf8mwXr4dehw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHwEGUl57zoX9hS1mscxX1nMR55Wxj19k97WrdRMPyxl0FIKAe
	yFVaKetzBdGpofvZ90wqGZh1zHmss4KTjbVrdrT85kOk44RlZZ6prwNYBwKVRRy6W5+oVWKnoCr
	bbkZo
X-Gm-Gg: ASbGnctS+39rGOfUOZcjEWGXXXZ8Idh0XV8gOYTxTGCXx/ip0e+BlYvDAagOME4SELV
	18CNj6V40neak1ATqb+Z6temaqenVsW0DzdWA8oVgwsIPwx+kyr8jRDm+AiUHu8/OAJqIk85kH2
	fjozF82X204Vl02/2rxgbo6GpEUA1eGk5Z+3/xZGXgiXYj9SbnvOtmXITW3xfgNOIfAlg/rQDPA
	awSqXWfVF27Jitx1c1KhUmFp3SwNtLqepbnA6slAqxQbaIACkiOVto8NIKLdVEK5p0I24c9pvG+
	3OaR6h7n1RUg3SU4F+V9HOFVTeFMB36RtoGeEzIoMoQ1UnCs5gkdVJFfioc=
X-Google-Smtp-Source: AGHT+IEcZ7IWwbzk7Cr79F+9XAqiUrbefLCmZGtZDQW6QXzoOs2RilX/320awuYADG21Cf4HFNqMFg==
X-Received: by 2002:a05:6e02:370a:b0:3dd:a13c:603e with SMTP id e9e14a558f8ab-3de07d0cd09mr149833125ab.14.1750164480957;
        Tue, 17 Jun 2025 05:48:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de01a4ae11sm24255875ab.52.2025.06.17.05.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 05:48:00 -0700 (PDT)
Message-ID: <c655293b-b2da-497b-98a6-05399fd120f8@kernel.dk>
Date: Tue, 17 Jun 2025 06:47:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING: ODEBUG bug in io_sq_offload_create
To: syzbot <syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Penglei Jiang <superman.xpt@gmail.com>
References: <6851237a.a70a0220.395abc.0208.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6851237a.a70a0220.395abc.0208.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 2:12 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8c6bc74c7f89 Merge tag 'v6.16-rc1-smb3-client-fixes' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1745710c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1ab5c40b21ee326a
> dashboard link: https://syzkaller.appspot.com/bug?extid=763e12bbf004fb1062e4
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ea3d70580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c5710c580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8c6bc74c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b523997774df/vmlinux-8c6bc74c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/da5178f1b34a/bzImage-8c6bc74c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com
> 
> R13: 0000000000000002 R14: 00007fad89109ab1 R15: 00007fad8910601d
>  </TASK>
> ------------[ cut here ]------------
> ODEBUG: free active (active state 1) object: ffff888024813bd0 object type: rcu_head hint: 0x0
> WARNING: CPU: 0 PID: 5941 at lib/debugobjects.c:612 debug_print_object+0x1a2/0x2b0 lib/debugobjects.c:612
> Modules linked in:
> CPU: 0 UID: 0 PID: 5941 Comm: syz-executor101 Not tainted 6.16.0-rc1-syzkaller-00236-g8c6bc74c7f89 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:debug_print_object+0x1a2/0x2b0 lib/debugobjects.c:612
> Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 54 41 56 48 8b 14 dd 00 8a 15 8c 4c 89 e6 48 c7 c7 80 7e 15 8c e8 bf 33 99 fc 90 <0f> 0b 90 90 58 83 05 56 99 c6 0b 01 48 83 c4 18 5b 5d 41 5c 41 5d
> RSP: 0018:ffffc90003f8fa78 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff817ae248
> RDX: ffff88803cd0a440 RSI: ffffffff817ae255 RDI: 0000000000000001
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8c158520
> R13: ffffffff8baeb4a0 R14: 0000000000000000 R15: ffffc90003f8fb78
> FS:  00007fad890686c0(0000) GS:ffff8880d6753000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fad8911b362 CR3: 0000000031b29000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
>  debug_check_no_obj_freed+0x4b7/0x600 lib/debugobjects.c:1129
>  slab_free_hook mm/slub.c:2312 [inline]
>  slab_free mm/slub.c:4643 [inline]
>  kmem_cache_free+0x2ac/0x4d0 mm/slub.c:4745
>  put_task_struct include/linux/sched/task.h:145 [inline]
>  put_task_struct include/linux/sched/task.h:132 [inline]
>  io_sq_offload_create+0xe4b/0x1330 io_uring/sqpoll.c:517
>  io_uring_create io_uring/io_uring.c:3747 [inline]
>  io_uring_setup+0x1514/0x2120 io_uring/io_uring.c:3830
>  __do_sys_io_uring_setup io_uring/io_uring.c:3864 [inline]
>  __se_sys_io_uring_setup io_uring/io_uring.c:3855 [inline]
>  __x64_sys_io_uring_setup+0xc2/0x170 io_uring/io_uring.c:3855
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fad890b6f99
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 1b 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fad89068208 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007fad891393c8 RCX: 00007fad890b6f99
> RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000004d25
> RBP: 00007fad891393c0 R08: 00007fad89067fa6 R09: 0000000000003232
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fad89068210
> R13: 0000000000000002 R14: 00007fad89109ab1 R15: 00007fad8910601d
>  </TASK>

Looks like fallout from a fix in the 6.16 kernel series, where:

commit ac0b8b327a5677dc6fecdf353d808161525b1ff0
Author: Penglei Jiang <superman.xpt@gmail.com>
Date:   Tue Jun 10 10:18:01 2025 -0700

    io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()

moves task_struct error handling to io_sq_thread(), but misses that
io_sq_offload_create() does it too for tctx allocation failure.

#syz test: git://git.kernel.dk/linux.git syztest

-- 
Jens Axboe



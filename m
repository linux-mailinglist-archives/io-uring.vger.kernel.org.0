Return-Path: <io-uring+bounces-1366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5FE895C06
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 20:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FE751C22EB6
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 18:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B80615B12B;
	Tue,  2 Apr 2024 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtVtv5TB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C1F15AAAA;
	Tue,  2 Apr 2024 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712083910; cv=none; b=jJjkrHvdhepWQIX3TAx/UhPaNlodD8uKp0mYB+JKD/t+VkxJI62ivh9LksGChIR5o49s1o75aE7t1V9tJF0a2F5tPotncRKfDTcZ2McWgnBmpHGCpeaDjeL5nmTQT2BEpZikUE7Yy4M9ugm6JLKM8rvcQdGiEOJmo+iIBGQLYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712083910; c=relaxed/simple;
	bh=YQ7U6cn6u0tgGS9pZaMG6ENwjqekG6L0CBw4q26axwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dkXQlQBvTNS1AdTt3o8Ddzqo7Cn2492e/asa2KGQCX7Y5coN9uKM4SiF+WshjuxA+9WzX40UYjKxqJfyj5Pnq0WZfS7cT/NvzTWMTGwrvlVcQrLxOqa6DrGr0jcsQec0FMz0ckSDF4DAQD9W4PnTWK1jBEPGJsYyMIa1WRI5JU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtVtv5TB; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a450bedffdfso628881866b.3;
        Tue, 02 Apr 2024 11:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712083907; x=1712688707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Iy3O6LTjnTGETz4d3hkbMgo1SLP2OZrb9HVZvCzUp7c=;
        b=FtVtv5TBA6Xqbeo1iJ2fUZ3IONReplwnqhEIxdCb7lcXInnkSNPYHzhQxXBAWkMkZg
         BEStheaRODPxEiuFPivLhmt4MJsk8Qx9ATAX7V7W6thZxxLw2kDrnPsF+tzLux++xy9i
         IN4YeWjRRLtw57MM5l9lpPLDJPeBVriviwtsiOvCyjyIGZusnhuHsfOv7SH28rpxCwJa
         C9gAjQlZ4zH2cd5b1OD+MNbOvfV6rpi0ySTjUAH/StNVVuJCOuR6VGXxxG37qgq0mkBd
         y61MOZv9Kj77ZsY2v9dCkInEhfi1c4fs2cU6qfXhyy3I9kwANYnFQvLZ4zAClgRcfnHm
         Y8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712083907; x=1712688707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iy3O6LTjnTGETz4d3hkbMgo1SLP2OZrb9HVZvCzUp7c=;
        b=T1v4KRqoDDJVDh9/hvuFK+Pwf1MFf+ZtOIPe+fjjAvf4LwXL7a9IkBRcTAzd0LSj/R
         BWUarMa0E6Pi5dl39czoVjCDPQk1oliiRT98pu4kgWEXjOI7ZO8tUdYYUBaaMLHJotY3
         3magiB/askgeWziVjSo0e69h9FMfBIUuXV3QP2kY8hWeMWVfOHH+g67+GuTLClF7u0X3
         OsaIYsbfNl++97rTwapHG2HO4WlsTczo/V41Yd2KJuGG8S+Dc5tLN0bNCCfPx4sKGcKk
         j03SIqapNugG/CTefZ8fKFenLx8d1hGXG1llToOT/+3mRGlCztnyowGEIR3xzpdC6wkB
         iJ/w==
X-Forwarded-Encrypted: i=1; AJvYcCXxszs6+INd20X3WKb6b9wSoT2moP/8TgN9gN6jTNoWKrskC/1Bph7bleEJYBcpnTAKOUBSoEDRx6HpP0h5MLeroyv6yWU1oiguXp5/PHW/EVE9lEEH2pAkRFIZ/XY8TFhftFGiAsQ=
X-Gm-Message-State: AOJu0Yx5WKZwfGYTskGaLmPexC63PSu2HJj0i6MB3cMIw5H5hDPaLZos
	3l2n4a+FHMBqQ0EFOeP4rt4H40nN8sx9GtmVI4VauTq4YfsvB0zp
X-Google-Smtp-Source: AGHT+IGs0G7NKBQJf9LMqVkSQRCIKKQzbAORqEDXMNoS8wJ9N5iuVyTlnchwz9T0FFx5D5uo1MZFdw==
X-Received: by 2002:a17:906:a3d4:b0:a47:31c8:81f5 with SMTP id ca20-20020a170906a3d400b00a4731c881f5mr410695ejb.47.1712083906534;
        Tue, 02 Apr 2024 11:51:46 -0700 (PDT)
Received: from [192.168.42.163] ([148.252.147.117])
        by smtp.gmail.com with ESMTPSA id l3-20020a1709067d4300b00a466af74ef2sm6822622ejp.2.2024.04.02.11.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 11:51:46 -0700 (PDT)
Message-ID: <a801e5e8-178b-41c5-bf76-352eabcabf45@gmail.com>
Date: Tue, 2 Apr 2024 19:51:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in put_page
To: syzbot <syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <0000000000002464bf06151928ef@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000002464bf06151928ef@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/24 09:47, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

gmail decided to put it into spam, replying for visibility
in case I'm not the only one who missed it.



> HEAD commit:    c0b832517f62 Add linux-next specific files for 20240402
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1737bfb1180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=afcaf46d374cec8c
> dashboard link: https://syzkaller.appspot.com/bug?extid=324f30025b9b5d66fab9
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ce85b1180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139fe0c5180000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0d36ec76edc7/disk-c0b83251.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6f9bb4e37dd0/vmlinux-c0b83251.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2349287b14b7/bzImage-c0b83251.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com
> 
>   reset_page_owner include/linux/page_owner.h:25 [inline]
>   free_pages_prepare mm/page_alloc.c:1110 [inline]
>   free_unref_page+0xd3c/0xec0 mm/page_alloc.c:2617
>   __folio_put_small mm/swap.c:119 [inline]
>   __folio_put+0x22b/0x390 mm/swap.c:142
>   io_mem_alloc_single io_uring/memmap.c:55 [inline]
>   io_pages_map+0x25a/0x480 io_uring/memmap.c:76
>   io_allocate_scq_urings+0x3b8/0x640 io_uring/io_uring.c:3432
>   io_uring_create+0x741/0x12f0 io_uring/io_uring.c:3590
>   io_uring_setup io_uring/io_uring.c:3702 [inline]
>   __do_sys_io_uring_setup io_uring/io_uring.c:3729 [inline]
>   __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3723
>   do_syscall_64+0xfb/0x240
>   entry_SYSCALL_64_after_hwframe+0x72/0x7a
> ------------[ cut here ]------------
> kernel BUG at include/linux/mm.h:1135!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 0 PID: 5084 Comm: syz-executor990 Not tainted 6.9.0-rc2-next-20240402-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
> RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
> RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
> RIP: 0010:put_page+0x1b6/0x260 include/linux/mm.h:1581
> Code: 00 00 e8 6d 25 61 fd 84 c0 74 6e e8 c4 a6 ed fc e9 3f ff ff ff e8 ba a6 ed fc 4c 89 f7 48 c7 c6 a0 12 1f 8c e8 bb ea 36 fd 90 <0f> 0b e8 a3 a6 ed fc e9 a1 fe ff ff 4c 89 f7 be 08 00 00 00 e8 11
> RSP: 0018:ffffc9000353fc30 EFLAGS: 00010246
> RAX: bf727e5c3e70b300 RBX: ffffea0000446034 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
> RBP: 0000000000000000 R08: ffffffff8fa934ef R09: 1ffffffff1f5269d
> R10: dffffc0000000000 R11: fffffbfff1f5269e R12: 1ffff1100c8c9518
> R13: ffff888064636000 R14: ffffea0000446000 R15: ffff88806464a8c6
> FS:  00005555716a0380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe2349d29f0 CR3: 0000000022106000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   io_pages_unmap+0x1c0/0x320 io_uring/memmap.c:108
>   io_rings_free+0xcf/0x2b0 io_uring/io_uring.c:2619
>   io_allocate_scq_urings+0x41f/0x640 io_uring/io_uring.c:3437
>   io_uring_create+0x741/0x12f0 io_uring/io_uring.c:3590
>   io_uring_setup io_uring/io_uring.c:3702 [inline]
>   __do_sys_io_uring_setup io_uring/io_uring.c:3729 [inline]
>   __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3723
>   do_syscall_64+0xfb/0x240
>   entry_SYSCALL_64_after_hwframe+0x72/0x7a
> RIP: 0033:0x7fe234a0f9d9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc53bc7168 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fe234a0f9d9
> RDX: 00007fe234a0f9d9 RSI: 0000000020000000 RDI: 0000000000006839
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe234a59036
> R13: 00007ffc53bc71a0 R14: 00007ffc53bc71e0 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
> RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
> RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
> RIP: 0010:put_page+0x1b6/0x260 include/linux/mm.h:1581
> Code: 00 00 e8 6d 25 61 fd 84 c0 74 6e e8 c4 a6 ed fc e9 3f ff ff ff e8 ba a6 ed fc 4c 89 f7 48 c7 c6 a0 12 1f 8c e8 bb ea 36 fd 90 <0f> 0b e8 a3 a6 ed fc e9 a1 fe ff ff 4c 89 f7 be 08 00 00 00 e8 11
> RSP: 0018:ffffc9000353fc30 EFLAGS: 00010246
> RAX: bf727e5c3e70b300 RBX: ffffea0000446034 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
> RBP: 0000000000000000 R08: ffffffff8fa934ef R09: 1ffffffff1f5269d
> R10: dffffc0000000000 R11: fffffbfff1f5269e R12: 1ffff1100c8c9518
> R13: ffff888064636000 R14: ffffea0000446000 R15: ffff88806464a8c6
> FS:  00005555716a0380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000556f47e67058 CR3: 0000000022106000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

-- 
Pavel Begunkov


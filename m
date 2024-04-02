Return-Path: <io-uring+bounces-1367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F274895C09
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 20:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 625661C20A7E
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 18:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF6115B129;
	Tue,  2 Apr 2024 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnWdzJXw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807115AAAA;
	Tue,  2 Apr 2024 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712083994; cv=none; b=E0MZ18YRB5PpKi3Pgh8QFgQGwpC3xvSKqsXcg6NJL0kJxz9zcn4GS+hEQFw4n2p7+Kua4p0vqFYyKHvVQVHyVmE/CfC/F7+hV0bEVbxWFb2qdz9S/PBLZNJ8tGPVbxuTB0GAlnNz+52rUBfG40mECp4WeWIanqvy7YXu6qf4yZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712083994; c=relaxed/simple;
	bh=s2Sld41mW3Q/yf52GDT1gj8bGXDBkJ7JQZeZzh4FWCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kgxRe0gYl22lUFucy9kYjGYS9WZJKg4ZO9bKeRTT8Jk7Bxs5MrtF76hfgjfNZU6cb2UxA4bLELwEpXAV5c54VLixwxGnsMqbAS20OMjxdPQXcFnxkzOnhWZwjZeNz8wzQE4OxyfhIobth0BxEwVi/LprTneirtnEf9JFn/rcF/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnWdzJXw; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a46ea03c2a5so31104366b.1;
        Tue, 02 Apr 2024 11:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712083991; x=1712688791; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lj4ZI2wsdTrMvhungIgInwMNXCkijPKLj2pa8x8wrSQ=;
        b=fnWdzJXwUlou5YDgeEzxmm8tCqpk3JBxA18370MgNS1f9GtTd10JPOCDUjMyjhl6q8
         PXq7RgL7xLT80ACUunz/CdLLmzkBC2LdHrVb8e1v/0LLTQrAe/jnF+i66v6IAW+/K3lX
         F4WieCDVWbhoR5OR1ujH3K8OyJq3lhPIoCX6Yjwmj99sqAmLFzlm608PJpR6Ybu5CXiq
         cAG1QXQCipRhNtxftWiogKBv8WyZ46cGLVazzAthCHKU3ZFWdqv6iB/VD5nJUGszx+fN
         MdtkiaBUMCBWAFabzf9XmJ/g9nJE1J2CFwglgjq8zGNofKjAaTRpqew4IAo1+cz6/U0v
         iUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712083991; x=1712688791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lj4ZI2wsdTrMvhungIgInwMNXCkijPKLj2pa8x8wrSQ=;
        b=RVzzCeuJK4Y1lHy8AZVeo/BvdAW+sflNxLc//ofXxNAZOHgPAq5e9kWgiVMY6xccHE
         51A5mOl8rV+H1wC2UReILMAUg7SqAzHiLd6mpDGGFefGql2MGWdK8DlUBhA3jx+fp7Sw
         MQYNVxI6osABd8eDpvttSPjS3zoo2/DzMO4HkSwdd6KmPHBjw6txRyr0I1VKVoQmUclG
         0StKxdVHGhFsHJveQm65dx6foqSDXlKW/fqN76SJYq1sEgBqDE3IECoCBMowxwiCTmSZ
         6pLdQXqU2RnMHnTlmTrsQCH/3ltyMrMu1sUf97CXJKNzE2pOduu9LZt+aRaxrghGBMEn
         KcRA==
X-Forwarded-Encrypted: i=1; AJvYcCX8ewZ0OvsKU7FXMfm+G3nbjPz6I5vOSM14NjHDOshLU9wLkQY9qpdLnAHijhPh6q1qV0WRu76jjaDg52Wzny4k3elVdIW7I1WuAZCPHkk/4p/aFx8yKclmtVHSGIj9Xfk+qqmu4WI=
X-Gm-Message-State: AOJu0Yzus9DcEjOPixQg0KP4p9rw6zZQqTa7AEljtKsXtE6r7gH5IHgf
	23tqbUvQxB730r04mPF7OHdcCdqzlxDv315Uxu+YAklaAOWzQmpu
X-Google-Smtp-Source: AGHT+IF9KMN80hNXx36iQhnCpsJsvPGxjviC1XQG0N/tOkzQMDNCqV2RHd/JTLckqFmbwFMTMRWVCA==
X-Received: by 2002:a17:907:3e1d:b0:a4e:410e:9525 with SMTP id hp29-20020a1709073e1d00b00a4e410e9525mr361552ejc.30.1712083990950;
        Tue, 02 Apr 2024 11:53:10 -0700 (PDT)
Received: from [192.168.42.163] ([148.252.147.117])
        by smtp.gmail.com with ESMTPSA id bw17-20020a170906c1d100b00a46b4544da2sm6779271ejb.125.2024.04.02.11.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 11:53:10 -0700 (PDT)
Message-ID: <6816efda-dc85-4625-a396-1fa6c523db2e@gmail.com>
Date: Tue, 2 Apr 2024 19:53:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in __io_remove_buffers
To: syzbot <syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000f3f1ef061520cb6e@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000f3f1ef061520cb6e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/24 18:54, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

Got into spam again as with the last one, replying
just for folks to see.

> 
> HEAD commit:    c0b832517f62 Add linux-next specific files for 20240402
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d5def9180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=afcaf46d374cec8c
> dashboard link: https://syzkaller.appspot.com/bug?extid=beb5226eef6218124e9d
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1155ccc5180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b06795180000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0d36ec76edc7/disk-c0b83251.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6f9bb4e37dd0/vmlinux-c0b83251.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2349287b14b7/bzImage-c0b83251.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com
> 
>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
> ------------[ cut here ]------------
> kernel BUG at include/linux/mm.h:1135!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 0 PID: 12 Comm: kworker/u8:1 Not tainted 6.9.0-rc2-next-20240402-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
> RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
> RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
> RIP: 0010:put_page include/linux/mm.h:1581 [inline]
> RIP: 0010:__io_remove_buffers+0x8ee/0x8f0 io_uring/kbuf.c:196
> Code: ff fb ff ff 48 c7 c7 3c 68 a9 8f e8 fc b6 56 fd e9 ee fb ff ff e8 12 dc f1 fc 48 89 ef 48 c7 c6 60 ff 1e 8c e8 13 20 3b fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
> RSP: 0018:ffffc90000117830 EFLAGS: 00010246
> RAX: 12798bbc5474ca00 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
> RBP: ffffea0000880c40 R08: ffffffff92f3a5ef R09: 1ffffffff25e74bd
> R10: dffffc0000000000 R11: fffffbfff25e74be R12: 0000000000000008
> R13: 0000000000000002 R14: ffff88802d20d280 R15: ffffea0000880c74
> FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200020c4 CR3: 000000007d97a000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   io_put_bl io_uring/kbuf.c:229 [inline]
>   io_destroy_buffers+0x14e/0x490 io_uring/kbuf.c:243
>   io_ring_ctx_free+0x818/0xe70 io_uring/io_uring.c:2710
>   io_ring_exit_work+0x7c7/0x850 io_uring/io_uring.c:2941
>   process_one_work kernel/workqueue.c:3218 [inline]
>   process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3299
>   worker_thread+0x86d/0xd70 kernel/workqueue.c:3380
>   kthread+0x2f0/0x390 kernel/kthread.c:388
>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
> RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
> RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
> RIP: 0010:put_page include/linux/mm.h:1581 [inline]
> RIP: 0010:__io_remove_buffers+0x8ee/0x8f0 io_uring/kbuf.c:196
> Code: ff fb ff ff 48 c7 c7 3c 68 a9 8f e8 fc b6 56 fd e9 ee fb ff ff e8 12 dc f1 fc 48 89 ef 48 c7 c6 60 ff 1e 8c e8 13 20 3b fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
> RSP: 0018:ffffc90000117830 EFLAGS: 00010246
> RAX: 12798bbc5474ca00 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
> RBP: ffffea0000880c40 R08: ffffffff92f3a5ef R09: 1ffffffff25e74bd
> R10: dffffc0000000000 R11: fffffbfff25e74be R12: 0000000000000008
> R13: 0000000000000002 R14: ffff88802d20d280 R15: ffffea0000880c74
> FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f31a71870f0 CR3: 000000007930c000 CR4: 00000000003506f0
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


Return-Path: <io-uring+bounces-12111-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFuJGDZBimmKIwAAu9opvQ
	(envelope-from <io-uring+bounces-12111-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 21:19:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B42791145ED
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 21:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A70B301DB9C
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 20:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E02F333426;
	Mon,  9 Feb 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="prR7mMd/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9A4331A5F
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770668287; cv=none; b=FPgnR1tlVajR+Y17HGmP8eNq/g/Xy5ico1q1QEqoxY095fPrKDVfGS/A9UsDYQeHH6b8Fn4OriCsCEVfOO2LlADO6t7kFEAGpESjKaMvcKQoBEtITc18G+8CWrNIZOJQWL/+uUwIf4CTyfC9aXUv+xk/B5u1Ll2SBtBoXJNS8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770668287; c=relaxed/simple;
	bh=IJwdLydSXuOsSV/s2G7EBOzBXGvGnB7qCApA1SIsFak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d/n85vfag0cu+9jZ3yA4x7/5fjKBO6uE11YevLiGaX7jESmw8ZZ1G/NLs/ybddGR1TfxFppSqTeuHSvISUa4VXEtCiAkWg2akWqoA0BDaniv0G6kJDBZrfRv3FQlUEVwQrPKYn1KXhdOcTbKnd+hP/rLegRq2PcApd5lPEIhWkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=prR7mMd/; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d1890f7cefso128429a34.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 12:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770668285; x=1771273085; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C5oTgZ0FGRmcY3SY1Rn7CE8w7Ml/es9Z/zuKzPR+wHw=;
        b=prR7mMd/XyAJ9D5qnvHzD3+TgXuutDAXgnvF1AfpMBcX1quo2/3t9ZKN64NhbnLozp
         MSI3b+EEESyikEQNUqSP6jFHhmBWDogCmM+otXlVIuF5cyD5ZesD9IjAS3jEvpxwNEj9
         1vr4PLNUpcxvzha2+EvGJWcHQIFVa1Pe1Vu9+CAnbixW/PyjAJczopjTkgdXRdA9YZ58
         yOCjkabtE0KehvlFUDbYYL5w6N9CHFfCPTGI/CUCAqG2qSjSocUHxHNaUnoxn+b8W+wM
         oI7/jWjfjfngU6AAJ6rikF8qedzjFdA0OEsGl5aIXQZ0Wbatn5qkNSUbgKKQLuJ0WVIs
         R73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770668285; x=1771273085;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C5oTgZ0FGRmcY3SY1Rn7CE8w7Ml/es9Z/zuKzPR+wHw=;
        b=h2MM+rCzDKIkJYo5Av28vViRSdN06JVwdi8bo/GPvzscCDmaEVbZt9TNK0XWoKDeAQ
         trhE7KFuAtandnuBDUBO/tx4ONH5RmaoszQaCAzQQ2xW7K+bK2KGA8yAzv263QvOfod/
         KikEY6xSYc5+5DbvdHR17MW2LebIc8i2gWPS8FcuPZWcOariti3i5LaDg7punBZxN/UT
         OaCf119AonC0DPnKEedfIueCFVgwVh+wx3cPF+4xIxYbxE0n8MMxLFLSAcMqEXbKnMpm
         RqzEwIWpmkPmIau3Ni1VIsioiXBT9uc2t/vv8UaPvvK9eJD9CIBkFPXfZaro7RhYqQwX
         QNeg==
X-Forwarded-Encrypted: i=1; AJvYcCUdlqoYsqloCh8mw4uvxdjU9cBXg5kYosnfziDrkic+esrbJEuzNgMNpjHgkWM9z+a1/PF7AKUBPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2iV8y2PMfW7dO1g6Q7//JPt7kC+UdNpqQZXu5oT2hqChFRmvz
	Zz51WAD2CO3MUSu6XW2hQbWsL4tTm7v1SfT5+XkiAc6M8BXjKlcB5pvT6x+8r2pYYPw=
X-Gm-Gg: AZuq6aKIxQdf5SuUEH8xhwSQetztjmLi4TOJkEIrYkq+HaA1JN9P2HnvQQJrxtPrCey
	xyxPwz9E77bJ/MhFSjxZcnngUXvoaeyqP3JXXsoTR9ntNfJ/cHGM5eJEekkWPAhja2uh+bXF8Vk
	bdGey0vPYRn/NoSMfV8vfjUwGOXf0zEvCVnW/w45yyeKv8C7PlBvEf1523ecT0ROuEHspC1hyIf
	/GprF1WzR2lDtGv3etuO9d77aglP1tPq92hsn1Qmh48ve/d2xNRrHe/IF4KZZJcIxnde5RLfgZ3
	9ueRNGSoWi+tVMsTleVTcASQHHgKGJaBbqRq3pjMQFopoHJVD98KwIeAMLuEc1qTv9/vsKAnLJd
	5ARneKKje6OHu4ns6FzfxDQEjIrEkMaiiDvJUpVuD1ch5d+QME5eR8hvIGWupOv5juIEanHpK8+
	UZnqmfjsQSGZYuk6xQHKQ7GXljutoY3NIbIcdaeiuPL1ddS3kByZkmwTmeSOl6K32r27ZIdw==
X-Received: by 2002:a05:6830:6994:b0:79c:f9ff:43e with SMTP id 46e09a7af769-7d46467e812mr6258361a34.28.1770668285082;
        Mon, 09 Feb 2026 12:18:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d464785fcasm7885861a34.17.2026.02.09.12.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 12:18:04 -0800 (PST)
Message-ID: <23112bc4-a498-4089-a225-1440c2151ce2@kernel.dk>
Date: Mon, 9 Feb 2026 13:18:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: corrupted list in
 io_poll_remove_entries
To: syzbot <syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
 linux-media@vger.kernel.org
References: <698a26d3.050a0220.3b3015.007d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <698a26d3.050a0220.3b3015.007d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12111-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,kernel.dk:mid,syzkaller.appspot.com:url,kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,storage.googleapis.com:url];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,ab12f0c08dd7ab8d057c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: B42791145ED
X-Rspamd-Action: no action

On 2/9/26 11:26 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d3b65a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
> dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1222965a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140e833a580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c46beb4ff3a5/disk-e7aa5724.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d162bcaaf9b9/vmlinux-e7aa5724.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/54b0844b8ea7/bzImage-e7aa5724.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
> 
> list_del corruption. prev->next should be ffff88807dc6c3f0, but was ffff888146b205c8. (prev=ffff888146b205c8)
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:62!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __list_del_entry_valid include/linux/list.h:132 [inline]
>  __list_del_entry include/linux/list.h:223 [inline]
>  list_del_init include/linux/list.h:295 [inline]
>  io_poll_remove_waitq io_uring/poll.c:149 [inline]
>  io_poll_remove_entry io_uring/poll.c:166 [inline]
>  io_poll_remove_entries.part.0+0x156/0x7e0 io_uring/poll.c:197
>  io_poll_remove_entries io_uring/poll.c:177 [inline]
>  io_poll_task_func+0x39e/0xe30 io_uring/poll.c:343
>  io_handle_tw_list+0x194/0x580 io_uring/io_uring.c:1122
>  tctx_task_work_run+0x57/0x2b0 io_uring/io_uring.c:1182
>  tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1200
>  task_work_run+0x150/0x240 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x829/0x2a30 kernel/exit.c:971
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
>  x64_sys_call+0x14fd/0x1510 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f60e579aeb9
> Code: Unable to access opcode bytes at 0x7f60e579ae8f.
> RSP: 002b:00007ffc2d47ddf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f60e579aeb9
> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f60e59e1280
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f60e59e1280 R14: 0000000000000003 R15: 00007ffc2d47deb0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0

#syz test

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 8c6f5aafda1d..5cb46109d1ff 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -168,7 +168,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 			mutex_unlock(&dmxdev->mutex);
 			return -ENOMEM;
 		}
-		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
+		dmxdev->dvr_buffer.data = mem;
+		dmxdev->dvr_buffer.size = DVR_BUFFER_SIZE;
+		dvb_ringbuffer_reset(&dmxdev->dvr_buffer);
 		if (dmxdev->may_do_mmap)
 			dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
 				     file->f_flags & O_NONBLOCK);

-- 
Jens Axboe


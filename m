Return-Path: <io-uring+bounces-12110-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GKGBIksimkjIAAAu9opvQ
	(envelope-from <io-uring+bounces-12110-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 19:50:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52978113D85
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 19:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2053302769C
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 18:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA983AEF5D;
	Mon,  9 Feb 2026 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t4/LgPMQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBC43AE6E0
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770663005; cv=none; b=kMU52SwwEeX9l5/nD+L5GURml7OEkPbni0pUG26M9nbI2RpKCdl+W0RryhycjehkmOrvmeuQ+gBkKjfjE4au0YnSyq7JksoZe+KNfYZdlyS+Ex3/p+BJ7VCH2LYKqYFTpg5KNRA68HBimnVDQ1ep+j6LFvMfRDvSCIG80+ngbl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770663005; c=relaxed/simple;
	bh=undCIAWo6qWW+Z1HOg8qlP6+G1FkpCs7G0WeQTxNGE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s9ZzmfbXm5ZW/b4jwpKnliDwz8SEWTYrOwnp1IOoHHxG9IgFhUtI8PRmgEcrU+RYQoKswOhTIdKCY1Ap4GZz7dUhPsx3yu/l+1wSoJU9lAGd48ItdJp5fauR55mrbLN/Qkpwtj0np88IszJDiiQ1Dz+SCq/Af3j/TsoVD3C5Exc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t4/LgPMQ; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7cfd9b898cdso34797a34.2
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 10:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770663004; x=1771267804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tYxV1ZZhF0FuP950hVsE38NKjm5LJ2udmADunvWNt+s=;
        b=t4/LgPMQIOf+ZNB3uBDthKw6azftbW9Btm5KFt8VuvCRJlmSCyP7PJFnrf1XzCiHgQ
         YzD7zsorl3YdHXqFGjDkQiUQSY53Mac1ESu9I/DOpfyFhd/1SPkzlD5XaLpzYydYgeZY
         DtDVAQGA6Bq27AXMgZV5m6SC2kjYaCBlgHfIWQ+OPh7npVtRVN+OAtdpt4ApvXXroeql
         Pc52RomB99ti17lhu5cka7t7DwpZM/ZWetwWLgBWE2tV+emF0orVSHfGaywibOAO+seU
         ZSfR9x2MN1cBwslC9NfaHngbBhthvlcmpJEEvH9yhrfewRdGZbMIJBFaR17NolrmxuTW
         Nxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663004; x=1771267804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tYxV1ZZhF0FuP950hVsE38NKjm5LJ2udmADunvWNt+s=;
        b=otw6LEvcDdEcFpsTDm1e7PMRKHXpLUz4JwPOgiWKvgknZmXBzcpxDPzRpgSHXllfLJ
         2xYnWUmnGtk8moHhPRH5vVVVdjbyh0Jp2gBn7sgzBgbq+jffDNqhW0dYBz/tuDCoS6QP
         s4ZFImkv7Mn94oUalxC/B7klUap6Qvhxq3jY27iJE3tO7BtxZSutwF0SlGptfRsSQ3d/
         ZVNCcgWZ7KWMvb78U2Kasql4umdxHKEYx1lRxVwH1yAUTzVl/r8nJOegzMepi//FxU9G
         LWUjCOu8NEYT4J8KisuKAa6a+/6hLZNruLVO8PtYl/0L7ARRzQ0dxc5Kk7X1RvIb/vsm
         beEg==
X-Forwarded-Encrypted: i=1; AJvYcCVZKAhcAxU6Q81k+vEZ+/8NXXFQ6SgrjNzpAkp5xHH3QDacKCAmGoJbM3vYxd2x63tp3+bjJK66Kg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrc7FhbSjVnhr9/1pRyqRg78Orna7/iVTxSOR6sk+rtNFW5P1+
	gwdQApMqV9lkL3B1FRc9Ph7CVhU3hOv5rM0DWyvYJIJ/y43Xhgo+4DWUndDkO8P4/UToEq9SADf
	FK9jIaa4=
X-Gm-Gg: AZuq6aK4v5nV4d40CVgdrH3roOcMZtjjl0P92Nju/vZhwubEr+mFx7lXXq7OdijMJYu
	w2bQBcXVoyPbMjkqDd9YbdxIcIhPrIEPnFiMliocilH7a9YHbzDAJZ9BlzCQCFATFnRgzl8A0cI
	8sbtU+R3/euehD+1vr5+VbRz/ccrinVDmkXJvDDGFMzZSe37tHdlefJuLN6gp6u+YhIclKvvb9m
	0rVZqCs4ofwmZ8E3vHYruG3HoaO+98EUd1Z/0HVs2OU135hxYVALXdyOGCyBQ9/Alg6w11Yk+7o
	Q+mMfcl0A7kv35+x7m9dWJfVIQ8LhP6X8GSF+dYagnpkavaZTRsBHshF60EMmX0CwRUKYE+ipKy
	e/+0EarTjpVJUtNZTgJY8A8zkZQdXHSgpwd9rDJeJdu91Du7BS4znlBkObgX/E9UQiH/qYTC5pw
	Tao+EgYIO8Y6QzFBP+h6dSygdHokCkaYWU/lG8Lnt8e9AaVB6D6nCb0fzIKXVDt26K16ME1Q==
X-Received: by 2002:a05:6830:6994:b0:79c:f9ff:43e with SMTP id 46e09a7af769-7d46467e812mr6111729a34.28.1770663003431;
        Mon, 09 Feb 2026 10:50:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4647277a4sm7929198a34.13.2026.02.09.10.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 10:50:02 -0800 (PST)
Message-ID: <e6f8da96-6920-434d-9f15-6e283bf3c829@kernel.dk>
Date: Mon, 9 Feb 2026 11:50:02 -0700
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12110-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,storage.googleapis.com:url,appspotmail.com:email,syzkaller.appspot.com:url,kernel-dk.20230601.gappssmtp.com:dkim];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 52978113D85
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

This looks like a bug related to dvb polling, presumably in dvb_dvr_poll()
or friends. I've seen that in drivers before, for example comedi, see:

commit 35b6fc51c666fc96355be5cd633ed0fe4ccf68b2
Author: Ian Abbott <abbotti@mev.co.uk>
Date:   Tue Jul 22 16:53:16 2025 +0100

    comedi: fix race between polling and detaching

as a reference.

#syz set subsystems: media

-- 
Jens Axboe



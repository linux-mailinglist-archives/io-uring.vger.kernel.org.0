Return-Path: <io-uring+bounces-12113-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kE4AEvBZimnnJgAAu9opvQ
	(envelope-from <io-uring+bounces-12113-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 23:04:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A3563114F62
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 23:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 24DE0300809A
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 22:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181E12D9ECB;
	Mon,  9 Feb 2026 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ladGQrEM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9452E764D
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 22:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770674666; cv=none; b=erPT/47/6gS02rfUSG1gQRYIKas9LwNcf+CNX71RJxrSUoxF8OI0YM4geT2IfPjWrUGfglq1GE3+axsoZD5BeZzttkCzg+/H/3YWMCuOysl+bRKalOlEX047JTXhWw+5KMguxohX8r49lYFfktmz+BhGBAWJ297pYZFFdsDLeUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770674666; c=relaxed/simple;
	bh=sg9i6EbR3opqzhIfz2zDRSTLPBwOL8szFxvxPWiswzo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=nQJ0nwkZZwapTB62ZNFFw7iws6z+9OtL5Va5dX05DaCqe9LHfUXdT0J5kueXJ/Aaw/UJIQAU450JhON23F1DvOOfuF/hrM4Xlj9pbta+plFyCtWqXctxIt8HwCW7YSzmxonrly2iq+R1MqWtUohFJLv/2LQBECF2QVHYQH/IXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ladGQrEM; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-3f9ebb269c3so2306479fac.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 14:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770674661; x=1771279461; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqalBd1i+2sp9rJIkOfh/aaeHsqLHRAKGG+Rqctmir8=;
        b=ladGQrEMZ7fgNXvqmbeXFeDXbNb+fY/IcQNK6MiaJnYs3RUCxUpWUu71eWZKjQ2xw/
         nhnvVFGwutm+86TaXKZmCXPx6lTkSc2Zu8CnqCH5qeZOaGK+0QuzLPjo2ys2vyhcL5Ar
         zMfrqPK156wMGEowW9HzA0xE1+c7tT4oWW0ew3eETQpCNY3ZeKpTrn1FaHQRn5gT8HgB
         TgUd2Fe0Z7gcquBnaHQYGXmk0Z/twNSZ96VJXJsBzA2DnDMP9KnIoqqAQ4LUKq/5m7Af
         QVx7QcbonP8Eszjafg4LEBzUCF83T963eMW3+OkNKjtpQW8oWLe5grebTnoTNMpRGaAu
         UkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770674661; x=1771279461;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RqalBd1i+2sp9rJIkOfh/aaeHsqLHRAKGG+Rqctmir8=;
        b=Mir5x+qvlBcKTpbKpDjD7Nq6ULlvVjqJ4/x3bUzj84FP48QRxMelM48YR5YvwuUf7P
         fNxXC6FHKDk+XXBJ3u+e8uqZo2tXklzRNdCv21WC5G5B6Wn9MWxF47LpKlUfhSmixfeb
         Lcb8+/0Ul/u9c3ZwWmIKAE41800oiPBpk3MBkdUME3//Jj+2/VNghROnGAN4H4exdO6A
         j1rF6Bq8Gt3l8WKpMjt/TguXK4JE8fJW83GsJPaZfHlhGKMeSJIqjAsX9X2dcSLYaaf4
         BXAJx3ISPUXMdnrYLUZTPIqHlvKkBfg+8+0zl+trK8pDv6Esem1YClQpHBuXiD8uRyS8
         T9oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk2omiAqtYai1PPlm2uLnF7HE5KEcAvpf3htgtrW13onwqO+8GXqpATishQWo6BR9WbNjoV3MXKA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+65jj3vOjjDQZadTPCcSin2JsVGN5q1aEZYYgQqJTtdmpjK8B
	CnFjvnl7UNJb3FMYWaZ9h53pRt7Sf/jt4t2lFQQXPsy8ST+y1b28ewBIV6qo4FXHuYU=
X-Gm-Gg: AZuq6aJaQgqeF8PBgL+W/LM5iG9voUzUMKKu8pIeODZqFgFnRpkYCTheVppOHWaLZKe
	+R979R9l3IDgR7V7wFUGOS/DrOjn8pN275yPa6i7nyDt6A0ephaSJWzbJ5upGVS4xaGPx1IGvht
	70z2wuS/gYFPToG0EbcMMPklc3kXqJ7FbdcPmxrdahs+urYd+C38l1nlpmGF5Hd044dctqA3yXx
	T3oi3YlgaIl/bCZ1bHoEvD7Lh6gCxeLB8CXWIuOTNOwMn1ufHWgqrWHWcGbrKPZFEpzniiVuI0r
	eN8YdWR1V0MR0Ob9OgzrFGU8cqCDdXfxUpZQSRWP1GCwSFbMSoElheOSqA1uu4gdJ7BZ4tVeaIx
	JFOiVKlotuzskufcsc0RUVUd2HTn3mjYzheSQPpzNEmWn8zoUz43VR46mb+NijLbEU7bzai/9EJ
	x+GVSzi3q3vWkKqunZi7kP89ScI64dootVw3SFrsoDA+yeQX+/ogPx0rAd8AuRvzKIQ1y3rQ==
X-Received: by 2002:a05:6820:2d09:b0:662:c1a7:e166 with SMTP id 006d021491bc7-672fff0d6bdmr29090eaf.48.1770674661274;
        Mon, 09 Feb 2026 14:04:21 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3b2a6c16sm6592595eaf.16.2026.02.09.14.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 14:04:20 -0800 (PST)
Message-ID: <96e92028-88b0-4dfa-a468-ce1d602affd8@kernel.dk>
Date: Mon, 9 Feb 2026 15:04:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: corrupted list in
 io_poll_remove_entries
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
 linux-media@vger.kernel.org
References: <698a26d3.050a0220.3b3015.007d.GAE@google.com>
 <e6f8da96-6920-434d-9f15-6e283bf3c829@kernel.dk>
Content-Language: en-US
In-Reply-To: <e6f8da96-6920-434d-9f15-6e283bf3c829@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12113-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,storage.googleapis.com:url,qemu.org:url,appspotmail.com:email,kernel-dk.20230601.gappssmtp.com:dkim];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
X-Rspamd-Queue-Id: A3563114F62
X-Rspamd-Action: no action

On 2/9/26 11:50 AM, Jens Axboe wrote:
> On 2/9/26 11:26 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d3b65a580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
>> dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1222965a580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140e833a580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/c46beb4ff3a5/disk-e7aa5724.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/d162bcaaf9b9/vmlinux-e7aa5724.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/54b0844b8ea7/bzImage-e7aa5724.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
>>
>> list_del corruption. prev->next should be ffff88807dc6c3f0, but was ffff888146b205c8. (prev=ffff888146b205c8)
>> ------------[ cut here ]------------
>> kernel BUG at lib/list_debug.c:62!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>> CPU: 0 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
>> Call Trace:
>>  <TASK>
>>  __list_del_entry_valid include/linux/list.h:132 [inline]
>>  __list_del_entry include/linux/list.h:223 [inline]
>>  list_del_init include/linux/list.h:295 [inline]
>>  io_poll_remove_waitq io_uring/poll.c:149 [inline]
>>  io_poll_remove_entry io_uring/poll.c:166 [inline]
>>  io_poll_remove_entries.part.0+0x156/0x7e0 io_uring/poll.c:197
>>  io_poll_remove_entries io_uring/poll.c:177 [inline]
>>  io_poll_task_func+0x39e/0xe30 io_uring/poll.c:343
>>  io_handle_tw_list+0x194/0x580 io_uring/io_uring.c:1122
>>  tctx_task_work_run+0x57/0x2b0 io_uring/io_uring.c:1182
>>  tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1200
>>  task_work_run+0x150/0x240 kernel/task_work.c:233
>>  exit_task_work include/linux/task_work.h:40 [inline]
>>  do_exit+0x829/0x2a30 kernel/exit.c:971
>>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
>>  x64_sys_call+0x14fd/0x1510 arch/x86/include/generated/asm/syscalls_64.h:232
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f60e579aeb9
>> Code: Unable to access opcode bytes at 0x7f60e579ae8f.
>> RSP: 002b:00007ffc2d47ddf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f60e579aeb9
>> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f60e59e1280
>> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f60e59e1280 R14: 0000000000000003 R15: 00007ffc2d47deb0
>>  </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
> 
> This looks like a bug related to dvb polling, presumably in dvb_dvr_poll()
> or friends. I've seen that in drivers before, for example comedi, see:

As per the other email, I believe this analysis was correct. Here's an
epoll based reproducer for the same issue, showing the problem with dvb
blowing away poll waitqueues. Crash here:

list_del corruption. prev->next should be ff1100004a299148, but was ff1100004169c5c8. (prev=ff1100004169c5c8)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:62!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 10044 Comm: dvr-poll-repro Not tainted 6.19.0-g05f7e89ab973 #422 PREEMPT(full) 
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x178/0x280
Code: fc ff df 48 89 d1 48 c1 e9 03 80 3c 01 00 0f 85 07 01 00 00 48 8b 02 48 89 d1 48 c7 c7 40 44 1a 8c 48 89 c2 e8 39 d5 2e fc 90 <0f> 0b 48 89 cf 48 89 74 24 10 48 89 0c 24 48 89 44 24 08 e8 b0 2b
RSP: 0018:ffa000000c74fd30 EFLAGS: 00010082
RAX: 000000000000006d RBX: ff1100004a299130 RCX: 0000000000000000
RDX: 000000000000006d RSI: ffffffff81e76a0e RDI: fff3fc00018e9f97
RBP: ff1100004a299148 R08: ffffffff81e6f6f7 R09: 0000000000000001
R10: 0000000000000005 R11: 0000000000000000 R12: ff1100004169c588
R13: 0000000000000286 R14: ff1100004a354c00 R15: ff1100004a299120
FS:  00007f486cac8740(0000) GS:ff110000975d4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005599332e7fe0 CR3: 000000006a752000 CR4: 0000000000351ef0
Call Trace:
 <TASK>
 ? srso_alias_return_thunk+0x5/0xfbef5
 remove_wait_queue+0x28/0x1b0
 ep_remove_wait_queue+0x85/0x1d0
 ep_clear_and_put+0x186/0x420
 ? __pfx_ep_eventpoll_release+0x10/0x10
 ep_eventpoll_release+0x3e/0x60
 __fput+0x3fd/0xb40
 fput_close_sync+0x113/0x250
 ? __pfx_fput_close_sync+0x10/0x10
 __x64_sys_close+0x8b/0x120
 do_syscall_64+0xcb/0xf80
 ? srso_alias_return_thunk+0x5/0xfbef5
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f486cb5ceb2
Code: 18 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 1a 83 e2 39 83 fa 08 75 12 e8 2b ff ff ff 0f 1f 00 49 89 ca 48 8b 44 24 20 0f 05 <48> 83 c4 18 c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 10 ff 74 24 18
RSP: 002b:00007ffe5521f0b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f486cb5ceb2
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007ffe5521f140 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
R13: 00007f486cd0a000 R14: 00007ffe5521f298 R15: 00005643adab8dd8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x178/0x280
Code: fc ff df 48 89 d1 48 c1 e9 03 80 3c 01 00 0f 85 07 01 00 00 48 8b 02 48 89 d1 48 c7 c7 40 44 1a 8c 48 89 c2 e8 39 d5 2e fc 90 <0f> 0b 48 89 cf 48 89 74 24 10 48 89 0c 24 48 89 44 24 08 e8 b0 2b
RSP: 0018:ffa000000c74fd30 EFLAGS: 00010082
RAX: 000000000000006d RBX: ff1100004a299130 RCX: 0000000000000000
RDX: 000000000000006d RSI: ffffffff81e76a0e RDI: fff3fc00018e9f97
RBP: ff1100004a299148 R08: ffffffff81e6f6f7 R09: 0000000000000001
R10: 0000000000000005 R11: 0000000000000000 R12: ff1100004169c588
R13: 0000000000000286 R14: ff1100004a354c00 R15: ff1100004a299120
FS:  00007f486cac8740(0000) GS:ff110000975d4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005599332e7fe0 CR3: 000000006a752000 CR4: 0000000000351ef0

Reproducer:


#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <unistd.h>

#define DVR_PATH	"/dev/dvb/adapter0/dvr0"
#define NR_ITERATIONS	100

static int test_dvr_poll(int iter)
{
	struct epoll_event ev;
	int dvr_fd, dvr_fd2, epfd;
	int ret = -1;

	dvr_fd = open(DVR_PATH, O_RDWR | O_WRONLY);
	if (dvr_fd < 0) {
		perror("open " DVR_PATH);
		return -1;
	}

	epfd = epoll_create1(0);
	if (epfd < 0) {
		perror("epoll_create1");
		goto close_dvr;
	}
	memset(&ev, 0, sizeof(ev));
	ev.events = EPOLLIN;
	ev.data.fd = dvr_fd;
	if (epoll_ctl(epfd, EPOLL_CTL_ADD, dvr_fd, &ev) < 0) {
		perror("epoll_ctl ADD");
		goto close_ep;
	}

	dvr_fd2 = open(DVR_PATH, O_RDONLY);
	if (dvr_fd2 < 0) {
		perror("open " DVR_PATH " O_RDONLY");
		goto close_ep;
	}

	close(dvr_fd2);
	ret = 0;
close_ep:
	close(epfd);
close_dvr:
	close(dvr_fd);
	return ret;
}

int main(int argc, char *argv[])
{
	int i, iterations = NR_ITERATIONS;

	if (argc > 1)
		iterations = atoi(argv[1]);

	for (i = 0; i < iterations; i++) {
		if (test_dvr_poll(i))
			return 1;
	}

	return 0;
}

-- 
Jens Axboe


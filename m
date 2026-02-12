Return-Path: <io-uring+bounces-12174-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEdsG10bjWmkzAAAu9opvQ
	(envelope-from <io-uring+bounces-12174-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 01:14:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9D412875D
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 01:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E58A330A7054
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 00:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2E4E55C;
	Thu, 12 Feb 2026 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r58UNs+2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30D4A21
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 00:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770855250; cv=none; b=IxdXh5BKgJHsOT4Hqzwk6fjuzbyfAZ7KVwW84igVJoMD+tqSJLaOVCY66WzJ3ZTpcG+BT99loLLs6lUraZNV1qXz7/4yEkwlLqZaaJNkVH5b06avtrMfHLw8xp7F0OaTNj04FPr7iAzr27GVZHMlplgtsmflgJTvxP64O4EPdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770855250; c=relaxed/simple;
	bh=uflvyI7kYZB1YguZBsEgpXy/6ocNJAjHu0Tnf6RroD8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=QXZiIb5gYwVSoLfAuaeMbTJcn1NY6oIyHx/B3aa3xXBA7x54zJBXbFCKG/3cTuQjy/xXhzjnThvaXuNzFoVbxbM8qpSreFmDcVVpClzw2e+huSzZB241VLWjor59sUKyRoyNaoFIky0aLn5rVyWvF8BwTnFQ/FN/3z5idST/bvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r58UNs+2; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-40a62601731so4226030fac.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 16:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770855245; x=1771460045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1N6XuJ/B8OWlPGQYqZSUkzhw3w+cGpNhGD+iHHuj/I=;
        b=r58UNs+2p7ZP3QTrgwEhQ1+unDaovuObSP0hCBKN/l8W7QsaQdEInNFisaMqbLNhwA
         HWHzWoIfYAlIKrCuc7C6jDRUgYqaYm7dRDmcWu4mwZx1xlmI+mobDJi0zLrfE0Jy4gjQ
         SJGx4WafjuUoAuHyt2k+224KfdixBiW7mRH5Qjjv7JD5hy7jZVZ5jH1jRYJVvjOktnZb
         Gb+Fn+Kh8ivXyJZTBDtFI1+f9txrTGg1Fu2eJDmTLbP1NG4tgBsYOt/gPp+ioJRAqMU7
         3c6XNOcDkCzRetYB7YUZ4M0YBR52KbV/L38qi6h5WcF+SOC9a6RtyCkPmSZ1YBwd3DD0
         Kdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770855245; x=1771460045;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1N6XuJ/B8OWlPGQYqZSUkzhw3w+cGpNhGD+iHHuj/I=;
        b=K6c9STsceewuQDkO5oogNYNi0mxjl/p5MXZnpqgvOW1LMq60Os1X7Cjlkv/lFRede+
         JLZU1jaKZl05E8V+Y4+W+aT9/w546yHvdrlZ66M63DclMkh7AIYvjfO5io9V7gArxiDE
         cZi/Qn3oxpoqyiZC7pSM/CMIbAZImZvdz9cWnIkoxnNW7uH1Jf4UyurkQm10sWthnTed
         iQzKg9mvq+wdCTwOFY4AicR4UrudGO2qnDTJJ4H3BK+genQ+CPWc5D5bYJeB0d5Kwj7H
         plVvOgwP5cvdAlejkoHvZdy31pqWF6D3SL1hSHw4gOYth2TFW7twlOUqruGQOoNLSfex
         sL2g==
X-Forwarded-Encrypted: i=1; AJvYcCWmex+RiFhIAhlMy/g72gcYuT4vKmZ+bcZp6CtJgrJfH5cHabmuGix1MX6JX2ip7IELiGE7w8gB4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaTPIETIB3GgMy7YRxI1H0LHogyDA72nJOJNjbmVD0xG+yj9se
	mIiLAnz8amtNyFmKwaDZXAEsLAfVgQDUPDUF8Ca9siRl/TWbER+gzQiI+up8KgZljaE=
X-Gm-Gg: AZuq6aK1jJHakhsTQiX1fYrxjuRvbTsQgRHb5qp/8Ub7x2pdjCliD+Nqz7+7j6eU74Y
	Lhi0RGQYrP1dBbB4Xd93RwPkAjNugJ/L6LGPqGmGpVfdMiV/zszItsqAgSqv7mYtHQ1zD3NE7QH
	+kEgLGObah88Tk4BCNTLEJQF6pKDt0p9e2ejInODURhZCGIpVAhqFqud27GMvGlAK+OzUQjVEYZ
	mr3wjRynua1EVh2F0zpGSlkVsSgqw2gJS/7vEuYJQ1xMvw07WO3WqxHdQfSjRc3mf6zDPSWxVPm
	s1/O7lrtmJup/wdnfpJI+bEF3RvqQ1ZA6vJedpOyD0tq9LrVGiA8TDH8qrZD7STo0T90UoIUKvF
	IkWwJdATuR6vHb+T7c7vf/Tv7JYm4G84KWJ1LM36cDo6+DKyNEeNUa5NYHnvNdYrnKyqvF3EGc5
	8EWEChgeD+Pol/U6xmcZJru0RbZNHQaq62U2aLO6YKQBpCRnxCrXNVRZXYtyswhTEsYqau9C900
	XUmch5QJ6OCTDFOND5S
X-Received: by 2002:a05:6820:6ac6:b0:662:f74d:69f5 with SMTP id 006d021491bc7-67598a3a7a6mr461018eaf.31.1770855245449;
        Wed, 11 Feb 2026 16:14:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaef220cesm2450175fac.9.2026.02.11.16.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 16:14:04 -0800 (PST)
Message-ID: <3d6c84df-853a-4e28-8ee6-b1239bc985f0@kernel.dk>
Date: Wed, 11 Feb 2026 17:14:03 -0700
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
 <23112bc4-a498-4089-a225-1440c2151ce2@kernel.dk>
 <cae1de3b-1f76-4595-acfb-70c311d6c1aa@kernel.dk>
Content-Language: en-US
In-Reply-To: <cae1de3b-1f76-4595-acfb-70c311d6c1aa@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12174-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,syzkaller.appspot.com:url,kernel-dk.20230601.gappssmtp.com:dkim];
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
X-Rspamd-Queue-Id: BE9D412875D
X-Rspamd-Action: no action

On 2/10/26 3:16 PM, Jens Axboe wrote:
> On 2/9/26 1:18 PM, Jens Axboe wrote:
>> On 2/9/26 11:26 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d3b65a580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1222965a580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140e833a580000
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot-assets/c46beb4ff3a5/disk-e7aa5724.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/d162bcaaf9b9/vmlinux-e7aa5724.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/54b0844b8ea7/bzImage-e7aa5724.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
>>>
>>> list_del corruption. prev->next should be ffff88807dc6c3f0, but was ffff888146b205c8. (prev=ffff888146b205c8)
>>> ------------[ cut here ]------------
>>> kernel BUG at lib/list_debug.c:62!
>>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>>> CPU: 0 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
>>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
>>> Call Trace:
>>>  <TASK>
>>>  __list_del_entry_valid include/linux/list.h:132 [inline]
>>>  __list_del_entry include/linux/list.h:223 [inline]
>>>  list_del_init include/linux/list.h:295 [inline]
>>>  io_poll_remove_waitq io_uring/poll.c:149 [inline]
>>>  io_poll_remove_entry io_uring/poll.c:166 [inline]
>>>  io_poll_remove_entries.part.0+0x156/0x7e0 io_uring/poll.c:197
>>>  io_poll_remove_entries io_uring/poll.c:177 [inline]
>>>  io_poll_task_func+0x39e/0xe30 io_uring/poll.c:343
>>>  io_handle_tw_list+0x194/0x580 io_uring/io_uring.c:1122
>>>  tctx_task_work_run+0x57/0x2b0 io_uring/io_uring.c:1182
>>>  tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1200
>>>  task_work_run+0x150/0x240 kernel/task_work.c:233
>>>  exit_task_work include/linux/task_work.h:40 [inline]
>>>  do_exit+0x829/0x2a30 kernel/exit.c:971
>>>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>>>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>>>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>>>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
>>>  x64_sys_call+0x14fd/0x1510 arch/x86/include/generated/asm/syscalls_64.h:232
>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> RIP: 0033:0x7f60e579aeb9
>>> Code: Unable to access opcode bytes at 0x7f60e579ae8f.
>>> RSP: 002b:00007ffc2d47ddf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f60e579aeb9
>>> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
>>> RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f60e59e1280
>>> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
>>> R13: 00007f60e59e1280 R14: 0000000000000003 R15: 00007ffc2d47deb0
>>>  </TASK>
>>> Modules linked in:
>>> ---[ end trace 0000000000000000 ]---
>>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
>>
>> #syz test
>>
>> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
>> index 8c6f5aafda1d..5cb46109d1ff 100644
>> --- a/drivers/media/dvb-core/dmxdev.c
>> +++ b/drivers/media/dvb-core/dmxdev.c
>> @@ -168,7 +168,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
>>  			mutex_unlock(&dmxdev->mutex);
>>  			return -ENOMEM;
>>  		}
>> -		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
>> +		dmxdev->dvr_buffer.data = mem;
>> +		dmxdev->dvr_buffer.size = DVR_BUFFER_SIZE;
>> +		dvb_ringbuffer_reset(&dmxdev->dvr_buffer);
>>  		if (dmxdev->may_do_mmap)
>>  			dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
>>  				     file->f_flags & O_NONBLOCK);
>>
> 
> Mauro and other maintainers, this is literally the same issue as one reported
> last year:
> 
> https://lore.kernel.org/linux-media/20250407091619.11250-1-superman.xpt@gmail.com/
> 
> and I'm honestly a bit surprised that nobody has dealt with this, it's 10 months ago.
> And syzbot is still hitting it, literally crashing the box.
> 
> Hmm?

Nobody cares about any user that is able to open a dvr device, which at
least on debian is EVERY standard user, can crash the kernel?

I see replies on other messages, yet this issue has seemingly been
ignored for a year.

-- 
Jens Axboe


Return-Path: <io-uring+bounces-12361-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4D3tIYi1mWk8WQMAu9opvQ
	(envelope-from <io-uring+bounces-12361-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 14:39:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0454D16CEE5
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 14:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6DECC3014439
	for <lists+io-uring@lfdr.de>; Sat, 21 Feb 2026 13:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6611B6CE9;
	Sat, 21 Feb 2026 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sXmnKBpo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1EC7082F
	for <io-uring@vger.kernel.org>; Sat, 21 Feb 2026 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771681148; cv=none; b=kEyWzIxFypCtXlD2NKHgSx5OrzvPGpuMmd5Zg9+qMbEkFC6fsoLX1iTQBtbpnRLEe9xRPoVWXeM2Dw/dwOof5xz5OXlLqKCjA/v0YARjszZxOTZKkqtk1me4rKs6CIz1kA6ZVPSS8Jm8LCsxMADlBYRmKLIjVes/MhjTTIOLNDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771681148; c=relaxed/simple;
	bh=Ip3ZjBDSE/Zy86Y+LTe9T2puFdEjlBEqxZaFXE079aA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=MwQcEkza1lyEa6SvJPm3gPfSBl/njUy5UNZ8hGkch5YjiSz1uIla3ieOxxn6cHHbV82JhO2zapRP6mjEZbJw9DFQLXxQ/+XG59Dysbt6zaM7tBDk1I5YwEJqybHP1ufJXs45h554SHCRS5JHhlc70uiGowO9ZatGkumLUyO6q9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sXmnKBpo; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-463a0e14b4cso1104096b6e.1
        for <io-uring@vger.kernel.org>; Sat, 21 Feb 2026 05:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771681144; x=1772285944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qF2506Q3uzmD43lhIhgvzg5157toy2azs/t1x6da2k=;
        b=sXmnKBpofg5Kv12ga0YRImp3fbQ/neAk9ffiwle+AxMIxcHFK8WsDTiotkjhx2WV+o
         7s15tCYS3iSa9YNK1N6YCtfGDctGQ5IAP6ZzsPrDlkLwMQl0p3AVkuVNSsJTm+UGHdZi
         RkHzRgMDWP33bvRuMqbjDdT07LOxlYe9MKx13ImiWqOoEVQeHAeuIyQJswuZAyQ32cer
         egdFKWDe2V0YptfycZc4BBiLk5wAoleun5CYzr3LhrKPLk5PSs+wOdzaveSO4yIYXLpn
         2GnZZA8F9Ic8Oyt1t8rHl6PHkWinTFRmT+fU8jsmv03ZZFIkE7HSjTBdDRFxV4wqgxZU
         Yg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771681144; x=1772285944;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qF2506Q3uzmD43lhIhgvzg5157toy2azs/t1x6da2k=;
        b=kpwjJmKmNvN7MlrlYgJTfEdy19kVF3fCxg2KMWzet+GKRMlHC8HCqSpspg8vlzxhIP
         IC09n1Fo9j/9lOTMhl6ZNi08BavFbVUsHi9LcdaLBVVcnyIYareCEs/OGYzPfMRJ08Vq
         0QMHHJ6VF8YZNf8aYY8Lfax6tGEYHSCxrSBaCwbTzZ5jrfPiYMJXEDCSXHhZM70zNEAu
         Q1ZK1bSoFsSb3Bs4LTRVZSn1QuL6wyJrkB+QcpMUx24lFSRIdX6L7m/QGyywRwFjZ85B
         V8g3SbsqZYb9A8a1hvCGLjwB2gDBgplZMJcb7G7mxniBOuwHOFEFYWKCAlUuWJwypclo
         QX0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW4gqoeNwUPlsyEVweux/PRV8szYReh0z0aRIRgOmZodfGrjvwfiBfvyt5wJ6wOlLLgEkddsSTbPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGTAZWumfIUdzjYq5k8iuXRaIcOgeCx0KKyqnFb46OO9ODFGMu
	aNjNcm2TE0ANcHaXTBKM4ElxIsQT4hUQBcHgYV6HdElyq/dVRDWt+3h6oh4frwpBjk8=
X-Gm-Gg: AZuq6aIxIwdpK/eBG6mNsHNx0kBnrJFrf8uqDxoeTR7Y1E+YtoyMYAKKkIbJuAJYQQQ
	zT1l+s6RayRSeMIb01rGp4Lpud3rp9sGLcBq5GNu3imfM93hYHjI02AKbSXdUxsllQAWeAiCjIJ
	ZhDXlxNmBpWVQh1t+POzYlvlv1orNTqH0tpCTPRqc9TCUd4zTKG5c+S2qAcQq5bjspRkVVK7AQt
	K1MYqae9lK54U6/KJhA366x9qREHrXZLJ9Chkxd6VRV3VSjMUz9VaPLBP3tlpdhk/TC0Q+nLQB7
	rOEt9DEQwd6alz0TtzL/jN+RTZKDfRucJanHsphpNI3NyBlObOZDKCygCGxu3yl7AXVGz0Dt9WW
	wuBf9z1hNtShEQWJqCnuHQg71hoESm+h4bapZOXtcn8eXgtWBgA5R5pDPRcqGCbv0a6AhS6paje
	39BgGoX7hYkf3iA3ErSJRU4Z6JR9Ojx3O9bGLGitZ2JMy6DjddcLhEa50Py8AcCpAdkFYlw+AcF
	mxoVVJdlOSejg==
X-Received: by 2002:a05:6808:eca:b0:45e:63e0:4c9a with SMTP id 5614622812f47-4644616cba7mr1983904b6e.1.1771681144251;
        Sat, 21 Feb 2026 05:39:04 -0800 (PST)
Received: from [172.25.209.35] ([187.223.170.195])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4644a1b2570sm1502190b6e.17.2026.02.21.05.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Feb 2026 05:39:03 -0800 (PST)
Message-ID: <709538df-3f3e-4306-af11-206809e1f742@kernel.dk>
Date: Sat, 21 Feb 2026 06:39:01 -0700
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
 linux-media@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <698a26d3.050a0220.3b3015.007d.GAE@google.com>
 <23112bc4-a498-4089-a225-1440c2151ce2@kernel.dk>
 <cae1de3b-1f76-4595-acfb-70c311d6c1aa@kernel.dk>
 <3d6c84df-853a-4e28-8ee6-b1239bc985f0@kernel.dk>
Content-Language: en-US
In-Reply-To: <3d6c84df-853a-4e28-8ee6-b1239bc985f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12361-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,storage.googleapis.com:url,syzkaller.appspot.com:url];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,ab12f0c08dd7ab8d057c];
	RCPT_COUNT_SEVEN(0.00)[7];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 0454D16CEE5
X-Rspamd-Action: no action

On 2/11/26 5:14 PM, Jens Axboe wrote:
> On 2/10/26 3:16 PM, Jens Axboe wrote:
>> On 2/9/26 1:18 PM, Jens Axboe wrote:
>>> On 2/9/26 11:26 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d3b65a580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
>>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1222965a580000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140e833a580000
>>>>
>>>> Downloadable assets:
>>>> disk image: https://storage.googleapis.com/syzbot-assets/c46beb4ff3a5/disk-e7aa5724.raw.xz
>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/d162bcaaf9b9/vmlinux-e7aa5724.xz
>>>> kernel image: https://storage.googleapis.com/syzbot-assets/54b0844b8ea7/bzImage-e7aa5724.xz
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
>>>>
>>>> list_del corruption. prev->next should be ffff88807dc6c3f0, but was ffff888146b205c8. (prev=ffff888146b205c8)
>>>> ------------[ cut here ]------------
>>>> kernel BUG at lib/list_debug.c:62!
>>>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>>>> CPU: 0 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
>>>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>>>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>>>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>>>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>>>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>>>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>>>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>>>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>>>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
>>>> Call Trace:
>>>>  <TASK>
>>>>  __list_del_entry_valid include/linux/list.h:132 [inline]
>>>>  __list_del_entry include/linux/list.h:223 [inline]
>>>>  list_del_init include/linux/list.h:295 [inline]
>>>>  io_poll_remove_waitq io_uring/poll.c:149 [inline]
>>>>  io_poll_remove_entry io_uring/poll.c:166 [inline]
>>>>  io_poll_remove_entries.part.0+0x156/0x7e0 io_uring/poll.c:197
>>>>  io_poll_remove_entries io_uring/poll.c:177 [inline]
>>>>  io_poll_task_func+0x39e/0xe30 io_uring/poll.c:343
>>>>  io_handle_tw_list+0x194/0x580 io_uring/io_uring.c:1122
>>>>  tctx_task_work_run+0x57/0x2b0 io_uring/io_uring.c:1182
>>>>  tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1200
>>>>  task_work_run+0x150/0x240 kernel/task_work.c:233
>>>>  exit_task_work include/linux/task_work.h:40 [inline]
>>>>  do_exit+0x829/0x2a30 kernel/exit.c:971
>>>>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>>>>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>>>>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>>>>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
>>>>  x64_sys_call+0x14fd/0x1510 arch/x86/include/generated/asm/syscalls_64.h:232
>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>> RIP: 0033:0x7f60e579aeb9
>>>> Code: Unable to access opcode bytes at 0x7f60e579ae8f.
>>>> RSP: 002b:00007ffc2d47ddf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f60e579aeb9
>>>> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
>>>> RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f60e59e1280
>>>> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
>>>> R13: 00007f60e59e1280 R14: 0000000000000003 R15: 00007ffc2d47deb0
>>>>  </TASK>
>>>> Modules linked in:
>>>> ---[ end trace 0000000000000000 ]---
>>>> RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
>>>> Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
>>>> RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
>>>> RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
>>>> RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
>>>> RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
>>>> R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
>>>> R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
>>>> FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
>>>
>>> #syz test
>>>
>>> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
>>> index 8c6f5aafda1d..5cb46109d1ff 100644
>>> --- a/drivers/media/dvb-core/dmxdev.c
>>> +++ b/drivers/media/dvb-core/dmxdev.c
>>> @@ -168,7 +168,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
>>>  			mutex_unlock(&dmxdev->mutex);
>>>  			return -ENOMEM;
>>>  		}
>>> -		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
>>> +		dmxdev->dvr_buffer.data = mem;
>>> +		dmxdev->dvr_buffer.size = DVR_BUFFER_SIZE;
>>> +		dvb_ringbuffer_reset(&dmxdev->dvr_buffer);
>>>  		if (dmxdev->may_do_mmap)
>>>  			dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
>>>  				     file->f_flags & O_NONBLOCK);
>>>
>>
>> Mauro and other maintainers, this is literally the same issue as one reported
>> last year:
>>
>> https://lore.kernel.org/linux-media/20250407091619.11250-1-superman.xpt@gmail.com/
>>
>> and I'm honestly a bit surprised that nobody has dealt with this, it's 10 months ago.
>> And syzbot is still hitting it, literally crashing the box.
>>
>> Hmm?
> 
> Nobody cares about any user that is able to open a dvr device, which at
> least on debian is EVERY standard user, can crash the kernel?
> 
> I see replies on other messages, yet this issue has seemingly been
> ignored for a year.

Another ping on this one. For some reason you (Mauro) are ignoring this
issue, both the original report and my report. Not quite sure what to do
about it, but I'm tempted to just send the patch to Linus at this point.

-- 
Jens Axboe


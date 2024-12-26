Return-Path: <io-uring+bounces-5605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA6E9FCAF2
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 13:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C61188263C
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 12:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357511D358F;
	Thu, 26 Dec 2024 12:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+FRDFYa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701271CEAC3;
	Thu, 26 Dec 2024 12:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735215832; cv=none; b=HrU7+Bspc8zwbKr+/swJFvtoVub9ey7iflG5Iyn3S/xg+E6xlwXtWxGy//bA2lOisaLxqM7TRTalycwUmz9VEQxB7fV8r615w9Nah2FiUwwu7/WejiGdqsLkNyMECloVxR3nU3p0ggNi92g9u/WOsFNVjb6V8cxva/4XFt0tTCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735215832; c=relaxed/simple;
	bh=oqg14pf3IZcjWAJwg8d7d58UrrAf0+kO9s2WCETNO9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBsQe3NbUM+rvOUII6WAUJVzlSt/ZnEj/vldql93ra25ROaWAnWZcv7ObPgWsdGOAqNLdii2BjmDmx0LCl+Bx2/5hVbCTNgWK1KQGoOLWogSXxoilECdAOOvcrH0Xmr4vwAQeaSzUJMcgxgqHOR/pcnBZZWz3UzME882nkN1o/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+FRDFYa; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d7e527becaso10084342a12.3;
        Thu, 26 Dec 2024 04:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735215828; x=1735820628; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0947Fnllmyrg7F6vJ2Bp7JuZgZGVp0Z2D6ts9kMY+GY=;
        b=d+FRDFYaTGdvnjxgBHXsgsTiXlYp8ODd3rA86nvDkxbZRgYVFvmfkjsrKZt3iMu+4h
         YvrJEQDIg6DMVqGqeoHDIKPcITbz57tlPgQP/LjG5LCnSCdZUZ8Wsv5ts/6jYoScbzS0
         v/ZjgwZzIksm8h8TaJLL+Uv04YKu6JPA9DcqeJDa/TRBEW09IdGt1ProVhT1WIv2LfRd
         DgPdR0NegAs3L29Bx1mb6T7q+O/CvNbUDA36dAiW5M2BBcafgBXKPTEdUpw1eQ4hKgCR
         23cvm8Q1PaiXkNxxBeeY5D4N+OIZ/zmJF9aWr2O2SWI/si0QmvJDuOduOEZGpM79t+rw
         JV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735215828; x=1735820628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0947Fnllmyrg7F6vJ2Bp7JuZgZGVp0Z2D6ts9kMY+GY=;
        b=Ld3/Lk2BuoUe+mBWagANe8Gdl5DCS1NFNhYsNG0hZ/VSAGEToRjoxiW+aed+sX60AY
         uHNt15Yt6Y81ard8xCrqQeLSTiljzcwyLIEotygL9byp5CjZmKDk3RyarWok/KUsRHDN
         1ULlRcof62D8ZRxXmPNno1CFUf1TUKHeGuR0uAMhEGsK5UPFHoqKzC4BK1TvGEjvZcXk
         danwAuHxXJy1XEJCkD/7ibqNspbV04syItsQ2KNu34JYu4Y0jNUju6UDWykWOyBOZu+L
         3KI7g191C4IBi1ATq1nt8tmxeO+5Fi0UWE4ywTz/e5p9hOxpuiONzY26lsjzSgtXeICM
         dhYw==
X-Forwarded-Encrypted: i=1; AJvYcCVbfX79MOTcxsQMPPmc+PpHtNou19l4XSYyp7GO2wYlfLLR4wdTbeLY5HsZChmI9+TrvLN1NkMbww==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyMsfkEYvDmelSfm7QAYcMBNxGDjDqW5C81NjWrgOifJtdYeEj
	PvmN55ZCQo/cH7vLSJ3Gztm9T0mi5vP7MwW48HBjq7t4GGvaYpOO
X-Gm-Gg: ASbGncuiYPTpc5cm4rt5ZvLlpsHecrF2Ltq+6zy9gohBb1xTEDUzc6h1MJ6maMcy32R
	JMToIC5gZicwpqjt1BpndrxfRukuG/7vASv5gu2wXZDHM8hgZ7MAVJURntNjZJJrE98t/p3P0ig
	RAtoJTsQFNbk4XzG2auJDM3QDFIfALC7Fn75PZ7gh19sJ4RcbEMIGHQWY4OyVEc3IjmHrLktSQ3
	VZpOwe9p28m7wZ6uxozgdxho5Xn20IoFFN/wzyRewhwhGIZ8PLnE7ACdBW84tIVJw==
X-Google-Smtp-Source: AGHT+IE25ourJnMmnZIJh3LUMUoGA4PEYDSBZlB4CTs2jwR+HGgCA4+DYQZ/QtMhqh7WiJ2iNuurKA==
X-Received: by 2002:a05:6402:358c:b0:5d0:8f1c:d9d7 with SMTP id 4fb4d7f45d1cf-5d81dd83b30mr60553672a12.4.1735215826318;
        Thu, 26 Dec 2024 04:23:46 -0800 (PST)
Received: from [192.168.42.17] ([85.255.234.252])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe49edsm957636766b.106.2024.12.26.04.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 04:23:45 -0800 (PST)
Message-ID: <c0a50347-da83-4d6c-9d9e-ffc5fac5c4b7@gmail.com>
Date: Thu, 26 Dec 2024 12:24:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
To: Waiman Long <llong@redhat.com>, Kun Hu <huk23@m.fudan.edu.cn>,
 peterz@infradead.org, mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com
Cc: linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <1CF89E16-3A37-494F-831C-5CA24BCEEE50@m.fudan.edu.cn>
 <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/25/24 21:11, Waiman Long wrote:
> On 12/24/24 7:28 AM, Kun Hu wrote:
>> Hello,
>>
>> When using fuzzer tool to fuzz the latest Linux kernel, the following crash
>> was triggered.
>>
>> HEAD commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
>> git tree: upstream
>> Console output:https://drive.google.com/file/d/11IXj9a4uRbOaqIK90F2px6nLiHhJ04rw/view?usp=sharing
>> Kernel config: https://drive.google.com/file/d/1RhT5dFTs6Vx1U71PbpenN7TPtnPoa3NI/view?usp=sharing
>> C reproducer: https://drive.google.com/file/d/1BP2d5rfb4XBuq0njxKnS6d3AoysIiT61/view?usp=sharing
>> Syzlang reproducer: https://drive.google.com/file/d/1lTQrXRQfndtigBiKBxelQeHszr2dzbLp/view?usp=sharing
>> Similar report: https://lore.kernel.org/lkml/CALcu4rZOs3sbXBWARhjM6d8UngPUF3bU1CPmSZBugUpgaP_0WA@mail.gmail.com/T/
>>
>>
>> This bug seems to have been reported and fixed in the old kernel, which seems to be a regression issue? If you fix this issue, please add the following tag to the commit:
>> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
>>
>>
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
>> Read of size 8 at addr ff1100000289acb8 by task syz.6.1904/11159
>>
>> CPU: 1 UID: 0 PID: 11159 Comm: syz.6.1904 Not tainted 6.13.0-rc3 #3
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>> <TASK>
>> __dump_stack lib/dump_stack.c:94 [inline]
>> dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
>> print_address_description mm/kasan/report.c:378 [inline]
>> print_report+0xcf/0x5f0 mm/kasan/report.c:489
>> kasan_report+0x93/0xc0 mm/kasan/report.c:602
>> __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
>> lock_acquire kernel/locking/lockdep.c:5849 [inline]
>> lock_acquire+0x1b1/0x580 kernel/locking/lockdep.c:5814
>> __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>> _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
>> class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
>> try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
>> io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
>> io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
>> io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
>> io_uring_create io_uring/io_uring.c:3724 [inline]
>> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
>> __do_sys_io_uring_setup io_uring/io_uring.c:3833 [inline]
>> __se_sys_io_uring_setup io_uring/io_uring.c:3827 [inline]
>> __x64_sys_io_uring_setup+0x94/0x140 io_uring/io_uring.c:3827
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fa4396a071d
>> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fa4382f3ba8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 00007fa439862f80 RCX: 00007fa4396a071d
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000002616
>> RBP: 00007fa4382f3c00 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000015
>> R13: 00007fa439862f8c R14: 00007fa439863018 R15: 00007fa4382f3d40
>> </TASK>
> 
> This is not caused by a locking bug. The freed structure is a task_struct which is passed by io_sq_thread() to try_to_wake_up(). So the culprit is probably in the io_uring code. cc'ing the io_uring developers for further review.

Thanks for the report, we'll take a look

-- 
Pavel Begunkov



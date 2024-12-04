Return-Path: <io-uring+bounces-5204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A52A69E3F76
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C545281303
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2FA20B20E;
	Wed,  4 Dec 2024 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ob7VnvlD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C429C20C49E
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329053; cv=none; b=TaYffqyorvtW+1tTcJsTm7aDqj041Ej0clrxbRUHOdzuK2kPCtkzk9XDdyRxpGiSAtBQiLtzxUsPtv8ai6po0dN/N1ENGE+skTJkvRxRBLSLzoF7UN1yK7exjWwyXP055KreX2RsGknWUETsmQEI7ILPW+Ej+Rl+M0/Uqf//F7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329053; c=relaxed/simple;
	bh=D5RMggkvqJJmWAdaEJyPdYP42ngAHaPJpovKkrzHOGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dya5zzGlMYO608UDu1+mWjnVwh8oYk8kMd46CeMKhi3rSZGGoS7Vzyti8jUbFBUpmX7iDXJnaYbZ/5NlymHXSSdSSNatT/zzNoi5/g6snC/MXyqepYB3E/1QZekefKFjtkMMdfc3pDyLfU6eANZe6n4N2xVc8MkZQV0690Bkp8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ob7VnvlD; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea9739647bso5033913a12.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 08:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733329049; x=1733933849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7P77MNq1S8T3SEsRBGWK6l0nmeNklLB0BoCdpmJrXTs=;
        b=Ob7VnvlDtFaEXoowqsNhRQIlw/R197G2+XFnRP6SylWh1VSbpu5a/gBS1W1RoGOREf
         llA0ZwUwt9z/4OeNMe1B/NtBDETYdfoLrR0JBHJw5iye+hEaQDn+TXzfAA+K4NvyHkL9
         VidkYpe+BKYSoPZOqNqx42f4WA6WnWJj//ftB5S4ZfH2QssjtmBatk4iLfW5TW7fS5mD
         Rs9/vsMZI0i9qSFlRCm7yFy2Jnd1SVwoDqovwGqhjjSpRZu3UKvTPmDaRHvtGAsazcR/
         cllTi2fREyXkhPRuvGNU1y1TyygHJDOKM3ZwYXpytsXNoZPctKRbbTP0WaaoYDCyeDSR
         9QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329049; x=1733933849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7P77MNq1S8T3SEsRBGWK6l0nmeNklLB0BoCdpmJrXTs=;
        b=aUvDGmnaj8xntfiIB2GGnAx369pPGkrzlzZjejN5RKloLcfh0tXml2pTHUE5p3ZPLu
         OCkI4CbSbEYoevQTG9f+G1pOU29M0OMvGN5vC8oxB458cWxhWSRLBc7sOhP1P1ipBUC8
         13vOo1cDO5ltZimf6HVP1zN8OW4NcR91SxXWdtMOjKB6eNbmB7ATF/rx2pJiF2sSt+a1
         4miQhIArNZD3A/LhTDfq1ndfv4p4JkovZz2lv/JSulmC9NYvWnB27mJggRozC5v2bkcY
         Bfdu8yLE/YgayMJDpmE+2SbT6C5e2JX7ktVQPwB8a3NUCRMeKCD5NQhPgJGg8Zkj3iCC
         PY6A==
X-Forwarded-Encrypted: i=1; AJvYcCVaFvbJtO68jjZZM5mP5j8ei8U8m0wbnSRw/fdkNPbpuuoYlTPO1+kaAtiYJHm4sXL4ZyEZdPX9wg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc/b+RY8Vp5CMWodT9YekCV8mx9eDgJvhvWct+2tkqb5WZjD1Q
	rfi26GLYt+1qJ+3n2W8kQm1c3ZcT3YHMJ868mcZMSqJNLgTlVITGH5cX0A4443Y=
X-Gm-Gg: ASbGncuiIh9scvzfVKwN1ChZmjQiGvn66Sa+1li7KG42Ap/qx8oiZOwiJueWHwhhXkU
	7ra0t39fup3BGoYXQ5nCfKRku1Y2VD5+o8rAKtFSEmvyiYPdFz/u/D9fDatOtCj8AdqrDd2Uc/9
	aoGuMdmtlveXjhLkPmatzT24tkoUXc88IT9Ltsjiap79246ZL7ltKwTC5PUjwM9zK4cFpmhQvvE
	bj0EQ+gCFNWzQikJDbtXurpOMnzusCyXGyWYzwiLa3HzZ5y1J2ebU1PnQ==
X-Google-Smtp-Source: AGHT+IGgWZB5/OqY8yzRC8nRVwrcmLa7enXp1lQBRR/0rQCRJOCO3r9s0TzV9wTD1kGRvgJ0HTuaOw==
X-Received: by 2002:a05:6a20:9185:b0:1e0:bf98:42dc with SMTP id adf61e73a8af0-1e1653f3c8amr9318189637.28.1733329048856;
        Wed, 04 Dec 2024 08:17:28 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254176148csm12558612b3a.19.2024.12.04.08.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 08:17:28 -0800 (PST)
Message-ID: <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk>
Date: Wed, 4 Dec 2024 09:17:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in
 sys_io_uring_register
To: Tamir Duberstein <tamird@gmail.com>
Cc: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <67505f88.050a0220.17bd51.0069.GAE@google.com>
 <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
 <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/24 8:21 AM, Tamir Duberstein wrote:
> On Wed, Dec 4, 2024 at 10:10?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/4/24 8:01 AM, Jens Axboe wrote:
>>> On 12/4/24 6:56 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    c245a7a79602 Add linux-next specific files for 20241203
>>>> git tree:       linux-next
>>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10ae840f980000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=af3fe1d01b9e7b7
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=092bbab7da235a02a03a
>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a448df980000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cca330580000
>>>>
>>>> Downloadable assets:
>>>> disk image: https://storage.googleapis.com/syzbot-assets/8cc90a2ea120/disk-c245a7a7.raw.xz
>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/0f6b1a1a0541/vmlinux-c245a7a7.xz
>>>> kernel image: https://storage.googleapis.com/syzbot-assets/9fa3eac09ddc/bzImage-c245a7a7.xz
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>>>> BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
>>>> BUG: KASAN: null-ptr-deref in put_cred_many include/linux/cred.h:255 [inline]
>>>> BUG: KASAN: null-ptr-deref in put_cred include/linux/cred.h:269 [inline]
>>>> BUG: KASAN: null-ptr-deref in io_unregister_personality io_uring/register.c:82 [inline]
>>>> BUG: KASAN: null-ptr-deref in __io_uring_register io_uring/register.c:698 [inline]
>>>> BUG: KASAN: null-ptr-deref in __do_sys_io_uring_register io_uring/register.c:902 [inline]
>>>> BUG: KASAN: null-ptr-deref in __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
>>>> Write of size 8 at addr 0000000000000406 by task syz-executor274/5828
>>>>
>>>> CPU: 1 UID: 0 PID: 5828 Comm: syz-executor274 Not tainted 6.13.0-rc1-next-20241203-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
>>>> Call Trace:
>>>>  <TASK>
>>>>  __dump_stack lib/dump_stack.c:94 [inline]
>>>>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>>>  print_report+0xe8/0x550 mm/kasan/report.c:492
>>>>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>>>>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>>>>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>>>>  atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
>>>>  put_cred_many include/linux/cred.h:255 [inline]
>>>>  put_cred include/linux/cred.h:269 [inline]
>>>>  io_unregister_personality io_uring/register.c:82 [inline]
>>>>  __io_uring_register io_uring/register.c:698 [inline]
>>>>  __do_sys_io_uring_register io_uring/register.c:902 [inline]
>>>>  __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
>>>>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>>>>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>> RIP: 0033:0x7f65bbcb03a9
>>>> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>>> RSP: 002b:00007ffe8fac7478 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>>>> RAX: ffffffffffffffda RBX: 000000000000371d RCX: 00007f65bbcb03a9
>>>> RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000000000003
>>>> RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
>>>> R13: 00007ffe8fac7648 R14: 0000000000000001 R15: 0000000000000001
>>>>  </TASK>
>>>> ==================================================================
>>>
>>> Not sure what's going on with -next, but this looks like nonsense - we
>>> store a valid pointer in the xarry, and then attempt to delete an
>>> invalid index which then returns a totally garbage pointer!? I'll check
>>> what is in -next, but this very much does not look like an io_uring
>>> issue.
>>
>> Took a quick look, and it's this patch:
>>
>> commit d2e88c71bdb07f1e5ccffbcc80d747ccd6144b75
>> Author: Tamir Duberstein <tamird@gmail.com>
>> Date:   Tue Nov 12 14:25:37 2024 -0500
>>
>>     xarray: extract helper from __xa_{insert,cmpxchg}
>>
>> in the current -next tree. Adding a few folks who might be interested.
>>
>> --
>> Jens Axboe
> 
> Yep, looks broken. I believe the missing bit is
> 
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 2af86bede3c1..5da8d18899a1 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1509,7 +1509,7 @@ static void *xas_result(struct xa_state *xas, void *curr)
>  void *__xa_erase(struct xarray *xa, unsigned long index)
>  {
>   XA_STATE(xas, xa, index);
> - return xas_result(&xas, xas_store(&xas, NULL));
> + return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
>  }
>  EXPORT_SYMBOL(__xa_erase);
> 
> This would explain deletion of a reserved entry returning
> `XA_ZERO_ENTRY` rather than `NULL`.

Yep this works.

> My apologies for this breakage. Should I send a new version? A new
> "fixes" patch?

Since it seems quite drastically broken, and since it looks like Andrew
is holding it, seems like the best course of action would be to have it
folded with the existing patch.

-- 
Jens Axboe


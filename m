Return-Path: <io-uring+bounces-5200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0DC9E3E29
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8079BB24949
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 15:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F751FECCF;
	Wed,  4 Dec 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XNc4WsHO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D681E1BC9F0
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733325055; cv=none; b=XzwoYOnHn05vcQ3JJ+60bgiB0DmCuKJnDuEtMhXfcsTAbaX5rtLTiYEet4M9cPHdn5UZ85wctTfEos5PNB6hgA8a/j6+ovVTIZOD8NgHAXCiyOvRb/nlvdmYrXU27MpYEktmL7CiUDw0EwI/S5izHrzK/DAeYdLNgsGniw2uG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733325055; c=relaxed/simple;
	bh=Rb6Y8NXHzsTM9HHrLWqndVveTK66td8PjW2s5dtTRto=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=khFRKH+8ULzb6/ZH8IdWiOs5oR7PW5+rRO1RmmGKKAiHUgsTxqd7qLrJnFdQR9UMfFkm6x60BL4GkbogNJ46kzhLargXxMukZJg0KSRSxHFfAB4v2sokbO3OVtZDECSd7rTGZWc8o44bpoSTcF7OV6UKaot+cJfBMsyO6CRNqk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XNc4WsHO; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-71db6687504so553054a34.3
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 07:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733325053; x=1733929853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPPB8GEGw1E9XYvmVhUijrypMtBCZ7AbIpJmv7ma6Ec=;
        b=XNc4WsHOszHjaA9nwuzdj4ZIFhgd8hdG9DwnJDLt9P0ZfavQntqlcNjYNMZf2mui+t
         w7lwhoRUTzkDmJou4FaKSzZsE/Dr0UyMI9JOWEVgUudeqY4Clh+vUArA3Du31DbK33Uy
         FjIlp2gGjta6Dp1khOM+xal5RKwILedRN1p7fvGikjLnx0glkOVQghEjrRm5a9kdInLv
         KlXu4rt27Tkh71AHhppEQ7L6JYa/gPyZVzCiHIy+GPgG7kmIZb2jovrB6SrR4LInVXwd
         uGAepQYdoF/oDsIODcJvvzmiw+r8eMAesH5TnmGtiCWew3eBIIW0Eb/2Jcb5brbYWQTL
         OJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733325053; x=1733929853;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dPPB8GEGw1E9XYvmVhUijrypMtBCZ7AbIpJmv7ma6Ec=;
        b=iXRIfjYrdJQFcALK5O/lRtwJ++km+004W8ZQvI5yfGm1dfacMQWQ2Pu//6el9DwhaR
         QQGFsHAtqXGz5BinHUMvLqVX5L8DMmn6i1ry2vxWxdEtsjAkM/CxRsd0wq0kYHYa+Mfl
         3pmnD5A0uFHMBmtadpzBioBu9ocWcGB4SsTRBSyyLWrTgWpJn4zSAYB4UAgcajTx9T6N
         aS4XSDtB/vnwXdnjrTNdwIEIfxtTf4sv9mCd4RicIpy6LIWZzzrE4mCKWnsO235ESmct
         WVqRb97n/mblvXfrq0W5LpfXxePD4XQb0tiMNGT35Wqqz902Orp/fC9qWIScd6n4M8cR
         OEUA==
X-Forwarded-Encrypted: i=1; AJvYcCUex6lupC+d1GT/3zSDx1Qws5tJqTXE9jxVO2t4LyH3auQUgrblrkLlUXKP/bsm83c46QDTeJ4D7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrX8jD1rPwm07QA9QNTqs+uUGKLC6gTwHUixeDGk8pDDBWlueY
	Wqe+dytL0r8IRKbL1ahx3AwsIPYYi8dSE7ELc2+vdkKCDBAwtfBykrN8g4P1nRI=
X-Gm-Gg: ASbGncv7d5Vtn9gsv0dQ8LIWY/nGHY+1LizOwYKwPsa1ShjasBjcTO35E+xAt7hjVIG
	2OywuI24Pr3Rp+TvGJ1yp3E7Sf6iIse/cR8ThNhZ8u4NKa3IlLcwp7H38p35IPzYiHiv8Dz86Hk
	TwtqaPSSOdB9GvFgwsoJGA6FW/Uele3e6+bJkZmtXSsJkLgitHsUEPCUAcZo3YuuzgCYPXbhJH+
	jvhCTudEBh07PuWVpHI7EStNY09o9TBgLaFwuijGOyN9y7z
X-Google-Smtp-Source: AGHT+IFRL6eoAWjRqHtca0RFb+zKD2CuOO34C5Pgh8UzSYU80xBI+aFeeuZJmQemv2QncwzbMEu35A==
X-Received: by 2002:a05:6830:1d59:b0:71d:63fc:2eaa with SMTP id 46e09a7af769-71db5868ff4mr2199938a34.21.1733325052755;
        Wed, 04 Dec 2024 07:10:52 -0800 (PST)
Received: from [172.20.2.46] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29de928c9b7sm4403411fac.22.2024.12.04.07.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 07:10:52 -0800 (PST)
Message-ID: <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
Date: Wed, 4 Dec 2024 08:10:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in
 sys_io_uring_register
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, tamird@gmail.com
References: <67505f88.050a0220.17bd51.0069.GAE@google.com>
 <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
Content-Language: en-US
In-Reply-To: <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/24 8:01 AM, Jens Axboe wrote:
> On 12/4/24 6:56 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    c245a7a79602 Add linux-next specific files for 20241203
>> git tree:       linux-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10ae840f980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=af3fe1d01b9e7b7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=092bbab7da235a02a03a
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a448df980000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cca330580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/8cc90a2ea120/disk-c245a7a7.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/0f6b1a1a0541/vmlinux-c245a7a7.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/9fa3eac09ddc/bzImage-c245a7a7.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>> BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
>> BUG: KASAN: null-ptr-deref in put_cred_many include/linux/cred.h:255 [inline]
>> BUG: KASAN: null-ptr-deref in put_cred include/linux/cred.h:269 [inline]
>> BUG: KASAN: null-ptr-deref in io_unregister_personality io_uring/register.c:82 [inline]
>> BUG: KASAN: null-ptr-deref in __io_uring_register io_uring/register.c:698 [inline]
>> BUG: KASAN: null-ptr-deref in __do_sys_io_uring_register io_uring/register.c:902 [inline]
>> BUG: KASAN: null-ptr-deref in __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
>> Write of size 8 at addr 0000000000000406 by task syz-executor274/5828
>>
>> CPU: 1 UID: 0 PID: 5828 Comm: syz-executor274 Not tainted 6.13.0-rc1-next-20241203-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
>> Call Trace:
>>  <TASK>
>>  __dump_stack lib/dump_stack.c:94 [inline]
>>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>  print_report+0xe8/0x550 mm/kasan/report.c:492
>>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>>  atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
>>  put_cred_many include/linux/cred.h:255 [inline]
>>  put_cred include/linux/cred.h:269 [inline]
>>  io_unregister_personality io_uring/register.c:82 [inline]
>>  __io_uring_register io_uring/register.c:698 [inline]
>>  __do_sys_io_uring_register io_uring/register.c:902 [inline]
>>  __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
>>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f65bbcb03a9
>> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffe8fac7478 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> RAX: ffffffffffffffda RBX: 000000000000371d RCX: 00007f65bbcb03a9
>> RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000000000003
>> RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
>> R13: 00007ffe8fac7648 R14: 0000000000000001 R15: 0000000000000001
>>  </TASK>
>> ==================================================================
> 
> Not sure what's going on with -next, but this looks like nonsense - we
> store a valid pointer in the xarry, and then attempt to delete an
> invalid index which then returns a totally garbage pointer!? I'll check
> what is in -next, but this very much does not look like an io_uring
> issue.

Took a quick look, and it's this patch:

commit d2e88c71bdb07f1e5ccffbcc80d747ccd6144b75
Author: Tamir Duberstein <tamird@gmail.com>
Date:   Tue Nov 12 14:25:37 2024 -0500

    xarray: extract helper from __xa_{insert,cmpxchg}

in the current -next tree. Adding a few folks who might be interested.

-- 
Jens Axboe



Return-Path: <io-uring+bounces-9578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1017B44A66
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 01:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE8A5566EE5
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 23:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4422F656E;
	Thu,  4 Sep 2025 23:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="19iNBcz2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590121D6DA9
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028358; cv=none; b=sikv3Zb0rRbRs3wZ9cWIolfydmLJEa17rhdk9xiSoBQ6aSBGGtDu9GeA9UZSJ1pSAHfbn6UbRxwSxlTmCIx0eB8Qqj7/ED2UEXfm7be2h4dxJpw8UqlKnojsGLOQnJKVoTHFh31od8skH2EpMxJbQ7xGHSO8lotSSabvX960tE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028358; c=relaxed/simple;
	bh=0z4W131kc7IZA/MZBmrE2/S7QjivMLpZDRe6D8mSq1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5CGQzwIWet2OXEljvVXkx4XwqqdgJ3bsUOwI+xcfVbANh/pk8mA/JWqqaPs1fJ0EnTA9JP/HuMk7974jkegR2z1Jv7aB+Yrno5IWtppG9BgFfLAzAhEYn8UjG39KPrt+WIh43U8KBgYvgQbPjuZzxBtaT3DW2+kOkqZSDq2+4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=19iNBcz2; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e98b64d7000so1548169276.3
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757028355; x=1757633155; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xozTMnAUTSGP/OIsr+6T7j3/FSd9yXb5HKJfOm++2A=;
        b=19iNBcz2azO0oyiCCxgYHGPJ+qjLi2CdjGHUPwd+s4x58zywNc+7ZN2ENqrAuXQQI/
         Y+yJNbuDnkkHKHTEpL09rVvZ1C1zbfPIHpV+9O6lMSNbAuk8Am1swNihkoTrG9JjzuEM
         SIUy1rRntwRrctbAb2bJckwCeS8Nc2kJYNHnEhdcbVQGqznq0J9sJrH+tXxRO8GBEYxa
         r2TCjb/w01CdpgbJTJjsbmODokw2G6SY4CxXXZKOCVNHoPbnVSFnrI89t5R5TIvOH8K/
         o2kMg8pfqo6RKHHSa5foK3s+UAYAuOGg/w+lUKQ00h7Pjh2hn7Rtv3myyhgwrk7+vHiL
         Pewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757028355; x=1757633155;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7xozTMnAUTSGP/OIsr+6T7j3/FSd9yXb5HKJfOm++2A=;
        b=oF4DrOFWq7D2ZTSa3yv1AOq8gNCctJE98n4zvpqEpWYNdelPXI/+gZCF12+6dTzF49
         lDcs6TcYlIaAAzCrwmgoGE9zPgDtLZlR0+7NH+dEmiIPW0i0vyfR1RlJAbzgjHxDwvc6
         iboplK6P5UehRIiB0PVdqvAl6OqEzhXXI5lsoEhqVtM1aUMpv1AJzqn/AbuWvVrcKd0P
         F1v7443n57VTiYbFRHu/GS3k72tujx1/n2vSvKRFKi322HT9X9dHQjZcUzDX5whcTJaw
         Gq+MszlvQI0OjRvK6cRPUJ3guPSKvZfb6ax05q1jp+Oq0WtAZeA+V/QvUgQfRWuLnmSg
         hCjw==
X-Forwarded-Encrypted: i=1; AJvYcCXhY7saz8STJdUzMyMO2k1huxn15U5ZlUpQaoG3rx0683WqrlondIAbyDxzCtjv9aceej/LVEiRRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQjvvi/UYF6pgMEQevssyN6w7s0CJHvJ/l5FcYr6p36//mDo4R
	z29Yz3N5ODjPNzp4e2EFdv5T4sKPoyA5hc2FQ7dKNUW1csVF4PHyKNGNg8oifu+oF7I=
X-Gm-Gg: ASbGncsFOj4rD1pKUhwCm+Rwxe8iRRQOtkqEOO1/OTUWMZQ5duf1IE/ZknTyNPHLatZ
	MgPs322URpEb7tRXiej8MITgdqLkNeiSuNEWqi/njT7x2opjcwroEmxWPiu+ZIdkeiue3bg8Gf9
	1PKAWxHxVoknTV/XwbZvlEK5091at6Yk3ckxfUHv9me4toCOGaJseGfD/oRdRIIVNeJ+0guoe3C
	RuJOxJz2UI6Bz0II+g9V3kNfmbhfJNiCAYbG7QNwMFs7JAovRnuNM1u6ZJ5tsQFYKRTkCUFm2YD
	osuxmhfd116K2940YhE5f63DTTOjl1XfC1lRpBDuFcmoIFW1s7HBD0A5IKL420PD3N+/qqLRfkw
	OMtZ11l6NxRnNpVoaK+C3tOMi7dHl
X-Google-Smtp-Source: AGHT+IHYyMuPItddACX1ADJHnCstSzAXvHPDxAQjNdgUGdiE0877dFLHUdUXWRUOoRlz4okMbYYr6A==
X-Received: by 2002:a05:6902:158c:b0:e90:6ed1:ec51 with SMTP id 3f1490d57ef6-e98a578c92cmr23210220276.14.1757028355311;
        Thu, 04 Sep 2025 16:25:55 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9d6a5cdb43sm1149951276.8.2025.09.04.16.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 16:25:54 -0700 (PDT)
Message-ID: <d3c5e370-5d60-4f00-9f92-d783e0e4a051@kernel.dk>
Date: Thu, 4 Sep 2025 17:25:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
 <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
 <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
 <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
 <CADUfDZq-x3t6gfzAg8kxe8oNezDwYKggkeZ4o1Jw-Q1smjh6aQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq-x3t6gfzAg8kxe8oNezDwYKggkeZ4o1Jw-Q1smjh6aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 10:50 AM, Caleb Sander Mateos wrote:
> On Thu, Sep 4, 2025 at 9:46?AM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
>>
>> On Thu, Sep 4, 2025 at 7:52?AM Caleb Sander Mateos
>> <csander@purestorage.com> wrote:
>>>
>>> On Wed, Sep 3, 2025 at 4:30?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 9/3/25 3:55 PM, syzbot ci wrote:
>>>>> syzbot ci has tested the following series
>>>>>
>>>>> [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>>>> https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
>>>>> * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
>>>>> * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
>>>>> * [PATCH 3/4] io_uring: factor out uring_lock helpers
>>>>> * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>>>>
>>>>> and found the following issue:
>>>>> WARNING in io_handle_tw_list
>>>>>
>>>>> Full report is available here:
>>>>> https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
>>>>>
>>>>> ***
>>>>>
>>>>> WARNING in io_handle_tw_list
>>>>>
>>>>> tree:      linux-next
>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
>>>>> base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
>>>>> arch:      amd64
>>>>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>> config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
>>>>> syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro
>>>>>
>>>>> ------------[ cut here ]------------
>>>>> WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
>>>>> WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
>>>>> Modules linked in:
>>>>> CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full)
>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
>>>>> RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
>>>>> Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
>>>>> RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
>>>>> RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
>>>>> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
>>>>> RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
>>>>> R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
>>>>> R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
>>>>> FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
>>>>> Call Trace:
>>>>>  <TASK>
>>>>>  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
>>>>>  io_sq_tw io_uring/sqpoll.c:244 [inline]
>>>>>  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
>>>>>  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
>>>>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>>>  </TASK>
>>>>
>>>> Probably the sanest thing to do here is to clear
>>>> IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
>>>> allow it, it'll be impossible to uphold the locking criteria on both the
>>>> issue and register side.
>>>
>>> Yup, I was thinking the same thing. Thanks for taking a look.
>>
>> On further thought, IORING_SETUP_SQPOLL actually does guarantee a
>> single issuer. io_uring_enter() already avoids taking the uring_lock
>> in the IORING_SETUP_SQPOLL case because it doesn't issue any SQEs
>> itself. Only the SQ thread does that, so it *is* the single issuer.
>> The assertions I added in io_ring_ctx_lock()/io_ring_ctx_unlock() is
>> just unnecessarily strict. It should expect current ==
>> ctx->sq_data->thread in the IORING_SETUP_SQPOLL case.
> 
> Oh, but you are totally correct about needing the mutex to synchronize
> between issue on the SQ thread and io_uring_register() on other
> threads. Yeah, I don't see an easy way to avoid taking the mutex on
> the SQ thread unless we disallowed io_uring_register() completely.
> Clearing IORING_SETUP_SINGLE_ISSUER seems like the best option for
> now.

Right - I don't disagree that SQPOLL is the very definition of "single
issuer", but it'll still have to contend with the creating task doing
other operations that they would need mutual exclusion for. I don't
think clearing SINGLE_ISSUER on SQPOLL is a big deal, it's not like it's
worse off than before. It's just not getting the same optimizations that
the !SQPOLL single issuer path would get.

-- 
Jens Axboe


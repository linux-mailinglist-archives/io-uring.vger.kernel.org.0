Return-Path: <io-uring+bounces-10506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2C7C495C0
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F6101889C56
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F392F5311;
	Mon, 10 Nov 2025 21:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MKzCW+zR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BE92F90EA
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762808804; cv=none; b=lP3+j4krhFDoQ8Nb+kDDXptouIzikFr5YQRYIhML4k6VDpYPmkEincxDdYbEyamAdYOcIEQa4dZWIUDTjyThJQ6f3VG+rTGGza073ImBSN/JGhWnd3GzIjWWVkROFMLP5NXfhILY0HH1uOYL7QYBt2VejdMn5VT9EwR7KtcGhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762808804; c=relaxed/simple;
	bh=p9eImnkzVajZji6ba/40drjhN77svtSkMv7pWURCLRA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=KouCDiv/HUK2RHinZkfsi7V3kLIhk50LUrVaypggGJrr69Uyi+YuYTRKZMqX+9yxOFEL5InjIG7yub6wFeZYBxHbTr5mWwmj1gEiVO6slMy7RuqWo5JZAOfO5kK6Q+iCmh7QnejokzyMkIbqikh0qjCLxFaVIn++q5w3u9sSzwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MKzCW+zR; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4332381ba9bso37413505ab.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762808800; x=1763413600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAnchgHMxAbZYlLtY/QgEWE40Wk8QbLD4OHQ8Memgrg=;
        b=MKzCW+zRAkaqkyKyqUI0azF458FNsxnV7Is5TNI4u0FMKTceD55fvRvt+BHflE7Cb/
         cTWLlyAOUVtMh0fxwQMI3sCOQbriZbLVL62dhdicaZv2/41rDHLavTpFb0DAdADoQnw+
         9vOD2o5j8U+1oUaEVNR1VlsyAYlwt60F10opKc3pCnfhr67zmSvVd7Tr9X39JfHQ/Hj9
         Viv7cSHo43eYOjgdgsnvPdFYUQpRU8R5Ten5j117lm93cDfiTExD1F9+nKp/BvjtzwaD
         RTDkdMfSMPU+wMdz2+td8wu0KW4fXGKQjXL91MHCQ1rt0hKLYcVaLi0BI7zHS/9DlxXh
         yacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762808800; x=1763413600;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAnchgHMxAbZYlLtY/QgEWE40Wk8QbLD4OHQ8Memgrg=;
        b=kx7n7w7F40MXJq4MF8MBU9IcmIqYo7peWtdNI4jEYPYAqccw/ADchzD70b7DE1pfpI
         k5BnuVAhezUp+V0ZSV1xngxII4hdZegK4OhkmLPeqN19YBjUNEatxnXxjtJixBZbsZu5
         hTk7HnAaVTvZLKs9IxChwHJfOycX1N26/YJvUwf/PfmTuTD8FsN8MN9xWU2E6mygzCNB
         rtHaS/bfnS3zCfMGNcdxRtEgAPv6kNycyO2f98MJxRJmimwGdDuI1W/SddR0YPB4ORUd
         aL3VME4aurQPbX3hamHfI8VjBn5oqQyHq/v/rO3DWQaa17obaP+RJ19qrDQ1mPjzmLYO
         D53w==
X-Forwarded-Encrypted: i=1; AJvYcCW+tnRl0Gfsq1AtFcUAtbXkf9YR4EIsiLzvv8SCYeRcyZ5w7KzU1GVWF1Aloa1q3lHDKWi9DSr8sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEYZM5oZT/Al0Vvi/ig/3J6zINYIAM+KrXHPVVq61POS9FNEXg
	aWwd033Dz/fy2bktOEXE2Wt61S70Sx9v51MByHATyg9SLPvU4Z9gpBHhEJ2f9cyOhEtCxwJPV0Y
	63b/i
X-Gm-Gg: ASbGncuwllsti86NK09rc0AiHtnSP5IGQejnukp7Jya+uCGFb3AGncukoqxPKg5sprW
	LvO/5tFFOSayNHiXqfkdHaZRmo6hP27oJg8oeRo6xJkK1Lo9drIWWQENA5vTstyruhYQH+VUIc4
	kqJczhQVeL+3kwEC1FnI3wSWDuGlJyOILwGUKb2IK4vFWxt6sRAuLCUMsm94vTnAvlklqfOFOFg
	05fUCYUHxc+UlAsb7iXKzxCIHI+83BDyo+P5+RIbSEmh8BKwl1Z/vCV2oW44p5XyI/rexCOrSl7
	8HBqejWxaeQCvKI2O8dCk8nMdHmByQzu9vVLNRA51o45JY75u5cSA7TV0BOfzTBfh4RSaTerX0V
	fHhItslSwS7Gf9YmqIdGSV871NbLMR+s/Wxf3ScUsRmnyn5qE2eA83Pw27E2+olXPZVG7Gd+6U4
	xkGHAV02SXI7YOLc+WRQ==
X-Google-Smtp-Source: AGHT+IE6VCGeW4hCnKDcdc4Jk9D7a1Cpq0cNJpchGvwnc4BuBlnuVqINxxc8VIDdhMLc+uNFs0RpLg==
X-Received: by 2002:a05:6e02:3e8d:b0:433:79e4:7adb with SMTP id e9e14a558f8ab-43379e47d20mr105680505ab.11.1762808800259;
        Mon, 10 Nov 2025 13:06:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-433754f1e7dsm28354825ab.11.2025.11.10.13.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 13:06:38 -0800 (PST)
Message-ID: <dc9790ff-70de-470a-b4a1-d85dc5b1cb23@kernel.dk>
Date: Mon, 10 Nov 2025 14:06:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (2)
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69122a59.a70a0220.22f260.00fd.GAE@google.com>
 <bb64cc89-194f-4626-a048-0692239f65dd@kernel.dk>
Content-Language: en-US
In-Reply-To: <bb64cc89-194f-4626-a048-0692239f65dd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/25 1:37 PM, Jens Axboe wrote:
> On 11/10/25 11:09 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    4a0c9b339199 Merge tag 'probes-fixes-v6.18-rc4' of git://g..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12af5342580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3c93637d7648c24e1fd0
>> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16af5342580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13664412580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/bfd02a09ef4d/disk-4a0c9b33.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/ed9a1334f973/vmlinux-4a0c9b33.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/e503329437ee/bzImage-4a0c9b33.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
>>
>> BUG: memory leak
>> unreferenced object 0xffff88812638cc20 (size 32):
>>   comm "syz.0.17", pid 6104, jiffies 4294942640
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace (crc 0):
>>     kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>>     slab_post_alloc_hook mm/slub.c:4975 [inline]
>>     slab_alloc_node mm/slub.c:5280 [inline]
>>     __do_kmalloc_node mm/slub.c:5641 [inline]
>>     __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
>>     kmalloc_noprof include/linux/slab.h:961 [inline]
>>     kmalloc_array_noprof include/linux/slab.h:1003 [inline]
>>     iovec_from_user lib/iov_iter.c:1309 [inline]
>>     iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
>>     __import_iovec+0x71/0x350 lib/iov_iter.c:1363
>>     io_import_vec io_uring/rw.c:99 [inline]
>>     __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
>>     io_import_rw_buffer io_uring/rw.c:139 [inline]
>>     io_rw_do_import io_uring/rw.c:314 [inline]
>>     io_prep_rw+0xb5/0x120 io_uring/rw.c:326
>>     io_prep_rwv io_uring/rw.c:344 [inline]
>>     io_prep_readv+0x20/0x80 io_uring/rw.c:359
>>     io_init_req io_uring/io_uring.c:2248 [inline]
>>     io_submit_sqe io_uring/io_uring.c:2295 [inline]
>>     io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
>>     __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
>>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>     do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
>>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> This one doesn't make any sense to me. The reproducer given only uses
> a single segment, and hence could never hit the allocation path for
> an iovec, it'd always just use the embedded vec?!

Ah nevermind, I see what this is now. We can still alloc for lower
counts, if we don't have a persistent one already.

-- 
Jens Axboe



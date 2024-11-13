Return-Path: <io-uring+bounces-4644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE5C9C6E0F
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 12:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DFC31F253B4
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 11:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D99B20010A;
	Wed, 13 Nov 2024 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhR68jQA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5EC4DA04;
	Wed, 13 Nov 2024 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498123; cv=none; b=ekT/A6jHR29Xflv/B8gk86P/Q83tgeJnIJiRfNa3iWTdVY11D5henjYMiQ8FEaMxIt4VJ5WGO+8vvUyb2PG6GuqiBvEm6Zzjj8xd5d8vxKrEHscaNi6/A6Qy5htq1H/nEVyzYOJChNUir1bgsm7BwoG342sYLrnPNpAVrVr5a0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498123; c=relaxed/simple;
	bh=PMIncaEeXWcWPEA4rDCmxwepYu6a15MVimvl7Cy7g4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QVYUeAxmV7QipB+losy3wsb1Jxr2bAsGP+ZYmt5k2ls/z9aWHkYqwTPKIDLO8VXQTte8ol0sHZoXaLA/FBvRTSPu1alWRJkZYucfWLQ7c4fsCfyjHjNia4sALXaV8RkcD3psIVEljFz/syYF+n8mU56EZ/AOzssceDPvU8bAn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhR68jQA; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9ed49edd41so1153488466b.0;
        Wed, 13 Nov 2024 03:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731498120; x=1732102920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VnUpzgEd4fvXH4JZN2LOT4I7hzGeDKaC0bnh+9VTaTw=;
        b=LhR68jQAdET236/m8vJ136YJAANMkiUxHllPLgbyI55ZkFBgRVRz1UJldE0vomOJmO
         66bjXRRDTlYLlAeyu4+vS9jbR94n0wPIwm6FUjLMDP2OYpPtUVJssanXPyxcRYgFia2T
         u8mBZTdoIaMI7lSuTmC4n1MJU8OgNrheUCxnWSmMWVxps07UpTFRPkJ7JQbfue76QVD0
         +sJ3BrJV5/mQzf5XL5l6tZkztSStYMgvyoednG2xW/A++8h0FOfcVKuv257Q9ZWJSCVv
         atpEMXypE2/q/6L4te/alhkwVHQitQrQX4LupI8er+LkHHMaG+BehH5Hk31T5OtAJSnn
         z4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731498120; x=1732102920;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VnUpzgEd4fvXH4JZN2LOT4I7hzGeDKaC0bnh+9VTaTw=;
        b=BpB32xF3KCzi5MUTn71skMdBnwvGTiLJvu9tQJkYbr93YkCOHNFjkhQoWLz+RMb6QU
         B4H2uAQ5rKJWa/WBFYjere8+MSxAGbah3uz2G6fcdKJEZTwhp+Z2wjuaKgD9stTfycP2
         QuOa+NpK9liKMi0GHkTWhOJd76D4S6g6pvlVVEr2uDSZm8IqwYSJ6poNMefgtt5cQPt6
         JEg5SrzC8rrRugFlfcW00+Q4JfelcwqLP2EAALXMHrBM4B6wdRxLhedsiAYytj8leonQ
         hgp30jrM+E1NbUxyS8WHWoHXlOQpqGfTWI84ghPbruSJ5t3ftksR8PMrOMiQZaXP6Mrk
         UeMA==
X-Forwarded-Encrypted: i=1; AJvYcCUEGGjhhYYpmvFDUG0i0WQtAC6R8k/rtjCE93qH2V/qfNsVJkMqA2SS8DoRcBaSxcGFtRUzKL0aIdPPEmpn@vger.kernel.org, AJvYcCWktMcqwhjOWmk+Lm0CbYsKiJHPFrVtPTI/NjDv4kCrxfGsWue8FelSFkZCTa2PCNMwA7gcA1763g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjU5BsvgHJYVetpQtcEbdfOj52yUA7H/G8nhDt//j8VV4QZRJ6
	pr1dGQk0qMVloFkdK3jGHl19uWfZIkyYprPegIgcghQgXxDu106R
X-Google-Smtp-Source: AGHT+IHcSuQqX66cLW7vEPsusPnY87zBOxCkBLvdrl/vnaD4EA/yJT6KpX1KHT0q9gHdTpqLDIJGqw==
X-Received: by 2002:a17:907:6d28:b0:a9a:67a9:dc45 with SMTP id a640c23a62f3a-a9eefebd422mr1878752066b.3.1731498119436;
        Wed, 13 Nov 2024 03:41:59 -0800 (PST)
Received: from [192.168.42.32] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0ad2f76sm845662166b.89.2024.11.13.03.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 03:41:59 -0800 (PST)
Message-ID: <03028b7f-95e8-4b9c-a52a-77b02f83fb21@gmail.com>
Date: Wed, 13 Nov 2024 11:42:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in
 __se_sys_io_uring_register / io_sqe_files_register (3)
To: syzbot <syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <673488a6.050a0220.2a2fcc.000a.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <673488a6.050a0220.2a2fcc.000a.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 11:08, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2d5404caa8c7 Linux 6.12-rc7
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e838c0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=29fedde79f609854
> dashboard link: https://syzkaller.appspot.com/bug?extid=5a486fef3de40e0d8c76
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/15a7713979b8/disk-2d5404ca.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b51c4f695d4a/vmlinux-2d5404ca.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e8c0f17bc00b/bzImage-2d5404ca.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in __se_sys_io_uring_register / io_sqe_files_register
> 
> read-write to 0xffff8881021940b8 of 4 bytes by task 5923 on cpu 1:
>   io_sqe_files_register+0x2c4/0x3b0 io_uring/rsrc.c:713
>   __io_uring_register io_uring/register.c:403 [inline]
>   __do_sys_io_uring_register io_uring/register.c:611 [inline]
>   __se_sys_io_uring_register+0x8d0/0x1280 io_uring/register.c:591
>   __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
>   x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff8881021940b8 of 4 bytes by task 5924 on cpu 0:
>   __do_sys_io_uring_register io_uring/register.c:613 [inline]

Seems to point to tracing:

mutex_lock(&ctx->uring_lock);
ret = __io_uring_register(ctx, opcode, arg, nr_args);
mutex_unlock(&ctx->uring_lock);
trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);

And thus we don't care much about it, but we can just move it
one line up under the lock.

-- 
Pavel Begunkov


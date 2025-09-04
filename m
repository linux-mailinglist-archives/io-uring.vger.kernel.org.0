Return-Path: <io-uring+bounces-9577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7AFB44A61
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 01:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4BDA7A1A8B
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 23:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C19C2ED84A;
	Thu,  4 Sep 2025 23:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FGop1r6j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498728152B
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028045; cv=none; b=pOZqEnKVJO4cOBHyFVWFymw1AJVn4JyFWfeBoyOp5Am0c73zabe8F37fOFFJFofQut+f7ZXEFMTzlpDPg8nz00U2UH9MvobJBSNmA3hEmwcxnNH5ilQqt0Y4lOocghDHEXKlAOfgOPWdZNJO+7G5W11uwcs7Co1ub1ra9qu4gT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028045; c=relaxed/simple;
	bh=ewALHqGy5tuuTChxZiDl3T7/UNGXb7XI/a+bgYYFYQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X2x7gKbMcZYKx64g8c1kithUhqmAQ1Sl2bNdJule2+TNB6f8uH5Uq0qLZfEqhqlY/kkDNoJKg1uJ2vam4lJdtu8kdELbu0DnAzpD+27JIJEY9vKSBWR7M4GzYmhnrhcyELMl4bwIbMo2oM+3AsEyiqFmLXUgripuA6F8MpQAGs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FGop1r6j; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d6014810fso16861247b3.0
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 16:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757028042; x=1757632842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aRwZHhESXMYZyHSR6sI/Jb9sZA0hD8LgQNqFD43qiSc=;
        b=FGop1r6jP5UNg6doJ1ld5yamCh5V3za9yUI6wJDbvP/rhYBS7p/GjJH7EXaMqcNIhy
         1N/a/GiTERJMKrSy1vvJZul0iQb89o/KSEjEC8UZYU9dU8rFXBhrJWXMRamvdEzOhFhW
         Vuveh74BlzEAODROfGYOHdmVi6vj04a2LGrJxGRxB/b+m43YlXJijOpkj6sNNSdfW4ED
         djbOgmsn9gqVn2067Lm8UZilhL4QTZcmiR6lw0T4Cg8UliY4vP+OLOnbxfIUyrPkfMcw
         ZAUZSwKK4iA3sN8l/wzmAFH3T/uGUcCuqZjWYlSWS6CI1jXAjtWvHAHyBg7FgPPQ9ORp
         D52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757028042; x=1757632842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aRwZHhESXMYZyHSR6sI/Jb9sZA0hD8LgQNqFD43qiSc=;
        b=BO5CymGpPYK2FEy76Pn/6/fCoRUc5aVrGWZRTRJ6ZtZwPnF+9oEei7XzzakdYlR2w7
         DhVDVmVxpI2wIjmkXD1/Fw6jcw8ZkvNH9Wo54Nb/1AoP4wCj2CioJA6yVvTjxzIutMIh
         9J9HgU7zyGzUl8rTRKxSZEux5XiNIaDRQ8jvNnPAYEQh3WpW8ny3+kyboeXsvkJKctpH
         acx29GicJ6WS6jsxG8jU4L3EtG0X2QMFIDzS3PCPBndz3EZnfZsLLb52kmGrrgfP4g2V
         xamm8779k2k2PYaD83Ve+7+MRrX0YycEWmTvhohty5OK/ltZ2Nbo+utUB9wwKMpOWSbV
         oQ6w==
X-Forwarded-Encrypted: i=1; AJvYcCXg1+OPxwWneJMQwrxCa/YEQE9G1ubFUTzXYsqKIPDjlVBgfYZQg8yHFr8nXS6XgSKxOub/DXLz1g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzk6LeCn7BQ8J8lI12wXjcD6JWWWzcF91TicOGylkPE7nZalSd
	X8N1MEUhuAvgYggnobDj3SWLuPEsmwTR5IcQ9+WBkoR/QAO+o2r/UzlEsYNDgXKD4+k=
X-Gm-Gg: ASbGncsqULSSZhkvwoUAGi0ydDxh68lWGcuPBFh9UOcX5C6scsTUFjDIrzS4m3YqkOj
	BNckxfGCTHQ7gGbCtnrETI0QWuxPSI+tWTMVvkWeNjP3sbksblfKPVgjrJaQvp/5HSKbO6dob6n
	o3dCQJiwZG/WeuL+r3BO3vbkXPtbR4HcpD2g9QuhvuPmL9B/bGJkTyUmBKdaV3t3KbQS5FmALw3
	K3cC4Z1KzBDSYu9xsvngt2lvTMxDBkYYvZzfA1TPg1TnN/ryg4AJd0k6MTnAfE8fviBQWc/f9b4
	cVjIaz1rKqINMgi/JAwrrZaNa7eowxZshRSVNLqSyT5qUS+0L9OIU0NltrSQxjqJfwKZDW/+zhe
	0ldhEGU4NQWg9dzOygnq/2jYNSH/4
X-Google-Smtp-Source: AGHT+IGvbBhMOcXfylPm/9NSlvF5+lCTc4rsnucF8Y+pzJ+UJ37E30YkGhwUDgeXMdUu0Kd7n9YtCg==
X-Received: by 2002:a05:690c:6f0f:b0:71f:df7e:2d0 with SMTP id 00721157ae682-722764ad026mr226492207b3.25.1757028042300;
        Thu, 04 Sep 2025 16:20:42 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a832e435sm25422227b3.26.2025.09.04.16.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 16:20:41 -0700 (PDT)
Message-ID: <54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
Date: Thu, 4 Sep 2025 17:20:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in
 io_sqe_buffer_register
To: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>
References: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 9:36 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1785fe62580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f23e62580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cb6312580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
> BUG: KASAN: null-ptr-deref in PageCompound include/linux/page-flags.h:331 [inline]
> BUG: KASAN: null-ptr-deref in io_buffer_account_pin io_uring/rsrc.c:668 [inline]
> BUG: KASAN: null-ptr-deref in io_sqe_buffer_register+0x369/0x20a0 io_uring/rsrc.c:817
> Read of size 8 at addr 0000000000000000 by task syz.0.17/6020
> 
> CPU: 0 UID: 0 PID: 6020 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>  PageCompound include/linux/page-flags.h:331 [inline]
>  io_buffer_account_pin io_uring/rsrc.c:668 [inline]
>  io_sqe_buffer_register+0x369/0x20a0 io_uring/rsrc.c:817
>  __io_sqe_buffers_update io_uring/rsrc.c:322 [inline]
>  __io_register_rsrc_update+0x55e/0x11b0 io_uring/rsrc.c:360
>  io_register_rsrc_update+0x196/0x1a0 io_uring/rsrc.c:391
>  __io_uring_register io_uring/register.c:736 [inline]
>  __do_sys_io_uring_register io_uring/register.c:926 [inline]
>  __se_sys_io_uring_register+0x795/0x11b0 io_uring/register.c:903
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f99b1f8ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f99b2d88038 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007f99b21c5fa0 RCX: 00007f99b1f8ebe9
> RDX: 00002000000003c0 RSI: 0000000000000010 RDI: 0000000000000003
> RBP: 00007f99b2011e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f99b21c6038 R14: 00007f99b21c5fa0 R15: 00007ffeadfa5958
>  </TASK>
> ==================================================================

This is from the mm-unstable changes in linux-next, adding David as I
ran a quick bisect and it said:

da6b34293ff8dbb78f8b9278c9a492925bbf1f87 is the first bad commit
commit da6b34293ff8dbb78f8b9278c9a492925bbf1f87
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Sep 1 17:03:40 2025 +0200

    mm/gup: remove record_subpages()
    
    We can just cleanup the code by calculating the #refs earlier, so we can
    just inline what remains of record_subpages().
    
    Calculate the number of references/pages ahead of times, and record them
    only once all our tests passed.
    
    Link: https://lkml.kernel.org/r/20250901150359.867252-20-david@redhat.com
    Signed-off-by: David Hildenbrand <david@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I won't personally have time to look into this until after the weekend,
but as it's linux-next specific, not a huge deal right now.

Note that there's also a similar report, which is the same thing:

https://lore.kernel.org/all/68b9d130.a00a0220.eb3d.0008.GAE@google.com/

which I marked as dupe of this one.

-- 
Jens Axboe


Return-Path: <io-uring+bounces-1769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A438BCA32
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 11:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2F11F20F94
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 09:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F58140374;
	Mon,  6 May 2024 09:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9aSENte"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57A51422A3
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714986286; cv=none; b=S6sedP/BPktmliuoA8cwAD2S631jRy2CLhvrUOGZkCDKA3HzljquoPrCBH7v5SqSeqeHB5ABiOqk5wiWkSZbILwaMu5n1/nENjkPTxwEKsW1UUfzU88RBj/xaeQCHOH/PckBuvanGhjcoRVjrQro6qXZQtO+7LWj8iofkERDYBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714986286; c=relaxed/simple;
	bh=P6jKRP8WdSAvZ8RrcvBEhhc2F5D0qVrJOPA9QiOcuWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nNc3/bT0s8IKoFADLVFWBlqW842GzJm0XCeVTcwgqNVJ941SWDPpe6L0ao7P6rgcT25rtn7mqVkiPOAHfA77hxr6VGzULz+1D/4emQ58ZqNb0VqXhsUBuURQpZ7g/5atS72WRPIs6B/mjJHCaQktcyIK4DtVt1hUontmjcbKCJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9aSENte; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714986283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TNxJ90r7OIOz6OKvqUrw671Q/oNs3xYKmR6x/WOwqn0=;
	b=Y9aSENtedmt9LTJ8gAmbLP0r9zy4RizA7Dtqk+2KKlGsSgiExyZYleZkIWoRzedQW6L8/4
	PxwLSId8v7p8UpbnLLh9feecNAokgrMC9C/bK3DcwvRN8TFFEOVPIcF0lzw7sIBBPcC/W6
	z6HYxeTPhwjbgNLa97DEXBRWOk9rtIg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-OO2FGM0bO7u5dUQJEmF-5Q-1; Mon, 06 May 2024 05:04:42 -0400
X-MC-Unique: OO2FGM0bO7u5dUQJEmF-5Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41ab62f535aso5804485e9.0
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 02:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714986281; x=1715591081;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNxJ90r7OIOz6OKvqUrw671Q/oNs3xYKmR6x/WOwqn0=;
        b=prfDQoPWK8yJvvrEKo0ISuTtUjzMmM8F7Yd+uuKi5ImhSt2NhEjVHyM+gb5D9SLBus
         01Qz+uszXKeILY51tSm2U+NpWGcZcXZZugBQlUCZ4DC6O9qyeTkBfF6QMxarKC178l0H
         8FbASp8mPGwYE3RLbL7UP+EGg7w0lxOUFAxsUpzJjNGpDnbQzPGFwfnF9eP6Sy60cT3C
         PAaDTkuZNznQhga8RKLm0Jtqc2YCwGpoD7S7NuirrKRWNwmdyRGuO7JE5gUJn6aocdmX
         vaeY7AUgpA8FDOBBPyvqKjIYnokR1Ri4VdUjTR7mhNPXrc4m9cKDHik3TphY6qL3a9bd
         Nsxg==
X-Forwarded-Encrypted: i=1; AJvYcCWZwMdVrZm5ptVZg+iheyGFjH4K+7pmnpPpTqlsvs0Oy2YSNCmNjuNywEOtAgT9ZjBSIfLrKxMiDQH4EQlOKSJGCU4+Gw4RdlQ=
X-Gm-Message-State: AOJu0Yw2Z+aqE2A74o69DS6JVwaxlwqYU9vDyoUqcG2DRCB7dEXtRJW8
	unOZsCClxq/10u/3mfQ5GCgw/3yjSx9Xz5BEmZtO+g4vB88QDvOfLtwuMeBF6Pdy+OUMngGcjdA
	v3n5DjbsguMRL9UOU7jHwUiVql/jlxcb1G0iO+AlGbRpzNUh+xr4w6y7Q
X-Received: by 2002:a05:600c:4691:b0:41a:141c:e15a with SMTP id p17-20020a05600c469100b0041a141ce15amr7565496wmo.16.1714986281127;
        Mon, 06 May 2024 02:04:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOLIGr3ODLDhvC3tmKKtdQELzrPVmv7NZt12FE6eNlKj4YgDVIsNmX1yfGqnXQexcDMsAfOQ==
X-Received: by 2002:a05:600c:4691:b0:41a:141c:e15a with SMTP id p17-20020a05600c469100b0041a141ce15amr7565473wmo.16.1714986280679;
        Mon, 06 May 2024 02:04:40 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:bf00:182c:d606:87cf:6fea? (p200300cbc74bbf00182cd60687cf6fea.dip0.t-ipconnect.de. [2003:cb:c74b:bf00:182c:d606:87cf:6fea])
        by smtp.gmail.com with ESMTPSA id n44-20020a05600c502c00b004146e58cc35sm19248292wmr.46.2024.05.06.02.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 02:04:40 -0700 (PDT)
Message-ID: <af1a4b81-22f3-4955-8c44-95bede13a7bb@redhat.com>
Date: Mon, 6 May 2024 11:04:39 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [io-uring?] WARNING in hpage_collapse_scan_pmd (2)
To: syzbot <syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com, Peter Xu <peterx@redhat.com>
References: <0000000000006923bb06178ce04a@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <0000000000006923bb06178ce04a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.05.24 15:41, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e67572cd2204 Linux 6.9-rc6
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1067d2f8980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
> dashboard link: https://syzkaller.appspot.com/bug?extid=5ea2845f44caa77f5543
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10874a40980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d3c4905a7f32/disk-e67572cd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9e4d1fc8f9c1/vmlinux-e67572cd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4616b77edaee/bzImage-e67572cd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5288 at arch/x86/include/asm/pgtable.h:403 pte_uffd_wp arch/x86/include/asm/pgtable.h:403 [inline]
> WARNING: CPU: 1 PID: 5288 at arch/x86/include/asm/pgtable.h:403 hpage_collapse_scan_pmd+0xd32/0x14c0 mm/khugepaged.c:1316

That's the

WARN_ON_ONCE(wp && pte_write(pte));

check during pte_uffd_wp() in hpage_collapse_scan_pmd().

Maybe fixed by

commit fffa0c5024e8c90dced69b7fcde1d738384a1069
Author: Peter Xu <peterx@redhat.com>
Date:   Mon Apr 22 09:33:11 2024 -0400

     mm/userfaultfd: reset ptes when close() for wr-protected ones


That resides in mm-hotfixes-unstable

(in which case we might want to tag it as stable)


> Modules linked in:
> CPU: 1 PID: 5288 Comm: syz-executor.4 Not tainted 6.9.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> RIP: 0010:pte_uffd_wp arch/x86/include/asm/pgtable.h:403 [inline]
> RIP: 0010:hpage_collapse_scan_pmd+0xd32/0x14c0 mm/khugepaged.c:1316
> Code: 90 90 e9 4b f6 ff ff 4c 8b 64 24 48 e8 f7 ee 9e ff 31 ff 4c 89 ee e8 fd e9 9e ff 4d 85 ed 0f 84 b5 01 00 00 e8 df ee 9e ff 90 <0f> 0b 90 41 be 09 00 00 00 0f b6 6c 24 47 48 8b 5c 24 10 e9 fb fa
> RSP: 0018:ffffc90003abf9b0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88807a402000 RCX: ffffffff81eed643
> RDX: ffff888021ddbc00 RSI: ffffffff81eed651 RDI: 0000000000000007
> RBP: 000000006897fc67 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000002 R12: 0000000020800000
> R13: 0000000000000002 R14: 0000000000000400 R15: ffff88801e4dcc00
> FS:  00007fd661dde6c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7e57ed9ba1 CR3: 0000000025328000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   madvise_collapse+0x738/0xb10 mm/khugepaged.c:2761
>   madvise_vma_behavior+0x202/0x1b20 mm/madvise.c:1074
>   madvise_walk_vmas+0x1cf/0x2c0 mm/madvise.c:1248
>   do_madvise+0x309/0x640 mm/madvise.c:1428
>   __do_sys_madvise mm/madvise.c:1441 [inline]
>   __se_sys_madvise mm/madvise.c:1439 [inline]
>   __x64_sys_madvise+0xa9/0x110 mm/madvise.c:1439
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xcf/0x260 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd66227dea9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd661dde0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fd6623ac050 RCX: 00007fd66227dea9
> RDX: 0000000000000019 RSI: 00000000dfc3efff RDI: 00000000203c1000
> RBP: 00007fd6622ca4a4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000006e R14: 00007fd6623ac050 R15: 00007ffd98c8dfa8
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-hotfixes-unstable

-- 
Cheers,

David / dhildenb



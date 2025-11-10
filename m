Return-Path: <io-uring+bounces-10504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6629FC49434
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 892DD4E7AB1
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 20:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFDC2EFD91;
	Mon, 10 Nov 2025 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VRORgA2S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D7C2EF646
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 20:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807033; cv=none; b=D0OBLwjeDogNjPPQKI10un1u0cLqYXyOY4ZnQGmeo4mIc+Kf9Oa8qbyZKpL5zSknv7j3CiV6HdM/QdP2GESCmcFmaDh88fePb+1kVLZ/yA69YlYC0zj/D0SyOYvOJLl/vFL0008yXH56iZCpVgpy1N7msujHMyBoup7I/3Vr67s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807033; c=relaxed/simple;
	bh=3QRzL6KiVufSbSlXjca3DhGEofbmZoco/KcHN4Hlibw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P86CTZocA5iw4IL8edhauAmSCE5WDx083pNySN3d8c4o12TSx2GVROKd0cFB3EWxwOEYx5xsAK3o7Z7Q5Qs89v+n6xd1ob/ofovTsg6LXL/dA/U4zVxyrqzHwiDokoXzNyRxHfltoUKs08NK28rwNWQ/zP8dvCyrcN2EpVMStOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VRORgA2S; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4330e3080bfso12240425ab.2
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 12:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762807029; x=1763411829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a7JWVgDY7ZOp5yY1nE+ehHytyqrFQTQY2al6sgpKXpc=;
        b=VRORgA2SUSWzWbL+k8jK2zxAzLSSw3xwE8Tzh6HDEGl+fHmi/rVDul1plC4/fWvm2P
         0tvjiRe5Y2Gq6VLgK3xIKGVGGYCibwVQ4/UuLu0o21Dk8f1XHtJI1Wxe+f+EhNUtviG8
         fd4UsJbNH7LCVCZSBJcR3cFtcVS5Kjc2NPWE+0hXTdgx2t2i/HeELR8Cp6pw0UONKo8G
         24bjxZZFabrLul2UWh/IgxU0d72mhwqZQizm4LwQzMaq9qD8AXzSV6OqfiHOMvPZacop
         VMpY21Q9a24+NhkZZNLqUmW/cO3vjtDQtYC8CRT6YMRFpek+bFJjMH1U3HlnzgKg8DRH
         vaKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762807029; x=1763411829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a7JWVgDY7ZOp5yY1nE+ehHytyqrFQTQY2al6sgpKXpc=;
        b=bOkJEMDi1v9psQORKmVZstzcmfRQsroEx6+TUWRHzMwH2dC7C7Z+vvIZsSeNV09+Jr
         fyIkV/8Owy5gO3BUmstgogBOcSsV1NJyLnz4GLSOiSn8hHdyKy89bqsvEldczpg2s2Sw
         3KjWkANp4mP5/YBo52DcoWVjse7alXoLwvK7hsJBRddQ4D/dMy330GcJRzdojsEhi6p3
         HRgijpOGVf+5Vg2mpMtzY9SGVpkCH//hsCE6xjaLD15V0BnICeZpVAjrHIXK4UHdrti2
         Rwh90L6FjroiSCKAfWpub4m4xFaTuPlMuyqAcVKakY7pRbqVT9CCY+BpriSf+DH4uTeU
         LNrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU4jYB5AgMpOJX4eTuKpuCXaTaqKu9tov5gz+Ice1egOUIDgmDLNFMUy5C6DDP2mforARHW8+6gA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLtUlu6/9HZzXurboootFi0CBrDlgcpPOVi8lEumnDtAOKM2Ux
	fcHf0dwuqNrXKIfsFMDWS/CG/MybzW5s//vOPhTAR04HWQJn1uZc6dZB3Mr0TX0jOKA=
X-Gm-Gg: ASbGncsny0Kj55DktT2l6fGwkTFdTFngi74jXd8NfT06DJImo1S9qDlc5oY5VrQw+T5
	1gSQt625SDg6toSCDbaNegZw/govDsdh0xzAahLYSkSRpPLNeC9Z6kB7Lo19G+e4VbxRxD0d7r9
	P4kK0MkzIVR4o2W3W1z4rGoUY7s2odJlvubVeDmJib9MECiST3IJj+rLaTppGMXqhhPW0skVyAb
	MDYoLOU7dqc39g6Yh4od/1I27c+n32W1DTnbH/7N3Rh1gWpT2ZrwYRCzI8YNxBJX/zDz78JokHf
	mKoaMjI0sQOoNGZUDs/c/bNWxfG5c04C5TqMQhzAdhdp5D5ch0XvlpoO+fQRPTF2PV6dlkBNWcA
	wCK5xyl3CbV40F/XUZ+GTU8RlSJS4iHYKXN9go7z9eHPlVBoNvEuETQwc7wWlfOK+CvFEu86Fk/
	JCXIqQa0k=
X-Google-Smtp-Source: AGHT+IHb7gCQ9TEEs+ynvDaT6nNTImVkj2v/QbrKYdL6dahq+P6/ageh0RV5Q2qbponGv+x9wHYXgA==
X-Received: by 2002:a05:6e02:17ca:b0:433:5a9d:dac6 with SMTP id e9e14a558f8ab-43367e7166fmr139020985ab.27.1762807028949;
        Mon, 10 Nov 2025 12:37:08 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b746806d41sm5409820173.20.2025.11.10.12.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 12:37:08 -0800 (PST)
Message-ID: <bb64cc89-194f-4626-a048-0692239f65dd@kernel.dk>
Date: Mon, 10 Nov 2025 13:37:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (2)
To: syzbot <syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69122a59.a70a0220.22f260.00fd.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69122a59.a70a0220.22f260.00fd.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/25 11:09 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4a0c9b339199 Merge tag 'probes-fixes-v6.18-rc4' of git://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12af5342580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
> dashboard link: https://syzkaller.appspot.com/bug?extid=3c93637d7648c24e1fd0
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16af5342580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13664412580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/bfd02a09ef4d/disk-4a0c9b33.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ed9a1334f973/vmlinux-4a0c9b33.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e503329437ee/bzImage-4a0c9b33.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff88812638cc20 (size 32):
>   comm "syz.0.17", pid 6104, jiffies 4294942640
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>     slab_post_alloc_hook mm/slub.c:4975 [inline]
>     slab_alloc_node mm/slub.c:5280 [inline]
>     __do_kmalloc_node mm/slub.c:5641 [inline]
>     __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
>     kmalloc_noprof include/linux/slab.h:961 [inline]
>     kmalloc_array_noprof include/linux/slab.h:1003 [inline]
>     iovec_from_user lib/iov_iter.c:1309 [inline]
>     iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
>     __import_iovec+0x71/0x350 lib/iov_iter.c:1363
>     io_import_vec io_uring/rw.c:99 [inline]
>     __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
>     io_import_rw_buffer io_uring/rw.c:139 [inline]
>     io_rw_do_import io_uring/rw.c:314 [inline]
>     io_prep_rw+0xb5/0x120 io_uring/rw.c:326
>     io_prep_rwv io_uring/rw.c:344 [inline]
>     io_prep_readv+0x20/0x80 io_uring/rw.c:359
>     io_init_req io_uring/io_uring.c:2248 [inline]
>     io_submit_sqe io_uring/io_uring.c:2295 [inline]
>     io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
>     __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>     do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f

This one doesn't make any sense to me. The reproducer given only uses
a single segment, and hence could never hit the allocation path for
an iovec, it'd always just use the embedded vec?!

-- 
Jens Axboe



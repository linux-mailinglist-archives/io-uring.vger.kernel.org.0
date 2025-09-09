Return-Path: <io-uring+bounces-9696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047A2B50937
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 01:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A48681766
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 23:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC1A287262;
	Tue,  9 Sep 2025 23:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yk/pAYE0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDDD2874F7
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757460358; cv=none; b=QLdlWsVfcG8w3wWmfBOZKmwIRXGnvmoQUb32eTNIXFTl8hRQJqIxMMqGl6x6bLtusACnKf0UbQMZnEL9cpkW8ND9GlBHTcUrDq1PsuZaLLWweZ4u+oD1bNvGV2/xfwmLCBmBa/z/wiYm9erKZ2kGgLQRuuldhT8WzoSNrge+AJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757460358; c=relaxed/simple;
	bh=uNnxA1dvmfWjwsoIO7gvN9DB6GhDSc1uSFjsdbCoD1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a66ZbnWb2SKJGdXQKzJxPjKPdleVr7J45vy/c/N86LE59MrBYY1i562pzN/wGo4g8QOt9qpTziE8A0pRTTy3lNVeZiilnJpd5NXLUcJ9QGglgkkp3OWQn2uzM5LDRvTzqN/3pLRQtFmFsk7KPGmLhoxLurK8VVvBglxJnJzYV5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yk/pAYE0; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b52403c47b7so74001a12.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757460356; x=1758065156; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HBxFRmy+wMZ+rkIR8J9ER+la6ZPfBh/wFz0ioFZnNGI=;
        b=yk/pAYE0RdmqFwXHi8gUpeMBT75amxBXFSS+4br3RoKwZ/BNkSi34jgnK+ZIqqj7Sd
         +Wauj1UtlUI9cQivMaX/hggj93MrqQC+1+i+IvHNQm/WAzduWiBR9Uah/KFwVLE64kAk
         hcfEftBesZ68WvDAbIcYdKDLTwL/s6iaB511wikVzVURRk/CzmvTxQbVdinvTOKlY852
         zNiOV9iKfuMfzR9hjRLGZ1B4wh2k5Q3M3QgD36ZM5eB/tpj7LzD/Wddp7S6YO9HdG776
         0By2iI38wqQLqrKz9kxoWAj1H1FRO88RAL7DvFaS8BDIm7P4vcOWAw4vzivvX0rRYXyy
         12AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757460356; x=1758065156;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HBxFRmy+wMZ+rkIR8J9ER+la6ZPfBh/wFz0ioFZnNGI=;
        b=tQLkZPrqFapsKDQ5vplTzs2rKOuxPOG5kOG5XrAUXO9+/cVTTrCEIQ33IAMlSMBSHX
         WY9sskpCWh475aVsKsy3xrG4d+zNVnqpYjC4/bFTmtgXwwX6MZHqW+3s7FzpX3M5zQwr
         jedgk9CDwREUnVd92q3fIvVPfKpfutq5OMWy6EGmmy6MM76mwStBeaXRp7VWzAWb4+nM
         RdqWiO+6azlIfL5TG5dEfEaTnrbYlHp+Zz29ICK490zwMiAfeA7NIV6mItSWYhAYOysn
         HPi+huF7NJb418KXSKwdLdX9ViK5tjaE4HP2QWhu1HfFAFZucoZtZTCDlI6RyFEpWzrj
         UPBA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ2ZNKPu5s+BhWI2/doK0zZraQbdSiZQs9DmINqZdaRScK6sO1hKwTh6NxRxdz9g9iSt0F8LCQ9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvtCmh84Lqwy0b71qvEsxRRN8hCoiWxuYCA7prkS2X3XViB9Ux
	//5uzZqmkUB9Dsbd55rR8PpKvLa6t2Y+mIignSDJJ3AlVwJ/2Bk4orPcbdlxKNjuRdA=
X-Gm-Gg: ASbGncsk1Uv6rbb2uEshZ4WC8Elkw1AqxwGAYxN9YMJ8UqwH50SNjDXj/FGwRe3JhWb
	ZnOpDCTWmyZdFJPZ4ojvtH4dIEwb6HmHRsWxk0DM24ErHLIcjTMT3bE8iYEy3UTNFO+Ll2qyMWO
	P6aLblvtdXnLUy7y2IHxCrcElmxW0CQb73z9Q+527nn2h20zzuvICsrphUxYA/HmrZiQ4tAR8vY
	LGxZB27XA/Q9OyhjkNO67MQHqceolrHuU33ZhWcxf8gK5IOf5XmtI3rUPfxQ9YQIoss5QzKJvyL
	uiduH4rYPK7OILaAktNw6WFe2ZNAU6xU0sn9mIe5dlkKzYlsdMctVcxorfD2LHjQ58Ho/wlK+LA
	B31pXUW8IJ1fCXlQheO2g
X-Google-Smtp-Source: AGHT+IHTJAcexgKuiEtX0sdtjTDp5lzxWIJa6pazhA5lwXpq0XJzwHpIpOJgNsfaZxB7EBVzTz/71A==
X-Received: by 2002:a17:903:2450:b0:24c:cb6b:105a with SMTP id d9443c01a7336-2517a7dc904mr201370645ad.30.1757460355646;
        Tue, 09 Sep 2025 16:25:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422b73sm8756665ad.3.2025.09.09.16.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 16:25:55 -0700 (PDT)
Message-ID: <58bf0d4f-e89b-4d1d-a917-89d0d88be365@kernel.dk>
Date: Tue, 9 Sep 2025 17:25:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush (2)
To: syzbot <syzbot+42d478f812698fed9f41@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68c097c6.050a0220.3c6139.000c.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68c097c6.050a0220.3c6139.000c.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/25 3:10 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    be5d4872e528 Add linux-next specific files for 20250905
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1458a962580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=114fb6eb337a294b
> dashboard link: https://syzkaller.appspot.com/bug?extid=42d478f812698fed9f41
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1510d312580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1258a962580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fb814704342a/disk-be5d4872.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4f4366b3c12b/vmlinux-be5d4872.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7b2472ced6f9/bzImage-be5d4872.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+42d478f812698fed9f41@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/vmalloc.c:538 at vmap_pages_pte_range mm/vmalloc.c:538 [inline], CPU#0: syz.0.17/6034
> WARNING: mm/vmalloc.c:538 at vmap_pages_pmd_range mm/vmalloc.c:569 [inline], CPU#0: syz.0.17/6034
> WARNING: mm/vmalloc.c:538 at vmap_pages_pud_range mm/vmalloc.c:587 [inline], CPU#0: syz.0.17/6034
> WARNING: mm/vmalloc.c:538 at vmap_pages_p4d_range mm/vmalloc.c:605 [inline], CPU#0: syz.0.17/6034
> WARNING: mm/vmalloc.c:538 at vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline], CPU#0: syz.0.17/6034
> WARNING: mm/vmalloc.c:538 at __vmap_pages_range_noflush+0xdf1/0xf30 mm/vmalloc.c:656, CPU#0: syz.0.17/6034
> Modules linked in:
> CPU: 0 UID: 0 PID: 6034 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:vmap_pages_pte_range mm/vmalloc.c:538 [inline]
> RIP: 0010:vmap_pages_pmd_range mm/vmalloc.c:569 [inline]
> RIP: 0010:vmap_pages_pud_range mm/vmalloc.c:587 [inline]
> RIP: 0010:vmap_pages_p4d_range mm/vmalloc.c:605 [inline]
> RIP: 0010:vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline]
> RIP: 0010:__vmap_pages_range_noflush+0xdf1/0xf30 mm/vmalloc.c:656
> Code: eb 7b e8 92 1e ad ff eb 2f e8 8b 1e ad ff eb 6d e8 84 1e ad ff 31 ed eb 64 e8 7b 1e ad ff 90 0f 0b 90 eb 14 e8 70 1e ad ff 90 <0f> 0b 90 eb 09 e8 65 1e ad ff 90 0f 0b 90 bd f4 ff ff ff 44 8b 74
> RSP: 0018:ffffc90003dff950 EFLAGS: 00010293
> RAX: ffffffff8213e750 RBX: dffffc0000000000 RCX: ffff888030da3c80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8213e9c5
> R10: fffff520014d3800 R11: ffffed10170c7fa9 R12: ffff888028890828
> R13: ffff88802e700d08 R14: 0000000000000000 R15: 1ffff11005ce01a1
> FS:  0000555592944500(0000) GS:ffff8881257ba000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32163fff CR3: 0000000077ab6000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
>  vmap_pages_range mm/vmalloc.c:701 [inline]
>  vmap+0x1ca/0x310 mm/vmalloc.c:3515
>  io_region_init_ptr+0x24d/0x350 io_uring/memmap.c:125
>  io_create_region+0x3a4/0x480 io_uring/memmap.c:228
>  io_allocate_scq_urings+0x2b0/0x870 io_uring/io_uring.c:3626
>  io_uring_create+0x591/0xba0 io_uring/io_uring.c:3867
>  io_uring_setup io_uring/io_uring.c:3963 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3997 [inline]
>  __se_sys_io_uring_setup+0x264/0x270 io_uring/io_uring.c:3988
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3093f8ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffcd7235a8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007f30941c5fa0 RCX: 00007f3093f8ebe9
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000007688
> RBP: 0000200000000040 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000007688 R15: 0000000000000000
>  </TASK>

This seems specific to the 0905 release, which had some sketchy mm
bits in it. Doesn't reproduce on my -next branch, mainline, or on
newer linux-next either. Hence most likely a specific mm issue
in that broken release.

#syz invalid

-- 
Jens Axboe



Return-Path: <io-uring+bounces-9556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4279BB42D6A
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 01:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C41631BC6898
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 23:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564162EA479;
	Wed,  3 Sep 2025 23:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CETVKolm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172832D4B4B
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 23:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942203; cv=none; b=A6xSLJ2Bay4rHDfgn1po2xA4/pPPWZpynfIwYn98Shu9iO91leTsON/h0lwroTDrbTbDORopsJQgjIHqiComcPEh5eTrIbn57HMMWGz+/38lB0TPxxryZY9p3WBy3/q1kBIccCaOeA4suAyqHNqQVIpMdEtFG5QiDsnShH541NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942203; c=relaxed/simple;
	bh=GNr7VFuJevqVS2hBqVOZK3r8mR73l9bbWq/xzZ2iqUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E37nxbGYFxZanjAXavpXAlNi9n3Fa7/VRab8Ml7NtvwgYPFwK5TdkYmwyPuHYfna3wxuip16Kj/iHO/S6AITJxexH96vGqEzoJZ6pXTlgVPFci0Ip3hpc1/sfz92Dm4YPD8RFaQ1Q6A5NujdgM61xFMFMz0hUd/FxFEJVXNgafw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CETVKolm; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3f0fcd81068so3011855ab.2
        for <io-uring@vger.kernel.org>; Wed, 03 Sep 2025 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756942200; x=1757547000; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YvqGMPyp0FchAqYhsEWYsUXhRgyEZLtEOdipJAz6MGY=;
        b=CETVKolmy87znVbk6iJqY3eDsDZ0h3twv4RoqNGsUyyIDxO4OEZVtYDKXp3uFz/jKD
         UApC/7NWBsZGrFhbr+KyBgLg3Lx3mDVRkCoPBlpFcRcQEKkEMGGAlEW6iDxcUVOhL3AK
         JA1KAeBFepn0XxR8VdNMS2/YURh4qM8cG574aPGE3cjyH6rJivGtNAnM99zlhKNL+D2B
         707BV5H0CJjbMxtjZ3BlraLvtDg4Ki/eL8Wk1e9y9EmfgI4IdtQRQJx5EJNv/dwGdFqT
         GAr8BB9cevE+tRI9t1Zx1yZW2Rky2N1JGYsxRsHEBNsGLjo7Eyc1DDSz3Y2mG9MJNWot
         bykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942200; x=1757547000;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YvqGMPyp0FchAqYhsEWYsUXhRgyEZLtEOdipJAz6MGY=;
        b=N4TxHKJVPxpORlse5GHi8eJo6QZKetn/cwHm8nFpTMBx2UUwTIWbaTxwy9GbY91pLW
         /amnH7tBNI4VZ8KIHEnbT05Z0lQO7Hb/1a5q8hPlSXKv2Sx1fpil5IEYwXFBaTHqfhcS
         RAne+V9ZmSngfQXzR+dUcourZO/1rIP9D6seoWs/oz3W692vTtzAPFC6+Ml6VWDJXcWJ
         lZ8I84QPfDgo4n0wEpU377fCb1hrJAcAhQwrwBtsebXTvq9liHxF+R7+u3SBx6bRRby8
         W6twJVBW3hxSXwoRC5cPyjXcHStxqmn0uuK5eg5ihoI4rDQZXL91LtREWqIa7r/ygpKl
         Rr2Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3GrfnLGDNnFMHOgXjqvCuvhTFk5dgzGBuqL+Frz4M6tMhj79eYRiaX4vchLNfimV3Z7AyN1quhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwztaiqcV8vY8s4U0umRkl6ptLVSslPMj7mg4iZ/yvUToTWdVLp
	+4vtwyN4fX4equKz003JZbC8ShBJr3QUrvOx2lPDJlbHdFkCRCdT5BYWYsvYBh7YOXU=
X-Gm-Gg: ASbGncuq8kZQd8n/iZolYaf4hKotH/ztr/LIdt++ehg6qkdpxFQokudLipSwQXDFGmz
	91ME4KmGBdYEOpE24YfAFc67zlfkTFMzZMAFx+Le3HKJYj24aBFu8adgYzXu+amQmncllRO8VTM
	K5iwWeFudogWcAEaeaHDk/jkfNp1kPlT8rIk3Szs5YRkIsfm2lMFotVKjg2BBayZ9KjsLFOfX6l
	GANSZ0+hZQoHcZCI7pqims0EmDmw7lDfHXSVlV0Z6sjySSBhnTch6msLIt3w6FkGEbzzQ2BFjDF
	WEhy4723uIdFCb9ITGnmUQv7e/66GX4pP9UhRc4O6oS7HwK8JRbB4YDg3YHdBdWAlVCu6cvdbPY
	omS9JA+39Bdr42kuouoPa9K7tXAD2
X-Google-Smtp-Source: AGHT+IHu4lmtN61kR+SUYR1vSljYZPLL/bhjVNR3pwIPbHq7Flpijoa8vuWAQObGbrdcYyjDn0HhKA==
X-Received: by 2002:a92:c24b:0:b0:3e5:53da:3d7 with SMTP id e9e14a558f8ab-3f400097e47mr319540815ab.6.1756942200159;
        Wed, 03 Sep 2025 16:30:00 -0700 (PDT)
Received: from [172.20.0.68] ([70.88.81.106])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f3e07ea071sm56727295ab.31.2025.09.03.16.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 16:29:59 -0700 (PDT)
Message-ID: <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
Date: Wed, 3 Sep 2025 17:29:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>,
 csander@purestorage.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/3/25 3:55 PM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
> * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
> * [PATCH 3/4] io_uring: factor out uring_lock helpers
> * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> 
> and found the following issue:
> WARNING in io_handle_tw_list
> 
> Full report is available here:
> https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> 
> ***
> 
> WARNING in io_handle_tw_list
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
> syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro
> 
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
> WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> Modules linked in:
> CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
>  io_sq_tw io_uring/sqpoll.c:244 [inline]
>  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
>  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>

Probably the sanest thing to do here is to clear
IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
allow it, it'll be impossible to uphold the locking criteria on both the
issue and register side.

-- 
Jens Axboe


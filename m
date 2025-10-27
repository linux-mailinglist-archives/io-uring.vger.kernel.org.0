Return-Path: <io-uring+bounces-10240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A4AC119B8
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA65B4E8B32
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6740F2DEA6E;
	Mon, 27 Oct 2025 22:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="10LKB9LC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8202D7812
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761602652; cv=none; b=U/NIqdYQ3GzMWPjdZxecMPeUEWg0m1a1BUD1Gk1/iv+uFS8Azw8RJ1bEWEZbJfJkyT3fHTtA5URGRvKk53ktBw+tE8y9BD5ruTr//z8b5sVB/KbBvwOC3O7Q9N2Fu7MOPaYQZ1nQre07000sR6MM60n9oL1G3PUqUKHGtuD+wAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761602652; c=relaxed/simple;
	bh=mDNBf9VaT4m5FDUFI/a6dWRitHA6UrUSUcgu24qbcLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cmodv4ZNUZgnYyj13VxMdW5h2bJ7LeuGbIOrSpMUtBQWixZfI5BnxSIDMpntQfyQZ+WOa9O7UOBSzHH8uzlZ02TRhIgXjAxseL60gV5aN3skG4jUzGQdBoGs8EByMPdYkkr5xP14m4DIZjy+FmNAIs0wJpGHKHZWU8ZeI/5OoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=10LKB9LC; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso556771539f.3
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761602648; x=1762207448; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1DGwtRYivJI/9/ePCg3GK9WG1nAdTuerTKUBAFg18NU=;
        b=10LKB9LCjIN7c3rosnYfByTEVePrQUIcefh4WzavGXEHZRSfHPgXQ6qPnJ+jkBV1TR
         0qYLCODk2zpYtqi/6f0HHn19qbw0VN99ZFLiFU4T5EmCZ6T5cleCtcV40GHV0qnzSBPH
         Ay5PjO06PrUc/zEX6Me4/gvkmoCnTQoJ9HEe4vx4vJPW5S8h6zEuNAFNdMSH6t7eLilg
         PxdIjQo6F6F9s+gOlpWULtApazDaAVeCQKxqENlDASLzNx3cO4qaS7DtBMNGY1hIq5Vk
         5BY4wdbY5Y/fmp3Tkxo+o2Me8+8wjNF3K+m5sOws7xpNZ4CCrPj7ZynRcnlIQCFM8sHJ
         suKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761602648; x=1762207448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DGwtRYivJI/9/ePCg3GK9WG1nAdTuerTKUBAFg18NU=;
        b=i5QQ3fUJM2STZt1kxUPyMIqYDhiwZuM6myvCjbfPeYxgf2bsiCoCqzqJ04Ij12KkEo
         JJtWOZnbeCrkINCaV3qLiQIHnjrvwRTdSlg4s5uRx/6kOxCI6n/+MvI7UDn2k2YKFWB5
         uFKcjNuCGx2prsNJTMsj3wlA0aor4PkqA9HDC9yPrW7y8/DJJ3IPAdvSiB1sFwBezSRc
         3nJHYy+1VsGMjCgkwIsjXa5vRFxeR4tJZoEb862rfZzUaGIhyvHLvvq5+ElkYw1uLO12
         4t96qIZSuWXy8wixuEf3ykgDYoB6u5X3eyS2XUBGuyXOeg2Nw3vkBWP4g0woUxR+OOjQ
         LCJg==
X-Forwarded-Encrypted: i=1; AJvYcCUiv0V2u8hLMvIuPWmDP1TXJmOWl2E74MInev7Wp2mraa+8oyQXSBWBNCko0FLNE78eiuhSq9j07Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBj8D4xDICUcXaiX3ujel9zOfSYZGdS+hkzI7157Oz1NsWDkuq
	dZhhaqd1o2GARtt/SanRJ0FKSqvPOpgd9mduhka9GwGzYqACZu1edmghgLqLwfw7NNvcayRYdIj
	r0yDJ5wU=
X-Gm-Gg: ASbGncuUSaYiiNVYtngEhbZHK8Bt8hEIBuDRpXuRsKqL0mvI81kuuf2y49VKbZhumgp
	54h8aoTHAsolFO/Cd1LvTHBJnic77AfapF5oXS5/U2MXkDSpvAuXCieT9OnvaMHC6y5tOTDziDl
	CiegboUqCQaExIcunFEScDuhVrIibmlQb6Sz2XlAtAJkSkxTnJYXkxPkIKZq0nIWoNH5QDMx69E
	C801HPJe0cD2COR1nHkRDZWtq39QkP0O49Uz7pzKHq3By+y/k7IZMqm4AOJifgfH5fs1lLk/uV9
	3cY38fYvbysdS9pP/7DRV3WyG+e9M4oBK3KL1+LBwk4UEhb1wa7bTdW9pl2Yq9gIwlBrFv46ihI
	5DXwz7VXMk4gl9/ES+iMOxs4k/cfe95/aWRIbn1Tw+Ofbbv/TxDJb2xxNOGfOeLVHFcKXcoaw3A
	==
X-Google-Smtp-Source: AGHT+IGEqsw+ql+25KlKysVMbdQvsh8plbbkD4ishSElZSeGl+KywOGvbUA62Fk7G5E/px3LHD70Sg==
X-Received: by 2002:a05:6e02:1fca:b0:430:ab29:e75b with SMTP id e9e14a558f8ab-4320f8382f4mr21545175ab.17.1761602647606;
        Mon, 27 Oct 2025 15:04:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f67dcae3sm36275455ab.3.2025.10.27.15.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 15:04:06 -0700 (PDT)
Message-ID: <d0cd8a65-b565-4275-b87d-51d10e88069f@kernel.dk>
Date: Mon, 27 Oct 2025 16:04:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (5)
To: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Keith Busch <kbusch@kernel.org>
References: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 3:07 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13087be2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
> dashboard link: https://syzkaller.appspot.com/bug?extid=10a9b495f54a17b607a6
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14725d2f980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11233b04580000

[snip]

> RAX: ffffffff82431501 RBX: 0000000000000018 RCX: ffffffff824315fd
> RDX: 0000000000000001 RSI: 0000000000000018 RDI: ffffc9000383f880
> RBP: 0000000000000000 R08: ffffc9000383f897 R09: 1ffff92000707f12
> R10: dffffc0000000000 R11: fffff52000707f13 R12: 0000000000000003
> R13: ffff888079527128 R14: fffff52000707f13 R15: 1ffff92000707f10
> FS:  00007f4e567906c0(0000) GS:ffff888125cdc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055db9a726918 CR3: 000000002ec48000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
>  seq_printf+0xad/0x270 fs/seq_file.c:403
>  __io_uring_show_fdinfo io_uring/fdinfo.c:142 [inline]
>  io_uring_show_fdinfo+0x734/0x17d0 io_uring/fdinfo.c:256
>  seq_show+0x5bc/0x730 fs/proc/fd.c:68
>  seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
>  seq_read+0x369/0x480 fs/seq_file.c:162
>  vfs_read+0x200/0xa30 fs/read_write.c:570
>  ksys_read+0x145/0x250 fs/read_write.c:715
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Keith, I'm pretty sure your change:

commit 1cba30bf9fdd6c982708f3587f609a30c370d889
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Oct 16 11:09:38 2025 -0700

    io_uring: add support for IORING_SETUP_SQE_MIXED

leaves fdinfo open up to being broken. Before, we had:

sq_entries = min(sq_tail - sq_head, ctx->sq_entries);

as a cap for the loop, now you just have:

while (sq_head < sq_tail) {

which seems like a bad idea. It's also missing an sq_head increment if
we hit this condition:

if (sq_idx > sq_mask)
	continue;

which is also something you can trigger, and which would also end up in
an infinite loop.

Totally untested, but how about something like the below:

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 7fb900f1d8f6..3f254ae0ad61 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -66,6 +66,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
+	unsigned int sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -88,17 +89,18 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
-	while (sq_head < sq_tail) {
+	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
+	for (i = 0; i < sq_entries; i++) {
+		unsigned int entry = i + sq_head;
 		struct io_uring_sqe *sqe;
 		unsigned int sq_idx;
 		bool sqe128 = false;
 		u8 opcode;
 
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
-			sq_idx = sq_head & sq_mask;
+			sq_idx = entry & sq_mask;
 		else
-			sq_idx = READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
-
+			sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
 
@@ -140,7 +142,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
-		sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {

-- 
Jens Axboe


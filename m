Return-Path: <io-uring+bounces-4920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C9F9D4E78
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F2C2813C3
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 586511CB9E9;
	Thu, 21 Nov 2024 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z8WWJGmR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB98433D9
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198580; cv=none; b=ZOoTj3HRvc2DyHJoi7lC3569Dd1y2Qq9H2VvCN9R1Buwjk31Ra+gyIYbrTlbNemPP/owAUMvN7vZz2w6sthrvlCV7TTzaXJS1aCasYFfgG+l3hwPeXp+hlsDZqRtkdRt8c9PBiwVY9OpoTDuhmUsTLXFfNbEV1jBq6J7Z2MIQ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198580; c=relaxed/simple;
	bh=aiSE4dsbDfmupJ74pzVvVvTOYDpsSKb45SvSN69Z9dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R6sx0Svg/VjHOqbGQC/dLg008vjYjZsPfhV0So7ANE5EUuqAJvsCtc5z8Kp+Lk+80yp5iKZKviTHbbxCpogHRyejAGFeo/EZfH1QLrsQoqp8PBLBsREA7mMoAVx46h3cnncuL3/0nqXFEwu5YgUZ8xBPqw4QLPhQG8NgEpJAbYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z8WWJGmR; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-27d0e994ae3so469747fac.3
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732198575; x=1732803375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JOlVBIHljF4u2JAmVbNNZ3eDQhQq/LHtaPhWtJKVk94=;
        b=z8WWJGmRvNEtKpkSLzFfWAOOn24yg7f58HVjCUlmZET0jEwG0eNElh7g2sVkeLZJdR
         S5RxaVMtniImvtzISV+UXdz1YeY8sp2cNWbiXfarf4Okbe/fziFMpFwuPtK/cRiC7Ubn
         KPSu5h8ShTZMPHFio6C2XUkCpGcdsH0cvUOAxlUcx+5uNaxK3+zOyJU4k4rDjPRtkrnK
         UpKKYcbuYVED/U303g9juT1q3fMqHXgj/YNVO4PX0Ts2Hzo+aQgaohmOegN83NnLbLVH
         IIOIrREn4uEEordsGTvshWWM7ZZYNzXLOLW9JkQm8/0abgBdsg5jkLwSigfghRMhsJ5N
         3EYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732198575; x=1732803375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JOlVBIHljF4u2JAmVbNNZ3eDQhQq/LHtaPhWtJKVk94=;
        b=qaXk27hxP0zV494wtDrd0YMuQz7m3sEEItYvZn00+tyzVaYvHHeqjkQ1AggddbI6gT
         Dj4CRKK0xUqy1FkHKtMe6wngNEDljhmIWhnlNcTtiLlAObpUphDQmtW0ZjU2O0MWSoEr
         ztaJbfQfJaCNHLY6MBw1/Tdo2Aq0jF6fpAxYf/oUu6lp0kVa0AzJYcQzrziuwAXyGWIF
         TN6RxnuuvrRrxqK+PMn6U7xOyGWGi8yU02xSJwQzWKXQJIL9N27djY+Gy+geLkJ1/8Rb
         7m+7esEPW/wkU4lMUH7v0e0Gx1QkjTyPKN5DpkCseECjkR01syz9qc1kaE/gc/QV2hZk
         xdYg==
X-Forwarded-Encrypted: i=1; AJvYcCVPhaViP3miGOm1fdgShI24bC7BLNQqqJwLPp40oNF8khi1sxjt8e77ZQIhkxX+AdlXHCVlpqjAPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfK2FCd1ipImz1bVEKed9oeKzZ1fGx1FPwsPKtUb2HrILuoMOn
	CqGYPUVPtzbQ6SDajQQ8Iqx/uvirEs6DYlpJiah792x9ELttE+8GYXFtoVFzQCg=
X-Gm-Gg: ASbGncsklfCu5PJ2GZjYPZdecjWYNVAp+MDvCUW8qa8VV+2gehaAqjoQ32msFkMHWLE
	rH6/TnfV7idks5i+ykZVjAfotFISx+i3UDY6n0pZMgqCGW2f5YiW9QjX4HvGbArmb7mP4Ih1eqA
	AwHsMG31QNBeS6FaiU5miqf0nEqLLMlrgv2CkTzySZKPsxRwfH4UzzbdwxN0OcUShjvTmnO03G5
	c1Vqtto4sEsVOdc0rLL1xPTJPkb+OH8mPV+Wr5zlbff9Q==
X-Google-Smtp-Source: AGHT+IEDj5Gg5HiQM0ovHlm8I1W3F4tiOvYRBuvSVdQb7fmGQDlsMjTmpPRmehDFi9GfX/SIes3gsQ==
X-Received: by 2002:a05:6870:a414:b0:277:f722:45e1 with SMTP id 586e51a60fabf-296d9b65ff6mr6141019fac.17.1732198575567;
        Thu, 21 Nov 2024 06:16:15 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296519331c1sm4836488fac.23.2024.11.21.06.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:16:15 -0800 (PST)
Message-ID: <d813e99f-d532-4521-a018-70e11617e1c0@kernel.dk>
Date: Thu, 21 Nov 2024 07:16:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_nop
To: syzbot <syzbot+9a8500a45c2cabdf9577@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <673f3ed9.050a0220.3c9d61.0173.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <673f3ed9.050a0220.3c9d61.0173.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 7:08 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=134feb78580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f17942989df952c
> dashboard link: https://syzkaller.appspot.com/bug?extid=9a8500a45c2cabdf9577
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f767f7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f50ec0580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e1e82262b7ac/disk-43fb83c1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7ca6e1c46dc5/vmlinux-43fb83c1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/63aaea837532/bzImage-43fb83c1.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9a8500a45c2cabdf9577@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in io_nop+0x549/0x8a0 io_uring/nop.c:55
>  io_nop+0x549/0x8a0 io_uring/nop.c:55
>  io_issue_sqe+0x420/0x2130 io_uring/io_uring.c:1712
>  io_queue_sqe io_uring/io_uring.c:1922 [inline]
>  io_submit_sqe io_uring/io_uring.c:2177 [inline]
>  io_submit_sqes+0x11bc/0x2f80 io_uring/io_uring.c:2294
>  __do_sys_io_uring_enter io_uring/io_uring.c:3365 [inline]
>  __se_sys_io_uring_enter+0x423/0x4aa0 io_uring/io_uring.c:3300
>  __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3300
>  x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Uninit was created at:
>  __alloc_pages_noprof+0x9a7/0xe00 mm/page_alloc.c:4774
>  alloc_pages_mpol_noprof+0x299/0x990 mm/mempolicy.c:2265
>  alloc_pages_noprof+0x1bf/0x1e0 mm/mempolicy.c:2345
>  alloc_slab_page mm/slub.c:2412 [inline]
>  allocate_slab+0x320/0x12e0 mm/slub.c:2578
>  new_slab mm/slub.c:2631 [inline]
>  ___slab_alloc+0x12ef/0x35e0 mm/slub.c:3818
>  __kmem_cache_alloc_bulk mm/slub.c:4895 [inline]
>  kmem_cache_alloc_bulk_noprof+0x486/0x1330 mm/slub.c:4967
>  __io_alloc_req_refill+0x84/0x5b0 io_uring/io_uring.c:958
>  io_alloc_req io_uring/io_uring.h:411 [inline]
>  io_submit_sqes+0x9a2/0x2f80 io_uring/io_uring.c:2283
>  __do_sys_io_uring_enter io_uring/io_uring.c:3365 [inline]
>  __se_sys_io_uring_enter+0x423/0x4aa0 io_uring/io_uring.c:3300
>  __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3300
>  x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Yep that's a bug introduced in this merge window, the below should
fix it:

commit ee116574de8415b0673c466e6cd28ba5f70c41a2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Nov 21 07:12:17 2024 -0700

    io_uring/nop: ensure nop->fd is always initialized
    
    A previous commit added file support for nop, but it only initializes
    nop->fd if IORING_NOP_FIXED_FILE is set. That check should be
    IORING_NOP_FILE. Fix up the condition in nop preparation, and initialize
    it to a sane value even if we're not going to be directly using it.
    
    While in there, do the same thing for the nop->buffer field.
    
    Reported-by: syzbot+9a8500a45c2cabdf9577@syzkaller.appspotmail.com
    Fixes: a85f31052bce ("io_uring/nop: add support for testing registered files and buffers")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/nop.c b/io_uring/nop.c
index 6d470d4251ee..5e5196df650a 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -35,10 +35,14 @@ int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		nop->result = READ_ONCE(sqe->len);
 	else
 		nop->result = 0;
-	if (nop->flags & IORING_NOP_FIXED_FILE)
+	if (nop->flags & IORING_NOP_FILE)
 		nop->fd = READ_ONCE(sqe->fd);
+	else
+		nop->fd = -1;
 	if (nop->flags & IORING_NOP_FIXED_BUFFER)
 		nop->buffer = READ_ONCE(sqe->buf_index);
+	else
+		nop->buffer = -1;
 	return 0;
 }
 
-- 
Jens Axboe



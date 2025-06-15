Return-Path: <io-uring+bounces-8345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76530ADA207
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 16:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A50C57A071A
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 14:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE3926B08F;
	Sun, 15 Jun 2025 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UK+pMT03"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC320C029
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749996494; cv=none; b=NuEDPnYMeRlg0o46dv2Xj+nAmT7nHggLFvF+Nw3PXNuy06mb4GOMrngIb0NGSWGsXIU7R+RWbZ55vGlqzDnhRq/0rYTpaUiQBCJn4Y+0n0ZrXmGPSyP2R7M5z2lKMip0tIxbqiEj19JqxqppXhq1ZtlLGRRIjWu3ppqxixyZy7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749996494; c=relaxed/simple;
	bh=CcL2R9L1qSAoAE6fzuBvMZlTzcPa+YWzy/4ZbcilH78=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l5mCNn6D4tQy1nu5Lo7gnVkap5X9wt+TWKToD1yAiZuKYXkTRDqyuhtgRXH592QVTjnQp74mpTpfJuZRa1lsOU3ek9an2lLIrVTv5C/D5l0DchPu8obzVoiiUjB2degojcfRniWa3CLQxdwetoc7lycBwZc2Z4isubHLtx6xKfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UK+pMT03; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-86cf3a3d4ccso342421339f.3
        for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 07:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749996488; x=1750601288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ev2ncarzcapzq2egHLqNpb8FWb96CW9+NpRTLqU6sro=;
        b=UK+pMT03aN/yT4oo2cwII4ivoIEx6dJpqE96eNDKlCxXn4bbvgs+k00YhXQ4nwNbS6
         bytk8rbqH8S9D2t+s8ELpN4COTaD0f+KdUR3r8hvHzfF7m5sY84FLfP0S+o3HT31+NkJ
         P0IzZMWP3YcAcrPGpwG/Shtxu01wNZ8uQGVxDGwALPbQsQLmWvwIXYw7EAN40gANgB92
         WTAq+KAHmTYp4b3Fn0/aZuCXtz+eoMRDFABQXdNrdjC7iDo27QFmry6dH4gCF3qVfyU3
         iqzXZ90uF1or6wf1BKKVHChE5QS6gKImJaGUcsJFDn0Wt3lA65sl8z4KMbvIi2o31O5P
         dpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749996488; x=1750601288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ev2ncarzcapzq2egHLqNpb8FWb96CW9+NpRTLqU6sro=;
        b=p8jWBUOjI8C+Mi+WT5545DxxUAdvNKYI6zICcsHPDV1RBpcWIMvcO6a1g8Uneee3Ec
         vavrtFQ5ZogrQ51sTX4A2lobhaLX9KZJqU6BqdbcRqzL8cjSBVImEUH6/QNJzzO/QsiZ
         Df9sTPbT4rtgnospdbJDRi59R4Yp0Ejd3anYjILCcBU1yJHW/MMDwecOrWP6PsRnhBxy
         ghDvykCy4v14OnbjCsMBW4/BCzSouSewPOlgVejw1dN9JcAGuAkFcC0scg0Paz2hJ4Ne
         vijXDPkZ+EmTgiLe5kDbCFLtPY6PmvT55WHz/uW3a+ghpwc7E4wA2H2mmjb8Q/yuS3gv
         jaUA==
X-Forwarded-Encrypted: i=1; AJvYcCUilqyE2rojh2LvSLVAsPcrajmktaL1djUAecNGHQ8RF7bECS1NqAqO0DkDEkb46jUDn9K0PNRDLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqOmEdAfrh++CUVwADO1aDwCEgJbUdS+KkY3uuHQaoREk8UeXO
	N55U54MQmpBDGzjfiq7Cg1Ih/hPTE9jEVelsTDS3t2desF9M2qi7H+pYeagP7iHoeco=
X-Gm-Gg: ASbGncvnIN/VW8k1xPejMpIsq5C7kZTuETxnczFoowWYMALfn7me9oHG/IvqCZGRCW6
	AKXu/xkw0tX49UlCvxaL71ELZwsbQw0HhGdSTZz/TGcQ4rIydszAp5ggw3YuqvOl9TqbIW9iWtt
	6ZQwbjITI/Y3v+QjfMBcUZN9yHjEPPyurcRxdxJ32H8NYWAS8vMULQQrRWrjvDssYpLUgK4P1ol
	tILZNUChnRUjczUVKuudoIfQ3nBi2D2at4g1+xAmk01V1nYm5eT2cjvfa+GTUIT73ywwD5ZSpWq
	J6Ff2AMkRJkpe7mynVcLtfiPRbEnyJWdcyHocBjpDXtkiOA8gKtiNdJWxi4=
X-Google-Smtp-Source: AGHT+IErB8q9zdosjAiGP3Jl++mmQSh6Dlt7tVdsOt8nIx8SP2s3DHMmWgKfGAaatM16VWyTNNFHDw==
X-Received: by 2002:a05:6602:1513:b0:86d:5f:aef4 with SMTP id ca18e2360f4ac-875dec75b32mr657114939f.0.1749996488205;
        Sun, 15 Jun 2025 07:08:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c68bc2sm1268818173.80.2025.06.15.07.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jun 2025 07:08:07 -0700 (PDT)
Message-ID: <7103fcd2-904d-42ac-b5f4-e821697b72f0@kernel.dk>
Date: Sun, 15 Jun 2025 08:08:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_register_clone_buffers
To: syzbot <syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <684e77bd.a00a0220.279073.0029.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <684e77bd.a00a0220.279073.0029.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/25 1:35 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d7fa1af5b33e Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=13db6682580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=89c13de706fbf07a
> dashboard link: https://syzkaller.appspot.com/bug?extid=cb4bf3cb653be0d25de8
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15cab60c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c9a60c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/da97ad659b2c/disk-d7fa1af5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/659e123552a8/vmlinux-d7fa1af5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6ec5dbf4643e/Image-d7fa1af5.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6488 at mm/slub.c:5024 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
> Modules linked in:
> CPU: 0 UID: 0 PID: 6488 Comm: syz-executor312 Not tainted 6.15.0-rc7-syzkaller-gd7fa1af5b33e #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
> lr : __do_kmalloc_node mm/slub.c:-1 [inline]
> lr : __kvmalloc_node_noprof+0x3b4/0x640 mm/slub.c:5012
> sp : ffff80009cfd7a90
> x29: ffff80009cfd7ac0 x28: ffff0000dd52a120 x27: 0000000000412dc0
> x26: 0000000000000178 x25: ffff7000139faf70 x24: 0000000000000000
> x23: ffff800082f4cea8 x22: 00000000ffffffff x21: 000000010cd004a8
> x20: ffff0000d75816c0 x19: ffff0000dd52a000 x18: 00000000ffffffff
> x17: ffff800092f39000 x16: ffff80008adbe9e4 x15: 0000000000000005
> x14: 1ffff000139faf1c x13: 0000000000000000 x12: 0000000000000000
> x11: ffff7000139faf21 x10: 0000000000000003 x9 : ffff80008f27b938
> x8 : 0000000000000002 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : 00000000ffffffff x4 : 0000000000400dc0 x3 : 0000000200000000
> x2 : 000000010cd004a8 x1 : ffff80008b3ebc40 x0 : 0000000000000001
> Call trace:
>  __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024 (P)
>  kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
>  io_rsrc_data_alloc io_uring/rsrc.c:206 [inline]
>  io_clone_buffers io_uring/rsrc.c:1178 [inline]
>  io_register_clone_buffers+0x484/0xa14 io_uring/rsrc.c:1287
>  __io_uring_register io_uring/register.c:815 [inline]
>  __do_sys_io_uring_register io_uring/register.c:926 [inline]
>  __se_sys_io_uring_register io_uring/register.c:903 [inline]
>  __arm64_sys_io_uring_register+0x42c/0xea8 io_uring/register.c:903
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
>  el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
> irq event stamp: 370
> hardirqs last  enabled at (369): [<ffff8000801fc600>] local_daif_restore+0x1c/0x3c arch/arm64/include/asm/daifflags.h:75
> hardirqs last disabled at (370): [<ffff80008adb9eb8>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:511
> softirqs last  enabled at (294): [<ffff8000803cf71c>] softirq_handle_end kernel/softirq.c:425 [inline]
> softirqs last  enabled at (294): [<ffff8000803cf71c>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
> softirqs last disabled at (289): [<ffff800080020efc>] __do_softirq+0x14/0x20 kernel/softirq.c:613
> ---[ end trace 0000000000000000 ]---

Max buffer count is validated, but buffer count + offset is not.
That can lead to attempting to do a big alloc, below should
fix it.


diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..94a9db030e0e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1177,6 +1177,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		return -EINVAL;
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
+	if (nbufs > IORING_MAX_REG_BUFFERS)
+		return -EINVAL;
 
 	ret = io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.nr));
 	if (ret)

-- 
Jens Axboe


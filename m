Return-Path: <io-uring+bounces-5465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2020B9EE97D
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 15:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB087280D93
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 14:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BC1215799;
	Thu, 12 Dec 2024 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0nKVdXfk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2E7215795
	for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015525; cv=none; b=RCfWkN8F0KmiBEjJ1i/mQ5+PsM4Ctawy4W9ziJfoA+6s4Eral6T5ghV3BDh551WKWL3APvenfvWlf+ICeLdIeQXfJu9mREIW6CsZ1UQQ4XaPNlCxQv1je0VXzyzc+Eziy/2U9avDlfRZZG3k4kA4Msm2qO3WFsRO5sf9ud6qiNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015525; c=relaxed/simple;
	bh=RmRwnSfZ0C0DvaLc6kARMN1jv0mfkUkVvBkxX/2hnKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NJYOL9FtkKladxEIcalapE7/bIw6j+g0yMXcE5WmrHieul0HMK+gd8fpcAij9cVcbnbHO7UvJIdbnW0KHUJ6JLypH2aFoLbdQY+vwHB6DEtTqXQl9qRG7S8alYz+Og0odpPPWJmQ05YLo1DUK7F7Lz1V5Ynuio4lHsz8a2LFIK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0nKVdXfk; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a7deec316aso2463755ab.1
        for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 06:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734015520; x=1734620320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MCYfYmi0Pi9ypwtCfSsOVf3lEGIJzSgJ83yyjJ7u75w=;
        b=0nKVdXfkxvy6omvgXEAN31qk2Xl5AWrOi0QffQAiXHTxPVwuI/U98pcRd/USFltDP4
         2+Kl0eWFM7qG83w0uVkxmYrqxQd10CL2BfW/bqDT+ux08Jz5uq0IBIQXzPcPFyGd4mig
         PTlxyVtxiGbRvXWsFn+hxkWGEULfYdImAJ2HL/KUJAKqgKXQMi0+PFVylIaa3MKGq0fl
         fYiNiTNvNa11bC5leNJKNLmX/wO5DHg48yCAW/y6yxFDX5zF7IRq/CFkV6sB80M0Lwly
         IKDfUZysrn3+TF6cA3BM9Z8WPsSvEikuZ9gwC6KecGQk7hpEbhZzoxD0IgJGEoXn36RT
         rXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734015520; x=1734620320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCYfYmi0Pi9ypwtCfSsOVf3lEGIJzSgJ83yyjJ7u75w=;
        b=LtrYoQl+ky/ccNUyqG7ndYaGAhMEZ44Gp7Bez7nNxqTiSJ9gg+8K95iQMQDGSVH35k
         lRCY5O3qDzXZUEIfRypDp86kTWFYO1C4XGCeiAZfZRwYg9n4CMBaYgQcguhdj/2mgc1m
         eOYbkI/I17ht4zerEnP/eapNIxXgO1pwA+tF+/L8D8FQGYZx/tU/FSSXsizqM9ind/l1
         O+vAPrFpPbYDPm4Q752wEs3jpZtHQOOLbCvaxIyECpKBGxN1AcoR9JKSkS/nTkggUWo4
         YysVxrtXmI18Uf4YZhtGdZCcEpBHtgeDiGLGdWVv6Aal3494Rk7CPdkE2C6y9Ip71c+N
         ZPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUorrMWOKBe5/2der9WSQ2u2Be7sT3WmtWdkUtT8hlj2R8qyF1N5lv4acWfcpTTLG67EFFCNeGPOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzD7O45q8hZjmt/K6PJMyLA0KtvyJlteV/y0CORUyQtTwWN9Jud
	c0BB7SZgcLKz8vT0knWcjrd74sOTgaAUqY9ezM298QGJSl9u1/jmdjstKn4eo60=
X-Gm-Gg: ASbGncumxHEOwlaUYEuQSGt3jTm/F54evcoNNF+ANbKzpVrgh486PWg9mJ3nQJKoYNi
	gyv7EMJPzISk5getxsIhOxynLseHEJHpQFPNnUhECaXvrW7dbw5L0gmrR+0lmr/rJPd6cYNZz8o
	suF+fmW5mpdgsiDtlQVVZdOXBLeXaqNhuufdQNqQ7CBOatQQoyf+7jpKLI29RViNozvBUToAumI
	O2rTIU6Wlp7+3N/nZoQfs7+bT2L5wCWqp4nlTJDgeylAe5GK4QV
X-Google-Smtp-Source: AGHT+IF2yAGFDjep0GkWHzECEavemvwNFhF79MevZWXxqO4LxsqzRRuOUBCw2yWJAvUuF7nxI1YUgg==
X-Received: by 2002:a05:6e02:1707:b0:3a7:fe8c:b015 with SMTP id e9e14a558f8ab-3ae5953b1fdmr5545975ab.24.1734015520615;
        Thu, 12 Dec 2024 06:58:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9cb197126sm28877205ab.44.2024.12.12.06.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:58:39 -0800 (PST)
Message-ID: <85c4b3a6-559a-4f1d-bf2d-ec2db876dec7@kernel.dk>
Date: Thu, 12 Dec 2024 07:58:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] general protection fault in io_register_clone_buffers
To: chase xd <sl1589472800@gmail.com>, Pavel Begunkov
 <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDRcO6QORhUUHGRBQvZ_q8nip0S+Mn4Hb61W8zi_OfmSag@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDRcO6QORhUUHGRBQvZ_q8nip0S+Mn4Hb61W8zi_OfmSag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/24 3:06 AM, chase xd wrote:
> Syzkaller hit 'general protection fault in io_register_clone_buffers' bug.
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 5 UID: 0 PID: 12910 Comm: syz-executor169 Not tainted
> 6.12.0-rc4-00089-g7eb75ce75271-dirty #7
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:io_clone_buffers io_uring/rsrc.c:1039 [inline]
> RIP: 0010:io_register_clone_buffers+0xbb1/0xf40 io_uring/rsrc.c:1076
> Code: 48 63 c3 41 89 dd 4c 8d 3c c6 4c 89 fa 48 c1 ea 03 42 80 3c 22
> 00 0f 85 61 02 00 00 49 8b 17 48 8d 7a 10 48 89 f9 48 c1 e9 03 <42> 80
> 3c 21 00 0f 85 62 02 00 00 48 8b 72 10 4c 89 f7 e8 b8 93 ff
> RSP: 0018:ffffc90011047bd8 EFLAGS: 00010212
> RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000002
> RDX: 0000000000000000 RSI: ffff888017acfec0 RDI: 0000000000000010
> RBP: ffffc90011047d28 R08: 0000000000000000 R09: fffffbfff1dbb731
> R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
> R13: 0000000000000001 R14: ffff888021760000 R15: ffff888017acfec8
> FS:  00007fcbf80f4640(0000) GS:ffff88823bf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fcbf806e658 CR3: 000000002420a000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __io_uring_register+0x922/0x2290 io_uring/register.c:804
>  __do_sys_io_uring_register io_uring/register.c:907 [inline]
>  __se_sys_io_uring_register io_uring/register.c:884 [inline]
>  __x64_sys_io_uring_register+0x178/0x2b0 io_uring/register.c:884
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcbf815322d
> Code: c3 e8 77 24 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcbf80f41a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007fcbf81f5088 RCX: 00007fcbf815322d
> RDX: 0000000020000600 RSI: 000000000000001e RDI: 0000000000000004
> RBP: 00007fcbf81f5080 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000c90
> R13: 0000000000000003 R14: 00007fcbf811a630 R15: 00007fcbf80d4000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:io_clone_buffers io_uring/rsrc.c:1039 [inline]
> RIP: 0010:io_register_clone_buffers+0xbb1/0xf40 io_uring/rsrc.c:1076

I can't run these crazy syzbot reproducers, I do wish they'd be dwindled
down to the bare minimum rather than have tons of unrelated bits in
there. That said, can you check with this patch?

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index adaae8630932..077f84684c18 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1036,8 +1036,10 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 out_put_free:
 	i = data.nr;
 	while (i--) {
-		io_buffer_unmap(src_ctx, data.nodes[i]);
-		kfree(data.nodes[i]);
+		if (data.nodes[i]) {
+			io_buffer_unmap(src_ctx, data.nodes[i]);
+			kfree(data.nodes[i]);
+		}
 	}
 out_unlock:
 	io_rsrc_data_free(ctx, &data);

-- 
Jens Axboe


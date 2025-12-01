Return-Path: <io-uring+bounces-10875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB3AC99299
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 472284E24E0
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF81242D72;
	Mon,  1 Dec 2025 21:24:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF652184524
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624250; cv=none; b=XE+ujJS8FULCRLVO65OpsX/CrLXz7ajJrW9W99oYt2mNNVJO1P0yoK5/eVBwwzBOY1g2tnKCxBz2YyJrmKYJODMFwuQhyx2xbssanUDxSQ/NmNVJnscObpI4tClhvJ/pgU/VlLDjJgRnRkPt44BKjuVj4vUsVV/+JIMvyHQHJoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624250; c=relaxed/simple;
	bh=5896dyjBmsoORlZ8+zaUXOW+qgZgMQZDUrbrl/U2ew8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nvhK1gT0J+jbW932us0cE7bHbI05gDqA2Wq1j25VXHfrgmwMX7vA95cqqYKVjBRVZShn0dY8IepjSH3NBafqcrJrK0h+IFyU1k2qGRJBOgsPQ9WsosqATtq/yCXmzdeMAgOjGQxnZlYJygFY8+B9ir0SDoM2brqlGtcgjRpwTrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-656ceb0c967so1393810eaf.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624247; x=1765229047;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgdxd3aQAsAPYJmDsdrOq5rlcDaAKcTvmOdb4NW7nJQ=;
        b=Db2n2YbENqaR4RDszJbBwn7qMZuwqdRm/erj9bgf6lwd6F7psogbLk8NfCUsDtxU/o
         /YaXazFdLmDH+tcT7EtoDot0WIt5jdd9IUh+1Za5S8D7jP2S+g0IgKMsv3mTL4Hj1g91
         Xp0X9OWkuTWIU0a2D5QqUbl78bEBRdV4pFyt3cnqb4JMGw5AkTb06gk+Ex2w3eI1bNNN
         nyqRcSvL2bRXnp7C+MlOGL1jItjDDXQeaI0HVX5gp5N8RNk99VObdUuGJradxntoH0ad
         1UntA4LgH1WQetzUUIU/esX3+zx/+Dsxs9g0NZb5iuBqIV6fHB9JctW4DNFC5BXkzwi2
         L1Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVm3wtX/tiY5vTYFOH8KjEsY7afm8kEuCylG5UD/zC+eS7kXm+0nf8q9iRQohIxzOaQlqQ3cEiJdA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx42Y8aHYx0YRyCzhBQYNmMYLbjUFSe5Nbys7WtDCPCH/xPjOql
	Hmub+jXSaSDdQr5pN2UNnlfsfun1MBxUtBcu/daOOQurqnlmCiLeSBzVKrEPVHzL5cHCkJb/f3u
	zO5UEFiUvHj7IunIxb75JQea+eyRJqaLIuV8JSzUv+AHS5tDsUtvYRkiGi30=
X-Google-Smtp-Source: AGHT+IGqdIf91MxoWxs0ZEh3cXn9YsGG/YvEf0PmEUiwNLIM0144qO7HLhYv6k/iRyLMITSwxdSMipt83rQwlvDI3MGsnvZn52fK
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a54:4617:0:b0:453:ee6:12b3 with SMTP id
 5614622812f47-4530ee620ccmr6351246b6e.58.1764624247072; Mon, 01 Dec 2025
 13:24:07 -0800 (PST)
Date: Mon, 01 Dec 2025 13:24:07 -0800
In-Reply-To: <d08c0c69-eafa-4768-906a-50a7e039e76d@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692e0777.a70a0220.2ea503.00bc.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
From: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssranevjti@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in io_submit_sqes

2025/12/01 21:23:33 executed programs: 5
BUG: memory leak
unreferenced object 0xffff888111254200 (size 248):
  comm "syz.0.17", pid 6735, jiffies 4294946584
  hex dump (first 32 bytes):
    c0 e9 e3 09 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 2fa747c9):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888111262200 (size 248):
  comm "syz.0.18", pid 6740, jiffies 4294946586
  hex dump (first 32 bytes):
    c0 e9 e3 09 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 95820259):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888125155300 (size 248):
  comm "syz.0.19", pid 6744, jiffies 4294946588
  hex dump (first 32 bytes):
    c0 e9 e3 09 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 7f690aa4):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888122d56200 (size 248):
  comm "syz.0.20", pid 6764, jiffies 4294947184
  hex dump (first 32 bytes):
    c0 e9 e3 09 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 1e329da4):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888126b78d00 (size 248):
  comm "syz.0.21", pid 6766, jiffies 4294947184
  hex dump (first 32 bytes):
    c0 e9 e3 09 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc d8b7eea):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         7d0a66e4 Linux 6.18
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131aa512580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f30cc590c4f6da44
dashboard link: https://syzkaller.appspot.com/bug?extid=641eec6b7af1f62f2b99
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14448512580000



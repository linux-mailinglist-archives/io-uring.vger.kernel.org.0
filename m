Return-Path: <io-uring+bounces-5045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E309D8F33
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B9F828A4F8
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 23:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510D018130D;
	Mon, 25 Nov 2024 23:34:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAE81E480
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732577644; cv=none; b=qHAV/hfSe9CFwuV+huXYpXdyoedo6hlxQ/tFMfJ2gXR0g7m3hncpnpGxwqe1snoSqkOechA+q3R8baySYkWHjLXgU02HbYWIEmx15gNyJkR+2Mp6pILgWtwO/r6AVVpc9zu8WkBLhEmgw2gqZ4mQoeKgols2LZRNF6I3KIY79/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732577644; c=relaxed/simple;
	bh=rgkpqdqQkvHavA8r6D6Nk7TJzX420Xwq9vCjntuQn+Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kikD1xIx4zUDKiHiJ/apehCYo+tDoMlF3lmJz7bM6dlNF9vkEZ3i6CqgJJxFH/VCIr2bK2wIG83s/Ez1WsSHLrjcgbbJ+p2OEkzwVf9Cpu2NkcXrW0jtNhHlKeMQr1S2uL9puXph780wJF+2udObsrRVQVxSi5My+Zhxvc4/HTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a71bdd158aso55045205ab.1
        for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 15:34:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732577642; x=1733182442;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqNaDCIYNAGDm8DdpOLHaZPXRGpBbn3nGU7MsIFIGCw=;
        b=XcWvyfiYQ10c2ie1ykkb/5Q+5GtKYlGjMQub1wwkXH0qJKvMGZFY1mk4jw0GujKXCu
         powOD6qK6uc9+SQGpSTUf2J7Q+VnsYR8YyUYpB8vL/lylEQPaVg0ZDFnZpnqWnpSjzfT
         bI5osJI6N/gDfd9EI1317zJOsqLSyH88boP0rCzuBCc56HdT/wMPhyirGH1vidrHHfv9
         ZDqlH4OgfDeKrwMht5foRzI28BahUQi15b+e2dZ9Bl4D++K9/DA1zhkqlTP9lYQ4nzUT
         LmzlW/k5NTEkCZz1ka2PiVdSWchMMOnGdzqhaIYVCCmRYEuIYN9LQBU70bXcRBgNBiAN
         d1QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsK0lUStf++62Fu24IMgMc6hOxYKqZBIDzp1H/UPfpmdbvwZOpnQQ3GirVDF2kIyEGgP559NOGRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNHt8T2pbsAgjskrrP9aTdnmY4YviY50SHkqkhqeei3rn07bHv
	IyqXmihSXIMqwMgktBOYbpgJQo16hJz6Y1/ugKgqhz8XZaHg7uWKqwpIoOfMy+OsRAN8QxTkLSN
	RzxTNzxJeqSYx4q2++/S5B2MqaN8yo3ZvTpz2Zjp+P6HqzfRkTNy++rE=
X-Google-Smtp-Source: AGHT+IFnTudC4Rlie0Zbp02yyIsZP/XWgPyiYGNe+qn3ta2BXhs/9DdBVFVSa9p9PcL+rJpg/KwVtPwTWseiMavDz7uY1dae6hHp
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cc:b0:3a7:7fc0:ee16 with SMTP id
 e9e14a558f8ab-3a79ad787b5mr173421145ab.8.1732577641866; Mon, 25 Nov 2024
 15:34:01 -0800 (PST)
Date: Mon, 25 Nov 2024 15:34:01 -0800
In-Reply-To: <4db729f9-eece-4732-8d6d-405a997ed35c@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67450969.050a0220.1286eb.0006.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in io_pin_pages
From: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in io_pin_pages

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6625 at io_uring/memmap.c:146 io_pin_pages+0x149/0x180 io_uring/memmap.c:146
Modules linked in:
CPU: 0 UID: 0 PID: 6625 Comm: syz.0.15 Not tainted 6.12.0-rc4-syzkaller-00087-g9788f6363f9a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:io_pin_pages+0x149/0x180 io_uring/memmap.c:146
Code: 63 fd 4c 89 f8 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 0a f9 e8 fc 90 0f 0b 90 49 c7 c7 ea ff ff ff eb de e8 f8 f8 e8 fc 90 <0f> 0b 90 49 c7 c7 b5 ff ff ff eb cc 44 89 f1 80 e1 07 80 c1 03 38
RSP: 0018:ffffc90002ee7c10 EFLAGS: 00010293
RAX: ffffffff84abe228 RBX: fff0000000000091 RCX: ffff88806d4c9e00
RDX: 0000000000000000 RSI: fff0000000000091 RDI: 000000007fffffff
RBP: 000ffffffffffff0 R08: ffffffff84abe12e R09: 1ffff1100f98b260
R10: dffffc0000000000 R11: ffffed100f98b261 R12: ffffffffffff0000
R13: ffffffffffff0000 R14: ffffc90002ee7c80 R15: 1ffff110024de520
FS:  00007f3e6a15a6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b3255ffff CR3: 00000000339f8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:185
 io_rings_map io_uring/io_uring.c:2632 [inline]
 io_allocate_scq_urings+0x212/0x710 io_uring/io_uring.c:3491
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3713
 io_uring_setup io_uring/io_uring.c:3802 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3829 [inline]
 __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3823
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e6937e759
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3e6a159fc8 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f3e69535f80 RCX: 00007f3e6937e759
RDX: 0000000000000000 RSI: 0000000020000400 RDI: 0000000000002c0c
RBP: 0000000020000400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000002c0c R15: 0000000000000000
 </TASK>


Tested on:

commit:         9788f636 io_uring: sanitise nr_pages for SQ/CQ
git tree:       https://github.com/isilence/linux.git syz/sanitise-cqsq
console output: https://syzkaller.appspot.com/x/log.txt?x=1040e778580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f0635751ca15fb7a
dashboard link: https://syzkaller.appspot.com/bug?extid=2159cbb522b02847c053
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.


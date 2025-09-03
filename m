Return-Path: <io-uring+bounces-9554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F01B42C43
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 23:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D4EC1C21795
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 21:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D532EE273;
	Wed,  3 Sep 2025 21:55:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF02EDD7B
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756936546; cv=none; b=DIkeMQMj+Ljd/1G+3Jl5/DGMuJL+TiM8RVLxVt5UKGnCiOJRqiEVR/wRE0lnW4JRE8/tnzpXO6jEsvVJanhspzrojws67JoRgeF/75Nv/qSdkfUD4iyiQql7WSG4SFK9At3NkXqDGG/6KpnQJZRtGLUp6UTXta6jSgCBGMOo2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756936546; c=relaxed/simple;
	bh=2ndQEDCzUXx9yYy/WcdNCG32Pe+5P+tfbouij3eudSw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nxBiRM/jACz9c9chJ0LFxGJonxyIrJKz51p8Q5tKmQrjS2Ot+MFFQ2dNfq2kDkMCQ06aa/UmS+/HXuVdE3G1dmgrSVPOfrf3bl2s0qSnB71XHqZ9RsU1YVbLP44WHu1sqs4/vMjCSzG6N4yaIoXdWo+Kxj31i/F0nQ5cijhhdZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3f31ac5bd9cso3811845ab.3
        for <io-uring@vger.kernel.org>; Wed, 03 Sep 2025 14:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756936543; x=1757541343;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s6wN9KeqqiOqxe44BHCxn1omR+bJwqOjbtDhTcJ5oPM=;
        b=LlbKNQuXttauhVDRDMh50roElmQ1emLr9wg4jH4im+lwCAz3nNU4t7mzTYzfXL7rbY
         pTiNo9MbEX+a+HUsK+RxxMq/UziyMwozcc4TBSa9++Hw/NATzxHa3E0p8NCdGL5Ectqi
         W/IP2UeRRNBQdydACC8A9kVavuTTZcn+c6A+73Sh9kt2IsO3xPadjL47uUSn03l2Xk41
         ULrnkL/DDJz9t2lB80YvdTHpSf/Vn9UMNxx1W/NnOZQGQWncUmRpYOaLTqL9FGyuis0d
         sx/dwjLSBDOWCm5UB3vBw++jX+xteXZRUVAqG68mB8b8E5y/wyk94oJc2SqLJN+esaw6
         ZWPg==
X-Forwarded-Encrypted: i=1; AJvYcCUpc2mzdiaUKsZ26ZeA4xN0tJWqkr2qpDqH3VG8+Veo2FPsGRgUlXWG+8JAcomGqiezbi0TfeVjKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSw98VYnuaT1NfkmYzEEx/pk2nHDm3m0HVINBuh37OuzdOfNwW
	cQlm5G6fnj7YOunOHTozkIUChuh6zf0o5vmUSCrNKfZEBqOn/DoL6JU0DjTnREUJI+LuBawlnwW
	zpbwI9ANy3cqD/Wwx7grRSS9bSce4rbLDP6f//UFrTA4f7Fk5Z/y3G93TJ2o=
X-Google-Smtp-Source: AGHT+IGqRzrQxb2/qo9cxluGeSGc3ffRrYxJVeTFxOu68NAdqGwCBo9zqMCIguUWepMEvwLW5F+vKpL5rGv8Q98Bv/zrUKyvbg1L
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:3f6:5d61:e6e7 with SMTP id
 e9e14a558f8ab-3f65d61e8d5mr80856405ab.5.1756936543683; Wed, 03 Sep 2025
 14:55:43 -0700 (PDT)
Date: Wed, 03 Sep 2025 14:55:43 -0700
In-Reply-To: <20250903032656.2012337-1-csander@purestorage.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
From: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
* [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
* [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
* [PATCH 3/4] io_uring: factor out uring_lock helpers
* [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

and found the following issue:
WARNING in io_handle_tw_list

Full report is available here:
https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae

***

WARNING in io_handle_tw_list

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
Modules linked in:
CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
 io_sq_tw io_uring/sqpoll.c:244 [inline]
 io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
 ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.


Return-Path: <io-uring+bounces-13239-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JfJC9fr+WkLFQMAu9opvQ
	(envelope-from <io-uring+bounces-13239-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:08:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F444CE2C4
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE8E630054E0
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 13:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281653D4121;
	Tue,  5 May 2026 13:08:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236E43C06D
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777986513; cv=none; b=FyADNF8IVgWkAtlA+wzptXFr9FTv2u+5BlQeMi+uPQw2BVzI8hd+shCy3zgIdFkbLtz6y2f+GejNaaijjUFeVrOLkkisBcBleMR1UB77QEQORl60AiOyni3ozQsu7w5UZBSFLlR2KjtuOR2Ly8YtSkVpwlAAPXKJ1gLPIY7uzv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777986513; c=relaxed/simple;
	bh=sFevfuThPnK9sIPvedInedMJ5eGsSSn0G/pa7IgRNzY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Jnm0oBqXWO46zLbtLVgxEjdZ8l3NiHyojx0XVnKRIBjID3A4RI8Jad/ydxQBhgGQdRLUdhs6wnMotd86hCLNkKmmbZ/wv20rMoS/iNU9fNyKy3q78bjCK0HippUpA1saQYNS9upypjj3FHcBRkKotH7JvgE52somMUe6Vdb12RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6966db8db2aso8364469eaf.0
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777986511; x=1778591311;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTYFpGF2sAJ08QtA3xEO+n4nsS4Uz+UMNVOp/UWwx7k=;
        b=WavkXBgtwwaTYZ+8hVzTDh1XPauyBJXqmUnwejJaEnwU2feO5eA/f12dCLxN/GbiBl
         TXuTfsngjNsDSNxEjDxOFOueRK/g/wZf54gfPPalWUf0DOuCrmN924OUyvpy3hZBcMP1
         3DAkN4Iz/yJBAxoAAfxcGhCq1HsJO7Nu/PShjQXzFCip7uFo4RLH3tgpjva0DEJ5c3ZV
         U2G8q+m4cw36/NbRgZZvm5Re/2+EZMeTPD/j2h6n7etWQjkZn73q8V2kpTLw+i2+6cAl
         ONsim8n87UnCcscqXHkp0hFLjNCP5bQpRZZ8uNCWlMRrrTbw6lAX/BFV7nah4WwPqCfM
         pyNg==
X-Forwarded-Encrypted: i=1; AFNElJ/Fd6YG+ei2OLJ0hHtl7rixxvbkqMn6T1s7V0uGp+n0L/j8MC0nMhP7MFDzlhca/Qb8RpgW/ALgIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYIMsH/71oFbss1gahJO9CXZE4na6rdCJWO8bn4wXnGJ6eR08f
	pwpVPtPEkmnIH4n3lgLTr2Em7NSzCJRORYGlSJWxlaud546D+zNu5010eSwkx4u0dX/SRxD/2p+
	QE9eSuxKbezGCulxMvzBb8A9r85+nX2OT58ZDxt2gp65bHsA3DQngPjciNXY=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:e16:b0:694:857a:5a78 with SMTP id
 006d021491bc7-698876f07f9mr1294157eaf.8.1777986510804; Tue, 05 May 2026
 06:08:30 -0700 (PDT)
Date: Tue, 05 May 2026 06:08:30 -0700
In-Reply-To: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f9ebce.170a0220.59368.0011.GAE@google.com>
Subject: [syzbot ci] Re: io_uring/rsrc: remove registered buffer 1GB limit
From: syzbot ci <syzbot+ci5f475aa1640b4177@syzkaller.appspotmail.com>
To: andres@anarazel.de, axboe@kernel.dk, io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B2F444CE2C4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.991];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,appspotmail.com:email,googlegroups.com:email];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13239-lists,io-uring=lfdr.de,ci5f475aa1640b4177];
	RCPT_COUNT_FIVE(0.00)[5]

syzbot ci has tested the following series

[v1] io_uring/rsrc: remove registered buffer 1GB limit
https://lore.kernel.org/all/6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk
* [PATCH] io_uring/rsrc: remove registered buffer 1GB limit

and found the following issue:
WARNING in io_pin_pages

Full report is available here:
https://ci.syzbot.org/series/576c7f20-d7fb-471a-a534-f8f67489e049

***

WARNING in io_pin_pages

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      c7e4e4d5f7dc2daa439303d1b5bf6bdfaa249f49
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/287c9ce7-c085-4a41-9f94-756762f8dacf/config
syz repro: https://ci.syzbot.org/findings/63ff94b0-aced-41c6-83fc-a917c57ad624/syz_repro

------------[ cut here ]------------
!(flags & __GFP_NOWARN)
WARNING: mm/slub.c:6840 at __kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6840, CPU#1: syz.1.18/5830
Modules linked in:
CPU: 1 UID: 0 PID: 5830 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6840
Code: ff 48 c7 c7 d0 bd a8 8e 48 89 de e8 dc 48 c9 02 e9 49 fc ff ff 48 c7 c7 10 be a8 8e 48 89 de e8 c8 48 c9 02 e9 7e fc ff ff 90 <0f> 0b 90 45 31 e4 e9 f8 fd ff ff 90 0f 0b 90 e9 52 ff ff ff 49 83
RSP: 0018:ffffc90003a37928 EFLAGS: 00010246
RAX: 0000000000000004 RBX: 0000000201000008 RCX: 0000000080000001
RDX: 0000000201000008 RSI: ffffffff8c28ac40 RDI: ffffffff8c28ac00
RBP: ffffc90003a37b70 R08: 00000000004028c0 R09: 00000000ffffffff
R10: 0000000000000006 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000004028c0 R14: 0000000000000016 R15: 00000000ffffffff
FS:  00007fb3823ec6c0(0000) GS:ffff8882a9290000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcca0efe68 CR3: 000000017064e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_pin_pages+0xac/0x1a0 io_uring/memmap.c:59
 io_sqe_buffer_register+0x228/0x1860 io_uring/rsrc.c:801
 io_sqe_buffers_register+0x2f9/0x7e0 io_uring/rsrc.c:913
 io_register_rsrc+0x24d/0x280 io_uring/rsrc.c:414
 __io_uring_register io_uring/register.c:843 [inline]
 __do_sys_io_uring_register io_uring/register.c:1029 [inline]
 __se_sys_io_uring_register+0xc5d/0x1ac0 io_uring/register.c:1006
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb38159cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3823ec028 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007fb381815fa0 RCX: 00007fb38159cdd9
RDX: 0000200000002700 RSI: 000000000000000f RDI: 0000000000000003
RBP: 00007fb381632d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb381816038 R14: 00007fb381815fa0 R15: 00007fffdb4e7d78
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.


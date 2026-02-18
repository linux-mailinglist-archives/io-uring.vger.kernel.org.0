Return-Path: <io-uring+bounces-12311-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id bYn4G4N9lWn+RwIAu9opvQ
	(envelope-from <io-uring+bounces-12311-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 09:51:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7741544F1
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 09:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32B793031CC7
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 08:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEAC2F5A09;
	Wed, 18 Feb 2026 08:47:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1BE325488
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 08:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771404428; cv=none; b=Ai1GZwEA8pshlqumHkY/AqDZVCysVrHlILtnQmLl2MOZ5BAh/UYgVckTDsg6PNGMRXCKf7zaFNdaBxujFmPoKH41aNaw3FBvS8p7mFCCNEb5eQey1bs/mU/wXqq3uMVayd12ab4KeFcBhCrQU9RQ9VljMjUOzxSr1kGGoPmkpTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771404428; c=relaxed/simple;
	bh=Esdzk9VSfB+lTanDTVJE2rQhGfxzfyI1dUMsdig+Em8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=CZ3fTSUuolpJxmXMbSSPjqgcxwkEPMJfwqLIO1SbXg0hSBifGPsMEgP/do1LW/rEMjK3uLG2ATiU9JeRi0UUHa7EYYmJ1dj88KIBo7CA+jlq8lVCaOqgI8WHRM8uEHCt9ibulTHxKxni6MLLJvGlJ4NK0pKZ/Q1FojSttmUSZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-662ca3cb667so17121927eaf.2
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 00:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771404426; x=1772009226;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU0dvQSdrNuSDHm9APNyMRdxU4fTzW2ZD/3ePa8/37w=;
        b=tCgcSVXqHLfQwrG1eNZJ5uAkFIdESkzKFbJpG9L18Ps5hLuM7m5KeoPG0xM9BemY40
         JlavoiVHKGde4uZLLuA1/uSwaNWdSgO0frVr456Muo8xWiwx80sRbQMy6K6NKoMJhSPG
         HpACOcmv8YI+76/DmuJCPGbIvLGlaUcftQ2RFtA/af8N/+4oYp3WsKvwsmdNAlKKoZ8g
         Rb3CAuk4GIdMv3mzsC6r3o6Mlv7/WjcQv02SnS3BXgsGJHaS3FZ2bK30bRD+Bo6nbM2h
         JalUWBjkOg4heeISmkh2p9vbDs1mvN1Ca1Ei8GeupBOeE/datEcKJ5Rdcfi9wCHz86vQ
         eHRA==
X-Forwarded-Encrypted: i=1; AJvYcCVRKDpjebY2+x29G6f03DmXtDgYM+pL9Km8gszRAWByYw2ULl1PIvIb+ZX42LrHwHH4D15d8UbDTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXVHVwXYMNMY1YDPhbR+C3TUV+6Zy4/XXxcnXhsu/IBmADsE+E
	Pb1QBLSmVixVKVxYa7SAZZhdehTvAHk4Og8V8rfF7GzLBHOTVfk2RsCl020gnLS5oWoW+h8ISri
	gKS2BNFXvIcHasBK+ZvvEcudsW/V14LsC6qRcgVQ0Ix7V/KUxoeAmOLw63Ws=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2907:b0:679:a650:cc20 with SMTP id
 006d021491bc7-679a650d096mr1037503eaf.80.1771404426124; Wed, 18 Feb 2026
 00:47:06 -0800 (PST)
Date: Wed, 18 Feb 2026 00:47:06 -0800
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69957c8a.a70a0220.2c38d7.011b.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: add kernel-managed buffer rings
From: syzbot ci <syzbot+ci872ea55a8e111acc@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bernd@bsbernd.com, 
	csander@purestorage.com, hch@infradead.org, io-uring@vger.kernel.org, 
	joannelkoong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,bsbernd.com,purestorage.com,infradead.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12311-lists,io-uring=lfdr.de,ci872ea55a8e111acc];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,appspotmail.com:email,syzbot.org:url]
X-Rspamd-Queue-Id: BC7741544F1
X-Rspamd-Action: no action

syzbot ci has tested the following series

[v2] io_uring: add kernel-managed buffer rings
https://lore.kernel.org/all/20260218025207.1425553-1-joannelkoong@gmail.com
* [PATCH v2 1/9] io_uring/memmap: chunk allocations in io_region_allocate_pages()
* [PATCH v2 2/9] io_uring/kbuf: add support for kernel-managed buffer rings
* [PATCH v2 3/9] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
* [PATCH v2 4/9] io_uring/kbuf: add buffer ring pinning/unpinning
* [PATCH v2 5/9] io_uring/kbuf: return buffer id in buffer selection
* [PATCH v2 6/9] io_uring/kbuf: add recycling for kernel managed buffer rings
* [PATCH v2 7/9] io_uring/kbuf: add io_uring_is_kmbuf_ring()
* [PATCH v2 8/9] io_uring/kbuf: export io_ring_buffer_select()
* [PATCH v2 9/9] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()

and found the following issue:
general protection fault in io_remove_buffers_legacy

Full report is available here:
https://ci.syzbot.org/series/ddeaf464-c69b-4166-b0cf-53c9d51e4820

***

general protection fault in io_remove_buffers_legacy

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2961f841b025fb234860bac26dfb7fa7cb0fb122
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ab5ad5aa-2757-4d66-a2c5-391a8417535d/config
C repro:   https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefffbce63/c_repro
syz repro: https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefffbce63/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 bd 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 0000000175cd2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del include/linux/list.h:237 [inline]
 io_remove_buffers_legacy+0x139/0x310 io_uring/kbuf.c:533
 io_put_bl+0x62/0x120 io_uring/kbuf.c:548
 io_register_pbuf_ring+0x6c0/0x7d0 io_uring/kbuf.c:855
 __io_uring_register io_uring/register.c:838 [inline]
 __do_sys_io_uring_register io_uring/register.c:1024 [inline]
 __se_sys_io_uring_register+0xc3e/0x19a0 io_uring/register.c:1001
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f056859bf79
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd8dcfaf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f0568815fa0 RCX: 00007f056859bf79
RDX: 0000200000000040 RSI: 0000000000000016 RDI: 0000000000000004
RBP: 00007f05686327e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0568815fac R14: 00007f0568815fa0 R15: 00007f0568815fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 bd 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f25f1e17095 CR3: 0000000175cd2000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	90                   	nop
   4:	90                   	nop
   5:	f3 0f 1e fa          	endbr64
   9:	41 57                	push   %r15
   b:	41 56                	push   %r14
   d:	41 55                	push   %r13
   f:	41 54                	push   %r12
  11:	53                   	push   %rbx
  12:	48 89 fb             	mov    %rdi,%rbx
  15:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  1c:	fc ff df
  1f:	48 83 c7 08          	add    $0x8,%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 05                	je     0x36
  31:	e8 df 8c 77 fd       	call   0xfd778d15
  36:	4c 8b 7b 08          	mov    0x8(%rbx),%r15
  3a:	48 89 d8             	mov    %rbx,%rax
  3d:	48                   	rex.W
  3e:	c1                   	.byte 0xc1
  3f:	e8                   	.byte 0xe8


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.


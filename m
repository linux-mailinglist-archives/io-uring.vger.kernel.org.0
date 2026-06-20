Return-Path: <io-uring+bounces-13797-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lgVrLyAQNmoj7QYAu9opvQ
	(envelope-from <io-uring+bounces-13797-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 05:59:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0560D6A84C8
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 05:59:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13797-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13797-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A4C43033D06
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 03:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61B9218E91;
	Sat, 20 Jun 2026 03:59:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1C231842
	for <io-uring@vger.kernel.org>; Sat, 20 Jun 2026 03:59:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781927965; cv=none; b=PRAxw3T/HoVDw4evmBlU0te2ejWd7C7PvLA5F2cT8S8NejOdfA2TWX1c1Hb9u2sc92YUgoKoxT4Ujt0cF/Ig1aFhcBzbKeyqN/3QbYrm3p44gvCJ9wHMV5Ijwmd89Kkz1xrrHEo6fsr7ymaxAZJYjXMn9n/7/z1nOr22qK08dlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781927965; c=relaxed/simple;
	bh=zjbTYABBQCq4MV195LvlToSF2Y8xv4Wp7WS3HzDItJE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mXbso/KaNEkQak+azlDTUHaqQV1/iR574olcu5rinOc4pKtzkjuAFGi+a+qXV7E3gehp32bt0gAACg3Rm+Lt0VG1m4spjeSvreYLNRwao0ZGYYjpQpO54JqlhrhTkX4g09qBhi3uIiqdm8I8z3iVw/9N6nJzuVtN401esvjDVD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-48976713b46so1967447b6e.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 20:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781927963; x=1782532763;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hBIEmhr57CNARluLSmTu1YJVZdcg6Ib83HB4fCchvfY=;
        b=iA70pklj2cpKHIUHoxwUm81KWZ8WUz5ze4LOSQVXDbBuBS0sAEFgm/bJZXDgKrSs4S
         BI/IU9gIhalc6MTOnDTMBuL1ZY03MGYvpzscsa/VQDkZ6B3q7O4cbA+yUyC8E7skc329
         ORWtFqxJezRTHR+6eYn5gFkwXfSfusqaVPrao2a6MDqMw/iVIWXSeVT0G4qtRqN4W8Am
         INVFkqm7O8pl2rjtE1tmdXFdw9NVTLOU96D+jsNNLJZvRDxpy/esdfktErxNkBmfDuEX
         +OVj5kfeMCRL4pyWSXvtHSh3pfLd5jSm3nSm/r8ZkXnpjbH6IKT7FA0Wp5CVP5SNoDXp
         vFUA==
X-Forwarded-Encrypted: i=1; AFNElJ+yEUW7PLrSTtR5Yf1AgaiM/R4NlxNMP1XoAdiLEjB82YEP2fHTaQGkCsQxSNxOghXsufsCchua8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQS6aJvmNWj9yBuqWUv+RT/RcXxn/Uh43oWHalcWKSGO15qhLy
	FXRALdquGNKhupl32jCLM30VkHKsomnVMhq9TpwaQAUypdmUxukylASAOPVBUpq+IH+fJxTIN76
	KZZwkpakD4RQaAf9RIaS1tQ1Woy8rxYznRkpnzDSfKeSThV6LTEmdJ3mdAeA=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1491:b0:479:ac7d:6d8a with SMTP id
 5614622812f47-4896ac02527mr5769421b6e.24.1781927963296; Fri, 19 Jun 2026
 20:59:23 -0700 (PDT)
Date: Fri, 19 Jun 2026 20:59:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a36101b.be22b350.2a3e9.0001.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_pin_pages (2)
From: syzbot <syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.36 / 15.00];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fef3a5f0899512];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13797-lists,io-uring=lfdr.de,f99b00a963915b6b52c6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goo.gl:url,syzkaller.appspotmail.com:from_mime,storage.googleapis.com:url,vger.kernel.org:from_smtp,appspotmail.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,syzkaller.appspot.com:url,googlegroups.com:email];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:syzkaller-bugs@googlegroups.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	TAGGED_RCPT(0.00)[io-uring];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0560D6A84C8

Hello,

syzbot found the following issue on:

HEAD commit:    83f1454877cc Merge tag 'ext4_for_linus-7.2-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1211daae580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fef3a5f0899512
dashboard link: https://syzkaller.appspot.com/bug?extid=f99b00a963915b6b52c6
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b12ae580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165bb986580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/87171ffb708f/disk-83f14548.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf1d27787991/vmlinux-83f14548.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6e9a56090e11/bzImage-83f14548.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com

------------[ cut here ]------------
!(flags & __GFP_NOWARN)
WARNING: mm/slub.c:6841 at __kvmalloc_node_noprof+0x6f7/0xa60 mm/slub.c:6841, CPU#1: syz.0.17/5823
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:__kvmalloc_node_noprof+0x6f7/0xa60 mm/slub.c:6841
Code: c1 e8 5d 0f ff ff 4d 85 f6 0f 85 21 fd ff ff 48 81 fb ff ff ff 7f 0f 86 b8 fc ff ff 41 81 e4 00 20 00 00 0f 85 07 fd ff ff 90 <0f> 0b 90 e9 fe fc ff ff be 43 01 00 00 48 c7 c7 22 f2 f1 8d e8 a0
RSP: 0018:ffffc9000249fa88 EFLAGS: 00010246
RAX: 0000000000000001 RBX: 0000000080000008 RCX: 0000000100000000
RDX: 0000000000000000 RSI: ffffffff8c1d1100 RDI: ffffffff8e1e6928
RBP: 000000d6000000ca R08: 00000000004028c0 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 00000000ffffffff R14: 0000000000000000 R15: 00000000004028c0
FS:  000055556bd29500(0000) GS:ffff88812442d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd3d173e44 CR3: 0000000076c8e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 io_pin_pages+0xc3/0x1e0 io_uring/memmap.c:59
 io_sqe_buffer_register+0x1d9/0x1500 io_uring/rsrc.c:884
 io_sqe_buffers_register.cold+0x346/0x4c3 io_uring/rsrc.c:995
 __io_uring_register io_uring/register.c:767 [inline]
 __do_sys_io_uring_register+0x13ce/0x1bc0 io_uring/register.c:1029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd6539ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5b4af188 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007fcd65615fa0 RCX: 00007fcd6539ce59
RDX: 0000200000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: 00007fcd65432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcd65615fac R14: 00007fcd65615fa0 R15: 00007fcd65615fa0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup


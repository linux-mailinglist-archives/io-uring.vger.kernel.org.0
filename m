Return-Path: <io-uring+bounces-12310-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPV+DGw5lWnXNQIAu9opvQ
	(envelope-from <io-uring+bounces-12310-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 05:00:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB8E152E85
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 05:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A95D301D95E
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 04:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8842D738E;
	Wed, 18 Feb 2026 04:00:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02332C2EA
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771387241; cv=none; b=IaPYQvz7F/1FfVB9uEK6Zmuvcv0+AtvBJwPB/MQyErrTjhyAHFQQ2/e/+WHibZN91F+5Y8LGN7soAHZQLPYc6+Vrb1bGEAq0QAKR1cY9Ry9dqTm1ZKBjjGLAlTIisArQqBv6yQEbC60lH4546UljJESpjmaikD+JL43DJtUOWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771387241; c=relaxed/simple;
	bh=pAKi8y8ZHxGpohNq+c1xRLG0Do1H4dZ7Jj0yqgZ++Ig=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PvCmqnTXwiHoiI6/rhSz7rtnhn+/qVBchR4RSTCVwotCgyQgFAJ3S7MXzet3xDuHe4jDbozCjN2CFqFcNaoR9nJvA0JXdxoKionaWQPTeGXKTnoUgfPObsIyJz2+GS6KcwGpx1Vs2xzP9qTnA8iVWZfVrzfWe7AWP00+6Ls7C9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40eb57139f3so42854145fac.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 20:00:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771387239; x=1771992039;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqOiCdaHhD9Z7AwBKS+xfelLH4BnkqwdKh3Ewl594ws=;
        b=dSDQDycOhswNyzlu4lyOBHICz/QwFrJ934zT+OAQ19kv274cWRSY67TzSICDfgDQV6
         z0J5bn0WFrlPaBphR6RPFUsXUITIjiW4rYZ+dC7OrcVwxqCwjlCJO5HO+OqLMSy/1xiW
         MpqMf+Nr2WbQhdKRcT/2F/1ePZH4A2l+XSTDoK4dZv6hC+XPxmVPSyPFcwMfxfiLAlP0
         0hq4TZGp32G9DtfP2/rC9LotR6qAz0n+nV2xxoJkVs1IEUipvdjYxLRzsVS4MrYJLdyj
         3D5qFVnY5II0Pb1Gvj5+wodpuw4Dk0nnecmtfPJ5vgWQql2YMGpc5M/M8gzHfSfatwok
         9CIA==
X-Gm-Message-State: AOJu0YwTjheb+YmlJMpeaKMSthLz2YH0J13wJbg5LLoCSSFcDZFSxQNo
	vDxxyBvf6mun+PlGTAcs2HaXGY0d5dgIOSN+vJ7ZoLR1XjvOR/yv1oBAMOVyhD+57Zr38/rksMA
	t6T9EyK13p25n22S2qYYMxYXYFx8WMtvMOU+4W/uMTrYp4JUrXCHRaXkfsa8=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:20d:b0:662:fb4e:5f40 with SMTP id
 006d021491bc7-679a73f3f4amr382145eaf.35.1771387238996; Tue, 17 Feb 2026
 20:00:38 -0800 (PST)
Date: Tue, 17 Feb 2026 20:00:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in __secure_computing
From: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org, 
	luto@amacapital.net, syzkaller-bugs@googlegroups.com, wad@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=e2f061f80b102378];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12310-lists,io-uring=lfdr.de,0a4c46806941297fecb9];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,googlegroups.com:email,goo.gl:url]
X-Rspamd-Queue-Id: 7FB8E152E85
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    2961f841b025 Merge tag 'turbostat-2026.02.14' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1721315a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2f061f80b102378
dashboard link: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142edb3a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2961f841.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f9939f81465/vmlinux-2961f841.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3f9babe832cd/bzImage-2961f841.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077
Modules linked in:
CPU: 1 UID: 0 PID: 6077 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407
Code: 00 e8 96 52 fe ff e8 31 27 ff ff e8 fc 68 6b 00 bf 09 00 00 00 e8 82 f0 be ff e8 3d 79 6b 00 e9 06 fe ff ff e8 13 27 ff ff 90 <0f> 0b 90 e8 da 68 6b 00 bf 09 00 00 00 e8 60 f0 be ff e8 fb 26 ff
RSP: 0018:ffffc9000413fed0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000413ff48 RCX: ffffffff82097151
RDX: ffff888035c04900 RSI: ffffffff8209730d RDI: ffff888035c04900
RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000003
R10: 0000000000000003 R11: 0000000000000000 R12: 00000000000001b4
R13: 00000000000001b4 R14: ffff888035c04900 R15: 0000000000000001
FS:  0000555575c2e500(0000) GS:ffff8880d644a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f20e8a71fc0 CR3: 00000000373f5000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 syscall_trace_enter include/linux/entry-common.h:112 [inline]
 syscall_enter_from_user_mode_work include/linux/entry-common.h:156 [inline]
 syscall_enter_from_user_mode include/linux/entry-common.h:187 [inline]
 do_syscall_64+0x568/0xf80 arch/x86/entry/syscall_64.c:90
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f20e8b9c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd25984108 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: ffffffffffffffda RBX: 00007ffd259841f0 RCX: 00007f20e8b9c629
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000000f6e1 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b2d120000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f20e8e15fac R14: 00007f20e8e15fa8 R15: 00007f20e8e15fa0
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


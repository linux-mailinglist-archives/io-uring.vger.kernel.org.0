Return-Path: <io-uring+bounces-12493-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id nAiKD88fpGmEXwUAu9opvQ
	(envelope-from <io-uring+bounces-12493-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 12:15:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0D41CF49D
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 12:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC6C830134A5
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 11:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835C62C15A9;
	Sun,  1 Mar 2026 11:15:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121A9175A68
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772363723; cv=none; b=cD08HZdkY79WrWfylht/ACwad6LkoOfQBVX/4FD5g+dE2J3zTzIs7BnpzkoctrNDi9azzrgrLBIa6lk2LSWv5CKIv0Af+o0Z+BhRi/l26rVnFks039H4T9k9jG2Dvqia9ntKlj0nfIJn7beJRw94Qxqbl6NfSnt+AXYhDVlU+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772363723; c=relaxed/simple;
	bh=6nqydCXm309rCoYFPEhyghNtvLDFuVFmAPLQ2/fwK+M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QZC/LGUERQrp5xtwq/kMxun1VZKwTNV4BY4huXY0Xl6ITqrayx9PzZa/eBHnyaklbhoUCIYDe79YdO0p3H3A2fikYtwWjNGcXz7we6nt7p4DBt/U3pYVpLarudWRCgt4C77Ak82DQ0YksAprkoV5u6AA9goE4N8GQjbQovTsX28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679c978c609so29056669eaf.0
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 03:15:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772363721; x=1772968521;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uTWr7yHz10Q63auFPet4ICgnJKDd44UMepwelZQbJc0=;
        b=nDECatzqhK9K6Cg0gVxhl6T5YPtkWI7SNHKLY3cgmj6ZDL3qDgbliS1oqwCkpWIeUs
         01H3UWAaLZ0bc4dCdcbHR9J1O53N7dLmuwuSAqOOrzYCjGzqj4aQbF8rxMUzlxiOZlI2
         N1Q4r/hQT1l9WoXtFyySSBlUEcHOl+yOuS4mh0qEgmKhaI3EKSUgIZBo9NoFAct1yvWa
         AeUoPRwBIl+INS8valXfVGMnjPRsS83wZMKIqSa74m1Ar4MsU4UfzKNjpWN/ULOyoalR
         qjQyayAGqiAfUBv7PwAFcaWQtnVuS1wDztUr3nltZXRVWsimzOjOtJ/6+AlRB5coTfEn
         VY2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUPC5NaP7ItW80XpYDpH9y99vkE3kzj9atxc2pO3ffjTXbj71D+jqyEEv0R86ysjcbOoXotqjMxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzH/VXWq+6pMLJ1EsO5STg/Am/vLgBJ8yPMl0RGvho2y1UTS2Hf
	bcCLdvGPq63ukIEcWSpH/bzMDdmLWtGUxS0NMug/09L1L8jbJrSP5wJVtiAxRHv52Gh3WKsbwCe
	QlC99RIfck93dQslF10DfONkXYHx+uIa6yisWyCBesVCbqlQE2bfq1TaPz68=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81d2:b0:676:f174:9d07 with SMTP id
 006d021491bc7-679fae11a3bmr5321030eaf.19.1772363721178; Sun, 01 Mar 2026
 03:15:21 -0800 (PST)
Date: Sun, 01 Mar 2026 03:15:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a41fc9.050a0220.3a55be.005a.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_wq_put_and_exit
From: syzbot <syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=2b3e7eea64c28d20];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-12493-lists,io-uring=lfdr.de,79a4cc863a8db58cd92b];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,storage.googleapis.com:url,googlegroups.com:email,appspotmail.com:email,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 7D0D41CF49D
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    a75cb869a8cc Merge tag 'v7.0-rc1-ksmbd-server-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c91952580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b3e7eea64c28d20
dashboard link: https://syzkaller.appspot.com/bug?extid=79a4cc863a8db58cd92b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2c2deb730c26/disk-a75cb869.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2c7db53271fb/vmlinux-a75cb869.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db43e1ef6c13/bzImage-a75cb869.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com

------------[ cut here ]------------
time_after(jiffies, warn_timeout)
WARNING: io_uring/io-wq.c:1369 at io_wq_exit_workers io_uring/io-wq.c:1369 [inline], CPU#1: syz.0.2310/14573
WARNING: io_uring/io-wq.c:1369 at io_wq_put_and_exit+0x36c/0x9d0 io_uring/io-wq.c:1398, CPU#1: syz.0.2310/14573
Modules linked in:
CPU: 1 UID: 0 PID: 14573 Comm: syz.0.2310 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:io_wq_exit_workers io_uring/io-wq.c:1369 [inline]
RIP: 0010:io_wq_put_and_exit+0x36c/0x9d0 io_uring/io-wq.c:1398
Code: 00 00 0f 85 7d 05 00 00 48 8b 15 1f c2 50 09 4d 89 e7 31 ff 49 29 d7 4c 89 fe e8 2f 49 18 fd 4d 85 ff 79 aa e8 45 4e 18 fd 90 <0f> 0b 90 eb 9f e8 3a 4e 18 fd 4c 8d 63 08 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90000a678d0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888023693000 RCX: ffffffff84f05071
RDX: ffff88807bec2480 RSI: ffffffff84f0507b RDI: ffff88807bec2480
RBP: fffffbfff1c82250 R08: 0000000000000007 R09: 0000000000000000
R10: ffffffffffffe8f4 R11: 0000000000000000 R12: 0000000100012cf4
R13: 0000000000001b58 R14: ffff888023693018 R15: ffffffffffffe8f4
FS:  00007f83887c66c0(0000) GS:ffff888124447000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000a63000 CR3: 00000000acc14000 CR4: 00000000003526f0
DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000083
DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_uring_clean_tctx+0x114/0x180 io_uring/tctx.c:222
 io_uring_cancel_generic+0x7b9/0x810 io_uring/cancel.c:650
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x2be/0x2aa0 kernel/exit.c:911
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x4a0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x67c/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f838799c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f83887c60e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f8387c15fa8 RCX: 00007f838799c799
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f8387c15fa8
RBP: 00007f8387c15fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8387c16038 R14: 00007ffd9bf3d2d0 R15: 00007ffd9bf3d3b8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup


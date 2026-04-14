Return-Path: <io-uring+bounces-13038-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yIcjHntK3mkzqAkAu9opvQ
	(envelope-from <io-uring+bounces-13038-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 16:08:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC2B3FAE14
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 16:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 273823068F44
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 14:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4113E7161;
	Tue, 14 Apr 2026 14:06:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4E022FE0E
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175595; cv=none; b=UCFezmKhQ6V8QkOM6Q8MTcG0CjxXcbICYiEChHDNoTzaUKhN8MW1OEqMM/NKl1OgJirUTgzYexr+emhisJmSQ0ZpAIkElvOd7UjSi2lNY9qd5ibrPXOQbBA74UndGtvcmTFXzR1rYaQ6UcHA5NqJHzh1BsG57WvoAY+MX566cjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175595; c=relaxed/simple;
	bh=DgAENB3WHzVYcORyKqdwCIVZZSNSeG0iX8OtRJYQmFU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=g3DgQ6CwmuFo08mB5vLT1PAJhp1g4UyRaeHnE1ClXIziMvmGyshb/scg6uS/6wi+PUQ/8KhOtOySKHgh8+YO56uLjuhR6q2768YK4DnA6Dgqsth/qLVwAzRNYbGwluwInkNg332P1Hvtb+TYBwO2DQHHulVXi7Tkd3ptK1O8eRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6850890ec96so5823232eaf.1
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 07:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175593; x=1776780393;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9GiiDo/hLVX+hYvJ/BkRA1XftnQJvUX7CXL65wgHAqU=;
        b=QaASeg7+OM7mfnOt/JAN81jDnykWG5a0FsipqPmrHIqqLUIYJNNM8XwfYTNipGOXg4
         TGnU5MPGIqPj2G9FRyUdQlnatk+q+rpvgw1ouIPDdPV7hp0ZtOlxwPsmlWnMypsEsAeD
         RpLr9yKu4DFMWFtzauLo4acvp26OEH/rfJHTHtXPvzBBIOSQcv6vP1krUvViTWqRwbmM
         zZn6Y31WdlS7JMleb/cHPI8ZAECAHuHjNSDIQtRqpJ1XH1uRttRPElJ0+I8ZrMwWj18d
         29N73BbLmGGLMQRWj7WREc/Q9SzYoQz1KbOn4j9D4dBj07wyLJmpTeRFP7pRAEvuQLhp
         22WA==
X-Forwarded-Encrypted: i=1; AFNElJ+zdcPfVDwYe7pF9/I11v2e+ymTqGbzGZK2rk1pQKPONFuZAqXWIHKnwcUVC+sg2HNytoMQJI8QIg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4jPqML4U2srzDjGWQKo3YwxwoQ0BJbsAtbZz+kvPnwE0Eista
	PilfMUnEJ/643JbIocwxkd0b+oSfZCWxx/3pwYbFGnrA0D94MCKXVW+mdfAF8LSzE9saFJ99Q0+
	As17TeGvu29R3yBcaJDrxd/0vaEHtlwEQUmkLcAi1P37oaWYo33tW/WS/UdQ=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1903:b0:687:6290:6333 with SMTP id
 006d021491bc7-68be8fcba9amr8716062eaf.58.1776175593341; Tue, 14 Apr 2026
 07:06:33 -0700 (PDT)
Date: Tue, 14 Apr 2026 07:06:33 -0700
In-Reply-To: <69a41fc9.050a0220.3a55be.005a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69de49e9.a00a0220.468cb.0061.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in io_wq_put_and_exit
From: syzbot <syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=36e12cb4499e2de4];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13038-lists,io-uring=lfdr.de,79a4cc863a8db58cd92b];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email,storage.googleapis.com:url]
X-Rspamd-Queue-Id: DBC2B3FAE14
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

syzbot has found a reproducer for the following issue on:

HEAD commit:    d60bc1401583 Merge tag 'pwrseq-updates-for-v7.1-rc1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168b7b02580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36e12cb4499e2de4
dashboard link: https://syzkaller.appspot.com/bug?extid=79a4cc863a8db58cd92b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123f04ce580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e3bb6cfdd5a9/disk-d60bc140.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7d84405a4b00/vmlinux-d60bc140.xz
kernel image: https://storage.googleapis.com/syzbot-assets/de74b233e91c/bzImage-d60bc140.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 00007f8d42c15fa0 RCX: 00007f8d4299c819
RDX: 0000000000000000 RSI: 0000200000000080 RDI: 0000000000000084
RBP: 00007f8d42a32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8d42c15fac R14: 00007f8d42c15fa0 R15: 00007f8d42c15fa0
 </TASK>
------------[ cut here ]------------
!test_bit(IO_WQ_BIT_EXIT, &wq->state)
WARNING: io_uring/io-wq.c:1396 at io_wq_put_and_exit+0x8a7/0x9d0 io_uring/io-wq.c:1396, CPU#0: syz.0.19/5987
Modules linked in:
CPU: 0 UID: 0 PID: 5987 Comm: syz.0.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:io_wq_put_and_exit+0x8a7/0x9d0 io_uring/io-wq.c:1396
Code: ff e8 7d bf 17 fd 44 0f b6 74 24 78 31 ff 44 89 f6 e8 bd b9 17 fd 45 84 f6 0f 85 1a fd ff ff e9 67 fd ff ff e8 5a bf 17 fd 90 <0f> 0b 90 e9 00 f8 ff ff e8 8c 5e 83 fd e9 72 f8 ff ff 48 8b 3c 24
RSP: 0018:ffffc900036d7b50 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88807a8fa000 RCX: ffffffff84f04326
RDX: ffff88801e390000 RSI: ffffffff84f04b26 RDI: ffff88801e390000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 1ffff920006daf8c
R13: 0000000000000000 R14: ffff88801e390970 R15: ffff888032be0c18
FS:  00005555898aa500(0000) GS:ffff888124332000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 0000000077c62000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __io_uring_add_tctx_node+0x3e8/0x4c0 io_uring/tctx.c:174
 io_uring_create io_uring/io_uring.c:3063 [inline]
 io_uring_setup.cold+0x1993/0x1c7e io_uring/io_uring.c:3108
 __do_sys_io_uring_setup io_uring/io_uring.c:3142 [inline]
 __se_sys_io_uring_setup io_uring/io_uring.c:3133 [inline]
 __x64_sys_io_uring_setup+0xc2/0x170 io_uring/io_uring.c:3133
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8d4299c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9e8909a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f8d42c15fa0 RCX: 00007f8d4299c819
RDX: 0000000000000000 RSI: 0000200000000080 RDI: 0000000000000084
RBP: 00007f8d42a32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8d42c15fac R14: 00007f8d42c15fa0 R15: 00007f8d42c15fa0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.


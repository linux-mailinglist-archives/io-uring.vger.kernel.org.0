Return-Path: <io-uring+bounces-6326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BA0A2D6B0
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 15:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4D13188C77C
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 14:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAF51B4246;
	Sat,  8 Feb 2025 14:50:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0473D1991BF
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739026230; cv=none; b=RWDECaROC0Q50bDz4cM0wK1rW+r9tYkihSUk8XDIbZ9DN003DfUok6LjvNlOaHNDvKoO4c3J4POFUbW3HoSlbNNmKgVZ77AwAtdwI2GAnc5QcjnQsRg0fTthM1u7c1pjyRLzRn/AhqwxJyTlf3bEuOg9wfEffO3KimMIDbPvjtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739026230; c=relaxed/simple;
	bh=C39xxZbWG5B73fuAxMhH7Wx1t74Wf7VcK2EBsSFzYbU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bF0A8v9v4YE+y1oLyuYggkJ/ljMZmS/HeyzLq3uSxZvuvD4wnLQaX2maHaGHdMoWB1nmARihEJ4hRJpvgtpYbbFBacK6CPQr/oyC3q+6GBySKxSTqV9tDDwe+TOO83IGPX5HpwCHvynRffot9YSqQSXp5mLhrbuCrYBYjzBoMGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3cf64584097so22915175ab.2
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2025 06:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739026228; x=1739631028;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BbZBHmNjOsNgHsJJGIBV2EM3fYt/TUaHJ4HLa9k/xkQ=;
        b=SUcX1hHedEdOE/EF7nJ00vpld/cXblhf9O63p82Svs49FTKXWIqOd0CHUbG6Ahfl6N
         s2o4AjWkGfZJ5AiobgSvLLWEaLKqdZxilbrWipROIY4/HG1UswvlGJfq6Is4bKpEpus3
         3rssZnArXT2a6XfxTqdarkto8cuB2cg5W503R8YgRYSppbOVkt2V1TTtqHTxAtua9mIK
         98IFZptKeXURws6/52LaXClYxJlRO2+EItAq0sn39vGgCh4UDtx9DsDGWkAxlVLuqgIE
         ULFijEN65osN553T67tNgi64ybrR92B4SvGdznySZFyU2IPGd5Se6RmKXyslG+AkoHrb
         OweQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfhrqT58ld4hOIPTT0cs2NX968LziutLVd9WufJQuSiosHX4gDrZA1gg6h0L8oytr5JWSDjk+new==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcF/RQF+en6Pw5Ls4FQEeRWENkGrmFDqeh/nOE9Aysb86CnDJx
	JPLm7FWWTAQpwECYmdsylOKo99kXJCyNKXNVuY67hW/KrMKJoznNKEy7R8Uv+iitagm4d1APyEi
	dZv0a1ZihyADee7vC2IilWAP6XamDPgVox7mK/Iyt7jFCaVBBy5dICwU=
X-Google-Smtp-Source: AGHT+IG78lgY7nYVFXKmcWo5mIPjzy/BGpLNwEu4xmoWuk/k7xf5PKGOnTlhFukRmH0xiKUauVynhkGv4IuDjsD3J9MHxuzxBSag
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1cac:b0:3d0:2314:26e5 with SMTP id
 e9e14a558f8ab-3d13df3e9a8mr53582945ab.18.1739026228210; Sat, 08 Feb 2025
 06:50:28 -0800 (PST)
Date: Sat, 08 Feb 2025 06:50:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a76f34.050a0220.3d72c.0029.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (Feb 2025)
From: syzbot <syzbot+list10977d53e3ba4ce766d4@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 1 new issues were detected and 2 were fixed.
In total, 4 issues are still open and 113 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 189     No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 58      Yes   INFO: task hung in io_wq_put_and_exit (4)
                  https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
<3> 2       Yes   INFO: task hung in hugetlbfs_zero_partial_page
                  https://syzkaller.appspot.com/bug?extid=1c6e77303b6fae1f5957

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


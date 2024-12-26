Return-Path: <io-uring+bounces-5604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAEF9FC9DD
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 10:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3A15162F6D
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 09:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603071714BE;
	Thu, 26 Dec 2024 09:01:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99F013D600
	for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735203691; cv=none; b=dAxtx8Wmfw88jGevKQ45V2+nFWP6kVjsJtBQZN3z2iv4Yr6iR+ZYfNptVoq3/PnHMj8VDtgFF3UBFJxVK88HWVVwNbZWFPpsMYBi0ukNo1NVkH+0/xgEbhiJMw8Vb04niEbBE+PA1orSiqK5EuSoC0RwGYa3tjFWabaRG2hDcpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735203691; c=relaxed/simple;
	bh=XiS6Rbjn0/gOUmp2assHz1gURKb3DGr0GZFdo5o7qhA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QP98396eLNKhATfp2KrqFqaHdvdHWP0B+fXZaIGKqMliZKEL0fPS/CsahFONSIF1ftHAkdri4i2EOqsOqCY9SjhsEuqrxFkvZkKylqmiuljGM0VV48AyOkXEhOj+0VBs+sq2AEXu/20iAAKXMQWnAaokts/BuyXTEUwPUzHCPpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7de3ab182so123064145ab.1
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2024 01:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735203689; x=1735808489;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6q90i+UJwti9C0Z3u3BafrkMzJgXysTR6Gku42JPILQ=;
        b=guqrg2h9x8mdb/F39jRVB5/K0HoPoQODTZNWq8p3BtQZV7uOj+EvfppUSEAAh+cYWx
         OT5O3kmiH6UYK312LJZmE5lynK3vTfh34Z2ZeGzEHuv/XITpqJb6vdJU2oVMRtO4hjW+
         CqNWp6xrf1Ymtc1zq2VJt3V71qkecMKonwT7c73EswR0OWuve5FPTwH+Xqb69WmCsxhA
         ZJ6unrRhOy+648nhC5LT1sNY8xhtivVqm1//s9ryxYjsAfeUTqRW3O/tgQPFXXeASh95
         oQQrY+TTsAUpc6kVUIdqK8/nkzrp+82Z9HbuDhW+i48ZJ3OQkIRG75I06zst/5jGJeyJ
         oTiA==
X-Forwarded-Encrypted: i=1; AJvYcCXSRJl0GxVhNg0HbkpksMVDWoAF61l3NgoKovhLs5YALDblaQnjsM1ZbaJDR05OdiiZ+vJR2+gFqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYb0tLeB6m3uBJF17GVRYwmf7qiF7yUUhidGrGCFIpyvvkwajG
	BhSk528sGS5giqsli8sTxShiHNjhft5WwdrB95whgNiYpTzNgst3+PFH8j22C1Pr3BmE8eSBTJI
	FVbJ1jel+PS6RemCEsCHhn6Yl35Ek8UvcdNB96NSkg91UzkJewBl7dlw=
X-Google-Smtp-Source: AGHT+IFGM/wJ7vQZbm63hrkdC3ZHOr7Mn1zpwELwwd4DFbsB8Gja9gxNCJ1dj+9e3o4nQj5OsNm/vF/gAAZaZxVzGef67SESDR/u
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18cd:b0:3a7:81a4:a557 with SMTP id
 e9e14a558f8ab-3c2d65e508dmr184528335ab.24.1735203689052; Thu, 26 Dec 2024
 01:01:29 -0800 (PST)
Date: Thu, 26 Dec 2024 01:01:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676d1b69.050a0220.226966.007d.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (Dec 2024)
From: syzbot <syzbot+list494ac136ea991977a0db@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 3 new issues were detected and 2 were fixed.
In total, 7 issues are still open and 108 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 178     No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 57      Yes   WARNING: locking bug in sched_core_balance
                  https://syzkaller.appspot.com/bug?extid=14641d8d78cc029add8a
<3> 1       Yes   INFO: task hung in hugetlbfs_zero_partial_page
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


Return-Path: <io-uring+bounces-11697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0FFD1CBE5
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 07:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 657D63051ADF
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 06:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5A537418F;
	Wed, 14 Jan 2026 06:52:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A69D36BCE4
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 06:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373559; cv=none; b=lOEnwNLQRKdUh3vN4VhTquZNz2QPXpwK6/dm/ZqQzAQo2cW45RvAcUoAVEscQpkb6wXlvSMme1lB9aR3Tx0cpaOXOSZK4IZx4mQvuvclje5QiorzeUUYkbw0P3uFkvBK/UDkNICdhi7HvOoRulJkoTaB9mITK1eEdDC8a5WBeoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373559; c=relaxed/simple;
	bh=m3NtS9/WYq4ogsd0xWIPveap7BGcq4XUB+AfQuRe7ew=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AH8WsprpXRTr7oq1rSH3y9rVLYZNkWN2qUcorYmlwXdt5csGiGmsui2b4K+5W3KMx2HuuEcfCVZ7vuIKNa065E+RKkimTTTGQIoSXDnWiOwO54nL9XEvSJVTiW0fHaMfZybjqW4f6YeDF1sC0G5oqlA4pQOx9gdfpO0bQtr+yFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-450be8a012cso16754317b6e.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 22:52:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768373550; x=1768978350;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jB537Ogibf7YpoRVFLuuP4nwgbHZI+zx0PUtSdk9Flc=;
        b=ZzOSJ1gQG7YBVvzWSnCHGkxFOS0hUABuHFhD1EREuWPJ+r1DdwoPxwSbG1YCTV+LNK
         Drq9+yPhikzqqIS26QXNKd52hCB/yZ+798DiEor0GAZyWT6yunNDfRUTp78IlSCQIlZj
         HdHXNMdHIYE3sCsw3uluyUC2BEp7lOaSfWW2Sy9A/3YmEbVBPnVo5I6vALRLQ7MNY5YE
         9X7AsJ67vNhpAJzzeIfipDA3vE9lOLUIkoMpUXa3buLxcojFaBZg09uh1uBMiL7U/qHF
         ue7VP+I2r09sqE0Zh1Z2JIkiEKffq7sauo4Y2ClSmyoFtmRZgitcgxJNlrCjFxRoZPzN
         sYEA==
X-Forwarded-Encrypted: i=1; AJvYcCVqs8NLcBtdPz0VNCfsh4O56l9Md+nb6ZI1Q7Fm8DPP9OpTNwfx/6+Gj9XLrd2WfMyu+zGP3umArQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1HLq9IH50w+bBs5nZjL8Z4jXDCLM4uALg7KUhiqtv7RiAv8qJ
	j7B9C+Snh5ig1+PaDDERcE4dfA/SF62NDIO1pP0gXggtivygiK0XVAUe0XPl5TEmHBHID3ROhDo
	VYR9OaK4eXZh1FthjnDZLLvAlgpIgQzv5sRAP5o01VxdHOUthYa8RVOG1FIg=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1785:b0:45a:a4b7:e5a9 with SMTP id
 5614622812f47-45c71553f80mr1016306b6e.61.1768373550062; Tue, 13 Jan 2026
 22:52:30 -0800 (PST)
Date: Tue, 13 Jan 2026 22:52:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69673d2e.a70a0220.1aa68e.0001.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (Jan 2026)
From: syzbot <syzbot+list2596a0e816b2ced1c8ca@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 0 new issues were detected and 1 were fixed.
In total, 3 issues are still open and 133 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 5002    No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 68      Yes   INFO: task hung in io_wq_put_and_exit (6)
                  https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
<3> 30      No    INFO: rcu detected stall in io_ring_exit_work (3)
                  https://syzkaller.appspot.com/bug?extid=33504742c13bcd6c9541

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


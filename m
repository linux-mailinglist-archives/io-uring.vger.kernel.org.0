Return-Path: <io-uring+bounces-10974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB78CA5AAE
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 00:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E306303DDE7
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 23:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE5A260566;
	Thu,  4 Dec 2025 23:05:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88833DEFC
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 23:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764889536; cv=none; b=KwDDSfF994muV7v7o/ULl334zXpBYMIpQOYnp7vCPIvHKMH1LPryFPEj1CzjJPxApCK2B9x2e13m8Kke7/kQt6y2L/m50MM6T5fOThZhw9P/52tQrs5aJlPgJ6SLX8lEMrtH1zuX2lDhQw0rdF8EyM5gEks39ssXK7R7XSS4zb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764889536; c=relaxed/simple;
	bh=B6N7GPpf+2rjSuopOiNNLs+k8r2tKO8ldPdnfJrQTqI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gnksQJ0QpuXNJ6imvfArI0H14Zsy1aqIAit5Lel1wPLq9ZDP8//1oQrmoCAn9l/1atpTfXS88AnuprcNTuCRXwce7VAhX1DKEm9MuS7pYXApOupXP1jHv9iXsxUcL4Wk1JeIMNrkC79XAeoR2KiSfJKXSiNSCrTYAH4CImsIdUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-44fe931409aso810685b6e.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 15:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764889532; x=1765494332;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lLCQS7oLJmtgXpDYJT4/IPRj6VEJ6sFTUp9ljkYJ4Mo=;
        b=WokTQUB1dz6PreLnPOfpwvWt8h2UbpEO1yqLXxzJpiu6PhfSiqZBdz4hJYdfFAMn0C
         wMECapGWRd/Jb2c+52tp04niN7T9uHjIqMUz0jcXy/onW9zChRkmzmSKDnOFiP+sU3Nn
         eGQwDuwvtTVTp6KlDbIwysbR3kQ0IUXbEQkbih2Uz9hfd9fxA4hW4/TdQdl5NKPLI3Uh
         XVlbrcSKNVtsUJUnOjuFns1vxINL+Xk3WeGaD8kYrFAKNY4ZpcLQN+Y0z8t+zD4SbMvE
         7OVhn3V9PmoQJRAhgsv1ET83fqTj4bqMD2i/7uq23cxefoa+N8CDSmW4ksZmOO/ENWus
         8b7w==
X-Forwarded-Encrypted: i=1; AJvYcCWthLNJAJ5ZU4gAv3R3eTDd2Elz/UlypGlVsjPKl4W2kKvgMs8K6gqpmLjLUcCz2BEkDKz2xHRgvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEUAOrzm+VIQRUHYrwEququLoQx+fwLX9o1e2SID76QFxW9d5F
	dOt+oN3TVZt4QztcUJTvO98mkGQR8CrBmOBa90VAEGA7MpCt0WWE/TEyKNjzgYsIqlkKzvrEr6+
	OSEhEgJuLc9GEhBRJT8bE0EeVHLBO43bAa3ZJdWsKgYtSvIGLsYr55+9EiD0=
X-Google-Smtp-Source: AGHT+IGdCMyeiv07AFC2EfRUA3AOJ5QLX27r9NTc6RDtnShFpSbqSwuAaRYVR9ooxhC3Z1Fbysw9w3KTy6Fk8G298s9j4TJdN7HR
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6d8f:b0:453:f62:ddfe with SMTP id
 5614622812f47-4536e52e5b0mr3987675b6e.43.1764889532354; Thu, 04 Dec 2025
 15:05:32 -0800 (PST)
Date: Thu, 04 Dec 2025 15:05:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693213bc.a70a0220.2ea503.00ea.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (Dec 2025)
From: syzbot <syzbot+list2f3a8c0dbf1ef5c21483@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 1 new issues were detected and 1 were fixed.
In total, 3 issues are still open and 128 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 4212    No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 46      Yes   INFO: task hung in io_wq_put_and_exit (6)
                  https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
<3> 1       No    KASAN: slab-use-after-free Read in io_poll_remove_entries (2)
                  https://syzkaller.appspot.com/bug?extid=721cddf316143353975e

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


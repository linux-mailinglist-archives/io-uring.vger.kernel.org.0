Return-Path: <io-uring+bounces-9917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A07BC18DB
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 15:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0EB984EF427
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 13:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB9A2E11C6;
	Tue,  7 Oct 2025 13:45:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAEE2E11D5
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759844705; cv=none; b=NTus+G77/HPt85w9KYQNgDkOyTQJCFb6Mn6qCnfPgbdusrPfTHhyhuCg7OERU9MAVBHe+DRENQ1BeM8nv2HJ5FDqb2YAJXae7ynybWEDB65GTuH/fQgK+KIdGZVe1iSPjRw+MMHN7hyGevi4yDpQJRpCzT7RDvfaeSaN0BQbbGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759844705; c=relaxed/simple;
	bh=xWjmLBQ5keQMZ/8RBkxKB08avkEkdT811c//csHk2jU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jw68boqmo90Ft33m8k1p6kAa0+2KhGSo8FX/DmyIjFV2X46QDBFZGhc5UNBe3xTGmWm8IabTiJAZbhQ4zf4syPwz1MS0zyoXlJmaGFx+n1bOGuBjhPoSeKd1uWhdl++Cq11zlSjtWa6U7LwBmEFNWTPsZiJvg2Hyd/AQZgwfhKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42f71a09b2cso27663725ab.1
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 06:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759844703; x=1760449503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OdVSN+laD+F6d7qUqnjLSPnCbbVZWf+THc0/cthgRO8=;
        b=fgeku8s9mdpJ8U9d14gr1WD3gUDSWwIMB01aCbxFDaCCn9oIge6v1RkXAp9Sy9htCP
         8x2oqOl/86sLAUwMFhu+j5j+XWjRJyTYS9/MMQaHTXaQhF6NW1Ae2cIj7zCHOIggO7aY
         19BjjiAkk4K2g74G9RN7O6QcZHqgd1/znKpBEqW0gCF3XUWm51aXghljSHaA+yEGEO+o
         n0Z4NK0ELje+BGBKH8I2X+WmdNIh0B8q8QO5x3UZ59mxi3eopN/Wn070Dto8R5dsYnty
         Ye1dkTj+bxeAt5qiOrIF8/c3r/0rMwHA1+0+2GJ/nkgDGqTOT7r5ez1nWlFXW3hlZ7Tj
         OKBg==
X-Forwarded-Encrypted: i=1; AJvYcCWTxrCuifMzBMu+LZWD1HPUDLq5lYx1t5pY2dGFhTxfDVQ2kr1KlPH6tAL1K+Jh7Ki4hKiUbn3hOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YznIu8hwSOcmnns2uhwrvQ8j9r6KJsbzN9H61oIjbpcr1zpQx9T
	gleCIrMx0AfB8JvZPawttKmv1jqyWZNPNQMvmO2AytSQPc3rI4X4Qd723hAiQvo1rybRzgogSKi
	gVi2VNMjh4UvuaU4Qnjy5SrGZKyOlBHxr4GIXMvoYo04vXef0M6G0nM7e5h8=
X-Google-Smtp-Source: AGHT+IGDe+oPvXrYd8r2KJeAOfh3Qf98hvHejyYDAqBDAgB0WT7eJV883xCSAVgnpvxZvRvNsyKTF/F4ey7y3Yb0sMtJn+EODoJ7
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2188:b0:427:709a:fc87 with SMTP id
 e9e14a558f8ab-42e7ad9c5f4mr189291975ab.24.1759844702723; Tue, 07 Oct 2025
 06:45:02 -0700 (PDT)
Date: Tue, 07 Oct 2025 06:45:02 -0700
In-Reply-To: <747c4bf7-49bb-478d-a8f1-c7092ceaaa81@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e5195e.050a0220.256323.001f.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_waitid_wait
From: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Tested-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com

Tested on:

commit:         c746c3b5 Merge tag 'for-6.18-tag' of git://git.kernel...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=110955cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f142ebe84501b0b
dashboard link: https://syzkaller.appspot.com/bug?extid=b9e83021d9c642a33d8c
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13aa0542580000

Note: testing is done by a robot and is best-effort only.


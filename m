Return-Path: <io-uring+bounces-5677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC66FA019AE
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 15:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63C673A2FA3
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 14:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95588155326;
	Sun,  5 Jan 2025 14:13:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE34148FF6
	for <io-uring@vger.kernel.org>; Sun,  5 Jan 2025 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736086386; cv=none; b=EzTV+W8Ig8wro5bFywFgWyNhNkOap21WjWb2vCqjNU46fU4yd+j1fIgSgAB0NBTsOS+MQ/FHAxfqrZ8dfSHAWW1c4O2wZj5kKhZAwn+29/1ttQvwRZ4IRUzdAjdvdRWmXZSn7EcQ6T4ao5JBdia/6NGgrQNCWYfpXrbNp18xHAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736086386; c=relaxed/simple;
	bh=aRVI0PM1TCZY+aBpxAJ+62P59vvRgZkacfDEhUzEy0M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gdS3FAD1Y3rOXv8jg1198JSWd1QqW7Bom+t2+78SI8pTKJouJF63wQ69q02RHIizgKVgzTLWwznxoPDalzy2DVmGHQakVxFgdnbwvNOrJ5lp5xkHkRiw+/4Z5ApR3pMDMH3QCnqYXDGXU/N0MP+s43oU3/IV7tADv0P/klUyfcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso133839685ab.0
        for <io-uring@vger.kernel.org>; Sun, 05 Jan 2025 06:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736086383; x=1736691183;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3DB2kfv19UOQ2ASZU5/bUQYFRtWSL2cfvxrxetgTnI=;
        b=G8LPAlXmVFLAmLvnGlZ7ExsBf5aKTJr4w8SWNIoWFlLTiBIgFKIlS2lBR35iCwweLN
         cQvIJCOG/vYIRqBCOLVJXaKdIPDAc9GgPdtNATND0LwGO7IqJ/FHYmqMjGP3kBq99RKT
         Y47eaG0dkQ2o7szVvWYgsIXw2Ul0S84XtcsXpqohCvsaKqdyabSuUDFfJE66ZYOrkT4T
         IBkXDMCmi87QNASQrxFdyH5jQBG2BJtd7hcN7ExRtdEE0iyWMTYIdfsIUfVSI9gnVuz1
         YzHFAL0f13RSDgXLGD6JxMxlot4HH8SBHXir/+jZEmnQnvfY2CzGcjkpav2tpmhoeMWp
         VCXg==
X-Forwarded-Encrypted: i=1; AJvYcCXE9Jloiy28NkLNMb9yRxy3D4eJ4jJQpU6+gG8r37vUoBhNmDsf6n10knTrYMqeDGccUpHwWRq90g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyPAeo1ocRpm6TuMFLfWZn6brlq7SlOkffv1OiH3ZBkk/gJc+D
	OxlH3Eb934VePhg4Uiu+pPdG9BkOYeaaxvtvG24yAMDW/QooI6SMbgRx4fg0TDo90r55ePLoM9o
	qbgQrFKlEePefTPogeR+hR5MKmp3aaUKK0YQ5+Al799LTKFZpTPQc2Dg=
X-Google-Smtp-Source: AGHT+IHxzMjnKXExBQMo37LZAfLa9UGGqoFvwxTlkRXXoCuftgsmlE97ewepOgJj0J0+Qbf4H4BwFNR/PH6YXej0l/nHtWIA/xaq
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a63:b0:3a8:1195:f1f9 with SMTP id
 e9e14a558f8ab-3c2d2564124mr539801975ab.6.1736086382906; Sun, 05 Jan 2025
 06:13:02 -0800 (PST)
Date: Sun, 05 Jan 2025 06:13:02 -0800
In-Reply-To: <bb2cb6bd-d2ec-4378-bf9d-339571f7c53a@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677a936e.050a0220.3b53b0.005a.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in __io_submit_flush_completions
From: syzbot <syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com
Tested-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com

Tested on:

commit:         77c096ca io_uring: silence false positive warnings
git tree:       https://github.com/isilence/linux.git syz/get-cqe-lockdep
console output: https://syzkaller.appspot.com/x/log.txt?x=15d86edf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c078001e66e4a17e
dashboard link: https://syzkaller.appspot.com/bug?extid=1bcb75613069ad4957fc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.


Return-Path: <io-uring+bounces-8641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F201B00EC4
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 00:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C5B01C2519F
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 22:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B66829993F;
	Thu, 10 Jul 2025 22:38:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C8C4C97
	for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 22:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752187084; cv=none; b=SFKfZXP3phyKukLsoltt3ToxQvA0XP4eI0lOX9I0SdSJokblYACMb1BLS5IpXvK6RYjYSgMW1qw6iAZ/dlE4JdWdmlCJ+H6z/KOs/R8lmA8pITWKIlX1c6ijP9PXdu56wcNGYe8chWpCAKD0G0hrsbMnc/Do1saLR6Zbl01Npdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752187084; c=relaxed/simple;
	bh=vv+yCUcoaHxQ8BBe5s/3RR+FRvvf+feqcFxvt9Jq2+w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=h4lVUUJ3C3L7PfKdXMmXbjKmsyqOmaFfwlJi5HF2lz2cKTeDcdTcqdSYnBL5puN/hC3zuXyhN9eMLEyy9cJoc5UohoiBY7RS7HZUCYph3N82KSEx0HHKMmE6A5V6PvioPWoTjEZOD6viWaNYeWs16JR6eZyi9hKx0cReCLj/Fcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3de3b5b7703so9671585ab.1
        for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 15:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752187082; x=1752791882;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aj29vt+eYforRhHdEWSraObRQ2gLQ7p0Ps1ACKxNtZg=;
        b=cLqNf4/JIWXw2NnjYdVyfUC19x274mRQD+w+0AIpgvCpxUCxdQanPAuyBfxqXdM4n4
         LmfdVcGeP48OjFHkexKqELFjaOhBsxUBVws7+KakNnMeGLu6I49nbowXT3uuCQheSt1r
         tjL5OA30ixZb1BwHPHEzIl/f60AdFGCYnlS/b8+RK7uGitsFRXl13yP9Yeau900Mj5lw
         X5wADRrIaxJa5Nl2vVdPpqUWLQo5ZC6l+GxI9j/BwRxTqlVHzlYVPHfE2Dj6h5ENUn4O
         BVfllYtl7u/D3v/Eherjnz7kmSVylZUnu6b7ZRpr0XCIaWMRFS2rCtxxbMp1PApZldyT
         GSZA==
X-Forwarded-Encrypted: i=1; AJvYcCVHVfd2sCPfN/67yNBX28zSH2ROFEhSlSwutSgOwyKqlsDqqxTO5zQ6eZTY+7hqbzO+dBng099S0g==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmo4kcP4zI04wRRLS1fZmD8aQvpMC3x1cARmT7X3DU48+4oK6V
	bKHc/QxOB5BYFqsN3Fs5cPC7gZmt4U+ktB6DgHNMPbFzTL2Il66/mKa4tHm4yxElCr6j1kYLCZj
	uOaVvFOuDW+ggH6rLM9TF/hYh/t9fL9tNQk84/OsJCh/zwTxE9q5x6ueY4Ak=
X-Google-Smtp-Source: AGHT+IEd8YEDQvvTzY8O4EJBGgqJDoflCn1y+Enx80RqfvrXqsj0OdIZPl1lEg44ay6PjOPxD3HyQDgDAfPqWV1XkKq1VOVQa7KF
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2304:b0:3df:4024:9402 with SMTP id
 e9e14a558f8ab-3e25421b24dmr9038405ab.8.1752187082146; Thu, 10 Jul 2025
 15:38:02 -0700 (PDT)
Date: Thu, 10 Jul 2025 15:38:02 -0700
In-Reply-To: <bf1b2aa4-9ce3-4ad5-b0d1-fa379b96c9a3@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687040ca.a00a0220.26a83e.0026.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in vfs_coredump
From: syzbot <syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com
Tested-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com

Tested on:

commit:         5f9df768 Merge branch 'mm-everything' of git://git.ker..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git --
console output: https://syzkaller.appspot.com/x/log.txt?x=137fc0f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=44a6ca1881a12208
dashboard link: https://syzkaller.appspot.com/bug?extid=c29db0c6705a06cb65f2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.


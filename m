Return-Path: <io-uring+bounces-8907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6234B1E8F2
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 15:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBC211AA4FDF
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 13:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39DB327AC3A;
	Fri,  8 Aug 2025 13:11:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4E27603F
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754658665; cv=none; b=K7NMCgDqiZoaz0lukPOWJOrzHcBvW81J1Rn0qhzJXzPceJLpq9S+ijHzGFAHqV5wngPKQy0yZPCNSCEWzNWj77sP+LYGCpFvI3xN87mBs3yXO1mawdpHylkpd5E9RyQoofR4/yALEwKi2tpOpZxVZNfeHulPvinLJpTQ4cM91/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754658665; c=relaxed/simple;
	bh=ZE0SEK60mtbsliMPxlAG8SnYeqvfSaBX40GSK/AanqU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cCs+oSmfcPDFLjU4Sr6co7raoVy4XnC8PBIXSWT8z1PMUnB/Pil2zUA41dsaISPXhu5NfpDTog7pxg25uOi6INvUev91dIAj7nE9raS9KmGiprUZ/eMyvCPxZ5Yr0TUfvfrp3bB5/mzVxtkNKHUMoBhR3iI4Zpz1hkFxdR1m2Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-881814e7585so472400839f.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 06:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754658663; x=1755263463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhZx7zENkxQe5AbQJ77xeuD0BdDOYHSOItjPHuT1JPU=;
        b=R/NUSzKvAs/GpbLF02KxfpNjjtAtLq+4xGjp/9EBDB6SqlIUXXkDrHgzDF6vrcdDHp
         2oKyvV/S2VYg+gvCaopud57CjYvB/OwqaPksdpz/QFeV2L6E9MDJ4bDPXevQlQSakMDv
         nVVRQ6FQAvTa++sbdHaG6ng34+NE7e8j8YwyhV6jky5uZFaH2CG1LR7laGixkIaNQFBc
         sjkWrNPNGf4e18xHux3JXqR0HkRsEmp/xzFrkYJCa4dtEa0JK5AriaZeUKiVWqGqzFFX
         ZEkvIbFVmAKZubag6XZdrAEuNi1XJvKofp1bC8WiH+bXLliR8YxKbZ2NY5IUmlB8ULQA
         Efpg==
X-Forwarded-Encrypted: i=1; AJvYcCWE74vXU8rq3uILEUVqiBhY2ntqfzYQtcU+iZzWqVYD1Uj17M9slP6UlCVCZ/VrtAdVy92HiyPbEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrJLHAujWG9LQKa02xLGhGH+4i9vl9kVljezlPmGhgEcV7JlLU
	zt4T7LMW9dkn5kiSSTvW75gO7izMKvHpoEfuRoiFDrPjaG279qErCO/XoeLdZagqSpKFtwXk3PB
	qX1hUt3TgxXDL47QI5iW0zSFS/27g/THfXJYW7QXoHsfcJtOc5DAze9zihxM=
X-Google-Smtp-Source: AGHT+IFR/kg22snptckHcHi3WJ8VCMVs1g8tIWPbiYjf3ET+JTUIO003DYxMDbgSxq247KZH0Wmwh+F3efDO6l8FzFletuhXu46W
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:60c6:b0:879:c9db:cbf0 with SMTP id
 ca18e2360f4ac-883f11b474dmr526446839f.2.1754658662655; Fri, 08 Aug 2025
 06:11:02 -0700 (PDT)
Date: Fri, 08 Aug 2025 06:11:02 -0700
In-Reply-To: <05795247-a9c4-40ba-b213-c2b4370f86a7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6895f766.050a0220.7f033.0064.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
From: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+23727438116feb13df15@syzkaller.appspotmail.com
Tested-by: syzbot+23727438116feb13df15@syzkaller.appspotmail.com

Tested on:

commit:         37816488 Merge tag 'net-6.17-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ca61a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=251464a47fe663c3
dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16e13ea2580000

Note: testing is done by a robot and is best-effort only.


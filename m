Return-Path: <io-uring+bounces-5640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 892E09FEBA0
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 00:19:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DA3F161FC2
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 23:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D2619ADA6;
	Mon, 30 Dec 2024 23:19:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C3194080
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 23:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735600746; cv=none; b=Es9qPbZGJ4opGJfpVbLv2x3m91KG2IiYkQEtJ+w4pwhdlKTvXkppqQLxk+hmbZiyLd5AdCms8G2gtfU2Pfm+AqjPPbT2KHSu+Svta2hR3tYTdD9xnbzSxwmPGRwWGqfhyUJ+2Mki2it6Apo4hMlGKnx02ZWWPnWG6bWJDddQ6C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735600746; c=relaxed/simple;
	bh=vRI7372Q5Kne3rGvehqYNIqwTqXK973H3xAdZnjjOb4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AuLDDPGeSGZmG2IcRBaGJB2q11fJAuk8Npb3Y8MynDGJF/g7Yy8TQpDczPWbW7+q3UYPphFSQD2fxFBIxwhlVA/CdbCYIvt1ps+ljRJROBP2//cMNcg4MYkNHtMxcVFnbQihPRFTx5Pl0sIgraSMajOHi9MbFSYoNKAlPoBBl8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9cefa1969so94787935ab.1
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 15:19:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735600743; x=1736205543;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4gh6TBXzpYDMGAqsRtjB7Y9Y365UNBzUT6dDnA4j+w=;
        b=eOVZoCjq4vEIQG4X0p6H04MoZheglMJrcnAmrJKqZwmy88HJ1JFcnGSKQ7hDGLjacN
         q97ZnL8rByhkTKRG/owFGReG/omdno2RkOQhdxBgSprQeeRab4K7QNeF++Hme4Lx0stn
         MWZKVUOWiFt+P825ffjRnXdVT3adUzpaT5IUGIoucp0Wdt5+TRnATXiC2XgOARz3l8Bt
         XZraGOxE+RTEueKq/qZF6VMl8xpp7gVx//p3DAbzTbNOfnibWidEGIb9L9pLtcLHV3pW
         ClfWlLo8HJHVMTZjn8uLRyBm9WaHAGb4VJll295jH2cTm6kJgzzcL2D7oxeebC8lCMK+
         032w==
X-Forwarded-Encrypted: i=1; AJvYcCX41Q6CnEgzGjtGYryBhbRTJ2SoxwJHWBIHrlVUETir2JxRET2lWqWKCnEF7ZhK8MK0Mo2zc5GMjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy3fjBX34x1J1PIqPOBiaoWDVCFPa6STvHNKL6HEyzvJevmnRv
	xnFwLVj6gEYfDNP9pZ/YOG8d6vvCcOSqsEiTF4zJQMLs8syewpXDjvPRg2LYJDK+yKLgm6mUtGT
	4ukSYmOCwWfz7azsIdovIU6qT2bFhTB2Sq0bgJ2HYv+TWnV/wffHTruU=
X-Google-Smtp-Source: AGHT+IEIAhjemoYtlUG/oMqIutmApQFIGArxjoU2/F2Ad7OHjg5+NYtNHUAvUX5Fh11pIhQeq4advX2MGG6fdBpqlArQc2sDIczi
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3687:b0:3a7:6d14:cc29 with SMTP id
 e9e14a558f8ab-3c2d18b43aamr342242215ab.1.1735600743208; Mon, 30 Dec 2024
 15:19:03 -0800 (PST)
Date: Mon, 30 Dec 2024 15:19:03 -0800
In-Reply-To: <616118a2-e440-45c6-a548-a1cdb1b586f2@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67732a67.050a0220.2f3838.04d0.GAE@google.com>
Subject: Re: [syzbot] [fs?] [io-uring?] WARNING: locking bug in eventfd_signal_mask
From: syzbot <syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bigeasy@linutronix.de, 
	brauner@kernel.org, clrkwllms@kernel.org, io-uring@vger.kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, rostedt@goodmis.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com
Tested-by: syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com

Tested on:

commit:         a9c83a0a io_uring/timeout: flush timeouts outside of t..
git tree:       git://git.kernel.dk/linux io_uring-6.13
console output: https://syzkaller.appspot.com/x/log.txt?x=1566eaf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50c7a61469ce77e7
dashboard link: https://syzkaller.appspot.com/bug?extid=b1fc199a40b65d601b65
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.


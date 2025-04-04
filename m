Return-Path: <io-uring+bounces-7412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C594A7C672
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 00:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 220BA1B60B78
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 22:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2337D1A8404;
	Fri,  4 Apr 2025 22:54:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EEF1A4F2D
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807244; cv=none; b=W95gskfgut29Xf8qeXmAfWGPH8B9k9U0Yf/GhDo5VfoEbYd/3jnIoDDXP37VP17zyB/gyzDYewBJ9yToxyuTC9Yx2pyoBSItCDGHpkT7AXLIuxF8CtaaTUw11UlNyjbFMTWT7FlP+MuNBRPzG2YkfUPBmEWWRhtREEYj3Dt3Fy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807244; c=relaxed/simple;
	bh=CCboKF0E0pOUDrcALP+xPG44ezRrXKgwlgnWWox3uZE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m4Wrq/5Nzjqu91sroR/SS07kWary1PZHEu8TAcejHq9n/nkpwzF3Bo0+9igh6zdvzWtxe3TNtS717ThdXVgejgarsc4zYySjWLS6Dmpirm2qzqpsqpVqDKWFBotnooGMTWKU+uzO4IWeTy79u/T5lkIiJcO/MebFeHBan75rb3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85c552b10b9so309255739f.1
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 15:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743807241; x=1744412041;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BEWRvuZ+p60fVNjWGYQzVIHkSUDv98jwFOKe49syq3k=;
        b=TCwBHj2SIIdh/MCF1SAOEBe6+It0AqFhdw+4th0Weo8TQIUdt+TWX3tzvrq2shdB8N
         +fskwiBXldPJ57ehvnHhiZLxfhlnjJ2Tw2srectj3ucAZ0FczHOyLHJVJ9f7w4H9Djhw
         Yjy0KnZ/9u4fhaDbg3ssrA1m94GtoKE/zUXpTW2os5bSELe7PTttbH1ljppfwL65Pzw3
         Ws2Ck0HgDf1WHJTzL7Keicc2mpkF50IjzNeXsl3jmWr1fAypeypKJ4IhRgbS371YCcBE
         bYqzP6tMYzlagW6VhnWP/reWw+xiyT7N8fTLnGhemLChDzEKwUNexziH+RuQoCG4kONJ
         z+mA==
X-Forwarded-Encrypted: i=1; AJvYcCWXts94aukz0LRDTdH3xC/ryTuh6/LJVJrTsmZcLwMY/opLEC2Dw71rMXUKeyew9MOMXPA3ACT3sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPC2WEOatSaSihvjkMym0d7N3jmoBngOUHPUmX2e7Qey4j8qDd
	GabgiM5hcapJsQp3zsPayZfBuOofky2ZwpskqSVCBdmDaAaFY6zNp6JY1oqt2i74/0NEVPQb1DQ
	zWE1TCSfKFyRND/Ukp5UKML5xL1dUqlHAY1j+kEdJIEo4fMjHHd9N9UU=
X-Google-Smtp-Source: AGHT+IFamuhyyN733T8LzkJlkNQKtpHf+l7lPROYrZ0KNuXw9tziMkAnJXM1Gpc5xEhMYY6926lIrdIRyJt20mn2V2ws3WsU60Yr
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2198:b0:3d3:dcc4:a58e with SMTP id
 e9e14a558f8ab-3d6e531f3e2mr54965625ab.8.1743807241675; Fri, 04 Apr 2025
 15:54:01 -0700 (PDT)
Date: Fri, 04 Apr 2025 15:54:01 -0700
In-Reply-To: <7472b072-9c08-4e5a-8f16-8a56647ebc9a@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f06309.050a0220.0a13.0226.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         d1005530 io_uring/kbuf: conditional schedule on buffer..
git tree:       git://git.kernel.dk/linux.git io_uring-6.15
console output: https://syzkaller.appspot.com/x/log.txt?x=14566fb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcca8bc6e23acb2
dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.


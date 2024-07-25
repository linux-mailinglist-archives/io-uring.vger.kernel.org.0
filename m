Return-Path: <io-uring+bounces-2584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BC293C7AE
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 19:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01191C218AF
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 17:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743CF19D8B5;
	Thu, 25 Jul 2024 17:32:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838751CD13
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721928726; cv=none; b=XzC1DFGcB7N/5Hj4pqR+CZCL+5LBEC6tITA5ak4gHWXOQ5ix/koDWxWyLGX9UNbrnRW35jBa07oby7kJrbvOBQvTcGRomRHiOn9eLIZ/+KBMu1WWf5X9BgaYuDefzycCId91T5XacxddBFSZxfd4VXrWK3GGHUDKiIUrttJox80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721928726; c=relaxed/simple;
	bh=onjRvS+axWe8Q4FDhAZ0mLsXnu4JnCZDDvya23Fdmfo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NgsSoMV4pVOrdakjW0KlYahU5EemA8m/cIMH7w2Cpty8g4fcBoNqeCB/f147Bd+W0ij4RjHMesnM37cxssZ1uAc+LVSF5UA1BuoncK8aFZJOhofBbuxJDhj4YMXwbGel5poT0ExMKuE0ApGpoMXPzxGEXg0oE7Fz3dwQ8L8E7oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7f66b3d69a8so49885139f.2
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 10:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721928723; x=1722533523;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yInUmJZ2N1yq4ZyQvECJY6v59tbe4OHDKEmU4VskWGc=;
        b=dMRaCKCYFaqBXwt2EapQd8YZCFUYLrL2jOOE6dtVrd6zptREYxXqf6tUCehZCm4HR1
         5ElWON7fGR/+F4n3Y5x4G404t+4nvJTFqqYZsrxHfzJkOMLLIW3ibLLyAeHfsMSOrhtm
         QjDFqCF0qmlCnjHXyXUoJbnCD1vq5flQQkRmJ3mttmJig+VEiXATYki6oLjooREhD/+x
         2MJt4wkmN118r2z1pkbmoOvk7sSdwIoDDCHlAqB0/36uE0PyCOGMRZhCEuBmgGgQUQEl
         jAaQS10jlMAaPMvbDpnNGwCrhyHwG8skfeZYQ9/MIRQlDsH2PpxCs40TYQG/+palBnLy
         f/FA==
X-Forwarded-Encrypted: i=1; AJvYcCWMre1IVAJ59wvjlKe6DgZTvij13W2BhpChA77MLazZw3IeiXpUD/it+MWu7S9vAq6OrkJVrUPdQkNpxIt0ZEFFmXrOWIv+Mec=
X-Gm-Message-State: AOJu0YyZz8p14idJ780oh3m4miwJEG6HdfwMo9lyWzcqkS9uX9Z7f+d4
	l4a+kFnStpNpQVK6V2sZomNQ2Gtx2DQzh+3ZbbUAsWvqaFTYV/BizY8j+21X/sr4e3x/I0bSACo
	oHVEsPIUMg9GhQxuBVFnA+lj94ksR3d0XoMNKiEZQB6a2lXx2RC0X0Xs=
X-Google-Smtp-Source: AGHT+IEZMQleCE7wlx5bJHfXzkZuvMlL5wDNUObSSqLZA3kjVvIMzHAlAX10J/+9pI1+SFC0nMzEqu5S71REENSCp1jQ5+9CdMS6
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4120:b0:4c0:9a3e:c24d with SMTP id
 8926c6da1cb9f-4c29b6da7acmr195043173.0.1721928723594; Thu, 25 Jul 2024
 10:32:03 -0700 (PDT)
Date: Thu, 25 Jul 2024 10:32:03 -0700
In-Reply-To: <b8783e34-1011-4eae-86cc-9ba2b310863d@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e60a6b061e15c55b@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_task_work_add_remote
From: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
Tested-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com

Tested on:

commit:         0db4618e io_uring/msg_ring: fix uninitialized use of t..
git tree:       git://git.kernel.dk/linux io_uring-6.11
console output: https://syzkaller.appspot.com/x/log.txt?x=11879ae3980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f80e9475fcd20eb6
dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.


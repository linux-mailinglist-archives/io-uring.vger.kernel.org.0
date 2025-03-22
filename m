Return-Path: <io-uring+bounces-7201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 486BBA6CA88
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 15:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA3D882F24
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 14:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1B522155E;
	Sat, 22 Mar 2025 14:21:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCE01F4CAF
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742653267; cv=none; b=WmyRvExj3KayQKWtJq8lSXQsb4XBWRHJCQulERoRJJbysNQIJl2xdcVuUTEgH8sI0CuYuSb+OCso8I0ex9id1udht5yXVzQ9UFc4AVEuqV0sZxGiT3eQUOSWLZWhlHY0p3h20mmC+eTsq0SbCrbkr22Rq11guFIl4QEiFpNJv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742653267; c=relaxed/simple;
	bh=GV5ScpaW94JpIvrpJFW1esYd0UofIMH6efGT6ajycpU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QkZrvT206x/cDsFVi9bgoIiTViQurMQRnTpNa9gBfsMmMFGDgO1vMrjT2r1tIk0fl6PxKaRGy0JIGHWjxBOMpmv2kr/kll0VEXXH3Syecqb+fEelAp/mNAEqkMVj3ldoMeQEfOIKL5TGIGQFEHTNvTL2pmDVgCkcjQte7CNWjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d434c328dbso53502675ab.3
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 07:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742653264; x=1743258064;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JK5ZXI6vbQAIZxy13h5qPA6KYskAYkIUEuDZySyhb0A=;
        b=AO7ITsknUvWUYpjYA7FieXsHPGb/DOixt0Q3VKCr0AeuhelUBaY4DWSC5JBXzqZOAt
         r0KDcrhZoJV+HpfMOYVQOrx11P5fWqLxXUm9PxYDDK3rQkUOzWLBus5srJ+ruQYp5iNn
         JJqGtMUU0KRSnFRJrswtIrTxg+DRcfP56kRvUitUIkHAgjcdgHr9eHHxzvzGe63ALPL5
         AB1jhdYXEJ6ENFvoMt+Iwo78YwH9/xZQPMVe5qF3NNBBDmZ5BoJgNeE0cH7eLbSQgvYm
         3sx0ch4oB3+qI3nnyZpZUQuEL0XvQ6afXTt42zKupNvOeE7AiYj8iT/bVy1haUY+X+zB
         esEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSERZGw04ccb8mVS3HfGHcftIpUK6EKF7VMWWihe/adOVqvABsJygEHJTboy1ByOQMMoQyBddCgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YySy/30luckkOpMl/h3cpsRVtRpYF8an/QA07f+TTyapTKdxCTn
	abQcEV/c9zSpw9NJYeJlLzPk5EsXZiaTlvTk3R8B0RwKJXEgZ3x/18YRgTAdywiCXEKVVE5jIK6
	1qmEhOQudbsEz+9CmJIk/xAryGFLO+uiOxY3T6GqkJyWijpAx5WEeDkA=
X-Google-Smtp-Source: AGHT+IGCFPzSPPNaIKguvkQ1WT+OSMolQs7AmmRdajAqaldrzDzcQ1lTxjFWUpRhGeR0zPfdvEhekvGPfOClbBndJbI8tYg3c2c8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c21:b0:3d0:237e:c29c with SMTP id
 e9e14a558f8ab-3d59615d8bdmr91271625ab.12.1742653264601; Sat, 22 Mar 2025
 07:21:04 -0700 (PDT)
Date: Sat, 22 Mar 2025 07:21:04 -0700
In-Reply-To: <67de616f.050a0220.31a16b.002b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67dec750.050a0220.31a16b.003e.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING: refcount bug in io_send_zc_cleanup (2)
From: syzbot <syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit cc34d8330e036b6bffa88db9ea537bae6b03948f
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Mar 20 18:25:12 2025 +0000

    io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15ef043f980000
start commit:   d07de43e3f05 Merge tag 'io_uring-6.14-20250321' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17ef043f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13ef043f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=620facf12ff15d10
dashboard link: https://syzkaller.appspot.com/bug?extid=cf285a028ffba71b2ef5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16be1c4c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12223004580000

Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Fixes: cc34d8330e03 ("io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


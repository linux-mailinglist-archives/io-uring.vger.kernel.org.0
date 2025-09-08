Return-Path: <io-uring+bounces-9635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1511B48342
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 06:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C311899823
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 04:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463B421D5AF;
	Mon,  8 Sep 2025 04:30:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ABD207A09
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 04:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757305805; cv=none; b=u9CrI1153P3Ek4TALXOoavbD6Lid2yn5OeB6JkkiJkSAEcqCesr0jgPwol4aOM+1x4hp3N93X7KREMrW6FrDrvVUckyq2kmNYSuMlhEnLlOPFxRrbbyWQxHXiMgRQwFeYJQJm9LOst46Tl6gZq0OYqWo/ouKBoRUmrkdZ6JTKvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757305805; c=relaxed/simple;
	bh=4zkgAfJ47wYvARL/HU5hwdAls1pAwTkHezvtoue9GJc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SGa2aFlP17uqA0LDv6YRprmH7HwGMaABRPuRUVDx8uJsR3znNDVduh6gE7G+a+5jAbF0+9OU6NT7aNcZoEb8JhCZjvKIW4kHUM5wHa6PlI1mYKoByHOPEp4LVksJgqXBddRZQtbsjqJm+7dC7TNIIDQ/pNSxdksDucLTxADUVyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ee1d164774so72822365ab.1
        for <io-uring@vger.kernel.org>; Sun, 07 Sep 2025 21:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757305803; x=1757910603;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iKg/g/XoJErvdToiWX/Q27vZTqTfinN/J6yC7CugODI=;
        b=MQt/i2QYOgMt+9zG6l3tu3u2u57OrlqFTA1tAiNC5sDr7oJbI4IrsiJAWJyzRWT+mz
         zKSo3XBgYb1FNR6vFeWem64bxOK/K5KulmKLTAgAuoEa7HP6hJ9sYfy/LWc54YySjQfc
         gTxe0Y6Ede519b45NMsJoK0ynxVf8vDZ0dLMU192FfWFV2RLzyiPZqFggZEXlGHCW3Ov
         xIW2Gfe0toXzNpfWYelVRO1DRgndW+JVfQ7EbXqcgQ8ZlYGEKMBlkIs4yCVZTl2AOZpr
         IxajE22yhrXGu8Qa/m4pKC0iNPde86heePe6PKVD/AdM2fjvu67T7h5t7G0Qkx2paY5I
         6Nmw==
X-Forwarded-Encrypted: i=1; AJvYcCWjEazYb9Cc4YOhwM2dOnBRX30+aX476X5azvgkeKETQCn59Uhbd4YM45EDlfbJ67fYvZr480iqKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YylU7TWhO9VH0Iivd/nX1lGGQrq7pgHZbRCOjbw2CuFDDMoHgMG
	ejhKWiBLEnbThqkf5FZVqWWPN0GnsDTLY3/2iUrCJWvyFOm+IdfxshdRM3iZqtb+hv9Z2kyy0f9
	9T+yjug9CuDLnIIOz9egBQRlnYC8DHKr+Y3RdFJqCBecE0LfZM6+R7PKlDRk=
X-Google-Smtp-Source: AGHT+IGPKdo6XGzXWRxs8GK3AjURBkNRBzmNdwt1tAD0uRVr1AmOZCv3S4NUzRIjrDq90pmE/Ak2fuHxXW+LtPKeKZplQof/1f3p
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd88:0:b0:3f3:cd20:d7e4 with SMTP id
 e9e14a558f8ab-3fdfaf2e158mr94576065ab.1.1757305802594; Sun, 07 Sep 2025
 21:30:02 -0700 (PDT)
Date: Sun, 07 Sep 2025 21:30:02 -0700
In-Reply-To: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68be5bca.050a0220.192772.0831.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register
From: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com, 
	io-uring@vger.kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit da6b34293ff8dbb78f8b9278c9a492925bbf1f87
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Sep 1 15:03:40 2025 +0000

    mm/gup: remove record_subpages()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1240f962580000
start commit:   4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1140f962580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1640f962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a0e312580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101e3e62580000

Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Fixes: da6b34293ff8 ("mm/gup: remove record_subpages()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


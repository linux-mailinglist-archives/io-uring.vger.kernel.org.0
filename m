Return-Path: <io-uring+bounces-5239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 908489E457C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5546E165BC2
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA951F03E4;
	Wed,  4 Dec 2024 20:18:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597071F03C8
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733343485; cv=none; b=BLk+hENuciVuR03+sjDxjZ3aeoylApKuiLkPdu01HoDZCLf3TrborGFdd4k9krbb8l3vrA5reucL5fyPEuIkyIZRwtOYZrSs2Kk1ltsDf8uq6HlSaHHHyZCVrEOHjT10ReZZIALa4JrvRCw/Ge50uY3rqMqb3/yPRWEagUbd1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733343485; c=relaxed/simple;
	bh=NNeyfjKy8ZGP7PYgviKBfqCS/QI22FJoxQGC4XnQdu0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m9D9rCzQ1NH3Q4uuYGK6PlujMoI8arXbznqp2W2aXdzSKgnso6XuG2Lou0CtZLYdrmLWqiu/V2RH7GKASpuK9zQvK75Db+QWeXkUA1CvG+Xs8KzJlWb9gCqFssUynDwabAo5Ja9FJ9Iz/TKt94bGdcBzUWEvGVgH0y4Xv9HuLHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a76690f813so998225ab.2
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 12:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733343483; x=1733948283;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvYz/F16WGhbDx4cNvT6lI6TdEMFQnM9OQcYijyTMAI=;
        b=Y4HHql15STBbG6COGr64K/vxueQ7fVYfXHbWX3mE3ndcsofhgxJFqm9NnkPjfL3VGh
         D3HYvL2AzCCZ6KaHmmlBcDL4Ph7Kpo6a+CEZZ0MnNfEjNSXaObYtOg75FCgwf5pyhvJY
         P/5GbC9YzBd3MoH/Nl1ZIqgQkCg3iz2uj9Dkcnmoh9qZbNvaNj/dxmiz3CVsK/lbK3Pw
         plXYSq3MR4AS8QdexBYjd3ypDkGcxZrGL4+rOVdSnnucN3cuVc0nziZqhXtB/9coB3k/
         w4pTeeKZil17NUtTBg5qXVDEA8BdGvP5oNdRfajlHd3X+huHad0tVTORlmSP3AnrU7c+
         l6eQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+lct+l9uHrWm4z+Q9KlBBbRBswBW7u9d1ks+A3np9EMufvG/2RSxZXe/v3zDBQjemKBaE3xHQ7g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg675CvzlwUhL2sOlMsiGnu92W+3PCmLfWIoLneo9n+i0m/kbM
	/IT8j6EMYv6J71MEjO3zL2Um5mBNjTMQkUFm9NpSEcayeEFxIlsQrL0sNsj/cfR8uyvghBoo2z1
	MyjFfajNukho87hUAaTN7mNmWz7cjks5F3X81ILwBNuIVvvP64hcAt9I=
X-Google-Smtp-Source: AGHT+IEhH0cr5PTn2QWjKnJaTq5+Nve/ysWwfEdZrM2AyUkDS34xX+n3rmiLxI7NpJNwWzFqTBe2/YDMHcnDgWJGHKQ6KXm6TTL+
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2d:b0:3a7:c5cb:8bf3 with SMTP id
 e9e14a558f8ab-3a7f9a3ba65mr102881145ab.9.1733343483592; Wed, 04 Dec 2024
 12:18:03 -0800 (PST)
Date: Wed, 04 Dec 2024 12:18:03 -0800
In-Reply-To: <67505f88.050a0220.17bd51.0069.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6750b8fb.050a0220.17bd51.0074.GAE@google.com>
Subject: Re: [syzbot] [mm] KASAN: null-ptr-deref Write in sys_io_uring_register
From: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, tamird@gmail.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d2e88c71bdb07f1e5ccffbcc80d747ccd6144b75
Author: Tamir Duberstein <tamird@gmail.com>
Date:   Tue Nov 12 19:25:37 2024 +0000

    xarray: extract helper from __xa_{insert,cmpxchg}

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17435fc0580000
start commit:   c245a7a79602 Add linux-next specific files for 20241203
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14c35fc0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c35fc0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af3fe1d01b9e7b7
dashboard link: https://syzkaller.appspot.com/bug?extid=092bbab7da235a02a03a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a448df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cca330580000

Reported-by: syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com
Fixes: d2e88c71bdb0 ("xarray: extract helper from __xa_{insert,cmpxchg}")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


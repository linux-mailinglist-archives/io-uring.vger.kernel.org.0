Return-Path: <io-uring+bounces-4360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1049BA48A
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 09:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF69A281815
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 08:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF62515B13D;
	Sun,  3 Nov 2024 08:00:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D437015B0E4
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 08:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730620806; cv=none; b=h20xi6fNKUwlsw0LOXD6twSLL7uZ1TuqElAYvtls8c4s8/JqkozsG/GNQ2x7P/W+UlNmymTNWlIK7cFTeUtEWebRqiItImMGMftjJRvRije3OO5354LVlkonOfIRPJts2Y/LfD3Van8eJhupnbql6V0qgXEccEH/j0d5nA80TTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730620806; c=relaxed/simple;
	bh=Lqsft7adr0COfx9QvP8i+mZOqTv8xbTJfU1ig+o6UuE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=re636BxflAPx2tqG/nZuq2J7wLQBwE2GngRPEn0KUGUjSZ7oSTZsnq3tdbeeObjsrH6o8w85qjeE6GbnJDGHoRk+C0pWFDHRv0ACvtQqbpyfo/MVeyr4fFBx8yeoG7VW5qoPzmoicklskmjOM6c7HFJgkRyDT9OIuB3rUb5GO/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3b2aee1a3so37054845ab.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 01:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730620804; x=1731225604;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmP+HGQUwPW0ypY8esrOjnmsI7a99i7CTGI0scCwH0I=;
        b=Lt+i9OTSe/jrO4sDJdMJngjYU6Dd1XqsksilOOTwwTJKcgc+kk0wTW0So1cQBS8PQF
         ZE/gFqF1DEkgaD1zAuD1bPyOoflCEq4bjzp9lKL4U0tuMyBgD5AB8ySqw5xtij8sm2jY
         coCij3eYBLtTkmKHaTcjncavg1gFWJd0c2jg61uJY1FrjSuzkScHgNEcF8XARDp4/OTx
         PjBoue9Ra1iP8az9R6Dik2Nag7uHfy3+7wLPGpOYSZrdTAlls0dXp1ArSnrPSQpHiX+9
         rLqfak90FolmgyTrkcg1eIdMbU3xg+2ywNlvpHKFHH+LObkrRxWsyU+woUUndP2decRf
         /hrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzIzJtsmHhMdqxE5zPguwwMS0V3bRaGLIvVy/6hmAwTLsjosh9AEqdh0noJw0IkKPClyS82tC6Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YygL8tlgn59x/2jZPySjCHkc2eXYJagxTknUXLxiH563vkeyKLt
	eXq/mwINbTA9e32FVRXX7O5DzSjhlzIKyYMNdXbKOlGyFQmVsZcLNotnvCIlXDUYvwqU3Ruf3nT
	2xYtQF18GISA+jaHQADj3XCBRVnZxUkifIrdNeN3bU7pW/cmPre55lz4=
X-Google-Smtp-Source: AGHT+IH0buP0zXdG32JSHCLOF/6Mgi+ie9pEBHNGOEtrKdJwcvzsE9Cjn15xg0v/QLD/Co46kwwx0BCzpHV46XxLmKQBIQE9CbBB
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d98c:0:b0:3a6:bf1a:17d2 with SMTP id
 e9e14a558f8ab-3a6bf1a1a5emr27714515ab.1.1730620803983; Sun, 03 Nov 2024
 01:00:03 -0700 (PDT)
Date: Sun, 03 Nov 2024 01:00:03 -0700
In-Reply-To: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67272d83.050a0220.35b515.0198.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in io_sqe_buffer_register
From: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 661768085e99aad356ebc77d78ac41fd02eccbe3
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Oct 30 15:51:58 2024 +0000

    io_uring/rsrc: get rid of the empty node and dummy_ubuf

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1586e987980000
start commit:   f9f24ca362a4 Add linux-next specific files for 20241031
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1786e987980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1386e987980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=328572ed4d152be9
dashboard link: https://syzkaller.appspot.com/bug?extid=05c0f12a4d43d656817e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15abc6f7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eb655f980000

Reported-by: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com
Fixes: 661768085e99 ("io_uring/rsrc: get rid of the empty node and dummy_ubuf")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


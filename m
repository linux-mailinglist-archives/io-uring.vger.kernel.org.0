Return-Path: <io-uring+bounces-4341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B231A9B9AB0
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 23:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D5C282050
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 22:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8643C1E47A4;
	Fri,  1 Nov 2024 22:13:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB782140E34
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 22:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730499188; cv=none; b=I5vXdYqEet4Pa3ATO/v0J0J+bSmGarCM1HOSGiiDJb2JqSiKeUditZ1SC4FK8xTuWkFHOw0xA7Ol8ASfiZ69ai8NSHq3uSA9OQ2mfZULIRehFUDZ5lWbMyyIe8bmTmIBJKZG86tRatvDCvISeillmD+1JUDx+kdg9E8yatkF0gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730499188; c=relaxed/simple;
	bh=DXk7Tfz6V+9j+3TwKxH43yAXMkCnANFH0QzoCsbXz8g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jdqWM2FZD4W9eb73IoNMD7MgGLUk6NE5UaqQnpylwjPGU6meJXU6hy9U7Yt1jOyPQ9k46z5GIyCY9YMI4r3im3J/9lJHwecK0OpD8wbQslYx01y7Sy5eQm9TYO9tSk+z64v2BHAqqRu/60edLo1lmpwHXx6AxAX+3QdirC4nMM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a6bce8a678so4289765ab.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 15:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730499186; x=1731103986;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbGkxpLwmpLDwY6C5+KcVqrUr3hsQWtb/ZrSyYB3thQ=;
        b=vO+Sb4YRtIoBWe4YPfG5tG+D114klCPwFi1mfB5oCl642iijo2v8TPUss9CBTrXY8X
         Qd5wuq+7MiQUMBWKH4H/vNPfQ9Qn89uqZjekvhtBMTrpQrWXQhTHKrUYRM0c1kxx1JSq
         c1zttegwM2QEufRoqNK8RKZcHZvffFsz+G8KD5zMa7swSb/c1b29Bo1I1wqvJqg87ZHQ
         LtThiKATqcK1Vx6IU/f5mBzugMeLuqX3gxYQ9oXIh47p1gmUGDRkfhhhMw/+cpmzjWFH
         PIUSPNl+LtHoPoFcIRdJeIDR9LgKtFwBH4uu9e9lsf+5O5EhhWKUii8jsKHCLWqJw8Y7
         jwzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtyBPFHDkdKPYBdPxl2wbmSYNKgAj0+R88QpjiM6h2mJjTDO5SXqJcWYCuiqn2/3VAoAOiPRm8gw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp67eWFeoQufgKVZ65AHvaJxjAkyQu+yhVZ11JpFBjWtCr7i7m
	alcyAmO0pkKPuq/aia7WgfWxdcwCXClFi1J5xdA22QcKGrH9iUyNvF04Q8hhXODIYf7bbDXCKtC
	1W3aklPZU2pBAU4d3LM+UY5t8GXh5phci1nx75ha81SnhcZGZH1cO/NI=
X-Google-Smtp-Source: AGHT+IFvOt29HeE/lLPloslsE9diBs/vNO7oiztlxo8RQHBFFzL07o+uCm4/H83aB7L+lEUCGr0SYQNlZJtkk8qZ4s8yacqI5lKt
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:348c:b0:3a6:bfd1:49a9 with SMTP id
 e9e14a558f8ab-3a6bfd1546emr719465ab.2.1730499186133; Fri, 01 Nov 2024
 15:13:06 -0700 (PDT)
Date: Fri, 01 Nov 2024 15:13:06 -0700
In-Reply-To: <67251dc5.050a0220.529b6.015d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67255272.050a0220.35b515.017b.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (2)
From: syzbot <syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 661768085e99aad356ebc77d78ac41fd02eccbe3
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Oct 30 15:51:58 2024 +0000

    io_uring/rsrc: get rid of the empty node and dummy_ubuf

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17631630580000
start commit:   f9f24ca362a4 Add linux-next specific files for 20241031
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14e31630580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10e31630580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=328572ed4d152be9
dashboard link: https://syzkaller.appspot.com/bug?extid=6cb1e1ecb22a749ef8e8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f92630580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126b655f980000

Reported-by: syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com
Fixes: 661768085e99 ("io_uring/rsrc: get rid of the empty node and dummy_ubuf")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


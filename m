Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D533834CEEE
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 13:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhC2L2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 07:28:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56007 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhC2L2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 07:28:08 -0400
Received: by mail-io1-f69.google.com with SMTP id e15so10582864ioe.22
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 04:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rQvHuQoW7fvtp2Ftp9kpJnXrU1a0vQLohh1FTEc0jDU=;
        b=EjqMjm2YogwZnGfxYQ8yZG8M8ehSWOQUvVb65zdc1hJo7k4klp/i85IQHUpCMMxC6W
         ETz6xCA8axaD+lAXyDamU1axondFw02q2LhqmLhCUGHqLCepjG0b79lrSNQop15o4EyS
         9FUtHrsHTlXBSr4axOBDdYyzaLB336YQdSby7S14HwczudbYVV43GAnV4ZqX/hanmvcN
         ODdhyDq4ce7wrchctSggN1X5/zFGKWFRWShEJnCesbzAHQL/9SbEKxZ35BzeYGqAlBdd
         n4+bN34B3gvusEBmYTc1MNSeyaKBsleeTKTunhEDz1VB8jVgXsrNzS3s6v0RN/ZsYU9t
         zJNQ==
X-Gm-Message-State: AOAM531sAHX1D5xC/TW93j/ckeffLY7xp8q6wKBGDUHTgKqCCFCI0u1x
        rThnLNcU1x78e893gBk0OxDGumAAYzqUQ19QyKxDjVT378mz
X-Google-Smtp-Source: ABdhPJyVGPg1iqr/7NbcMuFQoOzNXIrVaBElCoeGpE0yyT3Q1rRFN8O0BxysKrgcUI8F0NUDr3gsxqYBJV5vkbJE8UoNcZEn92PU
MIME-Version: 1.0
X-Received: by 2002:a05:6638:381c:: with SMTP id i28mr22892618jav.60.1617017285612;
 Mon, 29 Mar 2021 04:28:05 -0700 (PDT)
Date:   Mon, 29 Mar 2021 04:28:05 -0700
In-Reply-To: <000000000000cefea605bea7e8c3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7989c05beab2c46@google.com>
Subject: Re: [syzbot] general protection fault in io_commit_cqring (2)
From:   syzbot <syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com>
To:     alobakin@pm.me, asml.silence@gmail.com, axboe@kernel.dk,
        davem@davemloft.net, gnault@redhat.com, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, kuba@kernel.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit f9d6725bf44a5b9412b5da07e3467100fe2af236
Author: Alexander Lobakin <alobakin@pm.me>
Date:   Sat Feb 13 14:11:50 2021 +0000

    skbuff: use __build_skb_around() in __alloc_skb()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11934b3ad00000
start commit:   81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13934b3ad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15934b3ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=0e905eb8228070c457a0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e0ed06d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1144754ed00000

Reported-by: syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com
Fixes: f9d6725bf44a ("skbuff: use __build_skb_around() in __alloc_skb()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

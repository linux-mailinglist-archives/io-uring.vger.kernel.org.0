Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2360B240AEF
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJQEH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 12:04:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38203 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgHJQEG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 12:04:06 -0400
Received: by mail-io1-f70.google.com with SMTP id e73so1533759iof.5
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 09:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JYunBAF0CO9I6T7+mCBUdOib7oLhSaU/1OgyuSzfO5o=;
        b=JUwYQXSGi89NcqPYhGldduulGcim/pDYlFOQL+jNnoNf+zyO9ZLMRyr7DnLQuryjHW
         zibxdEw30kgyWpD04goqAnVe5iGntUqg88rR8X5l2TBVtU4eRq6kHEAn0z43qcTVY7KD
         bXCXx3a/5jh9HP8iWSSXVczQAIWWQOGF/l4cYMTZe+mgaZTuTQBLvClIHu9NW4z5dxiK
         Z+nqRkVXc3ECQZ4z8O4Q3z2P/0LFJtuUFh3A4rMX29n8VXB/d1vTEO02EVvWbCxOqm9h
         WhrJCtxbFZPgufn/c5DYV6839JR49P3BoYKpgnmsfbWcLrUhW03dop1LvsiUjMao4eV+
         s4cw==
X-Gm-Message-State: AOAM533kLHZn6YodsUyOXmoJuLkpggnVraBkNOfmhyVrSR47LsuR1Y4/
        yLkyMnayLDGIcpLu0wly4dbEpy6Fx+j1dMJqiU+ffeqp60ZV
X-Google-Smtp-Source: ABdhPJypEi0fFwm9FfdzOt9VyXzPHxfS3H30esVuwqWhNkdWmk6zkV7Hh5f843JOksGNlCV4c68qEFWIGDUNpN78VlBwMuSaIAFL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:546:: with SMTP id i6mr2505029ils.143.1597075445337;
 Mon, 10 Aug 2020 09:04:05 -0700 (PDT)
Date:   Mon, 10 Aug 2020 09:04:05 -0700
In-Reply-To: <000000000000391eaf05ac87b74d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099566305ac881a16@google.com>
Subject: Re: INFO: task hung in io_uring_flush
From:   syzbot <syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit f86cd20c9454847a524ddbdcdec32c0380ed7c9b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jan 29 20:46:44 2020 +0000

    io_uring: fix linked command file table usage

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16db4d3a900000
start commit:   9420f1ce Merge tag 'pinctrl-v5.9-1' of git://git.kernel.or..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15db4d3a900000
console output: https://syzkaller.appspot.com/x/log.txt?x=11db4d3a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=72cf85e4237850c8
dashboard link: https://syzkaller.appspot.com/bug?extid=6338dcebf269a590b668
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141dde52900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b196aa900000

Reported-by: syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com
Fixes: f86cd20c9454 ("io_uring: fix linked command file table usage")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

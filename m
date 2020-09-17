Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCDF26D0BD
	for <lists+io-uring@lfdr.de>; Thu, 17 Sep 2020 03:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgIQBmK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 21:42:10 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:33624 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQBmJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 21:42:09 -0400
Received: by mail-io1-f80.google.com with SMTP id l22so640466iol.0
        for <io-uring@vger.kernel.org>; Wed, 16 Sep 2020 18:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/sygnsQByh+EwXCfZR6Do2whKxLsSoSrY8B6J/yTUtY=;
        b=KeNV1IG6SADDtV5cNJV5rKnOiB/eAPuKig8CzyzKogMfPhyfxDLRxzwO/9vR8BzKnV
         3/4WrCwTRQCCILa0o/p4GOuq9TXahSLKy3BnAHtKNMqJ9zZlQ6mmIHfRAjKjwypFU01a
         fHCjUHze47jWhAyBOx5mauglB3ufruYXWAd7CXJyC0DpjguIyJqLRhwI9LZaahJah8XW
         dGpprSETNb8WkWNEVLur8/L9V7An8CihhurJhQJ1mA2gptqyoBLOpR4x7FMBP8zv4pJ7
         JqTbBk5aX3lG8hXzLJtAoR8Abd8dir/GFoBWO/mzl5O42IZHDlnRdQyMv+kRB++a6j0y
         Bt8Q==
X-Gm-Message-State: AOAM533MPVSXzEUi3s6EMb6XIT8XasCnbooKdBillNnD1aCt/EDbOUF8
        2qwax+8B4HNiNBYBgofR6J5EJE/VpeBbUY9AfuuRpHcEs0lV
X-Google-Smtp-Source: ABdhPJxVMb+uOEerKF5s9Gb1ikE6JGsTujv7BAzkTlHPxkcCj/j3pCJ5o+iyWmzehBveVDnI38KnOrlXHDSc07kAYD3TL0Ym9yYi
MIME-Version: 1.0
X-Received: by 2002:a02:6607:: with SMTP id k7mr24979424jac.91.1600306928703;
 Wed, 16 Sep 2020 18:42:08 -0700 (PDT)
Date:   Wed, 16 Sep 2020 18:42:08 -0700
In-Reply-To: <000000000000391eaf05ac87b74d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000004632a05af787ebf@google.com>
Subject: Re: INFO: task hung in io_uring_flush
From:   syzbot <syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sat Sep 5 21:45:14 2020 +0000

    io_uring: fix cancel of deferred reqs with ->files

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=173d9b0d900000
start commit:   9123e3a7 Linux 5.9-rc1
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=6338dcebf269a590b668
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1573f116900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144d3072900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: fix cancel of deferred reqs with ->files

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

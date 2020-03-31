Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C001419952B
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 13:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgCaLOH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 07:14:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:47287 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbgCaLOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 07:14:06 -0400
Received: by mail-il1-f197.google.com with SMTP id a15so14123103ild.14
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2020 04:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VDzK7SMPTn5+1NJ0X+ZSAYeFxCx7H6x/5RbxADZ4d6E=;
        b=Q+pttkS7xGFv3AoMkUclqiHCrqH6exlIWmgRqRkEXWB427U0PiQy99JG80IhR2ZMhx
         CDDFrJOFO1x9f0Jb5OeUbbjcSc4/6XNPWeCmn1QIoDjYli0csohBm4yJKSGxc8eT/nI1
         7xBY2hkw0ya1h7RSUWROGTLwewSblYgIGJKi+o42Q+doy4935kEFV6paOwE3VF6xu3WR
         Xr/TgJ3zZKYmS92VnzFt3BUs8IgFySywcz4NyIPSVNGPddGgHXr3oRFYhLgh8U2DaX20
         6VRO6Ljct7QX9D82FiHsuPqdHhEdQy/D0mX6qLT4XlVNQmj9stJBFdoWMnuAxgwJVNOt
         GyLA==
X-Gm-Message-State: ANhLgQ3zwuG1njFIK84xyUwlJH5yzZ8YkgcNSqNwtJCc4z/vBQWgZ6Oh
        HUInt2vubJVQc9AcvlotDOW6t92SK4ybyOjIGmT5KKSY4y+o
X-Google-Smtp-Source: ADFU+vvsMmk+9AB6KhfsUlDFCpZCCk2oL4klTi/WKgJzTCgTsfyMEXJagR3lLTbUr0mSEfKTgEbpdznTLp2fsXhW7dvop7Eq42Q3
MIME-Version: 1.0
X-Received: by 2002:a5d:950e:: with SMTP id d14mr14672462iom.77.1585653243655;
 Tue, 31 Mar 2020 04:14:03 -0700 (PDT)
Date:   Tue, 31 Mar 2020 04:14:03 -0700
In-Reply-To: <0000000000002efe6505a221d5be@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000533b4505a224aa8b@google.com>
Subject: Re: INFO: trying to register non-static key in io_cqring_ev_posted (2)
From:   syzbot <syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this bug to:

commit b41e98524e424d104aa7851d54fd65820759875a
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Feb 17 16:52:41 2020 +0000

    io_uring: add per-task callback handler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115adadbe00000
start commit:   673b41e0 staging/octeon: fix up merge error
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=135adadbe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=155adadbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acf766c0e3d3f8c6
dashboard link: https://syzkaller.appspot.com/bug?extid=0c3370f235b74b3cfd97
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ac1b9de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10449493e00000

Reported-by: syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com
Fixes: b41e98524e42 ("io_uring: add per-task callback handler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

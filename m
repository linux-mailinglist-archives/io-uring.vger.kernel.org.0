Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE65308353
	for <lists+io-uring@lfdr.de>; Fri, 29 Jan 2021 02:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhA2Biw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 20:38:52 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56333 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhA2Bir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 20:38:47 -0500
Received: by mail-il1-f198.google.com with SMTP id s4so6370981ilv.23
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 17:38:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lm16eCirJMAjlWtITfJJw0jmgaMJxdBabVfxLijbAp0=;
        b=Ls8I/9xuMBLHdVoF3I8ONAN1EmhBtU6/fnDNVeOTZVNza7aabRf647dDtzyfYcz2Dm
         6OAy+HlWooZ0afOwFwnEnncBrZ854+JVxbefHM0zOA4QerPeQlqi2gKy47QeQau5pJK9
         NabBJ+B7c7M4L07smUEcupyq3epsot7zDK09Yip9U2Ui9AasqTo8BpAsxCVXMp3YKmcT
         EKvXRUvCPL08F7+4bSQP8Kwz2tq8kjU0LpRxBgQ9MEqSultknlfKIAUd/enniYu0VzNH
         QxF7ZCekPzTTdC7tb+48vez8hx8vO0SZlVX96J+LSUmQB9PQj+B95T6S/xo/pkKU7Bgr
         u0YQ==
X-Gm-Message-State: AOAM532YIjo66YWCJsMFqgbHJ4w1PhOQetuLDDpBU67Z73d6/wZCl61W
        sLLnRZMxELQ4KpEI/MvO4FxCy4nYXv6m4hBR5BZMYfl7b/kh
X-Google-Smtp-Source: ABdhPJzaeeto+90vKfwCqIzrB5cp8eqdHC8gCKgD33zO40cOrw2abKT9qoVAFdgqqOolzOUWECqyCPq1B3LE/EP9Hzwa53UUwB8D
MIME-Version: 1.0
X-Received: by 2002:a6b:f714:: with SMTP id k20mr2029676iog.70.1611884286518;
 Thu, 28 Jan 2021 17:38:06 -0800 (PST)
Date:   Thu, 28 Jan 2021 17:38:06 -0800
In-Reply-To: <000000000000619ae405b9f8cf6e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000512a7f05ba000ead@google.com>
Subject: Re: WARNING in io_uring_cancel_task_requests
From:   syzbot <syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=133f3090d00000
start commit:   d03154e8 Add linux-next specific files for 20210128
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10bf3090d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=173f3090d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3d9bd0c6ce9efbc3ef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a924c4d00000

Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

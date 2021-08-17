Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C423EE84A
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhHQITz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 04:19:55 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:49812 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhHQITp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 04:19:45 -0400
Received: by mail-il1-f200.google.com with SMTP id a15-20020a92444f000000b0022473393120so3933748ilm.16
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 01:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=v7Suw8Wuf/OUCzg/q1QAF/HIhF+USLUXdeQ4IT6YwQU=;
        b=oJBXM/uc0RQVK95Ed23OXAq9/C3s7AW5yveJ0nhIfGd2dgQVbWCXsRwrQPx/7vUN5G
         7dCEYikcZH6RoHArEhg+o261c5mK4iAT50LnjIfPrUB5kmkDEfnNEi3vglA5mtd77R9f
         2dF7yLvYO7jhJf73JFjtjW1+aKc6GZQZJZO/5QOsWaE+Bp7+mDUi3gmllORleGU+fEX+
         U1hTgEHbG7v+Qqi+dyVJQtev+UWKwv+eOqGYLosYSLst1p7duTNuccw/0LGkYR4+yAc/
         GQla6AuJH2kRFelRD5aOMQSb2ygF54bugsW5aI7lyCdYseN9OM8qykromvmciUuYRTXm
         adXA==
X-Gm-Message-State: AOAM532Nnmk8dMW9hmA7vzdE1OVOe/obeHbqzWD9nfEi9p9a2DI3+4Oz
        o7XR9JtcPXzSO+ZuFc/ViVSICTusyJfoSVtqxrqUjlD+9PkB
X-Google-Smtp-Source: ABdhPJx0yFNciOMcqB4BPAMWZWuOFnOun69pnpvkeraaKxBZjdZQSIVasmHZrwPztaBxc0fYb6tcdTbqwo3MH47lhjd3oBGqHBBD
MIME-Version: 1.0
X-Received: by 2002:a92:cb4b:: with SMTP id f11mr1569466ilq.189.1629188352582;
 Tue, 17 Aug 2021 01:19:12 -0700 (PDT)
Date:   Tue, 17 Aug 2021 01:19:12 -0700
In-Reply-To: <00000000000020339705c9ad30ee@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000007299005c9bcf9e9@google.com>
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
From:   syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit 483fc4e30869f8bd1693aca9cffddb21fb303b32
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Aug 15 09:40:26 2021 +0000

    io_uring: optimise io_prep_linked_timeout()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fada7e300000
start commit:   b9011c7e671d Add linux-next specific files for 20210816
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fada7e300000
console output: https://syzkaller.appspot.com/x/log.txt?x=11fada7e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17479216300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147f0111300000

Reported-by: syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com
Fixes: 483fc4e30869 ("io_uring: optimise io_prep_linked_timeout()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

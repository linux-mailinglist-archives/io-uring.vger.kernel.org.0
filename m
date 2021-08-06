Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0F3E28A3
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbhHFKdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 06:33:23 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:51179 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbhHFKdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 06:33:23 -0400
Received: by mail-io1-f69.google.com with SMTP id e18-20020a5d92520000b029057d0eab404aso5488359iol.17
        for <io-uring@vger.kernel.org>; Fri, 06 Aug 2021 03:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1nsTUtLl/XNEj2R0gdBgbLR1WT+4nRbfq0Z5jt4tfSk=;
        b=dziLXZabY/XK21dpwzDhUb9isgxsfYvnL7lW1rgPUgBdQTGRvgqpAKzTYLpHCHGaC0
         rDx0KK2SMoaiK8i7lWVFkG8oWtOK708cQY+YdaydPpY4a11LI4AIUZVMI/pvcJYn6ydl
         XM6dgR3WpPPPyD+NJOiC+ZivTVNW3KQDnM4rb3aKyzEywSmnc/1e+aGC8gTerR0hTf5G
         PpwDqUYZyTJyvRyLV/ATFP8x+/5gDKQAuBvLR7pj4sAG7Y/MtEgKhrssvcpt3dONBPL7
         6XYFvWe6SMStxsjK91rgXzn+XoE4N1HotcEyYyjlXoPH/GzHFJD3FE90gmSsybx5AW0D
         clxg==
X-Gm-Message-State: AOAM5312u3pKH7v+K3fwmN2NrBG+Nmd8oExep+JvdAS9Umt+xyZ7QEza
        C/iA8rqORS5G0HOrZi4yeaZ84ujfmWLz4NnCMz+0CJeXbXnd
X-Google-Smtp-Source: ABdhPJxYsmwtjg8JlsWjL6y+/14LVfgv7IjtjUAPQb8R8xh9IF1nYszq6JSuUVsEu1E2ClmpoxCvxHOxzXyQUw5M/RpqskPYU/b0
MIME-Version: 1.0
X-Received: by 2002:a6b:dc10:: with SMTP id s16mr433441ioc.61.1628245987926;
 Fri, 06 Aug 2021 03:33:07 -0700 (PDT)
Date:   Fri, 06 Aug 2021 03:33:07 -0700
In-Reply-To: <83e78e3f-2645-0c84-0255-da88e1b48466@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7a5cc05c8e18f5d@google.com>
Subject: Re: [syzbot] WARNING in io_ring_exit_work
From:   syzbot <syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com

Tested on:

commit:         369fdcf5 io-wq: fix lack of acct->nr_workers < acct->m..
git tree:       git://git.kernel.dk/linux-block io_uring-5.14
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e83fda0fd4c345d
dashboard link: https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.

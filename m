Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C250A36EBBF
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 16:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhD2OAz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 10:00:55 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:41686 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbhD2OAx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 10:00:53 -0400
Received: by mail-il1-f197.google.com with SMTP id m4-20020a9287040000b0290166e96ff634so35064297ild.8
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RGZQlqYRDcws6lKbGiNkhAc8TLY6zhzM1dhv48k3sxc=;
        b=XaWvUhogM4ioT/CoqLuRGq58w09gsOUW+wDWWBhJfsMwkxWt1altAcmMrdx9Z+Da/n
         BdsMeDt/9sMfy2AR4SzICEfS/wzRqy5ANUpkBamytn3uRTL3P2+t6uNh3NtyfDi9u2+w
         RGENJaQU6Dpxuj8egaP/GSPQIeTfgG7ZFbcmMoUfRAykfNPc+BVs8IxwdvfZO1djxI3V
         7Z12W4IYuQT3kX1VgKrzCOEWvjmZcBf8Xfh0QaB1mDFlIeGlCyzlDI59nu5Cglg5tcD/
         nzuv5yHy9gp3sALSGXZlinCpZFhzGk1sz/yLhyFijAEmyePdUvn/BpMXuCdLu3dKJjKU
         gSsg==
X-Gm-Message-State: AOAM530p7l27DUexb2JtByV+s431b8Cv+ZgtGGOTT5KkeGIvrFHuMm7g
        J0dA/VA07UVaMWWi0kPSckkPV1fxtp41Sg+z6fnMqds4Nvm9
X-Google-Smtp-Source: ABdhPJzuadjvDEHr9FHFGBzYheTEwO+GMWuYnAix7ZVEK/4HZPPAE5I0GJqznk7dtb2LAXrPUSmq6sKslvhgmpGf5WVREMCYuE7p
MIME-Version: 1.0
X-Received: by 2002:a02:3406:: with SMTP id x6mr6293704jae.137.1619704804712;
 Thu, 29 Apr 2021 07:00:04 -0700 (PDT)
Date:   Thu, 29 Apr 2021 07:00:04 -0700
In-Reply-To: <000000000000b23f7805c119dee8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086cb9005c11ce9e8@google.com>
Subject: Re: [syzbot] WARNING in io_rsrc_node_switch
From:   syzbot <syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit eae071c9b4cefbcc3f985c5abf9a6e32c1608ca9
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Apr 25 13:32:24 2021 +0000

    io_uring: prepare fixed rw for dynanic buffers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14498f59d00000
start commit:   d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16498f59d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12498f59d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65c207250bba4efe
dashboard link: https://syzkaller.appspot.com/bug?extid=a4715dd4b7c866136f79
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11893de1d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161c19d5d00000

Reported-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com
Fixes: eae071c9b4ce ("io_uring: prepare fixed rw for dynanic buffers")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

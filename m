Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1536EF16
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 19:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbhD2Rq5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 13:46:57 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39551 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbhD2Rq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 13:46:57 -0400
Received: by mail-il1-f197.google.com with SMTP id v3-20020a056e0213c3b029016165a33c15so35384764ilj.6
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 10:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1DydgRsBOMclr8lyrq3i7fMITXu/lphpAdBAlh88rSU=;
        b=UppjPUhksCaJ/82+Rp4HQlrmhLL6vhOisz1KwM2L6G91nozkXJsFY3UtAhPNF9ho2a
         lslgRu850PD9Z4K/BF7o72DM4qWuAD+pl3KOF9drO4WsWi0z/obXqfrx3m9sNDJDghTi
         F7HSMJe92X1Oa5B+DdPIkn9eSTlfDT6I9lcTFWA1CGP5QZoCeKwqvtBXG8gk7844zetI
         vQW5uf38GtOldaEHJdi4ChLdRQU0vTYYbw8dlCe6MX9UXxuMTf5sl+5OSAGNFwTY0v7B
         /K/Fzqtct89NTzeTyQaRh3lCic1dBKK3czolb/rDgsrSL2Y5PuSBHkX0IfOnqR4COlay
         8FgQ==
X-Gm-Message-State: AOAM532nKpL1cOVOFougRrUcuzPX/r5BD32Upq63KyLIW+mDVrtBsF3e
        Ec5CptDTTCsDQ+tgyiDuvogRxCcvFUlVjR26bTbcjUVFsmsn
X-Google-Smtp-Source: ABdhPJydPNzW45/whprBQL+Ac/2InNOOOYTRFbWB3JVZZeInMDqejiFAQUGgkQsp40t3ND/wlLTSgl6aueY1s8TPTqQh+qmzUvLA
MIME-Version: 1.0
X-Received: by 2002:a92:3212:: with SMTP id z18mr672901ile.171.1619718370026;
 Thu, 29 Apr 2021 10:46:10 -0700 (PDT)
Date:   Thu, 29 Apr 2021 10:46:10 -0700
In-Reply-To: <000000000000ce433f05c11dc4e6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014ec7c05c12012b1@google.com>
Subject: Re: [syzbot] WARNING in io_uring_setup (2)
From:   syzbot <syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f639edd00000
start commit:   d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=100e39edd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f639edd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53fdf14defd48c56
dashboard link: https://syzkaller.appspot.com/bug?extid=1eca5b0d7ac82b74d347
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15aeff43d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1747117dd00000

Reported-by: syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com
Fixes: eae071c9b4ce ("io_uring: prepare fixed rw for dynanic buffers")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

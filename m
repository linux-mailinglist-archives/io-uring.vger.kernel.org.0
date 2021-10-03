Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1968A42007A
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 09:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhJCHf7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 03:35:59 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50870 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhJCHfz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 03:35:55 -0400
Received: by mail-io1-f70.google.com with SMTP id p71-20020a6b8d4a000000b005d323186f7cso13122002iod.17
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 00:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c7Hhg1HS9ONwmBtdl/+gEC6wT21nlHlGkIEyTDo6QXw=;
        b=bxYpOeGuR71QFw1N1q4yxxWCQAwP2RSQlYLhzR2Gds0fJyGOSkexweQPsR2d69OYRh
         3Rkruo5Qk2oXKDiEwpe47opgbB5y/l5ljgdCkYOYQCD1mkT0rhUHjNjQ0aaTQLqUnkaY
         8yxIXWsGVZaGXI2IIWmT6sOdbexzDdkbrBBWr1xGrnP6mMSPW8NUilBWApOmP+tHOix8
         neXaAxKZSRTW4zMd66o064jq4jCdRibeEtC6NEq52zkM/90oJHjgz+VjRWShA9XLCxJj
         D9roxW8M0xwxacIyC0Jakm41XYjOEqH5tuLbGGOPVODrRgYvCoQR7Jn7tOr1fpb1z3rc
         oXAA==
X-Gm-Message-State: AOAM531v3OopD7wie5r5J6N8r0fBldiGxpK9JpVWIjskHtcqs4cJm7YL
        dn2hCT38fergHugsrYrdsToWMV4nMrmYCisgGVSNJhPkS28r
X-Google-Smtp-Source: ABdhPJxqZIyLyb2GCKV1AwEY4i18NOKnl8EziN7c1CJrRf52GnzfgmaxpkDY00mNnhUSIeev2Hfg4nqSERwqf/mhBGnmraIIITRW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17ca:: with SMTP id z10mr4904868ilu.249.1633246448379;
 Sun, 03 Oct 2021 00:34:08 -0700 (PDT)
Date:   Sun, 03 Oct 2021 00:34:08 -0700
In-Reply-To: <0000000000000d4da305cb1d2467@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062ec7d05cd6dd2f6@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in kiocb_done
From:   syzbot <syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b8ce1b9d25ccf81e1bbabd45b963ed98b2222df8
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Tue Aug 31 13:13:11 2021 +0000

    io_uring: don't submit half-prepared drain request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b14b67300000
start commit:   4ac6d90867a4 Merge tag 'docs-5.15' of git://git.lwn.net/li..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c3a5498e99259cf
dashboard link: https://syzkaller.appspot.com/bug?extid=726f2ce6dbbf2ad8d133
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124a3b49300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142e610b300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: don't submit half-prepared drain request

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

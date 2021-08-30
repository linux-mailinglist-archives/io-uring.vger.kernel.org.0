Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F7B3FB4A0
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 13:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhH3LfG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 07:35:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38599 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbhH3LfG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 07:35:06 -0400
Received: by mail-io1-f71.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso8357627iom.5
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 04:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8yu2qDi/W61ruhvfPtnck6J11ryx5e7EXsUOpCFvzG4=;
        b=oI+4KfUJC2POPCdpSC1bO5+FedlZEB4Vfx+MYK68SdIf+8LMwPtC3fV6S3Qp2AOMV3
         Lis7lBmMn6ifXKz/Z0ltY4ZVPabNwF4KoA8SE4jL4Sq1NiQHCieSBqZuLtisUmO4duxO
         FvAHoeBN9quu0B6evlzx3Gqy5Rwt9iF4HzHsTJQGI0ZLrZ/s+gXfe9G/SvmdyQK7B6GQ
         HLtvKoUdmvASCPDHBPDoiISm3iWNmXeL+IBj56/meli/fyX1zX39lgh6f0m72AMaHnO1
         WChBaxXmOezWu000eg521ShXqA+s4DwWc6aFELBnCixUnJem7Hxni+XCRZMF79fmGyW5
         cvyw==
X-Gm-Message-State: AOAM5337F/ldgqAAXF3wUlPRrwFaRYY6ifHdoWU3SzLvVLFUDlTeqLb0
        5bK9bSeVg6WFhMcHpof8er6peNeVDzRiSOj93+8P5yBhJFDJ
X-Google-Smtp-Source: ABdhPJw8R8S4wtILrC6Pgi4rcp0GnFmahcRcIzqC11+AgCnvk1l/mVz8zSjhYlwRKul0FOFQlHJqw0U8ywdoT7sMIsTAZe4Odi3M
MIME-Version: 1.0
X-Received: by 2002:a6b:5911:: with SMTP id n17mr17250394iob.180.1630323252380;
 Mon, 30 Aug 2021 04:34:12 -0700 (PDT)
Date:   Mon, 30 Aug 2021 04:34:12 -0700
In-Reply-To: <00000000000022acbf05c06d9f0d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053c98205cac53625@google.com>
Subject: Re: [syzbot] WARNING in io_poll_double_wake
From:   syzbot <syzbot+f2aca089e6f77e5acd46@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a890d01e4ee016978776e45340e521b3bbbdf41f
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Wed Jul 28 03:03:22 2021 +0000

    io_uring: fix poll requests leaking second poll entries

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d8819d300000
start commit:   98f7fdced2e0 Merge tag 'irq-urgent-2021-07-11' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=139b08f9b7481d26
dashboard link: https://syzkaller.appspot.com/bug?extid=f2aca089e6f77e5acd46
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11650180300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1510c6b0300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: fix poll requests leaking second poll entries

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
